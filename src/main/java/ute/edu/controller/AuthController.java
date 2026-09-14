package ute.edu.controller;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import ute.edu.dto.RegisterRequest;
import ute.edu.enums.UserRole;
import ute.edu.entity.UserAccount;
import ute.edu.service.AuthService;
import ute.edu.service.AuthTokenService;
import ute.edu.repository.UserAccountRepository;
import ute.edu.repository.StudentRepository;
import ute.edu.repository.LectureRepository;

@Controller
/** Controller xử lý đăng nhập, đăng ký và đăng xuất tài khoản. */
public class AuthController {
    private final AuthService authService;
    private final UserAccountRepository userRepository;
    private final StudentRepository studentRepository;
    private final LectureRepository lectureRepository;
    private final AuthTokenService authTokenService;

    public AuthController(AuthService authService,
                          UserAccountRepository userRepository,
                          StudentRepository studentRepository,
                          LectureRepository lectureRepository,
                          AuthTokenService authTokenService) {
        this.authService = authService;
        this.userRepository = userRepository;
        this.studentRepository = studentRepository;
        this.lectureRepository = lectureRepository;
        this.authTokenService = authTokenService;
    }

    @GetMapping("/login")
    /** Hiển thị trang đăng nhập. */
    public String loginPage(Model model, HttpSession session) {
        if (session.getAttribute("user") != null) {
            UserAccount user = (UserAccount) session.getAttribute("user");
            return redirectToDashboard(user);
        }
        return "login";
    }

    @PostMapping("/login")
    /** Kiểm tra thông tin đăng nhập và tạo phiên người dùng. */
    public String login(@RequestParam String email,
                        @RequestParam String password,
                        HttpServletRequest request,
                        HttpServletResponse response,
                        HttpSession session,
                        Model model,
                        RedirectAttributes redirectAttributes) {
        UserAccount user = authService.loginUser(email, password);
        if (user == null) {
            model.addAttribute("error", "Email hoặc mật khẩu không chính xác!");
            return "login";
        }

        request.changeSessionId();
        setupSession(session, user);
        writeTokenCookie(response, request, authTokenService.issue(user));
        redirectAttributes.addFlashAttribute("successMessage", "Đăng nhập thành công! Chào mừng " + user.getFullName());
        return redirectToDashboard(user);
    }

    @GetMapping("/quick-login")
    /** Đăng nhập nhanh bằng tên tài khoản mẫu. */
    public String quickLogin(@RequestParam String username,
                             HttpServletRequest request,
                             HttpServletResponse response,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        UserAccount user = authService.findByUsernameOrEmail(username);
        if (user != null) {
            request.changeSessionId();
            setupSession(session, user);
            writeTokenCookie(response, request, authTokenService.issue(user));
            return redirectToDashboard(user);
        }
        return "redirect:/login";
    }

    @GetMapping("/register")
    /** Hiển thị trang đăng ký tài khoản. */
    public String registerPage(Model model) {
        model.addAttribute("roles", new UserRole[]{UserRole.STUDENT, UserRole.LECTURER});
        model.addAttribute("registerRequest", new RegisterRequest());
        return "register";
    }

    @PostMapping("/register")
    /** Kiểm tra và lưu tài khoản mới. */
    public String register(RegisterRequest request, Model model, RedirectAttributes redirectAttributes) {
        try {
            UserAccount user = new UserAccount();
            user.setUsername(request.getUsername().trim());
            user.setPassword(request.getPassword());
            user.setFullName(request.getFullName().trim());
            user.setEmail(request.getEmail().trim());
            user.setPhone(request.getPhone().trim());
            user.setRole(UserRole.valueOf(request.getRole()));

            authService.register(user);
            redirectAttributes.addFlashAttribute("successMessage", "Đăng ký tài khoản thành công! Vui lòng đăng nhập.");
            return "redirect:/login";
        } catch (Exception e) {
            model.addAttribute("error", "Đăng ký thất bại: " + e.getMessage());
            model.addAttribute("roles", new UserRole[]{UserRole.STUDENT, UserRole.LECTURER});
            return "register";
        }
    }

    @GetMapping("/logout")
    /** Hủy phiên hiện tại và chuyển về trang đăng nhập. */
    public String logout(HttpServletRequest request,
                         HttpServletResponse response,
                         HttpSession session,
                         RedirectAttributes redirectAttributes) {
        authTokenService.revoke(getToken(request));
        deleteTokenCookie(response, request);
        session.invalidate();
        redirectAttributes.addFlashAttribute("infoMessage", "Bạn đã đăng xuất khỏi hệ thống.");
        return "redirect:/login";
    }

    private String getToken(HttpServletRequest request) {
        if (request.getCookies() == null) return null;
        for (Cookie cookie : request.getCookies()) {
            if (AuthTokenService.COOKIE_NAME.equals(cookie.getName())) return cookie.getValue();
        }
        return null;
    }

    private void writeTokenCookie(HttpServletResponse response, HttpServletRequest request, String token) {
        String secure = request.isSecure() ? "; Secure" : "";
        response.addHeader("Set-Cookie", AuthTokenService.COOKIE_NAME + "=" + token
                + "; Max-Age=" + authTokenService.getTokenTtlSeconds()
                + "; Path=" + request.getContextPath() + "; HttpOnly; SameSite=Lax" + secure);
    }

    private void deleteTokenCookie(HttpServletResponse response, HttpServletRequest request) {
        response.addHeader("Set-Cookie", AuthTokenService.COOKIE_NAME
                + "=; Max-Age=0; Path=" + request.getContextPath() + "; HttpOnly; SameSite=Lax");
    }

    private void setupSession(HttpSession session, UserAccount user) {
        session.setAttribute("user", user);
        session.setAttribute("userRole", user.getRole());
        if (user.getRole() == UserRole.STUDENT) {
            session.setAttribute("studentProfile", studentRepository.findByUserId(user.getId()));
        } else if (user.getRole() == UserRole.LECTURER || user.getRole() == UserRole.DEAN || user.getRole() == UserRole.DEPARTMENT_HEAD) {
            session.setAttribute("lecturerProfile", lectureRepository.findByUserId(user.getId()));
        }
    }

    private String redirectToDashboard(UserAccount user) {
        if (user.getRole() == UserRole.ADMIN || user.getRole() == UserRole.DEAN || user.getRole() == UserRole.DEPARTMENT_HEAD) {
            return "redirect:/admin/dashboard";
        }
        if (user.getRole() == UserRole.LECTURER) {
            return "redirect:/lecturer/dashboard";
        }
        return "redirect:/student/dashboard";
    }
}

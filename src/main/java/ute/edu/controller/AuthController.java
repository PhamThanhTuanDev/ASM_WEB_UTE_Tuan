package ute.edu.controller;

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
import ute.edu.repository.UserAccountRepository;
import ute.edu.repository.StudentRepository;
import ute.edu.repository.LectureRepository;

@Controller
public class AuthController {
    private final AuthService authService;
    private final UserAccountRepository userRepository;
    private final StudentRepository studentRepository;
    private final LectureRepository lectureRepository;

    public AuthController(AuthService authService,
                          UserAccountRepository userRepository,
                          StudentRepository studentRepository,
                          LectureRepository lectureRepository) {
        this.authService = authService;
        this.userRepository = userRepository;
        this.studentRepository = studentRepository;
        this.lectureRepository = lectureRepository;
    }

    @GetMapping("/login")
    public String loginPage(Model model, HttpSession session) {
        if (session.getAttribute("user") != null) {
            UserAccount user = (UserAccount) session.getAttribute("user");
            return redirectToDashboard(user);
        }
        return "login";
    }

    @PostMapping("/login")
    public String login(@RequestParam String email,
                        @RequestParam String password,
                        HttpSession session,
                        Model model,
                        RedirectAttributes redirectAttributes) {
        UserAccount user = authService.loginUser(email, password);
        if (user == null) {
            model.addAttribute("error", "Email hoặc mật khẩu không chính xác!");
            return "login";
        }

        setupSession(session, user);
        redirectAttributes.addFlashAttribute("successMessage", "Đăng nhập thành công! Chào mừng " + user.getFullName());
        return redirectToDashboard(user);
    }

    @GetMapping("/quick-login")
    public String quickLogin(@RequestParam String username,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        UserAccount user = authService.findByUsernameOrEmail(username);
        if (user != null) {
            setupSession(session, user);
            redirectAttributes.addFlashAttribute("successMessage", "Đã chuyển đổi sang tài khoản: " + user.getFullName() + " (" + user.getRole() + ")");
            return redirectToDashboard(user);
        }
        return "redirect:/login";
    }

    @GetMapping("/register")
    public String registerPage(Model model) {
        model.addAttribute("roles", new UserRole[]{UserRole.STUDENT, UserRole.LECTURER});
        model.addAttribute("registerRequest", new RegisterRequest());
        return "register";
    }

    @PostMapping("/register")
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
    public String logout(HttpSession session, RedirectAttributes redirectAttributes) {
        session.invalidate();
        redirectAttributes.addFlashAttribute("infoMessage", "Bạn đã đăng xuất khỏi hệ thống.");
        return "redirect:/login";
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

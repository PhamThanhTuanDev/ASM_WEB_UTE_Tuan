package ute.edu.config;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import ute.edu.entity.UserAccount;
import ute.edu.enums.UserRole;
import ute.edu.repository.LectureRepository;
import ute.edu.repository.StudentRepository;
import ute.edu.repository.UserAccountRepository;
import ute.edu.service.AuthTokenService;

import java.io.IOException;

@Component
public class OAuth2LoginSuccessHandler implements AuthenticationSuccessHandler {

    private final UserAccountRepository userAccountRepository;
    private final AuthTokenService authTokenService;
    private final StudentRepository studentRepository;
    private final LectureRepository lectureRepository;
    private final ute.edu.repository.DepartmentRepository departmentRepository;

    public OAuth2LoginSuccessHandler(UserAccountRepository userAccountRepository,
            AuthTokenService authTokenService,
            StudentRepository studentRepository,
            LectureRepository lectureRepository,
            ute.edu.repository.DepartmentRepository departmentRepository) {
        this.userAccountRepository = userAccountRepository;
        this.authTokenService = authTokenService;
        this.studentRepository = studentRepository;
        this.lectureRepository = lectureRepository;
        this.departmentRepository = departmentRepository;
    }

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
            Authentication authentication) throws IOException, ServletException {
        OAuth2User oauthUser = (OAuth2User) authentication.getPrincipal();
        String email = oauthUser.getAttribute("email");
        String name = oauthUser.getAttribute("name");

        if (email == null || !(email.endsWith("@hcmute.edu.vn") || email.endsWith("@student.hcmute.edu.vn")
                || email.endsWith("@teacher.hcmute.edu.vn"))) {
            response.sendRedirect(request.getContextPath() + "/login?error=invalid_domain");
            return;
        }

        UserAccount user = userAccountRepository.findByEmail(email);
        if (user == null) {
            String studentCode = email.split("@")[0];
            ute.edu.entity.Student existingStudent = studentRepository.findByStudentCode(studentCode).orElse(null);

            // Auto create account if not exists
            user = new UserAccount();
            user.setEmail(email);
            user.setUsername(studentCode);
            user.setFullName(name != null ? name : studentCode);
            user.setRole(UserRole.STUDENT); // Default role
            user.setEnabled(true);
            user.setPassword(new BCryptPasswordEncoder().encode("123456")); // Mật khẩu mặc định là 123456 đã được mã hoá
            user.setPhone(""); // Tránh lỗi not-null property cho trường phone
            userAccountRepository.save(user);

            if (existingStudent != null) {
                existingStudent.setUser(user);
                studentRepository.save(existingStudent);
            } else {
                // Auto create student profile to prevent redirect loop in StudentController
                ute.edu.entity.Student studentProfile = new ute.edu.entity.Student();
                studentProfile.setUser(user);
                studentProfile.setStudentCode(studentCode);
                studentProfile.setClassName("Chưa cập nhật");
                studentProfile.setMajor("Chưa cập nhật");

                // Assign a default department to avoid not-null constraint
                java.util.List<ute.edu.entity.Department> depts = departmentRepository.findAll();
                if (!depts.isEmpty()) {
                    studentProfile.setDepartment(depts.get(0));
                }

                studentRepository.save(studentProfile);
            }
        } else if (!user.isEnabled()) {
            response.sendRedirect(request.getContextPath() + "/login?error=account_disabled");
            return;
        }

        HttpSession session = request.getSession(true);
        request.changeSessionId();

        // Setup session
        session.setAttribute("user", user);
        session.setAttribute("userRole", user.getRole());
        if (user.getRole() == UserRole.STUDENT) {
            session.setAttribute("studentProfile", studentRepository.findByUserId(user.getId()));
        } else if (user.getRole() == UserRole.LECTURER || user.getRole() == UserRole.DEAN
                || user.getRole() == UserRole.DEPARTMENT_HEAD) {
            session.setAttribute("lecturerProfile", lectureRepository.findByUserId(user.getId()));
        }

        // Set token cookie
        String token = authTokenService.issue(user);
        String secure = request.isSecure() ? "; Secure" : "";
        String contextPath = request.getContextPath();
        String path = (contextPath == null || contextPath.isEmpty()) ? "/" : contextPath;
        response.addHeader("Set-Cookie", AuthTokenService.COOKIE_NAME + "=" + token
                + "; Max-Age=" + authTokenService.getTokenTtlSeconds()
                + "; Path=" + path + "; HttpOnly; SameSite=Lax" + secure);

        // Redirect based on role
        if (user.getRole() == UserRole.ADMIN || user.getRole() == UserRole.DEAN
                || user.getRole() == UserRole.DEPARTMENT_HEAD) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else if (user.getRole() == UserRole.LECTURER) {
            response.sendRedirect(request.getContextPath() + "/lecturer/dashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/student/dashboard");
        }
    }
}

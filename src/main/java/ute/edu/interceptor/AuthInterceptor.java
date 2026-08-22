package ute.edu.interceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import ute.edu.entity.UserAccount;
import ute.edu.enums.UserRole;

@Component
public class AuthInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
        String contextPath = request.getContextPath() == null ? "" : request.getContextPath();
        String uri = request.getRequestURI();
        if (uri.startsWith(contextPath)) {
            uri = uri.substring(contextPath.length());
        }
        if (uri.isEmpty()) {
            uri = "/";
        }

        // Public assets & report files
        if (uri.startsWith("/assets/")
                || uri.startsWith("/static/")
                || uri.startsWith("/reports/")
                || uri.startsWith("/uploads/")) {
            return true;
        }

        HttpSession session = request.getSession();
        UserAccount user = (UserAccount) session.getAttribute("user");

        if (user == null) {
            if (uri.startsWith("/admin") || uri.startsWith("/lecturer") || uri.startsWith("/student")) {
                response.sendRedirect(contextPath + "/login");
                return false;
            }
            return true;
        }

        if (uri.startsWith("/admin")) {
            if (user.getRole() != UserRole.ADMIN
                    && user.getRole() != UserRole.DEAN
                    && user.getRole() != UserRole.DEPARTMENT_HEAD) {
                response.sendRedirect(contextPath + getHomeForRole(user.getRole()));
                return false;
            }
        } else if (uri.startsWith("/lecturer")) {
            if (user.getRole() != UserRole.LECTURER
                    && user.getRole() != UserRole.ADMIN
                    && user.getRole() != UserRole.DEAN) {
                response.sendRedirect(contextPath + getHomeForRole(user.getRole()));
                return false;
            }
        } else if (uri.startsWith("/student")) {
            if (user.getRole() != UserRole.STUDENT && user.getRole() != UserRole.ADMIN) {
                response.sendRedirect(contextPath + getHomeForRole(user.getRole()));
                return false;
            }
        }

        return true;
    }

    private String getHomeForRole(UserRole role) {
        if (role == UserRole.ADMIN || role == UserRole.DEAN || role == UserRole.DEPARTMENT_HEAD) {
            return "/admin/dashboard";
        }
        if (role == UserRole.LECTURER) {
            return "/lecturer/dashboard";
        }
        return "/student/dashboard";
    }
}

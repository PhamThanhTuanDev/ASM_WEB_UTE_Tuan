package ute.edu.service;

import org.springframework.stereotype.Service;

import jakarta.servlet.http.HttpSession;

/** Service đọc, ghi và xóa dữ liệu trong phiên HTTP. */
@Service
public class SessionService {
    private final HttpSession session;

    public SessionService(HttpSession session) {
        this.session = session;
    }

    /**
     * Lấy thuộc tính trong session hoặc trả về giá trị mặc định.
     *
     * @param name         Tên attribute
     * @param defaultValue Giá trị trả về nếu attribute không tồn tại
     */
    public String get(String name, String defaultValue) {
        String param = (String) session.getAttribute(name);
        return param != null ? param : defaultValue;
    }

    /**
     * Thay đổi hoặc tạo mới attribute trong session.
     *
     * @param name  Tên attribute
     * @param value Giá trị attribute
     */
    public void set(String name, Object value) {
        session.setAttribute(name, value);
    }

    /**
     * Xóa attribute khỏi session.
     *
     * @param name Tên attribute cần xóa
     */
    public void remove(String name) {
        session.removeAttribute(name);
    }
}
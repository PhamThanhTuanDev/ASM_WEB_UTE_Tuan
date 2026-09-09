package ute.edu.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ute.edu.entity.UserAccount;

/** Truy vấn bảng users (tài khoản người dùng). */
public interface UserAccountRepository extends JpaRepository<UserAccount, Long> {
    /** Tìm tài khoản theo tên đăng nhập. */
    UserAccount findByUsername(String username);
    /** Tìm tài khoản theo email. */
    UserAccount findByEmail(String email);
    /** Tìm tài khoản theo email không phân biệt hoa thường. */
    UserAccount findByEmailIgnoreCase(String email);
}

package ute.edu.service;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import ute.edu.entity.UserAccount;
import ute.edu.repository.UserAccountRepository;

@Service
/** Service đăng ký tài khoản và xác thực người dùng. */
public class AuthService {
    private final UserAccountRepository userAccountRepository;
    private final BCryptPasswordEncoder passwordEncoder;

    public AuthService(UserAccountRepository userAccountRepository, BCryptPasswordEncoder passwordEncoder) {
        this.userAccountRepository = userAccountRepository;
        this.passwordEncoder = passwordEncoder;
    }

    /** Mã hóa mật khẩu và lưu tài khoản mới. */
    public UserAccount register(UserAccount user) {
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        return userAccountRepository.save(user);
    }

    /** Kiểm tra tên đăng nhập/email và mật khẩu, trả về người dùng hợp lệ. */
    public UserAccount loginUser(String identifier, String rawPassword) {
        if (identifier == null || rawPassword == null) return null;
        String cleanIdentifier = identifier.trim();
        String cleanPassword = rawPassword.trim();
        if (cleanIdentifier.isEmpty() || cleanPassword.isEmpty()) return null;

        // 1. Check by email or username (case-insensitive email)
        UserAccount user = userAccountRepository.findByEmail(cleanIdentifier);
        if (user == null) {
            user = userAccountRepository.findByUsername(cleanIdentifier);
        }
        if (user == null && cleanIdentifier.contains("@")) {
            user = userAccountRepository.findByEmailIgnoreCase(cleanIdentifier);
        }

        if (user == null || !user.isEnabled()) {
            return null;
        }

        String dbPass = user.getPassword();
        if (dbPass == null) return null;

        try {
            if (passwordEncoder.matches(cleanPassword, dbPass)) {
                return user;
            }
        } catch (Exception ignored) {
        }
        return null;
    }

    /** Trả về true nếu thông tin đăng nhập hợp lệ. */
    public boolean login(String identifier, String rawPassword) {
        return loginUser(identifier, rawPassword) != null;
    }

    /** Tìm tài khoản bằng email hoặc tên đăng nhập. */
    public UserAccount findByUsernameOrEmail(String identifier) {
        if (identifier == null) return null;
        String clean = identifier.trim();
        UserAccount u = userAccountRepository.findByEmail(clean);
        if (u == null) {
            u = userAccountRepository.findByUsername(clean);
        }
        return u;
    }

    /** Tìm tài khoản bằng tên đăng nhập. */
    public UserAccount findByUsername(String username) {
        return userAccountRepository.findByUsername(username);
    }
}

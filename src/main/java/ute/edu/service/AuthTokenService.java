package ute.edu.service;

import java.security.SecureRandom;
import java.time.Duration;
import java.time.Instant;
import java.util.Base64;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import ute.edu.entity.UserAccount;

@Service
/** Service tạo, xác thực và thu hồi token đăng nhập. */
public class AuthTokenService {
    public static final String COOKIE_NAME = "AUTH_TOKEN";

    private final SecureRandom secureRandom = new SecureRandom();
    private final Map<String, TokenSession> sessions = new ConcurrentHashMap<>();
    private final Duration tokenTtl;

    public AuthTokenService(@Value("${app.auth.token-ttl-hours:8}") long tokenTtlHours) {
        this.tokenTtl = Duration.ofHours(Math.max(1, tokenTtlHours));
    }

    /** Tạo token ngẫu nhiên và lưu phiên đăng nhập có thời hạn. */
    public String issue(UserAccount user) {
        byte[] bytes = new byte[32];
        secureRandom.nextBytes(bytes);
        String token = Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
        sessions.put(token, new TokenSession(user, Instant.now().plus(tokenTtl)));
        return token;
    }

    /** Kiểm tra token còn hạn và trả về tài khoản tương ứng. */
    public UserAccount authenticate(String token) {
        if (token == null || token.isBlank())
            return null;
        TokenSession tokenSession = sessions.get(token);
        if (tokenSession == null)
            return null;
        if (tokenSession.expiresAt().isBefore(Instant.now())) {
            sessions.remove(token);
            return null;
        }
        UserAccount user = tokenSession.user();
        return user.isEnabled() ? user : null;
    }

    /** Hủy token để kết thúc phiên đăng nhập. */
    public void revoke(String token) {
        if (token != null)
            sessions.remove(token);
    }

    /** Trả về thời gian sống của token theo giây. */
    public long getTokenTtlSeconds() {
        return tokenTtl.toSeconds();
    }

    private record TokenSession(UserAccount user, Instant expiresAt) {
    }
}
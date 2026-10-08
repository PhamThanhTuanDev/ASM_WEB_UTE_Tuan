package ute.edu.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

/**
 * Cấu hình ứng dụng chính.
 *
 * <ul>
 * <li>{@code @EnableScheduling}: Kích hoạt tác vụ định kỳ cho
 * {@code MailerServiceImp}.</li>
 * <li>{@code passwordEncoder}: Cung cấp BCrypt bean cho {@code AuthService} và
 * {@code DataInitializer}.</li>
 * </ul>
 */
@Configuration
@EnableScheduling
public class AppConfig {

    /**
     * Bộ mã hóa mật khẩu BCrypt.
     * BCrypt tích hợp salt ngẫu nhiên, chống Rainbow Table tốt hơn MD5/SHA.
     *
     * @return Bean {@link BCryptPasswordEncoder}
     */
    @Bean
    public BCryptPasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}

package ute.edu.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.core.annotation.Order;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.init.ResourceDatabasePopulator;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Component;

import javax.sql.DataSource;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * Mỗi lần khởi động app (nếu bật), tự import database/asm_web_ute_data.sql
 * (DROP + CREATE + dữ liệu demo).
 */
@Component
@Order(1)
public class DataInitializer implements ApplicationRunner {
    private static final Logger log = LoggerFactory.getLogger(DataInitializer.class);
    private static final String SEED_FILE = "database/asm_web_ute_data.sql";

    private final DataSource dataSource;
    private final JdbcTemplate jdbcTemplate;
    private final BCryptPasswordEncoder passwordEncoder;

    @Value("${app.seed.enabled:true}")
    private boolean seedEnabled;

    /** true = mỗi lần chạy app đều import lại file SQL (ghi đè DB). */
    @Value("${app.seed.every-run:true}")
    private boolean seedEveryRun;

    public DataInitializer(DataSource dataSource,
                           JdbcTemplate jdbcTemplate,
                           BCryptPasswordEncoder passwordEncoder) {
        this.dataSource = dataSource;
        this.jdbcTemplate = jdbcTemplate;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public void run(ApplicationArguments args) {
        if (!seedEnabled) {
            log.info("DB seed disabled (app.seed.enabled=false).");
            ensureSchema();
            return;
        }

        if (!seedEveryRun && countSafe("users") > 0) {
            log.info("DB already has data — skip seed (set app.seed.every-run=true to always re-import).");
            ensureSchema();
            migratePlaintextPasswords();
            return;
        }

        Resource seed = resolveSeedScript();
        if (seed == null || !seed.exists()) {
            log.error("Không tìm thấy {}. Chạy app từ thư mục gốc project.", SEED_FILE);
            return;
        }

        log.warn("Importing {} (UTF-8) — existing tables will be dropped/recreated...", SEED_FILE);
        try {
            ResourceDatabasePopulator populator = new ResourceDatabasePopulator();
            populator.setSqlScriptEncoding("UTF-8");
            populator.addScript(seed);
            populator.setContinueOnError(false);
            // setSeparator(";") bỏ vì ";" là giá trị mặc định của ResourceDatabasePopulator
            populator.execute(dataSource);
            ensureSchema();
            log.info("Import OK. Demo password: 123456 — e.g. admin@hcmute.edu.vn");
        } catch (Exception e) {
            log.error("Import failed: {}", e.getMessage(), e);
        }
    }

    /**
     * Tìm file SQL seed theo CWD của process.
     * Chỉ cần 1 candidate vì Paths.get(relative) và Paths.get("").toAbsolutePath()
     * đều resolve về cùng thư mục làm việc (user.dir).
     */
    private Resource resolveSeedScript() {
        Path candidate = Paths.get(SEED_FILE).toAbsolutePath().normalize();
        if (Files.isRegularFile(candidate)) {
            log.info("Seed file: {}", candidate);
            return new FileSystemResource(candidate.toFile());
        }
        return null;
    }

    /**
     * Đếm số dòng trong bảng, trả về 0 nếu bảng chưa tồn tại.
     * Dùng backtick để tránh xung đột với reserved keywords của MySQL.
     */
    private long countSafe(String table) {
        try {
            Long count = jdbcTemplate.queryForObject(
                    "SELECT COUNT(*) FROM `" + table + "`", Long.class);
            return count != null ? count : 0;
        } catch (Exception e) {
            return 0;
        }
    }

    /**
     * Đảm bảo schema DB có đủ các cột cần thiết.
     * Dùng try-catch riêng từng lệnh ALTER vì MySQL sẽ ném lỗi nếu cột đã tồn tại —
     * đây là cách idempotent (chạy nhiều lần vẫn an toàn) thay vì kiểm tra trước.
     */
    private void ensureSchema() {
        // topics: đảm bảo timestamp có precision 6 (microsecond) cho JPA
        tryAlter("ALTER TABLE topics MODIFY created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)",
                "topics.created_at", true);
        tryAlter("ALTER TABLE topics MODIFY updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6)",
                "topics.updated_at", true);

        // reports: thêm các cột mới nếu chưa có
        tryAlter("ALTER TABLE reports ADD COLUMN approved BOOLEAN NOT NULL DEFAULT FALSE",
                "reports.approved", false);
        tryAlter("ALTER TABLE reports ADD COLUMN approved_at DATETIME NULL",
                "reports.approved_at", false);
        tryAlter("ALTER TABLE reports ADD COLUMN review_status VARCHAR(20) NOT NULL DEFAULT 'PENDING'",
                "reports.review_status", false);
    }

    /**
     * Thực thi một lệnh ALTER TABLE, bỏ qua lỗi nếu cột/thay đổi đã tồn tại.
     *
     * @param sql      Câu lệnh ALTER cần thực thi
     * @param context  Tên cột/bảng để ghi log (dễ debug)
     * @param isWarn   true = log ở mức WARN (quan trọng), false = log ở mức DEBUG
     */
    private void tryAlter(String sql, String context, boolean isWarn) {
        try {
            jdbcTemplate.execute(sql);
        } catch (Exception e) {
            if (isWarn) {
                log.warn("ensureSchema {}: {}", context, e.getMessage());
            } else {
                log.debug("ensureSchema {}: {}", context, e.getMessage());
            }
        }
    }

    /**
     * Mã hóa BCrypt cho các tài khoản còn lưu mật khẩu dạng plain text.
     * Nhận diện BCrypt bằng prefix chuẩn ($2a$, $2b$, $2y$) thay vì giải mã —
     * vì BCrypt là one-way hash, không thể biết giá trị gốc theo cách khác.
     */
    private void migratePlaintextPasswords() {
        try {
            jdbcTemplate.query("SELECT id, password FROM users", rs -> {
                String password = rs.getString("password");
                if (password != null && !isBCryptHashed(password)) {
                    jdbcTemplate.update("UPDATE users SET password = ? WHERE id = ?",
                            passwordEncoder.encode(password), rs.getLong("id"));
                }
            });
        } catch (Exception e) {
            log.warn("password migration skipped: {}", e.getMessage());
        }
    }

    /**
     * Kiểm tra một chuỗi có phải là BCrypt hash hay không.
     * BCrypt hash luôn bắt đầu bằng $2a$, $2b$ hoặc $2y$.
     */
    private boolean isBCryptHashed(String value) {
        return value.startsWith("$2a$") || value.startsWith("$2b$") || value.startsWith("$2y$");
    }
}
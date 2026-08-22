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

    @Value("${app.seed.enabled:true}")
    private boolean seedEnabled;

    /** true = mỗi lần chạy app đều import lại file SQL (ghi đè DB). */
    @Value("${app.seed.every-run:true}")
    private boolean seedEveryRun;

    public DataInitializer(DataSource dataSource, JdbcTemplate jdbcTemplate) {
        this.dataSource = dataSource;
        this.jdbcTemplate = jdbcTemplate;
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
            populator.setSeparator(";");
            populator.execute(dataSource);
            ensureSchema();
            log.info("Import OK. Demo password: 123456 — e.g. admin@hcmute.edu.vn");
        } catch (Exception e) {
            log.error("Import failed: {}", e.getMessage(), e);
        }
    }

    private Resource resolveSeedScript() {
        Path[] candidates = {
                Paths.get(SEED_FILE),
                Paths.get(System.getProperty("user.dir", ".")).resolve(SEED_FILE),
                Paths.get("").toAbsolutePath().resolve(SEED_FILE)
        };
        for (Path p : candidates) {
            if (Files.isRegularFile(p)) {
                log.info("Seed file: {}", p.toAbsolutePath().normalize());
                return new FileSystemResource(p.toFile());
            }
        }
        return null;
    }

    private long countSafe(String table) {
        try {
            Long c = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM `" + table + "`", Long.class);
            return c != null ? c : 0;
        } catch (Exception e) {
            return 0;
        }
    }

    private void ensureSchema() {
        try {
            jdbcTemplate.execute(
                    "ALTER TABLE topics MODIFY created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)");
            jdbcTemplate.execute(
                    "ALTER TABLE topics MODIFY updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6)");
        } catch (Exception e) {
            log.warn("ensureSchema topics: {}", e.getMessage());
        }
    }
}

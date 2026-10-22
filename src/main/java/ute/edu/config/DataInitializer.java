package ute.edu.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.context.annotation.DependsOn;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.init.ResourceDatabasePopulator;
import org.springframework.stereotype.Component;

import javax.sql.DataSource;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashSet;
import java.util.Set;
import java.util.regex.Pattern;

/**
 * Khởi tạo dữ liệu mẫu khi database trống; bổ sung bảng thiếu khi đã có dữ liệu.
 * Chỉ import đè dữ liệu khi bật rõ app.seed.every-run=true.
 */
@Component
@DependsOn("entityManagerFactory")
// Railway chạy với LAZY_INIT=true: không có bean nào gọi tới lớp này nên phải tắt lazy,
// nếu không phần nâng cấp CSDL (loại đợt, cột giờ báo cáo) sẽ không bao giờ chạy.
@org.springframework.context.annotation.Lazy(false)
public class DataInitializer implements InitializingBean {
    private static final Logger log = LoggerFactory.getLogger(DataInitializer.class);
    private static final String SEED_FILE = "database/asm_web_ute_data.sql";

    private final DataSource dataSource;
    private final JdbcTemplate jdbcTemplate;

    @Value("${app.seed.enabled:true}")
    private boolean seedEnabled;

    /** true = mỗi lần chạy app đều import lại file SQL (ghi đè DB). */
    @Value("${app.seed.every-run:false}")
    private boolean seedEveryRun;

    public DataInitializer(DataSource dataSource,
                           JdbcTemplate jdbcTemplate) {
        this.dataSource = dataSource;
        this.jdbcTemplate = jdbcTemplate;
    }

    @Override
    public void afterPropertiesSet() {
        // Existing databases must also allow a group to be created before choosing a period.
        var periodColumn = jdbcTemplate.queryForList(
                "SELECT IS_NULLABLE FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() "
                        + "AND TABLE_NAME = 'student_groups' AND COLUMN_NAME = 'reg_period_id'", String.class);
        if (periodColumn.stream().anyMatch("NO"::equalsIgnoreCase)) {
            jdbcTemplate.execute("ALTER TABLE student_groups MODIFY COLUMN reg_period_id BIGINT NULL");
        }
        Resource seed = resolveSeedScript();
        if (seed == null || !seed.exists()) {
            throw new IllegalStateException("Không tìm thấy tệp dữ liệu mẫu " + SEED_FILE + " trong dự án hoặc gói ứng dụng.");
        }

        try {
            String sql = seed.getContentAsString(StandardCharsets.UTF_8);
            if (sql.startsWith("\uFEFF")) {
                sql = sql.substring(1);
            }
            // Bỏ lệnh tạo/chọn database: luôn nạp vào database đang kết nối
            // (trên hosting cPanel tên database khác asm_web_ute và không có quyền CREATE DATABASE).
            sql = sql.replaceAll("(?im)^\\s*(CREATE\\s+DATABASE|USE)\\s[^;]*;", "");
            Set<String> existing = new HashSet<>(jdbcTemplate.queryForList(
                    "SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_SCHEMA = DATABASE() AND TABLE_TYPE = 'BASE TABLE'",
                    String.class));
            var definitions = Pattern.compile("CREATE TABLE (\\w+)\\s*\\(.*?\\) ENGINE=InnoDB[^;]*;", Pattern.DOTALL)
                    .matcher(sql);
            StringBuilder missingSchema = new StringBuilder();
            boolean hasData = false;
            while (definitions.find()) {
                String table = definitions.group(1);
                if (!existing.contains(table)) {
                    missingSchema.append(definitions.group().replaceFirst("CREATE TABLE ", "CREATE TABLE IF NOT EXISTS ")).append('\n');
                } else {
                    Integer populated = jdbcTemplate.queryForObject(
                            "SELECT EXISTS (SELECT 1 FROM `" + table + "` LIMIT 1)", Integer.class);
                    hasData |= populated != null && populated == 1;
                }
            }
            if (!seedEnabled || (!seedEveryRun && hasData)) {
                if (!missingSchema.isEmpty()) {
                    ResourceDatabasePopulator schema = new ResourceDatabasePopulator();
                    schema.setSqlScriptEncoding("UTF-8");
                    schema.addScript(new ByteArrayResource(missingSchema.toString().getBytes(StandardCharsets.UTF_8)));
                    schema.execute(dataSource);
                    log.warn("Created missing project tables. Existing data preserved; no demo rows were imported.");
                }
                migrateRegistrationTypes();
                migrateCouncilReportTimes();
                return;
            }
            log.warn("Importing demo SQL into empty database (or explicit app.seed.every-run=true).");
            ResourceDatabasePopulator populator = new ResourceDatabasePopulator();
            populator.setSqlScriptEncoding("UTF-8");
            populator.addScript(new ByteArrayResource(sql.getBytes(StandardCharsets.UTF_8), SEED_FILE));
            populator.setContinueOnError(false);
            // setSeparator(";") bỏ vì ";" là giá trị mặc định của ResourceDatabasePopulator
            populator.execute(dataSource);
            migrateRegistrationTypes();
            migrateCouncilReportTimes();
            log.info("Import OK. Demo passwords: admin123 (admin/dean/department head), 123456 (lecturer/student).");
        } catch (Exception e) {
            throw new IllegalStateException("Khởi tạo database thất bại. Kiểm tra " + SEED_FILE + ": " + e.getMessage(), e);
        }
    }

    /** Chuyển mã loại cũ mà không import lại dữ liệu hoặc thay đổi lịch sử các đợt. */
    private void migrateRegistrationTypes() {
        var constraints = jdbcTemplate.queryForList("SELECT cc.CONSTRAINT_NAME, cc.CHECK_CLAUSE "
                + "FROM information_schema.CHECK_CONSTRAINTS cc JOIN information_schema.TABLE_CONSTRAINTS tc "
                + "ON tc.CONSTRAINT_SCHEMA=cc.CONSTRAINT_SCHEMA AND tc.CONSTRAINT_NAME=cc.CONSTRAINT_NAME "
                + "WHERE tc.TABLE_SCHEMA=DATABASE() AND tc.TABLE_NAME='registration_periods'");
        boolean hasCanonicalConstraint = false;
        for (var constraint : constraints) {
            String clause = constraint.get("CHECK_CLAUSE").toString();
            if (!Pattern.compile("(?i)\\btype\\b").matcher(clause).find()) continue;
            if (clause.contains("KLTN") && clause.contains("TLCN") && !clause.contains("THESIS")
                    && !clause.contains("PROJECT") && !clause.contains("COURSE")) {
                hasCanonicalConstraint = true;
            } else {
                String name = constraint.get("CONSTRAINT_NAME").toString().replace("`", "``");
                // DROP CONSTRAINT chạy được cả trên MySQL 8 và MariaDB (MariaDB không hiểu DROP CHECK).
                jdbcTemplate.execute("ALTER TABLE registration_periods DROP CONSTRAINT `" + name + "`");
            }
        }
        jdbcTemplate.update("UPDATE registration_periods SET type=CASE "
                + "WHEN type IN ('THESIS','GRADUATION_PROJECT') THEN 'KLTN' "
                + "WHEN type IN ('PROJECT','COURSE','SUBJECT') THEN 'TLCN' "
                + "WHEN type='RESEARCH' THEN 'NCKH' ELSE type END "
                + "WHERE type IN ('THESIS','GRADUATION_PROJECT','PROJECT','COURSE','SUBJECT','RESEARCH')");
        if (!hasCanonicalConstraint) {
            jdbcTemplate.execute("ALTER TABLE registration_periods ADD CONSTRAINT ck_periods_type "
                    + "CHECK (type IN ('KLTN','TLCN','NCKH'))");
        }
    }

    private void migrateCouncilReportTimes() {
        var columns = jdbcTemplate.queryForList("SELECT COLUMN_NAME FROM information_schema.COLUMNS "
                + "WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='topic_assignments'", String.class);
        if (!columns.contains("start_time")) {
            jdbcTemplate.execute("ALTER TABLE topic_assignments ADD COLUMN start_time TIME NULL");
        }
        if (!columns.contains("end_time")) {
            jdbcTemplate.execute("ALTER TABLE topic_assignments ADD COLUMN end_time TIME NULL");
        }
        Integer indexCount = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM information_schema.STATISTICS "
                + "WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='topic_assignments' "
                + "AND INDEX_NAME='idx_assignments_council_time'", Integer.class);
        if (indexCount != null && indexCount == 0) {
            jdbcTemplate.execute("ALTER TABLE topic_assignments ADD INDEX idx_assignments_council_time "
                    + "(council_id,start_time,end_time)");
        }
    }

    /**
     * Ưu tiên tệp SQL trong dự án; khi chạy WAR đã đóng gói thì dùng bản trên classpath.
     */
    private Resource resolveSeedScript() {
        Path candidate = Paths.get(SEED_FILE).toAbsolutePath().normalize();
        if (Files.isRegularFile(candidate)) {
            log.info("Seed file: {}", candidate);
            return new FileSystemResource(candidate.toFile());
        }
        return new ClassPathResource(SEED_FILE);
    }

}

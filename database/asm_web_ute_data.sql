-- =============================================================================
-- CSDL QUẢN LÝ ĐỀ TÀI SINH VIÊN KHOA CÔNG NGHỆ THÔNG TIN - HCMUTE
-- Database: asm_web_ute
-- Character set: utf8mb4_unicode_ci
-- =============================================================================

CREATE DATABASE IF NOT EXISTS `asm_web_ute` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `asm_web_ute`;

-- Tắt kiểm tra khóa ngoại tạm thời để khởi tạo lại bảng
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS `announcement_reads`;
DROP TABLE IF EXISTS `notifications`;
DROP TABLE IF EXISTS `announcements`;
DROP TABLE IF EXISTS `scores`;
DROP TABLE IF EXISTS `topic_assignments`;
DROP TABLE IF EXISTS `council_members`;
DROP TABLE IF EXISTS `councils`;
DROP TABLE IF EXISTS `reports`;
DROP TABLE IF EXISTS `topic_registrations`;
DROP TABLE IF EXISTS `group_members`;
DROP TABLE IF EXISTS `student_groups`;
DROP TABLE IF EXISTS `topic_supervisors`;
DROP TABLE IF EXISTS `topics`;
DROP TABLE IF EXISTS `registration_periods`;
DROP TABLE IF EXISTS `students`;
DROP TABLE IF EXISTS `lecturers`;
DROP TABLE IF EXISTS `users`;
DROP TABLE IF EXISTS `departments`;
DROP TABLE IF EXISTS `roles`;

SET FOREIGN_KEY_CHECKS = 1;

-- -----------------------------------------------------------------------------
-- 1. BẢNG ROLES (Vai trò quyền hạn)
-- -----------------------------------------------------------------------------
CREATE TABLE `roles` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `code` VARCHAR(50) NOT NULL UNIQUE,
    `name` VARCHAR(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `roles` (`id`, `code`, `name`) VALUES
(1, 'ADMIN', 'Quản trị viên hệ thống'),
(2, 'DEAN', 'Trưởng khoa CNTT'),
(3, 'LECTURER', 'Giảng viên hướng dẫn / Phản biện'),
(4, 'STUDENT', 'Sinh viên thực hiện đề tài');

-- -----------------------------------------------------------------------------
-- 2. BẢNG DEPARTMENTS (Các khoa)
-- -----------------------------------------------------------------------------
CREATE TABLE `departments` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `code` VARCHAR(50) NOT NULL UNIQUE,
    `name` VARCHAR(255) NOT NULL,
    `description` TEXT,
    `active` BIT(1) DEFAULT b'1',
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `departments` (`id`, `code`, `name`, `description`) VALUES
(1, 'CNTT', 'Khoa Công nghệ thông tin', 'Đào tạo và nghiên cứu công nghệ phần mềm, khoa học máy tính, hệ thống thông tin và an toàn thông tin.'),
(2, 'LCT', 'Khoa Luật và Chính trị', 'Đào tạo và nghiên cứu pháp luật, lý luận chính trị và các lĩnh vực liên quan.'),
(3, 'XD', 'Khoa Xây dựng', 'Đào tạo và nghiên cứu kỹ thuật xây dựng, công trình và quản lý xây dựng.'),
(4, 'ĐĐT', 'Khoa Điện - Điện tử', 'Đào tạo và nghiên cứu kỹ thuật điện, điện tử, điều khiển và tự động hóa.'),
(5, 'CK', 'Khoa Cơ khí', 'Đào tạo và nghiên cứu cơ khí, chế tạo máy và cơ điện tử.'),
(6, 'KT', 'Khoa Kinh tế', 'Đào tạo và nghiên cứu kinh tế, quản trị và thương mại.');

-- -----------------------------------------------------------------------------
-- 3. BẢNG USERS (Tài khoản người dùng)
-- Mật khẩu demo: admin123 cho admin/dean, 123456 cho giảng viên/sinh viên (BCrypt)
-- -----------------------------------------------------------------------------
CREATE TABLE `users` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `username` VARCHAR(100) NOT NULL UNIQUE,
    `password` VARCHAR(255) NOT NULL,
    `role_id` BIGINT NULL,
    `full_name` VARCHAR(255) NOT NULL,
    `email` VARCHAR(150) NOT NULL UNIQUE,
    `phone` VARCHAR(30) NOT NULL,
    `role` VARCHAR(50) NOT NULL,
    `enabled` BIT(1) NOT NULL DEFAULT b'1',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `fk_users_roles` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Hash BCrypt được tạo từ mật khẩu demo ở trên.
INSERT INTO `users` (`id`, `username`, `password`, `role_id`, `full_name`, `email`, `phone`, `role`, `enabled`) VALUES
(1, 'admin', '$2a$10$EfVgSFSVuJnJl9YUl/gYg.mIR7iN//rAKamRehTDo2ypoFEAgpP12', 1, 'Quản Trị Viên (Admin)', 'admin@hcmute.edu.vn', '0901111000', 'ADMIN', b'1'),
(2, 'dean', '$2a$10$EfVgSFSVuJnJl9YUl/gYg.mIR7iN//rAKamRehTDo2ypoFEAgpP12', 2, 'PGS.TS. Trần Minh Tuấn (Trưởng khoa)', 'dean.fit@hcmute.edu.vn', '0901234567', 'DEAN', b'1'),
(3, 'lecturer01', '$2a$10$L4wyNr3EuOK.MpAkzglrTOir1F8NDmrkdw.yQwgdJAOjYz0pk46su', 3, 'TS. Nguyễn Văn An', '25810176@teacher.hcmute.edu.vn', '0902222001', 'LECTURER', b'1'),
(4, 'lecturer02', '$2a$10$L4wyNr3EuOK.MpAkzglrTOir1F8NDmrkdw.yQwgdJAOjYz0pk46su', 3, 'ThS. Trần Thị Bích', '25810177@teacher.hcmute.edu.vn', '0902222002', 'LECTURER', b'1'),
(5, 'lecturer03', '$2a$10$L4wyNr3EuOK.MpAkzglrTOir1F8NDmrkdw.yQwgdJAOjYz0pk46su', 3, 'PGS.TS. Lê Hoàng Cường', '25810178@teacher.hcmute.edu.vn', '0902222003', 'LECTURER', b'1'),
(6, 'lecturer04', '$2a$10$L4wyNr3EuOK.MpAkzglrTOir1F8NDmrkdw.yQwgdJAOjYz0pk46su', 3, 'TS. Phạm Đức Dũng', '25810179@teacher.hcmute.edu.vn', '0902222004', 'LECTURER', b'1'),
(7, 'lecturer05', '$2a$10$L4wyNr3EuOK.MpAkzglrTOir1F8NDmrkdw.yQwgdJAOjYz0pk46su', 3, 'ThS. Vũ Thị Ánh Tuyết', '25810180@teacher.hcmute.edu.vn', '0902222005', 'LECTURER', b'1'),
(8, 'student01', '$2a$10$L4wyNr3EuOK.MpAkzglrTOir1F8NDmrkdw.yQwgdJAOjYz0pk46su', 4, 'Nguyễn Văn Minh', '25810176@student.hcmute.edu.vn', '0903333001', 'STUDENT', b'1'),
(9, 'student02', '$2a$10$L4wyNr3EuOK.MpAkzglrTOir1F8NDmrkdw.yQwgdJAOjYz0pk46su', 4, 'Trần Thị Mai', '25810177@student.hcmute.edu.vn', '0903333002', 'STUDENT', b'1'),
(10, 'student03', '$2a$10$L4wyNr3EuOK.MpAkzglrTOir1F8NDmrkdw.yQwgdJAOjYz0pk46su', 4, 'Lê Hoàng Nam', '25810178@student.hcmute.edu.vn', '0903333003', 'STUDENT', b'1'),
(11, 'student04', '$2a$10$L4wyNr3EuOK.MpAkzglrTOir1F8NDmrkdw.yQwgdJAOjYz0pk46su', 4, 'Phạm Quốc Bảo', '25810179@student.hcmute.edu.vn', '0903333004', 'STUDENT', b'1'),
(12, 'student05', '$2a$10$L4wyNr3EuOK.MpAkzglrTOir1F8NDmrkdw.yQwgdJAOjYz0pk46su', 4, 'Võ Thị Cẩm Tú', '25810180@student.hcmute.edu.vn', '0903333005', 'STUDENT', b'1');

-- Bổ sung tài khoản cho sinh viên 06-100 và giảng viên 06-100.
-- Phần trước dấu @ của email luôn trùng với mã hồ sơ tương ứng.
INSERT IGNORE INTO `users` (`username`, `password`, `role_id`, `full_name`, `email`, `phone`, `role`, `enabled`)
WITH RECURSIVE `seq` AS (
    SELECT 6 AS `number`
    UNION ALL
    SELECT `number` + 1 FROM `seq` WHERE `number` < 100
)
SELECT CONCAT('student', LPAD(`number`, 2, '0')), '$2a$10$L4wyNr3EuOK.MpAkzglrTOir1F8NDmrkdw.yQwgdJAOjYz0pk46su', 4,
       CASE (`number` - 6) % 6
           WHEN 0 THEN CONCAT('Nguyễn Minh Khang ', LPAD(`number`, 2, '0'))
           WHEN 1 THEN CONCAT('Trần Quốc Bảo ', LPAD(`number`, 2, '0'))
           WHEN 2 THEN CONCAT('Lê Hoàng Nam ', LPAD(`number`, 2, '0'))
           WHEN 3 THEN CONCAT('Phạm Gia Huy ', LPAD(`number`, 2, '0'))
           WHEN 4 THEN CONCAT('Võ Thành Đạt ', LPAD(`number`, 2, '0'))
           ELSE CONCAT('Đặng Khánh Linh ', LPAD(`number`, 2, '0'))
       END,
    CONCAT(25810175 + `number`, '@student.hcmute.edu.vn'),
       CONCAT('0903333', LPAD(`number` + 5, 3, '0')), 'STUDENT', b'1'
FROM `seq`;

INSERT IGNORE INTO `users` (`username`, `password`, `role_id`, `full_name`, `email`, `phone`, `role`, `enabled`)
WITH RECURSIVE `seq` AS (
    SELECT 6 AS `number`
    UNION ALL
    SELECT `number` + 1 FROM `seq` WHERE `number` < 100
)
SELECT CONCAT('lecturer', LPAD(`number`, 2, '0')), '$2a$10$L4wyNr3EuOK.MpAkzglrTOir1F8NDmrkdw.yQwgdJAOjYz0pk46su', 3,
       CASE (`number` - 6) % 6
           WHEN 0 THEN CONCAT('TS. Nguyễn Hoàng Long ', LPAD(`number`, 2, '0'))
           WHEN 1 THEN CONCAT('TS. Trần Minh Quân ', LPAD(`number`, 2, '0'))
           WHEN 2 THEN CONCAT('PGS.TS. Lê Quốc Việt ', LPAD(`number`, 2, '0'))
           WHEN 3 THEN CONCAT('TS. Phạm Đức Anh ', LPAD(`number`, 2, '0'))
           WHEN 4 THEN CONCAT('PGS.TS. Võ Thành Trung ', LPAD(`number`, 2, '0'))
           ELSE CONCAT('TS. Đặng Thu Hà ', LPAD(`number`, 2, '0'))
       END,
    CONCAT(25810175 + `number`, '@teacher.hcmute.edu.vn'),
       CONCAT('0902222', LPAD(`number` + 5, 3, '0')), 'LECTURER', b'1'
FROM `seq`;

-- -----------------------------------------------------------------------------
-- 4. BẢNG LECTURERS (Hồ sơ Giảng viên)
-- -----------------------------------------------------------------------------
CREATE TABLE `lecturers` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `user_id` BIGINT NOT NULL UNIQUE,
    `department_id` BIGINT NOT NULL,
    `lecturer_code` VARCHAR(50) NOT NULL UNIQUE,
    `degree` VARCHAR(100),
    `academic_degree` VARCHAR(100),
    `academic_title` VARCHAR(100),
    `research_field` VARCHAR(255),
    CONSTRAINT `fk_lecturers_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_lecturers_departments` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `lecturers` (`id`, `user_id`, `department_id`, `lecturer_code`, `degree`, `academic_degree`, `academic_title`, `research_field`) VALUES
(1, 3, 1, '25810176', 'Tiến sĩ', 'Tiến sĩ', 'Giảng viên chính', 'Công nghệ phần mềm & Kiến trúc vi dịch vụ'),
(2, 4, 1, '25810177', 'Thạc sĩ', 'Thạc sĩ', 'Giảng viên', 'Trí tuệ nhân tạo & Thị giác máy tính'),
(3, 5, 1, '25810178', 'Tiến sĩ', 'Phó Giáo sư', 'Giảng viên', 'Hệ thống thông tin quản lý & Blockchain'),
(4, 6, 1, '25810179', 'Tiến sĩ', 'Tiến sĩ', 'Giảng viên', 'An ninh mạng & Hệ thống phân tán'),
(5, 7, 1, '25810180', 'Thạc sĩ', 'Thạc sĩ', 'Giảng viên', 'Kiểm thử phần mềm & DevOps');

INSERT IGNORE INTO `lecturers` (`user_id`, `department_id`, `lecturer_code`, `degree`, `academic_degree`, `academic_title`, `research_field`)
WITH RECURSIVE `seq` AS (
    SELECT 6 AS `number`
    UNION ALL
    SELECT `number` + 1 FROM `seq` WHERE `number` < 100
)
SELECT `user`.`id`, 1 + ((`seq`.`number` - 6) % 6), CAST(25810175 + `seq`.`number` AS CHAR),
       IF(`seq`.`number` % 2 = 0, 'Thạc sĩ', 'Tiến sĩ'),
       IF(`seq`.`number` % 2 = 0, 'Thạc sĩ', 'Tiến sĩ'), 'Giảng viên',
       CASE (`seq`.`number` - 6) % 6
           WHEN 0 THEN 'Công nghệ phần mềm và hệ thống thông tin'
           WHEN 1 THEN 'Pháp luật kinh tế và pháp chế doanh nghiệp'
           WHEN 2 THEN 'Kỹ thuật xây dựng công trình dân dụng'
           WHEN 3 THEN 'Điện tử, viễn thông và tự động hóa'
           WHEN 4 THEN 'Cơ khí chế tạo máy và cơ điện tử'
           ELSE 'Quản trị kinh doanh và thương mại điện tử'
       END
FROM `seq`
JOIN `users` AS `user`
    ON `user`.`email` = CONCAT(25810175 + `seq`.`number`, '@teacher.hcmute.edu.vn');

-- -----------------------------------------------------------------------------
-- 5. BẢNG STUDENTS (Hồ sơ Sinh viên)
-- -----------------------------------------------------------------------------
CREATE TABLE `students` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `user_id` BIGINT NOT NULL UNIQUE,
    `department_id` BIGINT NOT NULL,
    `student_code` VARCHAR(50) NOT NULL UNIQUE,
    `class_name` VARCHAR(50) NOT NULL,
    `course_year` VARCHAR(50) NOT NULL,
    `major` VARCHAR(150) NOT NULL,
    CONSTRAINT `fk_students_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_students_departments` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `students` (`id`, `user_id`, `department_id`, `student_code`, `class_name`, `course_year`, `major`) VALUES
(1, 8, 1, '25810176', '21110CL1A', 'K21', 'Công nghệ thông tin'),
(2, 9, 1, '25810177', '21110CL1A', 'K21', 'Công nghệ thông tin'),
(3, 10, 1, '25810178', '21110CL1B', 'K21', 'Công nghệ thông tin'),
(4, 11, 1, '25810179', '21110CL2A', 'K21', 'Khoa học máy tính'),
(5, 12, 1, '25810180', '21110CL2A', 'K21', 'Khoa học máy tính');

INSERT IGNORE INTO `students` (`user_id`, `department_id`, `student_code`, `class_name`, `course_year`, `major`)
WITH RECURSIVE `seq` AS (
    SELECT 6 AS `number`
    UNION ALL
    SELECT `number` + 1 FROM `seq` WHERE `number` < 100
)
SELECT `user`.`id`, 1 + ((`seq`.`number` - 6) % 6), CAST(25810175 + `seq`.`number` AS CHAR),
       CASE (`seq`.`number` - 6) % 6
           WHEN 0 THEN CONCAT('21110CL', 1 + (`seq`.`number` % 4), 'A')
           WHEN 1 THEN CONCAT('21112L', 1 + (`seq`.`number` % 3), 'A')
           WHEN 2 THEN CONCAT('21110XD', 1 + (`seq`.`number` % 3), 'A')
           WHEN 3 THEN CONCAT('21110DD', 1 + (`seq`.`number` % 3), 'A')
           WHEN 4 THEN CONCAT('21110CK', 1 + (`seq`.`number` % 3), 'A')
           ELSE CONCAT('21110KT', 1 + (`seq`.`number` % 3), 'A')
       END, 'K21',
       CASE (`seq`.`number` - 6) % 6
           WHEN 0 THEN IF(`seq`.`number` % 2 = 0, 'Công nghệ thông tin', 'Khoa học máy tính')
           WHEN 1 THEN 'Luật kinh tế'
           WHEN 2 THEN 'Kỹ thuật xây dựng'
           WHEN 3 THEN 'Kỹ thuật điện - điện tử'
           WHEN 4 THEN 'Cơ khí chế tạo máy'
           ELSE 'Quản trị kinh doanh'
       END
FROM `seq`
JOIN `users` AS `user`
    ON `user`.`email` = CONCAT(25810175 + `seq`.`number`, '@student.hcmute.edu.vn');

-- -----------------------------------------------------------------------------
-- 6. BẢNG REGISTRATION_PERIODS (Đợt đăng ký đề tài)
-- -----------------------------------------------------------------------------
CREATE TABLE `registration_periods` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL,
    `type` VARCHAR(50) NOT NULL, -- THESIS, PROJECT, NCKH, COURSE
    `lecturer_start_date` DATE NOT NULL,
    `lecturer_end_date` DATE NOT NULL,
    `student_start_date` DATE NOT NULL,
    `student_end_date` DATE NOT NULL,
    `reviewer_deadline` DATE NULL, -- Bắt buộc cho TLCN/KLTN
    `council_report_date` DATE NULL, -- Bắt buộc cho KLTN
    `status` VARCHAR(50) NOT NULL DEFAULT 'OPEN',
    `active` BIT(1) NOT NULL DEFAULT b'1',
    `created_by` BIGINT NULL,
    CONSTRAINT `fk_periods_users` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `registration_periods` (`id`, `name`, `type`, `lecturer_start_date`, `lecturer_end_date`, `student_start_date`, `student_end_date`, `reviewer_deadline`, `council_report_date`, `status`, `active`, `created_by`) VALUES
(1, 'Đợt Khóa luận tốt nghiệp (KLTN) Học kỳ 1 2026-2027', 'THESIS', '2026-08-01', '2026-09-15', '2026-09-16', '2026-10-15', '2027-01-10', '2027-01-20', 'OPEN', b'1', 1),
(2, 'Đợt Tiểu luận chuyên ngành (TLCN) Học kỳ 1 2026-2027', 'PROJECT', '2026-08-10', '2026-09-20', '2026-09-21', '2026-10-20', '2027-01-05', NULL, 'OPEN', b'1', 1),
(3, 'Đợt Nghiên cứu khoa học sinh viên (NCKH) 2026', 'NCKH', '2026-03-01', '2026-04-15', '2026-04-16', '2026-05-15', NULL, NULL, 'CLOSED', b'0', 1);

-- -----------------------------------------------------------------------------
-- 7. BẢNG TOPICS (Đề tài nghiên cứu)
-- -----------------------------------------------------------------------------
CREATE TABLE `topics` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `code` VARCHAR(50) NOT NULL UNIQUE,
    `title` VARCHAR(255) NOT NULL,
    `description` TEXT NOT NULL,
    `requirements` TEXT,
    `department_id` BIGINT NOT NULL,
    `reg_period_id` BIGINT NOT NULL,
    `lecturer_id` BIGINT NOT NULL, -- GVHD Chính
    `co_lecturer_id` BIGINT NULL,  -- Đồng GVHD
    `max_students` INT NOT NULL DEFAULT 3,
    `status` VARCHAR(50) NOT NULL DEFAULT 'PUBLISHED',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `fk_topics_departments` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`),
    CONSTRAINT `fk_topics_periods` FOREIGN KEY (`reg_period_id`) REFERENCES `registration_periods` (`id`),
    CONSTRAINT `fk_topics_lecturers` FOREIGN KEY (`lecturer_id`) REFERENCES `lecturers` (`id`),
    CONSTRAINT `fk_topics_co_lecturers` FOREIGN KEY (`co_lecturer_id`) REFERENCES `lecturers` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `topics` (`id`, `code`, `title`, `description`, `requirements`, `department_id`, `reg_period_id`, `lecturer_id`, `co_lecturer_id`, `max_students`, `status`) VALUES
(1, 'DT001', 'Cổng thông tin Quản lý Đề tài tốt nghiệp Khoa CNTT - HCMUTE', 'Xây dựng hệ thống web tự động hóa quy trình quản lý đợt, phân công GVHD, hội đồng phản biện và công bố điểm.', 'Thành thạo Spring Boot, JPA/Hibernate, MySQL, JSP/Bootstrap 5, Thiết kế CSDL quan hệ.', 1, 1, 1, 5, 3, 'PUBLISHED'),
(2, 'DT002', 'Ứng dụng Học sâu và NLP xây dựng Trợ lý ảo AI hỗ trợ sinh viên', 'Nghiên cứu mô hình ngôn ngữ lớn (LLM) và RAG để giải đáp thắc mắc quy chế học vụ và học bổng cho sinh viên UTE.', 'Kiến thức Python, PyTorch/TensorFlow, Transformers, LangChain, Vector Database.', 1, 1, 2, NULL, 3, 'PUBLISHED'),
(3, 'DT003', 'Hệ thống Truy xuất nguồn gốc Nông sản sử dụng Blockchain Hyperledger Fabric', 'Xây dựng mạng lưới Blockchain phân tán cho phép ghi nhận và xác thực hành trình chuỗi cung ứng thực phẩm sạch.', 'Hyperledger Fabric, Node.js, Smart Contract (Chaincode), Docker, Kiến trúc phân tán.', 1, 1, 3, 1, 3, 'PUBLISHED'),
(4, 'DT004', 'Giải pháp Giám sát và Phát hiện Tấn công mạng trên Cụm Kubernetes', 'Ứng dụng eBPF và Machine Learning để phân tích lưu lượng mạng và phát hiện bất thường trong môi trường Cloud Native.', 'Linux Kernel, eBPF, Kubernetes, Python ML, Network Security.', 1, 1, 4, NULL, 3, 'PUBLISHED'),
(5, 'DT005', 'Nền tảng E-Learning tương tác với Kiến trúc Microservices và Flutter', 'Xây dựng hệ sinh thái học tập trực tuyến hỗ trợ live streaming lớp học, bài tập trắc nghiệm và diễn đàn học thuật.', 'Spring Cloud, Flutter, WebSocket, Redis, Docker & CI/CD.', 1, 2, 5, NULL, 3, 'PUBLISHED'),
(6, 'DT006', 'Hệ thống Nhận diện Khuôn mặt thông minh phục vụ Điểm danh tự động', 'Ứng dụng mạng nơ-ron tích chập (CNN) kết hợp camera IP để điểm danh sinh viên trong giảng đường.', 'OpenCV, YOLO, Face Recognition, Python, MySQL.', 1, 1, 2, NULL, 3, 'PENDING');

-- -----------------------------------------------------------------------------
-- 8. BẢNG TOPIC_SUPERVISORS (Quan hệ Hướng dẫn Đề tài - Tối đa 2 GV)
-- -----------------------------------------------------------------------------
CREATE TABLE `topic_supervisors` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `topic_id` BIGINT NOT NULL,
    `lecturer_id` BIGINT NOT NULL,
    `role` VARCHAR(50) NOT NULL, -- PRIMARY, CO_SUPERVISOR
    UNIQUE KEY `uk_topic_lecturer` (`topic_id`, `lecturer_id`),
    CONSTRAINT `fk_supervisors_topics` FOREIGN KEY (`topic_id`) REFERENCES `topics` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_supervisors_lecturers` FOREIGN KEY (`lecturer_id`) REFERENCES `lecturers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `topic_supervisors` (`id`, `topic_id`, `lecturer_id`, `role`) VALUES
(1, 1, 1, 'PRIMARY'),
(2, 1, 5, 'CO_SUPERVISOR'),
(3, 2, 2, 'PRIMARY'),
(4, 3, 3, 'PRIMARY'),
(5, 3, 1, 'CO_SUPERVISOR'),
(6, 4, 4, 'PRIMARY'),
(7, 5, 5, 'PRIMARY');

-- -----------------------------------------------------------------------------
-- 9. BẢNG STUDENT_GROUPS (Nhóm sinh viên thực hiện đề tài)
-- -----------------------------------------------------------------------------
CREATE TABLE `student_groups` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(150) NOT NULL,
    `leader_id` BIGINT NOT NULL,
    `reg_period_id` BIGINT NOT NULL,
    `topic_id` BIGINT NULL,
    `status` VARCHAR(50) NOT NULL DEFAULT 'ASSIGNED',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_groups_leaders` FOREIGN KEY (`leader_id`) REFERENCES `students` (`id`),
    CONSTRAINT `fk_groups_periods` FOREIGN KEY (`reg_period_id`) REFERENCES `registration_periods` (`id`),
    CONSTRAINT `fk_groups_topics` FOREIGN KEY (`topic_id`) REFERENCES `topics` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `student_groups` (`id`, `name`, `leader_id`, `reg_period_id`, `topic_id`, `status`) VALUES
(1, 'Nhóm UTE Dev Innovators', 1, 1, 1, 'ASSIGNED'),
(2, 'Nhóm AI Titans', 4, 1, 2, 'ASSIGNED');

-- -----------------------------------------------------------------------------
-- 10. BẢNG GROUP_MEMBERS (Thành viên nhóm - Tối đa 3 SV, 1 Nhóm trưởng)
-- -----------------------------------------------------------------------------
CREATE TABLE `group_members` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `group_id` BIGINT NOT NULL,
    `student_id` BIGINT NOT NULL,
    `leader` BIT(1) NOT NULL DEFAULT b'0',
    `joined_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY `uk_group_student` (`group_id`, `student_id`),
    CONSTRAINT `fk_members_groups` FOREIGN KEY (`group_id`) REFERENCES `student_groups` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_members_students` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `group_members` (`id`, `group_id`, `student_id`, `leader`) VALUES
(1, 1, 1, b'1'), -- Nguyễn Văn Minh (Nhóm trưởng)
(2, 1, 2, b'0'), -- Trần Thị Mai (Thành viên)
(3, 1, 3, b'0'), -- Lê Hoàng Nam (Thành viên)
(4, 2, 4, b'1'), -- Phạm Quốc Bảo (Nhóm trưởng)
(5, 2, 5, b'0'); -- Võ Thị Cẩm Tú (Thành viên)

-- -----------------------------------------------------------------------------
-- 11. BẢNG TOPIC_REGISTRATIONS (Đăng ký đề tài do Nhóm trưởng gửi)
-- -----------------------------------------------------------------------------
CREATE TABLE `topic_registrations` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `group_id` BIGINT NOT NULL,
    `topic_id` BIGINT NOT NULL,
    `approved_by` BIGINT NULL,
    `status` VARCHAR(50) NOT NULL DEFAULT 'PENDING',
    `note` VARCHAR(255),
    `rejection_reason` VARCHAR(255),
    `approved_at` DATETIME NULL,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_registrations_groups` FOREIGN KEY (`group_id`) REFERENCES `student_groups` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_registrations_topics` FOREIGN KEY (`topic_id`) REFERENCES `topics` (`id`),
    CONSTRAINT `fk_registrations_users` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `topic_registrations` (`id`, `group_id`, `topic_id`, `approved_by`, `status`, `note`, `approved_at`) VALUES
(1, 1, 1, 1, 'APPROVED', 'Nhóm có nền tảng vững về Java Spring Boot và thiết kế web responsive.', '2026-08-11 10:00:00'),
(2, 2, 2, 1, 'APPROVED', 'Nhóm đã có kinh nghiệm nghiên cứu mô hình LLM và RAG.', '2026-08-13 14:30:00');

-- -----------------------------------------------------------------------------
-- 12. BẢNG REPORTS (Báo cáo tiến độ / cuối kỳ - Chỉ Nhóm trưởng nộp)
-- -----------------------------------------------------------------------------
CREATE TABLE `reports` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `topic_registration_id` BIGINT NOT NULL,
    `submitted_by` BIGINT NOT NULL,
    `file_name` VARCHAR(255) NOT NULL,
    `file_path` VARCHAR(255),
    `note` TEXT,
    `submitted_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `approved` BOOLEAN NOT NULL DEFAULT FALSE,
    `approved_at` DATETIME NULL,
    `review_status` VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    CONSTRAINT `fk_reports_registrations` FOREIGN KEY (`topic_registration_id`) REFERENCES `topic_registrations` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_reports_students` FOREIGN KEY (`submitted_by`) REFERENCES `students` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `reports` (`id`, `topic_registration_id`, `submitted_by`, `file_name`, `file_path`, `note`, `submitted_at`) VALUES
(1, 1, 1, 'BaoCao_KLTN_DT001_Nhom1_Final.pdf', '/uploads/reports/BaoCao_KLTN_DT001_Nhom1_Final.pdf', 'Báo cáo hoàn chỉnh đề tài kèm tài liệu thiết kế CSDL và kiến trúc hệ thống.', '2026-08-18 09:15:00'),
(2, 2, 4, 'BaoCao_TienDo_DT002_Nhom2.pdf', '/uploads/reports/BaoCao_TienDo_DT002_Nhom2.pdf', 'Báo cáo tiến độ hoàn thành huấn luyện mô hình RAG và đánh giá độ chính xác.', '2026-08-19 16:45:00');

-- -----------------------------------------------------------------------------
-- 13. BẢNG COUNCILS (Hội đồng phản biện - 3 đến 5 Giảng viên)
-- -----------------------------------------------------------------------------
CREATE TABLE `councils` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `code` VARCHAR(50) NOT NULL UNIQUE,
    `name` VARCHAR(255) NOT NULL,
    `reg_period_id` BIGINT NOT NULL,
    `department_id` BIGINT NULL,
    `chairman_id` BIGINT NOT NULL,
    `secretary_id` BIGINT NOT NULL,
    `council_date` DATE NOT NULL,
    `location` VARCHAR(255) NOT NULL,
    `status` VARCHAR(50) NOT NULL DEFAULT 'ONGOING',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_councils_periods` FOREIGN KEY (`reg_period_id`) REFERENCES `registration_periods` (`id`),
    CONSTRAINT `fk_councils_departments` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE SET NULL,
    CONSTRAINT `fk_councils_chairmen` FOREIGN KEY (`chairman_id`) REFERENCES `lecturers` (`id`),
    CONSTRAINT `fk_councils_secretaries` FOREIGN KEY (`secretary_id`) REFERENCES `lecturers` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `councils` (`id`, `code`, `name`, `reg_period_id`, `department_id`, `chairman_id`, `secretary_id`, `council_date`, `location`, `status`) VALUES
(1, 'HD01', 'Hội đồng Phản biện KLTN 01 - Chuyên ngành CNPM & Hệ thống', 1, 1, 3, 4, '2027-01-20', 'Phòng Hội thảo A1-302, Tòa nhà Trung tâm UTE', 'COMPLETED'),
(2, 'HD02', 'Hội đồng Phản biện KLTN 02 - Trí tuệ nhân tạo & Dữ liệu lớn', 1, 2, 1, 5, '2027-01-21', 'Phòng Báo cáo C1-201, Khu C', 'PLANNED');

-- -----------------------------------------------------------------------------
-- 14. BẢNG COUNCIL_MEMBERS (Thành viên Hội đồng: CHAIRMAN, SECRETARY, MEMBER)
-- -----------------------------------------------------------------------------
CREATE TABLE `council_members` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `council_id` BIGINT NOT NULL,
    `lecturer_id` BIGINT NOT NULL,
    `role` VARCHAR(50) NOT NULL, -- CHAIRMAN, SECRETARY, MEMBER
    `joined_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY `uk_council_lecturer` (`council_id`, `lecturer_id`),
    CONSTRAINT `fk_council_members_councils` FOREIGN KEY (`council_id`) REFERENCES `councils` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_council_members_lecturers` FOREIGN KEY (`lecturer_id`) REFERENCES `lecturers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- HD01: Chủ tịch Lê Hoàng Cường (GV003), Thư ký Phạm Đức Dũng (GV004), Ủy viên Trần Thị Bích (GV002)
-- Lưu ý: TS. Nguyễn Văn An là GVHD của DT001 nên không được tham gia chấm HD01 cho đề tài này (Đảm bảo quy tắc chống tự chấm điểm)
INSERT INTO `council_members` (`id`, `council_id`, `lecturer_id`, `role`) VALUES
(1, 1, 3, 'CHAIRMAN'),
(2, 1, 4, 'SECRETARY'),
(3, 1, 2, 'MEMBER'),
(4, 2, 1, 'CHAIRMAN'),
(5, 2, 5, 'SECRETARY'),
(6, 2, 3, 'MEMBER');

-- -----------------------------------------------------------------------------
-- 15. BẢNG TOPIC_ASSIGNMENTS (Phân công đề tài cho Hội đồng)
-- -----------------------------------------------------------------------------
CREATE TABLE `topic_assignments` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `council_id` BIGINT NOT NULL,
    `topic_registration_id` BIGINT NOT NULL,
    `status` VARCHAR(50) NOT NULL DEFAULT 'EVALUATED',
    `assigned_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY `uk_council_registration` (`council_id`, `topic_registration_id`),
    CONSTRAINT `fk_assignments_councils` FOREIGN KEY (`council_id`) REFERENCES `councils` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_assignments_registrations` FOREIGN KEY (`topic_registration_id`) REFERENCES `topic_registrations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `topic_assignments` (`id`, `council_id`, `topic_registration_id`, `status`) VALUES
(1, 1, 1, 'EVALUATED');

-- -----------------------------------------------------------------------------
-- 16. BẢNG SCORES (Điểm số và Nhận xét của Thành viên Hội đồng)
-- Điểm trung bình cộng: (9.2 + 8.8 + 9.0) / 3 = 9.0 (Xuất sắc)
-- -----------------------------------------------------------------------------
CREATE TABLE `scores` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `topic_assignment_id` BIGINT NOT NULL,
    `council_member_id` BIGINT NOT NULL,
    `score` DOUBLE NOT NULL,
    `comment` TEXT,
    `submitted_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY `uk_assignment_member` (`topic_assignment_id`, `council_member_id`),
    CONSTRAINT `fk_scores_assignments` FOREIGN KEY (`topic_assignment_id`) REFERENCES `topic_assignments` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_scores_council_members` FOREIGN KEY (`council_member_id`) REFERENCES `council_members` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `scores` (`id`, `topic_assignment_id`, `council_member_id`, `score`, `comment`, `submitted_at`) VALUES
(1, 1, 1, 9.2, 'Báo cáo xuất sắc, giải pháp kiến trúc rõ ràng, tính thực tiễn và ứng dụng cao cho Khoa CNTT.', '2026-08-20 14:00:00'),
(2, 1, 2, 8.8, 'Giao diện trực quan, luồng nghiệp vụ chuẩn xác, các ràng buộc dữ liệu được xử lý chặt chẽ.', '2026-08-20 14:15:00'),
(3, 1, 3, 9.0, 'Sinh viên trả lời phản biện lưu loát, nắm vững kỹ thuật lập trình web và cơ sở dữ liệu quan hệ.', '2026-08-20 14:30:00');

-- -----------------------------------------------------------------------------
-- 17. BẢNG NOTIFICATIONS (Thông báo từ Ban Chủ nhiệm Khoa)
-- -----------------------------------------------------------------------------
CREATE TABLE `notifications` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `title` VARCHAR(255) NOT NULL,
    `content` TEXT NOT NULL,
    `type` VARCHAR(50) NOT NULL, -- ALL, STUDENT, LECTURER
    `published` BIT(1) NOT NULL DEFAULT b'1',
    `published_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `created_by` BIGINT NULL,
    CONSTRAINT `fk_notifications_users` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `notifications` (`id`, `title`, `content`, `type`, `published`, `published_at`, `created_by`) VALUES
(1, 'Thông báo: Kế hoạch Đăng ký Khóa luận tốt nghiệp HK1 năm học 2026-2027', 'Khoa Công nghệ thông tin thông báo đến toàn thể Giảng viên và Sinh viên về kế hoạch triển khai đợt KLTN. Giảng viên đề xuất đề tài từ ngày 01/08/2026 đến 15/09/2026. Sinh viên tiến hành lập nhóm (tối đa 3 SV) và đăng ký đề tài từ ngày 16/09/2026 đến 15/10/2026.', 'ALL', b'1', '2026-08-15 08:00:00', 1),
(2, 'Hướng dẫn Sinh viên: Quy định thành lập nhóm và nộp báo cáo tiến độ', 'Mỗi nhóm sinh viên gồm tối đa 03 thành viên và mỗi sinh viên chỉ được tham gia 01 nhóm duy nhất trong đợt. Việc nộp báo cáo đề tài chỉ được thực hiện bởi Nhóm trưởng. Các nhóm lưu ý nộp đúng hạn quy định trên hệ thống.', 'STUDENT', b'1', '2026-08-16 09:00:00', 1),
(3, 'Lưu ý Giảng viên: Quy định chấm điểm và phân công hội đồng phản biện', 'Kính gửi Quý Thầy/Cô, theo quy chế đào tạo, Giảng viên hướng dẫn hoặc đồng hướng dẫn sẽ không tham gia chấm điểm phản biện cho đề tài do mình hướng dẫn. Đề nghị Quý Thầy/Cô thành viên hội đồng hoàn thành nhập điểm đúng thời hạn quy định.', 'LECTURER', b'1', '2026-08-17 10:00:00', 1);

-- -----------------------------------------------------------------------------
-- 18. BẢNG ANNOUNCEMENT_READS (Theo dõi trạng thái đã đọc thông báo)
-- -----------------------------------------------------------------------------
CREATE TABLE `announcement_reads` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `notification_id` BIGINT NOT NULL,
    `user_id` BIGINT NOT NULL,
    `read_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY `uk_notification_user` (`notification_id`, `user_id`),
    CONSTRAINT `fk_reads_notifications` FOREIGN KEY (`notification_id`) REFERENCES `notifications` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_reads_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `announcement_reads` (`id`, `notification_id`, `user_id`, `read_at`) VALUES
(1, 1, 7, '2026-08-15 11:20:00'),
(2, 2, 7, '2026-08-16 14:05:00');

-- ----------------------------------------------------------------------------
-- 19. BỔ SUNG DỮ LIỆU NGHIỆP VỤ ĐỦ 20 ĐỀ TÀI
-- Roles và departments là bảng danh mục nên giữ nguyên 4 vai trò và 6 khoa.
-- ----------------------------------------------------------------------------

INSERT IGNORE INTO `registration_periods`
    (`id`, `name`, `type`, `lecturer_start_date`, `lecturer_end_date`, `student_start_date`, `student_end_date`, `reviewer_deadline`, `council_report_date`, `status`, `active`, `created_by`)
WITH RECURSIVE `seq` AS (
    SELECT 4 AS `number`
    UNION ALL SELECT `number` + 1 FROM `seq` WHERE `number` < 20
)
SELECT `number`, CONCAT('Đợt đăng ký đề tài số ', LPAD(`number`, 3, '0')),
       CASE `number` % 4 WHEN 0 THEN 'THESIS' WHEN 1 THEN 'PROJECT' WHEN 2 THEN 'NCKH' ELSE 'COURSE' END,
       DATE_ADD('2026-01-01', INTERVAL `number` DAY),
       DATE_ADD('2026-02-01', INTERVAL `number` DAY),
       DATE_ADD('2026-02-02', INTERVAL `number` DAY),
       DATE_ADD('2026-03-01', INTERVAL `number` DAY),
       DATE_ADD('2026-04-01', INTERVAL `number` DAY),
       IF(`number` % 4 = 0, DATE_ADD('2026-04-15', INTERVAL `number` DAY), NULL),
       IF(`number` % 3 = 0, 'CLOSED', 'OPEN'), b'1', 1
FROM `seq`;

INSERT IGNORE INTO `topics`
    (`id`, `code`, `title`, `description`, `requirements`, `department_id`, `reg_period_id`, `lecturer_id`, `co_lecturer_id`, `max_students`, `status`)
WITH RECURSIVE `seq` AS (
    SELECT 7 AS `number`
    UNION ALL SELECT `number` + 1 FROM `seq` WHERE `number` < 20
)
SELECT `number`, CONCAT('DT', LPAD(`number`, 3, '0')),
    CASE (`number` - 6) % 6
           WHEN 0 THEN CONCAT('Xây dựng hệ thống phần mềm thông minh ', `number`)
           WHEN 1 THEN CONCAT('Nghiên cứu pháp luật và quản trị doanh nghiệp ', `number`)
           WHEN 2 THEN CONCAT('Mô hình BIM trong quản lý công trình ', `number`)
           WHEN 3 THEN CONCAT('Thiết kế hệ thống điều khiển tự động ', `number`)
           WHEN 4 THEN CONCAT('Tối ưu hóa dây chuyền cơ khí ', `number`)
           ELSE CONCAT('Phân tích dữ liệu kinh doanh và thương mại điện tử ', `number`)
       END,
       CONCAT('Đề tài nghiên cứu và ứng dụng chuyên ngành số ', `number`),
       'Có kiến thức chuyên ngành, kỹ năng phân tích và thực hiện báo cáo.',
    1 + ((`number` - 6) % 6), `number`,
       1 + ((`number` - 1) % 100),
    NULL, 3,
       IF(`number` % 10 = 0, 'PENDING', 'PUBLISHED')
FROM `seq`;

INSERT IGNORE INTO `topic_supervisors` (`id`, `topic_id`, `lecturer_id`, `role`)
WITH RECURSIVE `seq` AS (
    SELECT 7 AS `number`
    UNION ALL SELECT `number` + 1 FROM `seq` WHERE `number` < 20
)
SELECT `number` + 1, `number`, 1 + ((`number` - 1) % 100), 'PRIMARY'
FROM `seq`;

INSERT IGNORE INTO `student_groups` (`id`, `name`, `leader_id`, `reg_period_id`, `topic_id`, `status`)
WITH RECURSIVE `seq` AS (
    SELECT 3 AS `number`
    UNION ALL SELECT `number` + 1 FROM `seq` WHERE `number` < 20
)
SELECT `number`, CONCAT('Nhóm nghiên cứu UTE ', LPAD(`number`, 3, '0')), `number`,
       1 + ((`number` - 1) % 100), `number`, 'ASSIGNED'
FROM `seq`;

INSERT IGNORE INTO `group_members` (`id`, `group_id`, `student_id`, `leader`)
WITH RECURSIVE `seq` AS (
    SELECT 3 AS `number`
    UNION ALL SELECT `number` + 1 FROM `seq` WHERE `number` < 20
)
SELECT `number`, `number`, `number` + 3, b'1'
FROM `seq`;

INSERT IGNORE INTO `topic_registrations`
    (`id`, `group_id`, `topic_id`, `approved_by`, `status`, `note`, `approved_at`)
WITH RECURSIVE `seq` AS (
    SELECT 3 AS `number`
    UNION ALL SELECT `number` + 1 FROM `seq` WHERE `number` < 20
)
SELECT `number`, `number`, `number`, 1, 'APPROVED',
       CONCAT('Đăng ký đề tài số ', LPAD(`number`, 3, '0'), ' đã được tiếp nhận.'),
       DATE_ADD('2026-08-01 08:00:00', INTERVAL `number` DAY)
FROM `seq`;

INSERT IGNORE INTO `reports`
    (`id`, `topic_registration_id`, `submitted_by`, `file_name`, `file_path`, `note`, `submitted_at`)
WITH RECURSIVE `seq` AS (
    SELECT 3 AS `number`
    UNION ALL SELECT `number` + 1 FROM `seq` WHERE `number` < 20
)
SELECT `number`, `number`, `number`, CONCAT('BaoCao_DT', LPAD(`number`, 3, '0'), '.pdf'),
       CONCAT('/uploads/reports/BaoCao_DT', LPAD(`number`, 3, '0'), '.pdf'),
       CONCAT('Báo cáo tiến độ đề tài số ', `number`),
       DATE_ADD('2026-09-01 08:00:00', INTERVAL `number` DAY)
FROM `seq`;

INSERT IGNORE INTO `councils`
    (`id`, `code`, `name`, `reg_period_id`, `department_id`, `chairman_id`, `secretary_id`, `council_date`, `location`, `status`)
WITH RECURSIVE `seq` AS (
    SELECT 3 AS `number`
    UNION ALL SELECT `number` + 1 FROM `seq` WHERE `number` < 20
)
SELECT `number`, CONCAT('HD', LPAD(`number`, 3, '0')), CONCAT('Hội đồng phản biện số ', `number`),
    1 + ((`number` - 1) % 100),
    CASE WHEN `number` < 6 THEN 1 ELSE 1 + ((`number` - 6) % 6) END,
       1 + ((`number` - 1) % 100), 1 + (`number` % 100),
       DATE_ADD('2027-01-01', INTERVAL `number` DAY), CONCAT('Phòng H', `number`),
       IF(`number` % 3 = 0, 'PLANNED', 'ONGOING')
FROM `seq`;

INSERT IGNORE INTO `council_members` (`id`, `council_id`, `lecturer_id`, `role`)
WITH RECURSIVE `seq` AS (
    SELECT 3 AS `number`
    UNION ALL SELECT `number` + 1 FROM `seq` WHERE `number` < 20
)
SELECT 7 + ((`number` - 3) * 3), `number`, 1 + ((`number` - 1) % 100), 'CHAIRMAN'
FROM `seq`
UNION ALL
SELECT 8 + ((`number` - 3) * 3), `number`, 1 + (`number` % 100), 'SECRETARY'
FROM `seq`
UNION ALL
SELECT 9 + ((`number` - 3) * 3), `number`, 1 + ((`number` + 1) % 100), 'MEMBER'
FROM `seq`;

INSERT IGNORE INTO `topic_assignments` (`id`, `council_id`, `topic_registration_id`, `status`)
WITH RECURSIVE `seq` AS (
    SELECT 2 AS `number`
    UNION ALL SELECT `number` + 1 FROM `seq` WHERE `number` < 20
)
SELECT `number`, `number`, `number`, 'ASSIGNED'
FROM `seq`;

INSERT IGNORE INTO `notifications`
    (`id`, `title`, `content`, `type`, `published`, `published_at`, `created_by`)
WITH RECURSIVE `seq` AS (
    SELECT 4 AS `number`
    UNION ALL SELECT `number` + 1 FROM `seq` WHERE `number` < 100
)
SELECT `number`, CONCAT('Thông báo học vụ số ', `number`),
       CONCAT('Nội dung thông báo dành cho người dùng của hệ thống UTE, số ', `number`),
       CASE `number` % 3 WHEN 0 THEN 'ALL' WHEN 1 THEN 'STUDENT' ELSE 'LECTURER' END,
       b'1', DATE_ADD('2026-08-01 08:00:00', INTERVAL `number` DAY), 1
FROM `seq`;

INSERT IGNORE INTO `announcement_reads` (`id`, `notification_id`, `user_id`, `read_at`)
WITH RECURSIVE `seq` AS (
    SELECT 3 AS `number`
    UNION ALL SELECT `number` + 1 FROM `seq` WHERE `number` < 100
)
SELECT `number`, `number`, 8 + ((`number` - 3) % 100),
       DATE_ADD('2026-08-10 08:00:00', INTERVAL `number` DAY)
FROM `seq`;

-- Hoàn tất khởi tạo dữ liệu mẫu!

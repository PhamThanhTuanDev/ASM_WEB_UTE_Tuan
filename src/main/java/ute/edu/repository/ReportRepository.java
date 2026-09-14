package ute.edu.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import ute.edu.entity.Report;

/** Truy vấn bảng reports (báo cáo của nhóm sinh viên). */
public interface ReportRepository extends JpaRepository<Report, Long> {
    /** Lấy báo cáo của đăng ký, mới nhất trước. */
    List<Report> findByTopicRegistrationIdOrderBySubmittedAtDesc(Long registrationId);
    /** Kiểm tra đăng ký đã có báo cáo được duyệt chưa. */
    boolean existsByTopicRegistrationIdAndApprovedTrue(Long registrationId);
}

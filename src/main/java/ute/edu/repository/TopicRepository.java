package ute.edu.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import ute.edu.enums.TopicStatus;
import ute.edu.entity.Topic;

/** Truy vấn dữ liệu bảng topics (đề tài). */
public interface TopicRepository extends JpaRepository<Topic, Long> {
    /** Lấy các đề tài theo trạng thái. */
    List<Topic> findByStatus(TopicStatus status);
    /** Lấy các đề tài thuộc một khoa. */
    List<Topic> findByDepartmentId(Long departmentId);
    /** Lấy các đề tài thuộc một đợt đăng ký. */
    List<Topic> findByRegistrationPeriodId(Long periodId);
    /** Lấy các đề tài do một giảng viên hướng dẫn. */
    List<Topic> findByLecturerId(Long lecturerId);
    /** Lấy đề tài do giảng viên là GVHD chính hoặc đồng GVHD. */
    List<Topic> findByLecturerIdOrCoLecturerId(Long lecturerId, Long coLecturerId);
    /** Lọc đề tài theo khoa và trạng thái. */
    List<Topic> findByDepartmentIdAndStatus(Long departmentId, TopicStatus status);
    /** Lọc đề tài theo đợt đăng ký và trạng thái. */
    List<Topic> findByRegistrationPeriodIdAndStatus(Long periodId, TopicStatus status);
    /** Tìm đề tài theo tên hoặc mã, không phân biệt hoa thường. */
    List<Topic> findByTitleContainingIgnoreCaseOrCodeContainingIgnoreCase(String title, String code);
}

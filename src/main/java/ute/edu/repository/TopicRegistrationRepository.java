package ute.edu.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import ute.edu.enums.RegistrationStatus;
import ute.edu.entity.TopicRegistration;

/** Truy vấn bảng topic_registrations (đăng ký đề tài). */
public interface TopicRegistrationRepository extends JpaRepository<TopicRegistration, Long> {
    /** Lấy đăng ký theo trạng thái duyệt. */
    List<TopicRegistration> findByStatus(RegistrationStatus status);
    /** Lấy tất cả đăng ký của một nhóm. */
    List<TopicRegistration> findByGroupId(Long groupId);
    /** Kiểm tra nhóm đã đăng ký đề tài này chưa. */
    boolean existsByGroupIdAndTopicId(Long groupId, Long topicId);
}

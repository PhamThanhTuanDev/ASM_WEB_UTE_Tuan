package ute.edu.repository;

import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import ute.edu.entity.TopicAssignment;

/** Truy vấn bảng topic_assignments (phân công đề tài vào hội đồng). */
public interface TopicAssignmentRepository extends JpaRepository<TopicAssignment, Long> {
    /** Lấy các đề tài thuộc một hội đồng. */
    List<TopicAssignment> findByCouncilId(Long councilId);
    /** Lấy phân công của một đăng ký đề tài. */
    List<TopicAssignment> findByTopicRegistrationId(Long topicRegistrationId);
    /** Kiểm tra một đăng ký đã được gán vào hội đồng cụ thể chưa. */
    boolean existsByCouncilIdAndTopicRegistrationId(Long councilId, Long topicRegistrationId);
    /** Kiểm tra đăng ký đã thuộc bất kỳ hội đồng nào chưa. */
    boolean existsByTopicRegistrationId(Long topicRegistrationId);
    /** Lấy phân công đầu tiên của một đăng ký. */
    Optional<TopicAssignment> findFirstByTopicRegistrationId(Long topicRegistrationId);
    /** Xóa tất cả phân công của một hội đồng. */
    void deleteByCouncilId(Long councilId);
}

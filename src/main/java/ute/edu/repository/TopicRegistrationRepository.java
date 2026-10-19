package ute.edu.repository;

import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.data.jpa.repository.JpaRepository;
import ute.edu.enums.RegistrationStatus;
import ute.edu.entity.TopicRegistration;

/** Truy vấn bảng topic_registrations (đăng ký đề tài). */
public interface TopicRegistrationRepository extends JpaRepository<TopicRegistration, Long> {
    boolean existsByGroupIdAndStatusIn(Long groupId, java.util.Collection<RegistrationStatus> statuses);
    /** Khóa dòng đến hết giao dịch (SELECT ... FOR UPDATE chạy được trên cả MySQL và MariaDB). */
    @Query(value = "SELECT * FROM topic_registrations WHERE id = :id FOR UPDATE", nativeQuery = true)
    Optional<TopicRegistration> findForUpdate(@Param("id") Long id);
    boolean existsByTopicIdAndStatus(Long topicId, RegistrationStatus status);
    /** Lấy đăng ký theo trạng thái duyệt. */
    List<TopicRegistration> findByStatusOrderByCreatedAtDescIdDesc(RegistrationStatus status);

    /** Lấy tất cả đăng ký của một nhóm. */
    List<TopicRegistration> findByGroupIdOrderByCreatedAtDescIdDesc(Long groupId);

    /** Kiểm tra nhóm đã đăng ký đề tài này chưa. */
    boolean existsByGroupIdAndTopicId(Long groupId, Long topicId);
}

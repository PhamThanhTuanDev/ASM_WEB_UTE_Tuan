package ute.edu.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import ute.edu.enums.RegistrationStatus;
import ute.edu.entity.TopicRegistration;

public interface TopicRegistrationRepository extends JpaRepository<TopicRegistration, Long> {
    List<TopicRegistration> findByStatus(RegistrationStatus status);
    List<TopicRegistration> findByGroupId(Long groupId);
    boolean existsByGroupIdAndTopicId(Long groupId, Long topicId);
}

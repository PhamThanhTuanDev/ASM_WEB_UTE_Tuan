package ute.edu.repository;

import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import ute.edu.entity.TopicAssignment;

public interface TopicAssignmentRepository extends JpaRepository<TopicAssignment, Long> {
    List<TopicAssignment> findByCouncilId(Long councilId);
    List<TopicAssignment> findByTopicRegistrationId(Long topicRegistrationId);
    boolean existsByCouncilIdAndTopicRegistrationId(Long councilId, Long topicRegistrationId);
    Optional<TopicAssignment> findFirstByTopicRegistrationId(Long topicRegistrationId);
    void deleteByCouncilId(Long councilId);
}

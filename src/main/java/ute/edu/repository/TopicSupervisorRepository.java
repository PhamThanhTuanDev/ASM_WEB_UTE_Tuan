package ute.edu.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import ute.edu.entity.TopicSupervisor;

public interface TopicSupervisorRepository extends JpaRepository<TopicSupervisor, Long> {
    List<TopicSupervisor> findByTopicId(Long topicId);
    List<TopicSupervisor> findByLecturerId(Long lecturerId);
    boolean existsByTopicIdAndLecturerId(Long topicId, Long lecturerId);
    void deleteByTopicId(Long topicId);
}

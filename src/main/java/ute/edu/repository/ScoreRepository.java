package ute.edu.repository;

import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import ute.edu.entity.Score;

public interface ScoreRepository extends JpaRepository<Score, Long> {
    List<Score> findByTopicAssignmentId(Long assignmentId);
    Optional<Score> findByTopicAssignmentIdAndCouncilMemberId(Long assignmentId, Long councilMemberId);
}

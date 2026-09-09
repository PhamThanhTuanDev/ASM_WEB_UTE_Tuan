package ute.edu.repository;

import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import ute.edu.entity.Score;

/** Truy vấn bảng scores (điểm hội đồng). */
public interface ScoreRepository extends JpaRepository<Score, Long> {
    /** Lấy toàn bộ điểm của một phân công. */
    List<Score> findByTopicAssignmentId(Long assignmentId);
    /** Lấy điểm của một thành viên trong một phân công. */
    Optional<Score> findByTopicAssignmentIdAndCouncilMemberId(Long assignmentId, Long councilMemberId);
}

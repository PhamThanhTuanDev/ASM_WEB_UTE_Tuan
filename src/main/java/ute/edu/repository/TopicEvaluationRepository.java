package ute.edu.repository;

import java.util.Optional;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import ute.edu.entity.TopicEvaluation;

/** Truy vấn bảng topic_evaluations (điểm quá trình GVHD). */
public interface TopicEvaluationRepository extends JpaRepository<TopicEvaluation, Long> {
    /** Lấy đánh giá của một giảng viên cho một đề tài. */
    Optional<TopicEvaluation> findByTopicIdAndReviewerId(Long topicId, Long reviewerId);
    /** Lấy toàn bộ đánh giá quá trình của một đề tài. */
    List<TopicEvaluation> findByTopicId(Long topicId);
}

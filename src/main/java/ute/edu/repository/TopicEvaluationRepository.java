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
    /** Lấy đánh giá quá trình của nhiều đề tài trong 1 câu truy vấn. */
    List<TopicEvaluation> findByTopicIdIn(java.util.Collection<Long> topicIds);
}

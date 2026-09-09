package ute.edu.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "topic_evaluations")
/** Bảng topic_evaluations: lưu điểm quá trình và nhận xét của giảng viên hướng dẫn. */
public class TopicEvaluation {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    // Khóa chính của đánh giá quá trình.
    private Long id;

    @ManyToOne
    @JoinColumn(name = "topic_id", nullable = false)
    // Đề tài được giảng viên hướng dẫn đánh giá.
    private Topic topic;

    @ManyToOne
    @JoinColumn(name = "reviewer_id", nullable = false)
    // Giảng viên hướng dẫn thực hiện đánh giá.
    private Lecture reviewer;

    @Column(nullable = false)
    // Điểm quá trình của đề tài, dùng để xét điều kiện vào hội đồng.
    private Double score;

    @Column(length = 1000)
    // Nhận xét quá trình của giảng viên hướng dẫn.
    private String comment;

    @Column(nullable = false)
    // Thời điểm giảng viên lưu đánh giá.
    private LocalDateTime evaluatedAt = LocalDateTime.now();

    public TopicEvaluation() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Topic getTopic() { return topic; }
    public void setTopic(Topic topic) { this.topic = topic; }
    public Lecture getReviewer() { return reviewer; }
    public void setReviewer(Lecture reviewer) { this.reviewer = reviewer; }
    public Double getScore() { return score; }
    public void setScore(Double score) { this.score = score; }
    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }
    public LocalDateTime getEvaluatedAt() { return evaluatedAt; }
    public void setEvaluatedAt(LocalDateTime evaluatedAt) { this.evaluatedAt = evaluatedAt; }
}

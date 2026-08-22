package ute.edu.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "topic_evaluations")
public class TopicEvaluation {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "topic_id", nullable = false)
    private Topic topic;

    @ManyToOne
    @JoinColumn(name = "reviewer_id", nullable = false)
    private Lecture reviewer;

    @Column(nullable = false)
    private Double score;

    @Column(length = 1000)
    private String comment;

    @Column(nullable = false)
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

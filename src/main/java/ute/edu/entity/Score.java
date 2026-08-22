package ute.edu.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "scores", uniqueConstraints = @UniqueConstraint(columnNames = {"topic_assignment_id", "council_member_id"}))
public class Score {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @ManyToOne(optional = false)
    @JoinColumn(name = "topic_assignment_id")
    private TopicAssignment topicAssignment;
    @ManyToOne(optional = false)
    @JoinColumn(name = "council_member_id")
    private ReviewCouncilMember councilMember;
    @Column(nullable = false)
    private Double score;
    @Column(length = 2000)
    private String comment;
    @Column(nullable = false)
    private LocalDateTime submittedAt = LocalDateTime.now();
    private LocalDateTime updatedAt;

    public Long getId() { return id; }
    public TopicAssignment getTopicAssignment() { return topicAssignment; }
    public void setTopicAssignment(TopicAssignment value) { topicAssignment = value; }
    public ReviewCouncilMember getCouncilMember() { return councilMember; }
    public void setCouncilMember(ReviewCouncilMember value) { councilMember = value; }
    public Double getScore() { return score; }
    public void setScore(Double value) { score = value; }
    public String getComment() { return comment; }
    public void setComment(String value) { comment = value; }
    public LocalDateTime getSubmittedAt() { return submittedAt; }
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime value) { updatedAt = value; }
}

package ute.edu.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "scores", uniqueConstraints = @UniqueConstraint(columnNames = {"topic_assignment_id", "council_member_id"}))
/** Bảng scores: lưu điểm và nhận xét của từng thành viên hội đồng. */
public class Score {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    // Khóa chính của điểm hội đồng.
    private Long id;
    @ManyToOne(optional = false)
    @JoinColumn(name = "topic_assignment_id")
    // Bản ghi phân công mà điểm này thuộc về.
    private TopicAssignment topicAssignment;
    @ManyToOne(optional = false)
    @JoinColumn(name = "council_member_id")
    // Thành viên hội đồng thực hiện chấm điểm.
    private ReviewCouncilMember councilMember;
    @Column(nullable = false)
    // Điểm phản biện từ 0 đến 10.
    private Double score;
    @Column(length = 2000)
    // Nhận xét và ý kiến phản biện của giảng viên.
    private String comment;
    @Column(nullable = false)
    // Thời điểm giảng viên gửi điểm lần đầu.
    private LocalDateTime submittedAt = LocalDateTime.now();
    // Thời điểm điểm hoặc nhận xét được cập nhật gần nhất.
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

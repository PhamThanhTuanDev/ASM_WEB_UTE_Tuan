package ute.edu.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import ute.edu.enums.AssignmentStatus;

@Entity
@Table(name = "topic_assignments", uniqueConstraints = @UniqueConstraint(columnNames = {"council_id", "topic_registration_id"}),
        indexes = @Index(name = "idx_assignments_council_time", columnList = "council_id,start_time,end_time"))
/** Bảng topic_assignments: lưu việc phân công đề tài vào hội đồng phản biện. */
public class TopicAssignment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    // Khóa chính của bản ghi phân công.
    private Long id;

    @ManyToOne(optional = false)
    @JoinColumn(name = "council_id")
    /** Hội đồng được phân công chấm đề tài. */
    // Hội đồng nhận đề tài để chấm phản biện.
    private ReviewCouncil council;
    @ManyToOne(optional = false)
    @JoinColumn(name = "topic_registration_id")
    /** Đăng ký đề tài của nhóm sinh viên. */
    // Đăng ký đề tài của nhóm được phân công.
    private TopicRegistration topicRegistration;
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    /** Trạng thái phân công: ASSIGNED hoặc EVALUATED. */
    // Trạng thái: đã phân công hoặc đã có đủ điểm đánh giá.
    private AssignmentStatus status = AssignmentStatus.ASSIGNED;
    @Column(nullable = false)
    // Thời điểm đề tài được đưa vào hội đồng.
    private LocalDateTime assignedAt = LocalDateTime.now();

    // Giờ báo cáo được xác nhận ngay khi phân công đề tài vào hội đồng.
    @Column(name = "start_time")
    private LocalTime startTime;
    @Column(name = "end_time")
    private LocalTime endTime;

    public Long getId() { return id; }
    public ReviewCouncil getCouncil() { return council; }
    public void setCouncil(ReviewCouncil value) { council = value; }
    public TopicRegistration getTopicRegistration() { return topicRegistration; }
    public void setTopicRegistration(TopicRegistration value) { topicRegistration = value; }
    public AssignmentStatus getStatus() { return status; }
    public void setStatus(AssignmentStatus value) { status = value; }
    public LocalDateTime getAssignedAt() { return assignedAt; }
    public LocalTime getStartTime() { return startTime; }
    public void setStartTime(LocalTime value) { startTime = value; }
    public LocalTime getEndTime() { return endTime; }
    public void setEndTime(LocalTime value) { endTime = value; }
    public String getReportTimeLabel() {
        var format = DateTimeFormatter.ofPattern("HH:mm");
        return startTime == null || endTime == null ? "Chưa xếp giờ"
                : startTime.format(format) + " - " + endTime.format(format);
    }
}

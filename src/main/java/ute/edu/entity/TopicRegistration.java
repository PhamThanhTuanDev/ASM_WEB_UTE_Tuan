package ute.edu.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import ute.edu.enums.RegistrationStatus;

@Entity
@Table(name = "topic_registrations")
/** Bảng topic_registrations: lưu yêu cầu nhóm sinh viên đăng ký đề tài. */
public class TopicRegistration {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    // Khóa chính của yêu cầu đăng ký.
    private Long id;

    @ManyToOne
    @JoinColumn(name = "group_id", nullable = false)
    // Nhóm sinh viên gửi yêu cầu đăng ký.
    private StudentGroup group;

    @ManyToOne
    @JoinColumn(name = "topic_id", nullable = false)
    // Đề tài mà nhóm muốn đăng ký.
    private Topic topic;

    @ManyToOne
    @JoinColumn(name = "approved_by")
    // Người duyệt đăng ký, thường là Trưởng khoa.
    private UserAccount approvedBy;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    // Trạng thái: chờ duyệt, đã duyệt hoặc bị từ chối.
    private RegistrationStatus status = RegistrationStatus.PENDING;

    @Column(length = 500)
    // Ghi chú của nhóm khi gửi đăng ký.
    private String note;

    // Thời điểm đăng ký được duyệt.
    private LocalDateTime approvedAt;

    @Column(length = 1000)
    // Lý do từ chối nếu đăng ký không được chấp nhận.
    private String rejectionReason;

    @Column(nullable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    public TopicRegistration() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public StudentGroup getGroup() { return group; }
    public void setGroup(StudentGroup group) { this.group = group; }
    public Topic getTopic() { return topic; }
    public void setTopic(Topic topic) { this.topic = topic; }
    public UserAccount getApprovedBy() { return approvedBy; }
    public void setApprovedBy(UserAccount approvedBy) { this.approvedBy = approvedBy; }
    public RegistrationStatus getStatus() { return status; }
    public void setStatus(RegistrationStatus status) { this.status = status; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
    public LocalDateTime getApprovedAt() { return approvedAt; }
    public void setApprovedAt(LocalDateTime approvedAt) { this.approvedAt = approvedAt; }
    public String getRejectionReason() { return rejectionReason; }
    public void setRejectionReason(String rejectionReason) { this.rejectionReason = rejectionReason; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}

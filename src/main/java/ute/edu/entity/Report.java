package ute.edu.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import ute.edu.enums.ReportReviewStatus;

@Entity
@Table(name = "reports")
/** Bảng reports: lưu báo cáo do nhóm sinh viên nộp và trạng thái duyệt. */
public class Report {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    // Khóa chính của báo cáo.
    private Long id;

    @ManyToOne(optional = false)
    @JoinColumn(name = "topic_registration_id")
    // Đăng ký đề tài gắn với báo cáo.
    private TopicRegistration topicRegistration;

    @Column(nullable = false)
    // Tên file báo cáo do nhóm nộp.
    private String fileName;
    @Column(nullable = false, length = 1000)
    // Đường dẫn lưu file trên máy chủ.
    private String filePath;
    @Column(length = 1000)
    // Ghi chú của nhóm khi nộp báo cáo.
    private String note;

    @ManyToOne(optional = false)
    @JoinColumn(name = "submitted_by")
    // Sinh viên thực hiện thao tác nộp, thường là nhóm trưởng.
    private Student submittedBy;
    @Column(nullable = false)
    // Thời điểm nộp báo cáo.
    private LocalDateTime submittedAt = LocalDateTime.now();

    @Column(nullable = false)
    // Đánh dấu báo cáo đã được giảng viên duyệt.
    private boolean approved = false;

    // Thời điểm báo cáo được duyệt.
    private LocalDateTime approvedAt;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    // Trạng thái xét duyệt báo cáo.
    private ReportReviewStatus reviewStatus = ReportReviewStatus.PENDING;

    public Long getId() { return id; }
    public TopicRegistration getTopicRegistration() { return topicRegistration; }
    public void setTopicRegistration(TopicRegistration value) { topicRegistration = value; }
    public String getFileName() { return fileName; }
    public void setFileName(String value) { fileName = value; }
    public String getFilePath() { return filePath; }
    public void setFilePath(String value) { filePath = value; }
    public String getNote() { return note; }
    public void setNote(String value) { note = value; }
    public Student getSubmittedBy() { return submittedBy; }
    public void setSubmittedBy(Student value) { submittedBy = value; }
    public LocalDateTime getSubmittedAt() { return submittedAt; }
    public boolean isApproved() { return approved; }
    public void setApproved(boolean value) { approved = value; }
    public LocalDateTime getApprovedAt() { return approvedAt; }
    public void setApprovedAt(LocalDateTime value) { approvedAt = value; }
    public ReportReviewStatus getReviewStatus() {
        return approved && reviewStatus == ReportReviewStatus.PENDING
                ? ReportReviewStatus.APPROVED
                : reviewStatus;
    }
    public void setReviewStatus(ReportReviewStatus value) { reviewStatus = value; }
}

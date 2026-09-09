package ute.edu.entity;

import jakarta.persistence.*;
import java.time.LocalDate;
import ute.edu.enums.RegistrationType;
import ute.edu.enums.PeriodStatus;

@Entity
@Table(name = "registration_periods")
/** Bảng registration_periods: lưu các đợt đăng ký và mốc thời gian thực hiện. */
public class RegistrationPeriod {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    // Khóa chính của đợt đăng ký.
    private Long id;

    @ManyToOne
    @JoinColumn(name = "created_by")
    // Người tạo đợt đăng ký.
    private UserAccount createdBy;

    @Column(nullable = false)
    // Tên đợt đăng ký.
    private String name;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    // Loại đợt: khóa luận, tiểu luận hoặc nghiên cứu khoa học.
    private RegistrationType type;

    @Column(nullable = false)
    // Ngày bắt đầu giảng viên đề xuất đề tài.
    private LocalDate lecturerStartDate;

    @Column(nullable = false)
    // Hạn cuối giảng viên đề xuất đề tài.
    private LocalDate lecturerEndDate;

    @Column(nullable = false)
    // Ngày bắt đầu sinh viên đăng ký đề tài.
    private LocalDate studentStartDate;

    @Column(nullable = false)
    // Hạn cuối sinh viên đăng ký đề tài.
    private LocalDate studentEndDate;

    @Column
    // Hạn giảng viên phản biện hoàn tất chấm điểm.
    private LocalDate reviewerDeadline;

    @Column
    // Ngày dự kiến báo cáo trước hội đồng.
    private LocalDate councilReportDate;

    @Column(nullable = false)
    // Đợt có đang được sử dụng hay không.
    private boolean active = true;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    // Trạng thái đợt: nháp, mở hoặc đóng.
    private PeriodStatus status = PeriodStatus.DRAFT;

    public RegistrationPeriod() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public RegistrationType getType() { return type; }
    public void setType(RegistrationType type) { this.type = type; }
    public LocalDate getLecturerStartDate() { return lecturerStartDate; }
    public void setLecturerStartDate(LocalDate lecturerStartDate) { this.lecturerStartDate = lecturerStartDate; }
    public LocalDate getLecturerEndDate() { return lecturerEndDate; }
    public void setLecturerEndDate(LocalDate lecturerEndDate) { this.lecturerEndDate = lecturerEndDate; }
    public LocalDate getStudentStartDate() { return studentStartDate; }
    public void setStudentStartDate(LocalDate studentStartDate) { this.studentStartDate = studentStartDate; }
    public LocalDate getStudentEndDate() { return studentEndDate; }
    public void setStudentEndDate(LocalDate studentEndDate) { this.studentEndDate = studentEndDate; }
    public LocalDate getReviewerDeadline() { return reviewerDeadline; }
    public void setReviewerDeadline(LocalDate reviewerDeadline) { this.reviewerDeadline = reviewerDeadline; }
    public LocalDate getCouncilReportDate() { return councilReportDate; }
    public void setCouncilReportDate(LocalDate councilReportDate) { this.councilReportDate = councilReportDate; }
    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }
    public UserAccount getCreatedBy() { return createdBy; }
    public void setCreatedBy(UserAccount createdBy) { this.createdBy = createdBy; }
    public PeriodStatus getStatus() { return status; }
    public void setStatus(PeriodStatus status) { this.status = status; }
}

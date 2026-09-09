package ute.edu.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import ute.edu.enums.TopicStatus;

@Entity
@Table(name = "topics")
/** Bảng topics: lưu thông tin đề tài, khoa quản lý và giảng viên hướng dẫn. */
public class Topic {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    // Khóa chính của đề tài.
    private Long id;

    @ManyToOne
    @JoinColumn(name = "reg_period_id")
    // Đợt đăng ký mà đề tài được mở.
    private RegistrationPeriod registrationPeriod;

    @Column(unique = true, length = 30)
    // Mã đề tài duy nhất, ví dụ DT001.
    private String code;

    @Column(nullable = false)
    // Tên đề tài hiển thị cho sinh viên.
    private String title;

    @Column(columnDefinition = "TEXT")
    // Nội dung mô tả và mục tiêu đề tài.
    private String description;

    @Column(columnDefinition = "TEXT")
    // Kiến thức hoặc yêu cầu đối với nhóm đăng ký.
    private String requirements;

    @ManyToOne
    @JoinColumn(name = "department_id", nullable = false)
    // Khoa quản lý đề tài.
    private Department department;

    @ManyToOne
    @JoinColumn(name = "lecturer_id")
    // Giảng viên hướng dẫn chính.
    private Lecture lecturer;

    @ManyToOne
    @JoinColumn(name = "co_lecturer_id")
    // Giảng viên đồng hướng dẫn, nếu có.
    private Lecture coLecturer;

    @Column(nullable = false)
    // Số sinh viên tối đa được phép thực hiện đề tài.
    private int maxStudents = 3;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    // Trạng thái đề tài: nháp, chờ duyệt, đã duyệt hoặc bị từ chối.
    private TopicStatus status = TopicStatus.DRAFT;

    @Column(nullable = false)
    @JoinColumn(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(nullable = false)
    @JoinColumn(name = "updated_at")
    private LocalDateTime updatedAt = LocalDateTime.now();

    public Topic() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public RegistrationPeriod getRegistrationPeriod() { return registrationPeriod; }
    public void setRegistrationPeriod(RegistrationPeriod registrationPeriod) { this.registrationPeriod = registrationPeriod; }
    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getRequirements() { return requirements; }
    public void setRequirements(String requirements) { this.requirements = requirements; }
    public Department getDepartment() { return department; }
    public void setDepartment(Department department) { this.department = department; }
    public Lecture getLecturer() { return lecturer; }
    public void setLecturer(Lecture lecturer) { this.lecturer = lecturer; }
    public Lecture getCoLecturer() { return coLecturer; }
    public void setCoLecturer(Lecture coLecturer) { this.coLecturer = coLecturer; }
    public int getMaxStudents() { return maxStudents; }
    public void setMaxStudents(int maxStudents) { this.maxStudents = maxStudents; }
    public TopicStatus getStatus() { return status; }
    public void setStatus(TopicStatus status) { this.status = status; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}

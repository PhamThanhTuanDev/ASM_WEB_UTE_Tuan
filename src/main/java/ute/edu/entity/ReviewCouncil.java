package ute.edu.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.time.LocalDate;
import ute.edu.enums.CouncilStatus;

@Entity
@Table(name = "councils")
/** Bảng councils: lưu thông tin các hội đồng phản biện. */
public class ReviewCouncil {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    // Khóa chính của hội đồng.
    private Long id;

    @ManyToOne
    @JoinColumn(name = "reg_period_id")
    // Đợt đăng ký gắn với hội đồng.
    private RegistrationPeriod registrationPeriod;

    @ManyToOne
    @JoinColumn(name = "department_id")
    // Khoa quản lý và tổ chức hội đồng.
    private Department department;

    @Column(unique = true, length = 30)
    // Mã hội đồng, ví dụ HD01.
    private String code;

    @Column(nullable = false)
    // Tên đầy đủ của hội đồng phản biện.
    private String name;

    @ManyToOne
    @JoinColumn(name = "chairman_id")
    // Giảng viên giữ vai trò chủ tịch hội đồng.
    private Lecture chairman;

    @ManyToOne
    @JoinColumn(name = "secretary_id")
    // Giảng viên giữ vai trò thư ký hội đồng.
    private Lecture secretary;

    // Ngày tổ chức buổi bảo vệ.
    private LocalDate councilDate;
    // Phòng hoặc địa điểm tổ chức.
    private String location;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    // Trạng thái hội đồng: đã lên kế hoạch, đang diễn ra hoặc hoàn tất.
    private CouncilStatus status = CouncilStatus.PLANNED;

    @OneToMany(mappedBy = "council")
    // Danh sách thành viên tham gia hội đồng.
    private List<ReviewCouncilMember> members = new ArrayList<>();

    @Column(nullable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    public ReviewCouncil() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public RegistrationPeriod getRegistrationPeriod() { return registrationPeriod; }
    public void setRegistrationPeriod(RegistrationPeriod registrationPeriod) { this.registrationPeriod = registrationPeriod; }
    public Department getDepartment() { return department; }
    public void setDepartment(Department department) { this.department = department; }
    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public Lecture getChairman() { return chairman; }
    public void setChairman(Lecture chairman) { this.chairman = chairman; }
    public Lecture getSecretary() { return secretary; }
    public void setSecretary(Lecture secretary) { this.secretary = secretary; }
    public LocalDate getCouncilDate() { return councilDate; }
    public void setCouncilDate(LocalDate councilDate) { this.councilDate = councilDate; }
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    public CouncilStatus getStatus() { return status; }
    public void setStatus(CouncilStatus status) { this.status = status; }
    public List<ReviewCouncilMember> getMembers() { return members; }
    public void setMembers(List<ReviewCouncilMember> members) { this.members = members; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}

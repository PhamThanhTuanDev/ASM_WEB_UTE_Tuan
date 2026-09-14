package ute.edu.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import ute.edu.enums.GroupStatus;

@Entity
@Table(name = "student_groups")
/** Bảng student_groups: lưu các nhóm sinh viên thực hiện đề tài. */
public class StudentGroup {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    // Khóa chính duy nhất của nhóm sinh viên.
    private Long id;

    @ManyToOne
    @JoinColumn(name = "reg_period_id")
    // Đợt đăng ký mà nhóm tham gia.
    private RegistrationPeriod registrationPeriod;

    @Column(nullable = false)
    // Tên hiển thị của nhóm sinh viên.
    private String name;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    // Trạng thái nhóm: chưa hoàn tất, đã đủ thành viên hoặc đã được gán đề tài.
    private GroupStatus status = GroupStatus.INCOMPLETE;

    @ManyToOne
    @JoinColumn(name = "leader_id", nullable = false)
    // Sinh viên đại diện và có quyền đăng ký đề tài, nộp báo cáo.
    private Student leader;

    @OneToMany(mappedBy = "group")
    // Danh sách thành viên thuộc nhóm.
    private List<StudentGroupMember> members = new ArrayList<>();

    @ManyToOne
    @JoinColumn(name = "topic_id")
    // Đề tài nhóm đang thực hiện, có thể chưa được gán.
    private Topic topic;

    @Column(nullable = false)
    // Thời điểm tạo nhóm.
    private LocalDateTime createdAt = LocalDateTime.now();

    public StudentGroup() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public RegistrationPeriod getRegistrationPeriod() { return registrationPeriod; }
    public void setRegistrationPeriod(RegistrationPeriod registrationPeriod) { this.registrationPeriod = registrationPeriod; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public GroupStatus getStatus() { return status; }
    public void setStatus(GroupStatus status) { this.status = status; }
    public Student getLeader() { return leader; }
    public void setLeader(Student leader) { this.leader = leader; }
    public List<StudentGroupMember> getMembers() { return members; }
    public void setMembers(List<StudentGroupMember> members) { this.members = members; }
    public Topic getTopic() { return topic; }
    public void setTopic(Topic topic) { this.topic = topic; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}

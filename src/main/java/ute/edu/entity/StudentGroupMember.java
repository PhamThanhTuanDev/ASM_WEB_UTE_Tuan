package ute.edu.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "group_members")
/** Bảng group_members: lưu thành viên thuộc từng nhóm sinh viên. */
public class StudentGroupMember {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    // Khóa chính của quan hệ thành viên nhóm.
    private Long id;

    @ManyToOne
    @JoinColumn(name = "group_id", nullable = false)
    // Nhóm mà sinh viên tham gia.
    private StudentGroup group;

    @ManyToOne
    @JoinColumn(name = "student_id", nullable = false)
    // Sinh viên thuộc nhóm.
    private Student student;

    @Column(nullable = false)
    // Đánh dấu sinh viên có phải nhóm trưởng hay không.
    private boolean leader = false;

    @Column(nullable = false)
    @JoinColumn(name = "joined_at", nullable = false)
    // Thời điểm sinh viên tham gia nhóm.
    private LocalDateTime joinedAt = LocalDateTime.now();

    public StudentGroupMember() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public StudentGroup getGroup() { return group; }
    public void setGroup(StudentGroup group) { this.group = group; }
    public Student getStudent() { return student; }
    public void setStudent(Student student) { this.student = student; }
    public boolean isLeader() { return leader; }
    public void setLeader(boolean leader) { this.leader = leader; }
    public LocalDateTime getJoinedAt() { return joinedAt; }
}

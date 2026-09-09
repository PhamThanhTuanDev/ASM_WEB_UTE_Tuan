package ute.edu.entity;

import jakarta.persistence.*;
import ute.edu.enums.CommitteeRole;
import java.time.LocalDateTime;

@Entity
@Table(name = "council_members")
/** Bảng council_members: lưu danh sách giảng viên và vai trò trong hội đồng. */
public class ReviewCouncilMember {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    // Khóa chính của thành viên hội đồng.
    private Long id;

    @ManyToOne
    @JoinColumn(name = "council_id", nullable = false)
    // Hội đồng mà giảng viên tham gia.
    private ReviewCouncil council;

    @ManyToOne
    @JoinColumn(name = "lecturer_id", nullable = false)
    // Giảng viên thuộc hội đồng.
    private Lecture lecturer;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    // Vai trò trong hội đồng: chủ tịch, thư ký hoặc ủy viên.
    private CommitteeRole role;

    @Column(nullable = false)
    // Thời điểm thêm giảng viên vào hội đồng.
    private LocalDateTime joinedAt = LocalDateTime.now();

    public ReviewCouncilMember() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public ReviewCouncil getCouncil() { return council; }
    public void setCouncil(ReviewCouncil council) { this.council = council; }
    public Lecture getLecturer() { return lecturer; }
    public void setLecturer(Lecture lecturer) { this.lecturer = lecturer; }
    public CommitteeRole getRole() { return role; }
    public void setRole(CommitteeRole role) { this.role = role; }
    public LocalDateTime getJoinedAt() { return joinedAt; }
}

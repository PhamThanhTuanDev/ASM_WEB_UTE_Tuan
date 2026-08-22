package ute.edu.entity;

import jakarta.persistence.*;
import ute.edu.enums.CommitteeRole;
import java.time.LocalDateTime;

@Entity
@Table(name = "council_members")
public class ReviewCouncilMember {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "council_id", nullable = false)
    private ReviewCouncil council;

    @ManyToOne
    @JoinColumn(name = "lecturer_id", nullable = false)
    private Lecture lecturer;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private CommitteeRole role;

    @Column(nullable = false)
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

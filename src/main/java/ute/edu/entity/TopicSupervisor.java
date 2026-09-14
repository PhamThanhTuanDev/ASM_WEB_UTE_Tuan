package ute.edu.entity;

import jakarta.persistence.*;
import ute.edu.enums.SupervisorRole;

@Entity
@Table(name = "topic_supervisors", uniqueConstraints = @UniqueConstraint(columnNames = {"topic_id", "lecturer_id"}))
/** Bảng topic_supervisors: liên kết đề tài với giảng viên hướng dẫn. */
public class TopicSupervisor {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    // Khóa chính của quan hệ hướng dẫn.
    private Long id;

    @ManyToOne(optional = false)
    @JoinColumn(name = "topic_id")
    // Đề tài được hướng dẫn.
    private Topic topic;

    @ManyToOne(optional = false)
    @JoinColumn(name = "lecturer_id")
    // Giảng viên hướng dẫn đề tài.
    private Lecture lecturer;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    // Vai trò: GVHD chính hoặc đồng GVHD.
    private SupervisorRole role;

    public Long getId() { return id; }
    public Topic getTopic() { return topic; }
    public void setTopic(Topic topic) { this.topic = topic; }
    public Lecture getLecturer() { return lecturer; }
    public void setLecturer(Lecture lecturer) { this.lecturer = lecturer; }
    public SupervisorRole getRole() { return role; }
    public void setRole(SupervisorRole role) { this.role = role; }
}

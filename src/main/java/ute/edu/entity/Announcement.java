package ute.edu.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "announcements")
/** Bảng announcements: lưu các thông báo chung của hệ thống. */
public class Announcement {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    // Khóa chính của thông báo chung.
    private Long id;

    @Column(nullable = false)
    // Tiêu đề thông báo.
    private String title;

    @Column(columnDefinition = "TEXT")
    // Nội dung thông báo.
    private String content;

    @Column(nullable = false)
    // Thời điểm tạo thông báo.
    private LocalDateTime createdAt = LocalDateTime.now();

    @ManyToOne
    @JoinColumn(name = "created_by")
    // Người tạo thông báo.
    private UserAccount createdBy;

    public Announcement() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public UserAccount getCreatedBy() { return createdBy; }
    public void setCreatedBy(UserAccount createdBy) { this.createdBy = createdBy; }
}

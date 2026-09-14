package ute.edu.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import ute.edu.enums.NotificationType;

@Entity
@Table(name = "notifications")
/** Bảng notifications: lưu thông báo được gửi đến người dùng. */
public class Notification {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    // Khóa chính của thông báo.
    private Long id;
    @ManyToOne
    @JoinColumn(name = "created_by")
    // Người tạo thông báo.
    private UserAccount createdBy;
    @Column(nullable = false)
    // Tiêu đề thông báo.
    private String title;
    @Column(nullable = false, columnDefinition = "TEXT")
    // Nội dung chi tiết thông báo.
    private String content;
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    // Đối tượng nhận: tất cả, sinh viên hoặc giảng viên.
    private NotificationType type = NotificationType.ALL;
    @Column(nullable = false)
    // Đã công bố cho người nhận hay chưa.
    private boolean published;
    // Thời điểm công bố.
    private LocalDateTime publishedAt;
    @Column(nullable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    public Long getId() { return id; }
    public UserAccount getCreatedBy() { return createdBy; }
    public void setCreatedBy(UserAccount value) { createdBy = value; }
    public String getTitle() { return title; }
    public void setTitle(String value) { title = value; }
    public String getContent() { return content; }
    public void setContent(String value) { content = value; }
    public NotificationType getType() { return type; }
    public void setType(NotificationType value) { type = value; }
    public boolean isPublished() { return published; }
    public void setPublished(boolean value) { published = value; }
    public LocalDateTime getPublishedAt() { return publishedAt; }
    public void setPublishedAt(LocalDateTime value) { publishedAt = value; }
    public LocalDateTime getCreatedAt() { return createdAt; }
}

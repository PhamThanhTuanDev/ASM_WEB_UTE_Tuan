package ute.edu.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import ute.edu.enums.NotificationType;

@Entity
@Table(name = "notifications")
public class Notification {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @ManyToOne
    @JoinColumn(name = "created_by")
    private UserAccount createdBy;
    @Column(nullable = false)
    private String title;
    @Column(nullable = false, columnDefinition = "TEXT")
    private String content;
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private NotificationType type = NotificationType.ALL;
    @Column(nullable = false)
    private boolean published;
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

package ute.edu.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "announcement_reads", uniqueConstraints = @UniqueConstraint(columnNames = {"notification_id", "user_id"}))
/** Bảng announcement_reads: lưu người dùng đã đọc thông báo nào và thời điểm đọc. */
public class AnnouncementRead {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    // Khóa chính của lượt đọc.
    private Long id;
    @ManyToOne(optional = false)
    @JoinColumn(name = "notification_id")
    // Thông báo được người dùng đọc.
    private Notification notification;
    @ManyToOne(optional = false)
    @JoinColumn(name = "user_id")
    // Người đã đọc thông báo.
    private UserAccount user;
    @Column(nullable = false)
    // Thời điểm người dùng đọc thông báo.
    private LocalDateTime readAt = LocalDateTime.now();

    public Long getId() { return id; }
    public Notification getNotification() { return notification; }
    public void setNotification(Notification value) { notification = value; }
    public UserAccount getUser() { return user; }
    public void setUser(UserAccount value) { user = value; }
    public LocalDateTime getReadAt() { return readAt; }
}

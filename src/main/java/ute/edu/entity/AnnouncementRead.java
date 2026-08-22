package ute.edu.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "announcement_reads", uniqueConstraints = @UniqueConstraint(columnNames = {"notification_id", "user_id"}))
public class AnnouncementRead {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @ManyToOne(optional = false)
    @JoinColumn(name = "notification_id")
    private Notification notification;
    @ManyToOne(optional = false)
    @JoinColumn(name = "user_id")
    private UserAccount user;
    @Column(nullable = false)
    private LocalDateTime readAt = LocalDateTime.now();

    public Long getId() { return id; }
    public Notification getNotification() { return notification; }
    public void setNotification(Notification value) { notification = value; }
    public UserAccount getUser() { return user; }
    public void setUser(UserAccount value) { user = value; }
    public LocalDateTime getReadAt() { return readAt; }
}

package ute.edu.service;

import java.util.List;
import java.time.LocalDateTime;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ute.edu.entity.Notification;
import ute.edu.entity.UserAccount;
import ute.edu.entity.AnnouncementRead;
import ute.edu.enums.NotificationType;
import ute.edu.repository.NotificationRepository;
import ute.edu.repository.AnnouncementReadRepository;

@Service
/** Service tạo, công bố, xóa và theo dõi trạng thái đọc thông báo. */
public class NotificationService {
    private final NotificationRepository notificationRepository;
    private final AnnouncementReadRepository readRepository;

    public NotificationService(NotificationRepository notificationRepository,
            AnnouncementReadRepository readRepository) {
        this.notificationRepository = notificationRepository;
        this.readRepository = readRepository;
    }

    /** Lấy tất cả thông báo cho khu vực quản trị. */
    public List<Notification> getAll() {
        return notificationRepository.findAll();
    }

    /** Lấy thông báo đã công bố phù hợp với vai trò người dùng. */
    public List<Notification> getPublishedForRole(String role) {
        if ("STUDENT".equalsIgnoreCase(role)) {
            return notificationRepository.findByPublishedTrueOrderByCreatedAtDesc().stream()
                    .filter(n -> n.getType() == NotificationType.ALL || n.getType() == NotificationType.STUDENT)
                    .toList();
        } else if ("LECTURER".equalsIgnoreCase(role)) {
            return notificationRepository.findByPublishedTrueOrderByCreatedAtDesc().stream()
                    .filter(n -> n.getType() == NotificationType.ALL || n.getType() == NotificationType.LECTURER)
                    .toList();
        }
        return notificationRepository.findByPublishedTrueOrderByCreatedAtDesc();
    }

    @Transactional
    /** Tạo và tùy chọn công bố một thông báo mới. */
    public Notification create(String title, String content, NotificationType type, boolean published,
            UserAccount creator) {
        Notification notification = new Notification();
        notification.setTitle(title);
        notification.setContent(content);
        notification.setType(type);
        notification.setPublished(published);
        notification.setCreatedBy(creator);
        if (published) {
            notification.setPublishedAt(LocalDateTime.now());
        }
        return notificationRepository.save(notification);
    }

    @Transactional
    /** Đánh dấu một thông báo là đã đọc cho người dùng. */
    public void markAsRead(Long notificationId, UserAccount user) {
        if (user == null || notificationId == null)
            return;
        if (!readRepository.existsByNotificationIdAndUserId(notificationId, user.getId())) {
            Notification n = notificationRepository.findById(notificationId).orElse(null);
            if (n != null) {
                AnnouncementRead read = new AnnouncementRead();
                read.setNotification(n);
                read.setUser(user);
                readRepository.save(read);
            }
        }
    }

    /** Kiểm tra người dùng đã đọc thông báo chưa. */
    public boolean isRead(Long notificationId, Long userId) {
        if (userId == null || notificationId == null)
            return false;
        return readRepository.existsByNotificationIdAndUserId(notificationId, userId);
    }

    @Transactional
    /** Đánh dấu toàn bộ danh sách thông báo là đã đọc. */
    public void markAllAsRead(List<Notification> notifications, UserAccount user) {
        if (user == null || notifications == null)
            return;
        for (Notification notification : notifications) {
            markAsRead(notification.getId(), user);
        }
    }

    @Transactional
    /** Đổi trạng thái công bố hoặc ẩn thông báo. */
    public void togglePublish(Long id) {
        Notification n = notificationRepository.findById(id).orElse(null);
        if (n != null) {
            n.setPublished(!n.isPublished());
            if (n.isPublished() && n.getPublishedAt() == null) {
                n.setPublishedAt(LocalDateTime.now());
            }
            notificationRepository.save(n);
        }
    }

    @Transactional
    /** Xóa thông báo theo mã. */
    public void delete(Long id) {
        notificationRepository.deleteById(id);
    }
}

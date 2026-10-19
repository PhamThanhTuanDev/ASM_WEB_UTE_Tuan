package ute.edu.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import ute.edu.enums.NotificationType;
import ute.edu.entity.Notification;

/** Truy vấn bảng notifications (thông báo). */
public interface NotificationRepository extends JpaRepository<Notification, Long> {
    /** Lấy thông báo đã công bố, mới nhất trước. */
    List<Notification> findByPublishedTrueOrderByCreatedAtDescIdDesc();

    /** Lấy thông báo đã công bố theo nhóm người nhận. */
    List<Notification> findByTypeAndPublishedTrueOrderByCreatedAtDescIdDesc(NotificationType type);
}

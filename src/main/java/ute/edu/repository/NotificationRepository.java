package ute.edu.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import ute.edu.enums.NotificationType;
import ute.edu.entity.Notification;

public interface NotificationRepository extends JpaRepository<Notification, Long> {
    List<Notification> findByPublishedTrueOrderByCreatedAtDesc();
    List<Notification> findByTypeAndPublishedTrueOrderByCreatedAtDesc(NotificationType type);
}

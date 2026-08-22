package ute.edu.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import ute.edu.entity.AnnouncementRead;

public interface AnnouncementReadRepository extends JpaRepository<AnnouncementRead, Long> {
    boolean existsByNotificationIdAndUserId(Long notificationId, Long userId);
    List<AnnouncementRead> findByUserId(Long userId);
}

package ute.edu.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import ute.edu.entity.AnnouncementRead;

/** Truy vấn bảng announcement_reads (lịch sử đọc thông báo). */
public interface AnnouncementReadRepository extends JpaRepository<AnnouncementRead, Long> {
    @org.springframework.data.jpa.repository.Modifying
    @org.springframework.data.jpa.repository.Query(value = "INSERT INTO announcement_reads (notification_id,user_id,read_at) VALUES (:notificationId,:userId,CURRENT_TIMESTAMP) ON DUPLICATE KEY UPDATE id=id", nativeQuery = true)
    void markReadIfAbsent(@org.springframework.data.repository.query.Param("notificationId") Long notificationId,
                          @org.springframework.data.repository.query.Param("userId") Long userId);
    /** Kiểm tra người dùng đã đọc thông báo chưa. */
    boolean existsByNotificationIdAndUserId(Long notificationId, Long userId);

    /** Lấy lịch sử đọc của một người dùng. */
    List<AnnouncementRead> findByUserId(Long userId);
}

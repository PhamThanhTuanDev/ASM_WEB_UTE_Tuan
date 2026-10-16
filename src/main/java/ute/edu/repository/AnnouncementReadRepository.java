package ute.edu.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import ute.edu.entity.AnnouncementRead;

/** Truy vấn bảng announcement_reads (lịch sử đọc thông báo). */
public interface AnnouncementReadRepository extends JpaRepository<AnnouncementRead, Long> {
    /** Kiểm tra người dùng đã đọc thông báo chưa. */
    boolean existsByNotificationIdAndUserId(Long notificationId, Long userId);
    /** Lấy lịch sử đọc của một người dùng. */
    List<AnnouncementRead> findByUserId(Long userId);
    /** Lấy ID các thông báo người dùng đã đọc — 1 truy vấn thay cho N lần exists. */
    @Query("select r.notification.id from AnnouncementRead r where r.user.id = :userId")
    List<Long> findNotificationIdsByUserId(@Param("userId") Long userId);
}

package ute.edu.controller;

import jakarta.servlet.http.HttpSession;
import java.util.Collections;
import java.util.List;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;
import ute.edu.entity.Notification;
import ute.edu.entity.UserAccount;
import ute.edu.service.NotificationService;

@ControllerAdvice
/** Cung cấp dữ liệu dùng chung cho các trang JSP. */
public class GlobalModelAdvice {

    private final NotificationService notificationService;

    public GlobalModelAdvice(NotificationService notificationService) {
        this.notificationService = notificationService;
    }

    @ModelAttribute("unreadNotifCount")
    /** Đếm số thông báo chưa đọc của người dùng hiện tại. */
    public int getUnreadNotificationsCount(HttpSession session) {
        UserAccount user = (UserAccount) session.getAttribute("user");
        if (user == null) return 0;
        String roleStr = user.getRole() != null ? user.getRole().name() : "STUDENT";
        List<Notification> userNotifs = notificationService.getPublishedForRole(roleStr);
        int unread = 0;
        for (Notification n : userNotifs) {
            if (!notificationService.isRead(n.getId(), user.getId())) {
                unread++;
            }
        }
        return unread;
    }

    @ModelAttribute("topNotifications")
    /** Lấy một số thông báo mới nhất để hiển thị trên thanh điều hướng. */
    public List<Notification> getTopNotifications(HttpSession session) {
        UserAccount user = (UserAccount) session.getAttribute("user");
        if (user == null) return Collections.emptyList();
        String roleStr = user.getRole() != null ? user.getRole().name() : "STUDENT";
        List<Notification> notifs = notificationService.getPublishedForRole(roleStr);
        if (notifs.size() > 5) {
            return notifs.subList(0, 5);
        }
        return notifs;
    }
}

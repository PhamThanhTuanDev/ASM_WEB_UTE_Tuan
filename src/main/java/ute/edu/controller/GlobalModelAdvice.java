package ute.edu.controller;

import jakarta.servlet.http.HttpSession;
import java.util.Collections;
import java.util.List;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;
import ute.edu.entity.Notification;
import ute.edu.entity.UserAccount;
import ute.edu.helper.EnumLabelFormatter;
import ute.edu.service.NotificationService;

@ControllerAdvice
/** Cung cấp dữ liệu dùng chung cho các trang JSP. */
public class GlobalModelAdvice {

    private final NotificationService notificationService;
    private final EnumLabelFormatter enumLabel;

    public GlobalModelAdvice(NotificationService notificationService, EnumLabelFormatter enumLabel) {
        this.notificationService = notificationService;
        this.enumLabel = enumLabel;
    }

    @ModelAttribute("enumLabel")
    public EnumLabelFormatter getEnumLabelFormatter() {
        return enumLabel;
    }

    @ModelAttribute("unreadNotifCount")
    /** Đếm số thông báo chưa đọc của người dùng hiện tại. */
    public int getUnreadNotificationsCount(HttpSession session) {
        UserAccount user = (UserAccount) session.getAttribute("user");
        if (user == null) return 0;
        // Tải danh sách 1 lần và đếm, tránh gọi isRead() lặp thêm lần nữa
        return (int) getUnreadNotifications(session).size();
    }

    @ModelAttribute("unreadNotifyCount")
    /** Alias của unreadNotifCount — dùng bởi header.jsp. Tái sử dụng cùng 1 helper. */
    public int getUnreadNotifyCountAlias(HttpSession session) {
        return getUnreadNotificationsCount(session);
    }

    @ModelAttribute("topNotifications")
    /** Lấy tối đa 5 thông báo chưa đọc để hiển thị trên thanh điều hướng. */
    public List<Notification> getTopNotifications(HttpSession session) {
        List<Notification> unread = getUnreadNotifications(session);
        return unread.size() > 5 ? unread.subList(0, 5) : unread;
    }

    /**
     * Tải danh sách thông báo chưa đọc của user hiện tại.
     * Tập trung logic vào 1 chỗ để @ModelAttribute tái sử dụng,
     * tránh gọi getPublishedForRole() nhiều lần trên cùng 1 request.
     */
    private List<Notification> getUnreadNotifications(HttpSession session) {
        UserAccount user = (UserAccount) session.getAttribute("user");
        if (user == null) return Collections.emptyList();
        String roleStr = user.getRole() != null ? user.getRole().name() : "STUDENT";
        return notificationService.getPublishedForRole(roleStr).stream()
                .filter(n -> !notificationService.isRead(n.getId(), user.getId()))
                .toList();
    }
}

package ute.edu.controller;

import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.HttpServletRequest;
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
    private final ute.edu.helper.DateDisplayFormatter dateDisplay = new ute.edu.helper.DateDisplayFormatter();

    @ModelAttribute("dateDisplay")
    public ute.edu.helper.DateDisplayFormatter getDateDisplayFormatter() {
        return dateDisplay;
    }
    @org.springframework.beans.factory.annotation.Value("${app.demo.quick-login:false}")
    private boolean quickLoginEnabled;

    @ModelAttribute("quickLoginEnabled")
    public boolean isQuickLoginEnabled() {
        return quickLoginEnabled;
    }

    public static void refreshNotificationModel(NotificationService service, UserAccount user, org.springframework.ui.Model model) {
        List<Notification> unread = user == null ? Collections.emptyList() : service.getUnreadForUser(user);
        model.addAttribute("unreadNotifCount", unread.size());
        model.addAttribute("unreadNotifyCount", unread.size());
        model.addAttribute("topNotifications", unread.stream().limit(5).toList());
    }

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
    public int getUnreadNotificationsCount(HttpSession session, HttpServletRequest request) {
        UserAccount user = (UserAccount) session.getAttribute("user");
        if (user == null) return 0;
        // Tải danh sách 1 lần và đếm, tránh gọi isRead() lặp thêm lần nữa
        return (int) getUnreadNotifications(session, request).size();
    }

    @ModelAttribute("unreadNotifyCount")
    /** Alias của unreadNotifCount — dùng bởi header.jsp. Tái sử dụng cùng 1 helper. */
    public int getUnreadNotifyCountAlias(HttpSession session, HttpServletRequest request) {
        return getUnreadNotificationsCount(session, request);
    }

    @ModelAttribute("topNotifications")
    /** Lấy tối đa 5 thông báo chưa đọc để hiển thị trên thanh điều hướng. */
    public List<Notification> getTopNotifications(HttpSession session, HttpServletRequest request) {
        List<Notification> unread = getUnreadNotifications(session, request);
        return unread.size() > 5 ? unread.subList(0, 5) : unread;
    }

    /**
     * Tải danh sách thông báo chưa đọc của user hiện tại.
     * Tập trung logic vào 1 chỗ để @ModelAttribute tái sử dụng,
     * tránh gọi getPublishedForRole() nhiều lần trên cùng 1 request.
     */
    private List<Notification> getUnreadNotifications(HttpSession session, HttpServletRequest request) {
        UserAccount user = (UserAccount) session.getAttribute("user");
        if (user == null) return Collections.emptyList();
        Object cached = request.getAttribute(GlobalModelAdvice.class.getName());
        if (cached instanceof UnreadCache cache && cache.userId().equals(user.getId())) return cache.notifications();
        List<Notification> unread = notificationService.getUnreadForUser(user);
        request.setAttribute(GlobalModelAdvice.class.getName(), new UnreadCache(user.getId(), unread));
        return unread;
    }

    private record UnreadCache(Long userId, List<Notification> notifications) {}
}

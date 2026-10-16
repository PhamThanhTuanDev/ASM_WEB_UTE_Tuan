package ute.edu.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.util.Collections;
import java.util.List;
import java.util.Set;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;
import ute.edu.entity.Notification;
import ute.edu.entity.UserAccount;
import ute.edu.helper.EnumLabelFormatter;
import ute.edu.service.NotificationService;

@ControllerAdvice
/** Cung cấp dữ liệu dùng chung cho các trang JSP. */
public class GlobalModelAdvice {

    /** Tên attribute dùng để nhớ kết quả trong phạm vi 1 request. */
    private static final String UNREAD_CACHE_ATTR = GlobalModelAdvice.class.getName() + ".unread";

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
        return getUnreadNotifications(session, request).size();
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
     *
     * Tối ưu hiệu năng (tránh lỗi N+1 truy vấn):
     * - Trước đây: 3 @ModelAttribute ở trên đều gọi lại hàm này, và mỗi thông báo
     *   lại gọi isRead() = 1 truy vấn DB → 3 x (1 + số thông báo) truy vấn mỗi trang.
     * - Bây giờ: lấy 1 lần tập ID "đã đọc" (1 truy vấn) rồi lọc trong bộ nhớ,
     *   và nhớ kết quả trong request → cả trang chỉ tốn 2 truy vấn.
     */
    @SuppressWarnings("unchecked")
    private List<Notification> getUnreadNotifications(HttpSession session, HttpServletRequest request) {
        Object cached = request.getAttribute(UNREAD_CACHE_ATTR);
        if (cached instanceof List<?> cachedList) {
            return (List<Notification>) cachedList;
        }

        UserAccount user = (UserAccount) session.getAttribute("user");
        List<Notification> unread;
        if (user == null) {
            unread = Collections.emptyList();
        } else {
            String roleStr = user.getRole() != null ? user.getRole().name() : "STUDENT";
            Set<Long> readIds = notificationService.getReadNotificationIds(user.getId());
            unread = notificationService.getPublishedForRole(roleStr).stream()
                    .filter(n -> !readIds.contains(n.getId()))
                    .toList();
        }
        request.setAttribute(UNREAD_CACHE_ATTR, unread);
        return unread;
    }
}

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <c:set var="pageTitle" value="Thông báo khoa" />
            <c:set var="pageHeading" value="Thông báo từ ban chủ nhiệm khoa CNTT" />
            <c:set var="pageSubheading"
                value="Các văn bản, quyết định và kế hoạch hướng dẫn đề tài, hội đồng phản biện" />
            <c:set var="activeMenu" value="notifications" />

            <jsp:include page="../common/header.jsp" />
            <jsp:include page="../common/sidebar.jsp" />

            <div class="app-main">
                <jsp:include page="../common/navbar.jsp" />

                <main class="app-content workspace-page space-y-6">
                    <div class="space-y-4" data-pagination-list>
                        <c:forEach var="n" items="${notifications}">
                            <c:set var="isRead" value="${readNotificationIds != null ? readNotificationIds.contains(n.id) : notificationService.isRead(n.id, currentUser.id)}" />
                            <div id="notification-${n.id}" data-notification-id="${n.id}" data-pagination-item
                                data-pagination-priority="${isRead ? 1 : 0}">
                                <div
                                    class="bg-white rounded-3xl border ${!isRead ? 'border-sky-400 shadow-md ring-1 ring-sky-300' : 'border-slate-200 shadow-sm'} p-6 transition-all">
                                    <div class="flex flex-col sm:flex-row sm:items-start justify-between gap-3 mb-3">
                                        <div class="space-y-1">
                                            <div class="flex items-center gap-2 flex-wrap">
                                                <h4 class="font-bold text-slate-900 text-base leading-snug">${n.title}
                                                </h4>
                                                <c:if test="${!isRead}">
                                                    <span class="status-badge status-danger">MỚI / CHƯA ĐỌC</span>
                                                </c:if>
                                            </div>
                                            <div class="text-xs text-slate-500 flex items-center gap-2">
                                                <i data-lucide="clock" class="w-3.5 h-3.5 text-slate-400"></i>
                                                <span>Ngày đăng: <strong>${n.publishedAt != null ? n.publishedAt :
                                                        n.createdAt}</strong> &bull; Đăng bởi: ${n.createdBy != null ?
                                                    n.createdBy.fullName : 'Ban Chủ nhiệm Khoa'}</span>
                                            </div>
                                        </div>
                                        <span
                                            class="status-badge ${n.type == 'ALL' ? 'status-info' : 'status-pending'} self-start">
                                            ${enumLabel.label(n.type)}
                                        </span>
                                    </div>

                                    <p
                                        class="text-xs text-slate-700 leading-relaxed bg-slate-50 p-4 rounded-2xl border border-slate-200/80 whitespace-pre-line">
                                        ${n.content}
                                    </p>

                                    <c:if test="${!isRead}">
                                        <form method="post"
                                            action="${pageContext.request.contextPath}/lecturer/notifications/${n.id}/read"
                                            class="text-right mt-3">
                                            <button type="submit" class="btn-ui btn-ui-outline text-xs py-1.5 px-3">
                                                <i data-lucide="check-check" class="w-3.5 h-3.5 text-sky-600"></i> Đánh
                                                dấu đã đọc
                                            </button>
                                        </form>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>
                        <c:if test="${empty notifications}">
                            <div class="empty-state py-12 bg-white rounded-3xl border border-slate-200 shadow-sm">
                                <div class="empty-state-icon-wrap w-12 h-12 mb-2">
                                    <i data-lucide="bell-off" class="w-6 h-6 opacity-40"></i>
                                </div>
                                <div class="empty-state-desc text-xs mb-0">Không có thông báo mới nào</div>
                            </div>
                        </c:if>
                    </div>
                </main>

                <jsp:include page="../common/footer.jsp" />
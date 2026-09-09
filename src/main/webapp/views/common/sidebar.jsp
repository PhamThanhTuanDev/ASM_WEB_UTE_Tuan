<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="uri" value="${pageContext.request.requestURI}" />
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="dashboardRole" value="${sessionScope.userRole == 'ADMIN' || sessionScope.userRole == 'DEAN' || sessionScope.userRole == 'DEPARTMENT_HEAD' ? 'admin' : sessionScope.userRole == 'LECTURER' ? 'lecturer' : 'student'}" />

<aside class="app-sidebar fixed top-0 bottom-0 left-0 z-50 w-64 bg-slate-900 text-slate-300 flex flex-col border-r border-slate-800 transition-all duration-300 shadow-xl select-none">
    <div class="h-20 px-5 flex items-center justify-center border-b border-slate-800 bg-slate-950/40">
        <div class="sidebar-brand-text flex items-center justify-center w-full">
           <a href="${ctx}/${dashboardRole}/dashboard" data-page-loader class="sidebar-logo-link flex items-center gap-3 min-w-0 group">
            <img width="80" height="80" src="${ctx}/assets/img/logo/logo_nav_hcmute.png" alt="HCMUTE Logo" class="w-[80px] h-[80px] object-contain shrink-0 group-hover:scale-105 transition-transform">
        </a>
        </div>
    </div>

    <div class="flex-1 overflow-y-auto px-3 py-4 space-y-4">
        <c:choose>
            <c:when test="${sessionScope.userRole == 'ADMIN' || sessionScope.userRole == 'DEAN' || sessionScope.userRole == 'DEPARTMENT_HEAD'}">
                <div>
                    <div class="nav-section-title px-3 mb-2 text-[10px] font-bold uppercase tracking-wider text-slate-500">Tổng quan & điều hành</div>
                    <div class="space-y-1">
                        <a href="${ctx}/admin/dashboard"
                           class="flex items-center gap-3 px-3 py-2.5 rounded-xl text-xs font-semibold transition-all duration-300 ${fn:contains(uri, '/admin/dashboard') || activeMenu == 'dashboard' ? 'bg-blue-600 text-white shadow-md shadow-blue-600/30' : 'text-slate-400 hover:text-white hover:bg-slate-800/80'}"
                           title="Bảng điều khiển">
                            <i data-lucide="layout-dashboard" class="w-4 h-4 shrink-0"></i>
                            <span class="nav-label">Bảng điều khiển</span>
                        </a>
                        <a href="${ctx}/admin/periods"
                           class="flex items-center gap-3 px-3 py-2.5 rounded-xl text-xs font-semibold transition-all duration-300 ${fn:contains(uri, '/admin/periods') || activeMenu == 'periods' ? 'bg-blue-600 text-white shadow-md shadow-blue-600/30' : 'text-slate-400 hover:text-white hover:bg-slate-800/80'}"
                           title="Đợt đăng ký">
                            <i data-lucide="calendar-range" class="w-4 h-4 shrink-0"></i>
                            <span class="nav-label">Đợt đăng ký</span>
                        </a>
                    </div>
                </div>

                <div>
                    <div class="nav-section-title px-3 mb-2 text-[10px] font-bold uppercase tracking-wider text-slate-500">Quản lý đề tài & nhóm</div>
                    <div class="space-y-1">
                        <a href="${ctx}/admin/topics"
                           class="flex items-center gap-3 px-3 py-2.5 rounded-xl text-xs font-semibold transition-all duration-300 ${fn:contains(uri, '/admin/topics') || fn:contains(uri, '/admin/registrations') || activeMenu == 'topics' || activeMenu == 'registrations' ? 'bg-blue-600 text-white shadow-md shadow-blue-600/30' : 'text-slate-400 hover:text-white hover:bg-slate-800/80'}"
                           title="Đề tài & Duyệt">
                            <i data-lucide="book-open-check" class="w-4 h-4 shrink-0"></i>
                            <span class="nav-label">Đề tài &amp; duyệt</span>
                        </a>
                        <a href="${ctx}/admin/groups"
                           class="flex items-center gap-3 px-3 py-2.5 rounded-xl text-xs font-semibold transition-all duration-300 ${fn:contains(uri, '/admin/groups') || activeMenu == 'groups' ? 'bg-blue-600 text-white shadow-md shadow-blue-600/30' : 'text-slate-400 hover:text-white hover:bg-slate-800/80'}"
                           title="Nhóm Sinh viên">
                            <i data-lucide="users-round" class="w-4 h-4 shrink-0"></i>
                            <span class="nav-label">Nhóm sinh viên</span>
                        </a>
                    </div>
                </div>

                <div>
                    <div class="nav-section-title px-3 mb-2 text-[10px] font-bold uppercase tracking-wider text-slate-500">Hội đồng & đánh giá</div>
                    <div class="space-y-1">
                        <a href="${ctx}/admin/councils"
                           class="flex items-center gap-3 px-3 py-2.5 rounded-xl text-xs font-semibold transition-all duration-300 ${fn:contains(uri, '/admin/councils') || activeMenu == 'councils' ? 'bg-blue-600 text-white shadow-md shadow-blue-600/30' : 'text-slate-400 hover:text-white hover:bg-slate-800/80'}"
                           title="Hội đồng Phản biện">
                            <i data-lucide="scale" class="w-4 h-4 shrink-0"></i>
                            <span class="nav-label">Hội đồng phản biện</span>
                        </a>
                        <a href="${ctx}/admin/reports"
                           class="flex items-center gap-3 px-3 py-2.5 rounded-xl text-xs font-semibold transition-all duration-300 ${fn:contains(uri, '/admin/reports') || activeMenu == 'reports' ? 'bg-blue-600 text-white shadow-md shadow-blue-600/30' : 'text-slate-400 hover:text-white hover:bg-slate-800/80'}"
                           title="Báo cáo Đề tài">
                            <i data-lucide="file-up" class="w-4 h-4 shrink-0"></i>
                            <span class="nav-label">Báo cáo đề tài</span>
                        </a>
                        <a href="${ctx}/admin/results"
                           class="flex items-center gap-3 px-3 py-2.5 rounded-xl text-xs font-semibold transition-all duration-300 ${fn:contains(uri, '/admin/results') || activeMenu == 'results' ? 'bg-blue-600 text-white shadow-md shadow-blue-600/30' : 'text-slate-400 hover:text-white hover:bg-slate-800/80'}"
                           title="Điểm số & Kết quả">
                            <i data-lucide="award" class="w-4 h-4 shrink-0"></i>
                            <span class="nav-label">Điểm số & kết quả</span>
                        </a>
                    </div>
                </div>

                <div>
                    <div class="nav-section-title px-3 mb-2 text-[10px] font-bold uppercase tracking-wider text-slate-500">Hệ thống</div>
                    <div class="space-y-1">
                        <a href="${ctx}/admin/notifications"
                           class="flex items-center justify-between px-3 py-2.5 rounded-xl text-xs font-semibold transition-all duration-300 ${fn:contains(uri, '/admin/notifications') || activeMenu == 'notifications' ? 'bg-blue-600 text-white shadow-md shadow-blue-600/30' : 'text-slate-400 hover:text-white hover:bg-slate-800/80'}"
                           title="Thông báo Khoa">
                            <div class="flex items-center gap-3">
                                <i data-lucide="bell" class="w-4 h-4 shrink-0"></i>
                                <span class="nav-label">Thông báo khoa</span>
                            </div>
                            <c:if test="${unreadNotifCount != null && unreadNotifCount > 0}">
                                <span class="nav-badge px-1.5 py-0.5 rounded-full text-[10px] font-bold bg-rose-500 text-white leading-none">${unreadNotifCount}</span>
                            </c:if>
                        </a>
                        <a href="${ctx}/admin/users"
                           class="flex items-center gap-3 px-3 py-2.5 rounded-xl text-xs font-semibold transition-all duration-300 ${fn:contains(uri, '/admin/users') || activeMenu == 'users' ? 'bg-blue-600 text-white shadow-md shadow-blue-600/30' : 'text-slate-400 hover:text-white hover:bg-slate-800/80'}"
                           title="Tài khoản & Hồ sơ">
                            <i data-lucide="contact" class="w-4 h-4 shrink-0"></i>
                            <span class="nav-label">Tài khoản & hồ sơ</span>
                        </a>
                    </div>
                </div>
            </c:when>

            <c:when test="${sessionScope.userRole == 'LECTURER'}">
                <div>
                    <div class="nav-section-title px-3 mb-2 text-[10px] font-bold uppercase tracking-wider text-slate-500">Giảng viên nghiên cứu</div>
                    <div class="space-y-1">
                        <a href="${ctx}/lecturer/dashboard"
                           class="flex items-center gap-3 px-3 py-2.5 rounded-xl text-xs font-semibold transition-all duration-300 ${fn:contains(uri, '/lecturer/dashboard') || activeMenu == 'dashboard' ? 'bg-blue-600 text-white shadow-md shadow-blue-600/30' : 'text-slate-400 hover:text-white hover:bg-slate-800/80'}"
                           title="Bảng điều khiển">
                            <i data-lucide="layout-dashboard" class="w-4 h-4 shrink-0"></i>
                            <span class="nav-label">Bảng điều khiển</span>
                        </a>
                        <a href="${ctx}/lecturer/topics"
                           class="flex items-center gap-3 px-3 py-2.5 rounded-xl text-xs font-semibold transition-all duration-300 ${fn:contains(uri, '/lecturer/topics') || activeMenu == 'topics' ? 'bg-blue-600 text-white shadow-md shadow-blue-600/30' : 'text-slate-400 hover:text-white hover:bg-slate-800/80'}"
                           title="Đề xuất Đề tài">
                            <i data-lucide="file-plus" class="w-4 h-4 shrink-0"></i>
                            <span class="nav-label">Đề xuất đề tài</span>
                        </a>
                        <a href="${ctx}/lecturer/groups"
                           class="flex items-center gap-3 px-3 py-2.5 rounded-xl text-xs font-semibold transition-all duration-300 ${fn:contains(uri, '/lecturer/groups') || activeMenu == 'groups' ? 'bg-blue-600 text-white shadow-md shadow-blue-600/30' : 'text-slate-400 hover:text-white hover:bg-slate-800/80'}"
                           title="Nhóm Hướng dẫn">
                            <i data-lucide="users" class="w-4 h-4 shrink-0"></i>
                            <span class="nav-label">Nhóm hướng dẫn</span>
                        </a>
                    </div>
                </div>
                <div>
                    <div class="nav-section-title px-3 mb-2 text-[10px] font-bold uppercase tracking-wider text-slate-500">Hội đồng & báo cáo</div>
                    <div class="space-y-1">
                        <a href="${ctx}/lecturer/councils"
                           class="flex items-center gap-3 px-3 py-2.5 rounded-xl text-xs font-semibold transition-all duration-300 ${fn:contains(uri, '/lecturer/councils') || fn:contains(uri, '/lecturer/grading') || activeMenu == 'councils' ? 'bg-blue-600 text-white shadow-md shadow-blue-600/30' : 'text-slate-400 hover:text-white hover:bg-slate-800/80'}"
                           title="Hội đồng & Chấm điểm">
                            <i data-lucide="scale" class="w-4 h-4 shrink-0"></i>
                            <span class="nav-label">Hội đồng & chấm điểm</span>
                        </a>
                        <a href="${ctx}/lecturer/reports"
                           class="flex items-center gap-3 px-3 py-2.5 rounded-xl text-xs font-semibold transition-all duration-300 ${fn:contains(uri, '/lecturer/reports') || activeMenu == 'reports' ? 'bg-blue-600 text-white shadow-md shadow-blue-600/30' : 'text-slate-400 hover:text-white hover:bg-slate-800/80'}"
                           title="Xem Báo cáo SV">
                            <i data-lucide="folder-check" class="w-4 h-4 shrink-0"></i>
                            <span class="nav-label">Xem báo cáo SV</span>
                        </a>
                        <a href="${ctx}/lecturer/notifications"
                           class="flex items-center justify-between px-3 py-2.5 rounded-xl text-xs font-semibold transition-all duration-300 ${fn:contains(uri, '/lecturer/notifications') || activeMenu == 'notifications' ? 'bg-blue-600 text-white shadow-md shadow-blue-600/30' : 'text-slate-400 hover:text-white hover:bg-slate-800/80'}"
                           title="Thông báo Khoa">
                            <div class="flex items-center gap-3">
                                <i data-lucide="bell" class="w-4 h-4 shrink-0"></i>
                                <span class="nav-label">Thông báo khoa</span>
                            </div>
                            <c:if test="${unreadNotifCount != null && unreadNotifCount > 0}">
                                <span class="nav-badge px-1.5 py-0.5 rounded-full text-[10px] font-bold bg-rose-500 text-white leading-none">${unreadNotifCount}</span>
                            </c:if>
                        </a>
                    </div>
                </div>
            </c:when>

            <c:otherwise>
                <div>
                    <div class="nav-section-title px-3 mb-2 text-[10px] font-bold uppercase tracking-wider text-slate-500">Sinh viên thực hiện</div>
                    <div class="space-y-1">
                        <a href="${ctx}/student/dashboard"
                           class="flex items-center gap-3 px-3 py-2.5 rounded-xl text-xs font-semibold transition-all duration-300 ${fn:contains(uri, '/student/dashboard') || activeMenu == 'dashboard' ? 'bg-blue-600 text-white shadow-md shadow-blue-600/30' : 'text-slate-400 hover:text-white hover:bg-slate-800/80'}"
                           title="Bảng điều khiển">
                            <i data-lucide="layout-dashboard" class="w-4 h-4 shrink-0"></i>
                            <span class="nav-label">Bảng điều khiển</span>
                        </a>
                        <a href="${ctx}/student/topics"
                           class="flex items-center gap-3 px-3 py-2.5 rounded-xl text-xs font-semibold transition-all duration-300 ${fn:contains(uri, '/student/topics') || activeMenu == 'topics' ? 'bg-blue-600 text-white shadow-md shadow-blue-600/30' : 'text-slate-400 hover:text-white hover:bg-slate-800/80'}"
                           title="Tra cứu Đề tài">
                            <i data-lucide="search" class="w-4 h-4 shrink-0"></i>
                            <span class="nav-label">Tra cứu đề tài</span>
                        </a>
                        <a href="${ctx}/student/group"
                           class="flex items-center gap-3 px-3 py-2.5 rounded-xl text-xs font-semibold transition-all duration-300 ${fn:contains(uri, '/student/group') || activeMenu == 'group' ? 'bg-blue-600 text-white shadow-md shadow-blue-600/30' : 'text-slate-400 hover:text-white hover:bg-slate-800/80'}"
                           title="Nhóm của tôi">
                            <i data-lucide="users-round" class="w-4 h-4 shrink-0"></i>
                            <span class="nav-label">Nhóm của tôi</span>
                        </a>
                    </div>
                </div>
                <div>
                    <div class="nav-section-title px-3 mb-2 text-[10px] font-bold uppercase tracking-wider text-slate-500">Tiến độ & kết quả</div>
                    <div class="space-y-1">
                        <a href="${ctx}/student/reports"
                           class="flex items-center gap-3 px-3 py-2.5 rounded-xl text-xs font-semibold transition-all duration-300 ${fn:contains(uri, '/student/reports') || activeMenu == 'reports' ? 'bg-blue-600 text-white shadow-md shadow-blue-600/30' : 'text-slate-400 hover:text-white hover:bg-slate-800/80'}"
                           title="Nộp Báo cáo">
                            <i data-lucide="cloud-upload" class="w-4 h-4 shrink-0"></i>
                            <span class="nav-label">Nộp báo cáo</span>
                        </a>
                        <a href="${ctx}/student/results"
                           class="flex items-center gap-3 px-3 py-2.5 rounded-xl text-xs font-semibold transition-all duration-300 ${fn:contains(uri, '/student/results') || activeMenu == 'results' ? 'bg-blue-600 text-white shadow-md shadow-blue-600/30' : 'text-slate-400 hover:text-white hover:bg-slate-800/80'}"
                           title="Lịch & Điểm số">
                            <i data-lucide="trophy" class="w-4 h-4 shrink-0"></i>
                            <span class="nav-label">Lịch & điểm số</span>
                        </a>
                        <a href="${ctx}/student/notifications"
                           class="flex items-center justify-between px-3 py-2.5 rounded-xl text-xs font-semibold transition-all duration-300 ${fn:contains(uri, '/student/notifications') || activeMenu == 'notifications' ? 'bg-blue-600 text-white shadow-md shadow-blue-600/30' : 'text-slate-400 hover:text-white hover:bg-slate-800/80'}"
                           title="Thông báo Khoa">
                            <div class="flex items-center gap-3">
                                <i data-lucide="bell" class="w-4 h-4 shrink-0"></i>
                                <span class="nav-label">Thông báo khoa</span>
                            </div>
                            <c:if test="${unreadNotifCount != null && unreadNotifCount > 0}">
                                <span class="nav-badge px-1.5 py-0.5 rounded-full text-[10px] font-bold bg-rose-500 text-white leading-none">${unreadNotifCount}</span>
                            </c:if>
                        </a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>

        <div>
            <div class="nav-section-title px-3 mb-2 text-[10px] font-bold uppercase tracking-wider text-slate-500">Cổng thông tin</div>
                <a href="${ctx}/home"
                    class="flex items-center gap-3 px-3 py-2.5 rounded-xl text-xs font-semibold text-slate-400 hover:text-white hover:bg-slate-800/80 transition-all duration-300"
                    title="Trang chủ Portal">
                <i data-lucide="external-link" class="w-4 h-4 shrink-0 text-blue-400"></i>
                <span class="nav-label">Trang chủ Portal</span>
            </a>
        </div>
    </div>

    <div class="p-3 border-t border-slate-800 bg-slate-950/60">
        <div class="flex items-center gap-3 p-2 rounded-xl bg-slate-900/80 border border-slate-800/80">
            <div class="w-8 h-8 rounded-lg bg-gradient-to-tr from-blue-600 to-indigo-600 text-white font-bold text-xs flex items-center justify-center shrink-0">
                ${fn:substring(sessionScope.user != null ? sessionScope.user.fullName : 'U', 0, 1)}
            </div>
            <div class="sidebar-user-meta flex-1 min-w-0">
                <div class="text-xs font-bold text-white truncate">
                    ${sessionScope.user != null ? sessionScope.user.fullName : 'Khách'}
                </div>
                <div class="text-[10px] text-slate-400 font-medium">
                    <c:choose>
                        <c:when test="${sessionScope.userRole == 'ADMIN'}"><span class="px-1.5 py-0.5 rounded bg-rose-500/20 text-rose-300 font-bold">ADMIN</span></c:when>
                        <c:when test="${sessionScope.userRole == 'DEAN'}"><span class="px-1.5 py-0.5 rounded bg-blue-500/20 text-blue-300 font-bold">DEAN</span></c:when>
                        <c:when test="${sessionScope.userRole == 'LECTURER'}"><span class="px-1.5 py-0.5 rounded bg-amber-500/20 text-amber-300 font-bold">LECTURER</span></c:when>
                        <c:otherwise><span class="px-1.5 py-0.5 rounded bg-emerald-500/20 text-emerald-300 font-bold">STUDENT</span></c:otherwise>
                    </c:choose>
                </div>
            </div>
            <a href="${ctx}/logout" class="text-slate-400 hover:text-rose-400 p-1 rounded-lg hover:bg-slate-800 transition-colors" title="Đăng xuất">
                <i data-lucide="log-out" class="w-3.5 h-3.5"></i>
            </a>
        </div>
    </div>
</aside>

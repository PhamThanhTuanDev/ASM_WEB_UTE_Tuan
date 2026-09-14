<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

            <!-- 1-Click Demo Role Switcher Toolbar -->
            <div class="demo-role-bar hidden md:flex">
                <div class="demo-title">
                    <span class="flex h-2 w-2 relative">
                        <span
                            class="animate-ping absolute inline-flex h-full w-full rounded-full bg-amber-400 opacity-75"></span>
                        <span class="relative inline-flex rounded-full h-2 w-2 bg-amber-500"></span>
                    </span>
                    <i data-lucide="zap" class="w-3.5 h-3.5 text-amber-400"></i>
                    <span>Chuyển đổi vai trò thử nghiệm:</span>
                </div>
                <div class="demo-role-pills">
                    <a href="${pageContext.request.contextPath}/quick-login?username=admin@hcmute.edu.vn"
                        class="demo-pill ${sessionScope.user.role == 'ADMIN' ? 'is-active' : ''}"
                        title="Quản trị hệ thống">
                        <i data-lucide="shield-check" class="w-3 h-3 text-rose-400"></i> Admin
                    </a>
                    <a href="${pageContext.request.contextPath}/quick-login?username=dean.fit@hcmute.edu.vn"
                        class="demo-pill ${sessionScope.user.role == 'DEAN' ? 'is-active' : ''}"
                        title="Trưởng khoa: PGS.TS Trần Minh Tuấn">
                        <i data-lucide="award" class="w-3 h-3 text-sky-400"></i> Trưởng khoa
                    </a>
                    <a href="${pageContext.request.contextPath}/quick-login?username=25810176@teacher.hcmute.edu.vn"
                        class="demo-pill ${sessionScope.user.email == '25810176@teacher.hcmute.edu.vn' ? 'is-active' : ''}"
                        title="TS. Nguyễn Văn An - GVHD">
                        <i data-lucide="user-check" class="w-3 h-3 text-emerald-400"></i> TS. An (GVHD)
                    </a>
                    <a href="${pageContext.request.contextPath}/quick-login?username=25810178@teacher.hcmute.edu.vn"
                        class="demo-pill ${sessionScope.user.email == '25810178@teacher.hcmute.edu.vn' ? 'is-active' : ''}"
                        title="PGS. Lê Hoàng Cường - Chủ tịch HĐ">
                        <i data-lucide="scale" class="w-3 h-3 text-purple-400"></i> PGS. Cường (Chủ tịch HĐ)
                    </a>
                    <a href="${pageContext.request.contextPath}/quick-login?username=25810176@student.hcmute.edu.vn"
                        class="demo-pill ${sessionScope.user.email == '25810176@student.hcmute.edu.vn' ? 'is-active' : ''}"
                        title="Sinh viên Nguyễn Văn Minh - Nhóm trưởng">
                        <i data-lucide="graduation-cap" class="w-3 h-3 text-amber-400"></i> SV Minh (Nhóm trưởng)
                    </a>
                </div>
            </div>

            <!-- Sticky Main Navbar -->
            <header class="app-topbar">
                <div class="flex items-center gap-3.5 min-w-0">
                    <!-- Sidebar Toggle -->
                    <button id="sidebarToggleBtn" type="button" class="sidebar-toggle-btn"
                        aria-label="Đóng/mở thanh điều hướng">
                        <i data-lucide="menu" class="w-6 h-6"></i>
                    </button>
                    <div class="topbar-title-wrap min-w-0">
                        <!-- SaaS Breadcrumb Navigation -->
                        <nav class="app-breadcrumb text-xs sm:text-sm flex items-center gap-1.5 sm:gap-2 min-w-0" aria-label="Đường dẫn trang">
                            <span class="hidden sm:inline-flex items-center gap-1.5 shrink-0">
                                <a href="${pageContext.request.contextPath}/home" title="Trang chủ Portal"
                                    class="inline-flex items-center gap-1 font-medium text-slate-500 hover:text-sky-700">
                                    <i data-lucide="home" class="w-3.5 h-3.5"></i>
                                    <span>Trang chủ</span>
                                </a>
                                <i data-lucide="chevron-right" class="w-3.5 h-3.5 text-slate-300"></i>
                                <c:choose>
                                    <c:when test="${sessionScope.userRole == 'ADMIN'}">
                                        <a href="${pageContext.request.contextPath}/admin/dashboard"
                                            class="font-medium text-slate-500 hover:text-sky-700">Admin</a>
                                    </c:when>
                                    <c:when test="${sessionScope.userRole == 'DEAN'}">
                                        <a href="${pageContext.request.contextPath}/admin/dashboard"
                                            class="font-medium text-slate-500 hover:text-sky-700">Trưởng khoa</a>
                                    </c:when>
                                    <c:when test="${sessionScope.userRole == 'LECTURER'}">
                                        <a href="${pageContext.request.contextPath}/lecturer/dashboard"
                                            class="font-medium text-slate-500 hover:text-sky-700">Giảng viên</a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/student/dashboard"
                                            class="font-medium text-slate-500 hover:text-sky-700">Sinh viên</a>
                                    </c:otherwise>
                                </c:choose>
                                <i data-lucide="chevron-right" class="w-3.5 h-3.5 text-slate-300"></i>
                            </span>
                            <span class="current truncate max-w-[130px] xs:max-w-[180px] sm:max-w-[340px] font-bold text-slate-900">
                                ${pageTitle != null ? pageTitle : 'Bảng điều khiển'}
                            </span>
                        </nav>
                    </div>
                </div>

                <div class="flex items-center gap-3">
                    <!-- Search Button for Mobile -->
                    <button class="topbar-icon-btn md:hidden" type="button" data-open-command-palette
                        title="Tìm kiếm nhanh">
                        <i data-lucide="search" class="w-4 h-4"></i>
                    </button>

                    <!-- Notification Dropdown -->
                    <div class="dropdown relative">
                        <button class="topbar-icon-btn" type="button" data-bs-toggle="dropdown" aria-expanded="false"
                            title="Thông báo">
                            <i data-lucide="bell" class="w-4 h-4"></i>
                            <c:if test="${unreadNotifCount != null && unreadNotifCount > 0}">
                                <span class="topbar-notif-badge"></span>
                            </c:if>
                        </button>
                        <div class="dropdown-menu dropdown-menu-end notif-dropdown mt-2 z-50">
                            <div class="notif-dropdown-header">
                                <div class="flex items-center gap-2">
                                    <i data-lucide="bell-ring" class="w-4 h-4 text-amber-300"></i>
                                    <h6>Thông báo hệ thống</h6>
                                </div>
                                <c:choose>
                                    <c:when test="${unreadNotifCount != null && unreadNotifCount > 0}">
                                        <span class="notif-count-badge bg-rose-500 text-white">
                                            ${unreadNotifCount} mới
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="notif-count-badge bg-emerald-500/80 text-white">
                                            Đã đọc
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="notif-list divide-y divide-slate-100">
                                <c:choose>
                                    <c:when test="${empty topNotifications}">
                                        <div class="empty-state py-6">
                                            <div class="empty-state-icon-wrap w-10 h-10 mb-2">
                                                <i data-lucide="inbox" class="w-5 h-5 opacity-40"></i>
                                            </div>
                                            <div class="empty-state-desc text-xs mb-0">Không có thông báo mới nào</div>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="notif" items="${topNotifications}">
                                            <c:set var="notifTargetUrl"
                                                value="${sessionScope.userRole == 'ADMIN' || sessionScope.userRole == 'DEAN' || sessionScope.userRole == 'DEPARTMENT_HEAD' ? '/admin/notifications' : sessionScope.userRole == 'LECTURER' ? '/lecturer/notifications' : '/student/notifications'}" />
                                            <a href="${pageContext.request.contextPath}${notifTargetUrl}?notificationId=${notif.id}"
                                                class="notif-item group">
                                                <div class="flex justify-between items-start gap-2">
                                                    <div
                                                        class="notif-item-title group-hover:text-sky-600 transition-colors">
                                                        ${notif.title}
                                                    </div>
                                                    <span class="badge badge--info shrink-0 text-[9px] py-0 px-1.5">
                                                        ${notif.type}
                                                    </span>
                                                </div>
                                                <div class="notif-item-body">
                                                    ${notif.content}
                                                </div>
                                            </a>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="notif-dropdown-footer">
                                <c:set var="allNotifUrl"
                                    value="${sessionScope.userRole == 'ADMIN' || sessionScope.userRole == 'DEAN' || sessionScope.userRole == 'DEPARTMENT_HEAD' ? '/admin/notifications' : sessionScope.userRole == 'LECTURER' ? '/lecturer/notifications' : '/student/notifications'}" />
                                <a href="${pageContext.request.contextPath}${allNotifUrl}"
                                    class="text-xs font-bold text-sky-600 hover:text-sky-700 inline-flex items-center gap-1">
                                    Xem tất cả thông báo <i data-lucide="chevron-right" class="w-3.5 h-3.5"></i>
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- User Profile Dropdown -->
                    <div class="dropdown relative">
                        <button class="topbar-user-btn" type="button" data-bs-toggle="dropdown">
                            <div class="topbar-user-avatar">
                                ${fn:substring(sessionScope.user != null ? sessionScope.user.fullName : 'U', 0, 1)}
                            </div>
                            <div class="text-left hidden sm:block">
                                <div class="topbar-user-name">
                                    ${sessionScope.user != null ? sessionScope.user.fullName : 'Tài khoản'}
                                </div>
                                <div class="topbar-user-role">
                                    ${sessionScope.userRole}
                                </div>
                            </div>
                            <i data-lucide="chevron-down" class="w-3.5 h-3.5 text-slate-400 ml-0.5"></i>
                        </button>
                        <div class="dropdown-menu dropdown-menu-end user-dropdown mt-2 z-50">
                            <div class="user-dropdown-profile">
                                <div class="font-bold text-xs text-slate-800">${sessionScope.user != null ?
                                    sessionScope.user.fullName : ''}</div>
                                <div class="text-[11px] text-slate-500 truncate">${sessionScope.user != null ?
                                    sessionScope.user.email : ''}</div>
                                <div class="mt-2">
                                    <c:choose>
                                        <c:when test="${sessionScope.userRole == 'ADMIN'}"><span
                                                class="badge badge--admin">ADMIN</span></c:when>
                                        <c:when test="${sessionScope.userRole == 'DEAN'}"><span
                                                class="badge badge--dean">TRƯỞNG KHOA</span></c:when>
                                        <c:when test="${sessionScope.userRole == 'LECTURER'}"><span
                                                class="badge badge--lecturer">GIẢNG VIÊN</span></c:when>
                                        <c:otherwise><span class="badge badge--student">SINH VIÊN</span></c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <a class="user-dropdown-item" href="${pageContext.request.contextPath}/home">
                                <i data-lucide="globe" class="w-4 h-4 text-sky-500"></i> Cổng thông tin HCMUTE
                            </a>
                            <hr class="my-1 border-slate-100">
                            <a class="user-dropdown-item danger" href="${pageContext.request.contextPath}/logout">
                                <i data-lucide="log-out" class="w-4 h-4 text-rose-500"></i> Đăng xuất tài khoản
                            </a>
                        </div>
                    </div>
                </div>
            </header>

            <!-- Global Command Palette Modal (Ctrl + K) -->
            <div id="searchCommandModal" class="command-palette-backdrop" role="dialog" aria-modal="true"
                aria-label="Tìm kiếm hoặc điều hướng nhanh">
                <div class="command-palette-box">
                    <div class="relative flex items-center">
                        <i data-lucide="search" class="w-4 h-4 text-slate-400 absolute left-4 pointer-events-none"></i>
                        <input type="text" class="command-palette-input pl-11 pr-14"
                            placeholder="Tìm kiếm trang, chức năng hoặc đề tài..." autocomplete="off">
                        <span
                            class="absolute right-4 text-[10px] font-bold text-slate-400 bg-slate-100 px-1.5 py-0.5 rounded border border-slate-200">ESC</span>
                    </div>
                    <div class="command-palette-list">
                        <div class="px-3 py-1.5 text-[10px] font-bold uppercase tracking-wider text-slate-400">Điều
                            hướng nhanh</div>
                        <c:choose>
                            <c:when
                                test="${sessionScope.userRole == 'ADMIN' || sessionScope.userRole == 'DEAN' || sessionScope.userRole == 'DEPARTMENT_HEAD'}">
                                <a href="${pageContext.request.contextPath}/admin/dashboard" class="command-item">
                                    <i data-lucide="layout-dashboard" class="w-4 h-4 text-sky-600"></i>
                                    <span>Bảng điều khiển Quản trị</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/periods" class="command-item">
                                    <i data-lucide="calendar-range" class="w-4 h-4 text-amber-600"></i>
                                    <span>Quản lý đợt đăng ký khóa luận</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/topics" class="command-item">
                                    <i data-lucide="book-open-check" class="w-4 h-4 text-emerald-600"></i>
                                    <span>Quản lý đề tài &amp; Phê duyệt</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/groups" class="command-item">
                                    <i data-lucide="users-round" class="w-4 h-4 text-indigo-600"></i>
                                    <span>Quản lý nhóm sinh viên</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/councils" class="command-item">
                                    <i data-lucide="scale" class="w-4 h-4 text-purple-600"></i>
                                    <span>Quản lý hội đồng phản biện</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/users" class="command-item">
                                    <i data-lucide="user-cog" class="w-4 h-4 text-rose-600"></i>
                                    <span>Quản lý tài khoản người dùng</span>
                                </a>
                            </c:when>
                            <c:when test="${sessionScope.userRole == 'LECTURER'}">
                                <a href="${pageContext.request.contextPath}/lecturer/dashboard" class="command-item">
                                    <i data-lucide="layout-dashboard" class="w-4 h-4 text-sky-600"></i>
                                    <span>Bảng điều khiển Giảng viên</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/lecturer/topics" class="command-item">
                                    <i data-lucide="file-plus-2" class="w-4 h-4 text-emerald-600"></i>
                                    <span>Đề xuất đề tài nghiên cứu</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/lecturer/groups" class="command-item">
                                    <i data-lucide="users" class="w-4 h-4 text-amber-600"></i>
                                    <span>Quản lý nhóm sinh viên hướng dẫn</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/lecturer/councils" class="command-item">
                                    <i data-lucide="scale" class="w-4 h-4 text-purple-600"></i>
                                    <span>Hội đồng phản biện &amp; Chấm điểm</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/lecturer/reports" class="command-item">
                                    <i data-lucide="file-check" class="w-4 h-4 text-indigo-600"></i>
                                    <span>Xem báo cáo sinh viên</span>
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/student/dashboard" class="command-item">
                                    <i data-lucide="layout-dashboard" class="w-4 h-4 text-sky-600"></i>
                                    <span>Bảng điều khiển Sinh viên</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/student/topics" class="command-item">
                                    <i data-lucide="search" class="w-4 h-4 text-emerald-600"></i>
                                    <span>Tra cứu &amp; Đăng ký đề tài</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/student/group" class="command-item">
                                    <i data-lucide="users" class="w-4 h-4 text-amber-600"></i>
                                    <span>Nhóm sinh viên của tôi</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/student/reports" class="command-item">
                                    <i data-lucide="cloud-upload" class="w-4 h-4 text-indigo-600"></i>
                                    <span>Nộp báo cáo tiến độ / cuối kỳ</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/student/results" class="command-item">
                                    <i data-lucide="award" class="w-4 h-4 text-purple-600"></i>
                                    <span>Xem kết quả &amp; Lịch hội đồng</span>
                                </a>
                            </c:otherwise>
                        </c:choose>
                        <div
                            class="px-3 py-1.5 mt-2 text-[10px] font-bold uppercase tracking-wider text-slate-400 border-t border-slate-100">
                            Liên kết chung</div>
                        <a href="${pageContext.request.contextPath}/home" class="command-item">
                            <i data-lucide="globe" class="w-4 h-4 text-sky-500"></i>
                            <span>Cổng thông tin HCMUTE Portal</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/logout"
                            class="command-item text-rose-600 hover:text-rose-700">
                            <i data-lucide="log-out" class="w-4 h-4 text-rose-500"></i>
                            <span>Đăng xuất khỏi hệ thống</span>
                        </a>
                    </div>
                </div>
            </div>
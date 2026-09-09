<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- 1-Click Demo Role Switcher Header Bar -->
<div class="bg-gradient-to-r from-slate-900 via-blue-900 to-indigo-950 text-white px-4 py-2 text-xs border-b border-slate-700/50 hidden md:flex items-center justify-between shadow-inner">
    <div class="flex items-center gap-2">
        <span class="flex h-2 w-2 relative">
            <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-amber-400 opacity-75"></span>
            <span class="relative inline-flex rounded-full h-2 w-2 bg-amber-500"></span>
        </span>
        <strong class="text-amber-400 font-semibold tracking-wide flex items-center gap-1.5">
            <i data-lucide="zap" class="w-3.5 h-3.5"></i> Bộ chuyển vai trò thử nghiệm:
        </strong>
        <span class="text-slate-300">Chuyển đổi vai trò nhanh để kiểm thử giao diện & phân quyền:</span>
    </div>
    <div class="flex items-center gap-1.5 flex-wrap">
        <a href="${pageContext.request.contextPath}/quick-login?username=admin@hcmute.edu.vn" 
           class="px-2.5 py-1 rounded-full text-xs font-semibold transition-all duration-200 flex items-center gap-1 ${sessionScope.user.role == 'ADMIN' ? 'bg-white text-blue-900 shadow-sm ring-2 ring-blue-400' : 'bg-slate-800/80 hover:bg-slate-700 text-slate-200'}" 
           title="Quản trị hệ thống">
            <i data-lucide="shield-check" class="w-3.5 h-3.5 text-rose-400"></i> Admin
        </a>
        <a href="${pageContext.request.contextPath}/quick-login?username=dean.fit@hcmute.edu.vn" 
           class="px-2.5 py-1 rounded-full text-xs font-semibold transition-all duration-200 flex items-center gap-1 ${sessionScope.user.role == 'DEAN' ? 'bg-white text-blue-900 shadow-sm ring-2 ring-blue-400' : 'bg-slate-800/80 hover:bg-slate-700 text-slate-200'}" 
           title="Trưởng khoa: PGS.TS Trần Minh Tuấn - dean.fit@hcmute.edu.vn">
            <i data-lucide="award" class="w-3.5 h-3.5 text-blue-400"></i> Trưởng khoa (Dean)
        </a>
          <a href="${pageContext.request.contextPath}/quick-login?username=25810176@teacher.hcmute.edu.vn" 
              class="px-2.5 py-1 rounded-full text-xs font-semibold transition-all duration-200 flex items-center gap-1 ${sessionScope.user.email == '25810176@teacher.hcmute.edu.vn' ? 'bg-white text-blue-900 shadow-sm ring-2 ring-blue-400' : 'bg-slate-800/80 hover:bg-slate-700 text-slate-200'}" 
           title="TS. Nguyễn Văn An - GVHD">
            <i data-lucide="user-check" class="w-3.5 h-3.5 text-emerald-400"></i> TS. Nguyễn Văn An (GVHD)
        </a>
          <a href="${pageContext.request.contextPath}/quick-login?username=25810178@teacher.hcmute.edu.vn" 
              class="px-2.5 py-1 rounded-full text-xs font-semibold transition-all duration-200 flex items-center gap-1 ${sessionScope.user.email == '25810178@teacher.hcmute.edu.vn' ? 'bg-white text-blue-900 shadow-sm ring-2 ring-blue-400' : 'bg-slate-800/80 hover:bg-slate-700 text-slate-200'}" 
           title="PGS. Lê Hoàng Cường - Chủ tịch HĐ">
            <i data-lucide="scale" class="w-3.5 h-3.5 text-purple-400"></i> PGS. Lê H. Cường (Chủ tịch HĐ)
        </a>
          <a href="${pageContext.request.contextPath}/quick-login?username=25810176@student.hcmute.edu.vn" 
              class="px-2.5 py-1 rounded-full text-xs font-semibold transition-all duration-200 flex items-center gap-1 ${sessionScope.user.email == '25810176@student.hcmute.edu.vn' ? 'bg-white text-blue-900 shadow-sm ring-2 ring-blue-400' : 'bg-slate-800/80 hover:bg-slate-700 text-slate-200'}" 
           title="Sinh viên Nguyễn Văn Minh - Nhóm trưởng">
            <i data-lucide="graduation-cap" class="w-3.5 h-3.5 text-amber-400"></i> SV Minh (Nhóm trưởng)
        </a>
    </div>
</div>

<!-- Sticky Main Navbar -->
<header class="sticky top-0 z-40 bg-white/85 backdrop-blur-md border-b border-slate-200 px-6 py-3.5 flex items-center justify-between shadow-xs transition-all duration-200">
    <div class="flex items-center gap-4">
        <!-- Sidebar Toggle for Mobile / Desktop Collapsible -->
        <button id="sidebarToggleBtn" type="button" class="p-2 rounded-lg text-slate-500 hover:text-slate-700 hover:bg-slate-100 transition-colors focus:outline-none focus:ring-2 focus:ring-blue-500">
            <i data-lucide="menu" class="w-5 h-5"></i>
        </button>
        <div>
            <h1 class="text-lg font-bold text-slate-900 tracking-tight leading-tight flex items-center gap-2">
                ${pageHeading != null ? pageHeading : 'Hệ thống quản lý đề tài'}
            </h1>
            <p class="text-xs text-slate-500 font-medium hidden sm:block">
                ${pageSubheading != null ? pageSubheading : 'Khoa Công nghệ Thông tin - Trường ĐH Sư phạm Kỹ thuật TP.HCM'}
            </p>
        </div>
    </div>

    <div class="flex items-center gap-3">
        <!-- Notification Dropdown with Red Pulse Badge -->
        <div class="dropdown relative">
            <button class="relative p-2.5 rounded-full text-slate-500 hover:text-slate-700 hover:bg-slate-100 transition-all duration-200 focus:outline-none" 
                    type="button" 
                    data-bs-toggle="dropdown" 
                    aria-expanded="false"
                    title="Thông báo">
                <i data-lucide="bell" class="w-5 h-5"></i>
                <c:if test="${unreadNotifCount != null && unreadNotifCount > 0}">
                    <span class="absolute top-1 right-1 flex h-4 w-4 items-center justify-center">
                        <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-rose-400 opacity-75"></span>
                        <span class="relative inline-flex rounded-full h-3.5 w-3.5 bg-rose-600 text-[9px] font-bold text-white items-center justify-center leading-none">
                            ${unreadNotifCount > 9 ? '9+' : unreadNotifCount}
                        </span>
                    </span>
                </c:if>
            </button>
            <div class="dropdown-menu dropdown-menu-end shadow-xl border border-slate-100 p-0 rounded-2xl w-80 sm:w-96 overflow-hidden mt-2 z-50">
                <div class="bg-gradient-to-r from-blue-600 to-indigo-700 p-4 text-white">
                    <div class="flex justify-between items-center">
                        <div class="flex items-center gap-2">
                            <i data-lucide="bell-ring" class="w-4 h-4 text-amber-300"></i>
                            <h6 class="font-bold text-sm">Thông báo hệ thống</h6>
                        </div>
                        <c:choose>
                            <c:when test="${unreadNotifCount != null && unreadNotifCount > 0}">
                                <span class="bg-rose-500/90 text-white text-[11px] font-bold px-2 py-0.5 rounded-full">
                                    ${unreadNotifCount} chưa đọc
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="bg-emerald-500/80 text-white text-[11px] font-medium px-2 py-0.5 rounded-full">
                                    Đã đọc hết
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="max-h-72 overflow-y-auto divide-y divide-slate-100 p-2">
                    <c:choose>
                        <c:when test="${empty topNotifications}">
                            <div class="text-center py-6 text-slate-400 text-xs">
                                <i data-lucide="inbox" class="w-8 h-8 mx-auto mb-1.5 opacity-40"></i>
                                Không có thông báo nào mới.
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="notif" items="${topNotifications}">
                                <c:set var="notifTargetUrl" value="${sessionScope.userRole == 'ADMIN' || sessionScope.userRole == 'DEAN' ? '/admin/notifications' : sessionScope.userRole == 'LECTURER' ? '/lecturer/notifications' : '/student/notifications'}" />
                                <a href="${pageContext.request.contextPath}${notifTargetUrl}" 
                                   class="block p-3 rounded-xl hover:bg-slate-50 transition-colors text-slate-700 group">
                                    <div class="flex justify-between items-start gap-2">
                                        <h6 class="font-semibold text-xs text-slate-800 group-hover:text-blue-600 transition-colors line-clamp-1">
                                            ${notif.title}
                                        </h6>
                                        <span class="text-[10px] font-medium px-1.5 py-0.5 rounded bg-blue-50 text-blue-700 shrink-0">
                                            ${notif.type}
                                        </span>
                                    </div>
                                    <p class="text-[11px] text-slate-500 line-clamp-2 mt-1">
                                        ${notif.content}
                                    </p>
                                </a>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="bg-slate-50 p-2.5 border-t border-slate-100 text-center">
                    <c:set var="allNotifUrl" value="${sessionScope.userRole == 'ADMIN' || sessionScope.userRole == 'DEAN' ? '/admin/notifications' : sessionScope.userRole == 'LECTURER' ? '/lecturer/notifications' : '/student/notifications'}" />
                    <a href="${pageContext.request.contextPath}${allNotifUrl}" class="text-xs font-semibold text-blue-600 hover:text-blue-700 inline-flex items-center gap-1">
                        Xem toàn bộ thông báo <i data-lucide="chevron-right" class="w-3.5 h-3.5"></i>
                    </a>
                </div>
            </div>
        </div>

        <!-- User Profile Dropdown -->
        <div class="dropdown relative">
            <button class="flex items-center gap-2.5 p-1.5 pr-3 rounded-full hover:bg-slate-100 transition-all duration-200 border border-slate-200/80 shadow-xs focus:outline-none" 
                    type="button" 
                    data-bs-toggle="dropdown">
                <div class="w-8 h-8 rounded-full bg-gradient-to-tr from-blue-600 to-indigo-600 text-white font-bold text-sm flex items-center justify-center shadow-xs">
                    ${fn:substring(sessionScope.user != null ? sessionScope.user.fullName : 'U', 0, 1)}
                </div>
                <div class="text-left hidden sm:block">
                    <div class="text-xs font-bold text-slate-800 leading-tight">
                        ${sessionScope.user != null ? sessionScope.user.fullName : 'Tài khoản'}
                    </div>
                    <div class="text-[10px] font-semibold text-slate-500">
                        ${sessionScope.userRole}
                    </div>
                </div>
                <i data-lucide="chevron-down" class="w-4 h-4 text-slate-400 ml-0.5"></i>
            </button>
            <ul class="dropdown-menu dropdown-menu-end shadow-xl border border-slate-100 p-2 rounded-2xl w-60 z-50 mt-2">
                <li class="p-3 bg-slate-50 rounded-xl mb-1 border border-slate-100">
                    <div class="font-bold text-xs text-slate-800">${sessionScope.user != null ? sessionScope.user.fullName : ''}</div>
                    <div class="text-[11px] text-slate-500 truncate">${sessionScope.user != null ? sessionScope.user.email : ''}</div>
                    <div class="mt-1.5">
                        <c:choose>
                            <c:when test="${sessionScope.userRole == 'ADMIN'}">
                                <span class="px-2 py-0.5 rounded-md text-[10px] font-bold bg-rose-100 text-rose-800 border border-rose-200">ADMIN</span>
                            </c:when>
                            <c:when test="${sessionScope.userRole == 'DEAN'}">
                                <span class="px-2 py-0.5 rounded-md text-[10px] font-bold bg-blue-100 text-blue-800 border border-blue-200">TRƯỞNG KHOA</span>
                            </c:when>
                            <c:when test="${sessionScope.userRole == 'LECTURER'}">
                                <span class="px-2 py-0.5 rounded-md text-[10px] font-bold bg-amber-100 text-amber-800 border border-amber-200">GIẢNG VIÊN</span>
                            </c:when>
                            <c:otherwise>
                                <span class="px-2 py-0.5 rounded-md text-[10px] font-bold bg-emerald-100 text-emerald-800 border border-emerald-200">SINH VIÊN</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </li>
                <li>
                    <a class="flex items-center gap-2 px-3 py-2 text-xs font-medium text-slate-700 hover:bg-blue-50 hover:text-blue-600 rounded-lg transition-colors" 
                       href="${pageContext.request.contextPath}/home">
                        <i data-lucide="globe" class="w-4 h-4 text-blue-500"></i> Cổng thông tin HCMUTE
                    </a>
                </li>
                <li><hr class="my-1 border-slate-100"></li>
                <li>
                    <a class="flex items-center gap-2 px-3 py-2 text-xs font-semibold text-rose-600 hover:bg-rose-50 rounded-lg transition-colors" 
                       href="${pageContext.request.contextPath}/logout">
                        <i data-lucide="log-out" class="w-4 h-4 text-rose-500"></i> Đăng xuất tài khoản
                    </a>
                </li>
            </ul>
        </div>
    </div>
</header>

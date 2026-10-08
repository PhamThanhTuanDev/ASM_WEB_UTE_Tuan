<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <c:set var="ctx" value="${pageContext.request.contextPath}" />
        <c:set var="roleName" value="${sessionScope.user.role}" />
        <c:set var="uri" value="${pageContext.request.requestURI}" />

        <aside id="uteSidebar"
            class="fixed lg:static inset-y-16 lg:inset-y-auto left-0 z-30 w-64 bg-white border-r border-slate-200 flex flex-col transform -translate-x-full lg:translate-x-0 transition-transform duration-200">
            <div class="px-4 py-4 border-b border-slate-100">
                <div class="text-[10px] font-bold uppercase tracking-widest text-ute-light">Menu chức năng</div>
                <div class="text-sm font-extrabold text-ute mt-1">
                    <c:choose>
                        <c:when test="${roleName == 'LECTURER'}">Giảng viên</c:when>
                        <c:when test="${roleName == 'STUDENT'}">Sinh viên</c:when>
                        <c:otherwise>Hệ thống</c:otherwise>
                    </c:choose>
                </div>
            </div>

            <nav class="flex-1 overflow-y-auto px-3 py-4 space-y-1">
                <c:choose>
                    <c:when test="${roleName == 'LECTURER'}">
                        <a href="${ctx}/lecturer/dashboard"
                            class="sidebar-link flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-semibold text-slate-600 hover:bg-ute-50 ${activeMenu == 'dashboard' ? 'active' : ''}">
                            <i data-lucide="layout-dashboard" class="w-4 h-4 text-ute-light"></i> Dashboard
                        </a>
                        <a href="${ctx}/lecturer/groups"
                            class="sidebar-link flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-semibold text-slate-600 hover:bg-ute-50 ${activeMenu == 'classes' || activeMenu == 'groups' ? 'active' : ''}">
                            <i data-lucide="school" class="w-4 h-4 text-ute-light"></i> Quản lý lớp học phần
                        </a>
                        <a href="${ctx}/lecturer/topics"
                            class="sidebar-link flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-semibold text-slate-600 hover:bg-ute-50 ${activeMenu == 'topics' ? 'active' : ''}">
                            <i data-lucide="folder-kanban" class="w-4 h-4 text-ute-light"></i> Danh sách đồ án
                        </a>
                        <a href="${ctx}/lecturer/reports"
                            class="sidebar-link flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-semibold text-slate-600 hover:bg-ute-50 ${activeMenu == 'grading' || activeMenu == 'reports' ? 'active' : ''}">
                            <i data-lucide="clipboard-check" class="w-4 h-4 text-ute-light"></i> Chấm điểm bài nộp
                        </a>
                        <a href="${ctx}/lecturer/dashboard"
                            class="sidebar-link flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-semibold text-slate-600 hover:bg-ute-50 ${activeMenu == 'stats' ? 'active' : ''}">
                            <i data-lucide="bar-chart-3" class="w-4 h-4 text-ute-light"></i> Thống kê báo cáo
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="${ctx}/student/dashboard"
                            class="sidebar-link flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-semibold text-slate-600 hover:bg-ute-50 ${activeMenu == 'dashboard' ? 'active' : ''}">
                            <i data-lucide="layout-dashboard" class="w-4 h-4 text-ute-light"></i> Dashboard
                        </a>
                        <a href="${ctx}/student/topics"
                            class="sidebar-link flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-semibold text-slate-600 hover:bg-ute-50 ${activeMenu == 'courses' || activeMenu == 'topics' ? 'active' : ''}">
                            <i data-lucide="book-open" class="w-4 h-4 text-ute-light"></i> Danh sách môn học
                        </a>
                        <a href="${ctx}/student/projects"
                            class="sidebar-link flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-semibold text-slate-600 hover:bg-ute-50 ${activeMenu == 'project' ? 'active' : ''}">
                            <i data-lucide="folder" class="w-4 h-4 text-ute-light"></i> Đồ án của tôi
                        </a>
                        <a href="${ctx}/student/reports"
                            class="sidebar-link flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-semibold text-slate-600 hover:bg-ute-50 ${activeMenu == 'submit' || activeMenu == 'reports' ? 'active' : ''}">
                            <i data-lucide="upload-cloud" class="w-4 h-4 text-ute-light"></i> Nộp bài
                        </a>
                        <a href="${ctx}/student/results"
                            class="sidebar-link flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-semibold text-slate-600 hover:bg-ute-50 ${activeMenu == 'defense' ? 'active' : ''}">
                            <i data-lucide="calendar-clock" class="w-4 h-4 text-ute-light"></i> Lịch bảo vệ
                        </a>
                        <a href="${ctx}/student/results"
                            class="sidebar-link flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-semibold text-slate-600 hover:bg-ute-50 ${activeMenu == 'results' ? 'active' : ''}">
                            <i data-lucide="award" class="w-4 h-4 text-ute-light"></i> Kết quả
                        </a>
                    </c:otherwise>
                </c:choose>
            </nav>
            <div class="p-4 text-[11px] text-slate-400 border-t border-slate-100">
                Khoa CNTT · HCMUTE · 2026
            </div>
        </aside>
        <div id="uteSidebarOverlay" class="hidden lg:hidden fixed inset-0 top-16 bg-slate-900/40 z-20"></div>
        <main class="flex-1 min-w-0 p-4 lg:p-6">
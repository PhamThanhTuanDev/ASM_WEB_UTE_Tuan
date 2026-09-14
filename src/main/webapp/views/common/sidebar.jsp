<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

            <c:set var="uri" value="${pageContext.request.requestURI}" />
            <c:set var="ctx" value="${pageContext.request.contextPath}" />
            <c:set var="dashboardRole"
                value="${sessionScope.userRole == 'ADMIN' || sessionScope.userRole == 'DEAN' || sessionScope.userRole == 'DEPARTMENT_HEAD' ? 'admin' : sessionScope.userRole == 'LECTURER' ? 'lecturer' : 'student'}" />

            <aside
                class="app-sidebar fixed top-0 bottom-0 left-0 z-50 flex flex-col transition-all duration-300 select-none">
                <!-- Brand Header -->
                <div class="sidebar-brand items-center justify-center">
                    <a href="${ctx}/${dashboardRole}/dashboard" data-page-loader class="sidebar-logo-link group">
                        <img src="${ctx}/assets/img/logo/logo_nav_hcmute.png" alt="HCMUTE Logo"
                            class="sidebar-logo-img">
                        <div class="sidebar-brand-text">
                            <span class="sidebar-product-name">ASM_WEB_UTE</span>
                        </div>
                    </a>
                </div>

                <!-- Navigation Scroll Area -->
                <div class="sidebar-nav">
                    <c:choose>
                        <%-- ADMIN & DEAN ROLE --%>
                            <c:when
                                test="${sessionScope.userRole == 'ADMIN' || sessionScope.userRole == 'DEAN' || sessionScope.userRole == 'DEPARTMENT_HEAD'}">
                                <div class="nav-group">
                                    <div class="nav-section-title">Tổng quan &amp; Điều hành</div>
                                    <div class="space-y-1">
                                        <a href="${ctx}/admin/dashboard"
                                            class="sidebar-link ${fn:contains(uri, '/admin/dashboard') || activeMenu == 'dashboard' ? 'is-active' : ''}"
                                            title="Bảng điều khiển">
                                            <i data-lucide="layout-dashboard"></i>
                                            <span class="nav-label">Bảng điều khiển</span>
                                        </a>
                                        <a href="${ctx}/admin/periods"
                                            class="sidebar-link ${fn:contains(uri, '/admin/periods') || activeMenu == 'periods' ? 'is-active' : ''}"
                                            title="Đợt đăng ký">
                                            <i data-lucide="calendar-range"></i>
                                            <span class="nav-label">Đợt đăng ký</span>
                                        </a>
                                    </div>
                                </div>

                                <div class="nav-group">
                                    <div class="nav-section-title">Quản lý Đề tài &amp; Nhóm</div>
                                    <div class="space-y-1">
                                        <a href="${ctx}/admin/topics"
                                            class="sidebar-link ${fn:contains(uri, '/admin/topics') || activeMenu == 'topics' ? 'is-active' : ''}"
                                            title="Đề tài & Duyệt">
                                            <i data-lucide="book-open-check"></i>
                                            <span class="nav-label">Đề tài &amp; Duyệt</span>
                                        </a>
                                        <a href="${ctx}/admin/registrations"
                                            class="sidebar-link ${fn:contains(uri, '/admin/registrations') || activeMenu == 'registrations' ? 'is-active' : ''}"
                                            title="Đăng ký đề tài">
                                            <i data-lucide="clipboard-pen-line"></i>
                                            <span class="nav-label">Đăng ký đề tài</span>
                                        </a>
                                        <a href="${ctx}/admin/groups"
                                            class="sidebar-link ${fn:contains(uri, '/admin/groups') || activeMenu == 'groups' ? 'is-active' : ''}"
                                            title="Nhóm sinh viên">
                                            <i data-lucide="users-round"></i>
                                            <span class="nav-label">Nhóm sinh viên</span>
                                        </a>
                                    </div>
                                </div>

                                <div class="nav-group">
                                    <div class="nav-section-title">Hội đồng &amp; Báo cáo</div>
                                    <div class="space-y-1">
                                        <a href="${ctx}/admin/councils"
                                            class="sidebar-link ${fn:contains(uri, '/admin/councils') || activeMenu == 'councils' ? 'is-active' : ''}"
                                            title="Hội đồng phản biện">
                                            <i data-lucide="scale"></i>
                                            <span class="nav-label">Hội đồng phản biện</span>
                                        </a>
                                        <a href="${ctx}/admin/reports"
                                            class="sidebar-link ${fn:contains(uri, '/admin/reports') || activeMenu == 'reports' ? 'is-active' : ''}"
                                            title="Báo cáo đề tài">
                                            <i data-lucide="file-up"></i>
                                            <span class="nav-label">Báo cáo đề tài</span>
                                        </a>
                                        <a href="${ctx}/admin/results"
                                            class="sidebar-link ${fn:contains(uri, '/admin/results') || activeMenu == 'results' ? 'is-active' : ''}"
                                            title="Điểm số & Kết quả">
                                            <i data-lucide="award"></i>
                                            <span class="nav-label">Điểm số &amp; Kết quả</span>
                                        </a>
                                    </div>
                                </div>

                                <div class="nav-group">
                                    <div class="nav-section-title">Hệ thống</div>
                                    <div class="space-y-1">
                                        <a href="${ctx}/admin/notifications"
                                            class="sidebar-link justify-between ${fn:contains(uri, '/admin/notifications') || activeMenu == 'notifications' ? 'is-active' : ''}"
                                            title="Thông báo khoa">
                                            <div class="flex items-center gap-3">
                                                <i data-lucide="bell"></i>
                                                <span class="nav-label">Thông báo khoa</span>
                                            </div>
                                            <c:if test="${unreadNotifCount != null && unreadNotifCount > 0}">
                                                <span class="nav-badge">${unreadNotifCount}</span>
                                            </c:if>
                                        </a>
                                        <a href="${ctx}/admin/users"
                                            class="sidebar-link ${fn:contains(uri, '/admin/users') || activeMenu == 'users' ? 'is-active' : ''}"
                                            title="Tài khoản & Hồ sơ">
                                            <i data-lucide="contact"></i>
                                            <span class="nav-label">Tài khoản &amp; Hồ sơ</span>
                                        </a>
                                    </div>
                                </div>
                            </c:when>

                            <%-- LECTURER ROLE --%>
                                <c:when test="${sessionScope.userRole == 'LECTURER'}">
                                    <div class="nav-group">
                                        <div class="nav-section-title">Nghiên cứu &amp; Hướng dẫn</div>
                                        <div class="space-y-1">
                                            <a href="${ctx}/lecturer/dashboard"
                                                class="sidebar-link ${fn:contains(uri, '/lecturer/dashboard') || activeMenu == 'dashboard' ? 'is-active' : ''}"
                                                title="Bảng điều khiển">
                                                <i data-lucide="layout-dashboard"></i>
                                                <span class="nav-label">Bảng điều khiển</span>
                                            </a>
                                            <a href="${ctx}/lecturer/topics"
                                                class="sidebar-link ${fn:contains(uri, '/lecturer/topics') || activeMenu == 'topics' ? 'is-active' : ''}"
                                                title="Đề xuất đề tài">
                                                <i data-lucide="file-plus"></i>
                                                <span class="nav-label">Đề xuất đề tài</span>
                                            </a>
                                            <a href="${ctx}/lecturer/groups"
                                                class="sidebar-link ${fn:contains(uri, '/lecturer/groups') || activeMenu == 'groups' ? 'is-active' : ''}"
                                                title="Nhóm hướng dẫn">
                                                <i data-lucide="users"></i>
                                                <span class="nav-label">Nhóm hướng dẫn</span>
                                            </a>
                                        </div>
                                    </div>

                                    <div class="nav-group">
                                        <div class="nav-section-title">Hội đồng &amp; Báo cáo</div>
                                        <div class="space-y-1">
                                            <a href="${ctx}/lecturer/councils"
                                                class="sidebar-link ${fn:contains(uri, '/lecturer/councils') || fn:contains(uri, '/lecturer/grading') || activeMenu == 'councils' ? 'is-active' : ''}"
                                                title="Hội đồng & Chấm điểm">
                                                <i data-lucide="scale"></i>
                                                <span class="nav-label">Hội đồng &amp; Chấm điểm</span>
                                            </a>
                                            <a href="${ctx}/lecturer/reports"
                                                class="sidebar-link ${fn:contains(uri, '/lecturer/reports') || activeMenu == 'reports' ? 'is-active' : ''}"
                                                title="Xem báo cáo SV">
                                                <i data-lucide="folder-check"></i>
                                                <span class="nav-label">Xem báo cáo SV</span>
                                            </a>
                                            <a href="${ctx}/lecturer/notifications"
                                                class="sidebar-link justify-between ${fn:contains(uri, '/lecturer/notifications') || activeMenu == 'notifications' ? 'is-active' : ''}"
                                                title="Thông báo khoa">
                                                <div class="flex items-center gap-3">
                                                    <i data-lucide="bell"></i>
                                                    <span class="nav-label">Thông báo khoa</span>
                                                </div>
                                                <c:if test="${unreadNotifCount != null && unreadNotifCount > 0}">
                                                    <span class="nav-badge">${unreadNotifCount}</span>
                                                </c:if>
                                            </a>
                                        </div>
                                    </div>
                                </c:when>

                                <%-- STUDENT ROLE --%>
                                    <c:otherwise>
                                        <div class="nav-group">
                                            <div class="nav-section-title">Sinh viên thực hiện</div>
                                            <div class="space-y-1">
                                                <a href="${ctx}/student/dashboard"
                                                    class="sidebar-link ${fn:contains(uri, '/student/dashboard') || activeMenu == 'dashboard' ? 'is-active' : ''}"
                                                    title="Bảng điều khiển">
                                                    <i data-lucide="layout-dashboard"></i>
                                                    <span class="nav-label">Bảng điều khiển</span>
                                                </a>
                                                <a href="${ctx}/student/topics"
                                                    class="sidebar-link ${fn:contains(uri, '/student/topics') || activeMenu == 'topics' ? 'is-active' : ''}"
                                                    title="Tra cứu đề tài">
                                                    <i data-lucide="search"></i>
                                                    <span class="nav-label">Tra cứu đề tài</span>
                                                </a>
                                                <a href="${ctx}/student/group"
                                                    class="sidebar-link ${fn:contains(uri, '/student/group') || activeMenu == 'group' || activeMenu == 'project' ? 'is-active' : ''}"
                                                    title="Đồ án & Nhóm của tôi">
                                                    <i data-lucide="users-round"></i>
                                                    <span class="nav-label">Đồ án &amp; Nhóm của tôi</span>
                                                </a>
                                            </div>
                                        </div>

                                        <div class="nav-group">
                                            <div class="nav-section-title">Tiến độ &amp; Kết quả</div>
                                            <div class="space-y-1">
                                                <a href="${ctx}/student/reports"
                                                    class="sidebar-link ${fn:contains(uri, '/student/reports') || activeMenu == 'reports' ? 'is-active' : ''}"
                                                    title="Nộp báo cáo">
                                                    <i data-lucide="cloud-upload"></i>
                                                    <span class="nav-label">Nộp báo cáo</span>
                                                </a>
                                                <a href="${ctx}/student/results"
                                                    class="sidebar-link ${fn:contains(uri, '/student/results') || activeMenu == 'results' ? 'is-active' : ''}"
                                                    title="Lịch & Điểm số">
                                                    <i data-lucide="trophy"></i>
                                                    <span class="nav-label">Lịch &amp; Điểm số</span>
                                                </a>
                                                <a href="${ctx}/student/notifications"
                                                    class="sidebar-link justify-between ${fn:contains(uri, '/student/notifications') || activeMenu == 'notifications' ? 'is-active' : ''}"
                                                    title="Thông báo khoa">
                                                    <div class="flex items-center gap-3">
                                                        <i data-lucide="bell"></i>
                                                        <span class="nav-label">Thông báo khoa</span>
                                                    </div>
                                                    <c:if test="${unreadNotifCount != null && unreadNotifCount > 0}">
                                                        <span class="nav-badge">${unreadNotifCount}</span>
                                                    </c:if>
                                                </a>
                                            </div>
                                        </div>
                                    </c:otherwise>
                    </c:choose>

                    <!-- Common Portal Link -->
                    <div class="nav-group">
                        <div class="nav-section-title">Cổng thông tin</div>
                        <a href="${ctx}/home" data-page-loader class="sidebar-link" title="Trang chủ Portal">
                            <i data-lucide="external-link" class="text-sky-400"></i>
                            <span class="nav-label">Trang chủ</span>
                        </a>
                    </div>
                </div>

                <!-- Sidebar Footer with User Card -->
                <div class="sidebar-footer">
                    <div class="sidebar-user-card">
                        <div class="sidebar-user-avatar">
                            ${fn:substring(sessionScope.user != null ? sessionScope.user.fullName : 'U', 0, 1)}
                        </div>
                        <div class="sidebar-user-info">
                            <div class="sidebar-user-name">
                                ${sessionScope.user != null ? sessionScope.user.fullName : 'Khách'}
                            </div>
                            <div>
                                <c:choose>
                                    <c:when test="${sessionScope.userRole == 'ADMIN'}"><span
                                            class="sidebar-user-role role-admin">ADMIN</span></c:when>
                                    <c:when test="${sessionScope.userRole == 'DEAN'}"><span
                                            class="sidebar-user-role role-dean">TRƯỞNG KHOA</span></c:when>
                                    <c:when test="${sessionScope.userRole == 'LECTURER'}"><span
                                            class="sidebar-user-role role-lecturer">GIẢNG VIÊN</span></c:when>
                                    <c:otherwise><span class="sidebar-user-role role-student">SINH VIÊN</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <a href="${ctx}/logout" class="sidebar-logout-btn" title="Đăng xuất">
                            <i data-lucide="log-out" class="w-4 h-4"></i>
                        </a>
                    </div>
                </div>
            </aside>
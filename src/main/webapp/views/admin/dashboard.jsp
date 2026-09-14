<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <c:set var="pageTitle" value="Bảng điều khiển quản trị" />
            <c:set var="pageHeading" value="Bảng điều hành &amp; Quản trị hệ thống" />
            <c:set var="pageSubheading"
                value="Tổng quan toàn diện quy trình đề tài, đợt đăng ký và hội đồng phản biện" />
            <c:set var="activeMenu" value="dashboard" />

            <jsp:include page="../common/header.jsp" />
            <jsp:include page="../common/sidebar.jsp" />

            <div class="app-main">
                <jsp:include page="../common/navbar.jsp" />

                <main class="app-content space-y-6">
                    <!-- 3D Hero Section -->
                    <section class="dashboard-hero">
                        <div class="hero-orbit" aria-hidden="true"></div>
                        <div class="hero-3d-cube" aria-hidden="true"></div>
                        <div class="academic-badge-float top-4 right-16 hidden md:inline-flex"
                            style="animation-delay: -1.8s;">
                            <i data-lucide="shield-check" class="w-3.5 h-3.5 text-sky-300"></i>
                            <span>Admin Operations</span>
                        </div>
                        <div class="floating-particle w-2 h-2 top-8 right-32 hidden md:block"
                            style="animation-delay: -1s;"></div>
                        <div class="floating-particle w-1.5 h-1.5 bottom-6 right-56 hidden md:block"
                            style="animation-delay: -3.2s;"></div>

                        <div class="relative z-10 flex flex-col lg:flex-row lg:items-center lg:justify-between gap-5">
                            <div class="space-y-2">
                                <div
                                    class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-white/10 text-sky-200 text-[10px] font-extrabold uppercase tracking-widest border border-white/15 backdrop-blur-md">
                                    <i data-lucide="sparkles" class="w-3.5 h-3.5 text-amber-300"></i>
                                    <span>Trung tâm điều hành học thuật</span>
                                </div>
                                <h2
                                    class="text-2xl sm:text-3xl font-extrabold tracking-tight text-white flex items-center gap-2.5">
                                    <span>Xin chào, ${sessionScope.user.fullName}</span>
                                    <span class="inline-block animate-bounce text-xl">👋</span>
                                </h2>
                                <p class="max-w-2xl text-xs sm:text-sm leading-relaxed text-sky-100/90 font-medium">
                                    Giám sát và điều phối chu trình đề tài tốt nghiệp, kết nối nhóm sinh viên, giảng
                                    viên hướng dẫn và hội đồng bảo vệ trong một không gian quản trị tập trung.
                                </p>
                            </div>

                            <div
                                class="flex flex-col sm:flex-row items-stretch sm:items-center gap-2.5 shrink-0 w-full sm:w-auto">
                                <a href="${pageContext.request.contextPath}/admin/periods"
                                    class="btn-ui bg-white text-blue-900 hover:bg-sky-50 shadow-md border border-white font-bold text-xs px-4 py-2.5 rounded-xl transition-all justify-center">
                                    <i data-lucide="calendar-plus" class="w-4 h-4 text-sky-600"></i> Quản lý đợt
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/notifications"
                                    class="btn-ui bg-white/10 text-white hover:bg-white/20 border border-white/20 font-bold text-xs px-4 py-2.5 rounded-xl backdrop-blur-md transition-all justify-center">
                                    <i data-lucide="megaphone" class="w-4 h-4 text-amber-300"></i> Đăng thông báo
                                </a>
                            </div>
                        </div>
                    </section>

                    <!-- Bento Grid: 4 Role-Based KPI Stat Cards -->
                    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5">
                        <!-- Stat 1: Tổng đề tài -->
                        <div class="dashboard-stat p-5" style="--stat-accent: #006da8;">
                            <div class="space-y-1 flex-1 min-w-0">
                                <div class="flex items-center justify-between">
                                    <div class="text-[10px] font-extrabold uppercase tracking-wider text-slate-400">Tổng
                                        đề tài</div>
                                </div>
                                <div class="text-3xl font-black text-slate-900 tracking-tight">${fn:length(topics)}
                                </div>
                                <div class="text-xs text-emerald-600 font-bold flex items-center gap-1 mt-1 truncate">
                                    <i data-lucide="check-circle-2" class="w-3.5 h-3.5"></i>
                                    <span>${publishedTopicCount} đề tài đã duyệt</span>
                                </div>
                                <div class="stat-mini-progress">
                                    <div class="stat-mini-progress-bar"
                                        style="width: ${fn:length(topics) > 0 ? (publishedTopicCount * 100 / fn:length(topics)) : 0}%">
                                    </div>
                                </div>
                            </div>

                        </div>

                        <!-- Stat 2: Nhóm sinh viên -->
                        <div class="dashboard-stat p-5" style="--stat-accent: #059669;">
                            <div class="space-y-1 flex-1 min-w-0">
                                <div class="flex items-center justify-between">
                                    <div class="text-[10px] font-extrabold uppercase tracking-wider text-slate-400">Nhóm
                                        sinh viên</div>

                                </div>
                                <div class="text-3xl font-black text-slate-900 tracking-tight">${groupCount}</div>
                                <div class="text-xs text-sky-600 font-bold flex items-center gap-1 mt-1 truncate">
                                    <i data-lucide="clipboard-list" class="w-3.5 h-3.5"></i>
                                    <span>${totalRegistrations} lượt đăng ký</span>
                                </div>
                                <div class="stat-mini-progress">
                                    <div class="stat-mini-progress-bar"
                                        style="width: ${groupCount > 0 ? '100%' : '15%'}"></div>
                                </div>
                            </div>

                        </div>

                        <!-- Stat 3: Hội đồng phản biện -->
                        <div class="dashboard-stat p-5" style="--stat-accent: #7c3aed;">
                            <div class="space-y-1 flex-1 min-w-0">
                                <div class="flex items-center justify-between">
                                    <div class="text-[10px] font-extrabold uppercase tracking-wider text-slate-400">Hội
                                        đồng phản biện</div>

                                </div>
                                <div class="text-3xl font-black text-slate-900 tracking-tight">${councilCount}</div>
                                <div class="text-xs text-purple-600 font-bold flex items-center gap-1 mt-1 truncate">
                                    <i data-lucide="user-check" class="w-3.5 h-3.5"></i>
                                    <span>${totalLecturers} giảng viên tham gia</span>
                                </div>
                                <div class="stat-mini-progress">
                                    <div class="stat-mini-progress-bar"
                                        style="width: ${councilCount > 0 ? '100%' : '20%'}"></div>
                                </div>
                            </div>

                        </div>

                        <!-- Stat 4: Đợt đăng ký -->
                        <div class="dashboard-stat p-5" style="--stat-accent: #d97706;">
                            <div class="space-y-1 flex-1 min-w-0">
                                <div class="flex items-center justify-between">
                                    <div class="text-[10px] font-extrabold uppercase tracking-wider text-slate-400">Đợt
                                        đăng ký</div>

                                </div>
                                <div class="text-3xl font-black text-slate-900 tracking-tight">${fn:length(periods)}
                                </div>
                                <div class="text-xs text-amber-600 font-bold flex items-center gap-1 mt-1 truncate">
                                    <i data-lucide="calendar-check" class="w-3.5 h-3.5"></i>
                                    <span>Đang hoạt động</span>
                                </div>
                                <div class="stat-mini-progress">
                                    <div class="stat-mini-progress-bar"
                                        style="width: ${fn:length(periods) > 0 ? '100%' : '30%'}"></div>
                                </div>
                            </div>

                        </div>
                    </div>

                    <!-- Middle Section: Timeline & Status Distribution -->
                    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                        <!-- Timeline of Registration Periods (2 Cols) -->
                        <div
                            class="lg:col-span-2 bg-white rounded-3xl border border-slate-200 p-6 shadow-sm flex flex-col justify-between">
                            <div class="flex items-center justify-between mb-4 pb-3 border-b border-slate-100">
                                <h3 class="text-sm font-bold text-slate-900 flex items-center gap-2">
                                    <i data-lucide="activity" class="w-4 h-4 text-sky-600"></i>
                                    <span>Tiến độ các đợt đăng ký khóa luận</span>
                                </h3>
                                <a href="${pageContext.request.contextPath}/admin/periods"
                                    class="text-xs font-bold text-sky-600 hover:text-sky-700 flex items-center gap-1">
                                    Quản lý đợt <i data-lucide="chevron-right" class="w-3.5 h-3.5"></i>
                                </a>
                            </div>

                            <div class="space-y-4 flex-1">
                                <c:if test="${empty periods}">
                                    <div class="empty-state py-8">
                                        <div class="empty-state-icon-wrap">
                                            <i data-lucide="calendar-off" class="w-6 h-6"></i>
                                        </div>
                                        <div class="empty-state-title">Chưa có đợt đăng ký nào</div>
                                        <div class="empty-state-desc">Hãy tạo đợt mới để khởi động quy trình đề tài cho
                                            sinh viên.</div>
                                    </div>
                                </c:if>

                                <c:forEach var="p" items="${dashboardPeriods}">
                                    <div
                                        class="p-4 rounded-2xl bg-slate-50 border border-slate-200/80 space-y-3 transition-all hover:bg-sky-50/30 hover:border-sky-200">
                                        <div class="flex items-center justify-between flex-wrap gap-2">
                                            <div class="flex items-center gap-2.5">
                                                <span
                                                    class="status-badge ${p.status == 'OPEN' ? 'status-approved' : 'status-neutral'}">
                                                    ${p.status}
                                                </span>
                                                <h4 class="font-bold text-xs text-slate-900">${p.name}</h4>
                                                <span
                                                    class="text-[10px] font-semibold text-slate-500 bg-white px-2 py-0.5 rounded-md border border-slate-200">
                                                    ${p.type}
                                                </span>
                                            </div>
                                            <span class="text-xs text-slate-500 font-medium">
                                                Báo cáo HĐ: <strong class="text-slate-800">${p.councilReportDate != null
                                                    ? p.councilReportDate : 'Chưa định'}</strong>
                                            </span>
                                        </div>

                                        <!-- 4-Phase Step Timeline -->
                                        <div class="grid grid-cols-2 sm:grid-cols-4 gap-2 text-center text-[11px]">
                                            <div class="p-2.5 rounded-xl bg-sky-50 border border-sky-100 text-sky-900">
                                                <div class="font-bold text-[10px] uppercase text-sky-700">1. GV Đề xuất
                                                </div>
                                                <div class="text-slate-500 text-[10px] mt-0.5 font-medium">
                                                    ${p.lecturerStartDate}</div>
                                            </div>
                                            <div
                                                class="p-2.5 rounded-xl bg-emerald-50 border border-emerald-100 text-emerald-900">
                                                <div class="font-bold text-[10px] uppercase text-emerald-700">2. SV Đăng
                                                    ký</div>
                                                <div class="text-slate-500 text-[10px] mt-0.5 font-medium">
                                                    ${p.studentStartDate}</div>
                                            </div>
                                            <div
                                                class="p-2.5 rounded-xl bg-amber-50 border border-amber-100 text-amber-900">
                                                <div class="font-bold text-[10px] uppercase text-amber-700">3. Hạn GVPB
                                                </div>
                                                <div class="text-slate-500 text-[10px] mt-0.5 font-medium">
                                                    ${p.reviewerDeadline != null ? p.reviewerDeadline : 'Chưa định'}
                                                </div>
                                            </div>
                                            <div
                                                class="p-2.5 rounded-xl bg-purple-50 border border-purple-100 text-purple-900">
                                                <div class="font-bold text-[10px] uppercase text-purple-700">4. Báo cáo
                                                    HĐ</div>
                                                <div class="text-slate-500 text-[10px] mt-0.5 font-medium">
                                                    ${p.councilReportDate != null ? p.councilReportDate : 'Chưa định'}
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>

                        <!-- Topic Status Distribution Doughnut Chart (1 Col) -->
                        <div
                            class="bg-white rounded-3xl border border-slate-200 p-6 shadow-sm flex flex-col justify-between">
                            <div class="flex items-center justify-between mb-4 pb-3 border-b border-slate-100">
                                <h3 class="text-sm font-bold text-slate-900 flex items-center gap-2">
                                    <i data-lucide="pie-chart" class="w-4 h-4 text-sky-600"></i>
                                    <span>Trạng thái đề tài</span>
                                </h3>
                                <a href="${pageContext.request.contextPath}/admin/topics"
                                    class="text-xs font-bold text-sky-600 hover:text-sky-700">
                                    Chi tiết &rarr;
                                </a>
                            </div>

                            <div class="h-48 relative flex items-center justify-center my-2">
                                <canvas id="topicStatusChart"></canvas>
                            </div>

                            <div class="grid grid-cols-3 gap-2 text-center text-xs mt-4 pt-4 border-t border-slate-100">
                                <div class="p-2.5 bg-emerald-50/70 rounded-2xl border border-emerald-100">
                                    <div class="font-black text-emerald-800 text-base">${publishedTopicCount}</div>
                                    <div class="text-[10px] text-emerald-600 font-bold mt-0.5">Đã duyệt</div>
                                </div>
                                <div class="p-2.5 bg-amber-50/70 rounded-2xl border border-amber-100">
                                    <div class="font-black text-amber-800 text-base">${pendingTopicCount}</div>
                                    <div class="text-[10px] text-amber-600 font-bold mt-0.5">Chờ duyệt</div>
                                </div>
                                <div class="p-2.5 bg-rose-50/70 rounded-2xl border border-rose-100">
                                    <div class="font-black text-rose-800 text-base">${rejectedTopicCount}</div>
                                    <div class="text-[10px] text-rose-600 font-bold mt-0.5">Từ chối</div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Bottom Tables: Recent Registrations & Councils -->
                    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
                        <!-- Recent Registrations -->
                        <div class="bg-white rounded-3xl border border-slate-200 shadow-sm overflow-hidden">
                            <div class="p-5 border-b border-slate-100 flex items-center justify-between">
                                <h3 class="text-sm font-bold text-slate-900 flex items-center gap-2">
                                    <i data-lucide="clipboard-list" class="w-4 h-4 text-sky-600"></i>
                                    <span>Đăng ký đề tài mới nhất</span>
                                </h3>
                                <a href="${pageContext.request.contextPath}/admin/registrations"
                                    class="text-xs font-bold text-sky-600 hover:text-sky-700">
                                    Xem tất cả &rarr;
                                </a>
                            </div>
                            <div class="divide-y divide-slate-100 text-xs">
                                <c:if test="${empty recentRegistrations}">
                                    <div class="empty-state py-8">
                                        <div class="empty-state-icon-wrap w-10 h-10 mb-2">
                                            <i data-lucide="clipboard-x" class="w-5 h-5 opacity-40"></i>
                                        </div>
                                        <div class="empty-state-desc text-xs mb-0">Chưa có lượt đăng ký mới nào</div>
                                    </div>
                                </c:if>
                                <c:forEach var="reg" items="${recentRegistrations}">
                                    <div
                                        class="p-4 flex items-center justify-between hover:bg-slate-50 transition-colors">
                                        <div class="min-w-0 pr-3">
                                            <div class="font-bold text-slate-900 truncate">${reg.group.name}</div>
                                            <div class="text-[11px] text-slate-500 mt-0.5 truncate">
                                                <span
                                                    class="font-mono text-slate-700 font-semibold">[${reg.topic.code}]</span>
                                                ${reg.topic.title}
                                            </div>
                                        </div>
                                        <span
                                            class="status-badge ${reg.status == 'APPROVED' ? 'status-approved' : reg.status == 'PENDING' ? 'status-pending' : 'status-danger'} shrink-0">
                                            ${reg.status}
                                        </span>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>

                        <!-- Recent Councils -->
                        <div class="bg-white rounded-3xl border border-slate-200 shadow-sm overflow-hidden">
                            <div class="p-5 border-b border-slate-100 flex items-center justify-between">
                                <h3 class="text-sm font-bold text-slate-900 flex items-center gap-2">
                                    <i data-lucide="scale" class="w-4 h-4 text-purple-600"></i>
                                    <span>Hội đồng phản biện mới nhất</span>
                                </h3>
                                <a href="${pageContext.request.contextPath}/admin/councils"
                                    class="text-xs font-bold text-sky-600 hover:text-sky-700">
                                    Xem tất cả &rarr;
                                </a>
                            </div>
                            <div class="divide-y divide-slate-100 text-xs">
                                <c:if test="${empty recentCouncils}">
                                    <div class="empty-state py-8">
                                        <div class="empty-state-icon-wrap w-10 h-10 mb-2">
                                            <i data-lucide="scale" class="w-5 h-5 opacity-40"></i>
                                        </div>
                                        <div class="empty-state-desc text-xs mb-0">Chưa có hội đồng phản biện nào</div>
                                    </div>
                                </c:if>
                                <c:forEach var="c" items="${recentCouncils}">
                                    <div
                                        class="p-4 flex items-center justify-between hover:bg-slate-50 transition-colors">
                                        <div class="min-w-0 pr-3">
                                            <div class="flex items-center gap-2">
                                                <span
                                                    class="px-1.5 py-0.5 bg-slate-900 text-white rounded font-mono font-bold text-[10px]">${c.code}</span>
                                                <span class="font-bold text-slate-900 truncate">${c.name}</span>
                                            </div>
                                            <div class="text-[11px] text-slate-500 mt-1 truncate">
                                                Chủ tịch: <strong
                                                    class="text-slate-700">${c.chairman.user.fullName}</strong> &bull;
                                                Phòng: ${c.location}
                                            </div>
                                        </div>
                                        <span
                                            class="status-badge ${c.status == 'COMPLETED' ? 'status-approved' : 'status-pending'} shrink-0">
                                            ${c.status}
                                        </span>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </main>

                <jsp:include page="../common/footer.jsp" />

                <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
                <script>
                    document.addEventListener("DOMContentLoaded", function () {
                        const ctx = document.getElementById('topicStatusChart');
                        if (ctx) {
                            new Chart(ctx, {
                                type: 'doughnut',
                                data: {
                                    labels: ['Đã duyệt', 'Chờ duyệt', 'Từ chối'],
                                    datasets: [{
                                        data: [${ publishedTopicCount }, ${ pendingTopicCount }, ${ rejectedTopicCount }],
                                        backgroundColor: ['#10b981', '#f59e0b', '#f43f5e'],
                                        borderColor: '#ffffff',
                                        borderWidth: 3,
                                        hoverOffset: 6
                                    }]
                                },
                                options: {
                                    responsive: true,
                                    maintainAspectRatio: false,
                                    plugins: {
                                        legend: { display: false },
                                        tooltip: {
                                            backgroundColor: '#0f233a',
                                            titleFont: { family: 'Plus Jakarta Sans', size: 12, weight: 'bold' },
                                            bodyFont: { family: 'Plus Jakarta Sans', size: 12 },
                                            padding: 10,
                                            cornerRadius: 10
                                        }
                                    },
                                    cutout: '74%'
                                }
                            });
                        }
                    });
                </script>
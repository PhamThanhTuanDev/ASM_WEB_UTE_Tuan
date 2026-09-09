<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle" value="Bảng điều khiển quản trị" />
<c:set var="pageHeading" value="Bảng điều hành & quản trị hệ thống" />
<c:set var="pageSubheading" value="Tổng quan toàn diện quy trình đề tài, đợt đăng ký và hội đồng phản biện" />
<c:set var="activeMenu" value="dashboard" />

<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/sidebar.jsp" />

<div class="app-main">
    <jsp:include page="../common/navbar.jsp" />

    <main class="app-content space-y-6">
        <section class="dashboard-hero">
            <div class="dashboard-hero-content flex flex-col lg:flex-row lg:items-center lg:justify-between gap-5">
                <div>
                    <div class="text-[10px] font-bold uppercase tracking-[0.18em] text-blue-100">Trung tâm điều hành</div>
                    <h2 class="mt-1 text-xl sm:text-2xl font-extrabold tracking-tight">Xin chào, ${sessionScope.user.fullName}</h2>
                    <p class="mt-2 max-w-2xl text-xs sm:text-sm leading-relaxed text-blue-100">
                        Theo dõi nhanh đề tài, nhóm sinh viên, báo cáo và các mốc quan trọng trong một màn hình.
                    </p>
                </div>
                <div class="relative z-10 flex flex-wrap gap-2">
                    <a href="${pageContext.request.contextPath}/admin/periods" class="btn-ui bg-white text-blue-800 hover:bg-blue-50 border border-white">
                        <i data-lucide="calendar-plus" class="w-4 h-4"></i> Quản lý đợt
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/notifications" class="btn-ui bg-blue-950/30 text-white hover:bg-blue-950/50 border border-white/25">
                        <i data-lucide="megaphone" class="w-4 h-4"></i> Đăng thông báo
                    </a>
                </div>
            </div>
        </section>

        <!-- 4 Stat Cards Row -->
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5">
            <!-- Stat 1: Topics -->
            <div class="dashboard-stat p-5 flex items-center justify-between" style="--stat-accent: #2563eb;">
                <div>
                    <div class="text-[11px] font-bold uppercase tracking-wider text-slate-500">Tổng đề tài</div>
                    <div class="text-2xl font-black text-slate-900 mt-1">${fn:length(topics)}</div>
                    <div class="text-xs text-emerald-600 font-semibold flex items-center gap-1 mt-1">
                        <i data-lucide="check-circle-2" class="w-3.5 h-3.5"></i> ${publishedTopicCount} đã duyệt
                    </div>
                </div>
                <div class="w-12 h-12 rounded-2xl bg-blue-50 text-blue-600 flex items-center justify-center shrink-0 border border-blue-100">
                    <i data-lucide="book-marked" class="w-6 h-6"></i>
                </div>
            </div>

            <!-- Stat 2: Student Groups -->
            <div class="dashboard-stat p-5 flex items-center justify-between" style="--stat-accent: #059669;">
                <div>
                    <div class="text-[11px] font-bold uppercase tracking-wider text-slate-500">Nhóm sinh viên</div>
                    <div class="text-2xl font-black text-slate-900 mt-1">${groupCount}</div>
                    <div class="text-xs text-blue-600 font-semibold flex items-center gap-1 mt-1">
                        <i data-lucide="clipboard-list" class="w-3.5 h-3.5"></i> ${totalRegistrations} lượt đăng ký
                    </div>
                </div>
                <div class="w-12 h-12 rounded-2xl bg-emerald-50 text-emerald-600 flex items-center justify-center shrink-0 border border-emerald-100">
                    <i data-lucide="users" class="w-6 h-6"></i>
                </div>
            </div>

            <!-- Stat 3: Councils -->
            <div class="dashboard-stat p-5 flex items-center justify-between" style="--stat-accent: #7c3aed;">
                <div>
                    <div class="text-[11px] font-bold uppercase tracking-wider text-slate-500">Hội đồng phản biện</div>
                    <div class="text-2xl font-black text-slate-900 mt-1">${councilCount}</div>
                    <div class="text-xs text-purple-600 font-semibold flex items-center gap-1 mt-1">
                        <i data-lucide="user-check" class="w-3.5 h-3.5"></i> ${totalLecturers} giảng viên tham gia
                    </div>
                </div>
                <div class="w-12 h-12 rounded-2xl bg-purple-50 text-purple-600 flex items-center justify-center shrink-0 border border-purple-100">
                    <i data-lucide="scale" class="w-6 h-6"></i>
                </div>
            </div>

            <!-- Stat 4: Active Periods -->
            <div class="dashboard-stat p-5 flex items-center justify-between" style="--stat-accent: #d97706;">
                <div>
                    <div class="text-[11px] font-bold uppercase tracking-wider text-slate-500">Đợt đăng ký</div>
                    <div class="text-2xl font-black text-slate-900 mt-1">${fn:length(periods)}</div>
                    <div class="text-xs text-amber-600 font-semibold flex items-center gap-1 mt-1">
                        <i data-lucide="calendar" class="w-3.5 h-3.5"></i> Học kỳ 2 &bull; 2026
                    </div>
                </div>
                <div class="w-12 h-12 rounded-2xl bg-amber-50 text-amber-600 flex items-center justify-center shrink-0 border border-amber-100">
                    <i data-lucide="calendar-check" class="w-6 h-6"></i>
                </div>
            </div>
        </div>

        <!-- Middle Section: Period Timeline & Status Doughnut -->
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
            <!-- Period Timeline (2 Columns) -->
            <div class="lg:col-span-2 bg-white rounded-2xl border border-slate-200 p-6 shadow-xs flex flex-col justify-between">
                <div class="flex items-center justify-between mb-4 pb-3 border-b border-slate-100">
                    <h3 class="text-sm font-bold text-slate-900 flex items-center gap-2">
                        <i data-lucide="activity" class="w-4 h-4 text-blue-600"></i> Tiến độ các đợt đăng ký
                    </h3>
                    <a href="${pageContext.request.contextPath}/admin/periods" class="text-xs font-semibold text-blue-600 hover:text-blue-700">
                        Quản lý đợt &rarr;
                    </a>
                </div>

                    <div class="space-y-4">
                    <c:if test="${empty periods}">
                        <div class="empty-state">
                            <div>
                                <div class="empty-state-icon mx-auto"><i data-lucide="calendar-off" class="w-6 h-6"></i></div>
                                <div class="text-xs font-bold text-slate-700">Chưa có đợt đăng ký</div>
                                <div class="mt-1 text-[11px]">Tạo đợt mới để bắt đầu quy trình.</div>
                            </div>
                        </div>
                    </c:if>
                    <div>
                    <c:forEach var="p" items="${dashboardPeriods}">
                        <div class="p-4 rounded-2xl bg-slate-50 border border-slate-100 space-y-3">
                            <div class="flex items-center justify-between">
                                <div class="flex items-center gap-2">
                                    <span class="px-2 py-0.5 rounded text-[10px] font-bold ${p.status == 'OPEN' ? 'bg-emerald-100 text-emerald-800' : 'bg-slate-200 text-slate-700'}">
                                        ${p.status}
                                    </span>
                                    <h4 class="font-bold text-xs text-slate-900">${p.name}</h4>
                                    <span class="text-[10px] font-semibold text-slate-500 bg-white px-2 py-0.5 rounded border border-slate-200">${p.type}</span>
                                </div>
                                <span class="text-[11px] text-slate-500 font-medium">Báo cáo HĐ: <strong>${p.councilReportDate != null ? p.councilReportDate : 'N/A'}</strong></span>
                            </div>

                            <!-- Visual Timeline Steps -->
                            <div class="grid grid-cols-4 gap-2 text-center text-[10px]">
                                <div class="p-2 rounded-xl bg-blue-100/70 border border-blue-200 text-blue-900">
                                    <div class="font-bold">1. GV Đề xuất</div>
                                    <div class="text-slate-600 text-[9px] mt-0.5">${p.lecturerStartDate}</div>
                                </div>
                                <div class="p-2 rounded-xl bg-emerald-100/70 border border-emerald-200 text-emerald-900">
                                    <div class="font-bold">2. SV Đăng ký</div>
                                    <div class="text-slate-600 text-[9px] mt-0.5">${p.studentStartDate}</div>
                                </div>
                                <div class="p-2 rounded-xl bg-amber-100/70 border border-amber-200 text-amber-900">
                                    <div class="font-bold">3. Hạn GVPB</div>
                                    <div class="text-slate-600 text-[9px] mt-0.5">${p.reviewerDeadline != null ? p.reviewerDeadline : 'N/A'}</div>
                                </div>
                                <div class="p-2 rounded-xl bg-purple-100/70 border border-purple-200 text-purple-900">
                                    <div class="font-bold">4. Báo cáo HĐ</div>
                                    <div class="text-slate-600 text-[9px] mt-0.5">${p.councilReportDate != null ? p.councilReportDate : 'N/A'}</div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                    </div>
                </div>
            </div>

            <!-- Status Distribution (1 Column) -->
            <div class="bg-white rounded-2xl border border-slate-200 p-6 shadow-xs flex flex-col justify-between">
                <div class="flex items-center justify-between mb-4 pb-3 border-b border-slate-100">
                    <h3 class="text-sm font-bold text-slate-900 flex items-center gap-2">
                        <i data-lucide="pie-chart" class="w-4 h-4 text-blue-600"></i> Trạng thái đề tài
                    </h3>
                    <a href="${pageContext.request.contextPath}/admin/topics" class="text-xs font-semibold text-blue-600 hover:text-blue-700">
                        Chi tiết &rarr;
                    </a>
                </div>

                <div class="h-48 relative flex items-center justify-center">
                    <canvas id="topicStatusChart"></canvas>
                </div>

                <div class="grid grid-cols-3 gap-2 text-center text-xs mt-4 pt-4 border-t border-slate-100">
                    <div class="p-2 bg-emerald-50 rounded-xl border border-emerald-100">
                        <div class="font-bold text-emerald-800">${publishedTopicCount}</div>
                        <div class="text-[10px] text-emerald-600 font-semibold">Đã duyệt</div>
                    </div>
                    <div class="p-2 bg-amber-50 rounded-xl border border-amber-100">
                        <div class="font-bold text-amber-800">${pendingTopicCount}</div>
                        <div class="text-[10px] text-amber-600 font-semibold">Chờ duyệt</div>
                    </div>
                    <div class="p-2 bg-rose-50 rounded-xl border border-rose-100">
                        <div class="font-bold text-rose-800">${rejectedTopicCount}</div>
                        <div class="text-[10px] text-rose-600 font-semibold">Từ chối</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bottom Tables: Recent Registrations & Councils -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <!-- Recent Registrations -->
            <div class="bg-white rounded-2xl border border-slate-200 shadow-xs overflow-hidden">
                <div class="p-5 border-b border-slate-100 flex items-center justify-between">
                    <h3 class="text-sm font-bold text-slate-900 flex items-center gap-2">
                        <i data-lucide="clipboard-list" class="w-4 h-4 text-blue-600"></i> Đăng ký đề tài mới nhất
                    </h3>
                    <a href="${pageContext.request.contextPath}/admin/topics" class="text-xs font-semibold text-blue-600 hover:text-blue-700">
                        Xem tất cả &rarr;
                    </a>
                </div>
                <div class="divide-y divide-slate-100 text-xs">
                    <c:if test="${empty recentRegistrations}">
                        <div class="empty-state"><div><div class="empty-state-icon mx-auto"><i data-lucide="clipboard-x" class="w-6 h-6"></i></div><div class="text-xs font-bold text-slate-700">Chưa có đăng ký mới</div></div></div>
                    </c:if>
                    <c:forEach var="reg" items="${recentRegistrations}">
                        <div class="p-4 flex items-center justify-between hover:bg-slate-50 transition-colors">
                            <div>
                                <div class="font-bold text-slate-900">${reg.group.name}</div>
                                <div class="text-[11px] text-slate-500 mt-0.5 line-clamp-1">[${reg.topic.code}] ${reg.topic.title}</div>
                            </div>
                            <span class="px-2.5 py-1 rounded-lg text-[11px] font-bold ${reg.status == 'APPROVED' ? 'bg-emerald-100 text-emerald-800' : reg.status == 'PENDING' ? 'bg-amber-100 text-amber-800' : 'bg-rose-100 text-rose-800'}">
                                ${reg.status}
                            </span>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- Recent Councils -->
            <div class="bg-white rounded-2xl border border-slate-200 shadow-xs overflow-hidden">
                <div class="p-5 border-b border-slate-100 flex items-center justify-between">
                    <h3 class="text-sm font-bold text-slate-900 flex items-center gap-2">
                        <i data-lucide="scale" class="w-4 h-4 text-purple-600"></i> Hội đồng phản biện
                    </h3>
                    <a href="${pageContext.request.contextPath}/admin/councils" class="text-xs font-semibold text-blue-600 hover:text-blue-700">
                        Xem tất cả &rarr;
                    </a>
                </div>
                <div class="divide-y divide-slate-100 text-xs">
                    <c:if test="${empty recentCouncils}">
                        <div class="empty-state"><div><div class="empty-state-icon mx-auto"><i data-lucide="scale" class="w-6 h-6"></i></div><div class="text-xs font-bold text-slate-700">Chưa có hội đồng</div></div></div>
                    </c:if>
                    <c:forEach var="c" items="${recentCouncils}">
                        <div class="p-4 flex items-center justify-between hover:bg-slate-50 transition-colors">
                            <div>
                                <div class="flex items-center gap-2">
                                    <span class="px-1.5 py-0.5 bg-slate-900 text-white rounded font-mono font-bold text-[10px]">${c.code}</span>
                                    <span class="font-bold text-slate-900">${c.name}</span>
                                </div>
                                <div class="text-[11px] text-slate-500 mt-1">
                                    CT: <strong>${c.chairman.user.fullName}</strong> &bull; Phòng: ${c.location}
                                </div>
                            </div>
                            <span class="px-2.5 py-1 rounded-lg text-[11px] font-bold ${c.status == 'COMPLETED' ? 'bg-emerald-100 text-emerald-800' : 'bg-amber-100 text-amber-800'}">
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
    document.addEventListener("DOMContentLoaded", function() {
        const ctx = document.getElementById('topicStatusChart');
        if (ctx) {
            new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: ['Đã duyệt', 'Chờ duyệt', 'Từ chối'],
                    datasets: [{
                        data: [${publishedTopicCount}, ${pendingTopicCount}, ${rejectedTopicCount}],
                        backgroundColor: ['#10b981', '#f59e0b', '#f43f5e'],
                        borderWidth: 2,
                        hoverOffset: 4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false }
                    },
                    cutout: '72%'
                }
            });
        }
    });
</script>

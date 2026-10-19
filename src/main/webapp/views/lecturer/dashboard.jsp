<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <c:set scope="request" var="pageTitle" value="Bảng điều khiển giảng viên" />
            <c:set scope="request" var="pageHeading" value="Không gian làm việc giảng viên" />
            <c:set scope="request" var="pageSubheading"
                value="Chào mừng Thầy/Cô ${lecturer.user.fullName} (${lecturer.department.name})" />
            <c:set scope="request" var="activeMenu" value="dashboard" />

            <jsp:include page="../common/header.jsp" />
            <jsp:include page="../common/sidebar.jsp" />

            <div class="app-main">
                <jsp:include page="../common/navbar.jsp" />

                <main class="app-content workspace-page space-y-6">
                    <!-- 3D Hero Section -->
                    <section class="dashboard-hero">
                        <div class="hero-orbit" aria-hidden="true"></div>
                        <div class="hero-3d-cube" aria-hidden="true"></div>
                        <div class="academic-badge-float top-4 right-16 hidden md:inline-flex"
                            style="animation-delay: -2.5s;">
                            <i data-lucide="award" class="w-3.5 h-3.5 text-amber-300"></i>
                            <span>Faculty Research</span>
                        </div>
                        <div class="floating-particle w-2 h-2 top-8 right-32 hidden md:block"
                            style="animation-delay: -1.2s;"></div>
                        <div class="floating-particle w-1.5 h-1.5 bottom-6 right-56 hidden md:block"
                            style="animation-delay: -3.8s;"></div>

                        <div class="relative z-10 flex flex-col lg:flex-row lg:items-center lg:justify-between gap-5">
                            <div class="space-y-2">
                                <div
                                    class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-white/10 text-sky-200 text-[10px] font-extrabold uppercase tracking-widest border border-white/15 backdrop-blur-md">
                                    <i data-lucide="graduation-cap" class="w-3.5 h-3.5 text-amber-300"></i>
                                    <span>Giảng viên hướng dẫn và ${lecturer.department.name}</span>
                                </div>
                                <h2
                                    class="text-2xl sm:text-3xl font-extrabold tracking-tight text-white flex items-center gap-2.5">
                                    <span>Chào Thầy/Cô, ${lecturer.user.fullName}</span>
                                    <span class="inline-block animate-bounce text-xl">👋</span>
                                </h2>
                                <p class="max-w-2xl text-xs sm:text-sm leading-relaxed text-sky-100/90 font-medium">
                                    Theo dõi tiến độ nhóm sinh viên hướng dẫn, quản lý các đề xuất đề tài và tham gia
                                    đánh giá chấm điểm tại các hội đồng phản biện.
                                </p>
                            </div>

                            <div
                                class="flex flex-col sm:flex-row items-stretch sm:items-center gap-2.5 shrink-0 w-full sm:w-auto">
                                <a href="${pageContext.request.contextPath}/lecturer/topics"
                                    class="btn-ui bg-white text-blue-900 hover:bg-sky-50 shadow-md border border-white font-bold text-xs px-4 py-2.5 rounded-xl transition-all justify-center">
                                    <i data-lucide="file-plus-2" class="w-4 h-4 text-sky-600"></i> Đề xuất đề tài
                                </a>
                                <a href="${pageContext.request.contextPath}/lecturer/councils"
                                    class="btn-ui bg-white/10 text-white hover:bg-white/20 border border-white/20 font-bold text-xs px-4 py-2.5 rounded-xl backdrop-blur-md transition-all justify-center">
                                    <i data-lucide="scale" class="w-4 h-4 text-purple-300"></i> Hội đồng và Điểm
                                </a>
                            </div>
                        </div>
                    </section>

                    <!-- KPI Bento Cards (3 cols) -->
                    <div class="grid grid-cols-1 sm:grid-cols-3 gap-5">
                        <div class="dashboard-stat p-5" style="--stat-accent: #006da8;">
                            <div class="space-y-1 flex-1 min-w-0">
                                <div class="flex items-center justify-between">
                                    <div class="text-[10px] font-extrabold uppercase tracking-wider text-slate-400">Đề
                                        tài hướng dẫn</div>
                                    <span class="stat-trend-badge trend-up">
                                        <i data-lucide="trending-up" class="w-3 h-3"></i>
                                        <span>Học kỳ này</span>
                                    </span>
                                </div>
                                <div class="text-3xl font-black text-slate-900 tracking-tight">${fn:length(myTopics)}
                                </div>
                                <div class="text-xs text-sky-600 font-bold truncate">Giảng viên hướng dẫn chính và Đồng HD</div>
                                <div class="stat-mini-progress">
                                    <div class="stat-mini-progress-bar"
                                        style="width: ${fn:length(myTopics) > 0 ? '100%' : '20%'}"></div>
                                </div>
                            </div>

                        </div>

                        <div class="dashboard-stat p-5" style="--stat-accent: #059669;">
                            <div class="space-y-1 flex-1 min-w-0">
                                <div class="flex items-center justify-between">
                                    <div class="text-[10px] font-extrabold uppercase tracking-wider text-slate-400">Nhóm
                                        sinh viên</div>
                                    <span class="stat-trend-badge trend-up">
                                        <i data-lucide="users" class="w-3 h-3 text-emerald-500"></i>
                                        <span>Đang phụ trách</span>
                                    </span>
                                </div>
                                <div class="text-3xl font-black text-slate-900 tracking-tight">${fn:length(myGroupRegs)}
                                </div>
                                <div class="text-xs text-emerald-600 font-bold truncate">Đang theo dõi và duyệt đăng
                                    ký</div>
                                <div class="stat-mini-progress">
                                    <div class="stat-mini-progress-bar"
                                        style="width: ${fn:length(myGroupRegs) > 0 ? '100%' : '15%'}"></div>
                                </div>
                            </div>

                        </div>

                        <div class="dashboard-stat p-5" style="--stat-accent: #d97706;">
                            <div class="space-y-1 flex-1 min-w-0">
                                <div class="flex items-center justify-between">
                                    <div class="text-[10px] font-extrabold uppercase tracking-wider text-slate-400">Hội
                                        đồng tham gia</div>
                                    <span
                                        class="stat-trend-badge ${fn:length(myCouncils) > 0 ? 'trend-up' : 'trend-neutral'}">
                                        <i data-lucide="scale" class="w-3 h-3 text-amber-500"></i>
                                        <span>Nhiệm vụ HĐ</span>
                                    </span>
                                </div>
                                <div class="text-3xl font-black text-slate-900 tracking-tight">${fn:length(myCouncils)}
                                </div>
                                <div class="text-xs text-amber-600 font-bold truncate">Chủ tịch / Thư ký / Ủy viên</div>
                                <div class="stat-mini-progress">
                                    <div class="stat-mini-progress-bar"
                                        style="width: ${fn:length(myCouncils) > 0 ? '100%' : '25%'}"></div>
                                </div>
                            </div>

                        </div>
                    </div>

                    <!-- Active Period Banner -->
                    <c:if test="${not empty activePeriod}">
                        <div class="bg-white rounded-3xl border border-slate-200 p-6 shadow-sm space-y-3">
                            <div
                                class="flex flex-col sm:flex-row sm:items-center justify-between gap-2 border-b border-slate-100 pb-3">
                                <div class="flex items-center gap-2.5">
                                    <div class="p-2 rounded-xl bg-sky-50 text-sky-700 border border-sky-100 shrink-0">
                                        <i data-lucide="calendar-check" class="w-5 h-5"></i>
                                    </div>
                                    <div>
                                        <h3 class="text-sm font-bold text-slate-900"><c:out value="${activePeriod.name}" /></h3>
                                        <p class="text-xs text-slate-500">Đợt đăng ký và bảo vệ khóa luận đang diễn ra
                                        </p>
                                    </div>
                                </div>
                                <span class="status-badge status-approved self-start sm:self-auto">
                                    ${enumLabel.label(activePeriod.type)}
                                </span>
                            </div>

                            <div class="grid grid-cols-1 sm:grid-cols-3 gap-3 text-xs pt-1">
                                <div
                                    class="p-3 rounded-2xl bg-slate-50 border border-slate-200/80 flex items-center gap-3">
                                    <div
                                        class="w-8 h-8 rounded-xl bg-amber-100 text-amber-800 flex items-center justify-center shrink-0">
                                        <i data-lucide="clock" class="w-4 h-4"></i>
                                    </div>
                                    <div>
                                        <div class="text-[10px] text-slate-400 font-bold uppercase">Hạn GV đề xuất:
                                        </div>
                                        <div class="font-bold text-slate-800">${dateDisplay.format(activePeriod.lecturerStartDate)} &rarr;
                                            ${dateDisplay.format(activePeriod.lecturerEndDate)}</div>
                                    </div>
                                </div>

                                <div
                                    class="p-3 rounded-2xl bg-slate-50 border border-slate-200/80 flex items-center gap-3">
                                    <div
                                        class="w-8 h-8 rounded-xl bg-sky-100 text-sky-800 flex items-center justify-center shrink-0">
                                        <i data-lucide="users" class="w-4 h-4"></i>
                                    </div>
                                    <div>
                                        <div class="text-[10px] text-slate-400 font-bold uppercase">Hạn SV đăng ký:
                                        </div>
                                        <div class="font-bold text-slate-800">${dateDisplay.format(activePeriod.studentStartDate)} &rarr;
                                            ${dateDisplay.format(activePeriod.studentEndDate)}</div>
                                    </div>
                                </div>

                                <div
                                    class="p-3 rounded-2xl bg-slate-50 border border-slate-200/80 flex items-center gap-3">
                                    <div
                                        class="w-8 h-8 rounded-xl bg-rose-100 text-rose-800 flex items-center justify-center shrink-0">
                                        <i data-lucide="flag" class="w-4 h-4"></i>
                                    </div>
                                    <div>
                                        <div class="text-[10px] text-slate-400 font-bold uppercase">Hạn nộp điểm:</div>
                                        <div class="font-bold text-slate-800">${activePeriod.reviewerDeadline != null ?
                                            dateDisplay.format(activePeriod.reviewerDeadline) : 'Chưa định'}</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <!-- Bottom 2 Columns: Topics và Councils -->
                    <div class="grid grid-cols-1 lg:grid-cols-12 gap-6">
                        <!-- Supervised Topics List (7 cols) -->
                        <div class="lg:col-span-7 space-y-6">
                            <div class="table-shell">
                                <div class="p-5 border-b border-slate-100 flex items-center justify-between">
                                    <h4 class="text-sm font-bold text-slate-900 flex items-center gap-2">
                                        <i data-lucide="book-marked" class="w-4 h-4 text-sky-600"></i>
                                        <span>Đề tài của tôi (${fn:length(myTopics)})</span>
                                    </h4>
                                    <a href="${pageContext.request.contextPath}/lecturer/topics"
                                        class="btn-ui btn-ui-primary text-xs py-1.5 px-3">
                                        <i data-lucide="plus" class="w-3.5 h-3.5"></i> Đề xuất mới
                                    </a>
                                </div>

                                <table class="w-full text-left border-collapse">
                                    <thead>
                                        <tr>
                                            <th class="w-[42%]">Mã và Tên Đề tài</th>
                                            <th class="w-[20%]">Vai trò</th>
                                            <th class="w-[20%]">Đồng HD</th>
                                            <th class="w-[18%] text-center">Trạng thái</th>
                                        </tr>
                                    </thead>
                                    <tbody class="divide-y divide-slate-100 text-xs">
                                        <c:if test="${empty myTopics}">
                                            <tr class="table-empty-row">
                                                <td colspan="4">
                                                    <div class="empty-state py-6">
                                                        <div class="empty-state-icon-wrap w-10 h-10 mb-2">
                                                            <i data-lucide="book-open" class="w-5 h-5 opacity-40"></i>
                                                        </div>
                                                        <div class="empty-state-desc text-xs mb-0">Thầy/Cô chưa đề xuất
                                                            đề tài nào</div>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:if>
                                        <c:forEach var="t" items="${myTopics}">
                                            <tr>
                                                <td class="align-top">
                                                    <span class="code-tag mb-1 inline-block">${t.code}</span>
                                                    <div class="font-bold text-slate-900 leading-snug">
                                                        <c:out value="${t.title}" />
                                                    </div>
                                                </td>
                                                <td class="align-top whitespace-nowrap">
                                                    <span
                                                        class="status-badge ${t.lecturer.id == lecturer.id ? 'status-info' : 'status-neutral'}">
                                                        ${t.lecturer.id == lecturer.id ? 'Giảng viên hướng dẫn chính' : 'Đồng HD'}
                                                    </span>
                                                </td>
                                                <td class="align-top text-slate-600 font-medium">
                                                    <c:out value="${t.coLecturer != null ? t.coLecturer.user.fullName : 'Không'}" />
                                                </td>
                                                <td class="align-top text-center whitespace-nowrap">
                                                    <span
                                                        class="status-badge ${t.status == 'PUBLISHED' || t.status == 'APPROVED' ? 'status-approved' : t.status == 'PENDING' ? 'status-pending' : 'status-neutral'}">
                                                        <c:choose>
                                                            <c:when
                                                                test="${t.status == 'PUBLISHED' || t.status == 'APPROVED'}">
                                                                ĐÃ DUYỆT</c:when>
                                                            <c:when test="${t.status == 'PENDING'}">CHỜ DUYỆT</c:when>
                                                            <c:otherwise>BẢN NHÁP</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- Assigned Review Councils (5 cols) -->
                        <div class="lg:col-span-5 space-y-6">
                            <div class="bg-white rounded-3xl border border-slate-200 p-6 shadow-sm space-y-4">
                                <div class="flex items-center justify-between pb-3 border-b border-slate-100">
                                    <h4 class="text-sm font-bold text-slate-900 flex items-center gap-2">
                                        <i data-lucide="scale" class="w-4 h-4 text-purple-600"></i>
                                        <span>Hội đồng tham gia (${fn:length(myCouncils)})</span>
                                    </h4>
                                    <a href="${pageContext.request.contextPath}/lecturer/councils"
                                        class="text-xs font-bold text-sky-600 hover:text-sky-700">
                                        Xem tất cả &rarr;
                                    </a>
                                </div>

                                <div class="space-y-3">
                                    <c:choose>
                                        <c:when test="${empty myCouncils}">
                                            <div class="empty-state py-8">
                                                <div class="empty-state-icon-wrap w-10 h-10 mb-2">
                                                    <i data-lucide="scale" class="w-5 h-5 opacity-40"></i>
                                                </div>
                                                <div class="empty-state-desc text-xs mb-0">Thầy/Cô chưa tham gia hội
                                                    đồng nào</div>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="mc" items="${myCouncils}">
                                                <div
                                                    class="p-4 rounded-2xl bg-slate-50 border border-slate-200/80 space-y-3 text-xs transition-all hover:bg-sky-50/20">
                                                    <div class="flex items-center justify-between gap-2">
                                                        <h5 class="font-bold text-slate-900 text-sm leading-snug">
                                                            <c:out value="${mc.council.name}" /></h5>
                                                        <span
                                                            class="status-badge ${mc.role == 'CHAIRMAN' ? 'status-pending' : mc.role == 'SECRETARY' ? 'status-info' : 'status-neutral'} shrink-0">
                                                            <c:choose>
                                                                <c:when test="${mc.role == 'CHAIRMAN'}">CHỦ TỊCH
                                                                </c:when>
                                                                <c:when test="${mc.role == 'SECRETARY'}">THƯ KÝ</c:when>
                                                                <c:otherwise>ỦY VIÊN</c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                    </div>
                                                    <div class="text-slate-500 space-y-1">
                                                        <div>Ngày báo cáo: <strong
                                                                class="text-slate-800">${mc.council.councilDate != null
                                                                ? dateDisplay.format(mc.council.councilDate) : 'Chưa định'}</strong></div>
                                                        <div>Địa điểm: <strong
                                                                class="text-slate-800">${mc.council.location != null ?
                                                                mc.council.location : 'Chưa định'}</strong></div>
                                                    </div>
                                                    <a href="${pageContext.request.contextPath}/lecturer/councils"
                                                        class="btn-ui btn-ui-primary w-full py-2 text-xs">
                                                        <i data-lucide="pen-tool" class="w-3.5 h-3.5"></i> Chấm điểm hội
                                                        đồng
                                                    </a>
                                                </div>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>

                <jsp:include page="../common/footer.jsp" />

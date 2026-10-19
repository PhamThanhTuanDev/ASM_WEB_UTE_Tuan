<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <c:set scope="request" var="pageTitle" value="Bảng điều khiển sinh viên" />
            <c:set scope="request" var="pageHeading" value="Không gian đề tài của sinh viên" />
            <c:set scope="request" var="pageSubheading"
                value="Chào bạn, ${student.user.fullName} (MSSV: ${student.studentCode} &bull; Lớp: ${student.className})" />
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
                            style="animation-delay: -2s;">
                            <i data-lucide="sparkles" class="w-3.5 h-3.5 text-amber-300"></i>
                            <span>HCMUTE KLTN</span>
                        </div>
                        <div class="floating-particle w-2 h-2 top-8 right-32 hidden md:block"
                            style="animation-delay: -1.5s;"></div>
                        <div class="floating-particle w-1.5 h-1.5 bottom-6 right-56 hidden md:block"
                            style="animation-delay: -3.5s;"></div>

                        <div class="relative z-10 flex flex-col lg:flex-row lg:items-center lg:justify-between gap-5">
                            <div class="space-y-2">
                                <div
                                    class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-white/10 text-sky-200 text-[10px] font-extrabold uppercase tracking-widest border border-white/15 backdrop-blur-md">
                                    <i data-lucide="award" class="w-3.5 h-3.5 text-emerald-300"></i>
                                    <span>MSSV: ${student.studentCode} &bull; Lớp: ${student.className}</span>
                                </div>
                                <h2
                                    class="text-2xl sm:text-3xl font-extrabold tracking-tight text-white flex items-center gap-2.5">
                                    <span>Xin chào, ${student.user.fullName}</span>
                                    <span class="inline-block animate-bounce text-xl">🎓</span>
                                </h2>
                                <p class="max-w-2xl text-xs sm:text-sm leading-relaxed text-sky-100/90 font-medium">
                                    Cổng quản lý đồ án tốt nghiệp: Đăng ký nhóm sinh viên, lựa chọn đề tài nghiên cứu,
                                    theo dõi tiến độ nộp báo cáo và nhận kết quả đánh giá từ hội đồng.
                                </p>
                            </div>

                            <div
                                class="flex flex-col sm:flex-row items-stretch sm:items-center gap-2.5 shrink-0 w-full sm:w-auto">
                                <a href="${pageContext.request.contextPath}/student/topics"
                                    class="btn-ui bg-white text-blue-900 hover:bg-sky-50 shadow-md border border-white font-bold text-xs px-4 py-2.5 rounded-xl transition-all justify-center">
                                    <i data-lucide="search" class="w-4 h-4 text-sky-600"></i> Tra cứu đề tài
                                </a>
                                <a href="${pageContext.request.contextPath}/student/group"
                                    class="btn-ui bg-white/10 text-white hover:bg-white/20 border border-white/20 font-bold text-xs px-4 py-2.5 rounded-xl backdrop-blur-md transition-all justify-center">
                                    <i data-lucide="users" class="w-4 h-4 text-emerald-300"></i> Nhóm của tôi
                                </a>
                            </div>
                        </div>
                    </section>

                    <!-- Process Timeline Banner -->
                    <c:if test="${not empty activePeriod}">
                        <div class="bg-white rounded-3xl border border-slate-200 p-6 shadow-sm space-y-4">
                            <div
                                class="flex flex-col sm:flex-row sm:items-center justify-between gap-2 border-b border-slate-100 pb-3">
                                <div class="flex items-center gap-2.5">
                                    <div class="p-2 rounded-xl bg-sky-50 text-sky-700 border border-sky-100 shrink-0">
                                        <i data-lucide="calendar-range" class="w-5 h-5"></i>
                                    </div>
                                    <div>
                                        <h3 class="text-sm font-bold text-slate-900"><c:out value="${activePeriod.name}" /></h3>
                                        <p class="text-xs text-slate-500">Quy trình 4 giai đoạn thực hiện đề tài tốt
                                            nghiệp</p>
                                    </div>
                                </div>
                                <span class="status-badge status-approved self-start sm:self-auto">
                                    ${enumLabel.label(activePeriod.type)}
                                </span>
                            </div>

                            <!-- Derive each step from the current registration, reports and council. -->
                            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-3 pt-1">
                                <c:forEach begin="1" end="4" var="step">
                                    <c:set var="stepDone" value="${currentStep > step}" />
                                    <c:set var="stepCurrent" value="${currentStep == step}" />
                                    <div class="academic-timeline-step p-3.5 rounded-2xl border space-y-2 ${stepCurrent ? 'is-current' : 'bg-slate-50 border-slate-200/80'}">
                                        <div class="flex items-center justify-between gap-2">
                                            <div class="flex items-center gap-2 text-xs font-bold ${stepDone ? 'text-emerald-700' : (stepCurrent ? 'text-sky-700' : 'text-slate-500')}">
                                                <i data-lucide="${stepDone ? 'check-circle-2' : (stepCurrent ? 'circle-dot' : 'circle')}" class="w-4 h-4 shrink-0"></i>
                                                <span>${step}.
                                                    <c:choose>
                                                        <c:when test="${step == 1}">GV Đề xuất</c:when>
                                                        <c:when test="${step == 2}">Nhóm và Chọn đề tài</c:when>
                                                        <c:when test="${step == 3}">Thực hiện và Báo cáo</c:when>
                                                        <c:otherwise>Hội đồng đánh giá</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                            <span class="text-[9px] font-extrabold uppercase px-1.5 py-0.5 rounded shrink-0 ${stepDone ? 'bg-emerald-100 text-emerald-700' : (stepCurrent ? 'bg-sky-100 text-sky-700' : 'bg-slate-100 text-slate-500')}">
                                                <c:choose>
                                                    <c:when test="${stepDone}">Đã xong</c:when>
                                                    <c:when test="${stepCurrent && step == 4}">${empty myAssignment ? 'Chờ hội đồng' : 'Chờ kết quả'}</c:when>
                                                    <c:when test="${stepCurrent && step == 2 && myRegistration.status == 'PENDING'}">Chờ duyệt</c:when>
                                                    <c:when test="${stepCurrent}">Đang thực hiện</c:when>
                                                    <c:otherwise>Chưa đến bước</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                        <div class="text-[11px] text-slate-500">
                                            <c:choose>
                                                <c:when test="${step == 1}">${dateDisplay.format(activePeriod.lecturerStartDate)} &rarr; ${dateDisplay.format(activePeriod.lecturerEndDate)}</c:when>
                                                <c:when test="${step == 2}">${dateDisplay.format(activePeriod.studentStartDate)} &rarr; ${dateDisplay.format(activePeriod.studentEndDate)}</c:when>
                                                <c:when test="${step == 3}">Hạn PB: ${activePeriod.reviewerDeadline != null ? dateDisplay.format(activePeriod.reviewerDeadline) : 'Chưa định'}</c:when>
                                                <c:otherwise>${activePeriod.councilReportDate != null ? dateDisplay.format(activePeriod.councilReportDate) : 'Chưa định'}</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </c:if>

                    <!-- Bento KPI 4 Stat Cards -->
                    <section class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-4"
                        aria-label="Tổng quan tiến độ">
                        <div class="dashboard-stat p-5" style="--stat-accent: #006da8;">
                            <div class="space-y-1 flex-1 min-w-0">
                                <div class="flex items-center justify-between">
                                    <p class="text-[10px] font-extrabold uppercase tracking-wider text-slate-400">${workflowCompleted ? 'Đồ án đã hoàn tất' : 'Đồ án đang làm'}</p>
                                    <span
                                        class="stat-trend-badge ${not empty myRegistration ? 'trend-up' : 'trend-neutral'}">
                                        <i data-lucide="${not empty myRegistration ? 'trending-up' : 'minus'}"
                                            class="w-3 h-3"></i>
                                        <span>${workflowCompleted ? 'Đã hoàn tất' : (not empty myRegistration ? 'Kỳ hiện tại' : 'Chờ đăng ký')}</span>
                                    </span>
                                </div>
                                <p class="text-3xl font-black text-slate-900 tracking-tight">${not empty myRegistration
                                    ? 1 : 0}</p>
                                <p class="text-xs text-sky-600 font-bold truncate">Đề tài trong đợt này</p>
                                <div class="stat-mini-progress">
                                    <div class="stat-mini-progress-bar"
                                        style="width: ${not empty myRegistration ? '100%' : '0%'}"></div>
                                </div>
                            </div>

                        </div>

                        <div class="dashboard-stat p-5" style="--stat-accent: #d97706;">
                            <div class="space-y-1 flex-1 min-w-0">
                                <div class="flex items-center justify-between">
                                    <p class="text-[10px] font-extrabold uppercase tracking-wider text-slate-400">Mốc
                                        sắp tới</p>
                                    <span
                                        class="stat-trend-badge ${not empty activePeriod ? 'trend-up' : 'trend-neutral'}">
                                        <i data-lucide="clock" class="w-3 h-3 text-amber-500"></i>
                                        <span>${workflowCompleted ? 'Đã hoàn tất' : (not empty activePeriod ? 'Theo tiến độ' : 'Chưa có đợt')}</span>
                                    </span>
                                </div>
                                <p class="text-3xl font-black text-slate-900 tracking-tight">${not workflowCompleted && not empty activePeriod ?
                                    1 : 0}</p>
                                <p class="text-xs text-amber-600 font-bold truncate">Theo dõi lịch báo cáo</p>
                                <div class="stat-mini-progress">
                                    <div class="stat-mini-progress-bar"
                                        style="width: ${not empty activePeriod ? '75%' : '0%'}"></div>
                                </div>
                            </div>

                        </div>

                        <div class="dashboard-stat p-5" style="--stat-accent: #059669;">
                            <div class="space-y-1 flex-1 min-w-0">
                                <div class="flex items-center justify-between">
                                    <p class="text-[10px] font-extrabold uppercase tracking-wider text-slate-400">Lượt
                                        đánh giá</p>
                                    <span class="stat-trend-badge trend-up">
                                        <i data-lucide="award" class="w-3 h-3 text-emerald-500"></i>
                                        <span>HĐ phản biện</span>
                                    </span>
                                </div>
                                <p class="text-3xl font-black text-slate-900 tracking-tight">${fn:length(myScores)}</p>
                                <p class="text-xs text-emerald-600 font-bold truncate">Điểm từ hội đồng PB</p>
                                <div class="stat-mini-progress">
                                    <div class="stat-mini-progress-bar"
                                        style="width: ${fn:length(myScores) > 0 ? '100%' : '15%'}"></div>
                                </div>
                            </div>

                        </div>

                        <div class="dashboard-stat p-5" style="--stat-accent: #7c3aed;">
                            <div class="space-y-1 flex-1 min-w-0">
                                <div class="flex items-center justify-between">
                                    <p class="text-[10px] font-extrabold uppercase tracking-wider text-slate-400">Điểm
                                        tổng kết</p>
                                    <span class="stat-trend-badge ${not empty avgScore ? 'trend-up' : 'trend-neutral'}">
                                        <i data-lucide="sparkles" class="w-3 h-3 text-purple-500"></i>
                                        <span>${not empty avgScore ? 'Đã chấm' : 'Chưa có'}</span>
                                    </span>
                                </div>
                                <p class="text-3xl font-black text-slate-900 tracking-tight">${not empty avgScore ?
                                    avgScore : '--'}</p>
                                <p class="text-xs text-purple-600 font-bold truncate">Trung bình các lượt chấm</p>
                                <div class="stat-mini-progress">
                                    <div class="stat-mini-progress-bar"
                                        style="width: ${not empty avgScore ? '100%' : '0%'}"></div>
                                </div>
                            </div>

                        </div>
                    </section>

                    <!-- Main 2-Column Section -->
                    <div class="grid grid-cols-1 lg:grid-cols-12 gap-6">
                        <!-- Left: Group và Topic Status Card (7 cols) -->
                        <div class="lg:col-span-7 space-y-6">
                            <div class="bg-white rounded-3xl border border-slate-200 p-6 shadow-sm space-y-4">
                                <div class="flex items-center justify-between pb-3 border-b border-slate-100">
                                    <h4 class="text-sm font-bold text-slate-900 flex items-center gap-2">
                                        <i data-lucide="users" class="w-4 h-4 text-sky-600"></i>
                                        <span>Trạng thái nhóm và đề tài</span>
                                    </h4>
                                    <a href="${pageContext.request.contextPath}/student/group"
                                        class="inline-flex items-center gap-1 text-xs font-bold text-sky-600 hover:text-sky-700">
                                        Quản lý nhóm <i data-lucide="chevron-right" class="w-3.5 h-3.5"></i>
                                    </a>
                                </div>

                                <c:choose>
                                    <c:when test="${empty myGroup}">
                                        <div
                                            class="empty-state py-8 bg-slate-50 rounded-2xl border border-slate-200/80 space-y-3">
                                            <div class="empty-state-icon-wrap w-12 h-12 mb-0">
                                                <i data-lucide="users-round" class="w-6 h-6 opacity-40"></i>
                                            </div>
                                            <div class="empty-state-title">Bạn chưa tham gia nhóm sinh viên nào</div>
                                            <div class="empty-state-desc">Hãy tạo nhóm mới hoặc gia nhập nhóm bạn học để
                                                cùng thực hiện đề tài tốt nghiệp.</div>
                                            <div>
                                                <a href="${pageContext.request.contextPath}/student/group"
                                                    class="btn-ui btn-ui-primary text-xs py-2 px-4">
                                                    <i data-lucide="plus" class="w-4 h-4"></i> Tạo nhóm mới (Tối đa 3
                                                    SV)
                                                </a>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div
                                            class="p-4 rounded-2xl bg-slate-50 border border-slate-200 space-y-3 text-xs">
                                            <div class="flex items-center justify-between">
                                                <h5 class="font-extrabold text-slate-900 text-sm"><c:out value="${myGroup.name}" /></h5>
                                                <span class="status-badge status-info">${enumLabel.label(myGroup.status)}</span>
                                            </div>
                                            <div class="text-slate-600 space-y-1.5">
                                                <div class="flex items-center gap-1.5 text-amber-800 font-bold">
                                                    <i data-lucide="crown" class="w-4 h-4 text-amber-500"></i>
                                                    <span>Trưởng nhóm: ${myGroup.leader.user.fullName}
                                                        (${myGroup.leader.studentCode})</span>
                                                </div>
                                                <div class="flex items-center gap-1.5 text-slate-500 font-medium">
                                                    <i data-lucide="users" class="w-4 h-4 text-slate-400"></i>
                                                    <span>Thành viên:
                                                        <c:forEach var="m" items="${myGroup.members}" varStatus="loop">
                                                            ${m.student.user.fullName}${!loop.last ? ', ' : ''}
                                                        </c:forEach>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Registered Topic Card -->
                                        <c:choose>
                                            <c:when test="${not empty myRegistration}">
                                                <div
                                                    class="p-5 rounded-2xl bg-white border border-slate-200 space-y-3 text-xs shadow-xs">
                                                    <div class="flex items-center justify-between">
                                                        <span class="code-tag">${myRegistration.topic.code}</span>
                                                        <span
                                                            class="status-badge ${myRegistration.status == 'APPROVED' ? 'status-approved' : myRegistration.status == 'PENDING' ? 'status-pending' : 'status-danger'}">
                                                            ${enumLabel.label(myRegistration.status)}
                                                        </span>
                                                    </div>
                                                    <h5 class="text-sm font-bold text-slate-900 leading-snug">
                                                        <c:out value="${myRegistration.topic.title}" /></h5>
                                                    <div class="text-slate-500">
                                                        GVHD: <strong
                                                            class="text-slate-800"><c:out value="${myRegistration.topic.lecturer !=
                                                            null ? myRegistration.topic.lecturer.user.fullName : 'Chưa
                                                            phân công'}" /></strong>
                                                    </div>

                                                    <c:if test="${myRegistration.status == 'APPROVED'}">
                                                        <div
                                                            class="pt-3 border-t border-slate-100 flex items-center gap-3">
                                                            <a href="${pageContext.request.contextPath}/student/reports"
                                                                class="btn-ui btn-ui-primary text-xs py-2 px-3.5">
                                                                <i data-lucide="cloud-upload" class="w-3.5 h-3.5"></i>
                                                                Nộp báo cáo tiến độ
                                                            </a>
                                                            <a href="${pageContext.request.contextPath}/student/results"
                                                                class="btn-ui btn-ui-outline text-xs py-2 px-3.5">
                                                                <i data-lucide="trophy"
                                                                    class="w-3.5 h-3.5 text-amber-500"></i> Xem kết quả
                                                                và Lịch
                                                            </a>
                                                        </div>
                                                    </c:if>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div
                                                    class="text-center py-6 text-slate-400 text-xs bg-slate-50 rounded-2xl border border-dashed border-slate-200 space-y-2">
                                                    <p>Nhóm chưa đăng ký đề tài nào trong đợt này.</p>
                                                    <a href="${pageContext.request.contextPath}/student/topics"
                                                        class="inline-flex items-center gap-1 text-sky-600 font-bold hover:underline">
                                                        Tra cứu và Đăng ký đề tài ngay &rarr;
                                                    </a>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- Right: Council và Grade Result Card (5 cols) -->
                        <div class="lg:col-span-5 space-y-6">
                            <div class="bg-white rounded-3xl border border-slate-200 p-6 shadow-sm space-y-4">
                                <h4
                                    class="text-sm font-bold text-slate-900 flex items-center gap-2 pb-3 border-b border-slate-100">
                                    <i data-lucide="award" class="w-4 h-4 text-emerald-600"></i>
                                    <span>Kết quả báo cáo hội đồng</span>
                                </h4>

                                <c:choose>
                                    <c:when test="${not empty avgScore}">
                                        <div
                                            class="bg-gradient-to-br from-emerald-50 to-teal-50 border border-emerald-200 rounded-3xl p-6 text-center space-y-1">
                                            <div
                                                class="text-[10px] font-extrabold uppercase tracking-widest text-emerald-800">
                                                Điểm tổng kết khóa luận</div>
                                            <div class="text-4xl font-black text-emerald-600">${avgScore}</div>
                                            <span
                                                class="status-badge ${avgScore >= 8.5 ? 'status-approved' : 'status-info'} mt-1">
                                                ${avgScore >= 8.5 ? 'Xuất sắc / Giỏi' : avgScore >= 7.0 ? 'Khá' : 'Đạt'}
                                            </span>
                                        </div>

                                        <div class="space-y-2 pt-2">
                                            <h5
                                                class="text-[10px] font-extrabold  tracking-wider text-slate-400">
                                                Nhận xét từ hội đồng:</h5>
                                            <c:forEach var="sc" items="${myScores}">
                                                <div
                                                    class="p-3.5 bg-slate-50 rounded-2xl border border-slate-200/80 text-xs space-y-1">
                                                    <div class="font-bold text-slate-800">
                                                        ${sc.councilMember.lecturer.user.fullName}
                                                        (${enumLabel.label(sc.councilMember.role)}):</div>
                                                    <div class="text-slate-600 italic text-[11px]">"${sc.comment}"</div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:when>
                                    <c:when test="${not empty myAssignment}">
                                        <div
                                            class="p-4 bg-slate-50 rounded-2xl border border-slate-200 text-xs space-y-2">
                                            <div class="flex items-center gap-2 font-bold text-slate-900">
                                                <i data-lucide="calendar-check" class="w-4 h-4 text-sky-600"></i>
                                                <span>Đã có lịch báo cáo hội đồng</span>
                                            </div>
                                            <div class="text-slate-600 space-y-1">
                                                <div><strong>Hội đồng:</strong> <c:out value="${myAssignment.council.name}" /></div>
                                                <div><strong>Ngày báo cáo:</strong> ${dateDisplay.format(myAssignment.council.councilDate)}
                                                </div>
                                                <div><strong>Phòng:</strong> ${myAssignment.council.location}</div>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="empty-state py-8">
                                            <div class="empty-state-icon-wrap w-10 h-10 mb-2">
                                                <i data-lucide="clock" class="w-5 h-5 opacity-40"></i>
                                            </div>
                                            <div class="empty-state-desc text-xs mb-0">Chưa có lịch báo cáo hoặc điểm số
                                                tổng kết</div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </main>

                <jsp:include page="../common/footer.jsp" />

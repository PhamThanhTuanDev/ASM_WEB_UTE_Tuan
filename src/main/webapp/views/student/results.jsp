<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set scope="request" var="pageTitle" value="Lịch và điểm số phản biện" />
<c:set scope="request" var="pageHeading" value="Lịch báo cáo hội đồng và kết quả điểm số" />
<c:set scope="request" var="pageSubheading" value="Theo dõi phòng báo cáo, thời gian và tra cứu điểm số chi tiết từ Hội đồng phản biện" />
<c:set scope="request" var="activeMenu" value="results" />

<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/sidebar.jsp" />

<div class="app-main">
    <jsp:include page="../common/navbar.jsp" />

    <main class="app-content workspace-page space-y-6">
        <c:choose>
            <c:when test="${empty myGroup || empty registration}">
                <div class="glass-card rounded-3xl border border-slate-200/90 p-12 text-center shadow-sm max-w-2xl mx-auto space-y-4">
                    <div class="w-16 h-16 rounded-2xl bg-slate-100 text-slate-400 flex items-center justify-center mx-auto">
                        <i data-lucide="trophy" class="w-8 h-8 opacity-40"></i>
                    </div>
                    <h4 class="text-base font-bold text-slate-800">Chưa có kết quả đánh giá</h4>
                    <p class="text-xs text-slate-500 max-w-md mx-auto leading-relaxed">
                        Nhóm chưa đăng ký đề tài hoặc chưa đến thời gian thành lập hội đồng phản biện và chấm điểm.
                    </p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="grid grid-cols-1 lg:grid-cols-12 gap-6">
                    <!-- Left: Council Defense Schedule Card (5 cols) -->
                    <div class="lg:col-span-5 space-y-6">
                        <div class="bg-white rounded-3xl border border-slate-200/90 p-6 shadow-xs space-y-5">
                            <div class="flex items-center gap-3 pb-4 border-b border-slate-100">
                                <div class="w-10 h-10 rounded-2xl bg-sky-50 text-sky-600 flex items-center justify-center shrink-0">
                                    <i data-lucide="calendar-check" class="w-5 h-5"></i>
                                </div>
                                <div class="min-w-0">
                                    <h4 class="text-sm font-bold text-slate-900">Lịch báo cáo trước hội đồng</h4>
                                    <p class="text-[11px] text-slate-500 truncate">Đề tài: <strong>${registration.topic.code}</strong></p>
                                </div>
                            </div>

                            <c:choose>
                                <c:when test="${not empty assignment}">
                                    <div class="p-5 bg-gradient-to-br from-slate-50 to-sky-50/40 rounded-2xl border border-slate-200/80 space-y-3.5 text-xs">
                                        <div class="flex items-center justify-between">
                                            <span class="px-2.5 py-1 rounded-xl font-mono font-bold text-xs bg-slate-900 text-white shadow-2xs">
                                                ${assignment.council.code}
                                            </span>
                                            <span class="status-badge ${assignment.council.status == 'COMPLETED' ? 'status-success' : 'status-pending'} text-[10px]">
                                                ${enumLabel.label(assignment.council.status)}
                                            </span>
                                        </div>

                                        <h5 class="text-sm font-bold text-slate-900 leading-snug"><c:out value="${assignment.council.name}" /></h5>

                                        <div class="space-y-2.5 pt-3 border-t border-slate-200/60">
                                            <div class="flex items-center justify-between">
                                                <span class="text-slate-500 flex items-center gap-2"><i data-lucide="calendar" class="w-3.5 h-3.5 text-sky-600"></i> Ngày báo cáo:</span>
                                                <span class="font-bold text-slate-800">${assignment.council.councilDate != null ? dateDisplay.format(assignment.council.councilDate) : 'Chưa định'}</span>
                                            </div>
                                            <div class="flex items-center justify-between">
                                                <span class="text-slate-500 flex items-center gap-2"><i data-lucide="map-pin" class="w-3.5 h-3.5 text-rose-500"></i> Phòng báo cáo:</span>
                                                <span class="font-bold text-slate-800">${assignment.council.location != null ? assignment.council.location : 'Chưa định'}</span>
                                            </div>
                                            <div class="flex items-center justify-between">
                                                <span class="text-slate-500 flex items-center gap-2"><i data-lucide="crown" class="w-3.5 h-3.5 text-amber-500"></i> Chủ tịch Hội đồng:</span>
                                                <span class="font-bold text-slate-800"><c:out value="${assignment.council.chairman.user.fullName}" /></span>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="bg-sky-500/10 border border-sky-300/80 text-sky-950 rounded-2xl p-4 text-xs flex items-start gap-3">
                                        <i data-lucide="info" class="w-4 h-4 text-sky-600 shrink-0 mt-0.5"></i>
                                        <div class="leading-relaxed">
                                            <strong>Lưu ý thí sinh:</strong> Các thành viên trong nhóm vui lòng có mặt trước 15 phút, trang phục lịch sự và chuẩn bị sẵn slide thuyết trình.
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-10 text-slate-400 text-xs bg-slate-50/70 rounded-2xl border border-slate-200/70 space-y-2">
                                        <i data-lucide="clock" class="w-8 h-8 mx-auto opacity-40"></i>
                                        <p class="font-medium text-slate-600">Khoa đang sắp xếp lịch và thành lập hội đồng phản biện cho đề tài của bạn.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Right: Score Card Overview và Detailed Council Comments (7 cols) -->
                    <div class="lg:col-span-7 space-y-6">
                        <div class="bg-white rounded-3xl border border-slate-200/90 p-6 shadow-xs space-y-5">
                            <div class="flex items-center justify-between pb-3 border-b border-slate-100">
                                <h4 class="text-sm font-bold text-slate-900 flex items-center gap-2">
                                    <i data-lucide="award" class="w-4 h-4 text-emerald-600"></i> Bảng điểm và Nhận xét chi tiết
                                </h4>
                                <c:if test="${not empty avgScore}">
                                    <span class="status-badge ${avgScore >= 8.5 ? 'status-success' : avgScore >= 7.0 ? 'status-info' : 'status-pending'} text-xs">
                                        ${avgScore >= 8.5 ? 'XUẤT SẮC / GIỎI' : avgScore >= 7.0 ? 'KHÁ' : avgScore >= 5.0 ? 'ĐẠT YÊU CẦU' : 'CHƯA ĐẠT'}
                                    </span>
                                </c:if>
                            </div>

                            <c:choose>
                                <c:when test="${not empty avgScore}">
                                    <!-- Big Average Score Highlight Card with 3D Depth -->
                                    <div class="bg-gradient-to-br from-emerald-500/10 via-teal-500/5 to-sky-500/10 border border-emerald-300/80 rounded-3xl p-6 text-center shadow-xs space-y-2 relative overflow-hidden">
                                        <div class="text-[11px] font-extrabold uppercase tracking-wider text-emerald-800">
                                            Điểm Tổng Kết (50% Quá Trình + 50% Hội Đồng)
                                        </div>
                                        <div class="text-5xl font-black text-emerald-600 tracking-tight drop-shadow-xs">
                                            ${avgScore}
                                        </div>
                                        <div class="text-xs text-slate-500 font-medium">
                                            Thang điểm chuẩn 10.0
                                        </div>
                                    </div>

                                    <c:if test="${not empty processScore}">
                                        <div class="grid grid-cols-2 gap-3">
                                            <div class="rounded-2xl bg-sky-50/70 border border-sky-200/80 p-4 text-center">
                                                <div class="text-[10px] font-extrabold uppercase tracking-wider text-sky-700">Điểm quá trình</div>
                                                <div class="text-2xl font-black text-sky-700 mt-1">${processScore} / 10</div>
                                            </div>
                                            <div class="rounded-2xl bg-emerald-50/70 border border-emerald-200/80 p-4 text-center">
                                                <div class="text-[10px] font-extrabold uppercase tracking-wider text-emerald-700">Điểm hội đồng</div>
                                                <div class="text-2xl font-black text-emerald-700 mt-1">${scoringService.calculateAverageScore(assignment.id)} / 10</div>
                                            </div>
                                        </div>
                                    </c:if>

                                    <c:if test="${not empty processEvaluations}">
                                        <div class="space-y-2 pt-2">
                                            <h5 class="text-xs font-bold  tracking-wider text-slate-500">Điểm quá trình từ giảng viên hướng dẫn:</h5>
                                            <c:forEach var="evaluation" items="${processEvaluations}">
                                                <div class="p-3.5 bg-sky-50/50 rounded-2xl border border-sky-100 text-xs space-y-1">
                                                    <div class="flex items-center justify-between">
                                                        <span class="font-bold text-slate-800"><c:out value="${evaluation.reviewer.user.fullName}" /></span>
                                                        <span class="font-black text-sky-700">${evaluation.score} / 10</span>
                                                    </div>
                                                    <div class="text-slate-600 italic text-[11px] leading-relaxed">"<c:out value="${evaluation.comment}" />"</div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:if>

                                    <!-- Detailed Feedback Accordion from each Council Member -->
                                    <div class="space-y-3 pt-2" data-accordion>
                                        <h5 class="text-xs font-bold  tracking-wider text-slate-500 flex items-center gap-1.5">
                                            <i data-lucide="message-square" class="w-3.5 h-3.5 text-sky-600"></i> Nhận xét chi tiết từ từng Giảng viên Hội đồng:
                                        </h5>

                                        <div class="space-y-2.5">
                                            <c:forEach var="sc" items="${scores}" varStatus="st">
                                                <div class="rounded-2xl bg-slate-50/80 border border-slate-200/90 overflow-hidden transition-all" data-accordion-item>
                                                    <button type="button" data-accordion-trigger
                                                            class="w-full p-4 flex items-center justify-between gap-3 text-left hover:bg-sky-50/40 transition-colors">
                                                        <div class="flex items-center gap-3 min-w-0">
                                                            <div class="w-9 h-9 rounded-xl bg-gradient-to-tr from-sky-600 to-blue-700 text-white font-bold text-xs flex items-center justify-center shrink-0 shadow-2xs">
                                                                <c:out value="${fn:substring(sc.councilMember.lecturer.user.fullName, 0, 1)}" />
                                                            </div>
                                                            <div class="min-w-0">
                                                                <span class="font-bold text-slate-900 text-xs block truncate"><c:out value="${sc.councilMember.lecturer.user.fullName}" /></span>
                                                                <span class="text-[10px] font-semibold text-slate-500">${enumLabel.label(sc.councilMember.role)}</span>
                                                            </div>
                                                        </div>
                                                        <div class="flex items-center gap-2.5 shrink-0">
                                                            <span class="status-badge status-success text-xs font-black">
                                                                ${sc.score} / 10
                                                            </span>
                                                            <i data-lucide="chevron-down" class="w-4 h-4 text-slate-400 transition-transform duration-300"></i>
                                                        </div>
                                                    </button>
                                                    <div data-accordion-panel class="${st.first ? '' : 'hidden'} px-4 pb-4">
                                                        <div class="bg-white p-3.5 rounded-xl border border-slate-200/80 text-slate-700 italic leading-relaxed text-[11px]">
                                                            "<c:out value="${sc.comment}" />"
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-12 text-slate-400 text-xs bg-slate-50/70 rounded-2xl border border-slate-200/70 space-y-2">
                                        <i data-lucide="clock" class="w-8 h-8 mx-auto opacity-40"></i>
                                        <p class="font-bold text-slate-700 text-sm">Hội đồng đang trong quá trình chấm điểm.</p>
                                        <p class="text-[11px] text-slate-400 max-w-sm mx-auto leading-relaxed">Kết quả điểm số tổng kết và lời nhận xét sẽ được hiển thị ngay khi Hội đồng hoàn tất phiên bảo vệ.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </main>

<jsp:include page="../common/footer.jsp" />



<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle" value="Bảng điều khiển sinh viên" />
<c:set var="pageHeading" value="Không gian đề tài của sinh viên" />
<c:set var="pageSubheading" value="Chào bạn, ${student.user.fullName} (MSSV: ${student.studentCode} &bull; Lớp: ${student.className})" />
<c:set var="activeMenu" value="dashboard" />

<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/sidebar.jsp" />

<div class="app-main">
    <jsp:include page="../common/navbar.jsp" />

    <main class="app-content space-y-6">
        <!-- Process Timeline Banner -->
        <c:if test="${not empty activePeriod}">
            <div class="bg-gradient-to-r from-blue-900 via-indigo-900 to-blue-800 text-white rounded-3xl p-6 shadow-md shadow-blue-900/10 space-y-4">
                <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-2 border-b border-white/10 pb-3">
                    <div class="flex items-center gap-2.5">
                        <div class="p-2 rounded-xl bg-white/10 text-amber-300">
                            <i data-lucide="calendar-range" class="w-5 h-5"></i>
                        </div>
                        <div>
                            <h3 class="text-base font-bold text-white">${activePeriod.name}</h3>
                            <p class="text-xs text-blue-200">Quy trình theo dõi 4 giai đoạn thực hiện đề tài tốt nghiệp</p>
                        </div>
                    </div>
                    <span class="px-3 py-1 rounded-full text-xs font-bold bg-white/15 text-white border border-white/20 self-start sm:self-auto">
                        ${activePeriod.type}
                    </span>
                </div>

                <!-- Step-by-Step Progress Timeline -->
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-3 pt-1">
                    <div class="p-3.5 rounded-2xl bg-white/10 border border-white/10 space-y-1">
                        <div class="flex items-center gap-2 text-xs font-bold text-emerald-300">
                            <i data-lucide="check-circle-2" class="w-4 h-4 text-emerald-400"></i>
                            <span>1. Giảng viên đề xuất</span>
                        </div>
                        <div class="text-[11px] text-blue-100">${activePeriod.lecturerStartDate} &rarr; ${activePeriod.lecturerEndDate}</div>
                    </div>

                    <div class="p-3.5 rounded-2xl ${myGroup != null ? 'bg-white/15 border-blue-400 text-white' : 'bg-white/10 border-white/10'} border space-y-1">
                        <div class="flex items-center gap-2 text-xs font-bold ${myGroup != null ? 'text-emerald-300' : 'text-amber-300'}">
                            <i data-lucide="${myGroup != null ? 'check-circle-2' : 'users'}" class="w-4 h-4"></i>
                            <span>2. Lập nhóm và chọn đề tài</span>
                        </div>
                        <div class="text-[11px] text-blue-100">${activePeriod.studentStartDate} &rarr; ${activePeriod.studentEndDate}</div>
                    </div>

                    <div class="p-3.5 rounded-2xl ${myRegistration != null && myRegistration.status == 'APPROVED' ? 'bg-white/15 border-blue-400' : 'bg-white/5 border-white/5 opacity-80'} border space-y-1">
                        <div class="flex items-center gap-2 text-xs font-bold ${myRegistration != null && myRegistration.status == 'APPROVED' ? 'text-amber-300' : 'text-slate-300'}">
                            <i data-lucide="file-check" class="w-4 h-4"></i>
                            <span>3. Thực hiện và báo cáo</span>
                        </div>
                        <div class="text-[11px] text-blue-200">Hạn PB: ${activePeriod.reviewerDeadline != null ? activePeriod.reviewerDeadline : 'Chưa định'}</div>
                    </div>

                    <div class="p-3.5 rounded-2xl ${avgScore != null ? 'bg-white/15 border-emerald-400' : 'bg-white/5 border-white/5 opacity-80'} border space-y-1">
                        <div class="flex items-center gap-2 text-xs font-bold ${avgScore != null ? 'text-emerald-300' : 'text-slate-300'}">
                            <i data-lucide="trophy" class="w-4 h-4"></i>
                            <span>4. Hội đông đánh giá</span>
                        </div>
                        <div class="text-[11px] text-blue-200">${activePeriod.councilReportDate != null ? activePeriod.councilReportDate : 'Chưa định'}</div>
                    </div>
                </div>
            </div>
        </c:if>

        <div class="grid grid-cols-1 lg:grid-cols-12 gap-6">
            <!-- Left: Group & Topic Status Card (7 cols) -->
            <div class="lg:col-span-7 space-y-6">
                <div class="bg-white rounded-2xl border border-slate-200 p-6 shadow-xs space-y-4">
                    <div class="flex items-center justify-between pb-3 border-b border-slate-100">
                        <h4 class="text-sm font-bold text-slate-900 flex items-center gap-2">
                            <i data-lucide="users" class="w-4 h-4 text-blue-600"></i> Trạng thái nhóm và đề tài
                        </h4>
                        <a href="${pageContext.request.contextPath}/student/group" class="inline-flex items-center gap-1 text-xs font-bold text-blue-600 hover:text-blue-700">
                            Quản lý nhóm <i data-lucide="chevron-right" class="w-3.5 h-3.5"></i>
                        </a>
                    </div>

                    <c:choose>
                        <c:when test="${empty myGroup}">
                            <div class="text-center py-8 text-slate-400 text-xs bg-slate-50 rounded-2xl border border-slate-100 space-y-3">
                                <i data-lucide="users-round" class="w-10 h-10 mx-auto text-slate-300"></i>
                                <p>Bạn chưa tham gia nhóm sinh viên nào trong đợt này.</p>
                                <div>
                                    <a href="${pageContext.request.contextPath}/student/group" class="inline-flex items-center gap-2 px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white font-bold rounded-xl text-xs shadow-xs transition-colors">
                                        <i data-lucide="plus" class="w-4 h-4"></i> Tạo nhóm mới (Tối đa 3 SV)
                                    </a>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="p-4 rounded-2xl bg-slate-50 border border-slate-200 space-y-3 text-xs">
                                <div class="flex items-center justify-between">
                                    <h5 class="font-black text-slate-900 text-sm">${myGroup.name}</h5>
                                    <span class="px-2.5 py-0.5 rounded-full text-[10px] font-bold bg-blue-50 text-blue-700 border border-blue-200">${myGroup.status}</span>
                                </div>
                                <div class="text-slate-600 space-y-1">
                                    <div class="flex items-center gap-1.5 text-amber-700 font-semibold">
                                        <i data-lucide="crown" class="w-3.5 h-3.5 text-amber-500"></i>
                                        <span>Trưởng nhóm: ${myGroup.leader.user.fullName} (${myGroup.leader.studentCode})</span>
                                    </div>
                                    <div class="flex items-center gap-1.5 text-slate-500">
                                        <i data-lucide="users" class="w-3.5 h-3.5 text-slate-400"></i>
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
                                    <div class="p-4 rounded-2xl bg-white border border-slate-200 space-y-3 text-xs">
                                        <div class="flex items-center justify-between">
                                            <span class="px-2.5 py-1 rounded font-mono font-bold text-xs bg-blue-50 text-blue-700 border border-blue-200">${myRegistration.topic.code}</span>
                                            <span class="px-2.5 py-1 rounded-lg text-xs font-bold ${myRegistration.status == 'APPROVED' ? 'bg-emerald-100 text-emerald-800 border border-emerald-200' : myRegistration.status == 'PENDING' ? 'bg-amber-100 text-amber-800 border border-amber-200' : 'bg-rose-100 text-rose-800 border border-rose-200'}">
                                                ${myRegistration.status}
                                            </span>
                                        </div>
                                        <h5 class="text-sm font-bold text-slate-900 leading-snug">${myRegistration.topic.title}</h5>
                                        <div class="text-slate-500">
                                            GVHD: <strong>${myRegistration.topic.lecturer != null ? myRegistration.topic.lecturer.user.fullName : 'N/A'}</strong>
                                        </div>

                                        <c:if test="${myRegistration.status == 'APPROVED'}">
                                            <div class="pt-2 border-t border-slate-100 flex items-center gap-3">
                                                <a href="${pageContext.request.contextPath}/student/reports" class="inline-flex items-center gap-1.5 px-3.5 py-2 bg-blue-600 hover:bg-blue-700 text-white font-bold rounded-xl text-xs shadow-xs transition-colors">
                                                    <i data-lucide="cloud-upload" class="w-3.5 h-3.5"></i> Nộp báo cáo
                                                </a>
                                                <a href="${pageContext.request.contextPath}/student/results" class="inline-flex items-center gap-1.5 px-3.5 py-2 bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold rounded-xl text-xs transition-colors">
                                                    <i data-lucide="trophy" class="w-3.5 h-3.5 text-amber-500"></i> Xem kết quả & Lịch
                                                </a>
                                            </div>
                                        </c:if>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-6 text-slate-400 text-xs bg-slate-50 rounded-2xl border border-dashed border-slate-200 space-y-2">
                                        <p>Nhóm chưa đăng ký đề tài nào.</p>
                                        <a href="${pageContext.request.contextPath}/student/topics" class="inline-flex items-center gap-1 text-blue-600 font-bold hover:underline">
                                            Tra cứu & đăng ký đề tài ngay &rarr;
                                        </a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Right: Council & Grade Result Card (5 cols) -->
            <div class="lg:col-span-5 space-y-6">
                <div class="bg-white rounded-2xl border border-slate-200 p-6 shadow-xs space-y-4">
                    <h4 class="text-sm font-bold text-slate-900 flex items-center gap-2 pb-3 border-b border-slate-100">
                        <i data-lucide="award" class="w-4 h-4 text-emerald-600"></i> Kết quả báo cáo hội đồng
                    </h4>

                    <c:choose>
                        <c:when test="${not empty avgScore}">
                            <div class="bg-gradient-to-br from-emerald-50 to-teal-50 border border-emerald-200 rounded-3xl p-5 text-center space-y-1">
                                <div class="text-[10px] font-bold uppercase tracking-wider text-emerald-800">Điểm trung bình hội đồng</div>
                                <div class="text-4xl font-black text-emerald-600">${avgScore}</div>
                                <span class="inline-block px-2.5 py-0.5 rounded-full text-xs font-bold ${avgScore >= 8.5 ? 'bg-emerald-200 text-emerald-900' : 'bg-blue-200 text-blue-900'}">
                                    ${avgScore >= 8.5 ? 'Xuất sắc / Giỏi' : avgScore >= 7.0 ? 'Khá' : 'Đạt'}
                                </span>
                            </div>

                            <div class="space-y-2 pt-2">
                                <h5 class="text-[11px] font-bold uppercase tracking-wider text-slate-500">Nhận xét từ hội đồng:</h5>
                                <c:forEach var="sc" items="${myScores}">
                                    <div class="p-3 bg-slate-50 rounded-xl border border-slate-100 text-xs space-y-1">
                                        <div class="font-bold text-slate-800">${sc.councilMember.lecturer.user.fullName} (${sc.councilMember.role}):</div>
                                        <div class="text-slate-600 italic text-[11px]">"${sc.comment}"</div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:when test="${not empty myAssignment}">
                            <div class="p-4 bg-slate-50 rounded-2xl border border-slate-200 text-xs space-y-2">
                                <div class="flex items-center gap-2 font-bold text-slate-900">
                                    <i data-lucide="calendar-check" class="w-4 h-4 text-blue-600"></i>
                                    <span>Đã Có Lịch Báo Cáo Hội Đồng</span>
                                </div>
                                <div class="text-slate-600 space-y-1">
                                    <div><strong>Hội đồng:</strong> ${myAssignment.council.name}</div>
                                    <div><strong>Ngày báo cáo:</strong> ${myAssignment.council.councilDate}</div>
                                    <div><strong>Phòng:</strong> ${myAssignment.council.location}</div>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-8 text-slate-400 text-xs bg-slate-50 rounded-2xl border border-slate-100 space-y-1">
                                <i data-lucide="clock" class="w-8 h-8 mx-auto opacity-40"></i>
                                <p>Chưa có lịch báo cáo hoặc điểm số tổng kết.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </main>

<jsp:include page="../common/footer.jsp" />


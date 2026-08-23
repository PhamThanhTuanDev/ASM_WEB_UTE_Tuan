<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle" value="Bảng điều khiển giảng viên" />
<c:set var="pageHeading" value="Không gian làm việc giảng viên" />
<c:set var="pageSubheading" value="Chào mừng Thầy/Cô ${lecturer.user.fullName} (${lecturer.department.name})" />
<c:set var="activeMenu" value="dashboard" />

<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/sidebar.jsp" />

<div class="app-main">
    <jsp:include page="../common/navbar.jsp" />

    <main class="app-content space-y-6">
        <!-- Stat Cards -->
        <div class="grid grid-cols-1 sm:grid-cols-3 gap-5">
            <div class="bg-white rounded-2xl border border-slate-200 p-5 shadow-xs flex items-center justify-between">
                <div class="space-y-1">
                    <div class="text-[11px] font-bold uppercase tracking-wider text-slate-400">Đề tài hướng dẫn</div>
                    <div class="text-3xl font-black text-blue-600">${fn:length(myTopics)}</div>
                    <div class="text-xs text-slate-500">GVHD Chính & Đồng hướng dẫn</div>
                </div>
                <div class="w-12 h-12 rounded-2xl bg-blue-50 text-blue-600 flex items-center justify-center shrink-0">
                    <i data-lucide="book-marked" class="w-6 h-6"></i>
                </div>
            </div>

            <div class="bg-white rounded-2xl border border-slate-200 p-5 shadow-xs flex items-center justify-between">
                <div class="space-y-1">
                    <div class="text-[11px] font-bold uppercase tracking-wider text-slate-400">Nhóm sinh viên</div>
                    <div class="text-3xl font-black text-emerald-600">${fn:length(myGroupRegs)}</div>
                    <div class="text-xs text-slate-500">Đang theo dõi & duyệt đăng ký</div>
                </div>
                <div class="w-12 h-12 rounded-2xl bg-emerald-50 text-emerald-600 flex items-center justify-center shrink-0">
                    <i data-lucide="users" class="w-6 h-6"></i>
                </div>
            </div>

            <div class="bg-white rounded-2xl border border-slate-200 p-5 shadow-xs flex items-center justify-between">
                <div class="space-y-1">
                    <div class="text-[11px] font-bold uppercase tracking-wider text-slate-400">Hội đồng tham gia</div>
                    <div class="text-3xl font-black text-amber-600">${fn:length(myCouncils)}</div>
                    <div class="text-xs text-slate-500">Chủ tịch / Thư ký / Ủy viên</div>
                </div>
                <div class="w-12 h-12 rounded-2xl bg-amber-50 text-amber-600 flex items-center justify-center shrink-0">
                    <i data-lucide="scale" class="w-6 h-6"></i>
                </div>
            </div>
        </div>

        <!-- Active Period Banner -->
        <c:if test="${not empty activePeriod}">
            <div class="bg-gradient-to-r from-blue-900 via-indigo-900 to-blue-800 text-white rounded-3xl p-6 shadow-md shadow-blue-900/10 space-y-3">
                <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-2 border-b border-white/10 pb-3">
                    <div class="flex items-center gap-2.5">
                        <div class="p-2 rounded-xl bg-white/10 text-amber-300 shrink-0">
                            <i data-lucide="calendar-check" class="w-5 h-5"></i>
                        </div>
                        <div>
                            <h3 class="text-base font-bold text-white">${activePeriod.name}</h3>
                            <p class="text-xs text-blue-200">Đợt đăng ký và bảo vệ đang kích hoạt</p>
                        </div>
                    </div>
                    <span class="px-3 py-1 rounded-full text-xs font-bold bg-white/15 text-white border border-white/20 self-start sm:self-auto whitespace-nowrap">
                        ${activePeriod.type}
                    </span>
                </div>

                <div class="grid grid-cols-1 sm:grid-cols-3 gap-3 text-xs pt-1">
                    <div class="p-3 rounded-2xl bg-white/10 border border-white/10 flex items-center gap-2.5">
                        <i data-lucide="clock" class="w-4 h-4 text-amber-300 shrink-0"></i>
                        <div>
                            <div class="text-[10px] text-blue-200">Hạn GV đề xuất:</div>
                            <div class="font-bold">${activePeriod.lecturerStartDate} &rarr; ${activePeriod.lecturerEndDate}</div>
                        </div>
                    </div>

                    <div class="p-3 rounded-2xl bg-white/10 border border-white/10 flex items-center gap-2.5">
                        <i data-lucide="users" class="w-4 h-4 text-sky-300 shrink-0"></i>
                        <div>
                            <div class="text-[10px] text-blue-200">Hạn SV đăng ký:</div>
                            <div class="font-bold">${activePeriod.studentStartDate} &rarr; ${activePeriod.studentEndDate}</div>
                        </div>
                    </div>

                    <div class="p-3 rounded-2xl bg-white/10 border border-white/10 flex items-center gap-2.5">
                        <i data-lucide="flag" class="w-4 h-4 text-rose-300 shrink-0"></i>
                        <div>
                            <div class="text-[10px] text-blue-200">Hạn GVPB nộp điểm:</div>
                            <div class="font-bold">${activePeriod.reviewerDeadline != null ? activePeriod.reviewerDeadline : 'Chưa định'}</div>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>

        <div class="grid grid-cols-1 lg:grid-cols-12 gap-6">
            <!-- Supervised Topics List (7 cols) - Vừa khít khung 100% -->
            <div class="lg:col-span-7 space-y-6">
                <div class="bg-white rounded-2xl border border-slate-200 shadow-xs overflow-hidden">
                    <div class="p-5 border-b border-slate-100 flex items-center justify-between">
                        <h4 class="text-sm font-bold text-slate-900 flex items-center gap-2">
                            <i data-lucide="book-marked" class="w-4 h-4 text-blue-600"></i> Đề tài của tôi (${fn:length(myTopics)})
                        </h4>
                        <a href="${pageContext.request.contextPath}/lecturer/topics" class="inline-flex items-center gap-1.5 px-3 py-1.5 bg-blue-600 hover:bg-blue-700 text-white font-bold rounded-xl text-xs shadow-xs transition-colors shrink-0">
                            <i data-lucide="plus" class="w-3.5 h-3.5"></i> Đề xuất mới
                        </a>
                    </div>

                    <table class="w-full text-left border-collapse">
                        <thead>
                            <tr class="bg-slate-50 text-[11px] font-bold uppercase tracking-wider text-slate-500 border-b border-slate-200">
                                <th class="px-4 py-3.5 w-[42%]">Mã & Tên Đề tài</th>
                                <th class="px-4 py-3.5 w-[20%]">Vai trò</th>
                                <th class="px-4 py-3.5 w-[20%]">Đồng HD</th>
                                <th class="px-4 py-3.5 w-[18%] text-center">Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-100 text-xs">
                            <c:forEach var="t" items="${myTopics}">
                                <tr class="hover:bg-slate-50/80 transition-colors">
                                    <!-- Mã & Tên -->
                                    <td class="px-4 py-3.5 align-top w-[42%]">
                                        <span class="px-2 py-0.5 rounded font-mono font-bold text-[10px] bg-blue-50 text-blue-700 border border-blue-200 inline-block mb-1">
                                            ${t.code}
                                        </span>
                                        <div class="font-bold text-slate-900 leading-snug break-words">
                                            ${t.title}
                                        </div>
                                    </td>

                                    <!-- Vai trò -->
                                    <td class="px-4 py-3.5 align-top w-[20%] whitespace-nowrap">
                                        <span class="px-2 py-1 rounded-lg text-[11px] font-bold inline-block ${t.lecturer.id == lecturer.id ? 'bg-blue-100 text-blue-800 border border-blue-200' : 'bg-indigo-100 text-indigo-800 border border-indigo-200'}">
                                            ${t.lecturer.id == lecturer.id ? 'GVHD Chính' : 'Đồng HD'}
                                        </span>
                                    </td>

                                    <!-- Đồng Hướng Dẫn -->
                                    <td class="px-4 py-3.5 align-top w-[20%] text-slate-600 font-medium break-words leading-snug">
                                        ${t.coLecturer != null ? t.coLecturer.user.fullName : '<span class="text-slate-400">Không</span>'}
                                    </td>

                                    <!-- Trạng thái -->
                                    <td class="px-4 py-3.5 align-top w-[18%] text-center whitespace-nowrap">
                                        <span class="px-2.5 py-1 rounded-lg text-[10px] font-bold inline-block ${t.status == 'PUBLISHED' || t.status == 'APPROVED' ? 'bg-emerald-100 text-emerald-800 border border-emerald-200' : t.status == 'PENDING' ? 'bg-amber-100 text-amber-800 border border-amber-200' : 'bg-slate-100 text-slate-600 border border-slate-200'}">
                                            <c:choose>
                                                <c:when test="${t.status == 'PUBLISHED' || t.status == 'APPROVED'}">ĐÃ DUYỆT</c:when>
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
                <div class="bg-white rounded-2xl border border-slate-200 p-5 shadow-xs space-y-4">
                    <div class="flex items-center justify-between pb-3 border-b border-slate-100">
                        <h4 class="text-sm font-bold text-slate-900 flex items-center gap-2">
                            <i data-lucide="scale" class="w-4 h-4 text-amber-500"></i> Hội đồng tham gia (${fn:length(myCouncils)})
                        </h4>
                        <a href="${pageContext.request.contextPath}/lecturer/councils" class="text-xs font-bold text-blue-600 hover:text-blue-700">
                            Xem tất cả &rarr;
                        </a>
                    </div>

                    <div class="space-y-3">
                        <c:choose>
                            <c:when test="${empty myCouncils}">
                                <div class="text-center py-6 text-slate-400 text-xs">
                                    <i data-lucide="inbox" class="w-6 h-6 mx-auto mb-1 opacity-40"></i>
                                    Thầy/Cô chưa tham gia hội đồng nào.
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="mc" items="${myCouncils}">
                                    <div class="p-4 rounded-2xl bg-slate-50 border border-slate-200 space-y-2 text-xs">
                                        <div class="flex items-center justify-between gap-2">
                                            <h5 class="font-bold text-slate-900 break-words leading-snug">${mc.council.name}</h5>
                                            <span class="px-2 py-0.5 rounded font-bold text-[10px] bg-slate-900 text-white whitespace-nowrap shrink-0">
                                                <c:choose>
                                                    <c:when test="${mc.role == 'CHAIRMAN'}">CHỦ TỊCH</c:when>
                                                    <c:when test="${mc.role == 'SECRETARY'}">THƯ KÝ</c:when>
                                                    <c:otherwise>ỦY VIÊN</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                        <div class="text-slate-500 space-y-0.5">
                                            <div>Ngày báo cáo: <strong class="text-slate-700">${mc.council.councilDate != null ? mc.council.councilDate : 'Chưa định'}</strong></div>
                                            <div>Địa điểm: <strong class="text-slate-700">${mc.council.location != null ? mc.council.location : 'Chưa định'}</strong></div>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/lecturer/councils" class="w-full inline-flex items-center justify-center gap-1.5 px-3 py-2 bg-white hover:bg-blue-600 text-blue-600 hover:text-white border border-slate-200 font-bold rounded-xl text-xs transition-colors shadow-xs">
                                            <i data-lucide="pen-tool" class="w-3.5 h-3.5"></i> Chấm điểm các đề tài
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
</div>
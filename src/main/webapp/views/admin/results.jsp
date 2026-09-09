<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle" value="Điểm số & kết quả phản biện" />
<c:set var="pageHeading" value="Tổng hợp điểm số & công bố kết quả" />
<c:set var="pageSubheading" value="Tính điểm trung bình cộng từ các thành viên hội đồng và chốt công bố kết quả chính thức" />
<c:set var="activeMenu" value="results" />
<c:set var="suppressFlashMessage" value="true" />

<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/sidebar.jsp" />

<div class="app-main">
    <jsp:include page="../common/navbar.jsp" />

    <main class="app-content space-y-6">
        <c:if test="${not empty successMessage or not empty errorMessage}">
            <div id="scoreFlashMessage" class="hidden" data-message-type="${not empty successMessage ? 'success' : 'error'}">${not empty successMessage ? successMessage : errorMessage}</div>
        </c:if>
        <div data-pagination-list>
        <c:forEach var="c" items="${councils}">
            <div data-pagination-item class="bg-white rounded-2xl border border-slate-200 shadow-xs overflow-hidden">
                <!-- Header -->
                <div class="bg-slate-50/80 px-6 py-4 border-b border-slate-200 flex flex-col sm:flex-row sm:items-center justify-between gap-3">
                    <div class="flex items-center gap-3">
                        <span class="px-2.5 py-1 bg-slate-900 text-white rounded-lg font-mono font-bold text-xs">${c.code}</span>
                        <h3 class="text-sm font-bold text-slate-900">${c.name}</h3>
                        <span class="px-2 py-0.5 rounded text-[11px] font-bold ${c.status == 'COMPLETED' ? 'bg-emerald-100 text-emerald-800' : 'bg-amber-100 text-amber-800'}">
                            ${c.status}
                        </span>
                    </div>
                    <form method="post" action="${pageContext.request.contextPath}/admin/results/${c.id}/finalize" onsubmit="return confirmFinalize(event, '${c.name}');">
                        <button type="submit" class="inline-flex items-center gap-1.5 px-4 py-2 bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-bold rounded-xl shadow-xs transition-colors">
                            <i data-lucide="lock" class="w-3.5 h-3.5"></i> Chốt & Công Bố Điểm
                        </button>
                    </form>
                </div>

                <div class="p-0">
                    <c:set var="assignments" value="${councilService.getAssignments(c.id)}" />
                    <c:choose>
                        <c:when test="${empty assignments}">
                            <div class="text-center py-8 text-slate-400 text-xs">
                                <i data-lucide="folder-open" class="w-8 h-8 mx-auto mb-2 opacity-40"></i>
                                Chưa có đề tài nào được phân công cho Hội đồng này.
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="overflow-x-auto">
                                <table class="w-full text-left border-collapse">
                                    <thead>
                                        <tr class="bg-slate-50/50 border-b border-slate-200 text-[11px] font-bold uppercase tracking-wider text-slate-500">
                                            <th class="px-4 py-3">Đề tài Báo cáo</th>
                                            <th class="px-4 py-3">Nhóm Thực hiện</th>
                                            <th class="px-4 py-3">Điểm Thành viên Hội đồng</th>
                                            <th class="px-4 py-3 text-center">Điểm Tổng Kết (50/50)</th>
                                            <th class="px-4 py-3">Đánh giá Chung</th>
                                        </tr>
                                    </thead>
                                    <tbody class="divide-y divide-slate-100 text-xs">
                                        <c:forEach var="assign" items="${assignments}">
                                            <c:set var="scores" value="${scoringService.getScoresForAssignment(assign.id)}" />
                                            <c:set var="avg" value="${scoringService.calculateFinalScore(assign.id)}" />
                                            <tr class="hover:bg-slate-50/50 transition-colors">
                                                <td class="px-4 py-4 max-w-xs">
                                                    <span class="px-2 py-0.5 rounded font-mono font-bold text-[10px] bg-blue-50 text-blue-700 border border-blue-200">${assign.topicRegistration.topic.code}</span>
                                                    <div class="font-bold text-slate-800 line-clamp-1 mt-1">${assign.topicRegistration.topic.title}</div>
                                                    <div class="text-[11px] text-slate-500">GVHD: ${assign.topicRegistration.topic.lecturer.user.fullName}</div>
                                                </td>
                                                <td class="px-4 py-4">
                                                    <div class="font-bold text-slate-900">${assign.topicRegistration.group.name}</div>
                                                    <div class="text-[11px] text-slate-500">Trưởng nhóm: ${assign.topicRegistration.group.leader.user.fullName}</div>
                                                </td>
                                                <td class="px-4 py-4">
                                                    <div class="space-y-1">
                                                        <c:forEach var="sc" items="${scores}">
                                                            <div class="p-2 rounded-lg bg-slate-50 border border-slate-100 text-[11px]">
                                                                <div class="flex items-center justify-between">
                                                                    <span class="font-bold text-slate-800">${sc.councilMember.lecturer.user.fullName}:</span>
                                                                    <span class="font-bold text-blue-700 bg-blue-50 px-1.5 py-0.2 rounded">${sc.score} / 10</span>
                                                                </div>
                                                                <p class="text-slate-500 italic mt-0.5 line-clamp-1">"${sc.comment}"</p>
                                                            </div>
                                                        </c:forEach>
                                                    </div>
                                                </td>
                                                <td class="px-4 py-4 text-center">
                                                    <c:choose>
                                                        <c:when test="${avg != null}">
                                                            <div class="text-2xl font-black ${avg >= 5.0 ? 'text-emerald-600' : 'text-rose-600'}">${avg}</div>
                                                            <span class="px-2 py-0.5 rounded-full text-[10px] font-bold ${avg >= 8.5 ? 'bg-emerald-100 text-emerald-800' : avg >= 7.0 ? 'bg-blue-100 text-blue-800' : avg >= 5.0 ? 'bg-amber-100 text-amber-800' : 'bg-rose-100 text-rose-800'}">
                                                                ${avg >= 8.5 ? 'Giỏi / Xuất sắc' : avg >= 7.0 ? 'Khá' : avg >= 5.0 ? 'Đạt' : 'Không đạt'}
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="px-2 py-1 bg-slate-100 text-slate-500 rounded text-[10px]">Chưa đủ điểm</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="px-4 py-4">
                                                    <span class="px-2.5 py-1 rounded-lg text-xs font-bold ${assign.status == 'EVALUATED' ? 'bg-emerald-100 text-emerald-800 border border-emerald-200' : 'bg-amber-100 text-amber-800 border border-amber-200'}">
                                                        ${assign.status}
                                                    </span>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </c:forEach>
        </div>
    </main>

<jsp:include page="../common/footer.jsp" />

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const flash = document.getElementById('scoreFlashMessage');
        if (!flash || typeof Swal === 'undefined') return;
        const isSuccess = flash.dataset.messageType === 'success';
        Swal.fire({
            icon: isSuccess ? 'success' : 'error',
            title: isSuccess ? 'Công bố điểm thành công' : 'Không thể công bố điểm',
            text: flash.textContent.trim(),
            confirmButtonText: 'Đóng',
            confirmButtonColor: isSuccess ? '#059669' : '#e11d48'
        });
    });

    function confirmFinalize(event, councilName) {
        event.preventDefault();
        const form = event.target;
        Swal.fire({
            title: 'Chốt & Công bố điểm?',
            text: 'Bạn có chắc chắn muốn chốt điểm và công bố kết quả cho ' + councilName + '?',
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: '#059669',
            cancelButtonColor: '#64748b',
            confirmButtonText: 'Đồng ý công bố',
            cancelButtonText: 'Hủy',
            customClass: {
                popup: 'rounded-2xl'
            }
        }).then((result) => {
            if (result.isConfirmed) {
                form.submit();
            }
        });
        return false;
    }
</script>

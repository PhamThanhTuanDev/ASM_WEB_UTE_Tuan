<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle" value="Điểm số &amp; kết quả phản biện" />
<c:set var="pageHeading" value="Tổng hợp điểm số &amp; công bố kết quả" />
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

        <div class="space-y-6" data-pagination-list>
            <c:forEach var="c" items="${councils}">
                <div data-pagination-item class="table-shell">
                    <!-- Council Header -->
                    <div class="bg-white px-6 py-4 border-b border-slate-100 flex flex-col sm:flex-row sm:items-center justify-between gap-3">
                        <div class="flex items-center gap-3 flex-wrap">
                            <span class="code-tag font-bold text-xs bg-slate-900 text-white border-slate-900">${c.code}</span>
                            <h3 class="text-sm font-extrabold text-slate-900">${c.name}</h3>
                            <span class="status-badge ${c.status == 'COMPLETED' ? 'status-approved' : 'status-pending'}">
                                ${c.status}
                            </span>
                        </div>
                        <form method="post" action="${pageContext.request.contextPath}/admin/results/${c.id}/finalize" onsubmit="return confirmFinalize(event, '${c.name}');">
                            <button type="submit" class="btn-ui btn-ui-primary text-xs py-2 px-3.5 shadow-sm">
                                <i data-lucide="lock" class="w-3.5 h-3.5"></i> Chốt &amp; Công Bố Điểm
                            </button>
                        </form>
                    </div>

                    <div>
                        <c:set var="assignments" value="${councilService.getAssignments(c.id)}" />
                        <c:choose>
                            <c:when test="${empty assignments}">
                                <div class="empty-state py-8">
                                    <div class="empty-state-icon-wrap w-10 h-10 mb-2">
                                        <i data-lucide="folder-open" class="w-5 h-5 opacity-40"></i>
                                    </div>
                                    <div class="empty-state-desc text-xs mb-0">Chưa có đề tài nào được phân công cho Hội đồng này</div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="overflow-x-auto">
                                    <table class="w-full text-left border-collapse">
                                        <thead>
                                            <tr>
                                                <th class="w-[24%]">Đề tài Báo cáo</th>
                                                <th class="w-[20%]">Nhóm Thực hiện</th>
                                                <th class="w-[28%]">Điểm Thành viên Hội đồng</th>
                                                <th class="w-[14%] text-center whitespace-nowrap">Điểm Tổng Kết (50/50)</th>
                                                <th class="w-[14%] text-center whitespace-nowrap">Trạng thái</th>
                                            </tr>
                                        </thead>
                                        <tbody class="divide-y divide-slate-100 text-xs">
                                            <c:forEach var="assign" items="${assignments}">
                                                <c:set var="scores" value="${scoringService.getScoresForAssignment(assign.id)}" />
                                                <c:set var="avg" value="${scoringService.calculateFinalScore(assign.id)}" />
                                                <tr class="hover:bg-slate-50/60 transition-colors">
                                                    <td class="align-top">
                                                        <span class="code-tag">${assign.topicRegistration.topic.code}</span>
                                                        <div class="font-bold text-slate-800 line-clamp-2 mt-1 leading-snug">${assign.topicRegistration.topic.title}</div>
                                                        <div class="text-[11px] text-slate-500 mt-0.5">GVHD: ${assign.topicRegistration.topic.lecturer.user.fullName}</div>
                                                    </td>
                                                    <td class="align-top">
                                                        <div class="font-bold text-slate-900">${assign.topicRegistration.group.name}</div>
                                                        <div class="text-[11px] text-slate-500 mt-0.5">Trưởng nhóm: ${assign.topicRegistration.group.leader.user.fullName}</div>
                                                    </td>
                                                    <td class="align-top">
                                                        <div class="space-y-1.5">
                                                            <c:forEach var="sc" items="${scores}">
                                                                <div class="p-2 rounded-xl bg-slate-50 border border-slate-200/80 text-[11px]">
                                                                    <div class="flex items-center justify-between">
                                                                        <span class="font-bold text-slate-800">${sc.councilMember.lecturer.user.fullName}:</span>
                                                                        <span class="font-black text-sky-700 bg-sky-50 px-2 py-0.5 rounded-md border border-sky-100">${sc.score} / 10</span>
                                                                    </div>
                                                                    <p class="text-slate-500 italic mt-0.5 line-clamp-1">"${sc.comment}"</p>
                                                                </div>
                                                            </c:forEach>
                                                        </div>
                                                    </td>
                                                    <td class="align-middle text-center whitespace-nowrap">
                                                        <c:choose>
                                                            <c:when test="${avg != null}">
                                                                <div class="text-2xl font-black ${avg >= 5.0 ? 'text-emerald-600' : 'text-rose-600'}">${avg}</div>
                                                                <span class="status-badge ${avg >= 8.5 ? 'status-approved' : avg >= 7.0 ? 'status-info' : avg >= 5.0 ? 'status-pending' : 'status-danger'} mt-1">
                                                                    ${avg >= 8.5 ? 'Giỏi / Xuất sắc' : avg >= 7.0 ? 'Khá' : avg >= 5.0 ? 'Đạt' : 'Không đạt'}
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="status-badge status-neutral">Chưa đủ điểm</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="align-middle text-center whitespace-nowrap">
                                                        <span class="status-badge ${assign.status == 'EVALUATED' ? 'status-approved' : 'status-pending'}">
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
            confirmButtonColor: isSuccess ? '#059669' : '#dc2626'
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
            customClass: { popup: 'rounded-3xl shadow-2xl' }
        }).then((result) => {
            if (result.isConfirmed) {
                form.submit();
            }
        });
        return false;
    }
</script>

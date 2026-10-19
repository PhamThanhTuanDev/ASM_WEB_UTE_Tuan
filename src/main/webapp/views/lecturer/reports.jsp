<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set scope="request" var="pageTitle" value="Báo cáo sinh viên" />
<c:set scope="request" var="pageHeading" value="Xem báo cáo sinh viên hướng dẫn" />
<c:set scope="request" var="pageSubheading" value="Danh sách các file báo cáo tiến độ và báo cáo hoàn chỉnh do Nhóm trưởng nộp" />
<c:set scope="request" var="activeMenu" value="reports" />

<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/sidebar.jsp" />

<div class="app-main">
    <jsp:include page="../common/navbar.jsp" />

    <main class="app-content workspace-page space-y-6">
        <div class="table-shell">
            <div class="p-5 border-b border-slate-100 flex flex-col sm:flex-row sm:items-center justify-between gap-4 bg-white">
                <div class="flex items-center gap-2.5">
                    <div class="w-8 h-8 rounded-xl bg-sky-50 text-sky-700 flex items-center justify-center border border-sky-100">
                        <i data-lucide="folder-check" class="w-4 h-4"></i>
                    </div>
                    <div>
                        <h3 class="text-sm font-bold text-slate-900 leading-tight">
                            Báo cáo sinh viên hướng dẫn (${fn:length(reports)})
                        </h3>
                        <p class="text-[11px] text-slate-500">Xem file, chấm điểm quá trình và phê duyệt báo cáo</p>
                    </div>
                </div>
                <div class="relative w-full sm:w-80">
                    <i data-lucide="search" class="w-4 h-4 text-slate-400 absolute left-3.5 top-1/2 -translate-y-1/2"></i>
                    <input type="text" id="reportSearchInput" onkeyup="filterReportsTable()" placeholder="Tìm file, đề tài, nhóm, người nộp..."
                           class="w-full pl-10 pr-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs font-medium focus:bg-white focus:ring-2 focus:ring-sky-500 focus:outline-none transition-all">
                </div>
            </div>

            <c:choose>
                <c:when test="${empty reports}">
                    <div class="empty-state py-12">
                        <div class="empty-state-icon-wrap w-12 h-12 mb-2">
                            <i data-lucide="file-x" class="w-6 h-6 opacity-40"></i>
                        </div>
                        <div class="empty-state-desc text-xs mb-0">Chưa có sinh viên nào nộp báo cáo</div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="overflow-x-auto">
                        <table class="w-full min-w-[1080px] table-fixed text-left border-collapse" id="reportsTable">
                            <colgroup>
                                <col style="width:20%">
                                <col style="width:22%">
                                <col style="width:22%">
                                <col style="width:12%">
                                <col style="width:12%">
                                <col style="width:12%">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>Mã và Đề tài</th>
                                    <th>Nhóm và Người nộp</th>
                                    <th>Tên file báo cáo</th>
                                    <th class="whitespace-nowrap">Thời gian nộp</th>
                                    <th>Ghi chú</th>
                                    <th class="text-center whitespace-nowrap">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-slate-100 text-xs">
                                <c:forEach var="r" items="${reports}">
                                    <tr class="hover:bg-slate-50/80 transition-colors report-row">
                                        <td class="align-top">
                                            <span class="code-tag">${r.topicRegistration.topic.code}</span>
                                            <div class="font-bold text-slate-900 mt-1 leading-snug line-clamp-2" title="${r.topicRegistration.topic.title}">
                                                <c:out value="${r.topicRegistration.topic.title}" />
                                            </div>
                                        </td>
                                        <td class="align-top">
                                            <div class="font-bold text-slate-800 text-xs leading-snug mb-1">
                                                <c:out value="${r.topicRegistration.group.name}" />
                                            </div>
                                            
                                            <c:set var="isSubmitterLeader" value="${r.topicRegistration.group.leader != null && r.topicRegistration.group.leader.id == r.submittedBy.id}" />
                                            
                                            <div class="font-bold text-slate-800 leading-snug flex items-center gap-1.5">
                                                <i data-lucide="user" class="w-3.5 h-3.5 text-sky-600"></i>
                                                <span><c:out value="${r.submittedBy.user.fullName}" /><c:if test="${isSubmitterLeader}"> (Nhóm trưởng)</c:if></span>
                                            </div>
                                            
                                            <div class="text-[11px] text-slate-500 mt-0.5">
                                                MSSV: <strong class="text-slate-700">${r.submittedBy.studentCode}</strong>
                                                <c:if test="${not empty r.submittedBy.className}"> &bull; ${r.submittedBy.className}</c:if>
                                            </div>
                                        </td>
                                        <td class="align-top">
                                            <div class="flex items-start gap-2 font-bold text-slate-800">
                                                <i data-lucide="file-text" class="w-4 h-4 text-rose-500 shrink-0 mt-0.5"></i>
                                                <span class="break-all leading-snug" title="${r.fileName}">${r.fileName}</span>
                                            </div>
                                        </td>
                                        <td class="align-top text-slate-500 font-medium whitespace-nowrap">
                                            ${dateDisplay.format(r.submittedAt)}
                                        </td>
                                        <td class="align-top">
                                            <c:choose>
                                                <c:when test="${not empty r.note}">
                                                    <p class="text-slate-600 italic leading-relaxed break-words whitespace-normal">
                                                        <c:out value="${r.note}" />
                                                    </p>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-slate-400">Không có</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="align-top text-center">
                                            <a href="${pageContext.request.contextPath}/lecturer/reports/${r.id}"
                                               class="btn-ui btn-ui-primary text-xs py-1.5 px-3 w-full max-w-[140px] mx-auto shadow-xs">
                                                <i data-lucide="eye" class="w-3.5 h-3.5"></i> Xem báo cáo
                                            </a>
                                            <div class="mt-2 flex justify-center">
                                                <c:choose>
                                                    <c:when test="${r.reviewStatus == 'APPROVED'}">
                                                        <span class="status-badge status-approved">ĐÃ DUYỆT</span>
                                                    </c:when>
                                                    <c:when test="${r.reviewStatus == 'REJECTED'}">
                                                        <span class="status-badge status-danger">TỪ CHỐI</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge status-pending">CHỜ DUYỆT</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>

<jsp:include page="../common/footer.jsp" />

<script>
    function filterReportsTable() {
        const input = document.getElementById('reportSearchInput');
        if (!input) return;
        const q = input.value.toLowerCase();
        document.querySelectorAll('.report-row').forEach(row => {
            row.style.display = row.innerText.toLowerCase().includes(q) ? '' : 'none';
        });
    }
</script>

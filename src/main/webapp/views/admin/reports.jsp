<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle" value="Báo cáo đề tài" />
<c:set var="pageHeading" value="Báo cáo đề tài sinh viên" />
<c:set var="pageSubheading" value="Danh sách file báo cáo tiến độ / hoàn chỉnh do nhóm trưởng nộp" />
<c:set var="activeMenu" value="reports" />

<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/sidebar.jsp" />

<div class="app-main">
    <jsp:include page="../common/navbar.jsp" />

    <main class="app-content space-y-6">
        <!-- Toolbar & Search -->
        <div class="table-shell">
            <div class="p-5 border-b border-slate-100 flex flex-col sm:flex-row sm:items-center justify-between gap-4 bg-white">
                <div class="flex items-center gap-3">
                    <div class="w-10 h-10 rounded-2xl bg-sky-50 text-sky-700 flex items-center justify-center border border-sky-100 shadow-xs">
                        <i data-lucide="folder-check" class="w-5 h-5"></i>
                    </div>
                    <div>
                        <h3 class="text-base font-bold text-slate-900 leading-tight">
                            Hồ sơ báo cáo tiến độ &bull; ${fn:length(reports)} tệp tin
                        </h3>
                        <p class="text-xs text-slate-500 mt-0.5">Tải về hoặc đối soát file nộp của các nhóm sinh viên</p>
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
                        <div class="empty-state-desc text-xs mb-0">Chưa có báo cáo nào được nộp vào hệ thống</div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="overflow-x-auto">
                        <table class="w-full min-w-[1080px] text-left border-collapse" id="reportsTable">
                            <thead>
                                <tr>
                                    <th class="w-[20%]">Mã &amp; Đề tài</th>
                                    <th class="w-[22%]">Nhóm &amp; Người nộp</th>
                                    <th class="w-[22%]">Tên file báo cáo</th>
                                    <th class="w-[12%] whitespace-nowrap">Thời gian nộp</th>
                                    <th class="w-[16%]">Ghi chú</th>
                                    <th class="w-[8%] text-center whitespace-nowrap">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-slate-100 text-xs">
                                <c:forEach var="r" items="${reports}">
                                    <tr class="hover:bg-slate-50/80 transition-colors report-row">
                                        <td class="align-top">
                                            <span class="code-tag">${r.topicRegistration.topic.code}</span>
                                            <div class="font-bold text-slate-900 mt-1 leading-snug line-clamp-2" title="${r.topicRegistration.topic.title}">
                                                ${r.topicRegistration.topic.title}
                                            </div>
                                        </td>
                                        <td class="align-top">
                                            <div class="font-bold text-slate-800 text-xs leading-snug">
                                                ${r.topicRegistration.group.name}
                                            </div>
                                            <c:set var="isSubmitterLeader" value="${r.topicRegistration.group.leader != null && r.topicRegistration.group.leader.id == r.submittedBy.id}" />
                                            <div class="font-semibold text-slate-700 mt-1 flex items-center gap-1.5">
                                                <i data-lucide="user" class="w-3.5 h-3.5 text-sky-600"></i>
                                                <span>${r.submittedBy.user.fullName}<c:if test="${isSubmitterLeader}"> (Nhóm trưởng)</c:if></span>
                                            </div>
                                            <div class="text-[11px] text-slate-500 mt-0.5">
                                                MSSV: <strong>${r.submittedBy.studentCode}</strong>
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
                                            ${r.submittedAt}
                                        </td>
                                        <td class="align-top">
                                            <c:choose>
                                                <c:when test="${not empty r.note}">
                                                    <p class="text-slate-600 italic leading-relaxed break-words whitespace-normal">
                                                        ${r.note}
                                                    </p>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-slate-400">Không có</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="align-top text-center whitespace-nowrap">
                                            <a href="${pageContext.request.contextPath}/reports/download/${r.id}" target="_blank"
                                               class="btn-ui btn-ui-outline text-xs py-1.5 px-3">
                                                <i data-lucide="download" class="w-3.5 h-3.5 text-sky-600"></i> Tải file
                                            </a>
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

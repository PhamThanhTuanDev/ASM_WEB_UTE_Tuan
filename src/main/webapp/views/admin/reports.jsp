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
        <div class="bg-white rounded-2xl border border-slate-200 shadow-xs overflow-hidden">
            <div class="p-5 border-b border-slate-100 flex flex-col sm:flex-row sm:items-center justify-between gap-3">
                <h3 class="text-sm font-bold text-slate-900 flex items-center gap-2">
                    <i data-lucide="folder-check" class="w-4 h-4 text-blue-600"></i>
                    Danh sách báo cáo (${fn:length(reports)})
                </h3>
                <div class="relative w-full sm:w-72">
                    <i data-lucide="search" class="w-4 h-4 text-slate-400 absolute left-3 top-1/2 -translate-y-1/2"></i>
                    <input type="text" id="reportSearchInput" onkeyup="filterReportsTable()" placeholder="Tìm file, đề tài, nhóm, người nộp..."
                           class="w-full pl-9 pr-3 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs focus:bg-white focus:ring-2 focus:ring-blue-500 focus:outline-none">
                </div>
            </div>

            <c:choose>
                <c:when test="${empty reports}">
                    <div class="text-center py-12 text-slate-400 text-xs">
                        <i data-lucide="file-x" class="w-8 h-8 mx-auto mb-2 opacity-40"></i>
                        Chưa có báo cáo nào được nộp.
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="overflow-x-auto">
                        <table class="w-full min-w-[1080px] table-fixed text-left border-collapse" id="reportsTable">
                            <colgroup>
                                <col style="width:16%">
                                <col style="width:18%">
                                <col style="width:22%">
                                <col style="width:12%">
                                <col style="width:22%">
                                <col style="width:10%">
                            </colgroup>
                            <thead>
                                <tr class="bg-slate-50 text-[11px] font-bold uppercase tracking-wider text-slate-500 border-b border-slate-200">
                                    <th class="px-4 py-3.5">Mã &amp; Đề tài</th>
                                    <th class="px-4 py-3.5">Nhóm &amp; Người nộp</th>
                                    <th class="px-4 py-3.5">Tên file báo cáo</th>
                                    <th class="px-4 py-3.5 whitespace-nowrap">Thời gian nộp</th>
                                    <th class="px-4 py-3.5">Ghi chú</th>
                                    <th class="px-4 py-3.5 text-center whitespace-nowrap">Tải về</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-slate-100 text-xs">
                                <c:forEach var="r" items="${reports}">
                                    <tr class="hover:bg-slate-50/80 transition-colors report-row">
                                        <td class="px-4 py-4 align-top">
                                            <span class="inline-block px-2 py-0.5 rounded font-mono font-bold text-[10px] bg-blue-50 text-blue-700 border border-blue-200">${r.topicRegistration.topic.code}</span>
                                            <div class="font-bold text-slate-900 mt-1.5 leading-snug line-clamp-2" title="${r.topicRegistration.topic.title}">
                                                ${r.topicRegistration.topic.title}
                                            </div>
                                        </td>
                                        <!-- 1. Thêm min-w-[220px] hoặc w-64 để mở rộng cột -->
                                        <td class="px-4 py-4 align-top overflow-hidden min-w-[220px]">
    
                                            <!-- Tên nhóm -->
                                            <div class="font-bold text-slate-800 leading-snug mb-1.5 break-words">
                                                ${r.topicRegistration.group.name}
                                            </div>
                                        
                                            <c:set var="isSubmitterLeader" value="${r.topicRegistration.group.leader != null && r.topicRegistration.group.leader.id == r.submittedBy.id}" />
                                        
                                            <!-- Tên + (Nhóm trưởng) giữ trên 1 hàng -->
                                            <div class="font-bold text-slate-800 leading-snug whitespace-nowrap">
                                                ${r.submittedBy.user.fullName}<c:if test="${isSubmitterLeader}"> (Nhóm trưởng)</c:if>
                                            </div>
                                        
                                            <!-- Hàng 1: MSSV -->
                                            <div class="text-[11px] text-slate-500 mt-1">
                                                MSSV: <strong class="text-slate-800">${r.submittedBy.studentCode}</strong>
                                            </div>
                                        
                                            <!-- Hàng 2: Lớp (nằm riêng 1 hàng dưới MSSV) -->
                                            <c:if test="${not empty r.submittedBy.className}">
                                                <div class="text-[11px] text-slate-500">
                                                    Lớp: <strong class="text-slate-800">${r.submittedBy.className}</strong>
                                                </div>
                                            </c:if>
                                        
                                        </td>
                                        <td class="px-4 py-4 align-top">
                                            <div class="flex items-start gap-2 font-semibold text-slate-800">
                                                <i data-lucide="file-text" class="w-4 h-4 text-rose-500 shrink-0 mt-0.5"></i>
                                                <span class="break-all leading-snug" title="${r.fileName}">${r.fileName}</span>
                                            </div>
                                        </td>
                                        <td class="px-4 py-4 align-top text-slate-500 font-medium whitespace-nowrap">
                                            ${r.submittedAt}
                                        </td>
                                        <td class="px-4 py-4 align-top">
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
                                        <td class="px-4 py-4 align-top text-center">
                                            <a href="${pageContext.request.contextPath}/reports/download/${r.id}" target="_blank"
                                               class="inline-flex items-center justify-center gap-1.5 px-3 py-2 rounded-xl border border-slate-200 bg-white hover:bg-blue-50 hover:border-blue-200 text-blue-700 text-[11px] font-bold transition-colors whitespace-nowrap">
                                                <i data-lucide="download" class="w-3.5 h-3.5"></i> Tải file
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

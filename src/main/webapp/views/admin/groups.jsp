<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle" value="Quản lý nhóm sinh viên" />
<c:set var="pageHeading" value="Quản lý nhóm sinh viên &amp; đề tài phân công" />
<c:set var="pageSubheading" value="Theo dõi cơ cấu thành viên (tối đa 3 SV), nhóm trưởng và đề tài đang thực hiện" />
<c:set var="activeMenu" value="groups" />

<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/sidebar.jsp" />

<div class="app-main">
    <jsp:include page="../common/navbar.jsp" />

    <main class="app-content space-y-6">
        <!-- Toolbar -->
        <div class="bg-white p-5 rounded-3xl border border-slate-200 shadow-sm flex flex-col sm:flex-row sm:items-center justify-between gap-4">
            <div class="flex items-center gap-3">
                <div class="w-10 h-10 rounded-2xl bg-sky-50 text-sky-700 flex items-center justify-center border border-sky-100 shadow-xs">
                    <i data-lucide="users" class="w-5 h-5"></i>
                </div>
                <div>
                    <h2 class="text-base font-bold text-slate-900 leading-tight">Danh sách nhóm sinh viên</h2>
                    <p class="text-xs text-slate-500 mt-0.5">Tổng số <strong class="text-sky-700">${fn:length(groups)}</strong> nhóm đã thành lập</p>
                </div>
            </div>
            <div class="relative w-full sm:w-80">
                <i data-lucide="search" class="w-4 h-4 text-slate-400 absolute left-3.5 top-1/2 -translate-y-1/2"></i>
                <input type="text" id="groupSearchInput" onkeyup="filterGroupsTable()" placeholder="Tìm theo tên nhóm, nhóm trưởng, MSSV..." 
                       class="w-full pl-10 pr-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs font-medium focus:bg-white focus:ring-2 focus:ring-sky-500 focus:outline-none transition-all">
            </div>
        </div>

        <!-- Groups Table Shell -->
        <div class="table-shell">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse min-w-[960px]" id="groupsTable">
                    <thead>
                        <tr>
                            <th class="whitespace-nowrap">Tên Nhóm &amp; Đợt</th>
                            <th class="whitespace-nowrap">Nhóm Trưởng</th>
                            <th class="min-w-[200px]">Thành viên khác</th>
                            <th class="min-w-[260px]">Đề tài Đăng ký</th>
                            <th class="whitespace-nowrap">GVHD</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-100 text-xs">
                        <c:forEach var="g" items="${groups}">
                            <tr class="hover:bg-slate-50/80 transition-colors group-row">
                                <td class="align-middle">
                                    <div class="font-extrabold text-slate-900 text-xs">${g.name}</div>
                                    <div class="text-[11px] text-slate-500 mt-1 flex items-center gap-1 font-medium">
                                        <i data-lucide="calendar" class="w-3.5 h-3.5 text-slate-400"></i>
                                        <span>${g.registrationPeriod != null ? g.registrationPeriod.name : 'Chung'}</span>
                                    </div>
                                </td>
                                <td class="align-middle whitespace-nowrap">
                                    <div class="space-y-0.5">
                                        <div class="font-bold text-slate-800 flex items-center gap-1.5">
                                            <i data-lucide="crown" class="w-3.5 h-3.5 text-amber-500"></i>
                                            <span>${g.leader.user.fullName}</span>
                                        </div>
                                        <div class="text-[11px] text-slate-500">
                                            MSSV: <strong class="text-slate-700">${g.leader.studentCode}</strong>
                                        </div>
                                        <c:if test="${not empty g.leader.className}">
                                            <div class="text-[10px] text-slate-400">
                                                Lớp: ${g.leader.className}
                                            </div>
                                        </c:if>
                                    </div>
                                </td>
                                <td class="align-middle">
                                    <div class="space-y-1">
                                        <c:set var="hasOtherMembers" value="false" />
                                        <c:forEach var="m" items="${g.members}">
                                            <c:if test="${!m.leader}">
                                                <c:set var="hasOtherMembers" value="true" />
                                                <div class="flex items-center gap-1.5 text-[11px] whitespace-nowrap">
                                                    <span class="w-1.5 h-1.5 rounded-full bg-sky-500 shrink-0"></span>
                                                    <span class="font-semibold text-slate-800">${m.student.user.fullName}</span>
                                                    <span class="text-slate-400 font-mono">(${m.student.studentCode})</span>
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                        <c:if test="${!hasOtherMembers}">
                                            <span class="text-[11px] text-slate-400 italic">Chưa có thành viên khác</span>
                                        </c:if>
                                    </div>
                                </td>
                                <td class="align-middle">
                                    <c:choose>
                                        <c:when test="${not empty g.topic}">
                                            <span class="code-tag">${g.topic.code}</span>
                                            <div class="font-bold text-slate-800 line-clamp-2 mt-1">${g.topic.title}</div>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge status-neutral">Chưa chọn đề tài</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="align-middle whitespace-nowrap">
                                    <c:choose>
                                        <c:when test="${not empty g.topic and g.topic.lecturer != null}">
                                            <div class="font-semibold text-slate-800">${g.topic.lecturer.user.fullName}</div>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-[11px] text-slate-400 italic">Chưa có GVHD</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty groups}">
                            <tr class="table-empty-row">
                                <td colspan="5">
                                    <div class="empty-state py-8">
                                        <div class="empty-state-icon-wrap w-12 h-12 mb-2">
                                            <i data-lucide="users-round" class="w-6 h-6 opacity-40"></i>
                                        </div>
                                        <div class="empty-state-desc text-xs mb-0">Chưa có nhóm sinh viên nào được thành lập</div>
                                    </div>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

<jsp:include page="../common/footer.jsp" />

<script>
    function filterGroupsTable() {
        const input = document.getElementById('groupSearchInput').value.toLowerCase();
        const rows = document.querySelectorAll('.group-row');
        rows.forEach(row => {
            const text = row.innerText.toLowerCase();
            row.style.display = text.includes(input) ? '' : 'none';
        });
    }
</script>

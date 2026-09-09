<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle" value="Quản lý nhóm sinh viên" />
<c:set var="pageHeading" value="Quản lý nhóm sinh viên & đề tài phân công" />
<c:set var="pageSubheading" value="Theo dõi cơ cấu thành viên (tối đa 3 SV), nhóm trưởng và đề tài đang thực hiện" />
<c:set var="activeMenu" value="groups" />

<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/sidebar.jsp" />

<div class="app-main">
    <jsp:include page="../common/navbar.jsp" />

    <main class="app-content space-y-6">
        <!-- Toolbar -->
        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-xs flex flex-col sm:flex-row sm:items-center justify-between gap-4">
            <div>
                <h2 class="text-lg font-bold text-slate-900 flex items-center gap-2">
                    <i data-lucide="users" class="w-5 h-5 text-blue-600"></i> Danh sách nhóm sinh viên
                </h2>
                <p class="text-xs text-slate-500 mt-0.5">Tổng số <strong class="text-blue-600">${fn:length(groups)}</strong> nhóm đã thành lập</p>
            </div>
            <div class="relative w-full sm:w-72">
                <i data-lucide="search" class="w-4 h-4 text-slate-400 absolute left-3.5 top-1/2 -translate-y-1/2"></i>
                <input type="text" id="groupSearchInput" onkeyup="filterGroupsTable()" placeholder="Tìm theo tên nhóm, nhóm trưởng, MSSV..." 
                       class="w-full pl-10 pr-3.5 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs focus:bg-white focus:ring-2 focus:ring-blue-500 focus:outline-none">
            </div>
        </div>

        <!-- Groups Table -->
        <div class="bg-white rounded-2xl border border-slate-200 shadow-xs overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse min-w-[960px]" id="groupsTable">
                    <thead>
                        <tr class="bg-slate-50/80 border-b border-slate-200 text-[11px] font-bold uppercase tracking-wider text-slate-500">
                            <th class="px-5 py-3">Tên Nhóm &amp; Đợt</th>
                            <th class="px-4 py-3 whitespace-nowrap">Nhóm Trưởng</th>
                            <th class="px-4 py-3">Thành viên khác</th>
                            <th class="px-4 py-3">Đề tài Đăng ký</th>
                            <th class="px-4 py-3 whitespace-nowrap">GVHD</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-100 text-xs">
                        <c:forEach var="g" items="${groups}">
                            <tr class="hover:bg-slate-50/80 transition-colors group-row">
                                <td class="px-5 py-4">
                                    <div class="font-bold text-slate-900 text-sm">${g.name}</div>
                                    <div class="text-[11px] text-slate-500 mt-0.5 flex items-center gap-1">
                                        ${g.registrationPeriod != null ? g.registrationPeriod.name : 'Chung'}
                                    </div>
                                </td>
                                <td class="px-4 py-3 align-middle whitespace-nowrap">
                                    <div class="inline-flex items-center gap-2.5">
                             
                                        
                                        
                                        <div>
                                            <!-- Dòng 1: Tên + Vương miện -->
                                            <div class="font-bold text-slate-800 inline-flex items-center gap-1 whitespace-nowrap">
                                                ${g.leader.user.fullName} (Nhóm trưởng)
                                        
                                            </div>
                                            
                                            <!-- Dòng 2: MSSV -->
                                            <div class="text-[10px] text-slate-500 whitespace-nowrap leading-tight">
                                                MSSV: <strong class="text-slate-700">${g.leader.studentCode}</strong>
                                            </div>
                                
                                            <!-- Dòng 3: Lớp (Rớt xuống 1 dòng riêng) -->
                                            <c:if test="${not empty g.leader.className}">
                                                <div class="text-[10px] text-slate-500 whitespace-nowrap leading-tight">
                                                    Lớp: <strong class="text-slate-700">${g.leader.className}</strong>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                </td>
                                <td class="px-4 py-3 align-middle">
                                    <div class="space-y-1">
                                        <c:set var="hasOtherMembers" value="false" />
                                        <c:forEach var="m" items="${g.members}">
                                            <c:if test="${!m.leader}">
                                                <c:set var="hasOtherMembers" value="true" />
                                                <div class="flex items-center gap-1.5 text-[11px] whitespace-nowrap">
                                                    <span class="w-1.5 h-1.5 rounded-full bg-blue-500 shrink-0"></span>
                                                    <span class="font-semibold text-slate-800">${m.student.user.fullName}</span>
                                                    <span class="text-slate-400 font-mono">(MSSV: ${m.student.studentCode})</span>
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                        <c:if test="${!hasOtherMembers}">
                                            <span class="text-[11px] text-slate-400 italic">Chưa có thành viên khác</span>
                                        </c:if>
                                    </div>
                                </td>
                                <td class="px-4 py-3 align-middle">
                                    <c:choose>
                                        <c:when test="${not empty g.topic}">
                                            
                                            <div class="font-bold text-slate-800 line-clamp-2 mt-1">${g.topic.title}</div>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="inline-block px-2 py-1 rounded-md text-[10px] bg-slate-100 text-slate-500 border border-slate-200 whitespace-nowrap">Chưa chọn đề tài</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="px-4 py-3 align-middle whitespace-nowrap">
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

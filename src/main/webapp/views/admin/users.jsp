<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle" value="Quản lý tài khoản & người dùng" />
<c:set var="pageHeading" value="Quản lý tài khoản & phân quyền hệ thống" />
<c:set var="pageSubheading" value="Danh sách tài khoản Giảng viên, Sinh viên và Quản trị viên trong hệ thống" />
<c:set var="activeMenu" value="users" />

<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/sidebar.jsp" />

<div class="app-main">
    <jsp:include page="../common/navbar.jsp" />

    <main class="app-content space-y-6">
        <!-- Tabs Navigation -->
        <div class="flex items-center gap-2 p-1.5 bg-slate-200/70 rounded-2xl w-fit">
            <button type="button" onclick="switchUserTab('lecturers')" id="btn-tab-lecturers"
                class="tab-btn px-4 py-2 rounded-xl text-xs font-bold transition-all bg-white text-sky-700 shadow-xs flex items-center gap-2">
                <i data-lucide="user-check" class="w-4 h-4"></i> Giảng viên (${fn:length(lecturers)})
            </button>
            <button type="button" onclick="switchUserTab('students')" id="btn-tab-students"
                class="tab-btn px-4 py-2 rounded-xl text-xs font-bold transition-all text-slate-600 hover:text-slate-900 flex items-center gap-2">
                <i data-lucide="graduation-cap" class="w-4 h-4"></i> Sinh viên (${fn:length(students)})
            </button>
            <button type="button" onclick="switchUserTab('allusers')" id="btn-tab-allusers"
                class="tab-btn px-4 py-2 rounded-xl text-xs font-bold transition-all text-slate-600 hover:text-slate-900 flex items-center gap-2">
                <i data-lucide="users" class="w-4 h-4"></i> Tất cả tài khoản (${fn:length(users)})
            </button>
        </div>

        <div id="userTabsContent">
            <!-- 1. Lecturers Pane -->
            <div id="pane-lecturers" class="tab-pane block">
                <div class="table-shell">
                    <table class="w-full text-left border-collapse datatable-pagination" id="lecturersTable" data-page-size="10">
                        <thead>
                            <tr>
                                <th class="w-[12%]">Mã GV</th>
                                <th class="w-[24%]">Họ và Tên Giảng viên</th>
                                <th class="w-[16%]">Học hàm / Học vị</th>
                                <th class="w-[18%]">Khoa</th>
                                <th class="w-[16%]">Lĩnh vực Nghiên cứu</th>
                                <th class="w-[14%]">Email liên hệ</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-100 text-xs">
                            <c:forEach var="l" items="${lecturers}">
                                <tr class="hover:bg-slate-50/80 transition-colors">
                                    <td class="align-middle">
                                        <span class="code-tag">${l.lecturerCode}</span>
                                    </td>
                                    <td class="align-middle">
                                        <div class="font-bold text-slate-900 leading-snug">${l.user.fullName}</div>
                                        <div class="text-[11px] text-slate-400 mt-0.5 font-mono">@${l.user.username}</div>
                                    </td>
                                    <td class="align-middle">
                                        <span class="status-badge status-info">
                                            ${l.academicDegree != null ? l.academicDegree : l.degree}
                                        </span>
                                    </td>
                                    <td class="align-middle">
                                        <span class="status-badge status-neutral">
                                            ${l.department != null ? l.department.name : 'Chung'}
                                        </span>
                                    </td>
                                    <td class="align-middle text-slate-600 font-medium">
                                        ${l.researchField != null ? l.researchField : 'Công nghệ thông tin'}
                                    </td>
                                    <td class="align-middle text-slate-500 font-mono text-[11px] whitespace-nowrap">
                                        ${l.user.email}
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- 2. Students Pane -->
            <div id="pane-students" class="tab-pane hidden">
                <div class="table-shell">
                    <div class="overflow-x-auto">
                        <table class="w-full text-left border-collapse datatable-pagination" id="studentsTable" data-page-size="10">
                            <thead>
                                <tr>
                                    <th class="w-[14%]">Mã số SV (MSSV)</th>
                                    <th class="w-[22%]">Họ và Tên Sinh viên</th>
                                    <th class="w-[16%]">Lớp &amp; Khóa</th>
                                    <th class="w-[18%]">Ngành học</th>
                                    <th class="w-[15%]">Khoa</th>
                                    <th class="w-[15%]">Email Sinh viên</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-slate-100 text-xs">
                                <c:forEach var="s" items="${students}">
                                    <tr class="hover:bg-slate-50/80 transition-colors">
                                        <td class="align-middle whitespace-nowrap">
                                            <span class="code-tag font-bold text-emerald-700 bg-emerald-50 border-emerald-200">${s.studentCode}</span>
                                        </td>
                                        <td class="align-middle">
                                            <div class="font-bold text-slate-900">${s.user.fullName}</div>
                                            <div class="text-[11px] text-slate-400 font-mono">@${s.user.username}</div>
                                        </td>
                                        <td class="align-middle whitespace-nowrap font-medium text-slate-700">
                                            ${s.className} &bull; ${s.courseYear}
                                        </td>
                                        <td class="align-middle font-semibold text-slate-700">
                                            ${s.major}
                                        </td>
                                        <td class="align-middle whitespace-nowrap">
                                            <span class="status-badge status-info">
                                                ${s.department != null ? s.department.code : 'CNTT'}
                                            </span>
                                        </td>
                                        <td class="align-middle text-slate-500 font-mono text-[11px] whitespace-nowrap">
                                            ${s.user.email}
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- 3. All Users Pane -->
            <div id="pane-allusers" class="tab-pane hidden">
                <div class="table-shell">
                    <div class="overflow-x-auto">
                        <table class="w-full text-left border-collapse datatable-pagination" id="adminsTable" data-page-size="10">
                            <thead>
                                <tr>
                                    <th class="w-[8%]">ID</th>
                                    <th class="w-[18%]">Tên Đăng nhập</th>
                                    <th class="w-[24%]">Họ và Tên</th>
                                    <th class="w-[22%]">Email liên kết</th>
                                    <th class="w-[14%]">Vai trò (Role)</th>
                                    <th class="w-[14%]">Trạng thái</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-slate-100 text-xs">
                                <c:forEach var="u" items="${users}">
                                    <tr class="hover:bg-slate-50/80 transition-colors">
                                        <td class="align-middle text-slate-400 font-mono">#${u.id}</td>
                                        <td class="align-middle font-mono font-bold text-sky-700">
                                            @${u.username}
                                        </td>
                                        <td class="align-middle font-bold text-slate-900">${u.fullName}</td>
                                        <td class="align-middle text-slate-500 font-mono text-[11px]">
                                            ${u.email}
                                        </td>
                                        <td class="align-middle whitespace-nowrap">
                                            <span class="status-badge ${u.role == 'ADMIN' ? 'status-danger' : u.role == 'DEAN' ? 'status-info' : u.role == 'LECTURER' ? 'status-pending' : 'status-approved'}">
                                                ${u.role}
                                            </span>
                                        </td>
                                        <td class="align-middle whitespace-nowrap">
                                            <span class="status-badge ${u.enabled ? 'status-approved' : 'status-danger'}">
                                                ${u.enabled ? 'HOẠT ĐỘNG' : 'KHÓA'}
                                            </span>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="../common/footer.jsp" />

<script>
    function switchUserTab(tabName) {
        document.querySelectorAll('.tab-pane').forEach(pane => {
            pane.classList.add('hidden');
            pane.classList.remove('block');
        });

        document.querySelectorAll('.tab-btn').forEach(btn => {
            btn.classList.remove('bg-white', 'text-sky-700', 'shadow-xs');
            btn.classList.add('text-slate-600');
        });

        const activePane = document.getElementById('pane-' + tabName);
        if (activePane) {
            activePane.classList.remove('hidden');
            activePane.classList.add('block');
        }

        const activeBtn = document.getElementById('btn-tab-' + tabName);
        if (activeBtn) {
            activeBtn.classList.add('bg-white', 'text-sky-700', 'shadow-xs');
            activeBtn.classList.remove('text-slate-600');
        }
        if (typeof lucide !== 'undefined') lucide.createIcons();
    }
</script>
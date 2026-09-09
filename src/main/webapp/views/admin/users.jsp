<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <c:set var="pageTitle" value="Quản lý tài khoản & người dùng" />
            <c:set var="pageHeading" value="Quản lý tài khoản & phân quyền hệ thống" />
            <c:set var="pageSubheading"
                value="Danh sách tài khoản Giảng viên, Sinh viên và Quản trị viên trong hệ thống" />
            <c:set var="activeMenu" value="users" />

            <jsp:include page="../common/header.jsp" />
            <jsp:include page="../common/sidebar.jsp" />

            <div class="app-main">
                <jsp:include page="../common/navbar.jsp" />

                <main class="app-content space-y-6">
                    <!-- Tabs Nav -->
                    <div class="flex items-center gap-1.5 p-1.5 bg-slate-200/80 rounded-2xl w-fit">
                        <button type="button" onclick="switchUserTab('lecturers')" id="btn-tab-lecturers"
                            class="tab-btn px-4 py-2 rounded-xl text-xs font-bold transition-all duration-200 bg-white text-blue-600 shadow-xs flex items-center gap-1.5">
                            <i data-lucide="user-check" class="w-4 h-4"></i> Giảng viên (${fn:length(lecturers)})
                        </button>
                        <button type="button" onclick="switchUserTab('students')" id="btn-tab-students"
                            class="tab-btn px-4 py-2 rounded-xl text-xs font-bold transition-all duration-200 text-slate-600 hover:text-slate-900 flex items-center gap-1.5">
                            <i data-lucide="graduation-cap" class="w-4 h-4"></i> Sinh viên (${fn:length(students)})
                        </button>
                        <button type="button" onclick="switchUserTab('allusers')" id="btn-tab-allusers"
                            class="tab-btn px-4 py-2 rounded-xl text-xs font-bold transition-all duration-200 text-slate-600 hover:text-slate-900 flex items-center gap-1.5">
                            <i data-lucide="users" class="w-4 h-4"></i> Tất cả Tài khoản (${fn:length(users)})
                        </button>
                    </div>

                    <div id="userTabsContent">
                        <!-- 1. Lecturers Pane -->
                        <!-- 1. Lecturers Pane (Vừa khít khung, Email 1 hàng, Học vị thoáng rộng) -->
                        <div id="pane-lecturers" class="tab-pane block">
                            <div class="bg-white rounded-2xl border border-slate-200 shadow-xs overflow-hidden">
                                <table class="w-full text-left border-collapse">
                                    <thead>
                                        <tr
                                            class="bg-slate-50/80 border-b border-slate-200 text-[11px] font-bold uppercase tracking-wider text-slate-500">
                                            <th class="px-3.5 py-3.5 w-[10%]">Mã GV</th>
                                            <th class="px-3.5 py-3.5 w-[22%]">Họ và Tên Giảng viên</th>
                                            <th class="px-3.5 py-3.5 w-[16%]">Học hàm / Học vị</th>
                                            <th class="px-3.5 py-3.5 w-[18%]">Khoa</th>
                                            <th class="px-3.5 py-3.5 w-[18%]">Lĩnh vực Nghiên cứu</th>
                                            <th class="px-3.5 py-3.5 w-[16%]">Email liên hệ</th>
                                        </tr>
                                    </thead>
                                    <tbody class="divide-y divide-slate-100 text-xs">
                                        <c:forEach var="l" items="${lecturers}">
                                            <tr class="hover:bg-slate-50/80 transition-colors">
                                                <!-- Mã GV -->
                                                <td
                                                    class="px-3.5 py-3.5 font-mono font-bold text-blue-600 align-top w-[10%]">
                                                    <span
                                                        class="px-2 py-0.5 rounded bg-blue-50 text-blue-700 border border-blue-200 inline-block text-[11px]">
                                                        ${l.lecturerCode}
                                                    </span>
                                                </td>

                                                <!-- Họ và Tên -->
                                                <td class="px-3.5 py-3.5 align-top w-[22%]">
                                                    <div class="font-bold text-slate-900 leading-snug break-words">
                                                        ${l.user.fullName}</div>
                                                    <div class="text-[11px] text-slate-400 mt-0.5">@${l.user.username}
                                                    </div>
                                                </td>

                                                <!-- Học hàm / Học vị (Nới rộng lên 16%, chống dính) -->
                                                <td class="px-3.5 py-3.5 align-top w-[16%]">
                                                    <span
                                                        class="px-2.5 py-1 rounded-md text-xs font-semibold bg-slate-100 text-slate-700 border border-slate-200 inline-block whitespace-nowrap">
                                                        ${l.academicDegree != null ? l.academicDegree : l.degree}
                                                    </span>
                                                </td>

                                                <!-- Khoa -->
                                                <td class="px-3.5 py-3.5 align-top w-[18%]">
                                                    <span
                                                        class="px-2.5 py-1 rounded-md text-xs font-semibold bg-indigo-50 text-indigo-700 border border-indigo-200 inline-block leading-snug break-words">
                                                        ${l.department != null ? l.department.name : 'Chung'}
                                                    </span>
                                                </td>

                                                <!-- Lĩnh vực Nghiên cứu -->
                                                <td
                                                    class="px-3.5 py-3.5 align-top w-[18%] text-slate-600 leading-snug break-words">
                                                    ${l.researchField != null ? l.researchField : 'Công nghệ thông tin'}
                                                </td>

                                                <!-- Email (Buộc nằm 1 hàng duy nhất) -->
                                                <td
                                                    class="px-3.5 py-3.5 align-top w-[16%] text-slate-500 font-mono text-[11px] whitespace-nowrap">
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
                            <div class="bg-white rounded-2xl border border-slate-200 shadow-xs overflow-hidden">
                                <div class="overflow-x-auto">
                                    <table class="w-full text-left border-collapse">
                                        <thead>
                                            <tr
                                                class="bg-slate-50/80 border-b border-slate-200 text-[11px] font-bold uppercase tracking-wider text-slate-500">
                                                <th class="px-5 py-3.5 w-[14%]">Mã số SV (MSSV)</th>
                                                <th class="px-5 py-3.5 w-[22%]">Họ và Tên Sinh viên</th>
                                                <th class="px-5 py-3.5 w-[16%]">Lớp & Khóa</th>
                                                <th class="px-5 py-3.5 w-[18%]">Ngành học</th>
                                                <th class="px-5 py-3.5 w-[15%]">Khoa</th>
                                                <th class="px-5 py-3.5 w-[15%]">Email Sinh viên</th>
                                            </tr>
                                        </thead>
                                        <tbody class="divide-y divide-slate-100 text-xs">
                                            <c:forEach var="s" items="${students}">
                                                <tr class="hover:bg-slate-50/80 transition-colors">
                                                    <td
                                                        class="px-5 py-4 font-mono font-bold text-emerald-600 whitespace-nowrap">
                                                        <span
                                                            class="px-2 py-0.5 rounded bg-emerald-50 text-emerald-700 border border-emerald-200">${s.studentCode}</span>
                                                    </td>
                                                    <td class="px-5 py-4">
                                                        <div class="font-bold text-slate-900">${s.user.fullName}</div>
                                                        <div class="text-[11px] text-slate-400">@${s.user.username}
                                                        </div>
                                                    </td>
                                                    <td class="px-5 py-4 whitespace-nowrap">
                                                        <span
                                                            class="px-2 py-0.5 rounded bg-slate-100 text-slate-700 border border-slate-200 font-semibold inline-block">
                                                            ${s.className} &bull; ${s.courseYear}
                                                        </span>
                                                    </td>
                                                    <td class="px-5 py-4 font-semibold text-slate-700">
                                                        ${s.major}
                                                    </td>
                                                    <td class="px-5 py-4 whitespace-nowrap">
                                                        <span
                                                            class="px-2 py-0.5 rounded bg-blue-50 text-blue-700 font-semibold inline-block">
                                                            ${s.department != null ? s.department.code : 'CNTT'}
                                                        </span>
                                                    </td>
                                                    <td
                                                        class="px-5 py-4 text-slate-500 font-mono text-[11px] whitespace-nowrap">
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
                            <div class="bg-white rounded-2xl border border-slate-200 shadow-xs overflow-hidden">
                                <div class="overflow-x-auto">
                                    <table class="w-full text-left border-collapse">
                                        <thead>
                                            <tr
                                                class="bg-slate-50/80 border-b border-slate-200 text-[11px] font-bold uppercase tracking-wider text-slate-500">
                                                <th class="px-5 py-3.5 w-[8%]">ID</th>
                                                <th class="px-5 py-3.5 w-[18%]">Tên Đăng nhập</th>
                                                <th class="px-5 py-3.5 w-[24%]">Họ và Tên</th>
                                                <th class="px-5 py-3.5 w-[22%]">Email liên kết</th>
                                                <th class="px-5 py-3.5 w-[14%]">Vai trò (Role)</th>
                                                <th class="px-5 py-3.5 w-[14%]">Trạng thái</th>
                                            </tr>
                                        </thead>
                                        <tbody class="divide-y divide-slate-100 text-xs">
                                            <c:forEach var="u" items="${users}">
                                                <tr class="hover:bg-slate-50/80 transition-colors">
                                                    <td class="px-5 py-4 text-slate-400 font-mono">#${u.id}</td>
                                                    <td class="px-5 py-4 font-mono font-bold text-blue-600">
                                                        @${u.username}</td>
                                                    <td class="px-5 py-4 font-bold text-slate-900">${u.fullName}</td>
                                                    <td class="px-5 py-4 text-slate-500 font-mono text-[11px]">
                                                        ${u.email}</td>
                                                    <td class="px-5 py-4 whitespace-nowrap">
                                                        <span
                                                            class="px-2.5 py-1 rounded-lg text-[11px] font-bold inline-block ${u.role == 'ADMIN' ? 'bg-rose-100 text-rose-800' : u.role == 'DEAN' ? 'bg-blue-100 text-blue-800' : u.role == 'LECTURER' ? 'bg-amber-100 text-amber-800' : 'bg-emerald-100 text-emerald-800'}">
                                                            ${u.role}
                                                        </span>
                                                    </td>
                                                    <td class="px-5 py-4 whitespace-nowrap">
                                                        <span
                                                            class="px-2.5 py-1 rounded-lg text-[11px] font-bold inline-block ${u.enabled ? 'bg-emerald-100 text-emerald-800' : 'bg-rose-100 text-rose-800'}">
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
            </div>

            <script>
                function switchUserTab(tabName) {
                    // Ẩn tất cả các nội dung tab
                    document.querySelectorAll('.tab-pane').forEach(pane => {
                        pane.classList.add('hidden');
                        pane.classList.remove('block');
                    });

                    // Đưa tất cả nút về trạng thái thường
                    document.querySelectorAll('.tab-btn').forEach(btn => {
                        btn.classList.remove('bg-white', 'text-blue-600', 'shadow-xs');
                        btn.classList.add('text-slate-600');
                    });

                    // Hiển thị nội dung tab được chọn
                    const activePane = document.getElementById('pane-' + tabName);
                    if (activePane) {
                        activePane.classList.remove('hidden');
                        activePane.classList.add('block');
                    }

                    // Kích hoạt style active cho nút bấm
                    const activeBtn = document.getElementById('btn-tab-' + tabName);
                    if (activeBtn) {
                        activeBtn.classList.add('bg-white', 'text-blue-600', 'shadow-xs');
                        activeBtn.classList.remove('text-slate-600');
                    }
                }
            </script>
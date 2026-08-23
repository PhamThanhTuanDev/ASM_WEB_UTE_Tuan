<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle" value="Đề xuất đề tài giảng viên" />
<c:set var="pageHeading" value="Đề xuất & quản lý đề tài giảng viên" />
<c:set var="pageSubheading" value="Đề xuất các hướng nghiên cứu, chỉ định đồng hướng dẫn và theo dõi duyệt từ Khoa" />
<c:set var="activeMenu" value="topics" />

<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/sidebar.jsp" />

<div class="app-main">
    <jsp:include page="../common/navbar.jsp" />

    <main class="app-content space-y-6">
        <!-- Top Action Bar -->
        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-xs flex flex-col sm:flex-row sm:items-center justify-between gap-4">
            <div>
                <h2 class="text-lg font-bold text-slate-900 flex items-center gap-2">
                    <i data-lucide="book-marked" class="w-5 h-5 text-blue-600"></i> Đề tài của thầy/cô
                </h2>
                <p class="text-xs text-slate-500 mt-0.5">Hiện đang phụ trách <strong class="text-blue-600">${fn:length(topics)}</strong> đề tài trong các đợt</p>
            </div>
            <button class="inline-flex items-center gap-2 px-4 py-2.5 bg-blue-600 hover:bg-blue-700 text-white text-xs font-bold rounded-xl shadow-sm hover:shadow-md transition-all duration-200" 
                    data-bs-toggle="modal" data-bs-target="#proposeTopicModal">
                <i data-lucide="plus-circle" class="w-4 h-4"></i> Đề xuất đề tài mới
            </button>
        </div>

        <!-- Topics Table -->
        <div class="bg-white rounded-2xl border border-slate-200 shadow-xs overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse min-w-[960px]">
                    <thead>
                        <tr class="bg-slate-50/80 border-b border-slate-200 text-[11px] font-bold uppercase tracking-wider text-slate-500">
                            <th class="px-4 py-3 whitespace-nowrap">Mã ĐT</th>
                            <th class="px-4 py-3 min-w-[220px]">Tên đề tài</th>
                            <th class="px-4 py-3 whitespace-nowrap">Bộ môn</th>
                            <th class="px-4 py-3 whitespace-nowrap">Vai trò</th>
                            <th class="px-4 py-3 whitespace-nowrap">Đồng HD</th>
                            <th class="px-3 py-3 text-center whitespace-nowrap">SV</th>
                            <th class="px-4 py-3 whitespace-nowrap">Trạng thái</th>
                            <th class="px-4 py-3 min-w-[160px]">Đợt đăng ký</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-100 text-xs">
                        <c:forEach var="t" items="${topics}">
                            <tr class="hover:bg-slate-50/80 transition-colors">
                                <td class="px-4 py-3 align-middle whitespace-nowrap">
                                    <span class="inline-block px-2 py-0.5 rounded-md bg-blue-50 text-blue-700 border border-blue-200 font-mono font-bold text-[11px] whitespace-nowrap">${t.code}</span>
                                </td>
                                <td class="px-4 py-3 align-middle">
                                    <div class="font-bold text-slate-900 text-[12px] leading-snug">${t.title}</div>
                                    <c:if test="${not empty t.description}">
                                        <p class="text-[10px] text-slate-500 line-clamp-1 mt-0.5">${t.description}</p>
                                    </c:if>
                                </td>
                                <td class="px-4 py-3 align-middle whitespace-nowrap text-slate-700 font-medium">
                                    ${t.department.name}
                                </td>
                                <td class="px-4 py-3 align-middle whitespace-nowrap">
                                    <span class="inline-flex px-2 py-0.5 rounded-md text-[10px] font-bold ${t.lecturer.id == lecturer.id ? 'bg-blue-100 text-blue-800 border border-blue-200' : 'bg-indigo-100 text-indigo-800 border border-indigo-200'}">
                                        ${t.lecturer.id == lecturer.id ? 'GVHD CHÍNH' : 'ĐỒNG HD'}
                                    </span>
                                </td>
                                <td class="px-4 py-3 align-middle whitespace-nowrap text-slate-600">
                                    <c:choose>
                                        <c:when test="${t.coLecturer != null}">${t.coLecturer.user.fullName}</c:when>
                                        <c:otherwise><span class="text-slate-400">Không có</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="px-3 py-3 align-middle text-center whitespace-nowrap">
                                    <span class="inline-block px-2 py-0.5 rounded-md bg-slate-100 text-slate-700 border border-slate-200 font-bold text-[11px]">${t.maxStudents}</span>
                                </td>
                                <td class="px-4 py-3 align-middle whitespace-nowrap">
                                    <c:choose>
                                        <c:when test="${t.status == 'PUBLISHED' || t.status == 'APPROVED'}">
                                            <span class="inline-flex px-2 py-0.5 rounded-md text-[10px] font-bold bg-emerald-100 text-emerald-800 border border-emerald-200">ĐÃ DUYỆT</span>
                                        </c:when>
                                        <c:when test="${t.status == 'PENDING' || t.status == 'DRAFT'}">
                                            <span class="inline-flex px-2 py-0.5 rounded-md text-[10px] font-bold bg-amber-100 text-amber-800 border border-amber-200">CHỜ DUYỆT</span>
                                        </c:when>
                                        <c:when test="${t.status == 'REJECTED'}">
                                            <span class="inline-flex px-2 py-0.5 rounded-md text-[10px] font-bold bg-rose-100 text-rose-800 border border-rose-200">TỪ CHỐI</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="inline-flex px-2 py-0.5 rounded-md text-[10px] font-bold bg-slate-100 text-slate-700 border border-slate-200">${t.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="px-4 py-3 align-middle text-slate-600">
                                    ${t.registrationPeriod != null ? t.registrationPeriod.name : 'Chung'}
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty topics}">
                            <tr>
                                <td colspan="8" class="px-4 py-10 text-center text-slate-400 text-xs">Chưa có đề tài nào. Hãy đề xuất đề tài mới.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <!-- Multi-Step / Card Sectioned Topic Proposal Modal -->
    <div class="modal fade" id="proposeTopicModal" tabindex="-1">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content rounded-3xl border-0 shadow-2xl overflow-hidden">
                <form method="post" action="${pageContext.request.contextPath}/lecturer/topics/save">
                    <div class="bg-gradient-to-r from-blue-600 to-indigo-700 px-6 py-4 text-white flex justify-between items-center">
                        <h5 class="text-base font-bold flex items-center gap-2">
                            <i data-lucide="file-plus" class="w-5 h-5"></i> Đề Xuất Đề Tài Nghiên Cứu Mới
                        </h5>
                        <button type="button" class="text-white/80 hover:text-white p-1" data-bs-dismiss="modal">
                            <i data-lucide="x" class="w-5 h-5"></i>
                        </button>
                    </div>

                    <div class="p-6 space-y-4 max-h-[80vh] overflow-y-auto">
                        <!-- Step indicators -->
                        <div class="flex items-center gap-2 mb-2" id="proposeStepNav">
                            <button type="button" class="propose-step-btn flex-1 px-3 py-2 rounded-xl text-[11px] font-bold bg-blue-600 text-white" data-step="1">1. Thông tin chung</button>
                            <button type="button" class="propose-step-btn flex-1 px-3 py-2 rounded-xl text-[11px] font-bold bg-slate-100 text-slate-600" data-step="2">2. Yêu cầu SV</button>
                            <button type="button" class="propose-step-btn flex-1 px-3 py-2 rounded-xl text-[11px] font-bold bg-slate-100 text-slate-600" data-step="3">3. Đồng HD</button>
                        </div>

                        <!-- Step 1: Thông tin chung đề tài -->
                        <div class="propose-step bg-slate-50 p-5 rounded-2xl border border-slate-200 space-y-4" data-step-panel="1">
                            <div class="flex items-center gap-2 border-b border-slate-200 pb-2">
                                <span class="w-6 h-6 rounded-full bg-blue-600 text-white font-bold text-xs flex items-center justify-center">1</span>
                                <h6 class="text-xs font-bold text-slate-900 uppercase tracking-wider">Thông Tin Chung Đề Tài</h6>
                            </div>

                            <div class="grid grid-cols-1 sm:grid-cols-3 gap-3">
                                <div>
                                    <label class="block text-xs font-bold text-slate-700 mb-1">Mã đề tài <span class="text-rose-500">*</span></label>
                                    <input type="text" name="code" class="w-full px-3.5 py-2.5 bg-white border border-slate-200 rounded-xl text-xs font-mono font-bold text-blue-600 focus:ring-2 focus:ring-blue-500 focus:outline-none" placeholder="Ví dụ: DT010" required>
                                </div>
                                <div class="sm:col-span-2">
                                    <label class="block text-xs font-bold text-slate-700 mb-1">Tên đề tài <span class="text-rose-500">*</span></label>
                                    <input type="text" name="title" class="w-full px-3.5 py-2.5 bg-white border border-slate-200 rounded-xl text-xs font-semibold focus:ring-2 focus:ring-blue-500 focus:outline-none" placeholder="Nhập tên đề tài..." required>
                                </div>
                            </div>

                            <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                                <div>
                                    <label class="block text-xs font-bold text-slate-700 mb-1">Bộ môn quản lý <span class="text-rose-500">*</span></label>
                                    <select name="departmentId" class="w-full px-3.5 py-2.5 bg-white border border-slate-200 rounded-xl text-xs font-semibold focus:ring-2 focus:ring-blue-500 focus:outline-none" required>
                                        <c:forEach var="d" items="${departments}">
                                            <option value="${d.id}" ${lecturer.department != null && lecturer.department.id == d.id ? 'selected' : ''}>${d.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div>
                                    <label class="block text-xs font-bold text-slate-700 mb-1">Đợt đăng ký áp dụng <span class="text-rose-500">*</span></label>
                                    <select name="periodId" class="w-full px-3.5 py-2.5 bg-white border border-slate-200 rounded-xl text-xs font-semibold focus:ring-2 focus:ring-blue-500 focus:outline-none" required>
                                        <c:forEach var="p" items="${periods}">
                                            <option value="${p.id}">${p.name} (${p.type})</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div>
                                <label class="block text-xs font-bold text-slate-700 mb-1">Mô tả chi tiết nội dung đề tài <span class="text-rose-500">*</span></label>
                                <textarea name="description" rows="3" class="w-full px-3.5 py-2.5 bg-white border border-slate-200 rounded-xl text-xs focus:ring-2 focus:ring-blue-500 focus:outline-none" placeholder="Mục tiêu, phạm vi và công nghệ áp dụng..." required></textarea>
                            </div>
                        </div>

                        <!-- Step 2: Yêu cầu đối với Sinh viên -->
                        <div class="propose-step hidden bg-slate-50 p-5 rounded-2xl border border-slate-200 space-y-4" data-step-panel="2">
                            <div class="flex items-center gap-2 border-b border-slate-200 pb-2">
                                <span class="w-6 h-6 rounded-full bg-blue-600 text-white font-bold text-xs flex items-center justify-center">2</span>
                                <h6 class="text-xs font-bold text-slate-900 uppercase tracking-wider">Yêu Cầu Đối Với Sinh Viên</h6>
                            </div>

                            <div class="grid grid-cols-1 sm:grid-cols-3 gap-3">
                                <div>
                                    <label class="block text-xs font-bold text-slate-700 mb-1">Số SV tối đa <span class="text-rose-500">*</span></label>
                                    <input type="number" name="maxStudents" value="3" min="1" max="3" class="w-full px-3.5 py-2.5 bg-white border border-slate-200 rounded-xl text-xs font-bold focus:ring-2 focus:ring-blue-500 focus:outline-none" required>
                                </div>
                                <div class="sm:col-span-2">
                                    <label class="block text-xs font-bold text-slate-700 mb-1">Yêu cầu kiến thức / kỹ năng tiên quyết</label>
                                    <input type="text" name="requirements" class="w-full px-3.5 py-2.5 bg-white border border-slate-200 rounded-xl text-xs focus:ring-2 focus:ring-blue-500 focus:outline-none" placeholder="Ví dụ: Spring Boot, ReactJS, Machine Learning...">
                                </div>
                            </div>
                        </div>

                        <!-- Step 3: Phân công Đồng hướng dẫn -->
                        <div class="propose-step hidden bg-slate-50 p-5 rounded-2xl border border-slate-200 space-y-4" data-step-panel="3">
                            <div class="flex items-center gap-2 border-b border-slate-200 pb-2">
                                <span class="w-6 h-6 rounded-full bg-blue-600 text-white font-bold text-xs flex items-center justify-center">3</span>
                                <h6 class="text-xs font-bold text-slate-900 uppercase tracking-wider">Phân Công Hướng Dẫn & Đồng Hướng Dẫn</h6>
                            </div>

                            <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                                <div>
                                    <label class="block text-xs font-bold text-slate-700 mb-1">GVHD Chính (PRIMARY)</label>
                                    <input type="text" class="w-full px-3.5 py-2.5 bg-slate-200/70 border border-slate-300 rounded-xl text-xs font-bold text-slate-800" value="${lecturer.user.fullName} (${lecturer.department != null ? lecturer.department.name : 'CNTT'})" readonly>
                                </div>
                                <div>
                                    <label class="block text-xs font-bold text-slate-700 mb-1">Mời Đồng GVHD (CO_SUPERVISOR - Tùy chọn)</label>
                                    <select name="coLecturerId" class="w-full px-3.5 py-2.5 bg-white border border-slate-200 rounded-xl text-xs font-semibold focus:ring-2 focus:ring-blue-500 focus:outline-none">
                                        <option value="">-- Không có đồng hướng dẫn --</option>
                                        <c:forEach var="l" items="${lecturers}">
                                            <c:if test="${l.id != lecturer.id}">
                                                <option value="${l.id}">${l.user.fullName} (${l.department != null ? l.department.name : ''})</option>
                                            </c:if>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="bg-slate-50 px-6 py-4 border-t border-slate-100 flex justify-between gap-3">
                        <button type="button" id="proposePrevBtn" class="px-4 py-2 bg-white border border-slate-200 text-slate-700 text-xs font-bold rounded-xl hover:bg-slate-100 transition-colors hidden">Quay lại</button>
                        <div class="flex gap-3 ml-auto">
                            <button type="button" class="px-4 py-2 bg-white border border-slate-200 text-slate-700 text-xs font-bold rounded-xl hover:bg-slate-100 transition-colors" data-bs-dismiss="modal">Hủy</button>
                            <button type="button" id="proposeNextBtn" class="px-5 py-2 bg-blue-600 hover:bg-blue-700 text-white text-xs font-bold rounded-xl shadow-sm hover:shadow-md transition-all">Tiếp tục</button>
                            <button type="submit" id="proposeSubmitBtn" class="hidden px-5 py-2 bg-blue-600 hover:bg-blue-700 text-white text-xs font-bold rounded-xl shadow-sm hover:shadow-md transition-all">
                                Gửi Đề Xuất Cho Khoa
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>

<jsp:include page="../common/footer.jsp" />

<script>
    (function () {
        let currentStep = 1;
        const total = 3;

        function goStep(step) {
            currentStep = step;
            document.querySelectorAll('.propose-step').forEach((p) => {
                p.classList.toggle('hidden', Number(p.dataset.stepPanel) !== step);
            });
            document.querySelectorAll('.propose-step-btn').forEach((b) => {
                const active = Number(b.dataset.step) === step;
                b.className = 'propose-step-btn flex-1 px-3 py-2 rounded-xl text-[11px] font-bold ' +
                    (active ? 'bg-blue-600 text-white' : 'bg-slate-100 text-slate-600');
            });
            document.getElementById('proposePrevBtn').classList.toggle('hidden', step === 1);
            document.getElementById('proposeNextBtn').classList.toggle('hidden', step === total);
            document.getElementById('proposeSubmitBtn').classList.toggle('hidden', step !== total);
        }

        document.addEventListener('DOMContentLoaded', () => {
            document.getElementById('proposeNextBtn')?.addEventListener('click', () => {
                if (currentStep < total) goStep(currentStep + 1);
            });
            document.getElementById('proposePrevBtn')?.addEventListener('click', () => {
                if (currentStep > 1) goStep(currentStep - 1);
            });
            document.querySelectorAll('.propose-step-btn').forEach((b) => {
                b.addEventListener('click', () => goStep(Number(b.dataset.step)));
            });
            goStep(1);
        });
    })();
</script>

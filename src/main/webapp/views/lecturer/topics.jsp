<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <c:set scope="request" var="pageTitle" value="Đề xuất đề tài giảng viên" />
            <c:set scope="request" var="pageHeading" value="Đề xuất và quản lý đề tài giảng viên" />
            <c:set scope="request" var="pageSubheading"
                value="Đề xuất các hướng nghiên cứu, chỉ định đồng hướng dẫn và theo dõi duyệt từ Khoa" />
            <c:set scope="request" var="activeMenu" value="topics" />

            <jsp:include page="../common/header.jsp" />
            <jsp:include page="../common/sidebar.jsp" />

            <div class="app-main">
                <jsp:include page="../common/navbar.jsp" />

                <main class="app-content workspace-page space-y-6">
                    <!-- Top Action Bar -->
                    <div
                        class="bg-white p-5 rounded-3xl border border-slate-200 shadow-sm flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                        <div class="flex items-center gap-3">
                            <div
                                class="w-10 h-10 rounded-2xl bg-sky-50 text-sky-700 flex items-center justify-center border border-sky-100 shadow-xs">
                                <i data-lucide="book-marked" class="w-5 h-5"></i>
                            </div>
                            <div>
                                <h2 class="text-base font-bold text-slate-900 leading-tight">Đề tài của thầy/cô</h2>
                                <p class="text-xs text-slate-500 mt-0.5">Hiện đang phụ trách <strong
                                        class="text-sky-700">${fn:length(topics)}</strong> đề tài trong các đợt</p>
                            </div>
                        </div>
                        <button class="btn-ui btn-ui-primary text-xs py-2.5 px-4 shadow-sm" data-bs-toggle="modal"
                            data-bs-target="#proposeTopicModal" ${empty periods ? 'disabled' : ''}>
                            <i data-lucide="plus-circle" class="w-4 h-4"></i> Đề xuất đề tài mới
                        </button>
                    </div>
                    <c:if test="${empty periods}">
                        <p class="text-sm text-amber-700">Hiện không có đợt đang mở và còn trong thời hạn giảng viên đề xuất đề tài.</p>
                    </c:if>

                    <!-- Topics Table Shell -->
                    <div class="table-shell">
                        <div class="overflow-x-auto">
                            <table class="w-full text-left border-collapse min-w-[960px] datatable-pagination"
                                id="lecturerTopicsTable" data-page-size="10">
                                <thead>
                                    <tr>
                                        <th class="whitespace-nowrap">Mã ĐT</th>
                                        <th class="min-w-[220px]">Tên đề tài</th>
                                        <th class="whitespace-nowrap">Khoa</th>
                                        <th class="whitespace-nowrap">Vai trò</th>
                                        <th class="whitespace-nowrap">Đồng HD</th>
                                        <th class="text-center whitespace-nowrap">SV (3)</th>
                                        <th class="whitespace-nowrap">Trạng thái</th>
                                        <th class="min-w-[160px]">Đợt đăng ký</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-slate-100 text-xs">
                                    <c:forEach var="t" items="${topics}">
                                        <tr class="hover:bg-slate-50/80 transition-colors">
                                            <td class="align-middle whitespace-nowrap">
                                                <span class="code-tag">${t.code}</span>
                                            </td>
                                            <td class="align-middle">
                                                <div class="font-bold text-slate-900 text-xs leading-snug"><c:out value="${t.title}" />
                                                </div>
                                                <c:if test="${not empty t.description}">
                                                    <p class="text-[11px] text-slate-500 line-clamp-1 mt-0.5">
                                                        <c:out value="${t.description}" /></p>
                                                </c:if>
                                            </td>
                                            <td class="align-middle whitespace-nowrap text-slate-700 font-medium">
                                                <c:out value="${t.department.name}" />
                                            </td>
                                            <td class="align-middle whitespace-nowrap">
                                                <span
                                                    class="status-badge ${t.lecturer.id == lecturer.id ? 'status-info' : 'status-neutral'}">
                                                    ${t.lecturer.id == lecturer.id ? 'GVHD CHÍNH' : 'ĐỒNG HD'}
                                                </span>
                                            </td>
                                            <td class="align-middle whitespace-nowrap text-slate-600">
                                                <c:choose>
                                                    <c:when test="${t.coLecturer != null}"><c:out value="${t.coLecturer.user.fullName}" />
                                                    </c:when>
                                                    <c:otherwise><span class="text-slate-400">Không có</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="align-middle text-center whitespace-nowrap">
                                                <span
                                                    class="inline-block px-2 py-0.5 rounded-md bg-slate-100 text-slate-700 font-mono font-bold text-[11px]">${t.maxStudents}</span>
                                            </td>
                                            <td class="align-middle whitespace-nowrap">
                                                <c:choose>
                                                    <c:when test="${t.status == 'PUBLISHED' || t.status == 'APPROVED'}">
                                                        <span class="status-badge status-approved">ĐÃ DUYỆT</span>
                                                    </c:when>
                                                    <c:when test="${t.status == 'PENDING' || t.status == 'DRAFT'}">
                                                        <span class="status-badge status-pending">CHỜ DUYỆT</span>
                                                    </c:when>
                                                    <c:when test="${t.status == 'REJECTED'}">
                                                        <span class="status-badge status-danger">TỪ CHỐI</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span
                                                            class="status-badge status-neutral">${enumLabel.label(t.status)}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="align-middle text-slate-600">
                                                <c:out value="${t.registrationPeriod != null ? t.registrationPeriod.name : 'Chung'}" />
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty topics}">
                                        <tr class="table-empty-row">
                                            <td colspan="8">
                                                <div class="empty-state py-8">
                                                    <div class="empty-state-icon-wrap w-12 h-12 mb-2">
                                                        <i data-lucide="book-open" class="w-6 h-6 opacity-40"></i>
                                                    </div>
                                                    <div class="empty-state-desc text-xs mb-0">Chưa có đề tài nào. Hãy
                                                        đề xuất đề tài mới ngay.</div>
                                                </div>
                                            </td>
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
                            <form id="proposeTopicForm" method="post" novalidate action="${pageContext.request.contextPath}/lecturer/topics/save">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                <div
                                    class="bg-gradient-to-r from-sky-700 to-blue-900 px-6 py-4 text-white flex justify-between items-center">
                                    <h5 class="text-base font-bold flex items-center gap-2">
                                        <i data-lucide="file-plus" class="w-5 h-5 text-sky-300"></i> Đề Xuất Đề Tài
                                        Nghiên Cứu Mới
                                    </h5>
                                    <button type="button" class="text-white/80 hover:text-white p-1"
                                        data-bs-dismiss="modal">
                                        <i data-lucide="x" class="w-5 h-5"></i>
                                    </button>
                                </div>

                                <div class="p-6 space-y-4 max-h-[80vh] overflow-y-auto">
                                    <!-- Step indicators -->
                                    <div class="flex items-center gap-2 mb-2" id="proposeStepNav">
                                        <button type="button"
                                            class="propose-step-btn flex-1 px-3.5 py-2.5 rounded-xl text-[11px] font-bold bg-sky-600 text-white"
                                            data-step="1">1. Thông tin chung</button>
                                        <button type="button"
                                            class="propose-step-btn flex-1 px-3.5 py-2.5 rounded-xl text-[11px] font-bold bg-slate-100 text-slate-600"
                                            data-step="2">2. Yêu cầu sinh viên</button>
                                        <button type="button"
                                            class="propose-step-btn flex-1 px-3.5 py-2.5 rounded-xl text-[11px] font-bold bg-slate-100 text-slate-600"
                                            data-step="3">3. Đồng hướng dẫn</button>
                                    </div>

                                    <!-- Step 1: Thông tin chung đề tài -->
                                    <div class="propose-step bg-slate-50 p-5 rounded-2xl border border-slate-200 space-y-4"
                                        data-step-panel="1">
                                        <div class="flex items-center gap-2 border-b border-slate-200 pb-2">
                                            <span
                                                class="w-6 h-6 rounded-full bg-sky-600 text-white font-bold text-xs flex items-center justify-center">1</span>
                                            <h6 class="text-xs font-bold text-slate-900  tracking-wider">Thông
                                                Tin Chung Đề Tài</h6>
                                        </div>

                                        <div class="grid grid-cols-1 sm:grid-cols-3 gap-3">
                                            <div>
                                                <label class="block text-xs font-bold text-slate-700 mb-1.5">Mã đề tài
                                                    <span class="text-rose-500">*</span></label>
                                                <input type="text" name="code" maxlength="30"
                                                    class="w-full px-3.5 py-2.5 bg-white border border-slate-200 rounded-xl text-xs font-mono font-bold text-sky-700 focus:ring-2 focus:ring-sky-500 focus:outline-none"
                                                    placeholder="Ví dụ: DT010" required>
                                            </div>
                                            <div class="sm:col-span-2">
                                                <label class="block text-xs font-bold text-slate-700 mb-1.5">Tên đề tài
                                                    <span class="text-rose-500">*</span></label>
                                                <input type="text" name="title" maxlength="255"
                                                    class="w-full px-3.5 py-2.5 bg-white border border-slate-200 rounded-xl text-xs font-semibold focus:ring-2 focus:ring-sky-500 focus:outline-none"
                                                    placeholder="Nhập tên đề tài..." required>
                                            </div>
                                        </div>

                                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                                            <div>
                                                <label class="block text-xs font-bold text-slate-700 mb-1.5">Khoa quản
                                                    lý <span class="text-rose-500">*</span></label>
                                                <select name="departmentId"
                                                    class="w-full px-3.5 py-2.5 bg-white border border-slate-200 rounded-xl text-xs font-semibold focus:ring-2 focus:ring-sky-500 focus:outline-none"
                                                    required>
                                                    <c:forEach var="d" items="${departments}">
                                                        <option value="${d.id}" ${lecturer.department !=null &&
                                                            lecturer.department.id==d.id ? 'selected' : '' }><c:out value="${d.name}" />
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div>
                                                <label class="block text-xs font-bold text-slate-700 mb-1.5">Đợt đăng ký
                                                    áp dụng <span class="text-rose-500">*</span></label>
                                                <select name="periodId"
                                                    class="w-full px-3.5 py-2.5 bg-white border border-slate-200 rounded-xl text-xs font-semibold focus:ring-2 focus:ring-sky-500 focus:outline-none"
                                                    required>
                                                    <c:forEach var="p" items="${periods}">
                                                        <option value="${p.id}">${p.name} (${enumLabel.label(p.type)})
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </div>

                                        <div>
                                            <label class="block text-xs font-bold text-slate-700 mb-1.5">Mô tả chi tiết
                                                nội dung đề tài <span class="text-rose-500">*</span></label>
                                            <textarea name="description" rows="3"
                                                class="w-full px-3.5 py-2.5 bg-white border border-slate-200 rounded-xl text-xs focus:ring-2 focus:ring-sky-500 focus:outline-none"
                                                placeholder="Mục tiêu, phạm vi và công nghệ áp dụng..."
                                                required></textarea>
                                        </div>
                                    </div>

                                    <!-- Step 2: Yêu cầu đối với Sinh viên -->
                                    <div class="propose-step hidden bg-slate-50 p-5 rounded-2xl border border-slate-200 space-y-4"
                                        data-step-panel="2">
                                        <div class="flex items-center gap-2 border-b border-slate-200 pb-2">
                                            <span
                                                class="w-6 h-6 rounded-full bg-sky-600 text-white font-bold text-xs flex items-center justify-center">2</span>
                                            <h6 class="text-xs font-bold text-slate-900  tracking-wider">Yêu
                                                Cầu Đối Với Sinh Viên</h6>
                                        </div>

                                        <div class="grid grid-cols-1 sm:grid-cols-3 gap-3">
                                            <div>
                                                <label class="block text-xs font-bold text-slate-700 mb-1.5">Số SV tối
                                                    đa <span class="text-rose-500">*</span></label>
                                                <input type="number" name="maxStudents" value="3" min="1" max="3"
                                                    class="w-full px-3.5 py-2.5 bg-white border border-slate-200 rounded-xl text-xs font-bold focus:ring-2 focus:ring-sky-500 focus:outline-none"
                                                    required>
                                            </div>
                                            <div class="sm:col-span-2">
                                                <label class="block text-xs font-bold text-slate-700 mb-1.5">Yêu cầu
                                                    kiến thức / kỹ năng tiên quyết</label>
                                                <input type="text" name="requirements"
                                                    class="w-full px-3.5 py-2.5 bg-white border border-slate-200 rounded-xl text-xs focus:ring-2 focus:ring-sky-500 focus:outline-none"
                                                    placeholder="Ví dụ: Spring Boot, ReactJS, Machine Learning...">
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Step 3: Phân công Đồng hướng dẫn -->
                                    <div class="propose-step hidden bg-slate-50 p-5 rounded-2xl border border-slate-200 space-y-4"
                                        data-step-panel="3">
                                        <div class="flex items-center gap-2 border-b border-slate-200 pb-2">
                                            <span
                                                class="w-6 h-6 rounded-full bg-sky-600 text-white font-bold text-xs flex items-center justify-center">3</span>
                                            <h6 class="text-xs font-bold text-slate-900">Phân công hướng dẫn và đồng hướng dẫn</h6>
                                        </div>

                                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                                            <div>
                                                <label class="block text-xs font-bold text-slate-700 mb-1.5">Giảng viên hướng dẫn chính
                                                   </label>
                                                <input type="text"
                                                    class="w-full px-3.5 py-2.5 bg-slate-200/70 border border-slate-300 rounded-xl text-xs font-bold text-slate-800"
                                                    value="${lecturer.user.fullName} (${lecturer.department != null ? lecturer.department.name : 'CNTT'})"
                                                    readonly>
                                            </div>
                                            <div>
                                                <label class="block text-xs font-bold text-slate-700 mb-1.5">Giảng viên đồng hướng dẫn (tùy chọn)</label>
                                                <select name="coLecturerId"
                                                    class="w-full px-3.5 py-2.5 bg-white border border-slate-200 rounded-xl text-xs font-semibold focus:ring-2 focus:ring-sky-500 focus:outline-none">
                                                    <option value="">-- Không có đồng hướng dẫn --</option>
                                                    <c:forEach var="l" items="${lecturers}">
                                                        <c:if test="${l.id != lecturer.id}">
                                                            <option value="${l.id}">${l.user.fullName} (${l.department
                                                                != null ? l.department.name : ''})</option>
                                                        </c:if>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="bg-slate-50 px-6 py-4 border-t border-slate-100 flex justify-between gap-3">
                                    <button type="button" id="proposePrevBtn"
                                        class="btn-ui btn-ui-outline text-xs hidden">Quay lại</button>
                                    <div class="flex gap-3 ml-auto">
                                        <button type="button" class="btn-ui btn-ui-outline text-xs"
                                            data-bs-dismiss="modal">Hủy</button>
                                        <button type="button" id="proposeNextBtn"
                                            class="btn-ui btn-ui-primary text-xs">Tiếp tục</button>
                                        <button type="submit" id="proposeSubmitBtn"
                                            class="hidden btn-ui btn-ui-primary text-xs">
                                            Gửi đề xuất cho khoa
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
                                b.className = 'propose-step-btn flex-1 px-3.5 py-2.5 rounded-xl text-[11px] font-bold ' +
                                    (active ? 'bg-sky-600 text-white' : 'bg-slate-100 text-slate-600');
                            });
                            document.getElementById('proposePrevBtn')?.classList.toggle('hidden', step === 1);
                            document.getElementById('proposeNextBtn')?.classList.toggle('hidden', step === total);
                            document.getElementById('proposeSubmitBtn')?.classList.toggle('hidden', step !== total);
                        }

                        document.addEventListener('DOMContentLoaded', () => {
                            const form = document.getElementById('proposeTopicForm');
                            function validatePanels(lastStep) {
                                for (const field of form.querySelectorAll('input, select, textarea')) {
                                    const panel = field.closest('.propose-step');
                                    if (panel && Number(panel.dataset.stepPanel) > lastStep) continue;
                                    if (field.required && (field.type === 'text' || field.tagName === 'TEXTAREA')) {
                                        field.setCustomValidity(field.value.trim() ? '' : 'Vui lòng nhập thông tin, không chỉ nhập khoảng trắng.');
                                    }
                                    if (!field.checkValidity()) {
                                        if (panel) goStep(Number(panel.dataset.stepPanel));
                                        field.reportValidity();
                                        return false;
                                    }
                                }
                                return true;
                            }
                            form.addEventListener('input', (event) => event.target.setCustomValidity?.(''));
                            form.addEventListener('submit', (event) => {
                                if (!validatePanels(total)) event.preventDefault();
                            });
                            document.getElementById('proposeNextBtn')?.addEventListener('click', () => {
                                if (currentStep < total && validatePanels(currentStep)) goStep(currentStep + 1);
                            });
                            document.getElementById('proposePrevBtn')?.addEventListener('click', () => {
                                if (currentStep > 1) goStep(currentStep - 1);
                            });
                            document.querySelectorAll('.propose-step-btn').forEach((b) => {
                                b.addEventListener('click', () => {
                                    const target = Number(b.dataset.step);
                                    if (target <= currentStep || validatePanels(target - 1)) goStep(target);
                                });
                            });
                            goStep(1);
                        });
                    })();
                </script>

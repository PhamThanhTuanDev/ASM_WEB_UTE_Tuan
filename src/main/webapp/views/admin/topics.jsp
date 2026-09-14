<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle" value="Duyệt đề tài" />
<c:set var="pageHeading" value="Duyệt đề xuất đề tài" />
<c:set var="pageSubheading" value="GVHD nộp đề xuất → Trưởng khoa chấp nhận / từ chối → công bố cho sinh viên đăng ký" />
<c:set var="activeMenu" value="topics" />

<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/sidebar.jsp" />

<div class="app-main">
    <jsp:include page="../common/navbar.jsp" />

    <main class="app-content space-y-6">
        <!-- Search & Filter Toolbar Surface -->
        <div class="bg-white p-5 rounded-3xl border border-slate-200 shadow-sm">
            <form method="get" action="${pageContext.request.contextPath}/admin/topics" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-3.5 items-center">
                <div class="relative">
                    <i data-lucide="search" class="w-4 h-4 text-slate-400 absolute left-3.5 top-1/2 -translate-y-1/2"></i>
                    <input type="text" id="topicSearchInput" onkeyup="filterTopicsTable()" placeholder="Tìm mã, tên đề tài, GVHD..."
                           class="w-full pl-10 pr-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs font-medium focus:bg-white focus:ring-2 focus:ring-sky-500 focus:outline-none transition-all">
                </div>
                <div>
                    <select name="departmentId" onchange="this.form.submit()" class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs font-semibold text-slate-700 focus:ring-2 focus:ring-sky-500 focus:outline-none transition-all">
                        <option value="">-- Tất cả Khoa --</option>
                        <c:forEach var="d" items="${departments}">
                            <option value="${d.id}" ${selectedDept == d.id ? 'selected' : ''}>${d.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <div>
                    <select name="periodId" onchange="this.form.submit()" class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs font-semibold text-slate-700 focus:ring-2 focus:ring-sky-500 focus:outline-none transition-all">
                        <option value="">-- Tất cả Đợt đăng ký --</option>
                        <c:forEach var="p" items="${periods}">
                            <option value="${p.id}" ${selectedPeriod == p.id ? 'selected' : ''}>${p.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="sm:text-right">
                    <button type="button" class="btn-ui btn-ui-primary w-full sm:w-auto text-xs py-2.5 px-4 shadow-sm"
                            data-bs-toggle="modal" data-bs-target="#createTopicModal">
                        <i data-lucide="plus-circle" class="w-4 h-4"></i> Thêm đề tài mới
                    </button>
                </div>
            </form>
        </div>

        <!-- Topics Table Frame -->
        <div class="table-shell">
            <div class="px-6 py-4 border-b border-slate-100 flex items-center justify-between gap-3 flex-wrap bg-white">
                <div class="flex items-center gap-2.5">
                    <div class="w-8 h-8 rounded-xl bg-sky-50 text-sky-700 flex items-center justify-center border border-sky-100">
                        <i data-lucide="book-open-check" class="w-4 h-4"></i>
                    </div>
                    <div>
                        <h2 class="text-sm font-bold text-slate-900 leading-tight">Danh sách đề xuất đề tài</h2>
                        <p class="text-[11px] text-slate-500">Chấp nhận → công bố cho SV đăng ký &bull; Từ chối → trả lại GVHD chỉnh sửa</p>
                    </div>
                </div>
                <span class="status-badge status-neutral">${fn:length(topics)} đề tài</span>
            </div>
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse" id="topicsTable">
                    <thead>
                        <tr>
                            <th class="whitespace-nowrap">Mã đề tài</th>
                            <th class="min-w-[240px]">Tên đề tài &amp; Khoa</th>
                            <th class="whitespace-nowrap">GVHD</th>
                            <th class="min-w-[160px]">Đợt đăng ký</th>
                            <th class="text-center whitespace-nowrap">Số SV (3)</th>
                            <th class="whitespace-nowrap">Trạng thái</th>
                            <th class="text-right whitespace-nowrap">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-100 text-xs">
                        <c:forEach var="t" items="${topics}">
                            <tr class="hover:bg-slate-50/80 transition-colors topic-row">
                                <td class="align-middle whitespace-nowrap">
                                    <span class="code-tag">${t.code}</span>
                                </td>
                                <td class="align-middle">
                                    <div class="font-bold text-slate-900 text-xs leading-snug">${t.title}</div>
                                    <div class="text-[11px] text-slate-500 mt-0.5">${t.department.name}</div>
                                </td>
                                <td class="align-middle whitespace-nowrap">
                                    <div class="font-bold text-slate-800">
                                        ${t.lecturer != null ? t.lecturer.user.fullName : 'Chưa phân công'}
                                    </div>
                                    <c:if test="${not empty t.coLecturer}">
                                        <div class="text-[11px] text-slate-500 mt-0.5 font-medium">+ ${t.coLecturer.user.fullName}</div>
                                    </c:if>
                                </td>
                                <td class="align-middle text-slate-600">
                                    ${t.registrationPeriod != null ? t.registrationPeriod.name : 'Chung'}
                                </td>
                                <td class="align-middle text-center whitespace-nowrap">
                                    <span class="inline-block px-2 py-0.5 rounded-md bg-slate-100 text-slate-700 font-mono font-bold text-[11px]">${t.maxStudents}</span>
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
                                            <span class="status-badge status-neutral">${t.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="align-middle text-right whitespace-nowrap">
                                    <div class="inline-flex items-center justify-end gap-1.5">
                                        <c:if test="${t.status == 'PENDING' || t.status == 'DRAFT'}">
                                            <button type="button" onclick="approveTopicAjax('${t.id}', this)"
                                                    class="btn-ui bg-emerald-600 hover:bg-emerald-700 text-white text-[11px] py-1 px-2.5 rounded-lg shadow-xs"
                                                    title="Chấp nhận &amp; công bố">
                                                <i data-lucide="check" class="w-3.5 h-3.5"></i> Duyệt
                                            </button>
                                            <button type="button" onclick="rejectTopicSweetAlert('${t.id}', '${fn:escapeXml(t.title)}')"
                                                    class="btn-ui bg-rose-50 hover:bg-rose-600 text-rose-700 hover:text-white border border-rose-200 text-[11px] py-1 px-2.5 rounded-lg transition-colors"
                                                    title="Từ chối đề xuất">
                                                <i data-lucide="x" class="w-3.5 h-3.5"></i> Từ chối
                                            </button>
                                        </c:if>
                                        <form method="post" action="${pageContext.request.contextPath}/admin/topics/${t.id}/delete" class="inline" onsubmit="return confirmDeleteTopic(event, '${fn:escapeXml(t.title)}');">
                                            <button type="submit" class="p-1.5 text-slate-400 hover:text-rose-600 hover:bg-rose-50 rounded-lg transition-colors" title="Xóa">
                                                <i data-lucide="trash-2" class="w-4 h-4"></i>
                                            </button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty topics}">
                            <tr class="table-empty-row">
                                <td colspan="7">
                                    <div class="empty-state py-8">
                                        <div class="empty-state-icon-wrap w-12 h-12 mb-2">
                                            <i data-lucide="book-open" class="w-6 h-6 opacity-40"></i>
                                        </div>
                                        <div class="empty-state-desc text-xs mb-0">Chưa có đề xuất đề tài nào phù hợp với bộ lọc</div>
                                    </div>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <!-- Modal Create Topic -->
    <div class="modal fade" id="createTopicModal" tabindex="-1">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content rounded-3xl border-0 shadow-2xl overflow-hidden">
                <form method="post" action="${pageContext.request.contextPath}/admin/topics/save">
                    <div class="bg-gradient-to-r from-sky-700 to-blue-900 px-6 py-4 text-white flex justify-between items-center">
                        <h5 class="text-base font-bold flex items-center gap-2">
                            <i data-lucide="book-plus" class="w-5 h-5 text-sky-300"></i> Thêm đề tài mới
                        </h5>
                        <button type="button" class="text-white/80 hover:text-white p-1" data-bs-dismiss="modal">
                            <i data-lucide="x" class="w-5 h-5"></i>
                        </button>
                    </div>
                    <div class="p-6 space-y-4 max-h-[80vh] overflow-y-auto">
                        <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
                            <div>
                                <label class="block text-xs font-bold text-slate-700 mb-1.5">Mã đề tài <span class="text-rose-500">*</span></label>
                                <input type="text" name="code" class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs font-mono font-bold text-sky-700 focus:bg-white focus:ring-2 focus:ring-sky-500 focus:outline-none" placeholder="VD: CNTT-010" required>
                            </div>
                            <div class="sm:col-span-2">
                                <label class="block text-xs font-bold text-slate-700 mb-1.5">Tên đề tài <span class="text-rose-500">*</span></label>
                                <input type="text" name="title" class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs font-semibold focus:bg-white focus:ring-2 focus:ring-sky-500 focus:outline-none" placeholder="Nhập tên đề tài nghiên cứu" required>
                            </div>
                        </div>
                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                            <div>
                                <label class="block text-xs font-bold text-slate-700 mb-1.5">Khoa <span class="text-rose-500">*</span></label>
                                <select name="departmentId" class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs font-semibold focus:ring-2 focus:ring-sky-500 focus:outline-none" required>
                                    <c:forEach var="d" items="${departments}">
                                        <option value="${d.id}">${d.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div>
                                <label class="block text-xs font-bold text-slate-700 mb-1.5">Đợt đăng ký <span class="text-rose-500">*</span></label>
                                <select name="periodId" class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs font-semibold focus:ring-2 focus:ring-sky-500 focus:outline-none" required>
                                    <c:forEach var="p" items="${periods}">
                                        <option value="${p.id}">${p.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                            <div>
                                <label class="block text-xs font-bold text-slate-700 mb-1.5">GVHD chính <span class="text-rose-500">*</span></label>
                                <select name="primaryLecturerId" class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs font-semibold focus:ring-2 focus:ring-sky-500 focus:outline-none" required>
                                    <c:forEach var="lec" items="${lecturers}">
                                        <option value="${lec.id}">${lec.user.fullName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div>
                                <label class="block text-xs font-bold text-slate-700 mb-1.5">Đồng GVHD</label>
                                <select name="coLecturerId" class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs font-semibold focus:ring-2 focus:ring-sky-500 focus:outline-none">
                                    <option value="">-- Không có --</option>
                                    <c:forEach var="lec" items="${lecturers}">
                                        <option value="${lec.id}">${lec.user.fullName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
                            <div>
                                <label class="block text-xs font-bold text-slate-700 mb-1.5">Số SV tối đa</label>
                                <input type="number" name="maxStudents" value="3" min="1" max="3" class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs font-bold focus:ring-2 focus:ring-sky-500 focus:outline-none" required>
                            </div>
                            <div class="sm:col-span-2">
                                <label class="block text-xs font-bold text-slate-700 mb-1.5">Trạng thái duyệt</label>
                                <select name="status" class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs font-semibold focus:ring-2 focus:ring-sky-500 focus:outline-none">
                                    <option value="PENDING">Chờ duyệt</option>
                                    <option value="PUBLISHED">Công bố ngay (Đã duyệt)</option>
                                    <option value="DRAFT">Bản nháp</option>
                                </select>
                            </div>
                        </div>
                        <div>
                            <label class="block text-xs font-bold text-slate-700 mb-1.5">Mô tả đề tài</label>
                            <textarea name="description" rows="3" class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs focus:ring-2 focus:ring-sky-500 focus:outline-none" placeholder="Mục tiêu và tóm tắt nội dung đề tài..."></textarea>
                        </div>
                        <div>
                            <label class="block text-xs font-bold text-slate-700 mb-1.5">Yêu cầu đối với sinh viên</label>
                            <textarea name="requirements" rows="2" class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs focus:ring-2 focus:ring-sky-500 focus:outline-none" placeholder="Kỹ năng, kiến thức chuyên ngành cần thiết..."></textarea>
                        </div>
                    </div>
                    <div class="bg-slate-50 px-6 py-4 border-t border-slate-100 flex justify-end gap-3">
                        <button type="button" class="btn-ui btn-ui-outline text-xs" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn-ui btn-ui-primary text-xs">Lưu đề tài</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

<jsp:include page="../common/footer.jsp" />

<script>
    function filterTopicsTable() {
        const q = document.getElementById('topicSearchInput').value.toLowerCase();
        document.querySelectorAll('.topic-row').forEach(row => {
            row.style.display = row.innerText.toLowerCase().includes(q) ? '' : 'none';
        });
    }

    function setTopicStatusBadge(row, status) {
        if (!row) return;
        const cell = row.children[5];
        if (!cell) return;
        if (status === 'PUBLISHED' || status === 'APPROVED') {
            cell.innerHTML = '<span class="status-badge status-approved">ĐÃ DUYỆT</span>';
        } else if (status === 'REJECTED') {
            cell.innerHTML = '<span class="status-badge status-danger">TỪ CHỐI</span>';
        } else {
            cell.innerHTML = '<span class="status-badge status-pending">CHỜ DUYỆT</span>';
        }
        const actions = row.children[6];
        if (actions) {
            actions.querySelectorAll('button[onclick*="approveTopicAjax"], button[onclick*="rejectTopicSweetAlert"]').forEach(b => b.remove());
        }
    }

    async function approveTopicAjax(topicId, btn) {
        btn.disabled = true;
        try {
            const data = await EnterpriseUI.postForm(
                '${pageContext.request.contextPath}/admin/topics/' + topicId + '/status-ajax',
                { status: 'PUBLISHED' }
            );
            if (data.success) {
                EnterpriseUI.toast('success', 'Đã duyệt', 'Đề tài đã được chấp nhận và công bố cho sinh viên đăng ký.');
                setTopicStatusBadge(btn.closest('tr'), 'PUBLISHED');
            } else {
                Swal.fire({ icon: 'error', title: 'Lỗi', text: data.message || 'Không thể duyệt', confirmButtonColor: '#006da8' });
            }
        } catch (e) {
            Swal.fire({ icon: 'error', title: 'Lỗi mạng', text: e.message, confirmButtonColor: '#006da8' });
        } finally {
            btn.disabled = false;
            if (typeof lucide !== 'undefined') lucide.createIcons();
        }
    }

    async function rejectTopicSweetAlert(topicId, topicTitle) {
        const result = await Swal.fire({
            title: 'Từ chối đề xuất?',
            text: 'Lý do từ chối "' + topicTitle + '":',
            input: 'textarea',
            inputPlaceholder: 'Nhập lý do từ chối để thông báo cho GVHD...',
            showCancelButton: true,
            confirmButtonColor: '#dc2626',
            cancelButtonColor: '#64748b',
            confirmButtonText: 'Từ chối đề tài',
            cancelButtonText: 'Đóng',
            customClass: { popup: 'rounded-3xl shadow-2xl' },
            inputValidator: (value) => {
                if (!value || !value.trim()) return 'Bắt buộc nhập lý do!';
            }
        });
        if (!result.isConfirmed) return;
        try {
            const data = await EnterpriseUI.postForm(
                '${pageContext.request.contextPath}/admin/topics/' + topicId + '/status-ajax',
                { status: 'REJECTED', rejectionReason: result.value.trim() }
            );
            if (data.success) {
                await EnterpriseUI.toast('success', 'Đã từ chối', data.message);
                const row = document.querySelector('button[onclick*="approveTopicAjax(\'' + topicId + '\'"]')?.closest('tr');
                setTopicStatusBadge(row, 'REJECTED');
            } else {
                Swal.fire({ icon: 'error', title: 'Lỗi', text: data.message || 'Không thể từ chối', confirmButtonColor: '#006da8' });
            }
        } catch (e) {
            Swal.fire({ icon: 'error', title: 'Lỗi mạng', text: e.message, confirmButtonColor: '#006da8' });
        }
    }

    function confirmDeleteTopic(event, title) {
        event.preventDefault();
        const form = event.target;
        Swal.fire({
            title: 'Xóa đề tài?',
            text: 'Bạn có chắc chắn muốn xóa đề tài "' + title + '" không?',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#dc2626',
            cancelButtonColor: '#64748b',
            confirmButtonText: 'Xóa vĩnh viễn',
            cancelButtonText: 'Hủy',
            customClass: { popup: 'rounded-3xl shadow-xl' }
        }).then((result) => {
            if (result.isConfirmed) form.submit();
        });
        return false;
    }
</script>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle" value="Duyệt đăng ký đề tài" />
<c:set var="pageHeading" value="Phê duyệt đăng ký đề tài của nhóm SV" />
<c:set var="pageSubheading" value="Xem xét và phê duyệt đề tài đăng ký của các nhóm sinh viên trước khi phân vào Hội đồng" />
<c:set var="activeMenu" value="registrations" />

<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/sidebar.jsp" />

<div class="app-main">
    <jsp:include page="../common/navbar.jsp" />

    <main class="app-content space-y-6">
        <!-- Top Toolbar -->
        <div class="bg-white p-5 rounded-3xl border border-slate-200 shadow-sm flex flex-col sm:flex-row sm:items-center justify-between gap-4">
            <div class="flex items-center gap-3">
                <div class="w-10 h-10 rounded-2xl bg-sky-50 text-sky-700 flex items-center justify-center border border-sky-100 shadow-xs">
                    <i data-lucide="clipboard-check" class="w-5 h-5"></i>
                </div>
                <div>
                    <h2 class="text-base font-bold text-slate-900 leading-tight">Yêu cầu đăng ký đề tài</h2>
                    <p class="text-xs text-slate-500 mt-0.5">Tổng số <strong class="text-sky-700">${fn:length(registrations)}</strong> lượt đăng ký cần xem xét</p>
                </div>
            </div>
            <div class="relative w-full sm:w-80">
                <i data-lucide="search" class="w-4 h-4 text-slate-400 absolute left-3.5 top-1/2 -translate-y-1/2"></i>
                <input type="text" id="regSearchInput" onkeyup="filterRegsTable()" placeholder="Tìm theo tên nhóm, mã đề tài, MSSV..." 
                       class="w-full pl-10 pr-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs font-medium focus:bg-white focus:ring-2 focus:ring-sky-500 focus:outline-none transition-all">
            </div>
        </div>

        <!-- Registrations Table Shell -->
        <div class="table-shell">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse datatable-pagination" id="regsTable" data-page-size="10">
                    <thead>
                        <tr>
                            <th class="whitespace-nowrap">Nhóm Sinh viên</th>
                            <th class="min-w-[220px]">Đề tài Đăng ký</th>
                            <th class="whitespace-nowrap">Thời gian gửi</th>
                            <th class="min-w-[180px]">Ghi chú từ Nhóm</th>
                            <th class="whitespace-nowrap">Người duyệt</th>
                            <th class="whitespace-nowrap">Trạng thái</th>
                            <th class="text-right whitespace-nowrap">Phê duyệt / Thao tác</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-100 text-xs">
                        <c:forEach var="reg" items="${registrations}">
                            <tr class="hover:bg-slate-50/80 transition-colors reg-row">
                                <td class="align-middle">
                                    <div class="font-bold text-slate-900 text-xs">${reg.group.name}</div>
                                    <div class="flex items-center gap-1.5 text-[11px] text-amber-700 font-bold mt-1">
                                        <i data-lucide="crown" class="w-3.5 h-3.5 text-amber-500"></i>
                                        <span>${reg.group.leader.user.fullName} (${reg.group.leader.studentCode})</span>
                                    </div>
                                </td>
                                <td class="align-middle">
                                    <span class="code-tag">${reg.topic.code}</span>
                                    <div class="font-bold text-slate-800 line-clamp-1 mt-1">${reg.topic.title}</div>
                                    <div class="text-[11px] text-slate-500 mt-0.5">${reg.topic.department.name}</div>
                                </td>
                                <td class="align-middle text-slate-500 font-medium whitespace-nowrap">
                                    ${reg.createdAt}
                                </td>
                                <td class="align-middle">
                                    <div class="text-slate-600 italic line-clamp-2">${reg.note != null ? reg.note : 'Không có ghi chú'}</div>
                                    <c:if test="${not empty reg.rejectionReason}">
                                        <div class="mt-1 text-rose-700 text-[11px] font-semibold bg-rose-50 p-2 rounded-xl border border-rose-200">
                                            <strong>Lý do từ chối:</strong> ${reg.rejectionReason}
                                        </div>
                                    </c:if>
                                </td>
                                <td class="align-middle text-slate-600 font-medium whitespace-nowrap">
                                    ${reg.approvedBy != null ? reg.approvedBy.fullName : '<span class="text-slate-400">Chưa duyệt</span>'}
                                </td>
                                <td class="align-middle whitespace-nowrap">
                                    <c:choose>
                                        <c:when test="${reg.status == 'APPROVED'}">
                                            <span class="status-badge status-approved">ĐÃ DUYỆT</span>
                                        </c:when>
                                        <c:when test="${reg.status == 'PENDING'}">
                                            <span class="status-badge status-pending">CHỜ DUYỆT</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge status-danger">TỪ CHỐI</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="align-middle text-right whitespace-nowrap">
                                    <div class="inline-flex items-center gap-1.5">
                                        <button type="button" onclick="approveRegistrationAjax('${reg.id}', this)"
                                                class="btn-ui bg-emerald-600 hover:bg-emerald-700 text-white text-[11px] py-1.5 px-3 rounded-lg shadow-xs"
                                                title="Chấp thuận đăng ký">
                                            <i data-lucide="check" class="w-3.5 h-3.5"></i> Duyệt
                                        </button>
                                        <button type="button" onclick="openRejectRegistrationModal('${reg.id}', '${reg.group.name}', this)"
                                                class="btn-ui bg-rose-50 hover:bg-rose-600 text-rose-700 hover:text-white border border-rose-200 text-[11px] py-1.5 px-3 rounded-lg transition-colors"
                                                title="Từ chối đăng ký kèm lý do">
                                            <i data-lucide="x" class="w-3.5 h-3.5"></i> Từ chối
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty registrations}">
                            <tr class="table-empty-row">
                                <td colspan="7">
                                    <div class="empty-state py-8">
                                        <div class="empty-state-icon-wrap w-12 h-12 mb-2">
                                            <i data-lucide="clipboard-x" class="w-6 h-6 opacity-40"></i>
                                        </div>
                                        <div class="empty-state-desc text-xs mb-0">Chưa có yêu cầu đăng ký đề tài nào</div>
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
    function filterRegsTable() {
        const input = document.getElementById('regSearchInput').value.toLowerCase();
        document.querySelectorAll('.reg-row').forEach(row => {
            row.style.display = row.innerText.toLowerCase().includes(input) ? '' : 'none';
        });
    }

    function updateRegStatusBadge(row, status) {
        if (!row) return;
        const cell = row.children[5];
        if (!cell) return;
        if (status === 'APPROVED') {
            cell.innerHTML = '<span class="status-badge status-approved">ĐÃ DUYỆT</span>';
        } else if (status === 'REJECTED') {
            cell.innerHTML = '<span class="status-badge status-danger">TỪ CHỐI</span>';
        }
    }

    async function approveRegistrationAjax(regId, btn) {
        btn.disabled = true;
        try {
            const data = await EnterpriseUI.postForm(
                '${pageContext.request.contextPath}/admin/registrations/' + regId + '/status-ajax',
                { status: 'APPROVED' }
            );
            if (data.success) {
                EnterpriseUI.toast('success', 'Đã duyệt', data.message);
                updateRegStatusBadge(btn.closest('tr'), 'APPROVED');
            } else {
                Swal.fire({ icon: 'error', title: 'Lỗi', text: data.message, confirmButtonColor: '#006da8' });
            }
        } catch (e) {
            Swal.fire({ icon: 'error', title: 'Lỗi mạng', text: e.message, confirmButtonColor: '#006da8' });
        } finally {
            btn.disabled = false;
            if (typeof lucide !== 'undefined') lucide.createIcons();
        }
    }

    async function openRejectRegistrationModal(regId, groupName, btn) {
        const result = await Swal.fire({
            title: 'Từ chối đăng ký đề tài?',
            text: 'Vui lòng nhập lý do từ chối cho nhóm "' + groupName + '":',
            input: 'textarea',
            inputPlaceholder: 'Nhập lý do chi tiết để sinh viên nắm thông tin...',
            showCancelButton: true,
            confirmButtonText: 'Xác nhận từ chối',
            cancelButtonText: 'Hủy bỏ',
            confirmButtonColor: '#dc2626',
            cancelButtonColor: '#64748b',
            customClass: { popup: 'rounded-3xl shadow-2xl' },
            inputValidator: (value) => {
                if (!value || !value.trim()) return 'Bắt buộc phải nhập lý do từ chối!';
            }
        });
        if (!result.isConfirmed) return;

        try {
            const data = await EnterpriseUI.postForm(
                '${pageContext.request.contextPath}/admin/registrations/' + regId + '/status-ajax',
                { status: 'REJECTED', rejectionReason: result.value.trim() }
            );
            if (data.success) {
                EnterpriseUI.toast('success', 'Đã từ chối', data.message);
                const row = btn ? btn.closest('tr') : document.querySelector('.reg-row');
                updateRegStatusBadge(row, 'REJECTED');
                if (row) {
                    const noteCell = row.children[3];
                    if (noteCell) {
                        noteCell.insertAdjacentHTML('beforeend',
                            '<div class="mt-1 text-rose-700 text-[11px] font-semibold bg-rose-50 p-2 rounded-xl border border-rose-200"><strong>Lý do từ chối:</strong> ' +
                            result.value.trim().replace(/</g, '&lt;') + '</div>');
                    }
                }
            } else {
                Swal.fire({ icon: 'error', title: 'Lỗi', text: data.message, confirmButtonColor: '#006da8' });
            }
        } catch (e) {
            Swal.fire({ icon: 'error', title: 'Lỗi mạng', text: e.message, confirmButtonColor: '#006da8' });
        }
    }
</script>

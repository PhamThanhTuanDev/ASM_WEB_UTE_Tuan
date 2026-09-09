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
        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-xs flex flex-col sm:flex-row sm:items-center justify-between gap-4">
            <div>
                <h2 class="text-lg font-bold text-slate-900 flex items-center gap-2">
                    <i data-lucide="clipboard-check" class="w-5 h-5 text-blue-600"></i> Danh sách đăng ký đề tài
                </h2>
                <p class="text-xs text-slate-500 mt-0.5">Tổng số <strong class="text-blue-600">${fn:length(registrations)}</strong> yêu cầu đăng ký trong hệ thống</p>
            </div>
            <div class="relative w-full sm:w-72">
                <i data-lucide="search" class="w-4 h-4 text-slate-400 absolute left-3.5 top-1/2 -translate-y-1/2"></i>
                <input type="text" id="regSearchInput" onkeyup="filterRegsTable()" placeholder="Tìm theo tên nhóm, mã đề tài, MSSV..." 
                       class="w-full pl-10 pr-3.5 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs focus:bg-white focus:ring-2 focus:ring-blue-500 focus:outline-none">
            </div>
        </div>

        <!-- Registrations Table -->
        <div class="bg-white rounded-2xl border border-slate-200 shadow-xs overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse" id="regsTable">
                    <thead>
                        <tr class="bg-slate-50/80 border-b border-slate-200 text-[11px] font-bold uppercase tracking-wider text-slate-500">
                            <th class="px-5 py-3.5">Nhóm Sinh viên</th>
                            <th class="px-5 py-3.5">Đề tài Đăng ký</th>
                            <th class="px-5 py-3.5">Thời gian gửi</th>
                            <th class="px-5 py-3.5">Ghi chú từ Nhóm</th>
                            <th class="px-5 py-3.5">Người duyệt</th>
                            <th class="px-5 py-3.5">Trạng thái</th>
                            <th class="px-5 py-3.5 text-right">Phê duyệt / Thao tác</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-100 text-xs">
                        <c:forEach var="reg" items="${registrations}">
                            <tr class="hover:bg-slate-50/80 transition-colors reg-row">
                                <td class="px-5 py-4">
                                    <div class="font-bold text-slate-900">${reg.group.name}</div>
                                    <div class="flex items-center gap-1.5 text-[11px] text-amber-600 font-semibold mt-0.5">
                                        <i data-lucide="crown" class="w-3.5 h-3.5 text-amber-500"></i>
                                        <span>Trưởng nhóm: ${reg.group.leader.user.fullName} (${reg.group.leader.studentCode})</span>
                                    </div>
                                </td>
                                <td class="px-5 py-4 max-w-xs">
                                    <span class="px-2 py-0.5 rounded font-mono font-bold text-[10px] bg-blue-50 text-blue-700 border border-blue-200">${reg.topic.code}</span>
                                    <div class="font-bold text-slate-800 line-clamp-1 mt-1">${reg.topic.title}</div>
                                    <div class="text-[11px] text-slate-500">Khoa: ${reg.topic.department.name}</div>
                                </td>
                                <td class="px-5 py-4 text-slate-500 font-medium whitespace-nowrap">
                                    ${reg.createdAt}
                                </td>
                                <td class="px-5 py-4 max-w-xs">
                                    <div class="text-slate-600 italic line-clamp-2">${reg.note != null ? reg.note : 'Không có ghi chú'}</div>
                                    <c:if test="${not empty reg.rejectionReason}">
                                        <div class="mt-1 text-rose-600 text-[11px] font-semibold bg-rose-50 p-1.5 rounded-lg border border-rose-200">
                                            <strong>Lý do từ chối:</strong> ${reg.rejectionReason}
                                        </div>
                                    </c:if>
                                </td>
                                <td class="px-5 py-4 text-slate-600 font-medium">
                                    ${reg.approvedBy != null ? reg.approvedBy.fullName : '<span class="text-slate-400">Chưa duyệt</span>'}
                                </td>
                                <td class="px-5 py-4 whitespace-nowrap">
                                    <c:choose>
                                        <c:when test="${reg.status == 'APPROVED'}">
                                            <span class="px-2.5 py-1 rounded-lg text-xs font-bold bg-emerald-100 text-emerald-800 border border-emerald-200">
                                                ĐÃ DUYỆT (APPROVED)
                                            </span>
                                        </c:when>
                                        <c:when test="${reg.status == 'PENDING'}">
                                            <span class="px-2.5 py-1 rounded-lg text-xs font-bold bg-amber-100 text-amber-800 border border-amber-200">
                                                CHỜ DUYỆT (PENDING)
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="px-2.5 py-1 rounded-lg text-xs font-bold bg-rose-100 text-rose-800 border border-rose-200">
                                                TỪ CHỐI (REJECTED)
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="px-5 py-4 text-right whitespace-nowrap">
                                    <div class="inline-flex items-center gap-1.5">
                                        <button type="button" onclick="approveRegistrationAjax('${reg.id}', this)"
                                                class="inline-flex items-center gap-1 px-2.5 py-1.5 bg-emerald-600 hover:bg-emerald-700 text-white font-bold rounded-lg text-xs shadow-xs transition-colors"
                                                title="Chấp thuận đăng ký">
                                            <i data-lucide="check" class="w-3.5 h-3.5"></i> Duyệt
                                        </button>
                                        <button type="button" onclick="openRejectRegistrationModal('${reg.id}', '${reg.group.name}', this)"
                                                class="inline-flex items-center gap-1 px-2.5 py-1.5 bg-rose-50 hover:bg-rose-600 text-rose-700 hover:text-white border border-rose-200 font-bold rounded-lg text-xs transition-colors"
                                                title="Từ chối đăng ký kèm lý do">
                                            <i data-lucide="x" class="w-3.5 h-3.5"></i> Từ chối
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

<jsp:include page="../common/footer.jsp" />

<!-- SweetAlert2 + Fetch API: Approve / Reject without full page reload -->
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
            cell.innerHTML = '<span class="px-2.5 py-1 rounded-lg text-xs font-bold bg-emerald-100 text-emerald-800 border border-emerald-200">ĐÃ DUYỆT (APPROVED)</span>';
        } else if (status === 'REJECTED') {
            cell.innerHTML = '<span class="px-2.5 py-1 rounded-lg text-xs font-bold bg-rose-100 text-rose-800 border border-rose-200">TỪ CHỐI (REJECTED)</span>';
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
                Swal.fire({ icon: 'error', title: 'Lỗi', text: data.message, confirmButtonColor: '#2563eb' });
            }
        } catch (e) {
            Swal.fire({ icon: 'error', title: 'Lỗi mạng', text: e.message, confirmButtonColor: '#2563eb' });
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
            inputPlaceholder: 'Nhập lý do chi tiết...',
            showCancelButton: true,
            confirmButtonText: 'Xác nhận từ chối',
            cancelButtonText: 'Hủy bỏ',
            confirmButtonColor: '#e11d48',
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
                updateRegStatusBadge((btn || document.activeElement)?.closest?.('tr') || document.querySelector('.reg-row'), 'REJECTED');
                const row = btn ? btn.closest('tr') : null;
                if (row) {
                    const noteCell = row.children[3];
                    if (noteCell) {
                        noteCell.insertAdjacentHTML('beforeend',
                            '<div class="mt-1 text-rose-600 text-[11px] font-semibold bg-rose-50 p-1.5 rounded-lg border border-rose-200"><strong>Lý do từ chối:</strong> ' +
                            result.value.trim().replace(/</g, '&lt;') + '</div>');
                    }
                }
            } else {
                Swal.fire({ icon: 'error', title: 'Lỗi', text: data.message, confirmButtonColor: '#2563eb' });
            }
        } catch (e) {
            Swal.fire({ icon: 'error', title: 'Lỗi mạng', text: e.message, confirmButtonColor: '#2563eb' });
        }
    }
</script>

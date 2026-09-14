<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle" value="Quản lý thông báo khoa" />
<c:set var="pageHeading" value="Quản lý &amp; đăng thông báo khoa CNTT" />
<c:set var="pageSubheading" value="Đăng thông báo theo từng đối tượng: Toàn trường, Sinh viên, hoặc Giảng viên" />
<c:set var="activeMenu" value="notifications" />

<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/sidebar.jsp" />

<div class="app-main">
    <jsp:include page="../common/navbar.jsp" />

    <main class="app-content space-y-6">
        <!-- Top Toolbar -->
        <div class="bg-white p-5 rounded-3xl border border-slate-200 shadow-sm flex flex-col sm:flex-row sm:items-center justify-between gap-4">
            <div class="flex items-center gap-3">
                <div class="w-10 h-10 rounded-2xl bg-sky-50 text-sky-700 flex items-center justify-center border border-sky-100 shadow-xs">
                    <i data-lucide="bell" class="w-5 h-5"></i>
                </div>
                <div>
                    <h2 class="text-base font-bold text-slate-900 leading-tight">Danh sách thông báo khoa</h2>
                    <p class="text-xs text-slate-500 mt-0.5">Tổng số <strong class="text-sky-700">${fn:length(notifications)}</strong> bản tin trong hệ thống</p>
                </div>
            </div>
            <button class="btn-ui btn-ui-primary text-xs py-2.5 px-4 shadow-sm shrink-0" 
                    data-bs-toggle="modal" data-bs-target="#createNotificationModal">
                <i data-lucide="plus-circle" class="w-4 h-4"></i> Đăng thông báo mới
            </button>
        </div>

        <!-- Notifications Table Shell -->
        <div class="table-shell">
            <table class="w-full text-left border-collapse datatable-pagination" id="adminNotificationsTable" data-page-size="10">
                <thead>
                    <tr>
                        <th class="w-[38%]">Tiêu đề Thông báo</th>
                        <th class="w-[14%]">Đối tượng nhận</th>
                        <th class="w-[18%]">Người đăng</th>
                        <th class="w-[12%] whitespace-nowrap">Thời gian tạo</th>
                        <th class="w-[10%] text-center whitespace-nowrap">Trạng thái</th>
                        <th class="text-right w-[8%] whitespace-nowrap">Thao tác</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-100 text-xs">
                    <c:forEach var="n" items="${notifications}">
                        <tr id="notification-${n.id}" data-notification-id="${n.id}" class="hover:bg-slate-50/80 transition-colors">
                            <td class="align-top">
                                <div class="font-bold text-slate-900 leading-snug">${n.title}</div>
                                <p class="text-[11px] text-slate-500 line-clamp-1 mt-1 leading-relaxed">${n.content}</p>
                            </td>

                            <td class="align-top whitespace-nowrap">
                                <span class="status-badge ${n.type == 'ALL' ? 'status-info' : n.type == 'STUDENT' ? 'status-approved' : 'status-pending'}">
                                    <c:choose>
                                        <c:when test="${n.type == 'ALL'}">Toàn trường</c:when>
                                        <c:when test="${n.type == 'STUDENT'}">Sinh viên</c:when>
                                        <c:otherwise>Giảng viên</c:otherwise>
                                    </c:choose>
                                </span>
                            </td>

                            <td class="align-top font-semibold text-slate-800">
                                ${n.createdBy != null ? n.createdBy.fullName : 'Ban Chủ nhiệm Khoa'}
                            </td>

                            <td class="align-top text-slate-500 font-medium whitespace-nowrap">
                                ${n.createdAt}
                            </td>

                            <td class="align-top text-center whitespace-nowrap">
                                <span class="status-badge ${n.published ? 'status-approved' : 'status-neutral'}">
                                    ${n.published ? 'ĐÃ CÔNG BỐ' : 'BẢN NHÁP'}
                                </span>
                            </td>

                            <td class="align-top text-right whitespace-nowrap">
                                <div class="inline-flex items-center gap-1.5 justify-end">
                                    <form method="post" action="${pageContext.request.contextPath}/admin/notifications/${n.id}/toggle" class="inline">
                                        <button type="submit" class="p-1.5 bg-slate-100 hover:bg-slate-200 text-slate-600 rounded-lg transition-colors" title="Ẩn / Hiện thông báo">
                                            <i data-lucide="${n.published ? 'eye-off' : 'eye'}" class="w-4 h-4"></i>
                                        </button>
                                    </form>
                                    <form method="post" action="${pageContext.request.contextPath}/admin/notifications/${n.id}/delete" class="inline" onsubmit="return confirmDeleteNotif(event, '${n.title}');">
                                        <button type="submit" class="p-1.5 text-slate-400 hover:text-rose-600 hover:bg-rose-50 rounded-lg transition-colors" title="Xóa thông báo">
                                            <i data-lucide="trash-2" class="w-4 h-4"></i>
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty notifications}">
                        <tr class="table-empty-row">
                            <td colspan="6">
                                <div class="empty-state py-8">
                                    <div class="empty-state-icon-wrap w-12 h-12 mb-2">
                                        <i data-lucide="bell-off" class="w-6 h-6 opacity-40"></i>
                                    </div>
                                    <div class="empty-state-desc text-xs mb-0">Chưa có thông báo nào trong hệ thống</div>
                                </div>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </main>

    <!-- Modal Đăng Thông Báo Mới -->
    <div class="modal fade" id="createNotificationModal" tabindex="-1">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content rounded-3xl border-0 shadow-2xl overflow-hidden">
                <form method="post" action="${pageContext.request.contextPath}/admin/notifications/save">
                    <div class="bg-gradient-to-r from-sky-700 to-blue-900 px-6 py-4 text-white flex justify-between items-center">
                        <h5 class="text-base font-bold flex items-center gap-2">
                            <i data-lucide="bell-plus" class="w-5 h-5 text-sky-300"></i> Soạn &amp; Đăng Thông Báo Mới
                        </h5>
                        <button type="button" class="text-white/80 hover:text-white p-1" data-bs-dismiss="modal">
                            <i data-lucide="x" class="w-5 h-5"></i>
                        </button>
                    </div>

                    <div class="p-6 space-y-4">
                        <div>
                            <label class="block text-xs font-bold text-slate-700 mb-1.5">Tiêu đề thông báo <span class="text-rose-500">*</span></label>
                            <input type="text" name="title" class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs font-semibold focus:bg-white focus:ring-2 focus:ring-sky-500 focus:outline-none" placeholder="Nhập tiêu đề thông báo..." required>
                        </div>

                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                            <div>
                                <label class="block text-xs font-bold text-slate-700 mb-1.5">Đối tượng nhận thông báo <span class="text-rose-500">*</span></label>
                                <select name="type" class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs font-semibold focus:bg-white focus:ring-2 focus:ring-sky-500 focus:outline-none" required>
                                    <option value="ALL">Tất cả (Toàn trường)</option>
                                    <option value="STUDENT">Chỉ Sinh viên (STUDENT)</option>
                                    <option value="LECTURER">Chỉ Giảng viên (LECTURER)</option>
                                </select>
                            </div>
                            <div>
                                <label class="block text-xs font-bold text-slate-700 mb-1.5">Trạng thái xuất bản</label>
                                <select name="published" class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs font-semibold focus:bg-white focus:ring-2 focus:ring-sky-500 focus:outline-none">
                                    <option value="true">Công bố công khai ngay</option>
                                    <option value="false">Lưu bản nháp</option>
                                </select>
                            </div>
                        </div>

                        <div>
                            <label class="block text-xs font-bold text-slate-700 mb-1.5">Nội dung chi tiết <span class="text-rose-500">*</span></label>
                            <textarea name="content" rows="6" class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs focus:bg-white focus:ring-2 focus:ring-sky-500 focus:outline-none" placeholder="Nhập nội dung thông báo đầy đủ..." required></textarea>
                        </div>
                    </div>

                    <div class="bg-slate-50 px-6 py-4 border-t border-slate-100 flex justify-end gap-3">
                        <button type="button" class="btn-ui btn-ui-outline text-xs" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn-ui btn-ui-primary text-xs">
                            Đăng Thông Báo
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <jsp:include page="../common/footer.jsp" />

<script>
    function confirmDeleteNotif(event, title) {
        event.preventDefault();
        const form = event.target;
        Swal.fire({
            title: 'Xóa thông báo?',
            text: 'Bạn có chắc muốn xóa thông báo "' + title + '"?',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#dc2626',
            cancelButtonColor: '#64748b',
            confirmButtonText: 'Xóa vĩnh viễn',
            cancelButtonText: 'Hủy',
            customClass: {
                popup: 'rounded-3xl shadow-xl'
            }
        }).then((result) => {
            if (result.isConfirmed) {
                form.submit();
            }
        });
        return false;
    }
</script>
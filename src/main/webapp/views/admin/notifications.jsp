<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle" value="Quản lý thông báo khoa" />
<c:set var="pageHeading" value="Quản lý & đăng thông báo khoa CNTT" />
<c:set var="pageSubheading" value="Đăng thông báo theo từng đối tượng: Toàn trường, Sinh viên, hoặc Giảng viên" />
<c:set var="activeMenu" value="notifications" />

<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/sidebar.jsp" />

<div class="app-main">
    <jsp:include page="../common/navbar.jsp" />

    <main class="app-content space-y-6">
        <!-- Top Toolbar -->
        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-xs flex flex-col sm:flex-row sm:items-center justify-between gap-4">
            <div>
                <h2 class="text-lg font-bold text-slate-900 flex items-center gap-2">
                    <i data-lucide="bell" class="w-5 h-5 text-blue-600"></i> Danh sách thông báo khoa
                </h2>
                <p class="text-xs text-slate-500 mt-0.5">Tổng số <strong class="text-blue-600">${fn:length(notifications)}</strong> bản tin trong hệ thống</p>
            </div>
            <button class="inline-flex items-center gap-2 px-4 py-2.5 bg-blue-600 hover:bg-blue-700 text-white text-xs font-bold rounded-xl shadow-xs hover:shadow-md transition-all duration-200 shrink-0" 
                    data-bs-toggle="modal" data-bs-target="#createNotificationModal">
                <i data-lucide="plus-circle" class="w-4 h-4"></i> Đăng thông báo mới
            </button>
        </div>

        <!-- Notifications Table (Cân đối tỷ lệ 100%) -->
        <div class="bg-white rounded-2xl border border-slate-200 shadow-xs overflow-hidden">
            <table class="w-full text-left border-collapse" id="adminNotificationsTable">
                <thead>
                    <tr class="bg-slate-50/80 border-b border-slate-200 text-[11px] font-bold uppercase tracking-wider text-slate-500">
                        <th class="px-4 py-3.5 w-[38%]">Tiêu đề Thông báo</th>
                        <th class="px-4 py-3.5 w-[14%]">Đối tượng nhận</th>
                        <th class="px-4 py-3.5 w-[18%]">Người đăng</th>
                        <th class="px-4 py-3.5 w-[12%]">Thời gian tạo</th>
                        <th class="px-4 py-3.5 w-[10%] text-center">Trạng thái</th>
                        <th class="px-4 py-3.5 text-right w-[8%]">Thao tác</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-100 text-xs">
                    <c:forEach var="n" items="${notifications}">
                        <tr class="hover:bg-slate-50/80 transition-colors">
                            <!-- Tiêu đề & Nội dung vắn tắt -->
                            <td class="px-4 py-4 align-top w-[38%]">
                                <div class="font-bold text-slate-900 leading-snug break-words">${n.title}</div>
                                <p class="text-[11px] text-slate-500 line-clamp-1 mt-1 leading-relaxed break-words">${n.content}</p>
                            </td>

                            <!-- Đối tượng nhận -->
                            <td class="px-4 py-4 align-top w-[14%] whitespace-nowrap">
                                <span class="px-2.5 py-1 rounded-lg text-[11px] font-bold inline-block ${n.type == 'ALL' ? 'bg-blue-100 text-blue-800 border border-blue-200' : n.type == 'STUDENT' ? 'bg-emerald-100 text-emerald-800 border border-emerald-200' : 'bg-amber-100 text-amber-800 border border-amber-200'}">
                                    <c:choose>
                                        <c:when test="${n.type == 'ALL'}">Toàn trường</c:when>
                                        <c:when test="${n.type == 'STUDENT'}">Sinh viên</c:when>
                                        <c:otherwise>Giảng viên</c:otherwise>
                                    </c:choose>
                                </span>
                            </td>

                            <!-- Người đăng -->
                            <td class="px-4 py-4 align-top w-[18%] font-semibold text-slate-800 break-words leading-snug">
                                ${n.createdBy != null ? n.createdBy.fullName : 'Ban Chủ nhiệm Khoa'}
                            </td>

                            <!-- Thời gian -->
                            <td class="px-4 py-4 align-top w-[12%] text-slate-500 font-medium whitespace-nowrap">
                                ${n.createdAt}
                            </td>

                            <!-- Trạng thái -->
                            <td class="px-4 py-4 align-top w-[10%] text-center whitespace-nowrap">
                                <span class="px-2.5 py-1 rounded-lg text-[10px] font-bold inline-block ${n.published ? 'bg-emerald-100 text-emerald-800 border border-emerald-200' : 'bg-slate-100 text-slate-600 border border-slate-200'}">
                                    ${n.published ? 'ĐÃ CÔNG BỐ' : 'BẢN NHÁP'}
                                </span>
                            </td>

                            <!-- Thao tác -->
                            <td class="px-4 py-4 align-top text-right w-[8%] whitespace-nowrap">
                                <div class="inline-flex items-center gap-1 justify-end">
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
                </tbody>
            </table>
        </div>
    </main>

    <!-- Modal Đăng Thông Báo Mới -->
    <div class="modal fade" id="createNotificationModal" tabindex="-1">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content rounded-3xl border-0 shadow-2xl overflow-hidden">
                <form method="post" action="${pageContext.request.contextPath}/admin/notifications/save">
                    <div class="bg-gradient-to-r from-blue-600 to-indigo-700 px-6 py-4 text-white flex justify-between items-center">
                        <h5 class="text-base font-bold flex items-center gap-2">
                            <i data-lucide="bell-plus" class="w-5 h-5"></i> Soạn & Đăng Thông Báo Mới
                        </h5>
                        <button type="button" class="text-white/80 hover:text-white p-1" data-bs-dismiss="modal">
                            <i data-lucide="x" class="w-5 h-5"></i>
                        </button>
                    </div>

                    <div class="p-6 space-y-4">
                        <div>
                            <label class="block text-xs font-bold text-slate-700 mb-1">Tiêu đề thông báo <span class="text-rose-500">*</span></label>
                            <input type="text" name="title" class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs font-semibold focus:bg-white focus:ring-2 focus:ring-blue-500 focus:outline-none" placeholder="Nhập tiêu đề thông báo..." required>
                        </div>

                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                            <div>
                                <label class="block text-xs font-bold text-slate-700 mb-1">Đối tượng nhận thông báo <span class="text-rose-500">*</span></label>
                                <select name="type" class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs font-semibold focus:bg-white focus:ring-2 focus:ring-blue-500 focus:outline-none" required>
                                    <option value="ALL">Tất cả (Toàn trường)</option>
                                    <option value="STUDENT">Chỉ Sinh viên (STUDENT)</option>
                                    <option value="LECTURER">Chỉ Giảng viên (LECTURER)</option>
                                </select>
                            </div>
                            <div>
                                <label class="block text-xs font-bold text-slate-700 mb-1">Trạng thái xuất bản</label>
                                <select name="published" class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs font-semibold focus:bg-white focus:ring-2 focus:ring-blue-500 focus:outline-none">
                                    <option value="true">Công bố công khai ngay</option>
                                    <option value="false">Lưu bản nháp</option>
                                </select>
                            </div>
                        </div>

                        <div>
                            <label class="block text-xs font-bold text-slate-700 mb-1">Nội dung chi tiết <span class="text-rose-500">*</span></label>
                            <textarea name="content" rows="6" class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs focus:bg-white focus:ring-2 focus:ring-blue-500 focus:outline-none" placeholder="Nhập nội dung thông báo đầy đủ..." required></textarea>
                        </div>
                    </div>

                    <div class="bg-slate-50 px-6 py-4 border-t border-slate-100 flex justify-end gap-3">
                        <button type="button" class="px-4 py-2 bg-white border border-slate-200 text-slate-700 text-xs font-bold rounded-xl hover:bg-slate-100 transition-colors" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="px-5 py-2 bg-blue-600 hover:bg-blue-700 text-white text-xs font-bold rounded-xl shadow-xs hover:shadow-md transition-all">
                            Đăng Thông Báo
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <jsp:include page="../common/footer.jsp" />
</div>

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
                popup: 'rounded-2xl'
            }
        }).then((result) => {
            if (result.isConfirmed) {
                form.submit();
            }
        });
        return false;
    }
</script>
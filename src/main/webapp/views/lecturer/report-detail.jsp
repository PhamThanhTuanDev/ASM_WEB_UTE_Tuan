<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Xem và duyệt báo cáo" />
<c:set var="pageHeading" value="Chi tiết báo cáo sinh viên" />
<c:set var="pageSubheading" value="Kiểm tra báo cáo, điểm quá trình và quyết định duyệt" />
<c:set var="activeMenu" value="reports" />

<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/sidebar.jsp" />

<div class="app-main">
    <jsp:include page="../common/navbar.jsp" />

    <main class="app-content workspace-page space-y-6">
        <div class="flex items-center justify-between gap-3">
            <a href="${pageContext.request.contextPath}/lecturer/reports"
               class="btn-ui btn-ui-outline text-xs py-2 px-3.5 shadow-xs">
                <i data-lucide="arrow-left" class="w-4 h-4"></i> Danh sách báo cáo
            </a>
            <c:choose>
                <c:when test="${report.reviewStatus == 'APPROVED'}">
                    <span class="status-badge status-approved text-xs py-1.5 px-3">
                        <i data-lucide="badge-check" class="w-4 h-4"></i> ĐÃ DUYỆT
                    </span>
                </c:when>
                <c:when test="${report.reviewStatus == 'REJECTED'}">
                    <span class="status-badge status-danger text-xs py-1.5 px-3">
                        <i data-lucide="circle-x" class="w-4 h-4"></i> ĐÃ TỪ CHỐI
                    </span>
                </c:when>
                <c:otherwise>
                    <span class="status-badge status-pending text-xs py-1.5 px-3">
                        <i data-lucide="clock-3" class="w-4 h-4"></i> CHỜ DUYỆT
                    </span>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 items-start">
            <section class="space-y-6 min-w-0">
                <div class="bg-white rounded-3xl border border-slate-200 p-6 shadow-sm">
                    <div class="flex items-start justify-between gap-4 mb-2">
                        <div class="flex items-start gap-3 min-w-0">
                            <div class="w-12 h-12 rounded-2xl bg-rose-50 text-rose-600 flex items-center justify-center shrink-0 border border-rose-100 shadow-xs">
                                <i data-lucide="file-text" class="w-6 h-6"></i>
                            </div>
                            <div class="min-w-0">
                                <h2 class="text-base font-bold text-slate-900 break-words leading-snug">${report.fileName}</h2>
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/reports/download/${report.id}" download target="_blank"
                           class="btn-ui btn-ui-primary text-xs py-2 px-3 shrink-0 shadow-xs">
                            <i data-lucide="download" class="w-4 h-4"></i> Tải file
                        </a>
                    </div>

                    <div class="mt-4 rounded-2xl border border-sky-100 bg-sky-50/60 p-4">
                        <div class="text-[10px] font-extrabold uppercase tracking-wider text-sky-700 mb-2">Tiến trình nộp báo cáo</div>
                        <div class="grid grid-cols-2 gap-4 text-xs">
                            <div class="flex items-start gap-2">
                                <i data-lucide="upload-cloud" class="w-4 h-4 text-sky-600 mt-0.5 shrink-0"></i>
                                <div>
                                    <div class="text-slate-500 font-medium">Sinh viên nộp:</div>
                                    <div class="font-bold text-slate-800 mt-0.5">${report.submittedAt}</div>
                                </div>
                            </div>
                            <div class="flex items-start gap-2">
                                <i data-lucide="calendar-check-2" class="w-4 h-4 ${report.approved ? 'text-emerald-600' : 'text-amber-600'} mt-0.5 shrink-0"></i>
                                <div>
                                    <div class="text-slate-500 font-medium">GVHD xử lý:</div>
                                    <c:choose>
                                        <c:when test="${report.approved}">
                                            <div class="font-bold text-emerald-700 mt-0.5">${report.approvedAt}</div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="font-bold text-amber-700 mt-0.5">Đang chờ xử lý</div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="mt-3 rounded-2xl bg-slate-50 border border-slate-200/80 p-4">
                        <div class="flex items-center gap-2 text-xs font-bold text-slate-700 mb-1.5">
                            <i data-lucide="notebook-pen" class="w-4 h-4 text-sky-600"></i> Ghi chú của nhóm
                        </div>
                        <p class="text-xs text-slate-600 leading-relaxed">${not empty report.note ? report.note : 'Nhóm không có ghi chú.'}</p>
                    </div>
                </div>

                <div class="bg-white rounded-3xl border border-slate-200 p-6 shadow-sm">
                    <h3 class="text-sm font-bold text-slate-900 flex items-center gap-2 mb-4">
                        <i data-lucide="users" class="w-4 h-4 text-sky-600"></i> Thông tin nhóm thực hiện
                    </h3>
                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-3 text-xs">
                        <div class="rounded-2xl bg-slate-50 border border-slate-200/80 p-4">
                            <div class="text-slate-500 mb-1">Tên nhóm</div>
                            <div class="font-bold text-slate-900 text-sm">${report.topicRegistration.group.name}</div>
                        </div>
                        <div class="rounded-2xl bg-slate-50 border border-slate-200/80 p-4">
                            <div class="text-slate-500 mb-1">Nhóm trưởng</div>
                            <div class="font-bold text-slate-900">${report.submittedBy.user.fullName}</div>
                            <div class="text-slate-500 mt-0.5 font-mono">MSSV: ${report.submittedBy.studentCode}</div>
                        </div>
                        <div class="sm:col-span-2 rounded-2xl bg-sky-50 border border-sky-100 p-4">
                            <div class="text-sky-700 font-bold mb-1">Đề tài nghiên cứu:</div>
                            <div class="font-bold text-slate-900 leading-snug">[${report.topicRegistration.topic.code}] ${report.topicRegistration.topic.title}</div>
                        </div>
                    </div>
                </div>
            </section>

            <aside class="space-y-6 min-w-0">
                <div class="bg-white rounded-3xl border border-slate-200 p-6 shadow-sm">
                    <h3 class="text-sm font-bold text-slate-900 flex items-center gap-2 mb-4">
                        <i data-lucide="chart-no-axes-column-increasing" class="w-4 h-4 text-sky-600"></i> Điểm quá trình
                    </h3>
                    <c:choose>
                        <c:when test="${report.approved}">
                            <div class="text-[11px] font-bold text-slate-500 uppercase tracking-wider">Điểm số quá trình</div>
                            <div class="flex items-end gap-2 mb-3 mt-1">
                                <span class="text-4xl font-black text-sky-700">${evaluation.score}</span>
                                <span class="text-sm font-bold text-slate-400 mb-1">/ 10</span>
                            </div>
                            <div class="text-[11px] font-bold text-slate-500 uppercase tracking-wider mt-3">Nhận xét của GVHD</div>
                            <p class="text-xs text-slate-700 leading-relaxed mt-1 italic">"${not empty evaluation.comment ? evaluation.comment : 'Không có nhận xét điểm quá trình.'}"</p>
                            <div class="mt-4 flex items-center gap-2 rounded-2xl bg-emerald-50 border border-emerald-200 p-3 text-xs font-semibold text-emerald-800">
                                <i data-lucide="lock-keyhole" class="w-4 h-4 shrink-0"></i> Điểm đã khóa sau khi duyệt báo cáo.
                            </div>
                        </c:when>
                        <c:otherwise>
                            <form method="post" action="${pageContext.request.contextPath}/lecturer/reports/evaluation" class="space-y-3.5">
                                <input type="hidden" name="topicId" value="${report.topicRegistration.topic.id}">
                                <input type="hidden" name="reportId" value="${report.id}">
                                <div>
                                    <label class="block text-[11px] font-bold text-slate-700 mb-1.5">Điểm từ 0 đến 10 <span class="text-rose-500">*</span></label>
                                    <input type="number" name="score" min="0" max="10" step="0.1" required
                                           value="${not empty evaluation ? evaluation.score : ''}"
                                           placeholder="Nhập điểm quá trình"
                                           class="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 bg-slate-50 text-sm font-bold text-sky-700 focus:bg-white focus:ring-2 focus:ring-sky-500 focus:outline-none">
                                </div>
                                <div>
                                    <label class="block text-[11px] font-bold text-slate-700 mb-1.5">Nhận xét chi tiết</label>
                                    <textarea name="comment" rows="3" placeholder="Nhận xét quá trình thực hiện của nhóm..."
                                              class="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 bg-slate-50 text-xs focus:bg-white focus:ring-2 focus:ring-sky-500 focus:outline-none">${not empty evaluation ? evaluation.comment : ''}</textarea>
                                </div>
                                <button type="submit" class="btn-ui btn-ui-primary w-full text-xs py-2.5">
                                    <i data-lucide="save" class="w-3.5 h-3.5"></i> Lưu điểm quá trình
                                </button>
                            </form>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="bg-white rounded-3xl border border-slate-200 p-6 shadow-sm">
                    <h3 class="text-sm font-bold text-slate-900 flex items-center gap-2 mb-3">
                        <i data-lucide="shield-check" class="w-4 h-4 text-emerald-600"></i> Quyết định báo cáo
                    </h3>
                    <p class="text-xs text-slate-500 leading-relaxed mb-4">Chỉ báo cáo được duyệt và có điểm quá trình mới đủ điều kiện đưa nhóm vào hội đồng.</p>
                    <c:choose>
                        <c:when test="${report.approved}">
                            <div class="rounded-2xl bg-emerald-50 border border-emerald-200 p-4 text-xs font-semibold text-emerald-800">
                                Báo cáo đã duyệt thành công. Không thể thay đổi điểm quá trình hoặc quyết định này.
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="space-y-2">
                                <c:choose>
                                    <c:when test="${not empty evaluation}">
                                        <form method="post" action="${pageContext.request.contextPath}/lecturer/reports/${report.id}/approve">
                                            <button type="submit" class="btn-ui bg-emerald-600 hover:bg-emerald-700 text-white w-full py-3 text-xs font-bold rounded-xl shadow-xs">
                                                <i data-lucide="check" class="w-4 h-4"></i> Duyệt báo cáo này
                                            </button>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <button type="button" disabled class="btn-ui bg-slate-100 text-slate-400 w-full py-3 text-xs font-bold rounded-xl cursor-not-allowed border border-slate-200">
                                            <i data-lucide="lock" class="w-4 h-4"></i> Chấm điểm trước khi duyệt
                                        </button>
                                    </c:otherwise>
                                </c:choose>
                                <form method="post" action="${pageContext.request.contextPath}/lecturer/reports/${report.id}/reject" onsubmit="return confirmRejectReport(event);">
                                    <button type="submit" class="btn-ui bg-rose-50 hover:bg-rose-600 text-rose-700 hover:text-white border border-rose-200 w-full py-3 text-xs font-bold rounded-xl transition-colors">
                                        <i data-lucide="x" class="w-4 h-4"></i> Từ chối báo cáo
                                    </button>
                                </form>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </aside>
        </div>
    </main>

<jsp:include page="../common/footer.jsp" />
    <jsp:include page="../common/flash.jsp" />

<script>
    function confirmRejectReport(event) {
        event.preventDefault();
        const form = event.currentTarget;
        Swal.fire({
            icon: 'warning',
            title: 'Từ chối báo cáo?',
            text: 'Nhóm sẽ cần nộp lại báo cáo phù hợp.',
            showCancelButton: true,
            confirmButtonText: 'Từ chối báo cáo',
            cancelButtonText: 'Hủy',
            confirmButtonColor: '#dc2626',
            cancelButtonColor: '#64748b',
            customClass: { popup: 'rounded-3xl shadow-2xl' }
        }).then(function (result) {
            if (result.isConfirmed) form.submit();
        });
        return false;
    }
</script>

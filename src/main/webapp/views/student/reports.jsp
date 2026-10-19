<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set scope="request" var="pageTitle" value="Nộp báo cáo tiến độ" />
<c:set scope="request" var="pageHeading" value="Nộp báo cáo tiến độ / báo cáo cuối kỳ" />
<c:set scope="request" var="pageSubheading" value="Phân quyền: Việc nộp báo cáo chỉ được thực hiện duy nhất bởi tài khoản của Nhóm trưởng" />
<c:set scope="request" var="activeMenu" value="reports" />

<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/sidebar.jsp" />

<div class="app-main">
    <jsp:include page="../common/navbar.jsp" />

    <main class="app-content workspace-page space-y-6">
        <c:if test="${not empty errorMessage}">
            <div data-report-feedback="error" role="alert" class="p-4 rounded-xl border border-rose-200 bg-rose-50 text-rose-800 text-sm"><c:out value="${errorMessage}" /></div>
        </c:if>
        <c:if test="${not empty successMessage}">
            <div data-report-feedback="success" role="status" class="p-4 rounded-xl border border-emerald-200 bg-emerald-50 text-emerald-800 text-sm"><c:out value="${successMessage}" /></div>
        </c:if>
        <c:choose>
            <c:when test="${empty myGroup || empty registration || registration.status != 'APPROVED'}">
                <div class="glass-card rounded-3xl border border-slate-200/90 p-12 text-center shadow-sm max-w-2xl mx-auto space-y-4">
                    <div class="w-16 h-16 rounded-2xl bg-amber-500/10 text-amber-600 flex items-center justify-center mx-auto">
                        <i data-lucide="file-warning" class="w-8 h-8"></i>
                    </div>
                    <h4 class="text-base font-bold text-slate-800">Chưa đủ điều kiện nộp báo cáo</h4>
                    <p class="text-xs text-slate-500 max-w-md mx-auto leading-relaxed">
                        Nhóm của bạn chưa đăng ký đề tài hoặc đề tài đăng ký chưa được Giảng viên hướng dẫn và Khoa phê duyệt chính thức.
                    </p>
                    <a href="${pageContext.request.contextPath}/student/topics" class="btn-ui btn-ui-primary text-xs py-2 px-4 inline-flex mx-auto">
                        Tra cứu đề tài <i data-lucide="arrow-right" class="w-3.5 h-3.5"></i>
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="grid grid-cols-1 lg:grid-cols-12 gap-6">
                    <!-- Left: HTML5 / JS Drag và Drop Upload Zone (5 cols) -->
                    <div class="lg:col-span-5 space-y-6">
                        <div class="bg-white rounded-3xl border border-slate-200/90 p-6 shadow-xs space-y-5">
                            <div class="flex items-center gap-3 pb-4 border-b border-slate-100">
                                <div class="w-10 h-10 rounded-2xl bg-sky-50 text-sky-600 flex items-center justify-center shrink-0">
                                    <i data-lucide="cloud-upload" class="w-5 h-5"></i>
                                </div>
                                <div class="min-w-0">
                                    <h4 class="text-sm font-bold text-slate-900">Nộp file báo cáo đề tài</h4>
                                    <p class="text-[11px] text-slate-500 truncate">Đề tài: <strong><c:out value="${registration.topic.title}" /></strong></p>
                                </div>
                            </div>

                            <c:choose>
                                <c:when test="${isLeader}">
                                    <form method="post" action="${pageContext.request.contextPath}/student/reports/submit" id="reportUploadForm" class="space-y-4" enctype="multipart/form-data">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                        <input type="hidden" name="registrationId" value="${registration.id}">
                                        
                                        <!-- Drag và Drop Zone -->
                                        <div>
                                            <label class="block text-xs font-bold text-slate-700 mb-1.5">Tải lên tệp báo cáo (hoặc nhập liên kết bên dưới)</label>
                                            <div id="dropZone" 
                                                 class="dropzone-container group">
                                                <input type="file" name="file" id="fileInput" class="sr-only" accept=".pdf,.doc,.docx,.zip,.rar" aria-label="Chọn tệp báo cáo" data-max-size="10485760">
                                                <div class="w-12 h-12 rounded-2xl bg-sky-100/80 text-sky-600 flex items-center justify-center mb-2 mx-auto shadow-2xs group-hover:scale-110 transition-transform" id="dropIcon">
                                                    <i data-lucide="upload-cloud" class="w-6 h-6"></i>
                                                </div>
                                                <div class="text-xs font-bold text-slate-800" id="dropTitle">
                                                    Kéo thả tệp vào đây hoặc <span class="text-sky-600 underline">Chọn từ máy tính</span>
                                                </div>
                                                <p class="text-[10px] text-slate-400 mt-1" id="dropSub">
                                                    Hỗ trợ PDF, DOC, DOCX, ZIP, RAR tối đa 10 MB
                                                </p>
                                            </div>

                                            <!-- Dropzone File Preview Card -->
                                            <div class="dropzone-file-preview" id="dropPreview">
                                                <div class="flex items-center gap-3 min-w-0">
                                                    <div class="w-8 h-8 rounded-xl bg-emerald-50 text-emerald-600 flex items-center justify-center shrink-0">
                                                        <i data-lucide="file-check" class="w-4 h-4"></i>
                                                    </div>
                                                    <div class="min-w-0">
                                                        <div class="dropzone-file-name text-xs font-bold text-slate-800 truncate">--</div>
                                                        <div class="dropzone-file-size text-[11px] text-slate-400">--</div>
                                                    </div>
                                                </div>
                                                <button type="button" class="dropzone-file-remove p-1 text-slate-400 hover:text-rose-600 transition-colors" title="Hủy chọn tệp">
                                                    <i data-lucide="x" class="w-4 h-4"></i>
                                                </button>
                                            </div>
                                        </div>

                                        <!-- File Name -->
                                        <div>
                                            <label class="block text-xs font-bold text-slate-700 mb-1.5">Tên tệp / Tiêu đề báo cáo <span class="text-rose-500">*</span></label>
                                            <input type="text" name="fileName" id="fileNameInput" class="w-full px-4 py-2.5 bg-slate-50 border border-slate-200 rounded-2xl text-xs font-semibold focus:bg-white focus:ring-2 focus:ring-sky-500/20 focus:border-sky-500 focus:outline-none transition-all" placeholder="BaoCao_TienDo_DT001_Nhom1.pdf" required>
                                        </div>

                                        <!-- Drive / Storage Link (Optional) -->
                                        <div>
                                            <label class="block text-xs font-bold text-slate-700 mb-1.5">Đường dẫn lưu trữ / Drive (Tùy chọn)</label>
                                            <input type="text" name="filePath" class="w-full px-4 py-2.5 bg-slate-50 border border-slate-200 rounded-2xl text-xs focus:bg-white focus:ring-2 focus:ring-sky-500/20 focus:border-sky-500 focus:outline-none transition-all" placeholder="https://drive.google.com/file/d/...">
                                        </div>

                                        <!-- Progress và Notes -->
                                        <div>
                                            <label class="block text-xs font-bold text-slate-700 mb-1.5">Ghi chú tiến độ và Nội dung hoàn thành</label>
                                            <textarea name="note" rows="3" class="w-full px-4 py-2.5 bg-slate-50 border border-slate-200 rounded-2xl text-xs focus:bg-white focus:ring-2 focus:ring-sky-500/20 focus:border-sky-500 focus:outline-none transition-all" placeholder="Nội dung nhóm đã hoàn thành trong đợt này, khó khăn gặp phải và kế hoạch tiếp theo..."></textarea>
                                        </div>

                                        <button type="submit" class="btn-ui btn-ui-primary w-full justify-center py-2.5 text-xs shadow-md shadow-sky-500/20">
                                            <i data-lucide="send" class="w-4 h-4"></i> Xác nhận nộp báo cáo
                                        </button>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <div class="bg-amber-500/10 border border-amber-300/80 text-amber-950 rounded-3xl p-5 text-xs space-y-2">
                                        <div class="flex items-center gap-2 font-bold text-amber-950">
                                            <i data-lucide="shield-lock" class="w-4 h-4 text-amber-600"></i>
                                            Quy định phân quyền nộp báo cáo:
                                        </div>
                                        <p class="leading-relaxed text-amber-900">
                                            Chỉ tài khoản của <strong>Nhóm trưởng (${myGroup.leader.user.fullName})</strong> mới có quyền đại diện nhóm tải lên và nộp file báo cáo đề tài.
                                        </p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Right: Submission History (7 cols) -->
                    <div class="lg:col-span-7 space-y-6">
                        <div class="bg-white rounded-3xl border border-slate-200/90 p-6 shadow-xs space-y-4">
                            <div class="flex items-center justify-between pb-3 border-b border-slate-100">
                                <h4 class="text-sm font-bold text-slate-900 flex items-center gap-2">
                                    <i data-lucide="history" class="w-4 h-4 text-sky-600"></i> Lịch sử báo cáo đã nộp (${fn:length(reports)})
                                </h4>
                                <span class="status-badge status-success text-[10px]">
                                    ${fn:length(reports)} bản nộp
                                </span>
                            </div>

                            <c:choose>
                                <c:when test="${empty reports}">
                                    <div class="text-center py-12 text-slate-400 text-xs bg-slate-50/70 rounded-2xl border border-slate-200/70 space-y-2">
                                        <i data-lucide="file-x" class="w-8 h-8 mx-auto opacity-40"></i>
                                        <div>Nhóm chưa nộp bản báo cáo nào trong đợt này.</div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="space-y-3">
                                        <c:forEach var="r" items="${reports}">
                                            <div class="p-4 bg-slate-50/70 hover:bg-sky-50/30 rounded-2xl border border-slate-200/80 transition-all space-y-2 text-xs group">
                                                <div class="flex items-start justify-between gap-3">
                                                    <div class="flex items-center gap-3">
                                                        <div class="w-10 h-10 rounded-2xl bg-rose-500/10 text-rose-600 flex items-center justify-center shrink-0 group-hover:scale-105 transition-transform">
                                                            <i data-lucide="file-text" class="w-5 h-5"></i>
                                                        </div>
                                                        <div>
                                                            <h5 class="font-bold text-slate-900 text-xs group-hover:text-sky-600 transition-colors">${r.fileName}</h5>
                                                            <div class="text-[11px] text-slate-500 mt-0.5">
                                                                Người nộp: <strong><c:out value="${r.submittedBy.user.fullName}" /></strong> (${r.submittedBy.studentCode})
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <span class="px-2.5 py-1 rounded-xl text-[10px] font-semibold bg-white border border-slate-200 text-slate-600 shrink-0 shadow-2xs">
                                                        ${dateDisplay.format(r.submittedAt)}
                                                    </span>
                                                </div>

                                                <c:if test="${not empty r.note}">
                                                    <div class="p-3 bg-white rounded-xl border border-slate-200/60 text-slate-600 text-[11px] leading-relaxed">
                                                        <strong class="text-slate-700">Ghi chú:</strong> <c:out value="${r.note}" />
                                                    </div>
                                                </c:if>

                                                <c:if test="${not empty r.filePath}">
                                                    <div class="pt-1 flex justify-end">
                                                        <a href="${pageContext.request.contextPath}/reports/download/${r.id}"
                                                           class="btn-ui btn-ui-outline text-xs py-1.5 px-3" download>
                                                            <i data-lucide="download" class="w-3.5 h-3.5 text-sky-600"></i> Tải báo cáo
                                                        </a>
                                                    </div>
                                                </c:if>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </main>

<jsp:include page="../common/footer.jsp" />
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const feedback = document.querySelector('[data-report-feedback="error"]')
            || document.querySelector('[data-report-feedback="success"]');
        if (!feedback || typeof Swal === 'undefined') return;
        const success = feedback.dataset.reportFeedback === 'success';
        feedback.hidden = true;
        Swal.fire({
            icon: success ? 'success' : 'error',
            title: success ? 'Nộp báo cáo thành công' : 'Không thể nộp báo cáo',
            text: feedback.textContent.trim(),
            confirmButtonText: 'Đã hiểu',
            confirmButtonColor: '#006da8'
        });
    });
</script>


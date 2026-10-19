<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set scope="request" var="pageTitle" value="Chấm điểm đề tài" />
<c:set scope="request" var="pageHeading" value="Phiếu đánh giá và chấm điểm đề tài" />
<c:set scope="request" var="pageSubheading" value="Hội đồng: ${assignment.council.name} &bull; Đề tài: ${assignment.topicRegistration.topic.title}" />
<c:set scope="request" var="activeMenu" value="councils" />

<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/sidebar.jsp" />

<div class="app-main">
    <jsp:include page="../common/navbar.jsp" />

    <main class="app-content workspace-page space-y-6">
        <!-- Anti-supervision constraint banner if supervisor -->
        <c:if test="${isSupervisor}">
            <div class="bg-rose-50 border border-rose-200 text-rose-900 p-5 rounded-3xl flex items-start gap-3.5 shadow-sm">
                <div class="p-2.5 rounded-2xl bg-rose-600 text-white shrink-0 shadow-xs">
                    <i data-lucide="shield-ban" class="w-5 h-5"></i>
                </div>
                <div class="text-xs leading-relaxed">
                    <h6 class="font-extrabold text-rose-950 text-sm flex items-center gap-2">
                        <span>Bạn là Giảng viên Hướng dẫn &bull; Bị khóa quyền chấm</span>
                    </h6>
                    <p class="text-rose-800 mt-1 font-medium">
                        Ràng buộc nghiệp vụ bắt buộc: Giảng viên Hướng dẫn chính hoặc Đồng hướng dẫn không được quyền nhập điểm hoặc phản biện đề tài của mình. Tất cả các trường nhập liệu đã bị khóa để đảm bảo tính khách quan.
                    </p>
                </div>
            </div>
        </c:if>

        <div class="grid grid-cols-1 lg:grid-cols-12 gap-6">
            <!-- Left Column: Topic Details và Submitted Reports (5 cols) -->
            <div class="lg:col-span-5 space-y-6">
                <!-- Topic Overview Card -->
                <div class="bg-white rounded-3xl border border-slate-200 p-6 shadow-sm space-y-4">
                    <div class="flex items-center justify-between">
                        <span class="code-tag">${assignment.topicRegistration.topic.code}</span>
                        <span class="status-badge status-neutral">
                            <c:out value="${assignment.topicRegistration.topic.department.name}" />
                        </span>
                    </div>

                    <h3 class="text-base font-extrabold text-slate-900 leading-snug">
                        <c:out value="${assignment.topicRegistration.topic.title}" />
                    </h3>

                    <p class="text-xs text-slate-600 leading-relaxed bg-slate-50 p-4 rounded-2xl border border-slate-200/80">
                        <c:out value="${assignment.topicRegistration.topic.description}" />
                    </p>

                    <!-- Group và Supervisors Info -->
                    <div class="bg-slate-50 p-4 rounded-2xl border border-slate-200/80 space-y-2 text-xs">
                        <div class="flex items-center justify-between pb-2 border-b border-slate-200">
                            <span class="text-slate-500 font-medium">Nhóm thực hiện:</span>
                            <span class="font-bold text-slate-900"><c:out value="${assignment.topicRegistration.group.name}" /></span>
                        </div>
                        <div class="flex items-center justify-between pb-2 border-b border-slate-200">
                            <span class="text-slate-500 font-medium">Trưởng nhóm:</span>
                            <span class="font-semibold text-slate-800">${assignment.topicRegistration.group.leader.user.fullName} (${assignment.topicRegistration.group.leader.studentCode})</span>
                        </div>
                        <div class="flex items-center justify-between pb-2 border-b border-slate-200">
                            <span class="text-slate-500 font-medium">GVHD chính:</span>
                            <span class="font-bold text-sky-700"><c:out value="${assignment.topicRegistration.topic.lecturer != null ? assignment.topicRegistration.topic.lecturer.user.fullName : 'N/A'}" /></span>
                        </div>
                        <c:if test="${not empty assignment.topicRegistration.topic.coLecturer}">
                            <div class="flex items-center justify-between">
                                <span class="text-slate-500 font-medium">Đồng GVHD:</span>
                                <span class="font-bold text-indigo-700"><c:out value="${assignment.topicRegistration.topic.coLecturer.user.fullName}" /></span>
                            </div>
                        </c:if>
                    </div>
                </div>

                <!-- Submitted Reports và Files -->
                <div class="bg-white rounded-3xl border border-slate-200 p-6 shadow-sm space-y-4">
                    <div class="flex items-center justify-between">
                        <h4 class="text-sm font-bold text-slate-900 flex items-center gap-2">
                            <i data-lucide="folder-archive" class="w-4 h-4 text-sky-600"></i> Báo cáo sinh viên đã nộp
                        </h4>
                        <span class="status-badge status-info">${fn:length(reports)} file</span>
                    </div>

                    <c:choose>
                        <c:when test="${empty reports}">
                            <div class="empty-state py-8">
                                <div class="empty-state-icon-wrap w-10 h-10 mb-2">
                                    <i data-lucide="file-x" class="w-5 h-5 opacity-40"></i>
                                </div>
                                <div class="empty-state-desc text-xs mb-0">Nhóm sinh viên chưa nộp bản báo cáo nào</div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="space-y-2">
                                <c:forEach var="rep" items="${reports}">
                                    <div class="p-3.5 bg-slate-50 hover:bg-sky-50/50 rounded-2xl border border-slate-200 transition-colors flex items-center justify-between gap-3 text-xs">
                                        <div class="flex items-center gap-2.5 min-w-0">
                                            <div class="w-8 h-8 rounded-xl bg-rose-100 text-rose-600 flex items-center justify-center shrink-0">
                                                <i data-lucide="file-text" class="w-4 h-4"></i>
                                            </div>
                                            <div class="truncate">
                                                <div class="font-bold text-slate-800 truncate">${rep.fileName}</div>
                                                <div class="text-[10px] text-slate-500 mt-0.5">${dateDisplay.format(rep.submittedAt)}</div>
                                            </div>
                                        </div>
                                        <c:if test="${not empty rep.filePath}">
                                        <a href="${pageContext.request.contextPath}/reports/download/${rep.id}" download
                                           class="btn-ui btn-ui-outline p-2 text-sky-600 shrink-0" 
                                           title="Tải về file">
                                            <i data-lucide="download" class="w-4 h-4"></i>
                                        </a>
                                        </c:if>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Right Column: Interactive Scoring Form (7 cols) -->
            <div class="lg:col-span-7 space-y-6">
                <div class="bg-white rounded-3xl border border-slate-200 p-6 shadow-sm space-y-5">
                    <div class="flex items-center justify-between border-b border-slate-100 pb-4">
                        <div class="flex items-center gap-2.5">
                            <div class="p-2 rounded-xl bg-sky-50 text-sky-700 border border-sky-100">
                                <i data-lucide="pen-tool" class="w-5 h-5"></i>
                            </div>
                            <div>
                                <h4 class="text-base font-bold text-slate-900 leading-tight">Phiếu điểm của giảng viên</h4>
                                <p class="text-xs text-slate-500">Giảng viên: <strong><c:out value="${lecturer.user.fullName}" /></strong></p>
                            </div>
                        </div>
                        <c:if test="${myScore != null}">
                            <div class="text-right" id="scoreStatusBadge">
                                <span class="status-badge status-approved text-xs">
                                    Đã chấm: <strong id="currentScoreDisplay">${myScore.score}</strong> / 10
                                </span>
                            </div>
                        </c:if>
                    </div>

                    <!-- Fetch API Scoring Form -->
                    <form id="gradingForm" onsubmit="submitGradeFetch(event)">
                        <div class="space-y-4">
                            <!-- Score Input -->
                            <div>
                                <label class="block text-xs font-bold text-slate-800 mb-1.5 flex items-center justify-between">
                                    <span>Điểm đánh giá (Thang điểm 10) <span class="text-rose-500">*</span></span>
                                    <span class="text-[11px] text-slate-400 font-normal">Cho phép số thập phân (Ví dụ: 8.5)</span>
                                </label>
                                <div class="relative">
                                    <input type="number" step="0.1" min="0" max="10" name="score" id="scoreInput"
                                           value="${myScore != null ? myScore.score : ''}" 
                                           placeholder="Nhập điểm từ 0.0 đến 10.0..."
                                           ${isSupervisor ? 'disabled' : 'required'}
                                           class="w-full px-4 py-3 rounded-xl border text-sm font-bold text-sky-700 focus:outline-none transition-all ${isSupervisor ? 'bg-slate-100 text-slate-400 cursor-not-allowed border-slate-200' : 'bg-slate-50 focus:bg-white border-slate-200 focus:ring-2 focus:ring-sky-500'}">
                                </div>
                            </div>

                            <!-- Comment Input -->
                            <div>
                                <label class="block text-xs font-bold text-slate-800 mb-1.5">
                                    Nhận xét chi tiết đề tài và phần trả lời phản biện <span class="text-rose-500">*</span>
                                </label>
                                <textarea name="comment" id="commentInput" rows="6" 
                                          placeholder="Nhận xét cụ thể về: Tính ứng dụng, cấu trúc mã nguồn, thái độ báo cáo và mức độ làm chủ công nghệ..."
                                          ${isSupervisor ? 'disabled' : 'required'}
                                          class="w-full px-4 py-3 rounded-xl border text-xs text-slate-800 leading-relaxed focus:outline-none transition-all ${isSupervisor ? 'bg-slate-100 text-slate-400 cursor-not-allowed border-slate-200' : 'bg-slate-50 focus:bg-white border-slate-200 focus:ring-2 focus:ring-sky-500'}"><c:out value="${myScore != null ? myScore.comment : ''}" /></textarea>
                            </div>

                            <!-- Actions -->
                            <div class="pt-3 border-t border-slate-100 flex items-center justify-between">
                                <a href="${pageContext.request.contextPath}/lecturer/councils" 
                                   class="btn-ui btn-ui-outline text-xs py-2.5 px-4">
                                    <i data-lucide="arrow-left" class="w-4 h-4"></i> Quay lại hội đồng
                                </a>

                                <c:choose>
                                    <c:when test="${isSupervisor}">
                                        <button type="button" disabled class="btn-ui bg-slate-200 text-slate-400 text-xs py-2.5 px-4 cursor-not-allowed border border-slate-300">
                                            <i data-lucide="lock" class="w-4 h-4"></i> Bị khóa (Bạn là GVHD)
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <button type="submit" id="saveGradeBtn" 
                                                class="btn-ui btn-ui-primary text-xs py-2.5 px-6 shadow-sm">
                                            <i data-lucide="save" class="w-4 h-4"></i> Lưu điểm và Nhận xét
                                        </button>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </form>

                    <!-- Scores from other council members -->
                    <c:if test="${not empty allScores}">
                        <div class="pt-5 border-t border-slate-200 space-y-3">
                            <h5 class="text-xs font-bold  tracking-wider text-slate-500 flex items-center gap-2">
                                <i data-lucide="users" class="w-4 h-4 text-sky-600"></i> Điểm Từ Các Thành Viên Hội Đồng:
                            </h5>
                            <div class="space-y-2">
                                <c:forEach var="sc" items="${allScores}">
                                    <div class="p-3.5 rounded-2xl bg-slate-50 border border-slate-200/80 text-xs space-y-1">
                                        <div class="flex items-center justify-between">
                                            <div class="font-bold text-slate-800">
                                                <c:out value="${sc.councilMember.lecturer.user.fullName}" />
                                                <span class="status-badge status-neutral ml-1">${enumLabel.label(sc.councilMember.role)}</span>
                                            </div>
                                            <span class="status-badge status-approved">
                                                ${sc.score} / 10
                                            </span>
                                        </div>
                                        <p class="text-slate-600 italic mt-1 text-[11px]">"${sc.comment}"</p>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </main>

<jsp:include page="../common/footer.jsp" />

<script>
    async function submitGradeFetch(event) {
        event.preventDefault();
        const btn = document.getElementById('saveGradeBtn');
        const scoreInput = document.getElementById('scoreInput');
        const commentInput = document.getElementById('commentInput');

        const score = parseFloat(scoreInput.value);
        const comment = commentInput.value.trim();

        if (isNaN(score) || score < 0 || score > 10) {
            Swal.fire({
                icon: 'warning',
                title: 'Điểm không hợp lệ',
                text: 'Vui lòng nhập điểm số từ 0.0 đến 10.0',
                confirmButtonColor: '#006da8',
                customClass: { popup: 'rounded-3xl shadow-xl' }
            });
            return;
        }

        if (!comment) {
            Swal.fire({
                icon: 'warning',
                title: 'Thiếu nhận xét',
                text: 'Vui lòng nhập lời nhận xét chi tiết cho đề tài',
                confirmButtonColor: '#006da8',
                customClass: { popup: 'rounded-3xl shadow-xl' }
            });
            return;
        }

        btn.disabled = true;
        btn.innerHTML = '<i data-lucide="loader-2" class="w-4 h-4 animate-spin"></i> Đang lưu...';
        if (typeof lucide !== 'undefined') lucide.createIcons();

        try {
            const formData = new URLSearchParams();
            formData.append('score', score);
            formData.append('comment', comment);

            const response = await fetch('${pageContext.request.contextPath}/lecturer/grading/${assignment.id}/save-ajax', {
                method: 'POST',
                headers: EnterpriseUI.csrfHeaders({
                    'Content-Type': 'application/x-www-form-urlencoded',
                }),
                body: formData.toString()
            });

            const data = await response.json();

            if (data.success) {
                EnterpriseUI.toast('success', 'Thành công!', data.message);

                const disp = document.getElementById('currentScoreDisplay');
                if (disp) {
                    disp.innerText = data.score;
                }
            } else {
                Swal.fire({
                    icon: 'error',
                    title: 'Không thể lưu điểm',
                    text: data.message,
                    confirmButtonColor: '#006da8',
                    customClass: { popup: 'rounded-3xl shadow-xl' }
                });
            }
        } catch (error) {
            Swal.fire({
                icon: 'error',
                title: 'Lỗi mạng',
                text: 'Không thể kết nối đến máy chủ: ' + error.message,
                confirmButtonColor: '#006da8',
                customClass: { popup: 'rounded-3xl shadow-xl' }
            });
        } finally {
            btn.disabled = false;
            btn.innerHTML = '<i data-lucide="save" class="w-4 h-4"></i> Lưu Điểm và Nhận Xét';
            if (typeof lucide !== 'undefined') lucide.createIcons();
        }
    }
</script>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set scope="request" var="pageTitle" value="Quản lý nhóm sinh viên" />
<c:set scope="request" var="pageHeading" value="Quản lý nhóm sinh viên thực hiện đề tài" />
<c:set scope="request" var="pageSubheading" value="Mỗi nhóm tối đa 3 sinh viên cùng khoa, có thể khác lớp; mỗi sinh viên chỉ tham gia một nhóm trong một đợt" />
<c:set scope="request" var="activeMenu" value="group" />

<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/sidebar.jsp" />

<div class="app-main">
    <jsp:include page="../common/navbar.jsp" />

    <main class="app-content workspace-page space-y-6">
        <c:if test="${not empty successMessage}">
            <span id="successMessage" class="hidden"><c:out value="${successMessage}" /></span>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <span id="errorMessage" class="hidden"><c:out value="${errorMessage}" /></span>
        </c:if>

        <c:choose>
            <%-- Case 1: Student has no group yet -> Show Create Group 3D Bento Card --%>
            <c:when test="${empty myGroup}">
                <div class="max-w-2xl mx-auto py-8">
                    <div class="glass-card rounded-3xl border border-slate-200/90 p-8 sm:p-10 shadow-xl text-center space-y-6 relative overflow-hidden">
                        <div class="absolute -right-16 -top-16 w-48 h-48 bg-sky-500/10 rounded-full blur-3xl pointer-events-none"></div>
                        <div class="absolute -left-16 -bottom-16 w-48 h-48 bg-blue-500/10 rounded-full blur-3xl pointer-events-none"></div>

                        <div class="w-16 h-16 rounded-2xl bg-gradient-to-tr from-sky-600 via-blue-600 to-indigo-700 text-white flex items-center justify-center mx-auto shadow-lg shadow-blue-500/25 relative z-10">
                            <i data-lucide="users-round" class="w-8 h-8"></i>
                        </div>
                        <div class="relative z-10">
                            <h3 class="text-xl font-extrabold text-slate-900 tracking-tight">Thành lập nhóm sinh viên mới</h3>
                            <p class="text-xs text-slate-500 max-w-md mx-auto mt-2 leading-relaxed">
                                Chọn đợt đăng ký khi tạo nhóm, sau đó thêm tối đa 2 thành viên cùng khoa. Hệ thống kiểm tra trùng nhóm trong đợt ngay khi thêm.
                            </p>
                        </div>

                        <form method="post" action="${pageContext.request.contextPath}/student/group/create" class="text-left space-y-4 max-w-md mx-auto pt-2 relative z-10">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                            <div>
                                <label for="createGroupPeriod" class="block text-xs font-bold text-slate-700 mb-1.5">Đợt đăng ký <span class="text-rose-500">*</span></label>
                                <select id="createGroupPeriod" name="periodId" required class="w-full px-4 py-3 border border-slate-200 rounded-2xl text-xs">
                                    <option value="">Chọn đợt còn hạn sinh viên đăng ký</option>
                                    <c:forEach var="p" items="${openPeriods}"><option value="${p.id}"><c:out value="${p.name}" /></option></c:forEach>
                                </select>
                            </div>
                            <div>
                                <label class="block text-xs font-bold text-slate-700 mb-1.5">Tên nhóm sinh viên <span class="text-rose-500">*</span></label>
                                <input type="text" name="name" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-2xl text-xs font-semibold focus:bg-white focus:ring-2 focus:ring-sky-500/20 focus:border-sky-500 focus:outline-none transition-all" placeholder="Ví dụ: Nhóm UTE Cloud Innovators..." required>
                            </div>
                            <button type="submit"  class="btn-ui btn-ui-primary w-full justify-center py-3 text-xs shadow-md shadow-sky-500/20 disabled:opacity-50 disabled:cursor-not-allowed">
                                <i data-lucide="sparkles" class="w-4 h-4 text-amber-300"></i> Tạo nhóm và Trở thành nhóm trưởng
                            </button>
                        </form>
                    </div>
                </div>
            </c:when>

            <%-- Case 2: Student already in a group -> Show Group Details và Member Cards --%>
            <c:otherwise>
                <!-- Group Header 3D Banner -->
                <div class="glass-card rounded-3xl border border-slate-200/90 p-6 sm:p-7 shadow-sm flex flex-col lg:flex-row lg:items-center justify-between gap-5 relative overflow-hidden">
                    <div class="absolute -right-20 -top-20 w-52 h-52 bg-sky-400/10 rounded-full blur-3xl pointer-events-none"></div>

                    <div class="flex items-center gap-4 relative z-10">
                        <div class="w-14 h-14 rounded-2xl bg-gradient-to-tr from-sky-600 to-blue-700 text-white flex items-center justify-center shrink-0 shadow-lg shadow-sky-500/20">
                            <i data-lucide="shield-check" class="w-7 h-7"></i>
                        </div>
                        <div>
                            <div class="flex items-center gap-2.5 flex-wrap">
                                <h3 class="text-xl font-extrabold text-slate-900 tracking-tight"><c:out value="${myGroup.name}" /></h3>
                                <span class="status-badge status-info text-[10px]">
                                    ${enumLabel.label(myGroup.status)}
                                </span>
                            </div>
                            <p class="text-xs text-slate-500 mt-1 flex items-center gap-2 flex-wrap">
                                <span>Đợt: <strong class="text-slate-700"><c:out value="${not empty myGroup.registrationPeriod ? myGroup.registrationPeriod.name : 'Chưa chọn đợt — vui lòng chọn đợt cho nhóm'}" /></strong></span>
                                <span class="text-slate-300">&bull;</span>
                                <span>Khởi tạo: <strong class="text-slate-700">${dateDisplay.format(myGroup.createdAt)}</strong></span>
                            </p>
                        </div>
                    </div>

                    <!-- Quota và Action Button -->
                    <div class="flex items-center gap-3 self-end lg:self-center relative z-10">
                        <div class="bg-slate-50/80 px-4 py-2.5 rounded-2xl border border-slate-200/80 text-right shrink-0">
                            <div class="text-[10px] uppercase font-bold tracking-wider text-slate-400">Sĩ số nhóm</div>
                            <div class="text-sm font-extrabold ${fn:length(members) == 3 ? 'text-emerald-600' : 'text-sky-600'}">
                                ${fn:length(members)} / 3 Thành viên
                            </div>
                        </div>

                        <c:if test="${myGroup.leader.id == student.id && canChangeMembers && not empty myGroup.registrationPeriod}">
                            <button type="button" class="btn-ui btn-ui-primary text-xs py-2.5 px-4 shadow-sm shrink-0" 
                                    data-bs-toggle="modal" data-bs-target="#inviteMemberModal">
                                <i data-lucide="user-plus" class="w-4 h-4"></i> Thêm thành viên
                            </button>
                        </c:if>
                    </div>
                </div>

                <c:if test="${empty myGroup.registrationPeriod && myGroup.leader.id == student.id}">
                    <form method="post" action="${pageContext.request.contextPath}/student/group/select-period" class="bg-white p-5 rounded-2xl border border-slate-200 space-y-3">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                        <input type="hidden" name="groupId" value="${myGroup.id}">
                        <label for="legacyGroupPeriod" class="block font-semibold">Chọn đợt đăng ký cho nhóm</label>
                        <p class="text-sm text-slate-600">Cần chọn đợt trước khi thêm thành viên hoặc đăng ký đề tài. Hệ thống sẽ kiểm tra toàn bộ thành viên hiện có.</p>
                        <select id="legacyGroupPeriod" name="periodId" required class="w-full p-3 border rounded-xl">
                            <option value="">Chọn đợt còn hạn sinh viên đăng ký</option>
                            <c:forEach var="p" items="${openPeriods}"><option value="${p.id}"><c:out value="${p.name}" /></option></c:forEach>
                        </select>
                        <button class="btn-ui btn-ui-primary" type="submit">Lưu đợt đăng ký</button>
                    </form>
                </c:if>
                <div class="grid grid-cols-1 lg:grid-cols-12 gap-6">
                    <!-- Left: Registered Topic Card (5 cols) -->
                    <div class="lg:col-span-5 space-y-6">
                        <div class="bg-white rounded-3xl border border-slate-200/90 p-6 shadow-xs space-y-4">
                            <h4 class="text-sm font-bold text-slate-900 flex items-center gap-2 pb-3 border-b border-slate-100">
                                <i data-lucide="book-marked" class="w-4 h-4 text-sky-600"></i> Đề tài nhóm đã đăng ký
                            </h4>

                            <c:choose>
                                <c:when test="${not empty registration}">
                                    <div class="p-5 rounded-2xl bg-gradient-to-br from-slate-50 to-sky-50/40 border border-slate-200/90 space-y-3.5">
                                        <div class="flex items-center justify-between">
                                            <span class="px-2.5 py-1 rounded-xl font-mono font-bold text-xs bg-sky-50 text-sky-700 border border-sky-200/80 shadow-2xs">${registration.topic.code}</span>
                                            <span class="status-badge ${registration.status == 'APPROVED' ? 'status-success' : registration.status == 'PENDING' ? 'status-pending' : 'status-danger'} text-[10px]">
                                                <c:choose>
                                                    <c:when test="${registration.status == 'APPROVED'}">ĐÃ CHẤP NHẬN</c:when>
                                                    <c:when test="${registration.status == 'PENDING'}">CHỜ DUYỆT</c:when>
                                                    <c:otherwise>TỪ CHỐI</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                        <h5 class="text-sm font-bold text-slate-900 leading-snug break-words"><c:out value="${registration.topic.title}" /></h5>
                                        <div class="text-xs text-slate-600 pt-2 border-t border-slate-200/60 space-y-1">
                                            <div>Giảng viên HD: <strong class="text-slate-800"><c:out value="${registration.topic.lecturer != null ? registration.topic.lecturer.user.fullName : 'N/A'}" /></strong></div>
                                            <c:if test="${not empty registration.topic.coLecturer}">
                                                <div class="text-slate-500">Đồng hướng dẫn: ${registration.topic.coLecturer.user.fullName}</div>
                                            </c:if>
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-8 px-4 text-slate-400 text-xs bg-slate-50/80 rounded-2xl border border-dashed border-slate-200 space-y-3">
                                        <div class="w-12 h-12 rounded-2xl bg-slate-100 text-slate-400 flex items-center justify-center mx-auto">
                                            <i data-lucide="inbox" class="w-6 h-6 opacity-40"></i>
                                        </div>
                                        <p class="text-slate-500 font-medium">Nhóm chưa thực hiện đăng ký đề tài nào.</p>
                                        <a href="${pageContext.request.contextPath}/student/topics" class="btn-ui btn-ui-outline text-xs py-1.5 px-3 mx-auto">
                                            Tra cứu và Đăng ký đề tài <i data-lucide="arrow-right" class="w-3.5 h-3.5"></i>
                                        </a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Right: Member Cards Grid (7 cols) -->
                    <div class="lg:col-span-7 space-y-4">
                        <div class="flex items-center justify-between">
                            <h4 class="text-sm font-bold text-slate-900 flex items-center gap-2">
                                <i data-lucide="users" class="w-4 h-4 text-sky-600"></i> Danh sách thành viên (${fn:length(members)} / 3)
                            </h4>
                            <c:if test="${fn:length(members) >= 3}">
                                <span class="status-badge status-success text-[10px]">ĐÃ ĐỦ SĨ SỐ</span>
                            </c:if>
                        </div>

                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                            <c:forEach var="m" items="${members}">
                                <div class="bg-white rounded-3xl border border-slate-200/90 p-5 shadow-xs hover:shadow-lg transition-all duration-300 flex flex-col justify-between group relative">
                                    <div>
                                        <!-- Card Top: Avatar và Badges -->
                                        <div class="flex items-start justify-between gap-2 mb-3">
                                            <div class="w-12 h-12 rounded-2xl flex items-center justify-center font-bold text-base text-white shrink-0 shadow-md ${m.leader ? 'bg-gradient-to-tr from-amber-500 to-amber-600 shadow-amber-500/20' : 'bg-gradient-to-tr from-sky-600 to-blue-700 shadow-sky-500/20'}">
                                                <c:out value="${fn:substring(m.student.user.fullName, 0, 1)}" />
                                            </div>
                                            <div class="flex flex-col items-end gap-1">
                                                <c:if test="${m.leader}">
                                                    <span class="px-2.5 py-0.5 rounded-lg text-[10px] font-bold bg-amber-100 text-amber-800 border border-amber-200 flex items-center gap-1 shadow-2xs">
                                                        <i data-lucide="crown" class="w-3 h-3 text-amber-600"></i> NHÓM TRƯỞNG 
                                                    </span>
                                                </c:if>
                                                <c:if test="${m.student.id == student.id}">
                                                    <span class="px-2.5 py-0.5 rounded-lg text-[10px] font-bold bg-sky-50 text-sky-700 border border-sky-200/80">
                                                        BẠN
                                                    </span>
                                                </c:if>
                                            </div>
                                        </div>

                                        <!-- Student Info -->
                                        <h5 class="text-sm font-bold text-slate-900 group-hover:text-sky-600 transition-colors truncate">
                                            <c:out value="${m.student.user.fullName}" />
                                        </h5>

                                        <div class="space-y-1.5 mt-3 text-xs text-slate-500">
                                            <div class="flex items-center justify-between">
                                                <span>MSSV:</span>
                                                <span class="font-mono font-bold text-slate-800">${m.student.studentCode}</span>
                                            </div>
                                            <div class="flex items-center justify-between">
                                                <span>Lớp học:</span>
                                                <span class="font-semibold text-slate-700">${m.student.className != null ? m.student.className : 'N/A'}</span>
                                            </div>
                                            <div class="flex items-center justify-between">
                                                <span>Email:</span>
                                                <span class="font-medium text-slate-700 truncate max-w-[140px]">${m.student.user.email}</span>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Card Footer / Delete Member -->
                                    <div class="pt-3 mt-4 border-t border-slate-100 flex items-center justify-between text-[11px] text-slate-400">
                                        <span>Tham gia: ${m.joinedAt != null ? dateDisplay.format(m.joinedAt) : 'Khởi tạo'}</span>
                                        <c:if test="${myGroup.leader.id == student.id && !m.leader && canChangeMembers}">
                                            <form method="post" action="${pageContext.request.contextPath}/student/group/remove-member" onsubmit="return confirmRemoveMember(event, '${m.student.user.fullName}');">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                                <input type="hidden" name="groupId" value="${myGroup.id}">
                                                <input type="hidden" name="studentId" value="${m.student.id}">
                                                <button type="submit" class="p-1.5 text-slate-400 hover:text-rose-600 hover:bg-rose-50 rounded-xl transition-colors" title="Xóa khỏi nhóm">
                                                    <i data-lucide="user-minus" class="w-4 h-4"></i>
                                                </button>
                                            </form>
                                        </c:if>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <!-- Modal Mời Thành Viên với Live MSSV Preview -->
                <div class="modal fade" id="inviteMemberModal" tabindex="-1" aria-labelledby="inviteMemberTitle" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content rounded-3xl border-0 shadow-2xl overflow-hidden backdrop-blur-md">
                            <form method="post" action="${pageContext.request.contextPath}/student/group/add-member">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                <input type="hidden" name="groupId" value="${myGroup.id}">
                                <div class="modal-header-hero px-6 py-4 text-white flex justify-between items-center">
                                    <h5 id="inviteMemberTitle" class="text-base font-bold flex items-center gap-2 mb-0">
                                        <i data-lucide="user-plus" class="w-5 h-5 text-sky-200"></i> Thêm thành viên vào nhóm
                                    </h5>
                                    <button type="button" class="text-white/80 hover:text-white p-1 rounded-lg transition-colors" data-bs-dismiss="modal" aria-label="Đóng">
                                        <i data-lucide="x" class="w-5 h-5"></i>
                                    </button>
                                </div>

                                <div class="p-6 space-y-4">
                                    <div class="bg-sky-500/10 border border-sky-300/80 text-sky-950 rounded-2xl p-3.5 text-xs flex items-start gap-2.5">
                                        <i data-lucide="info" class="w-4 h-4 text-sky-600 shrink-0 mt-0.5"></i>
                                        <div class="leading-relaxed">
                                            Nhập <strong>Mã số sinh viên (MSSV)</strong> để thêm trực tiếp vào nhóm, không cần xác nhận lời mời. Thành viên phải cùng khoa, có thể khác lớp và chưa thuộc nhóm khác trong cùng đợt. Nhóm đủ 3 người hoặc đã gửi đăng ký đề tài sẽ khóa thêm và xóa thành viên.
                                        </div>
                                    </div>

                                    <div>
                                        <label for="studentCodeInput" class="block text-xs font-bold text-slate-700 mb-1.5">Mã số sinh viên (MSSV) <span class="text-rose-500">*</span></label>
                                        <input type="text" name="studentCode" id="studentCodeInput" oninput="lookupStudentInfo(this.value)" 
                                               class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-2xl text-xs font-mono font-bold text-sky-600 focus:bg-white focus:ring-2 focus:ring-sky-500/20 focus:border-sky-500 focus:outline-none transition-all" 
                                               placeholder="Ví dụ: 25810167..." required>
                                    </div>

                                    <!-- Live Student Lookup Preview Card -->
                                    <div id="studentPreviewCard" class="hidden p-4 bg-sky-50/50 border border-sky-200/80 rounded-2xl text-xs space-y-2 transition-all">
                                        <div class="flex items-center gap-3">
                                            <div class="w-10 h-10 rounded-2xl bg-gradient-to-tr from-sky-600 to-blue-700 text-white font-bold text-sm flex items-center justify-center shrink-0 shadow-sm" id="prevAvatar">
                                                SV
                                            </div>
                                            <div class="min-w-0">
                                                <div class="font-bold text-slate-900 text-xs" id="prevName">Nguyễn Văn A</div>
                                                <div class="text-[11px] text-slate-500 mt-0.5" id="prevClass">Lớp: 21110CLC &bull; Khoa CNTT</div>
                                            </div>
                                        </div>
                                    </div>
                                    <div id="studentNotFound" class="hidden p-3.5 bg-rose-50 border border-rose-200 rounded-2xl text-xs text-rose-700 flex items-start gap-2">
                                        <i data-lucide="circle-alert" class="w-4 h-4 shrink-0 mt-0.5"></i>
                                        <span id="studentNotFoundMessage">Không tìm thấy sinh viên với MSSV này.</span>
                                    </div>
                                </div>

                                <div class="bg-slate-50/80 px-6 py-4 border-t border-slate-100 flex justify-end gap-3">
                                    <button type="button" class="btn-ui btn-ui-outline text-xs py-2 px-4" data-bs-dismiss="modal">Hủy</button>
                                    <button type="submit" class="btn-ui btn-ui-primary text-xs py-2 px-5 shadow-sm">
                                        <i data-lucide="check" class="w-4 h-4"></i> Thêm thành viên
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </main>

    <jsp:include page="../common/footer.jsp" />

<script>
    let lookupTimer = null;

    document.addEventListener('DOMContentLoaded', function () {
        if (typeof lucide !== 'undefined') lucide.createIcons();

        const successMessage = document.getElementById('successMessage');
        const errorMessage = document.getElementById('errorMessage');
        const message = successMessage || errorMessage;
        if (message && typeof Swal !== 'undefined') {
            Swal.fire({
                title: successMessage ? 'Thành công' : 'Có lỗi xảy ra',
                text: message.textContent.trim(),
                icon: successMessage ? 'success' : 'error',
                confirmButtonText: 'Đóng',
                confirmButtonColor: successMessage ? '#006da8' : '#ef4444',
                customClass: { popup: 'rounded-3xl', confirmButton: 'rounded-xl px-5 py-2.5 font-bold text-xs' }
            });
        }
    });

    function lookupStudentInfo(code) {
        clearTimeout(lookupTimer);
        const card = document.getElementById('studentPreviewCard');
        const notFound = document.getElementById('studentNotFound');
        const notFoundMessage = document.getElementById('studentNotFoundMessage');
        if (!code || code.trim().length < 3) {
            if (card) card.classList.add('hidden');
            if (notFound) notFound.classList.add('hidden');
            return;
        }

        lookupTimer = setTimeout(async () => {
            try {
                const res = await fetch('${pageContext.request.contextPath}/student/api/students/lookup?code=' + encodeURIComponent(code.trim()));
                const data = await res.json();
                if (data.found && card) {
                    card.classList.remove('hidden');
                    if (notFound) notFound.classList.add('hidden');
                    document.getElementById('prevAvatar').innerText = data.fullName.charAt(0);
                    document.getElementById('prevName').innerText = data.fullName + ' (' + data.studentCode + ')';
                    document.getElementById('prevClass').innerText = 'Lớp: ' + data.className + ' • ' + data.faculty;
                } else {
                    if (card) card.classList.add('hidden');
                    if (notFound) notFound.classList.remove('hidden');
                    if (notFoundMessage) notFoundMessage.innerText = data.message || 'Không tìm thấy sinh viên với MSSV này.';
                }
            } catch (e) {
                if (card) card.classList.add('hidden');
                if (notFound) notFound.classList.add('hidden');
            }
        }, 300);
    }

    function confirmRemoveMember(event, name) {
        event.preventDefault();
        const form = event.target;
        Swal.fire({
            title: 'Xóa thành viên?',
            text: 'Bạn có chắc chắn muốn xóa sinh viên "' + name + '" khỏi nhóm?',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#ef4444',
            cancelButtonColor: '#64748b',
            confirmButtonText: 'Đồng ý xóa',
            cancelButtonText: 'Hủy',
            customClass: { popup: 'rounded-3xl', confirmButton: 'rounded-xl px-4 py-2 text-xs font-bold', cancelButton: 'rounded-xl px-4 py-2 text-xs font-bold' }
        }).then((result) => {
            if (result.isConfirmed) {
                form.submit();
            }
        });
        return false;
    }
</script>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle" value="Quản lý nhóm sinh viên" />
<c:set var="pageHeading" value="Quản lý nhóm sinh viên thực hiện đề tài" />
<c:set var="pageSubheading" value="Mỗi nhóm có tối đa 03 thành viên, một nhóm trưởng và mỗi SV chỉ tham gia 01 nhóm duy nhất" />
<c:set var="activeMenu" value="group" />

<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/sidebar.jsp" />

<div class="app-main">
    <jsp:include page="../common/navbar.jsp" />

    <main class="app-content space-y-6">
        <c:choose>
            <%-- Case 1: Student has no group yet -> Show Create Group Form --%>
            <c:when test="${empty myGroup}">
                <div class="max-w-2xl mx-auto py-6">
                    <div class="bg-white rounded-3xl border border-slate-200 p-8 sm:p-10 shadow-xs hover:shadow-xl transition-all duration-300 text-center space-y-6 relative overflow-hidden">
                        <div class="absolute -right-12 -top-12 w-40 h-40 bg-blue-500/5 rounded-full blur-2xl"></div>
                        <div class="w-16 h-16 rounded-2xl bg-gradient-to-tr from-blue-600 via-indigo-600 to-blue-700 text-white flex items-center justify-center mx-auto shadow-lg shadow-blue-500/25">
                            <i data-lucide="users-round" class="w-8 h-8"></i>
                        </div>
                        <div>
                            <h3 class="text-xl font-black text-slate-900 tracking-tight">Thành lập nhóm sinh viên mới</h3>
                            <p class="text-xs text-slate-500 max-w-md mx-auto mt-1.5 leading-relaxed">
                                Bạn hiện chưa thuộc nhóm nào trong đợt đăng ký này. Hãy tạo nhóm và mời thêm tối đa 02 thành viên khác để cùng thực hiện đề tài tốt nghiệp.
                            </p>
                        </div>

                        <form method="post" action="${pageContext.request.contextPath}/student/group/create" class="text-left space-y-4 max-w-md mx-auto pt-2">
                            <div>
                                <label class="block text-xs font-bold text-slate-700 mb-1.5">Tên nhóm sinh viên <span class="text-rose-500">*</span></label>
                                <input type="text" name="name" class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-xs font-semibold focus:bg-white focus:ring-2 focus:ring-blue-500 focus:outline-none transition-all" placeholder="Ví dụ: Nhóm UTE Cloud Innovators..." required>
                            </div>
                            <div>
                                <label class="block text-xs font-bold text-slate-700 mb-1.5">Đợt đăng ký áp dụng</label>
                                <input type="text" class="w-full px-4 py-3 bg-slate-100/80 border border-slate-200 rounded-xl text-xs font-bold text-slate-600 cursor-not-allowed" value="${activePeriod != null ? activePeriod.name : 'Đang mở'}" readonly>
                            </div>
                            <button type="submit" class="w-full py-3.5 bg-blue-600 hover:bg-blue-700 text-white text-xs font-bold rounded-xl shadow-md shadow-blue-500/20 hover:shadow-lg transition-all duration-200 flex items-center justify-center gap-2">
                                <i data-lucide="sparkles" class="w-4 h-4 text-amber-300"></i> Tạo nhóm và trở thành nhóm trưởng
                            </button>
                        </form>
                    </div>
                </div>
            </c:when>

            <%-- Case 2: Student already in a group -> Show Group Details & Member Cards --%>
            <c:otherwise>
                <!-- Group Header Banner -->
                <div class="bg-white rounded-3xl border border-slate-200 p-6 shadow-xs flex flex-col lg:flex-row lg:items-center justify-between gap-5 relative overflow-hidden">
                    <div class="flex items-center gap-4">
                        <div class="w-14 h-14 rounded-2xl bg-gradient-to-tr from-blue-600 to-indigo-600 text-white flex items-center justify-center shrink-0 shadow-lg shadow-blue-500/20">
                            <i data-lucide="shield-check" class="w-7 h-7"></i>
                        </div>
                        <div>
                            <div class="flex items-center gap-2.5 flex-wrap">
                                <h3 class="text-xl font-black text-slate-900 tracking-tight">${myGroup.name}</h3>
                                <span class="px-3 py-1 rounded-full text-[10px] font-bold bg-blue-50 text-blue-700 border border-blue-200/80 uppercase tracking-wider">
                                    ${myGroup.status}
                                </span>
                            </div>
                            <p class="text-xs text-slate-500 mt-1 flex items-center gap-2 flex-wrap">
                                <span>Đợt: <strong class="text-slate-700">${myGroup.registrationPeriod.name}</strong></span>
                                <span class="text-slate-300">&bull;</span>
                                <span>Ngày khởi tạo: <strong class="text-slate-700">${myGroup.createdAt}</strong></span>
                            </p>
                        </div>
                    </div>

                    <!-- Quota & Action Button -->
                    <div class="flex items-center gap-3 self-end lg:self-center">
                        <div class="bg-slate-50 px-4 py-2.5 rounded-2xl border border-slate-200 text-right shrink-0">
                            <div class="text-[10px] uppercase font-bold tracking-wider text-slate-400">Sĩ số nhóm</div>
                            <div class="text-sm font-black ${fn:length(members) == 3 ? 'text-emerald-600' : 'text-blue-600'}">
                                ${fn:length(members)} / 3 Thành viên
                            </div>
                        </div>

                        <c:if test="${myGroup.leader.id == student.id && fn:length(members) < 3}">
                            <button type="button" class="inline-flex items-center gap-2 px-4 py-3 bg-blue-600 hover:bg-blue-700 text-white text-xs font-bold rounded-2xl shadow-md shadow-blue-500/20 hover:shadow-lg transition-all duration-200 shrink-0" 
                                    data-bs-toggle="modal" data-bs-target="#inviteMemberModal">
                                <i data-lucide="user-plus" class="w-4 h-4"></i> Mời Thành Viên
                            </button>
                        </c:if>
                    </div>
                </div>

                <div class="grid grid-cols-1 lg:grid-cols-12 gap-6">
                    <!-- Left: Registered Topic Card (5 cols) -->
                    <div class="lg:col-span-5 space-y-6">
                        <div class="bg-white rounded-3xl border border-slate-200 p-6 shadow-xs space-y-4">
                            <h4 class="text-sm font-bold text-slate-900 flex items-center gap-2 pb-3 border-b border-slate-100">
                                <i data-lucide="book-marked" class="w-4 h-4 text-blue-600"></i> Đề tài nhóm đã đăng ký
                            </h4>

                            <c:choose>
                                <c:when test="${not empty registration}">
                                    <div class="p-5 rounded-2xl bg-gradient-to-br from-slate-50 to-blue-50/30 border border-slate-200 space-y-3.5">
                                        <div class="flex items-center justify-between">
                                            <span class="px-2.5 py-1 rounded-lg font-mono font-bold text-xs bg-blue-50 text-blue-700 border border-blue-200">${registration.topic.code}</span>
                                            <span class="px-2.5 py-1 rounded-lg text-[10px] font-bold ${registration.status == 'APPROVED' ? 'bg-emerald-100 text-emerald-800 border border-emerald-200' : registration.status == 'PENDING' ? 'bg-amber-100 text-amber-800 border border-amber-200' : 'bg-rose-100 text-rose-800 border border-rose-200'}">
                                                <c:choose>
                                                    <c:when test="${registration.status == 'APPROVED'}">ĐÃ CHẤP NHẬN</c:when>
                                                    <c:when test="${registration.status == 'PENDING'}">CHỜ DUYỆT</c:when>
                                                    <c:otherwise>TỪ CHỐI</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                        <h5 class="text-sm font-bold text-slate-900 leading-snug break-words">${registration.topic.title}</h5>
                                        <div class="text-xs text-slate-600 pt-2 border-t border-slate-200/60 space-y-1">
                                            <div>Giảng viên HD: <strong class="text-slate-800">${registration.topic.lecturer != null ? registration.topic.lecturer.user.fullName : 'N/A'}</strong></div>
                                            <c:if test="${not empty registration.topic.coLecturer}">
                                                <div class="text-slate-500">Đồng hướng dẫn: ${registration.topic.coLecturer.user.fullName}</div>
                                            </c:if>
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-8 px-4 text-slate-400 text-xs bg-slate-50/80 rounded-2xl border border-dashed border-slate-200 space-y-3">
                                        <div class="w-12 h-12 rounded-2xl bg-slate-100 text-slate-400 flex items-center justify-center mx-auto">
                                            <i data-lucide="inbox" class="w-6 h-6 opacity-50"></i>
                                        </div>
                                        <p class="text-slate-500 font-medium">Nhóm chưa thực hiện đăng ký đề tài nào.</p>
                                        <a href="${pageContext.request.contextPath}/student/topics" class="inline-flex items-center gap-1.5 px-4 py-2 bg-blue-50 hover:bg-blue-100 text-blue-700 font-bold rounded-xl text-xs transition-colors">
                                            Tra cứu & Đăng ký đề tài <i data-lucide="arrow-right" class="w-3.5 h-3.5"></i>
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
                                <i data-lucide="users" class="w-4 h-4 text-blue-600"></i> Danh Sách thẻ thành viên (${fn:length(members)} / 3)
                            </h4>
                            <c:if test="${fn:length(members) >= 3}">
                                <span class="px-2.5 py-1 rounded-full text-[10px] font-bold bg-emerald-100 text-emerald-800 border border-emerald-200">ĐÃ ĐỦ SĨ SỐ</span>
                            </c:if>
                        </div>

                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                            <c:forEach var="m" items="${members}">
                                <div class="bg-white rounded-3xl border border-slate-200 p-5 shadow-xs hover:shadow-md transition-all duration-200 flex flex-col justify-between group relative">
                                    <div>
                                        <!-- Card Top: Avatar & Badges -->
                                        <div class="flex items-start justify-between gap-2 mb-3">
                                            <div class="w-12 h-12 rounded-2xl flex items-center justify-center font-bold text-base text-white shrink-0 shadow-md ${m.leader ? 'bg-gradient-to-tr from-amber-500 to-amber-600 shadow-amber-500/20' : 'bg-gradient-to-tr from-blue-600 to-indigo-600 shadow-blue-500/20'}">
                                                ${fn:substring(m.student.user.fullName, 0, 1)}
                                            </div>
                                            <div class="flex flex-col items-end gap-1">
                                                <c:if test="${m.leader}">
                                                    <span class="px-2.5 py-0.5 rounded-lg text-[10px] font-bold bg-amber-100 text-amber-800 border border-amber-200 flex items-center gap-1">
                                                        <i data-lucide="crown" class="w-3 h-3 text-amber-600"></i> TRƯỞNG NHÓM
                                                    </span>
                                                </c:if>
                                                <c:if test="${m.student.id == student.id}">
                                                    <span class="px-2.5 py-0.5 rounded-lg text-[10px] font-bold bg-blue-50 text-blue-700 border border-blue-200">
                                                        BẠN
                                                    </span>
                                                </c:if>
                                            </div>
                                        </div>

                                        <!-- Student Info -->
                                        <h5 class="text-sm font-bold text-slate-900 group-hover:text-blue-600 transition-colors truncate">
                                            ${m.student.user.fullName}
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
                                        <span>Tham gia: ${m.joinedAt != null ? m.joinedAt : 'Khởi tạo'}</span>
                                        <c:if test="${myGroup.leader.id == student.id && !m.leader}">
                                            <form method="post" action="${pageContext.request.contextPath}/student/group/remove-member" onsubmit="return confirmRemoveMember(event, '${m.student.user.fullName}');">
                                                <input type="hidden" name="groupId" value="${myGroup.id}">
                                                <input type="hidden" name="studentId" value="${m.student.id}">
                                                <button type="submit" class="p-1.5 text-slate-400 hover:text-rose-600 hover:bg-rose-50 rounded-lg transition-colors" title="Xóa khỏi nhóm">
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
                <div class="modal fade" id="inviteMemberModal" tabindex="-1">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content rounded-3xl border-0 shadow-2xl overflow-hidden">
                            <form method="post" action="${pageContext.request.contextPath}/student/group/add-member">
                                <input type="hidden" name="groupId" value="${myGroup.id}">
                                <div class="bg-gradient-to-r from-blue-600 to-indigo-700 px-6 py-4 text-white flex justify-between items-center">
                                    <h5 class="text-base font-bold flex items-center gap-2">
                                        <i data-lucide="user-plus" class="w-5 h-5"></i> Mời Thành Viên Vào Nhóm
                                    </h5>
                                    <button type="button" class="text-white/80 hover:text-white p-1" data-bs-dismiss="modal">
                                        <i data-lucide="x" class="w-5 h-5"></i>
                                    </button>
                                </div>

                                <div class="p-6 space-y-4">
                                    <div class="bg-blue-50 border border-blue-200 text-blue-900 rounded-2xl p-3.5 text-xs flex items-start gap-2.5">
                                        <i data-lucide="info" class="w-4 h-4 text-blue-600 shrink-0 mt-0.5"></i>
                                        <div class="leading-relaxed">
                                            Nhập chính xác <strong>Mã số sinh viên (MSSV)</strong> của bạn cùng lớp để tìm kiếm và thêm vào nhóm. Mỗi nhóm chứa tối đa 03 sinh viên.
                                        </div>
                                    </div>

                                    <div>
                                        <label class="block text-xs font-bold text-slate-700 mb-1">Mã số Sinh viên (MSSV) <span class="text-rose-500">*</span></label>
                                        <input type="text" name="studentCode" id="studentCodeInput" oninput="lookupStudentInfo(this.value)" 
                                               class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-xs font-mono font-bold text-blue-600 focus:bg-white focus:ring-2 focus:ring-blue-500 focus:outline-none" 
                                               placeholder="Ví dụ: 25810167..." required>
                                    </div>

                                    <!-- Live Student Lookup Preview Card -->
                                    <div id="studentPreviewCard" class="hidden p-4 bg-slate-50 border border-slate-200 rounded-2xl text-xs space-y-2 transition-all">
                                        <div class="flex items-center gap-3">
                                            <div class="w-10 h-10 rounded-xl bg-blue-600 text-white font-bold text-sm flex items-center justify-center shrink-0" id="prevAvatar">
                                                SV
                                            </div>
                                            <div class="min-w-0">
                                                <div class="font-bold text-slate-900 text-xs" id="prevName">Nguyễn Văn A</div>
                                                <div class="text-[11px] text-slate-500 mt-0.5" id="prevClass">Lớp: 21110CLC &bull; Khoa CNTT</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="bg-slate-50 px-6 py-4 border-t border-slate-100 flex justify-end gap-3">
                                    <button type="button" class="px-4 py-2.5 bg-white border border-slate-200 text-slate-700 text-xs font-bold rounded-xl hover:bg-slate-100 transition-colors" data-bs-dismiss="modal">Hủy</button>
                                    <button type="submit" class="px-5 py-2.5 bg-blue-600 hover:bg-blue-700 text-white text-xs font-bold rounded-xl shadow-md shadow-blue-500/20 hover:shadow-lg transition-all">
                                        Xác Nhận Thêm
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
</div>

<script>
    let lookupTimer = null;
    function lookupStudentInfo(code) {
        clearTimeout(lookupTimer);
        const card = document.getElementById('studentPreviewCard');
        if (!code || code.trim().length < 3) {
            if (card) card.classList.add('hidden');
            return;
        }

        lookupTimer = setTimeout(async () => {
            try {
                const res = await fetch('${pageContext.request.contextPath}/student/api/students/lookup?code=' + encodeURIComponent(code.trim()));
                const data = await res.json();
                if (data.found && card) {
                    card.classList.remove('hidden');
                    document.getElementById('prevAvatar').innerText = data.fullName.charAt(0);
                    document.getElementById('prevName').innerText = data.fullName + ' (' + data.studentCode + ')';
                    document.getElementById('prevClass').innerText = 'Lớp: ' + data.className + ' • ' + data.faculty;
                } else if (card) {
                    card.classList.add('hidden');
                }
            } catch (e) {
                if (card) card.classList.add('hidden');
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
            confirmButtonColor: '#dc2626',
            cancelButtonColor: '#64748b',
            confirmButtonText: 'Đồng ý xóa',
            cancelButtonText: 'Hủy',
            customClass: { popup: 'rounded-3xl' }
        }).then((result) => {
            if (result.isConfirmed) {
                form.submit();
            }
        });
        return false;
    }
</script>
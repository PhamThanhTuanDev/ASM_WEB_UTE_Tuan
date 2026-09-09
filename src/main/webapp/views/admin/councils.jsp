<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle" value="Quản lý hội đồng phản biện" />
<c:set var="pageHeading" value="Quản lý hội đồng phản biện & phân công" />
<c:set var="pageSubheading" value="Thành lập hội đồng 3 - 5 Giảng viên (1 Chủ tịch, 1 Thư ký, Ủy viên) và phân công đề tài phản biện" />
<c:set var="activeMenu" value="councils" />
<c:set var="suppressFlashMessage" value="true" />

<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/sidebar.jsp" />

<div class="app-main">
    <jsp:include page="../common/navbar.jsp" />

    <main class="app-content space-y-6">
        <c:if test="${not empty successMessage or not empty errorMessage}">
            <div id="councilFlashMessage" class="hidden" data-message-type="${not empty successMessage ? 'success' : 'error'}">${not empty successMessage ? successMessage : errorMessage}</div>
        </c:if>
        <!-- Top Toolbar -->
        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-xs flex flex-col sm:flex-row sm:items-center justify-between gap-4">
            <div>
                <h2 class="text-lg font-bold text-slate-900 flex items-center gap-2">
                    <i data-lucide="scale" class="w-5 h-5 text-blue-600"></i> Danh sách hội đồng phản biện
                </h2>
                <p class="text-xs text-slate-500 mt-0.5">Hiện có <strong class="text-blue-600">${fn:length(councils)}</strong> hội đồng đã thành lập</p>
            </div>
            <button class="inline-flex items-center gap-2 px-4 py-2.5 bg-blue-600 hover:bg-blue-700 text-white text-xs font-bold rounded-xl shadow-sm hover:shadow-md transition-all duration-200" 
                    data-bs-toggle="modal" data-bs-target="#createCouncilModal">
                <i data-lucide="users" class="w-4 h-4"></i> Thành lập hội đồng mới
            </button>
        </div>

        <div class="bg-white p-4 rounded-2xl border border-slate-200 shadow-xs grid grid-cols-1 md:grid-cols-3 gap-3">
            <div class="relative">
                <i data-lucide="search" class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400"></i>
                <input id="councilSearch" type="search" placeholder="Tìm theo tên giảng viên..." class="w-full pl-9 pr-3 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs focus:bg-white focus:border-blue-500 focus:outline-none">
            </div>
            <select id="councilPeriodFilter" class="w-full px-3 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs font-semibold focus:bg-white focus:border-blue-500 focus:outline-none">
                <option value="">Tất cả đợt đăng ký</option>
                <c:forEach var="p" items="${periods}"><option value="${p.id}">${p.name}</option></c:forEach>
            </select>
            <select id="councilDepartmentFilter" class="w-full px-3 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs font-semibold focus:bg-white focus:border-blue-500 focus:outline-none">
                <option value="">Tất cả khoa</option>
                <c:forEach var="d" items="${departments}"><option value="${d.id}">${d.name}</option></c:forEach>
            </select>
        </div>

        <!-- Councils Card Grid -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6" data-pagination-list>
            <c:forEach var="c" items="${councils}">
            <div data-pagination-item data-council-card data-period-id="${c.registrationPeriod.id}" data-department-id="${c.department.id}" data-lecturer-names="<c:forEach var='member' items='${c.members}'>${member.lecturer.user.fullName} </c:forEach>" class="bg-white rounded-2xl border border-slate-200 p-6 shadow-xs hover:shadow-md transition-all duration-200 flex flex-col justify-between group">
                    <div>
                        <!-- Header: Code, Title & Status -->
                        <div class="flex justify-between items-start mb-3">
                            <div class="flex items-center gap-2">
                                <span class="px-2.5 py-1 rounded-lg text-xs font-mono font-bold bg-slate-900 text-white">
                                    ${c.code}
                                </span>
                                <span class="text-xs text-slate-500 font-medium">
                                    ${c.department != null ? c.department.name : 'Khoa CNTT'}
                                </span>
                            </div>
                            <span class="px-2.5 py-1 rounded-lg text-xs font-bold ${c.status == 'COMPLETED' ? 'bg-emerald-100 text-emerald-800 border border-emerald-200' : 'bg-amber-100 text-amber-800 border border-amber-200'}">
                                ${c.status}
                            </span>
                        </div>

                        <h3 class="text-base font-bold text-slate-900 group-hover:text-blue-600 transition-colors mb-3">
                            ${c.name}
                        </h3>

                        <!-- Schedule & Room Info -->
                        <div class="bg-slate-50 p-3.5 rounded-xl border border-slate-100 grid grid-cols-2 gap-2 text-xs mb-4">
                            <div class="flex items-center gap-2 text-slate-700 font-semibold">
                                <i data-lucide="calendar" class="w-4 h-4 text-blue-600 shrink-0"></i>
                                <span>Ngày: <strong>${c.councilDate != null ? c.councilDate : 'Chưa định'}</strong></span>
                            </div>
                            <div class="flex items-center gap-2 text-slate-700 font-semibold">
                                <i data-lucide="map-pin" class="w-4 h-4 text-rose-500 shrink-0"></i>
                                <span>Phòng: <strong>${c.location != null ? c.location : 'Chưa định'}</strong></span>
                            </div>
                        </div>

                        <!-- Council Members (With Chairman, Secretary & Member Badges) -->
                        <div class="space-y-2 mb-4">
                            <div class="text-[11px] font-bold uppercase tracking-wider text-slate-400 flex items-center justify-between">
                                <span>Thành viên Hội đồng (${fn:length(c.members)} GV):</span>
                                <span class="text-blue-600 font-semibold">${fn:length(c.members)}/5 GV</span>
                            </div>
                            <div class="space-y-1.5">
                                <c:forEach var="m" items="${c.members}">
                                    <div class="flex items-center justify-between p-2.5 rounded-xl bg-slate-50 border border-slate-100 text-xs">
                                        <div class="flex items-center gap-2.5 min-w-0">
                                            <div class="w-7 h-7 rounded-lg flex items-center justify-center font-bold text-xs shrink-0 ${m.role == 'CHAIRMAN' ? 'bg-amber-500 text-white shadow-xs' : m.role == 'SECRETARY' ? 'bg-indigo-500 text-white shadow-xs' : 'bg-slate-200 text-slate-700'}">
                                                ${fn:substring(m.lecturer.user.fullName, 0, 1)}
                                            </div>
                                            <div class="truncate">
                                                <span class="font-bold text-slate-800">${m.lecturer.user.fullName}</span>
                                                <span class="text-[11px] text-slate-500">(${m.lecturer.academicDegree != null ? m.lecturer.academicDegree : 'GV'})</span>
                                            </div>
                                        </div>
                                        <div class="shrink-0">
                                            <c:choose>
                                                <c:when test="${m.role == 'CHAIRMAN'}">
                                                    <span class="px-2.5 py-1 rounded-md text-[10px] font-bold bg-amber-100 text-amber-800 border border-amber-200 flex items-center gap-1">
                                                        <i data-lucide="crown" class="w-3 h-3 text-amber-600"></i> CHỦ TỊCH
                                                    </span>
                                                </c:when>
                                                <c:when test="${m.role == 'SECRETARY'}">
                                                    <span class="px-2.5 py-1 rounded-md text-[10px] font-bold bg-indigo-100 text-indigo-800 border border-indigo-200 flex items-center gap-1">
                                                        <i data-lucide="feather" class="w-3 h-3 text-indigo-600"></i> THƯ KÝ
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="px-2 py-0.5 rounded-md text-[10px] font-semibold bg-slate-100 text-slate-600 border border-slate-200">
                                                        ỦY VIÊN
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>

                    <!-- Action Bar -->
                    <div class="pt-4 border-t border-slate-100 flex items-center justify-between">
                        <button type="button" class="inline-flex items-center gap-1.5 px-3.5 py-2 bg-blue-50 hover:bg-blue-600 text-blue-700 hover:text-white border border-blue-200 font-bold rounded-xl text-xs transition-colors" 
                                data-bs-toggle="modal" data-bs-target="#assignTopicModal_${c.id}">
                            <i data-lucide="link" class="w-3.5 h-3.5"></i> Phân công Đề tài
                        </button>
                        <form method="post" action="${pageContext.request.contextPath}/admin/councils/${c.id}/delete" onsubmit="return confirmDeleteCouncil(event, '${c.name}');">
                            <button type="submit" class="p-2 text-slate-400 hover:text-rose-600 hover:bg-rose-50 rounded-xl transition-colors" title="Xóa hội đồng">
                                <i data-lucide="trash-2" class="w-4 h-4"></i>
                            </button>
                        </form>
                    </div>
                </div>

                <!-- Modal Phân Công Đề Tài Cho Hội Đồng -->
                <div class="modal fade" id="assignTopicModal_${c.id}" tabindex="-1">
                    <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable max-w-2xl">
                        <div class="modal-content rounded-3xl border-0 shadow-2xl overflow-hidden">
                            <form method="post" action="${pageContext.request.contextPath}/admin/councils/${c.id}/assign-topic">
                                <div class="bg-gradient-to-r from-blue-600 to-indigo-700 px-6 py-4 text-white flex justify-between items-center">
                                    <h5 class="text-sm font-bold flex items-center gap-2">
                                        <i data-lucide="link" class="w-4 h-4"></i> Phân công Đề tài vào ${c.code}
                                    </h5>
                                    <button type="button" class="text-white/80 hover:text-white p-1" data-bs-dismiss="modal">
                                        <i data-lucide="x" class="w-4 h-4"></i>
                                    </button>
                                </div>
                                <div class="p-6 space-y-5">
                                    <div class="space-y-2">
                                        <div class="flex items-center justify-between gap-3">
                                            <label class="block text-xs font-bold text-slate-700" for="registrationId_${c.id}">Chọn đề tài đã duyệt</label>
                                            <span class="text-[10px] font-semibold text-slate-400">Bắt buộc</span>
                                        </div>
                                        <c:set var="hasCouncilTopics" value="false" />
                                        <c:forEach var="reg" items="${eligibleRegistrationsByCouncil[c.id]}">
                                            <c:set var="hasCouncilTopics" value="true" />
                                        </c:forEach>
                                        <select id="registrationId_${c.id}" name="registrationId" class="w-full min-w-0 max-w-full px-3 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs font-semibold text-slate-800 text-ellipsis focus:bg-white focus:border-blue-500 focus:ring-2 focus:ring-blue-500/20 focus:outline-none" required>
                                            <option value="" disabled selected>${hasCouncilTopics ? '-- Chọn một đề tài --' : 'Không còn đề tài chưa phân công thuộc khoa này'}</option>
                                            <c:forEach var="reg" items="${eligibleRegistrationsByCouncil[c.id]}">
                                                <option value="${reg.id}">
                                                    [${reg.topic.code}] ${reg.topic.title}
                                                </option>
                                            </c:forEach>
                                        </select>
                                        <p class="text-[11px] text-slate-500 leading-relaxed">Chỉ chọn đề tài đã duyệt, chưa thuộc hội đồng nào và cùng khoa với hội đồng hiện tại.</p>
                                    </div>
                                    <div class="flex items-start gap-3 bg-amber-50 border border-amber-200 text-amber-900 rounded-2xl p-4 text-xs leading-relaxed">
                                        <i data-lucide="shield-alert" class="w-4 h-4 text-amber-600 shrink-0 mt-0.5"></i>
                                        <span><strong>Quy định chấm điểm:</strong> GVHD chính hoặc đồng GVHD không được tham gia chấm đề tài của mình. Một GV vẫn có thể chấm nhiều đề tài khác.</span>
                                    </div>
                                </div>
                                <div class="bg-slate-50 px-6 py-4 border-t border-slate-100 flex flex-col-reverse sm:flex-row sm:justify-end gap-2.5">
                                    <button type="button" class="w-full sm:w-auto px-5 py-2.5 bg-white border border-slate-200 text-slate-700 text-xs font-bold rounded-xl hover:bg-slate-100 transition-colors" data-bs-dismiss="modal">Hủy</button>
                                    <button type="submit" class="w-full sm:w-auto px-6 py-2.5 bg-blue-600 hover:bg-blue-700 text-white text-xs font-bold rounded-xl shadow-sm hover:shadow-md transition-all">
                                        Xác nhận phân công
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </main>

    <!-- Modal Tạo Hội Đồng Mới (3-5 GV, 1 Chủ tịch, 1 Thư ký) -->
    <div class="modal fade" id="createCouncilModal" tabindex="-1">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content rounded-3xl border-0 shadow-2xl overflow-hidden h-[92vh] max-h-[92vh]">
                <form method="post" action="${pageContext.request.contextPath}/admin/councils/save" class="flex h-full min-h-0 flex-col">
                    <div class="bg-gradient-to-r from-blue-600 to-indigo-700 px-6 py-4 text-white flex justify-between items-center">
                        <h5 class="text-base font-bold flex items-center gap-2">
                            <i data-lucide="users" class="w-5 h-5"></i> Thành Lập Hội Đồng Phản Biện Mới
                        </h5>
                        <button type="button" class="text-white/80 hover:text-white p-1" data-bs-dismiss="modal">
                            <i data-lucide="x" class="w-5 h-5"></i>
                        </button>
                    </div>

                    <div class="min-h-0 flex-1 overflow-y-auto p-6 space-y-4">
                        <!-- Rule badge -->
                        <div class="bg-blue-50 border border-blue-200 text-blue-900 rounded-2xl p-3 text-xs flex items-center gap-2">
                            <i data-lucide="info" class="w-4 h-4 text-blue-600 shrink-0"></i>
                            <span>Quy định: Mỗi hội đồng phản biện gồm <strong>3 đến 5 Giảng viên</strong>, bao gồm 1 Chủ tịch và 1 Thư ký.</span>
                        </div>

                        <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
                            <div>
                                <label class="block text-xs font-bold text-slate-700 mb-1">Mã hội đồng <span class="text-rose-500">*</span></label>
                                <input type="text" name="code" class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs font-mono font-bold focus:bg-white focus:ring-2 focus:ring-blue-500 focus:outline-none" placeholder="Ví dụ: HD04" required>
                            </div>
                            <div class="sm:col-span-2">
                                <label class="block text-xs font-bold text-slate-700 mb-1">Tên hội đồng <span class="text-rose-500">*</span></label>
                                <input type="text" name="name" class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs font-semibold focus:bg-white focus:ring-2 focus:ring-blue-500 focus:outline-none" placeholder="Hội đồng Phản biện KLTN 04..." required>
                            </div>
                        </div>

                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                            <div>
                                <label class="block text-xs font-bold text-slate-700 mb-1">Đợt đăng ký áp dụng <span class="text-rose-500">*</span></label>
                                <select name="periodId" class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs font-semibold focus:bg-white focus:ring-2 focus:ring-blue-500 focus:outline-none" required>
                                    <c:forEach var="p" items="${periods}">
                                        <option value="${p.id}">${p.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div>
                                <label class="block text-xs font-bold text-slate-700 mb-1">Khoa quản lý</label>
                                <select name="departmentId" id="newCouncilDepartment" class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs font-semibold focus:bg-white focus:ring-2 focus:ring-blue-500 focus:outline-none" required onchange="filterCouncilLecturersByDepartment()">
                                    <c:forEach var="d" items="${departments}">
                                        <option value="${d.id}">${d.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                            <div>
                                <label class="block text-xs font-bold text-slate-700 mb-1">Ngày báo cáo hội đồng <span class="text-rose-500">*</span></label>
                                <input type="date" name="councilDate" class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs focus:bg-white focus:ring-2 focus:ring-blue-500 focus:outline-none" required>
                            </div>
                            <div>
                                <label class="block text-xs font-bold text-slate-700 mb-1">Địa điểm / Phòng báo cáo <span class="text-rose-500">*</span></label>
                                <input type="text" name="location" class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs focus:bg-white focus:ring-2 focus:ring-blue-500 focus:outline-none" placeholder="Ví dụ: Phòng A1-302" required>
                            </div>
                        </div>

                        <!-- Select Chairman & Secretary -->
                        <div class="bg-amber-50/60 p-4 rounded-2xl border border-amber-200 space-y-3">
                            <h6 class="text-xs font-bold text-amber-900 flex items-center gap-1.5">
                                <i data-lucide="crown" class="w-4 h-4 text-amber-600"></i> Chỉ Định Ban Lãnh Đạo Hội Đồng
                            </h6>
                            <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                                <div>
                                    <label class="block text-[11px] font-bold text-slate-700 mb-1">Chủ tịch Hội đồng (CHAIRMAN) <span class="text-rose-500">*</span></label>
                                    <select name="chairmanId" id="chairmanSelect" class="w-full px-3 py-2 bg-white border border-slate-200 rounded-xl text-xs font-semibold focus:ring-2 focus:ring-amber-500 focus:outline-none" required onchange="syncCouncilMemberCards()">
                                        <c:forEach var="lec" items="${lecturers}">
                                            <option value="${lec.id}" data-department-id="${lec.department.id}">${lec.user.fullName} (${lec.academicDegree != null ? lec.academicDegree : 'GV'})</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div>
                                    <label class="block text-[11px] font-bold text-slate-700 mb-1">Thư ký Hội đồng (SECRETARY) <span class="text-rose-500">*</span></label>
                                    <select name="secretaryId" id="secretarySelect" class="w-full px-3 py-2 bg-white border border-slate-200 rounded-xl text-xs font-semibold focus:ring-2 focus:ring-indigo-500 focus:outline-none" required onchange="syncCouncilMemberCards()">
                                        <c:forEach var="lec" items="${lecturers}" varStatus="loop">
                                            <option value="${lec.id}" data-department-id="${lec.department.id}" ${loop.index == 1 ? 'selected' : ''}>${lec.user.fullName} (${lec.academicDegree != null ? lec.academicDegree : 'GV'})</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <!-- Select Card Members (3-5 total including chairman & secretary) -->
                        <div class="bg-slate-50 p-4 rounded-2xl border border-slate-200 space-y-3">
                            <div class="flex items-center justify-between gap-2">
                                <h6 class="text-xs font-bold text-slate-800">
                                    Chọn Ủy viên (Select Card) — đủ sĩ số 3–5 GV:
                                </h6>
                                <span id="councilMemberCountBadge" class="px-2.5 py-1 rounded-full text-[10px] font-bold bg-blue-100 text-blue-800 border border-blue-200">2 / 5 đã chọn</span>
                            </div>
                            <div class="grid grid-cols-1 sm:grid-cols-2 gap-2 max-h-56 overflow-y-auto p-1" id="councilMemberCards">
                                <c:forEach var="lec" items="${lecturers}">
                                     <label class="member-select-card flex items-center gap-2.5 p-3 bg-white rounded-xl border border-slate-200 text-xs text-slate-700 hover:border-blue-400 transition-all"
                                         data-lecturer-id="${lec.id}" data-department-id="${lec.department.id}">
                                        <input type="checkbox" name="memberIds" value="${lec.id}" class="member-cb w-4 h-4 rounded text-blue-600 focus:ring-blue-500 border-slate-300" onchange="syncCouncilMemberCards()">
                                        <div class="w-8 h-8 rounded-lg bg-slate-100 text-slate-700 font-bold flex items-center justify-center shrink-0">
                                            ${fn:substring(lec.user.fullName, 0, 1)}
                                        </div>
                                        <div class="min-w-0 flex-1">
                                            <div class="font-bold text-slate-800 truncate">${lec.user.fullName}</div>
                                            <div class="text-[10px] text-slate-400">${lec.department != null ? lec.department.code : 'CNTT'} · ${lec.academicDegree != null ? lec.academicDegree : 'GV'}</div>
                                        </div>
                                        <span class="role-chip hidden shrink-0 px-2 py-0.5 rounded-md text-[10px] font-bold"></span>
                                    </label>
                                </c:forEach>
                            </div>
                            <p class="text-[10px] text-slate-500">Chủ tịch và Thư ký được đánh dấu tự động; tick thêm 1–3 ủy viên để đạt 3–5 thành viên.</p>
                        </div>
                    </div>

                    <div class="shrink-0 bg-slate-50 px-6 py-4 border-t border-slate-100 flex justify-end gap-3">
                        <button type="button" class="px-4 py-2 bg-white border border-slate-200 text-slate-700 text-xs font-bold rounded-xl hover:bg-slate-100 transition-colors" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="px-5 py-2 bg-blue-600 hover:bg-blue-700 text-white text-xs font-bold rounded-xl shadow-sm hover:shadow-md transition-all">
                            Thành Lập Hội Đồng
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

<jsp:include page="../common/footer.jsp" />

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const flash = document.getElementById('councilFlashMessage');
        if (!flash || typeof Swal === 'undefined') return;
        const isSuccess = flash.dataset.messageType === 'success';
        Swal.fire({
            icon: isSuccess ? 'success' : 'error',
            title: isSuccess ? 'Thành lập hội đồng thành công' : 'Không thể thành lập hội đồng',
            text: flash.textContent.trim(),
            confirmButtonText: 'Đóng',
            confirmButtonColor: isSuccess ? '#059669' : '#e11d48'
        });
    });

    function syncCouncilMemberCards() {
        const chairId = document.getElementById('chairmanSelect')?.value;
        const secId = document.getElementById('secretarySelect')?.value;
        let selected = 0;
        document.querySelectorAll('.member-select-card').forEach((card) => {
            const id = card.dataset.lecturerId;
            const cb = card.querySelector('.member-cb');
            const chip = card.querySelector('.role-chip');
            card.classList.remove('is-selected', 'is-chairman', 'is-secretary');
            chip.classList.add('hidden');
            chip.textContent = '';

            if (id === chairId) {
                if (cb) { cb.checked = true; cb.disabled = true; }
                card.classList.add('is-chairman', 'is-selected');
                chip.classList.remove('hidden');
                chip.className = 'role-chip shrink-0 px-2 py-0.5 rounded-md text-[10px] font-bold bg-amber-100 text-amber-800 border border-amber-200';
                chip.textContent = 'CHỦ TỊCH';
                selected++;
            } else if (id === secId) {
                if (cb) { cb.checked = true; cb.disabled = true; }
                card.classList.add('is-secretary', 'is-selected');
                chip.classList.remove('hidden');
                chip.className = 'role-chip shrink-0 px-2 py-0.5 rounded-md text-[10px] font-bold bg-indigo-100 text-indigo-800 border border-indigo-200';
                chip.textContent = 'THƯ KÝ';
                selected++;
            } else {
                if (cb) {
                    cb.disabled = false;
                    if (cb.checked) {
                        card.classList.add('is-selected');
                        chip.classList.remove('hidden');
                        chip.className = 'role-chip shrink-0 px-2 py-0.5 rounded-md text-[10px] font-bold bg-slate-100 text-slate-600 border border-slate-200';
                        chip.textContent = 'ỦY VIÊN';
                        selected++;
                    }
                }
            }
        });
        const badge = document.getElementById('councilMemberCountBadge');
        if (badge) {
            badge.textContent = selected + ' / 5 đã chọn';
            badge.className = 'px-2.5 py-1 rounded-full text-[10px] font-bold border ' +
                (selected >= 3 && selected <= 5
                    ? 'bg-emerald-100 text-emerald-800 border-emerald-200'
                    : 'bg-amber-100 text-amber-800 border-amber-200');
        }
    }

    document.addEventListener('DOMContentLoaded', syncCouncilMemberCards);

    function filterCouncilLecturersByDepartment() {
        const departmentId = document.getElementById('newCouncilDepartment')?.value;
        ['chairmanSelect', 'secretarySelect'].forEach(function (selectId) {
            const select = document.getElementById(selectId);
            if (!select) return;
            if (!select._allLecturerOptions) {
                select._allLecturerOptions = Array.from(select.options).map(function (option) {
                    return option.cloneNode(true);
                });
            }
            const matchingOptions = select._allLecturerOptions.filter(function (option) {
                return option.dataset.departmentId === departmentId;
            }).map(function (option) {
                return option.cloneNode(true);
            });
            select.replaceChildren(...matchingOptions);
            if (matchingOptions.length > 0) {
                select.value = matchingOptions[selectId === 'secretarySelect' && matchingOptions.length > 1 ? 1 : 0].value;
            }
        });
        const chairman = document.getElementById('chairmanSelect');
        const secretary = document.getElementById('secretarySelect');
        if (chairman && secretary && chairman.value === secretary.value && secretary.options.length > 1) {
            secretary.value = secretary.options[1].value;
        }
        document.querySelectorAll('#councilMemberCards .member-select-card').forEach(function (card) {
            const visible = card.dataset.departmentId === departmentId;
            card.classList.toggle('hidden', !visible);
            const checkbox = card.querySelector('.member-cb');
            if (!visible && checkbox) checkbox.checked = false;
        });
        syncCouncilMemberCards();
    }

    function filterCouncils() {
        const search = document.getElementById('councilSearch')?.value.trim().toLowerCase() || '';
        const period = document.getElementById('councilPeriodFilter')?.value || '';
        const department = document.getElementById('councilDepartmentFilter')?.value || '';
        document.querySelectorAll('[data-council-card]').forEach(function (card) {
            const matches = (!search || card.dataset.lecturerNames.toLowerCase().includes(search))
                && (!period || card.dataset.periodId === period)
                && (!department || card.dataset.departmentId === department);
            card.classList.toggle('hidden', !matches);
        });
    }

    document.addEventListener('DOMContentLoaded', function () {
        filterCouncilLecturersByDepartment();
        ['councilSearch', 'councilPeriodFilter', 'councilDepartmentFilter'].forEach(function (id) {
            document.getElementById(id)?.addEventListener('input', filterCouncils);
            document.getElementById(id)?.addEventListener('change', filterCouncils);
        });
    });

    document.addEventListener('DOMContentLoaded', function () {
        const form = document.querySelector('#createCouncilModal form');
        if (!form) return;
        form.addEventListener('submit', function (event) {
            const selectedCount = document.querySelectorAll('#councilMemberCards .member-cb:checked').length;
            const chairmanId = document.getElementById('chairmanSelect')?.value;
            const secretaryId = document.getElementById('secretarySelect')?.value;
            if (chairmanId === secretaryId) {
                event.preventDefault();
                Swal.fire({
                    icon: 'warning',
                    title: 'Chủ tịch và Thư ký bị trùng',
                    text: 'Vui lòng chọn hai giảng viên khác nhau cho hai vị trí.',
                    confirmButtonText: 'Đóng',
                    confirmButtonColor: '#d97706'
                });
                return;
            }
            if (selectedCount < 3 || selectedCount > 5) {
                event.preventDefault();
                Swal.fire({
                    icon: 'warning',
                    title: 'Số lượng thành viên chưa hợp lệ',
                    text: 'Hội đồng phải có từ 3 đến 5 giảng viên. Hiện tại: ' + selectedCount + ' người.',
                    confirmButtonText: 'Đóng',
                    confirmButtonColor: '#d97706'
                });
            }
        });
    });

    function confirmDeleteCouncil(event, name) {
        event.preventDefault();
        const form = event.target;
        Swal.fire({
            title: 'Xóa hội đồng?',
            text: 'Bạn có chắc muốn xóa hội đồng "' + name + '"?',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#dc2626',
            cancelButtonColor: '#64748b',
            confirmButtonText: 'Xác nhận xóa',
            cancelButtonText: 'Hủy',
            customClass: { popup: 'rounded-2xl' }
        }).then((result) => {
            if (result.isConfirmed) form.submit();
        });
        return false;
    }
</script>

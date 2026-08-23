<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle" value="Quản lý đợt đăng ký" />
<c:set var="pageHeading" value="Quản lý đợt đăng ký đề tài" />
<c:set var="pageSubheading" value="Thiết lập các mốc thời gian, điều kiện ràng buộc GVPB và Hội đồng phản biện" />
<c:set var="activeMenu" value="periods" />

<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/sidebar.jsp" />

<div class="app-main">
    <jsp:include page="../common/navbar.jsp" />

    <main class="app-content space-y-6">
        <!-- Top Action Bar -->
        <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 bg-white p-5 rounded-2xl border border-slate-200 shadow-xs">
            <div>
                <h2 class="text-lg font-bold text-slate-900 flex items-center gap-2">
                    <i data-lucide="calendar-range" class="w-5 h-5 text-blue-600"></i> Danh sách đợt đăng ký
                </h2>
                <p class="text-xs text-slate-500 mt-0.5">Hiện có <strong class="text-blue-600">${fn:length(periods)}</strong> đợt trong hệ thống</p>
            </div>
            <button class="inline-flex items-center gap-2 px-4 py-2.5 bg-blue-600 hover:bg-blue-700 text-white text-xs font-bold rounded-xl shadow-sm hover:shadow-md transition-all duration-200" 
                    data-bs-toggle="modal" data-bs-target="#createPeriodModal">
                <i data-lucide="plus-circle" class="w-4 h-4"></i> Tạo đợt đăng ký mới
            </button>
        </div>

        <!-- Grid Cards of Registration Periods -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <c:forEach var="p" items="${periods}">
                <div class="bg-white rounded-2xl border border-slate-200 p-5 shadow-xs hover:shadow-md transition-all duration-200 flex flex-col justify-between group">
                    <div>
                        <!-- Header Status Badge -->
                        <div class="flex justify-between items-start mb-3">
                            <span class="px-2.5 py-1 rounded-lg text-xs font-bold ${p.type == 'THESIS' ? 'bg-rose-50 text-rose-700 border border-rose-200' : p.type == 'PROJECT' ? 'bg-blue-50 text-blue-700 border border-blue-200' : 'bg-purple-50 text-purple-700 border border-purple-200'}">
                                ${p.type}
                            </span>
                            <span class="px-2.5 py-1 rounded-lg text-xs font-bold ${p.status == 'OPEN' ? 'bg-emerald-100 text-emerald-800 border border-emerald-200' : p.status == 'DRAFT' ? 'bg-amber-100 text-amber-800 border border-amber-200' : 'bg-slate-100 text-slate-700 border border-slate-200'}">
                                ${p.status == 'OPEN' ? 'ĐANG MỞ' : p.status == 'DRAFT' ? 'BẢN NHÁP' : 'ĐÃ ĐÓNG'}
                            </span>
                        </div>

                        <!-- Period Name -->
                        <h3 class="text-sm font-bold text-slate-900 group-hover:text-blue-600 transition-colors line-clamp-2 mb-3">
                            ${p.name}
                        </h3>

                        <!-- Progress Bar (computed by JS from date range) -->
                        <div class="bg-slate-50 p-3 rounded-xl border border-slate-100 mb-4 space-y-2 period-progress"
                             data-status="${p.status}"
                             data-start="${p.studentStartDate}"
                             data-end="${p.studentEndDate}">
                            <div class="flex justify-between text-[11px] font-semibold text-slate-600">
                                <span>Tiến độ đợt (SV đăng ký)</span>
                                <span class="text-blue-600 progress-label">${p.status == 'OPEN' ? 'Đang diễn ra' : p.status == 'CLOSED' ? 'Đã kết thúc' : 'Chưa bắt đầu'}</span>
                            </div>
                            <div class="w-full bg-slate-200 rounded-full h-2 overflow-hidden">
                                <div class="progress-bar h-2 rounded-full transition-all duration-500 ${p.status == 'OPEN' ? 'bg-blue-600' : p.status == 'CLOSED' ? 'bg-slate-400' : 'bg-amber-500'}"
                                     style="width: 15%"></div>
                            </div>
                        </div>

                        <!-- Timeline details -->
                        <div class="space-y-2 text-xs text-slate-600">
                            <div class="flex items-center justify-between py-1 border-b border-slate-100">
                                <span class="flex items-center gap-1.5 text-slate-500">
                                    <i data-lucide="user-check" class="w-3.5 h-3.5 text-blue-500"></i> GV Đề xuất:
                                </span>
                                <span class="font-semibold text-slate-800">${p.lecturerStartDate} &rarr; ${p.lecturerEndDate}</span>
                            </div>
                            <div class="flex items-center justify-between py-1 border-b border-slate-100">
                                <span class="flex items-center gap-1.5 text-slate-500">
                                    <i data-lucide="users" class="w-3.5 h-3.5 text-emerald-500"></i> SV Đăng ký:
                                </span>
                                <span class="font-semibold text-slate-800">${p.studentStartDate} &rarr; ${p.studentEndDate}</span>
                            </div>
                            <div class="flex items-center justify-between py-1 border-b border-slate-100">
                                <span class="flex items-center gap-1.5 text-slate-500">
                                    <i data-lucide="clock" class="w-3.5 h-3.5 text-amber-500"></i> Hạn GVPB nộp điểm:
                                </span>
                                <span class="font-semibold ${not empty p.reviewerDeadline ? 'text-amber-700 bg-amber-50 px-1.5 py-0.5 rounded' : 'text-slate-400'}">
                                    ${not empty p.reviewerDeadline ? p.reviewerDeadline : 'Không bắt buộc'}
                                </span>
                            </div>
                            <div class="flex items-center justify-between py-1">
                                <span class="flex items-center gap-1.5 text-slate-500">
                                    <i data-lucide="scale" class="w-3.5 h-3.5 text-purple-500"></i> Báo cáo Hội đồng:
                                </span>
                                <span class="font-semibold ${not empty p.councilReportDate ? 'text-purple-700 bg-purple-50 px-1.5 py-0.5 rounded' : 'text-slate-400'}">
                                    ${not empty p.councilReportDate ? p.councilReportDate : 'Không bắt buộc'}
                                </span>
                            </div>
                        </div>
                    </div>

                    <!-- Footer Action -->
                    <div class="pt-4 mt-4 border-t border-slate-100 flex items-center justify-between text-xs text-slate-400">
                        <span>Tạo bởi: <strong>${p.createdBy != null ? p.createdBy.fullName : 'Admin'}</strong></span>
                        <form method="post" action="${pageContext.request.contextPath}/admin/periods/${p.id}/delete" onsubmit="return confirmDeletePeriod(event, '${p.name}');">
                            <button type="submit" class="p-1.5 text-slate-400 hover:text-rose-600 hover:bg-rose-50 rounded-lg transition-colors" title="Xóa đợt">
                                <i data-lucide="trash-2" class="w-4 h-4"></i>
                            </button>
                        </form>
                    </div>
                </div>
            </c:forEach>
        </div>
    </main>

    <!-- Modal Tạo Đợt Đăng Ký Mới với JS Dynamic Validation & Fade-in -->
    <div class="modal fade" id="createPeriodModal" tabindex="-1">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content rounded-3xl border-0 shadow-2xl overflow-hidden">
                <form method="post" action="${pageContext.request.contextPath}/admin/periods/save">
                    <div class="bg-gradient-to-r from-blue-600 to-indigo-700 px-6 py-4 text-white flex justify-between items-center">
                        <h5 class="text-base font-bold flex items-center gap-2">
                            <i data-lucide="calendar-plus" class="w-5 h-5"></i> Tạo Đợt Đăng Ký Đề Tài Mới
                        </h5>
                        <button type="button" class="text-white/80 hover:text-white p-1" data-bs-dismiss="modal">
                            <i data-lucide="x" class="w-5 h-5"></i>
                        </button>
                    </div>

                    <div class="p-6 space-y-4 max-h-[80vh] overflow-y-auto">
                        <!-- Rule notification banner -->
                        <div class="bg-blue-50 border border-blue-200 text-blue-900 rounded-2xl p-3.5 text-xs flex items-start gap-2.5">
                            <i data-lucide="info" class="w-4 h-4 text-blue-600 mt-0.5 shrink-0"></i>
                            <div>
                                <strong>Quy định nghiệp vụ hệ thống:</strong>
                                <div>Đợt loại <strong>TLCN (PROJECT)</strong> & <strong>KLTN (THESIS)</strong> bắt buộc nhập Hạn nộp điểm GVPB. Đợt <strong>KLTN (THESIS)</strong> bắt buộc nhập Ngày báo cáo hội đồng.</div>
                            </div>
                        </div>

                        <!-- Name -->
                        <div>
                            <label class="block text-xs font-bold text-slate-700 mb-1">Tên đợt đăng ký <span class="text-rose-500">*</span></label>
                            <input type="text" name="name" class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs focus:bg-white focus:ring-2 focus:ring-blue-500 focus:outline-none" placeholder="Ví dụ: Đợt KLTN Học kỳ 2 năm học 2026-2027" required>
                        </div>

                        <!-- Type & Status -->
                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                            <div>
                                <label class="block text-xs font-bold text-slate-700 mb-1">Loại đợt đăng ký <span class="text-rose-500">*</span></label>
                                <select name="type" id="periodTypeSelect" class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs font-semibold text-slate-800 focus:bg-white focus:ring-2 focus:ring-blue-500 focus:outline-none" onchange="handlePeriodTypeChange(this.value)" required>
                                    <option value="THESIS">Khóa luận tốt nghiệp (THESIS / KLTN)</option>
                                    <option value="PROJECT">Tiểu luận chuyên ngành (PROJECT / TLCN)</option>
                                    <option value="NCKH">Nghiên cứu khoa học (NCKH)</option>
                                    <option value="COURSE">Môn học chuyên đề (COURSE)</option>
                                </select>
                            </div>
                            <div>
                                <label class="block text-xs font-bold text-slate-700 mb-1">Trạng thái khởi tạo</label>
                                <select name="status" class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs font-semibold text-slate-800 focus:bg-white focus:ring-2 focus:ring-blue-500 focus:outline-none">
                                    <option value="OPEN">MỞ (OPEN)</option>
                                    <option value="DRAFT">BẢN NHÁP (DRAFT)</option>
                                    <option value="CLOSED">ĐÓNG (CLOSED)</option>
                                </select>
                            </div>
                        </div>

                        <!-- Timeline Lecturers & Students -->
                        <div class="bg-slate-50 p-4 rounded-2xl border border-slate-200 space-y-3">
                            <h6 class="text-xs font-bold text-slate-800 flex items-center gap-1.5">
                                <i data-lucide="clock" class="w-4 h-4 text-blue-600"></i> Khung thời gian GV Đề xuất & SV Đăng ký
                            </h6>
                            <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                                <div>
                                    <label class="block text-[11px] font-semibold text-slate-600 mb-1">GV bắt đầu đề xuất</label>
                                    <input type="date" name="lecturerStartDate" class="w-full px-3 py-2 bg-white border border-slate-200 rounded-xl text-xs focus:ring-2 focus:ring-blue-500 focus:outline-none" required>
                                </div>
                                <div>
                                    <label class="block text-[11px] font-semibold text-slate-600 mb-1">GV kết thúc đề xuất</label>
                                    <input type="date" name="lecturerEndDate" class="w-full px-3 py-2 bg-white border border-slate-200 rounded-xl text-xs focus:ring-2 focus:ring-blue-500 focus:outline-none" required>
                                </div>
                                <div>
                                    <label class="block text-[11px] font-semibold text-slate-600 mb-1">SV bắt đầu đăng ký</label>
                                    <input type="date" name="studentStartDate" class="w-full px-3 py-2 bg-white border border-slate-200 rounded-xl text-xs focus:ring-2 focus:ring-blue-500 focus:outline-none" required>
                                </div>
                                <div>
                                    <label class="block text-[11px] font-semibold text-slate-600 mb-1">SV kết thúc đăng ký</label>
                                    <input type="date" name="studentEndDate" class="w-full px-3 py-2 bg-white border border-slate-200 rounded-xl text-xs focus:ring-2 focus:ring-blue-500 focus:outline-none" required>
                                </div>
                            </div>
                        </div>

                        <!-- Dynamic Fade-in Fields for GVPB & Council (TLCN / KLTN) -->
                        <div id="advancedDeadlinePanel" class="bg-indigo-50/50 p-4 rounded-2xl border border-indigo-100 space-y-3 fade-panel show">
                            <h6 class="text-xs font-bold text-indigo-950 flex items-center gap-1.5">
                                <i data-lucide="scale" class="w-4 h-4 text-indigo-600"></i> Hạn GVPB & Ngày Hội đồng Phản biện
                            </h6>
                            <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                                <div id="reviewerDeadlineContainer" class="transition-all duration-300">
                                    <label class="block text-[11px] font-semibold text-slate-700 mb-1">
                                        Hạn chót GVPB nộp điểm <span class="text-rose-500" id="reviewerReqMark">*</span>
                                    </label>
                                    <input type="date" name="reviewerDeadline" id="reviewerDeadlineInput" class="w-full px-3 py-2 bg-white border border-slate-200 rounded-xl text-xs focus:ring-2 focus:ring-blue-500 focus:outline-none" required>
                                    <span class="text-[10px] text-slate-500 mt-1 block">Bắt buộc đối với TLCN (PROJECT) & KLTN (THESIS)</span>
                                </div>
                                <div id="councilDateContainer" class="transition-all duration-300">
                                    <label class="block text-[11px] font-semibold text-slate-700 mb-1">
                                        Ngày báo cáo hội đồng <span class="text-rose-500" id="councilReqMark">*</span>
                                    </label>
                                    <input type="date" name="councilReportDate" id="councilDateInput" class="w-full px-3 py-2 bg-white border border-slate-200 rounded-xl text-xs focus:ring-2 focus:ring-blue-500 focus:outline-none" required>
                                    <span class="text-[10px] text-slate-500 mt-1 block">Bắt buộc đối với KLTN (THESIS)</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="bg-slate-50 px-6 py-4 border-t border-slate-100 flex justify-end gap-3">
                        <button type="button" class="px-4 py-2 bg-white border border-slate-200 text-slate-700 text-xs font-bold rounded-xl hover:bg-slate-100 transition-colors" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="px-5 py-2 bg-blue-600 hover:bg-blue-700 text-white text-xs font-bold rounded-xl shadow-sm hover:shadow-md transition-all">
                            Lưu & Áp Dụng Đợt
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

<jsp:include page="../common/footer.jsp" />

<script>
    function handlePeriodTypeChange(val) {
        const panel = document.getElementById('advancedDeadlinePanel');
        const revInput = document.getElementById('reviewerDeadlineInput');
        const revMark = document.getElementById('reviewerReqMark');
        const revContainer = document.getElementById('reviewerDeadlineContainer');
        const couInput = document.getElementById('councilDateInput');
        const couMark = document.getElementById('councilReqMark');
        const couContainer = document.getElementById('councilDateContainer');

        const needsPanel = (val === 'THESIS' || val === 'PROJECT');
        if (panel) {
            panel.classList.toggle('show', needsPanel);
        }

        if (val === 'THESIS') {
            revContainer.style.opacity = '1';
            revInput.required = true;
            revMark.style.display = 'inline';
            couContainer.style.opacity = '1';
            couContainer.style.display = '';
            couInput.required = true;
            couMark.style.display = 'inline';
        } else if (val === 'PROJECT') {
            revContainer.style.opacity = '1';
            revInput.required = true;
            revMark.style.display = 'inline';
            couContainer.style.opacity = '0.45';
            couInput.required = false;
            couMark.style.display = 'none';
        } else {
            revInput.required = false;
            couInput.required = false;
            revMark.style.display = 'none';
            couMark.style.display = 'none';
        }
    }

    document.addEventListener('DOMContentLoaded', function () {
        const sel = document.getElementById('periodTypeSelect');
        if (sel) handlePeriodTypeChange(sel.value);

        document.querySelectorAll('.period-progress').forEach(function (el) {
            const status = el.dataset.status;
            const start = el.dataset.start ? new Date(el.dataset.start) : null;
            const end = el.dataset.end ? new Date(el.dataset.end) : null;
            const bar = el.querySelector('.progress-bar');
            let pct = 15;
            if (status === 'CLOSED') pct = 100;
            else if (status === 'DRAFT') pct = 10;
            else if (start && end && end > start) {
                const now = new Date();
                pct = ((now - start) / (end - start)) * 100;
                pct = Math.max(5, Math.min(98, pct));
            }
            if (bar) bar.style.width = pct.toFixed(0) + '%';
        });
    });

    function confirmDeletePeriod(event, name) {
        event.preventDefault();
        const form = event.target;
        Swal.fire({
            title: 'Xóa đợt đăng ký?',
            text: 'Bạn có chắc chắn muốn xóa đợt "' + name + '"? Các dữ liệu liên quan sẽ bị ảnh hưởng.',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#dc2626',
            cancelButtonColor: '#64748b',
            confirmButtonText: 'Đồng ý xóa',
            cancelButtonText: 'Hủy',
            customClass: { popup: 'rounded-2xl' }
        }).then((result) => {
            if (result.isConfirmed) form.submit();
        });
        return false;
    }
</script>

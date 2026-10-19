<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <c:set scope="request" var="pageTitle" value="Tra cứu và đăng ký đề tài" />
            <c:set scope="request" var="pageHeading" value="Danh mục đề tài công bố cho sinh viên" />
            <c:set scope="request" var="pageSubheading"
                value="Tra cứu các đề tài đã duyệt của đợt và gửi yêu cầu đăng ký đại diện bởi Nhóm trưởng" />
            <c:set scope="request" var="activeMenu" value="topics" />

            <jsp:include page="../common/header.jsp" />
            <jsp:include page="../common/sidebar.jsp" />

            <div class="app-main">
                <jsp:include page="../common/navbar.jsp" />

                <main class="app-content workspace-page space-y-6">
                    <!-- Filter và Search Glassmorphism Toolbar -->
                    <div
                        class="glass-panel p-5 rounded-3xl border border-slate-200/80 shadow-xs relative overflow-hidden">
                        <div
                            class="absolute -right-16 -top-16 w-36 h-36 bg-sky-400/10 rounded-full blur-2xl pointer-events-none">
                        </div>
                        <form method="get" action="${pageContext.request.contextPath}/student/topics"
                            class="topic-filter grid grid-cols-1 sm:grid-cols-12 gap-4 items-stretch relative z-10">
                            <!-- Search Input -->
                            <div class="sm:col-span-6 relative min-w-0">
                                <i data-lucide="search"
                                    class="w-4 h-4 text-slate-400 absolute left-3.5 top-1/2 -translate-y-1/2 pointer-events-none"></i>
                                <input type="text" name="keyword" value="${keyword}"
                                    placeholder="Tìm theo tên đề tài, mã số đề tài, giảng viên..."
                                    class="w-full pl-10 pr-4 py-2.5 bg-slate-50/80 border border-slate-200 rounded-2xl text-xs font-medium focus:bg-white focus:ring-2 focus:ring-sky-500/20 focus:border-sky-500 focus:outline-none transition-all">
                            </div>

                            <!-- Period filter -->
                            <div class="sm:col-span-6 min-w-0">
                                <label for="topicPeriod" class="sr-only">Đợt đăng ký đang mở</label>
                                <select id="topicPeriod" name="periodId" onchange="this.form.requestSubmit()" class="w-full px-4 py-2.5 bg-white border border-slate-200 rounded-xl text-sm" ${not empty groupPeriod or empty openPeriods ? 'disabled' : ''}>
                                    <c:if test="${not empty groupPeriod}">
                                        <option value="${groupPeriod.id}" selected><c:out value="${groupPeriod.name}" /></option>
                                    </c:if>
                                    <c:if test="${empty groupPeriod}">
                                    <option value="">-- Chọn đợt đăng ký --</option>
                                    <c:forEach items="${openPeriods}" var="period">
                                        <option value="${period.id}" ${selectedPeriodId == period.id ? 'selected' : ''}><c:out value="${period.name}" /></option>
                                    </c:forEach>
                                    </c:if>
                                </select>
                                <c:if test="${not empty groupPeriod}">
                                    <input type="hidden" name="periodId" value="${groupPeriod.id}">                                
                                </c:if>
                            </div>
                            <!-- Department badge -->
                            <div
                                class="topic-filter-department sm:col-span-6 px-4 py-2.5 bg-sky-50/70 border border-sky-200/80 rounded-xl text-xs font-semibold text-sky-800 flex items-center gap-2 min-w-0">
                                <i data-lucide="building-2" class="w-4 h-4 text-sky-600 shrink-0"></i>
                                <span class="break-words">Khoa: <strong><c:out value="${student.department != null ?
                                        student.department.name : 'Chưa cập nhật'}" /></strong></span>
                            </div>

                            <!-- Filter Button -->
                            <div class="sm:col-span-6 flex justify-end">
                                <button type="submit" class="btn-ui btn-ui-primary w-full justify-center">
                                    <i data-lucide="filter" class="w-4 h-4"></i> Lọc đề tài
                                </button>
                            </div>
                        </form>
                        <c:if test="${empty openPeriods}"><p class="mt-3 text-sm text-amber-700">Chưa có đợt nào đang trong thời hạn sinh viên đăng ký.</p></c:if>
                    </div>

                    <!-- No Group Warning Banner -->
                    <c:if test="${workflowCompleted}">
                        <div class="p-4 rounded-xl border border-emerald-200 bg-emerald-50 text-emerald-800 flex flex-wrap items-center justify-between gap-3">
                            <div><strong>Đã hoàn thành đề tài</strong><p class="text-sm mt-1 mb-0">Bạn đã hoàn tất đề tài của nhóm. Có thể xem kết quả và tiếp tục tra cứu các đợt đang mở.</p></div>
                            <a href="${pageContext.request.contextPath}/student/results" class="btn-ui btn-ui-outline">Xem kết quả</a>
                        </div>
                    </c:if>
                    <c:if test="${empty myGroup && !workflowCompleted}">
                        <div
                            class="bg-amber-500/10 border border-amber-300/80 text-amber-900 p-4 sm:p-5 rounded-3xl flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3 text-xs shadow-xs backdrop-blur-sm">
                            <div class="flex items-center gap-3">
                                <div
                                    class="w-10 h-10 rounded-2xl bg-amber-500/20 text-amber-700 flex items-center justify-center shrink-0">
                                    <i data-lucide="alert-triangle" class="w-5 h-5"></i>
                                </div>
                                <div>
                                    <div class="font-bold text-amber-950 text-sm">Bạn chưa có nhóm sinh viên</div>
                                    <p class="text-amber-800 mt-0.5">Vui lòng tạo nhóm hoặc gia nhập nhóm trước khi gửi
                                        yêu cầu đăng ký đề tài.</p>
                                </div>
                            </div>
                            <a href="${pageContext.request.contextPath}/student/group"
                                class="btn-ui btn-ui-primary shrink-0 text-xs py-2 px-4 shadow-sm">
                                Tạo nhóm ngay <i data-lucide="arrow-right" class="w-3.5 h-3.5"></i>
                            </a>
                        </div>
                    </c:if>

                    <!-- 3-Column Card GRID of Topics -->
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6" data-pagination-list>
                        <c:forEach var="t" items="${topics}">
                            <div data-pagination-item
                                class="bg-white rounded-3xl border border-slate-200/90 p-6 shadow-xs hover:shadow-xl hover:-translate-y-1 transition-all duration-300 flex flex-col justify-between group relative overflow-hidden">
                                <!-- Subtle top gradient accent -->
                                <div
                                    class="absolute top-0 left-0 right-0 h-1 bg-gradient-to-r from-sky-400 via-blue-500 to-indigo-500 opacity-0 group-hover:opacity-100 transition-opacity">
                                </div>

                                <div>
                                    <!-- Header Badges -->
                                    <div class="flex items-start justify-between gap-2 mb-3">
                                        <span
                                            class="px-2.5 py-1 rounded-xl font-mono font-bold text-xs bg-sky-50 text-sky-700 border border-sky-200/80 shadow-2xs">
                                            ${t.code}
                                        </span>
                                        <span
                                            class="px-2.5 py-0.5 rounded-lg text-[10px] font-bold uppercase tracking-wider bg-slate-100 text-slate-600 border border-slate-200/80">
                                            <c:out value="${t.department.name}" />
                                        </span>
                                    </div>

                                    <!-- Topic Title -->
                                    <h4
                                        class="text-sm font-bold text-slate-900 group-hover:text-sky-600 transition-colors leading-snug break-words mb-2.5">
                                        <c:out value="${t.title}" />
                                    </h4>

                                    <!-- Description -->
                                    <p class="text-xs text-slate-500 line-clamp-3 leading-relaxed mb-3.5">
                                        <c:out value="${t.description}" />
                                    </p>

                                    <!-- Requirements -->
                                    <c:if test="${not empty t.requirements}">
                                        <div
                                            class="bg-slate-50/80 p-3 rounded-2xl border border-slate-200/60 text-[11px] text-slate-600 mb-3 flex items-start gap-2">
                                            <i data-lucide="code-2"
                                                class="w-3.5 h-3.5 text-sky-600 mt-0.5 shrink-0"></i>
                                            <span class="line-clamp-2"><strong>Yêu cầu:</strong>
                                                <c:out value="${t.requirements}" /></span>
                                        </div>
                                    </c:if>
                                </div>

                                <!-- Footer: Supervisor Info và Registration Action -->
                                <div class="pt-3.5 border-t border-slate-100/90 space-y-3 mt-2">
                                    <div class="text-xs text-slate-700">
                                        <div class="flex items-center gap-2 font-semibold">
                                            <i data-lucide="user-check" class="w-3.5 h-3.5 text-sky-600 shrink-0"></i>
                                            <span class="truncate">GVHD: <strong><c:out value="${t.lecturer != null ?
                                                    t.lecturer.user.fullName : 'Chưa phân công'}" /></strong></span>
                                        </div>
                                        <c:if test="${not empty t.coLecturer}">
                                            <div class="text-[11px] text-slate-500 ml-5.5 mt-0.5 truncate">
                                                Đồng HD: ${t.coLecturer.user.fullName}
                                            </div>
                                        </c:if>
                                    </div>

                                    <div class="flex items-center justify-between pt-1">
                                        <span
                                            class="text-[11px] font-semibold text-slate-500 bg-slate-100 px-2.5 py-1 rounded-lg border border-slate-200/80">
                                            Tối đa: <strong class="text-slate-700">${t.maxStudents}</strong> SV
                                        </span>

                                        <c:choose>
                                            <c:when test="${workflowCompleted || t.status == 'COMPLETED'}">
                                                <span class="status-badge status-success"><i data-lucide="check-circle-2" class="w-3 h-3"></i> Đã hoàn thành</span>
                                            </c:when>
                                            <%-- Case 1: Is Leader và (No Active Registration or Rejected) -> Can
                                                Register --%>
                                                <c:when
                                                    test="${not empty myGroup && myGroup.leader.id == student.id && (empty myRegistration || myRegistration.status == 'REJECTED')}">
                                                    <button type="button"
                                                        class="btn-ui btn-ui-primary text-xs !py-0 px-3.5 !h-8 !min-h-0 flex items-center justify-center gap-1 shadow-sm leading-none"
                                                        data-bs-toggle="modal"
                                                        data-bs-target="#registerTopicModal_${t.id}">
                                                        <i data-lucide="send" class="w-3.5 h-3.5"></i> Đăng Ký
                                                    </button>
                                                </c:when>

                                                <%-- Case 2: Group already registered this topic --%>
                                                    <c:when
                                                        test="${not empty myRegistration && myRegistration.topic.id == t.id}">
                                                        <span class="status-badge status-success">
                                                            <i data-lucide="check-circle" class="w-3 h-3"></i> ĐÃ ĐĂNG
                                                            KÝ
                                                        </span>
                                                    </c:when>

                                                    <%-- Case 3: In a group but NOT leader -> Badge enforcement --%>
                                                        <c:when
                                                            test="${not empty myGroup && myGroup.leader.id != student.id}">
                                                            <span
                                                                class="px-2.5 py-1 rounded-lg text-[10px] font-bold bg-slate-100 text-slate-500 border border-slate-200"
                                                                title="Chỉ tài khoản Trưởng nhóm mới có quyền thay mặt nhóm gửi đơn đăng ký">
                                                                Chỉ Nhóm trưởng đăng ký
                                                            </span>
                                                        </c:when>

                                                        <%-- Case 4: No group created yet --%>
                                                            <c:when test="${not empty myRegistration}">
                                                                <span class="status-badge status-info">${myRegistration.status == 'PENDING' ? 'Nhóm đang chờ duyệt' : 'Nhóm đã có đề tài'}</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <button type="button" disabled
                                                                    class="px-3 py-1.5 bg-slate-100 text-slate-400 text-xs font-semibold rounded-xl cursor-not-allowed border border-slate-200">
                                                                    Cần lập nhóm trước
                                                                </button>
                                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>

                            <!-- Registration Modal for Leader -->
                            <c:if test="${not workflowCompleted && not empty myGroup && myGroup.leader.id == student.id && empty myRegistration}">
                                <div class="modal fade" id="registerTopicModal_${t.id}" tabindex="-1"
                                    aria-hidden="true">
                                    <div class="modal-dialog modal-dialog-centered">
                                        <div
                                            class="modal-content rounded-3xl border-0 shadow-2xl overflow-hidden backdrop-blur-md">
                                            <form method="post"
                                                action="${pageContext.request.contextPath}/student/topics/register">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                                <input type="hidden" name="topicId" value="${t.id}">
                                                <input type="hidden" name="groupId" value="${myGroup.id}">

                                                <div
                                                    class="modal-header-hero px-6 py-4 text-white flex justify-between items-center">
                                                    <h5 class="text-base font-bold flex items-center gap-2">
                                                        <i data-lucide="send" class="w-5 h-5 text-sky-200"></i> Xác Nhận
                                                        Đăng Ký Đề Tài
                                                    </h5>
                                                    <button type="button"
                                                        class="text-white/80 hover:text-white p-1 rounded-lg transition-colors"
                                                        data-bs-dismiss="modal">
                                                        <i data-lucide="x" class="w-5 h-5"></i>
                                                    </button>
                                                </div>

                                                <div class="p-6 space-y-4">
                                                    <div
                                                        class="bg-sky-500/10 border border-sky-300/80 text-sky-950 rounded-2xl p-3.5 text-xs flex items-start gap-2.5">
                                                        <i data-lucide="info"
                                                            class="w-4 h-4 text-sky-600 shrink-0 mt-0.5"></i>
                                                        <div class="leading-relaxed">
                                                            Bạn đang đại diện nhóm <strong><c:out value="${myGroup.name}" /></strong> gửi
                                                            yêu cầu đăng ký đề tài này tới Khoa và Giảng viên hướng dẫn.
                                                        </div>
                                                    </div>

                                                    <div
                                                        class="p-4 bg-slate-50 border border-slate-200/80 rounded-2xl space-y-1.5">
                                                        <div class="font-mono font-bold text-xs text-sky-600">
                                                            [${t.code}]</div>
                                                        <div class="font-bold text-slate-900 text-sm"><c:out value="${t.title}" /></div>
                                                        <div
                                                            class="text-xs text-slate-500 flex items-center gap-2 flex-wrap pt-1">
                                                            <span>GVHD: <strong><c:out value="${t.lecturer != null ?
                                                                    t.lecturer.user.fullName : 'N/A'}" /></strong></span>
                                                            <span>&bull;</span>
                                                            <span>Khoa: ${t.department.name}</span>
                                                        </div>
                                                    </div>

                                                    <div>
                                                        <label class="block text-xs font-bold text-slate-700 mb-1.5">
                                                            Ghi chú gửi Giảng viên hướng dẫn / Ban chủ nhiệm Khoa
                                                        </label>
                                                        <textarea name="note" rows="3"
                                                            class="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-2xl text-xs focus:bg-white focus:ring-2 focus:ring-sky-500/20 focus:border-sky-500 focus:outline-none transition-all"
                                                            placeholder="Nêu lý do chọn đề tài, kinh nghiệm của nhóm hoặc các công nghệ đã chuẩn bị..."></textarea>
                                                    </div>
                                                </div>

                                                <div
                                                    class="bg-slate-50/80 px-6 py-4 border-t border-slate-100 flex justify-end gap-3">
                                                    <button type="button"
                                                        class="btn-ui btn-ui-outline text-xs py-2 px-4"
                                                        data-bs-dismiss="modal">Hủy</button>
                                                    <button type="submit"
                                                        class="btn-ui btn-ui-primary text-xs py-2 px-5 shadow-sm">
                                                        <i data-lucide="send" class="w-4 h-4"></i> Gửi Yêu Cầu Đăng Ký
                                                    </button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>

                    <c:if test="${empty topics}">
                        <div class="empty-state py-16 bg-white rounded-3xl border border-slate-200 shadow-sm">
                            <div class="empty-state-icon-wrap w-14 h-14 mb-3">
                                <i data-lucide="inbox" class="w-7 h-7 opacity-40"></i>
                            </div>
                            <div class="empty-state-title text-base font-bold text-slate-800">Không tìm thấy đề tài nào
                            </div>
                            <div class="empty-state-desc text-xs text-slate-500 mt-1 max-w-sm mx-auto">
                                <c:choose>
                                    <c:when test="${empty myGroup}">Chọn một đợt đang mở để xem đề tài. Bạn cần có nhóm trước khi đăng ký.</c:when>
                                    <c:otherwise>Chưa có đề tài phù hợp trong đợt đã chọn. Thử từ khóa khác hoặc liên hệ Khoa.</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:if>
                </main>

                <jsp:include page="../common/footer.jsp" />

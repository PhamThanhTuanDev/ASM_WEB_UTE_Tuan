<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle" value="Tra cứu & đăng ký đề tài" />
<c:set var="pageHeading" value="Danh mục đề tài công bố cho sinh viên" />
<c:set var="pageSubheading" value="Tra cứu các đề tài đã duyệt của đợt và gửi yêu cầu đăng ký đại diện bởi Nhóm trưởng" />
<c:set var="activeMenu" value="topics" />

<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/sidebar.jsp" />

<div class="app-main">
    <jsp:include page="../common/navbar.jsp" />

    <main class="app-content space-y-6">
        <!-- Filter & Search Toolbar -->
        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-xs">
            <form method="get" action="${pageContext.request.contextPath}/student/topics" class="grid grid-cols-1 sm:grid-cols-3 lg:grid-cols-4 gap-3 items-center">
                <!-- Search Input -->
                <div class="sm:col-span-2 relative">
                    <i data-lucide="search" class="w-4 h-4 text-slate-400 absolute left-3.5 top-1/2 -translate-y-1/2"></i>
                    <input type="text" name="keyword" value="${keyword}" placeholder="Tìm theo tên đề tài, mã đề tài, GVHD..." 
                           class="w-full pl-10 pr-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs focus:bg-white focus:ring-2 focus:ring-blue-500 focus:outline-none">
                </div>

                <!-- Department Filter -->
                <div>
                    <select name="departmentId" onchange="this.form.submit()" class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs font-semibold text-slate-700 focus:bg-white focus:ring-2 focus:ring-blue-500 focus:outline-none">
                        <option value="">-- Tất cả bộ môn --</option>
                        <c:forEach var="d" items="${departments}">
                            <option value="${d.id}" ${selectedDept == d.id ? 'selected' : ''}>${d.name}</option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Filter Button -->
                <div>
                    <button type="submit" class="w-full inline-flex items-center justify-center gap-2 px-4 py-2.5 bg-blue-600 hover:bg-blue-700 text-white text-xs font-bold rounded-xl shadow-sm hover:shadow-md transition-all duration-200">
                        <i data-lucide="filter" class="w-4 h-4"></i> Lọc đề tài
                    </button>
                </div>
            </form>
        </div>

        <!-- No Group Warning Banner -->
        <c:if test="${empty myGroup}">
            <div class="bg-amber-50 border border-amber-200 text-amber-900 p-4 rounded-2xl flex items-center justify-between gap-3 text-xs shadow-xs">
                <div class="flex items-center gap-2.5">
                    <i data-lucide="alert-triangle" class="w-5 h-5 text-amber-600 shrink-0"></i>
                    <span>Bạn chưa có nhóm sinh viên. Vui lòng tạo nhóm hoặc gia nhập nhóm trước khi gửi yêu cầu đăng ký đề tài.</span>
                </div>
                <a href="${pageContext.request.contextPath}/student/group" class="px-3.5 py-1.5 bg-amber-600 hover:bg-amber-700 text-white font-bold rounded-xl shrink-0 transition-colors">
                    Tạo nhóm ngay &rarr;
                </a>
            </div>
        </c:if>

        <!-- 3-Column Card GRID of Topics -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <c:forEach var="t" items="${topics}">
                <div class="bg-white rounded-2xl border border-slate-200 p-5 shadow-xs hover:shadow-md transition-all duration-200 flex flex-col justify-between group">
                    <div>
                        <!-- Header Badges -->
                        <div class="flex items-center justify-between mb-3">
                            <span class="px-2.5 py-1 rounded-lg font-mono font-bold text-xs bg-blue-50 text-blue-700 border border-blue-200">
                                ${t.code}
                            </span>
                            <span class="px-2.5 py-0.5 rounded-md text-[10px] font-semibold bg-slate-100 text-slate-600 border border-slate-200">
                                ${t.department.name}
                            </span>
                        </div>

                        <!-- Topic Title -->
                        <h4 class="text-sm font-bold text-slate-900 group-hover:text-blue-600 transition-colors leading-snug line-clamp-2 mb-2">
                            ${t.title}
                        </h4>

                        <!-- Description -->
                        <p class="text-xs text-slate-500 line-clamp-3 leading-relaxed mb-3">
                            ${t.description}
                        </p>

                        <!-- Requirements -->
                        <c:if test="${not empty t.requirements}">
                            <div class="bg-slate-50 p-2.5 rounded-xl border border-slate-100 text-[11px] text-slate-600 mb-3 flex items-start gap-1.5">
                                <i data-lucide="code-2" class="w-3.5 h-3.5 text-blue-600 mt-0.5 shrink-0"></i>
                                <span class="line-clamp-2"><strong>Yêu cầu:</strong> ${t.requirements}</span>
                            </div>
                        </c:if>
                    </div>

                    <!-- Footer: Supervisor Info & Registration Action -->
                    <div class="pt-3.5 border-t border-slate-100 space-y-3">
                        <div class="text-xs text-slate-700">
                            <div class="flex items-center gap-1.5 font-semibold">
                                <i data-lucide="user-check" class="w-3.5 h-3.5 text-blue-600"></i>
                                <span>GVHD: ${t.lecturer != null ? t.lecturer.user.fullName : 'Chưa phân công'}</span>
                            </div>
                            <c:if test="${not empty t.coLecturer}">
                                <div class="text-[11px] text-slate-500 ml-5 mt-0.5">
                                    Đồng HD: ${t.coLecturer.user.fullName}
                                </div>
                            </c:if>
                        </div>

                        <div class="flex items-center justify-between pt-1">
                            <span class="text-[11px] font-semibold text-slate-500 bg-slate-100 px-2 py-0.5 rounded-md border border-slate-200">
                                Tối đa: ${t.maxStudents} SV
                            </span>

                            <c:choose>
                                <%-- Case 1: Is Leader & (No Active Registration or Rejected) -> Can Register --%>
                                <c:when test="${not empty myGroup && myGroup.leader.id == student.id && (empty myRegistration || myRegistration.status == 'REJECTED')}">
                                    <button type="button" class="inline-flex items-center gap-1.5 px-3.5 py-1.5 bg-blue-600 hover:bg-blue-700 text-white font-bold rounded-xl text-xs shadow-xs hover:shadow-md transition-all duration-200" 
                                            data-bs-toggle="modal" data-bs-target="#registerTopicModal_${t.id}">
                                        <i data-lucide="send" class="w-3.5 h-3.5"></i> Đăng Ký
                                    </button>
                                </c:when>

                                <%-- Case 2: Group already registered this topic --%>
                                <c:when test="${not empty myRegistration && myRegistration.topic.id == t.id}">
                                    <span class="px-2.5 py-1 rounded-lg text-[11px] font-bold bg-emerald-100 text-emerald-800 border border-emerald-200">
                                        ĐÃ ĐĂNG KÝ
                                    </span>
                                </c:when>

                                <%-- Case 3: In a group but NOT leader -> Badge enforcement --%>
                                <c:when test="${not empty myGroup && myGroup.leader.id != student.id}">
                                    <span class="px-2 py-1 rounded-lg text-[10px] font-bold bg-slate-100 text-slate-500 border border-slate-200" title="Chỉ tài khoản Trưởng nhóm mới có quyền thay mặt nhóm gửi đơn đăng ký">
                                        Chỉ Nhóm trưởng mới có quyền đăng ký
                                    </span>
                                </c:when>

                                <%-- Case 4: No group created yet --%>
                                <c:otherwise>
                                    <button type="button" disabled class="px-3 py-1 bg-slate-100 text-slate-400 text-xs font-semibold rounded-xl cursor-not-allowed border border-slate-200">
                                        Cần lập nhóm trước
                                    </button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <!-- Registration Modal for Leader -->
                <c:if test="${not empty myGroup && myGroup.leader.id == student.id}">
                    <div class="modal fade" id="registerTopicModal_${t.id}" tabindex="-1">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content rounded-3xl border-0 shadow-2xl overflow-hidden">
                                <form method="post" action="${pageContext.request.contextPath}/student/topics/register">
                                    <input type="hidden" name="topicId" value="${t.id}">
                                    <input type="hidden" name="groupId" value="${myGroup.id}">

                                    <div class="bg-gradient-to-r from-blue-600 to-indigo-700 px-6 py-4 text-white flex justify-between items-center">
                                        <h5 class="text-base font-bold flex items-center gap-2">
                                            <i data-lucide="send" class="w-5 h-5"></i> Xác Nhận Đăng Ký Đề Tài
                                        </h5>
                                        <button type="button" class="text-white/80 hover:text-white p-1" data-bs-dismiss="modal">
                                            <i data-lucide="x" class="w-5 h-5"></i>
                                        </button>
                                    </div>

                                    <div class="p-6 space-y-4">
                                        <div class="bg-blue-50 border border-blue-200 text-blue-900 rounded-2xl p-3 text-xs flex items-start gap-2">
                                            <i data-lucide="info" class="w-4 h-4 text-blue-600 shrink-0 mt-0.5"></i>
                                            <div>
                                                Bạn đang đại diện nhóm <strong>${myGroup.name}</strong> gửi yêu cầu đăng ký đề tài này tới Khoa & Giảng viên hướng dẫn.
                                            </div>
                                        </div>

                                        <div class="p-3.5 bg-slate-50 border border-slate-200 rounded-2xl space-y-1">
                                            <div class="font-mono font-bold text-xs text-blue-600">[${t.code}]</div>
                                            <div class="font-bold text-slate-900 text-xs">${t.title}</div>
                                            <div class="text-[11px] text-slate-500">GVHD: ${t.lecturer != null ? t.lecturer.user.fullName : 'N/A'} &bull; Bộ môn: ${t.department.name}</div>
                                        </div>

                                        <div>
                                            <label class="block text-xs font-bold text-slate-700 mb-1">
                                                Ghi chú gửi Giảng viên hướng dẫn / Ban chủ nhiệm Khoa
                                            </label>
                                            <textarea name="note" rows="3" class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs focus:bg-white focus:ring-2 focus:ring-blue-500 focus:outline-none" placeholder="Nêu lý do chọn đề tài, thế mạnh của nhóm hoặc các công nghệ đã chuẩn bị..."></textarea>
                                        </div>
                                    </div>

                                    <div class="bg-slate-50 px-6 py-4 border-t border-slate-100 flex justify-end gap-3">
                                        <button type="button" class="px-4 py-2 bg-white border border-slate-200 text-slate-700 text-xs font-bold rounded-xl hover:bg-slate-100 transition-colors" data-bs-dismiss="modal">Hủy</button>
                                        <button type="submit" class="px-5 py-2 bg-blue-600 hover:bg-blue-700 text-white text-xs font-bold rounded-xl shadow-sm hover:shadow-md transition-all">
                                            Gửi Yêu Cầu Đăng Ký
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:if>
            </c:forEach>
        </div>
    </main>

<jsp:include page="../common/footer.jsp" />


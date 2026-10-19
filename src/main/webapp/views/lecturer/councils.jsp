<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <c:set scope="request" var="pageTitle" value="Hội đồng phản biện giảng viên" />
            <c:set scope="request" var="pageHeading" value="Hội đồng phản biện và chấm điểm đề tài" />
            <c:set scope="request" var="pageSubheading" value="Danh sách hội đồng tham gia và các đề tài được phân công chấm điểm" />
            <c:set scope="request" var="activeMenu" value="councils" />

            <jsp:include page="../common/header.jsp" />
            <jsp:include page="../common/sidebar.jsp" />

            <div class="app-main">
                <jsp:include page="../common/navbar.jsp" />

                <main class="app-content workspace-page space-y-6">
                    <!-- Anti-supervision Rule Alert Banner -->
                    <div
                        class="bg-gradient-to-r from-sky-50 to-indigo-50 border border-sky-200 text-sky-950 p-5 rounded-3xl flex items-start gap-3.5 shadow-sm">
                        <div class="p-2.5 rounded-2xl bg-sky-600 text-white shrink-0 shadow-xs">
                            <i data-lucide="shield-alert" class="w-5 h-5"></i>
                        </div>
                        <div class="text-xs leading-relaxed">
                            <h6 class="font-extrabold text-slate-900 text-sm mb-1">Quy định nghiệp vụ độc lập và bảo mật
                                chấm điểm:</h6>
                            <p class="text-slate-600">
                                Hệ thống tự động khóa quyền chấm điểm và phản biện đối với đề tài mà chính Thầy/Cô đang
                                là <strong>Giảng viên Hướng dẫn chính</strong> hoặc <strong>Đồng hướng dẫn</strong> để
                                bảo đảm tính minh bạch và khách quan.
                            </p>
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${empty myCouncilMembers}">
                            <div class="empty-state py-16 bg-white rounded-3xl border border-slate-200 shadow-sm">
                                <div class="empty-state-icon-wrap w-14 h-14 mb-3">
                                    <i data-lucide="scale" class="w-7 h-7 opacity-40"></i>
                                </div>
                                <h4 class="empty-state-title">Chưa có hội đồng được phân công</h4>
                                <p class="empty-state-desc max-w-md mx-auto">
                                    Chưa có đề tài được phân công cho các hội đồng Thầy/Cô tham gia.
                                    Khi Trưởng khoa phân công đề tài, hội đồng sẽ xuất hiện tại đây.
                                </p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="space-y-6">
                                <c:forEach var="mc" items="${myCouncilMembers}">
                                    <div class="table-shell">
                                        <!-- Council Header -->
                                        <div
                                            class="bg-white p-5 border-b border-slate-100 flex flex-col md:flex-row md:items-center justify-between gap-3">
                                            <div class="flex items-center gap-3 flex-wrap">
                                                <span
                                                    class="code-tag font-bold text-xs bg-slate-900 border-slate-900">
                                                    ${mc.council.code}
                                                </span>
                                                <h3 class="text-base font-extrabold text-slate-900"><c:out value="${mc.council.name}" />
                                                </h3>
                                                <c:choose>
                                                    <c:when test="${mc.role == 'CHAIRMAN'}">
                                                        <span
                                                            class="status-badge status-pending flex items-center gap-1">
                                                            <i data-lucide="crown"
                                                                class="w-3.5 h-3.5 text-amber-600"></i> CHỦ TỊCH HỘI
                                                            ĐỒNG
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${mc.role == 'SECRETARY'}">
                                                        <span class="status-badge status-info flex items-center gap-1">
                                                            <i data-lucide="feather"
                                                                class="w-3.5 h-3.5 text-sky-600"></i> THƯ KÝ HỘI ĐỒNG
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge status-neutral">
                                                            ỦY VIÊN PHẢN BIỆN
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="flex items-center gap-4 text-xs text-slate-600">
                                                <span
                                                    class="flex items-center gap-1.5 font-bold text-slate-700 whitespace-nowrap">
                                                    <i data-lucide="calendar" class="w-4 h-4 text-sky-600"></i>
                                                    ${mc.council.councilDate != null ? dateDisplay.format(mc.council.councilDate) : 'Chưa
                                                    định'}
                                                </span>
                                                <span
                                                    class="flex items-center gap-1.5 font-bold text-slate-700 whitespace-nowrap">
                                                    <i data-lucide="map-pin" class="w-4 h-4 text-rose-500"></i>
                                                    ${mc.council.location != null ? mc.council.location : 'Chưa định'}
                                                </span>
                                            </div>
                                        </div>

                                        <!-- Topic Assignments Table -->
                                        <div>
                                            <c:set var="assignments"
                                                value="${assignmentsByCouncil[mc.council.id]}" />
                                            <c:choose>
                                                <c:when test="${empty assignments}">
                                                    <div class="empty-state py-8">
                                                        <div class="empty-state-icon-wrap w-10 h-10 mb-2">
                                                            <i data-lucide="inbox" class="w-5 h-5 opacity-40"></i>
                                                        </div>
                                                        <div class="empty-state-desc text-xs mb-0">Chưa có đề tài nào
                                                            được phân công vào Hội đồng này</div>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="overflow-x-auto">
                                                        <table class="w-full text-left border-collapse">
                                                            <thead>
                                                                <tr>
                                                                    <th class="w-[34%]">Mã và Tên Đề tài</th>
                                                                    <th class="w-[24%]">Nhóm Sinh viên</th>
                                                                    <th class="w-[18%]">Giảng viên Hướng dẫn</th>
                                                                    <th class="w-[12%] text-center">Tình trạng</th>
                                                                    <th class="text-right w-[12%]">Thao tác</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody class="divide-y divide-slate-100 text-xs">
                                                                <c:forEach var="assign" items="${assignments}">
                                                                    <c:set var="isSupervisor"
                                                                        value="${(assign.topicRegistration.topic.lecturer != null && assign.topicRegistration.topic.lecturer.id == lecturer.id) || (assign.topicRegistration.topic.coLecturer != null && assign.topicRegistration.topic.coLecturer.id == lecturer.id) || scoringService.isLecturerSupervisingTopic(lecturer.id, assign.topicRegistration.topic.id)}" />
                                                                    <tr class="hover:bg-slate-50/80 transition-colors">
                                                                        <td class="align-top">
                                                                            <span
                                                                                class="code-tag">${assign.topicRegistration.topic.code}</span>
                                                                            <div
                                                                                class="font-bold text-slate-900 leading-snug mt-1">
                                                                                <c:out value="${assign.topicRegistration.topic.title}" />
                                                                            </div>
                                                                            <div
                                                                                class="text-[11px] text-slate-500 mt-1">
                                                                                <c:out value="${assign.topicRegistration.topic.department.name}" />
                                                                            </div>
                                                                        </td>

                                                                        <td class="align-top">
                                                                            <div
                                                                                class="font-bold text-slate-800 leading-snug mb-1">
                                                                                <c:out value="${assign.topicRegistration.group.name}" />
                                                                            </div>
                                                                            <div
                                                                                class="font-bold text-slate-800 leading-snug whitespace-nowrap">
                                                                                ${assign.topicRegistration.group.leader.user.fullName}
                                                                                (Nhóm trưởng)
                                                                            </div>
                                                                            <div
                                                                                class="text-[11px] text-slate-500 mt-0.5">
                                                                                MSSV: <strong
                                                                                    class="text-slate-800">${assign.topicRegistration.group.leader.studentCode}</strong>
                                                                            </div>
                                                                            <c:if
                                                                                test="${not empty assign.topicRegistration.group.leader.className}">
                                                                                <div class="text-[11px] text-slate-500">
                                                                                    Lớp:
                                                                                    ${assign.topicRegistration.group.leader.className}
                                                                                </div>
                                                                            </c:if>
                                                                        </td>

                                                                        <td class="align-top">
                                                                            <div
                                                                                class="font-bold text-slate-800 leading-snug">
                                                                                <c:out value="${assign.topicRegistration.topic.lecturer
                                                                                != null ?
                                                                                assign.topicRegistration.topic.lecturer.user.fullName
                                                                                : 'N/A'}" />
                                                                            </div>
                                                                            <c:if
                                                                                test="${not empty assign.topicRegistration.topic.coLecturer}">
                                                                                <div
                                                                                    class="text-[11px] text-slate-500 mt-0.5">
                                                                                    Đồng HD:
                                                                                    ${assign.topicRegistration.topic.coLecturer.user.fullName}
                                                                                </div>
                                                                            </c:if>
                                                                        </td>

                                                                        <td
                                                                            class="align-middle text-center whitespace-nowrap">
                                                                            <c:choose>
                                                                                <c:when test="${isSupervisor}">
                                                                                    <span
                                                                                        class="status-badge status-danger">
                                                                                        <i data-lucide="ban"
                                                                                            class="w-3 h-3"></i> Bị chặn
                                                                                        (GVHD)
                                                                                    </span>
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <span
                                                                                        class="status-badge ${assign.status == 'EVALUATED' ? 'status-approved' : 'status-pending'}">
                                                                                        ${enumLabel.label(assign.status)}
                                                                                    </span>
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </td>

                                                                        <td
                                                                            class="align-middle text-right whitespace-nowrap">
                                                                            <c:choose>
                                                                                <c:when test="${isSupervisor}">
                                                                                    <button type="button"
                                                                                        class="btn-ui bg-slate-100 text-slate-400 text-xs py-1.5 px-3 cursor-not-allowed border border-slate-200"
                                                                                        title="Bạn là GVHD của đề tài này nên không thể chấm điểm">
                                                                                        <i data-lucide="lock"
                                                                                            class="w-3.5 h-3.5"></i>
                                                                                        Khóa chấm
                                                                                    </button>
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <a href="${pageContext.request.contextPath}/lecturer/grading/${assign.id}"
                                                                                        class="btn-ui btn-ui-primary text-xs py-1.5 px-3 shadow-xs">
                                                                                        <i data-lucide="pen-tool"
                                                                                            class="w-3.5 h-3.5"></i>
                                                                                        Chấm điểm
                                                                                    </a>
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </td>
                                                                    </tr>
                                                                </c:forEach>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </main>

                <jsp:include page="../common/footer.jsp" />

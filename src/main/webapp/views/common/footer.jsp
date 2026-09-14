<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <footer
            class="mt-auto py-4 px-6 bg-white/70 backdrop-blur-md border-t border-slate-200/80 text-center text-xs text-slate-500 flex flex-col sm:flex-row items-center justify-between gap-2 select-none">
            <div class="flex items-center gap-2">
                <span class="font-bold text-slate-700">Hệ thống Quản lý Đề tài Sinh viên &copy; 2026</span>
                <span class="text-slate-300">&bull;</span>
                <span class="text-sky-700 font-medium">Khoa Công nghệ Thông tin - HCMUTE</span>
            </div>
            <div class="text-[11px] text-slate-400 font-mono">
                HCMUTE Academic Platform &bull; Spring Boot + JSP MVC
            </div>
        </footer>
        </div> <!-- end app-main -->
        </div> <!-- end app-wrapper -->

        <!-- AI Assistant Chatbox Component -->
        <jsp:include page="ai-chatbox.jsp" />

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/enterprise-ui.js?v=4.4.1"></script>

        <style>
            .notification-target {
                outline: 3px solid rgba(0, 109, 168, 0.4);
                outline-offset: -2px;
                background-color: rgba(232, 244, 250, 0.9) !important;
                transition: outline-color .25s ease, background-color .25s ease;
            }
        </style>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const notificationId = new URLSearchParams(window.location.search).get('notificationId');
                if (!notificationId) return;

                const selectedNotification = document.querySelector('[data-notification-id="' + notificationId + '"]');
                if (!selectedNotification) return;

                selectedNotification.hidden = false;
                selectedNotification.classList.add('notification-target');
                selectedNotification.scrollIntoView({ behavior: 'smooth', block: 'center' });
                window.setTimeout(function () {
                    selectedNotification.classList.remove('notification-target');
                }, 2400);
            });
        </script>

        </body>

        </html>
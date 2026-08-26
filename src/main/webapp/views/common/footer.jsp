<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <footer class="mt-auto py-4 px-6 bg-white border-t border-slate-200/80 text-center text-xs text-slate-500 flex flex-col sm:flex-row items-center justify-between gap-2">
            <div class="flex items-center gap-2">
                <span class="font-bold text-slate-700">Hệ thống Quản lý Đề tài Sinh viên &copy; 2026</span>
                <span>&bull;</span>
                <span>Khoa CNTT - HCMUTE</span>
            </div>
            <div class="text-[11px] text-slate-400">
                Enterprise Dashboard v3.1 &bull; Spring Boot MVC + Tailwind + Fetch API
            </div>
        </footer>
    </div> <!-- end app-main -->
</div> <!-- end app-wrapper -->

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/enterprise-ui.js"></script>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        if (typeof lucide !== 'undefined') lucide.createIcons();
    });
</script>

</body>
</html>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%--
    Hiển thị thông báo flash (successMessage / errorMessage / infoMessage) mà Controller
    gửi qua RedirectAttributes.addFlashAttribute(...) sau khi redirect.
    Dùng chung cho các trang giảng viên: <jsp:include page="../common/flash.jsp" />
--%>
<c:if test="${not empty successMessage or not empty errorMessage or not empty infoMessage}">
    <div id="flash-data" hidden
         data-success="${fn:escapeXml(successMessage)}"
         data-error="${fn:escapeXml(errorMessage)}"
         data-info="${fn:escapeXml(infoMessage)}"></div>
    <script>
        (function () {
            var el = document.getElementById('flash-data');
            if (!el) return;
            // Ưu tiên hiện lỗi trước, sau đó tới thành công, cuối cùng là thông tin
            var type = el.dataset.error ? 'error' : (el.dataset.success ? 'success' : 'info');
            var text = el.dataset.error || el.dataset.success || el.dataset.info;
            function show() {
                if (window.Swal) {
                    Swal.fire({
                        toast: true, position: 'top-end', icon: type, title: text,
                        showConfirmButton: type === 'error', timer: type === 'error' ? undefined : 4500,
                        timerProgressBar: type !== 'error'
                    });
                    return;
                }
                // Dự phòng khi SweetAlert chưa tải được: hiện hộp thông báo đơn giản
                var box = document.createElement('div');
                box.textContent = text;
                box.style.cssText = 'position:fixed;top:16px;right:16px;z-index:9999;padding:12px 16px;border-radius:12px;'
                    + 'font:600 13px sans-serif;color:#fff;max-width:420px;box-shadow:0 8px 24px rgba(0,0,0,.2);background:'
                    + (type === 'error' ? '#dc2626' : (type === 'success' ? '#059669' : '#0284c7'));
                document.body.appendChild(box);
                setTimeout(function () { box.remove(); }, 6000);
            }
            if (document.readyState === 'loading') {
                document.addEventListener('DOMContentLoaded', show);
            } else {
                show();
            }
        })();
    </script>
</c:if>

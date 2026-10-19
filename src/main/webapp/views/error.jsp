<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- Trang báo lỗi chung (403, 404, 500...) do BasicErrorController của Spring Boot chuyển tới.
     Tự chứa CSS để vẫn hiển thị được khi không tải được CDN. --%>
<c:set var="code" value="${not empty status ? status : requestScope['jakarta.servlet.error.status_code']}" />
<c:set var="role" value="${sessionScope.user.role}" />
<c:choose>
    <c:when test="${role == 'ADMIN' or role == 'DEAN' or role == 'DEPARTMENT_HEAD'}"><c:set var="homeUrl" value="/admin/dashboard" /></c:when>
    <c:when test="${role == 'LECTURER'}"><c:set var="homeUrl" value="/lecturer/dashboard" /></c:when>
    <c:when test="${role == 'STUDENT'}"><c:set var="homeUrl" value="/student/dashboard" /></c:when>
    <c:otherwise><c:set var="homeUrl" value="/" /></c:otherwise>
</c:choose>
<c:choose>
    <c:when test="${code == 403}">
        <c:set var="title" value="Bạn không có quyền truy cập" />
        <c:set var="detail" value="Chức năng này dành cho vai trò khác. Hãy quay về trang của bạn hoặc đăng nhập bằng tài khoản phù hợp." />
    </c:when>
    <c:when test="${code == 404}">
        <c:set var="title" value="Không tìm thấy trang" />
        <c:set var="detail" value="Đường dẫn không tồn tại hoặc dữ liệu đã bị xóa. Vui lòng kiểm tra lại địa chỉ." />
    </c:when>
    <c:when test="${code == 401}">
        <c:set var="title" value="Phiên đăng nhập đã hết hạn" />
        <c:set var="detail" value="Vui lòng đăng nhập lại để tiếp tục sử dụng hệ thống." />
    </c:when>
    <c:otherwise>
        <c:set var="title" value="Hệ thống đang gặp sự cố" />
        <c:set var="detail" value="Yêu cầu chưa được xử lý. Vui lòng thử lại sau ít phút hoặc liên hệ quản trị viên." />
    </c:otherwise>
</c:choose>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${code} - ${title} | Cổng Quản Lý Đề Tài HCMUTE</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logo/logo_hcmute.png">
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; }
        body {
            margin: 0; min-height: 100vh; display: flex; align-items: center; justify-content: center;
            padding: 24px; font-family: "Be Vietnam Pro", system-ui, sans-serif; color: #0f172a;
            background: linear-gradient(135deg, #f0f9ff 0%, #e2e8f0 100%);
        }
        .card {
            width: 100%; max-width: 520px; background: #fff; border-radius: 24px; padding: 40px 36px;
            text-align: center; box-shadow: 0 20px 50px rgba(0, 56, 101, .12); border: 1px solid #e2e8f0;
        }
        .logo { width: 64px; height: 64px; object-fit: contain; }
        .code { margin: 16px 0 4px; font-size: 64px; font-weight: 800; line-height: 1; color: #00568c; }
        h1 { margin: 8px 0 12px; font-size: 22px; font-weight: 700; }
        p { margin: 0 0 28px; font-size: 15px; line-height: 1.6; color: #475569; }
        .actions { display: flex; gap: 12px; justify-content: center; flex-wrap: wrap; }
        a.btn {
            display: inline-block; padding: 11px 22px; border-radius: 12px; font-weight: 600; font-size: 14px;
            text-decoration: none; transition: background .15s;
        }
        .primary { background: #006da8; color: #fff; }
        .primary:hover { background: #00568c; }
        .ghost { background: #f1f5f9; color: #0f172a; }
        .ghost:hover { background: #e2e8f0; }
        .path { margin-top: 24px; font-size: 12px; color: #94a3b8; word-break: break-all; }
    </style>
</head>
<body>
<main class="card">
    <img class="logo" src="${pageContext.request.contextPath}/assets/img/logo/logo_hcmute.png" alt="HCMUTE">
    <div class="code"><c:out value="${code}" /></div>
    <h1><c:out value="${title}" /></h1>
    <p><c:out value="${detail}" /></p>
    <div class="actions">
        <a class="btn primary" href="${pageContext.request.contextPath}${homeUrl}">Về trang chủ của tôi</a>
        <c:choose>
            <c:when test="${empty sessionScope.user}">
                <a class="btn ghost" href="${pageContext.request.contextPath}/login">Đăng nhập</a>
            </c:when>
            <c:otherwise>
                <a class="btn ghost" href="javascript:history.back()">Quay lại</a>
            </c:otherwise>
        </c:choose>
    </div>
    <c:if test="${not empty path}">
        <div class="path">Đường dẫn: <c:out value="${path}" /></div>
    </c:if>
</main>
</body>
</html>

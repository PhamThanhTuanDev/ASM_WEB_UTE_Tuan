<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký - HCMUTE</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logo/logo_hcmute.png">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/custom-theme.css">
    <style>
        .page-loader { position: fixed; inset: 0; z-index: 9999; display: flex; align-items: center; justify-content: center; background: #0b1b3a; opacity: 1; visibility: visible; transition: opacity .35s ease, visibility .35s ease; }
        .page-loader.is-hidden { opacity: 0; visibility: hidden; pointer-events: none; }
        .page-loader-content { display: flex; flex-direction: column; align-items: center; gap: 18px; }
        .page-loader-logo-wrap { position: relative; display: flex; align-items: center; justify-content: center; width: 136px; height: 136px; }
        .page-loader-logo-wrap::before { position: absolute; inset: 0; border: 3px solid rgba(147,197,253,.22); border-top-color: #60a5fa; border-right-color: #fbbf24; border-radius: 50%; animation: loaderSpin 1.1s linear infinite; content: ''; }
        .page-loader-logo-wrap::after { position: absolute; inset: 13px; border: 1px solid rgba(255,255,255,.18); border-radius: 50%; content: ''; }
        .page-loader-logo { width: 88px; height: 88px; object-fit: contain; animation: loaderPulse 1.5s ease-in-out infinite; }
        .page-loader-text { color: #dbeafe; font-size: 14px; font-weight: 700; letter-spacing: .16em; text-transform: uppercase; }
        @keyframes loaderSpin { to { transform: rotate(360deg); } }
        @keyframes loaderPulse { 0%,100% { transform: scale(.94); } 50% { transform: scale(1); } }
        @media (prefers-reduced-motion: reduce) { .page-loader-logo-wrap::before, .page-loader-logo { animation: none; } }
        body {
            background: linear-gradient(135deg, #0f172a 0%, #1e3a8a 60%, #3b82f6 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem 1rem;
        }
        .register-card {
            background: #ffffff;
            border-radius: var(--radius-xl);
            box-shadow: 0 25px 60px -15px rgba(0, 0, 0, 0.4);
            max-width: 650px;
            width: 100%;
            padding: 2.5rem;
        }
    </style>
</head>
<body>
<div id="pageLoader" class="page-loader" aria-label="Đang tải trang" role="status">
    <div class="page-loader-content">
        <div class="page-loader-logo-wrap">
            <img class="page-loader-logo" src="${pageContext.request.contextPath}/assets/img/logo/logo_nav_hcmute.png" alt="HCMUTE">
        </div>
        <div class="page-loader-text">Đang tải hệ thống</div>
    </div>
</div>
<div class="register-card">
    <div class="text-center mb-4">
        <div class="sidebar-brand-icon mx-auto mb-2" style="width: 44px; height: 44px;">
            <i class="fa-solid fa-user-plus fs-4"></i>
        </div>
        <h4 class="fw-bold text-dark mb-1">Đăng ký tài khoản mới</h4>
        <p class="text-muted small">Cổng quản lý đề tài Khoa CNTT - HCMUTE</p>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger py-2 small d-flex align-items-center gap-2 mb-3">
            <i class="fa-solid fa-circle-exclamation"></i>
            <span>${error}</span>
        </div>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/register">
        <div class="row g-3 mb-3">
            <div class="col-md-6">
                <label class="form-label small fw-bold">Tên đăng nhập</label>
                <input type="text" class="form-control" name="username" placeholder="Ví dụ: 21110006 hoặc gv006" required>
            </div>
            <div class="col-md-6">
                <label class="form-label small fw-bold">Mật khẩu</label>
                <input type="password" class="form-control" name="password" placeholder="Tối thiểu 6 ký tự" required>
            </div>
        </div>

        <div class="mb-3">
            <label class="form-label small fw-bold">Họ và tên</label>
            <input type="text" class="form-control" name="fullName" placeholder="Ví dụ: Nguyễn Văn Hùng" required>
        </div>

        <div class="row g-3 mb-3">
            <div class="col-md-6">
                <label class="form-label small fw-bold">Email</label>
                <input type="email" id="emailInput" class="form-control" name="email" placeholder="25810176@student.hcmute.edu.vn" required>
                <div id="emailHint" class="form-text small">Sinh viên: MSSV@student.hcmute.edu.vn</div>
            </div>
            <div class="col-md-6">
                <label class="form-label small fw-bold">Số điện thoại</label>
                <input type="text" class="form-control" name="phone" placeholder="090..." required>
            </div>
        </div>

        <div class="mb-4">
            <label class="form-label small fw-bold">Vai trò trong hệ thống</label>
            <select class="form-select" id="roleInput" name="role" required>
                <option value="STUDENT">Sinh viên (STUDENT)</option>
                <option value="LECTURER">Giảng viên (LECTURER)</option>
            </select>
        </div>

        <button type="submit" class="btn btn-primary-custom w-100 py-2">
            <i class="fa-solid fa-user-check me-1"></i> Hoàn tất đăng ký
        </button>
    </form>

    <div class="text-center mt-3 small">
        <span class="text-muted">Đã có tài khoản?</span>
        <a href="${pageContext.request.contextPath}/login" class="text-primary fw-bold text-decoration-none ms-1">Đăng nhập</a>
        <span class="mx-2 text-muted">&bull;</span>
        <a href="${pageContext.request.contextPath}/" class="text-secondary text-decoration-none">Về trang chủ</a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const roleInput = document.getElementById('roleInput');
    const emailInput = document.getElementById('emailInput');
    const emailHint = document.getElementById('emailHint');
    function updateEmailHint() {
        const lecturer = roleInput.value === 'LECTURER';
        emailInput.placeholder = lecturer ? '25810176@teacher.hcmute.edu.vn' : '25810176@student.hcmute.edu.vn';
        emailHint.textContent = lecturer ? 'Giảng viên: MãGV@teacher.hcmute.edu.vn' : 'Sinh viên: MSSV@student.hcmute.edu.vn';
    }
    roleInput.addEventListener('change', updateEmailHint);
    updateEmailHint();

    (function () {
        const loader = document.getElementById('pageLoader');
        const hideLoader = function () { window.setTimeout(function () { loader.classList.add('is-hidden'); }, 250); };
        window.addEventListener('load', hideLoader, { once: true });
        document.addEventListener('click', function (event) {
            const link = event.target.closest('a');
            if (!link || event.defaultPrevented || link.target === '_blank') return;
            const href = link.getAttribute('href') || '';
            if (href && !href.startsWith('#') && !href.startsWith('javascript:')) loader.classList.remove('is-hidden');
        });
        document.addEventListener('submit', function () { loader.classList.remove('is-hidden'); });
    })();
</script>
</body>
</html>

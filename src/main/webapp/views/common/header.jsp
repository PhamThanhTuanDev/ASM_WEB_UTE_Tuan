<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle != null ? pageTitle : 'Hệ thống quản lý đề tài'} - HCMUTE Thesis Portal</title>
<link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logo/logo_hcmute.png">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        brand: {
                            50: '#eff6ff', 100: '#dbeafe', 500: '#3b82f6',
                            600: '#2563eb', 700: '#1d4ed8', 900: '#1e3a8a'
                        }
                    },
                    fontFamily: {
                        sans: ['"Plus Jakarta Sans"', 'sans-serif']
                    }
                }
            }
        }
    </script>

    <script src="https://unpkg.com/lucide@latest"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <!-- Bootstrap only for modal/dropdown JS behavior; theme CSS overrides Bootstrap spacing -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/custom-theme.css">
    <style>
        .page-loader {
            position: fixed;
            inset: 0;
            z-index: 9999;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #0b1b3a;
            opacity: 1;
            visibility: visible;
            transition: opacity .35s ease, visibility .35s ease;
        }
        .page-loader.is-hidden {
            opacity: 0;
            visibility: hidden;
            pointer-events: none;
        }
        .page-loader-content {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 18px;
        }
        .page-loader-logo-wrap {
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
            width: 150px;
            height: 150px;
        }
        .page-loader-logo-wrap::before {
            position: absolute;
            inset: 0;
            border: 3px solid rgba(147, 197, 253, .22);
            border-top-color: #60a5fa;
            border-right-color: #fbbf24;
            border-radius: 50%;
            animation: loaderSpin 1.1s linear infinite;
            content: '';
        }
        .page-loader-logo-wrap::after {
            position: absolute;
            inset: 13px;
            border: 1px solid rgba(255, 255, 255, .18);
            border-radius: 50%;
            content: '';
        }
        .page-loader-logo {
            width: 88px;
            height: 88px;
            object-fit: contain;
            animation: loaderPulse 1.5s ease-in-out infinite;
        }
        .page-loader-text {
            color: #dbeafe;
            font-size: 14px;
            font-weight: 700;
            letter-spacing: .16em;
            text-transform: uppercase;
        }
        @keyframes loaderSpin {
            to { transform: rotate(360deg); }
        }
        @keyframes loaderPulse {
            0%, 100% { transform: scale(.94); }
            50% { transform: scale(1); }
        }
        @media (prefers-reduced-motion: reduce) {
            .page-loader-logo-wrap::before, .page-loader-logo { animation: none; }
        }
    </style>
</head>
<body class="bg-slate-50 text-slate-800 font-sans antialiased selection:bg-blue-600 selection:text-white min-h-screen"
      data-context-path="${pageContext.request.contextPath}">
<div id="pageLoader" class="page-loader" aria-label="Đang tải trang" role="status">
    <div class="page-loader-content">
        <div class="page-loader-logo-wrap">
            <img class="page-loader-logo" src="${pageContext.request.contextPath}/assets/img/logo/logo_nav_hcmute.png" alt="HCMUTE">
        </div>
        <div class="page-loader-text">Đang tải hệ thống</div>
    </div>
</div>
<div class="app-wrapper flex min-h-screen">
<div id="sidebarOverlay" class="sidebar-overlay" aria-hidden="true"></div>
<script>
    (function () {
        const loader = document.getElementById('pageLoader');
        if (!loader) return;

        if (window.sessionStorage.getItem('skipPageLoader') === '1') {
            loader.classList.add('is-hidden');
            window.sessionStorage.removeItem('skipPageLoader');
        }

        const showLoader = function () {
            loader.classList.remove('is-hidden');
        };
        const hideLoader = function () {
            window.setTimeout(function () {
                loader.classList.add('is-hidden');
            }, 250);
        };

        window.addEventListener('load', hideLoader, { once: true });
        window.addEventListener('pageshow', hideLoader);
        document.addEventListener('click', function (event) {
            const link = event.target.closest('a');
            if (!link || link.target === '_blank' || event.ctrlKey || event.metaKey || event.shiftKey || event.altKey) return;
            const href = link.getAttribute('href') || '';
            if (link.classList.contains('sidebar-logo-link')) {
                showLoader();
                return;
            }
            if (link.closest('.app-sidebar')) {
                window.sessionStorage.setItem('skipPageLoader', '1');
                return;
            }
            if (href && !href.startsWith('#') && !href.startsWith('javascript:')) {
                showLoader();
            }
        }, true);
        document.addEventListener('submit', function () { showLoader(); }, true);
    })();
</script>

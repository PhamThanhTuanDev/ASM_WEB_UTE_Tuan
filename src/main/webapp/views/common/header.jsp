<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <meta name="theme-color" content="#003865">
                    <meta name="color-scheme" content="light">
                    <title>${pageTitle != null ? pageTitle : 'Hệ thống quản lý đề tài sinh viên'} - HCMUTE</title>
                    <link rel="icon" type="image/png"
                        href="${pageContext.request.contextPath}/assets/img/logo/logo_hcmute.png">

                    <!-- Google Fonts: Plus Jakarta Sans -->
                    <link rel="preconnect" href="https://fonts.googleapis.com">
                    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                    <link
                        href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800;900&display=swap"
                        rel="stylesheet">

                    <!-- Tailwind CSS for functional utility spacing -->
                    <script src="https://cdn.tailwindcss.com"></script>
                    <script>
                        tailwind.config = {
                            theme: {
                                extend: {
                                    colors: {
                                        ute: {
                                            50: '#f0f9ff', 100: '#e0f2fe', 500: '#0ea5e9',
                                            600: '#006da8', 700: '#00568c', 900: '#003865'
                                        },
                                        brand: {
                                            50: '#eff6ff', 100: '#dbeafe', 500: '#0284c7',
                                            600: '#006da8', 700: '#00568c', 900: '#002e54'
                                        }
                                    },
                                    fontFamily: {
                                        sans: ['"Plus Jakarta Sans"', 'system-ui', 'sans-serif']
                                    }
                                }
                            }
                        }
                    </script>

                    <!-- Icons & Core Libraries -->
                    <script src="https://unpkg.com/lucide@latest"></script>
                    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link rel="stylesheet"
                        href="${pageContext.request.contextPath}/assets/css/custom-theme.css?v=4.4.0">
                </head>

                <body
                    class="bg-slate-50 text-slate-800 font-sans antialiased selection:bg-sky-600 selection:text-white min-h-screen"
                    data-context-path="${pageContext.request.contextPath}">

                    <a href="#main-content"
                        class="sr-only focus:not-sr-only focus:fixed focus:left-4 focus:top-4 focus:z-[10000] focus:rounded-xl focus:bg-white focus:px-4 focus:py-2 focus:text-xs focus:font-bold focus:text-blue-900 focus:shadow-xl">Bỏ
                        qua đến nội dung chính</a>

                    <!-- Futuristic Page Loader -->
                    <div id="pageLoader" class="page-loader" aria-label="Đang tải hệ thống" role="status">
                        <div class="page-loader-content">
                            <div class="page-loader-logo-wrap">
                                <img class="page-loader-logo"
                                    src="${pageContext.request.contextPath}/assets/img/logo/logo_nav_hcmute.png"
                                    alt="HCMUTE">
                            </div>
                            <div class="page-loader-text">HCMUTE • ACADEMIC PORTAL</div>
                        </div>
                    </div>

                    <div id="main-content" class="app-wrapper flex min-h-screen">
                        <div id="sidebarOverlay" class="sidebar-overlay" aria-hidden="true"></div>

                        <script>
                                (function () {
                                    const loader = document.getElementById('pageLoader');
                                    if (!loader) return;

                                    try {
                                        const navigation = window.performance && window.performance.getEntriesByType('navigation')[0];
                                        const isReload = navigation && navigation.type === 'reload';
                                        if (isReload || window.sessionStorage.getItem('showPageLoader') === '1') {
                                            loader.classList.add('is-visible');
                                            window.sessionStorage.removeItem('showPageLoader');
                                        }
                                    } catch (error) {
                                        loader.classList.remove('is-visible');
                                    }

                                    const hideLoader = function () {
                                        window.setTimeout(function () {
                                            loader.classList.remove('is-visible');
                                        }, 400);
                                    };

                                    document.addEventListener('DOMContentLoaded', hideLoader, { once: true });
                                    window.addEventListener('load', hideLoader, { once: true });
                                    window.addEventListener('pageshow', hideLoader);
                                    document.addEventListener('click', function (event) {
                                        const link = event.target.closest('a[data-page-loader]');
                                        if (!link || link.target === '_blank' || event.ctrlKey || event.metaKey || event.shiftKey || event.altKey) return;
                                        try {
                                            window.sessionStorage.setItem('showPageLoader', '1');
                                        } catch (error) { }
                                        loader.classList.add('is-visible');
                                    }, true);
                                })();
                        </script>
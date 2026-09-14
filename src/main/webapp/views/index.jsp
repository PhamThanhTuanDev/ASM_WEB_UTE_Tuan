<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Hệ thống quản lý đề tài sinh viên HCMUTE</title>
                <meta name="description"
                    content="Cổng thông tin quản trị đề tài tốt nghiệp, khóa luận và đồ án chuyên ngành Khoa Công nghệ Thông tin - Trường Đại học Sư phạm Kỹ thuật TP.HCM (HCMUTE).">
                <meta name="author" content="HCMUTE FIT">
                <link rel="icon" type="image/png"
                    href="${pageContext.request.contextPath}/assets/img/logo/logo_hcmute.png">

                <!-- Google Fonts & Tailwind CDN -->
                <link rel="preconnect" href="https://fonts.googleapis.com">
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                <link
                    href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap"
                    rel="stylesheet">
                <script src="https://cdn.tailwindcss.com"></script>
                <script>
                    tailwind.config = {
                        theme: {
                            extend: {
                                fontFamily: { sans: ['"Plus Jakarta Sans"', 'sans-serif'] },
                                colors: {
                                    brand: { 50: '#eff6ff', 100: '#dbeafe', 500: '#0088cc', 600: '#006da8', 700: '#005584', 800: '#003865', 900: '#002444' }
                                }
                            }
                        }
                    }
                </script>
                <script src="https://unpkg.com/lucide@latest"></script>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/custom-theme.css?v=4.4.0">

                <style>
                    .landing-hero {
                        position: relative;
                        background: linear-gradient(135deg, #001933 0%, #002b55 35%, #004c82 70%, #006da8 100%);
                        overflow: hidden;
                        isolation: isolate;
                    }

                    .landing-hero::before {
                        content: '';
                        position: absolute;
                        inset: 0;
                        background: radial-gradient(circle at 80% 20%, rgba(56, 189, 248, 0.22) 0%, transparent 50%),
                            radial-gradient(circle at 10% 80%, rgba(37, 99, 235, 0.25) 0%, transparent 45%);
                        pointer-events: none;
                        z-index: 1;
                    }

                    .hero-cube-3d {
                        width: 140px;
                        height: 140px;
                        transform-style: preserve-3d;
                        animation: cubeRotate 18s linear infinite;
                    }

                    .hero-cube-face {
                        position: absolute;
                        width: 140px;
                        height: 140px;
                        border: 2px solid rgba(186, 230, 253, 0.35);
                        background: rgba(0, 109, 168, 0.15);
                        backdrop-filter: blur(8px);
                        border-radius: 18px;
                    }

                    .hero-cube-face:nth-child(1) {
                        transform: rotateY(0deg) translateZ(70px);
                    }

                    .hero-cube-face:nth-child(2) {
                        transform: rotateY(90deg) translateZ(70px);
                    }

                    .hero-cube-face:nth-child(3) {
                        transform: rotateY(180deg) translateZ(70px);
                    }

                    .hero-cube-face:nth-child(4) {
                        transform: rotateY(-90deg) translateZ(70px);
                    }

                    .hero-cube-face:nth-child(5) {
                        transform: rotateX(90deg) translateZ(70px);
                    }

                    .hero-cube-face:nth-child(6) {
                        transform: rotateX(-90deg) translateZ(70px);
                    }

                    @keyframes cubeRotate {
                        0% {
                            transform: rotateX(15deg) rotateY(0deg);
                        }

                        100% {
                            transform: rotateX(15deg) rotateY(360deg);
                        }
                    }

                    .glass-nav {
                        background: rgba(255, 255, 255, 0.85);
                        backdrop-filter: blur(20px);
                        -webkit-backdrop-filter: blur(20px);
                    }

                    .glass-dark-card {
                        background: rgba(255, 255, 255, 0.07);
                        backdrop-filter: blur(16px);
                        border: 1px solid rgba(255, 255, 255, 0.14);
                    }
                </style>
            </head>

            <body class="bg-slate-50 text-slate-800 antialiased font-sans flex flex-col min-h-screen">

                <!-- Sticky Glass Header -->
                <header class="glass-nav sticky top-0 z-50 border-b border-slate-200/80 transition-all">
                    <div class="max-w-7xl mx-auto px-4 sm:px-6 h-20 flex items-center justify-between gap-4">
                        <a href="${pageContext.request.contextPath}/" class="flex items-center gap-3.5 group">
                            <div class="relative">
                                <img src="${pageContext.request.contextPath}/assets/img/logo/logo_nav_hcmute.png"
                                    alt="HCMUTE Logo"
                                    class="h-16 w-auto object-contain group-hover:scale-105 transition-transform duration-300">

                            </div>

                        </a>

                        <!-- Desktop Nav Links -->
                        <nav class="hidden md:flex items-center gap-8 h-full text-sm font-bold text-slate-600">
                            <a href="${pageContext.request.contextPath}/"
                                class="h-full inline-flex items-center gap-2 border-b-2 border-sky-600 text-sky-700">
                                <i data-lucide="home" class="w-4 h-4"></i> Trang chủ
                            </a>
                            <a href="#topicsSection"
                                class="h-full inline-flex items-center gap-2 border-b-2 border-transparent hover:border-sky-400 hover:text-sky-600 transition-colors">
                                <i data-lucide="book-open" class="w-4 h-4"></i> Danh mục đề tài
                            </a>
                            <a href="#processSection"
                                class="h-full inline-flex items-center gap-2 border-b-2 border-transparent hover:border-sky-400 hover:text-sky-600 transition-colors">
                                <i data-lucide="git-merge" class="w-4 h-4"></i> Quy trình thực hiện
                            </a>
                            <a href="#guideSection"
                                class="h-full inline-flex items-center gap-2 border-b-2 border-transparent hover:border-sky-400 hover:text-sky-600 transition-colors">
                                <i data-lucide="help-circle" class="w-4 h-4"></i> Hướng dẫn
                            </a>
                        </nav>

                        <!-- Auth / Dashboard Actions -->
                        <div class="flex items-center gap-3">
                            <c:choose>
                                <c:when test="${not empty sessionScope.user}">
                                    <c:set var="dashUrl"
                                        value="${sessionScope.userRole == 'ADMIN' || sessionScope.userRole == 'DEAN' ? 'admin' : sessionScope.userRole == 'LECTURER' ? 'lecturer' : 'student'}" />
                                    <a href="${pageContext.request.contextPath}/${dashUrl}/dashboard"
                                        class="btn-ui btn-ui-primary text-xs py-2.5 px-4 shadow-sm">
                                        <i data-lucide="layout-dashboard" class="w-4 h-4"></i>
                                        <span>Vào Bảng Điều Khiển</span>
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/login"
                                        class="btn-ui btn-ui-outline text-xs py-2 px-3.5">
                                        <i data-lucide="log-in" class="w-4 h-4"></i> Đăng nhập
                                    </a>
                                    <a href="${pageContext.request.contextPath}/register"
                                        class="btn-ui btn-ui-primary text-xs py-2 px-4 shadow-sm hidden sm:inline-flex">
                                        <i data-lucide="user-plus" class="w-4 h-4"></i> Đăng ký
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </header>

                <!-- 3D Academic Hero Section -->
                <section class="landing-hero text-white relative py-20 lg:py-28">
                    <!-- 3D Perspective Grid Floor -->
                    <div class="landing-grid-floor" aria-hidden="true"></div>

                    <!-- 3D Orbit rings background -->
                    <div
                        class="hero-orbit w-[600px] h-[600px] top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 opacity-25 pointer-events-none">
                    </div>
                    <div class="hero-orbit w-[850px] h-[850px] top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 opacity-15 pointer-events-none"
                        style="animation-duration: 45s; animation-direction: reverse;"></div>

                    <div class="max-w-7xl mx-auto px-4 sm:px-6 relative z-10">
                        <div class="grid grid-cols-1 lg:grid-cols-12 gap-12 items-center">

                            <!-- Left Hero Headline -->
                            <div class="lg:col-span-8 space-y-6">
                                <div
                                    class="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-white/10 border border-white/20 text-sky-200 text-xs font-bold backdrop-blur-md">
                                    <i data-lucide="sparkles" class="w-3.5 h-3.5 text-sky-300"></i>
                                    <span>CỔNG QUẢN LÝ ĐỀ TÀI & KHÓA LUẬN HCMUTE</span>
                                </div>

                                <h1
                                    class="text-3xl sm:text-5xl lg:text-6xl font-black tracking-tight leading-[1.15] text-white">
                                    Nền Tảng Quản Lý<br>
                                    <span
                                        class="text-transparent bg-clip-text bg-gradient-to-r from-sky-300 via-blue-200 to-white">Đề
                                        Tài Sinh Viên</span>
                                </h1>

                                <p class="text-sm sm:text-base text-sky-100/90 leading-relaxed max-w-2xl font-medium">
                                    Hệ thống thông minh kết nối Sinh viên, Giảng viên hướng dẫn và Hội đồng phản
                                    biện. Chuẩn hóa toàn diện từ đề xuất, duyệt đăng ký nhóm, nộp báo cáo đến bảo vệ
                                    khóa luận.
                                </p>

                                <div class="flex flex-wrap gap-4 pt-2">
                                    <a href="#topicsSection"
                                        class="inline-flex items-center gap-2 px-6 py-3.5 rounded-2xl bg-white text-blue-900 font-extrabold text-sm shadow-xl hover:bg-sky-50 hover:shadow-2xl transition-all hover:-translate-y-0.5">
                                        <i data-lucide="compass" class="w-4 h-4 text-sky-600"></i> Khám phá đề tài
                                    </a>
                                    <a href="${pageContext.request.contextPath}/login"
                                        class="inline-flex items-center gap-2 px-6 py-3.5 rounded-2xl glass-dark-card text-white font-bold text-sm hover:bg-white/15 transition-all hover:-translate-y-0.5">
                                        <i data-lucide="arrow-right-circle" class="w-4 h-4 text-sky-300"></i> Tham gia
                                        đợt ngay
                                    </a>
                                </div>

                                <!-- Active Period Strip -->
                                <c:if test="${not empty activePeriod}">
                                    <div
                                        class="mt-8 p-4 sm:p-5 rounded-3xl glass-dark-card border border-white/20 max-w-2xl">
                                        <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
                                            <div>
                                                <div
                                                    class="text-[10px] font-extrabold uppercase tracking-wider text-amber-300 flex items-center gap-1.5">
                                                    <i data-lucide="calendar" class="w-3 h-3 text-amber-400"></i> ĐỢT
                                                    ĐANG MỞ
                                                </div>
                                                <div class="font-extrabold text-white text-sm sm:text-base mt-0.5">
                                                    ${activePeriod.name}</div>
                                            </div>
                                            <div
                                                class="flex flex-wrap items-center gap-x-4 gap-y-1 text-xs text-sky-200">
                                                <span class="inline-flex items-center gap-1.5"><i data-lucide="calendar"
                                                        class="w-3.5 h-3.5 text-sky-300"></i> Hạn SV:
                                                    ${activePeriod.studentEndDate}</span>
                                                <c:if test="${not empty activePeriod.reviewerDeadline}">
                                                    <span class="inline-flex items-center gap-1.5"><i
                                                            data-lucide="clock" class="w-3.5 h-3.5 text-sky-300"></i>
                                                        GVPB: ${activePeriod.reviewerDeadline}</span>
                                                </c:if>
                                                <c:if test="${not empty activePeriod.councilReportDate}">
                                                    <span class="inline-flex items-center gap-1.5"><i
                                                            data-lucide="award" class="w-3.5 h-3.5 text-sky-300"></i>
                                                        Hội đồng: ${activePeriod.councilReportDate}</span>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                            </div>

                            <!-- Right Hero 3D Geometric Cube with Layered Badges -->
                            <div class="lg:col-span-4 hidden lg:flex items-center justify-center relative select-none"
                                style="perspective: 1000px; transform-style: preserve-3d; min-height: 260px;">
                                <div
                                    class="subtle-glowing-orb w-64 h-64 bg-sky-400/25 top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2">
                                </div>
                                <div class="hero-cube-3d">
                                    <div
                                        class="hero-cube-face flex items-center justify-center text-sky-200 font-mono font-bold text-xs">
                                        HCMUTE</div>
                                    <div class="hero-cube-face flex items-center justify-center text-sky-200"><i
                                            data-lucide="book-open" class="w-10 h-10 text-sky-300"></i></div>
                                    <div
                                        class="hero-cube-face flex items-center justify-center text-sky-200 font-mono font-bold text-xs">
                                        THESIS</div>
                                    <div class="hero-cube-face flex items-center justify-center text-sky-200"><i
                                            data-lucide="shield-check" class="w-10 h-10 text-sky-300"></i></div>
                                    <div
                                        class="hero-cube-face flex items-center justify-center text-sky-200 font-mono font-bold text-xs">
                                        FIT 2026</div>
                                    <div class="hero-cube-face flex items-center justify-center text-sky-200"><i
                                            data-lucide="award" class="w-10 h-10 text-sky-300"></i></div>
                                </div>
                                <!-- Floating layered glass badges -->
                                <div class="academic-badge-float -top-4 -left-4">
                                    <i data-lucide="sparkles" class="w-3.5 h-3.5 text-amber-300"></i>
                                    <span>AI / EdTech</span>
                                </div>
                                <div class="academic-badge-float -bottom-4 -right-4" style="animation-delay: -3s;">
                                    <i data-lucide="cpu" class="w-3.5 h-3.5 text-sky-300"></i>
                                    <span>Digital Thesis</span>
                                </div>
                                <!-- Floating particles -->
                                <div class="floating-particle w-2 h-2 top-2 right-8" style="animation-delay: -1s;">
                                </div>
                                <div class="floating-particle w-1.5 h-1.5 bottom-8 left-4"
                                    style="animation-delay: -4s;"></div>
                            </div>

                        </div>
                    </div>
                </section>

                <!-- Bento KPI Statistics Grid -->
                <section class="relative z-20 -mt-10 max-w-7xl mx-auto px-4 sm:px-6">
                    <div class="grid grid-cols-2 lg:grid-cols-4 gap-4">
                        <!-- Stat 1: Topics -->
                        <div
                            class="bg-white rounded-3xl border border-slate-200/90 p-5 shadow-lg shadow-slate-200/50 hover:-translate-y-1 transition-all duration-300">
                            <div class="flex items-center justify-between mb-2">
                                <span class="text-[10px] font-extrabold uppercase tracking-wider text-slate-400">Đề tài
                                    công bố</span>
                                <div
                                    class="w-9 h-9 rounded-2xl bg-sky-50 text-sky-600 flex items-center justify-center">
                                    <i data-lucide="book-marked" class="w-4 h-4"></i>
                                </div>
                            </div>
                            <div class="text-3xl font-black text-slate-900">${publishedTopics != null ? publishedTopics
                                : totalTopics}</div>
                            <div class="text-[11px] text-slate-500 mt-1 font-semibold flex items-center gap-1">
                                <i data-lucide="check-circle" class="w-3 h-3 text-emerald-500"></i> Đã phê duyệt chính
                                thức
                            </div>
                        </div>

                        <!-- Stat 2: Groups -->
                        <div
                            class="bg-white rounded-3xl border border-slate-200/90 p-5 shadow-lg shadow-slate-200/50 hover:-translate-y-1 transition-all duration-300">
                            <div class="flex items-center justify-between mb-2">
                                <span class="text-[10px] font-extrabold uppercase tracking-wider text-slate-400">Nhóm
                                    sinh viên</span>
                                <div
                                    class="w-9 h-9 rounded-2xl bg-emerald-50 text-emerald-600 flex items-center justify-center">
                                    <i data-lucide="users-round" class="w-4 h-4"></i>
                                </div>
                            </div>
                            <div class="text-3xl font-black text-slate-900">${totalGroups}</div>
                            <div class="text-[11px] text-slate-500 mt-1 font-semibold flex items-center gap-1">
                                <i data-lucide="sparkles" class="w-3 h-3 text-amber-500"></i> Nhóm đã lập & đăng ký
                            </div>
                        </div>

                        <!-- Stat 3: Lecturers -->
                        <div
                            class="bg-white rounded-3xl border border-slate-200/90 p-5 shadow-lg shadow-slate-200/50 hover:-translate-y-1 transition-all duration-300">
                            <div class="flex items-center justify-between mb-2">
                                <span class="text-[10px] font-extrabold uppercase tracking-wider text-slate-400">Giảng
                                    viên tham gia</span>
                                <div
                                    class="w-9 h-9 rounded-2xl bg-amber-50 text-amber-600 flex items-center justify-center">
                                    <i data-lucide="user-check" class="w-4 h-4"></i>
                                </div>
                            </div>
                            <div class="text-3xl font-black text-slate-900">${totalLecturers}</div>
                            <div class="text-[11px] text-slate-500 mt-1 font-semibold flex items-center gap-1">
                                <i data-lucide="award" class="w-3 h-3 text-sky-500"></i> Hướng dẫn & Hội đồng
                            </div>
                        </div>

                        <!-- Stat 4: Students -->
                        <div
                            class="bg-white rounded-3xl border border-slate-200/90 p-5 shadow-lg shadow-slate-200/50 hover:-translate-y-1 transition-all duration-300">
                            <div class="flex items-center justify-between mb-2">
                                <span class="text-[10px] font-extrabold uppercase tracking-wider text-slate-400">Sinh
                                    viên tham gia</span>
                                <div
                                    class="w-9 h-9 rounded-2xl bg-indigo-50 text-indigo-600 flex items-center justify-center">
                                    <i data-lucide="graduation-cap" class="w-4 h-4"></i>
                                </div>
                            </div>
                            <div class="text-3xl font-black text-slate-900">${totalStudents}</div>
                            <div class="text-[11px] text-slate-500 mt-1 font-semibold flex items-center gap-1">
                                <i data-lucide="shield-check" class="w-3 h-3 text-indigo-500"></i> Khóa luận & Đồ án
                            </div>
                        </div>
                    </div>
                </section>

                <!-- 4-Step Academic Workflow -->
                <section id="processSection" class="max-w-7xl mx-auto px-4 sm:px-6 py-16 sm:py-20">
                    <div class="text-center max-w-2xl mx-auto mb-12">
                        <span
                            class="px-3 py-1 rounded-full bg-sky-100 text-sky-700 text-xs font-bold uppercase tracking-wider">
                            QUY TRÌNH CHUẨN
                        </span>
                        <h2 class="text-2xl sm:text-3xl font-black text-slate-900 tracking-tight mt-3">
                            Hành Trình Thực Hiện Đề Tài 4 Bước
                        </h2>
                        <p class="text-xs sm:text-sm text-slate-500 mt-2">
                            Luồng xử lý khép kín và minh bạch giữa Sinh viên, Giảng viên hướng dẫn và Ban chủ nhiệm
                            Khoa.
                        </p>
                    </div>

                    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
                        <!-- Step 1 -->
                        <div
                            class="bg-white rounded-3xl border border-slate-200/90 p-6 shadow-xs hover:shadow-xl hover:-translate-y-1 transition-all duration-300 relative group">
                            <div
                                class="w-12 h-12 rounded-2xl bg-gradient-to-tr from-sky-600 to-blue-700 text-white font-black text-base flex items-center justify-center mb-4 shadow-md shadow-sky-500/20 group-hover:scale-110 transition-transform">
                                01
                            </div>
                            <h3 class="text-base font-bold text-slate-900 mb-1.5">Mở đợt & Đề xuất</h3>
                            <p class="text-xs text-slate-500 leading-relaxed">
                                Khoa công bố kế hoạch thời gian; Giảng viên đề xuất danh mục đề tài khóa luận để hội
                                đồng khoa thẩm định và phê duyệt.
                            </p>
                        </div>

                        <!-- Step 2 -->
                        <div
                            class="bg-white rounded-3xl border border-slate-200/90 p-6 shadow-xs hover:shadow-xl hover:-translate-y-1 transition-all duration-300 relative group">
                            <div
                                class="w-12 h-12 rounded-2xl bg-gradient-to-tr from-blue-600 to-indigo-700 text-white font-black text-base flex items-center justify-center mb-4 shadow-md shadow-blue-500/20 group-hover:scale-110 transition-transform">
                                02
                            </div>
                            <h3 class="text-base font-bold text-slate-900 mb-1.5">Lập nhóm & Đăng ký</h3>
                            <p class="text-xs text-slate-500 leading-relaxed">
                                Sinh viên tạo nhóm tối đa 03 thành viên. Nhóm trưởng đại diện gửi đơn đăng ký đề tài
                                mong muốn tới Giảng viên hướng dẫn.
                            </p>
                        </div>

                        <!-- Step 3 -->
                        <div
                            class="bg-white rounded-3xl border border-slate-200/90 p-6 shadow-xs hover:shadow-xl hover:-translate-y-1 transition-all duration-300 relative group">
                            <div
                                class="w-12 h-12 rounded-2xl bg-gradient-to-tr from-indigo-600 to-violet-700 text-white font-black text-base flex items-center justify-center mb-4 shadow-md shadow-indigo-500/20 group-hover:scale-110 transition-transform">
                                03
                            </div>
                            <h3 class="text-base font-bold text-slate-900 mb-1.5">Nộp báo cáo tiến độ</h3>
                            <p class="text-xs text-slate-500 leading-relaxed">
                                Tải lên tài liệu báo cáo tiến độ định kỳ và báo cáo toàn văn cuối kỳ; GVHD theo dõi,
                                chấm điểm quá trình và nhận xét.
                            </p>
                        </div>

                        <!-- Step 4 -->
                        <div
                            class="bg-white rounded-3xl border border-slate-200/90 p-6 shadow-xs hover:shadow-xl hover:-translate-y-1 transition-all duration-300 relative group">
                            <div
                                class="w-12 h-12 rounded-2xl bg-gradient-to-tr from-emerald-600 to-teal-700 text-white font-black text-base flex items-center justify-center mb-4 shadow-md shadow-emerald-500/20 group-hover:scale-110 transition-transform">
                                04
                            </div>
                            <h3 class="text-base font-bold text-slate-900 mb-1.5">Hội đồng & Công bố điểm</h3>
                            <p class="text-xs text-slate-500 leading-relaxed">
                                Hội đồng phản biện tổ chức bảo vệ, chấm điểm độc lập qua hệ thống và công bố kết quả
                                đánh giá tổng kết chính thức.
                            </p>
                        </div>
                    </div>
                </section>

                <!-- Catalog Section: Filter Rail + Topics Grid -->
                <main id="topicsSection" class="max-w-7xl mx-auto px-4 sm:px-6 pb-20">
                    <div class="flex flex-col lg:flex-row gap-8">

                        <!-- Left Filter Rail -->
                        <aside class="lg:w-80 shrink-0 space-y-6 lg:sticky lg:top-24 lg:self-start">
                            <!-- Filter Box -->
                            <div class="bg-white rounded-3xl border border-slate-200/90 shadow-xs p-6">
                                <h3 class="text-sm font-extrabold text-slate-900 flex items-center gap-2 mb-4">
                                    <i data-lucide="sliders-horizontal" class="w-4 h-4 text-sky-600"></i> Bộ lọc tra cứu
                                </h3>
                                <form method="get" action="${pageContext.request.contextPath}/" class="space-y-4">
                                    <div>
                                        <label class="block text-xs font-bold text-slate-600 mb-1.5">Từ khóa tìm
                                            kiếm</label>
                                        <div class="relative">
                                            <i data-lucide="search"
                                                class="w-4 h-4 text-slate-400 absolute left-3.5 top-1/2 -translate-y-1/2 pointer-events-none"></i>
                                            <input type="text" name="keyword" value="${keyword}"
                                                placeholder="Mã số, tên đề tài, GVHD..."
                                                class="w-full pl-10 pr-3.5 py-2.5 rounded-2xl bg-slate-50 border border-slate-200 text-xs font-medium focus:bg-white focus:ring-2 focus:ring-sky-500/20 focus:border-sky-500 focus:outline-none transition-all">
                                        </div>
                                    </div>

                                    <div>
                                        <label class="block text-xs font-bold text-slate-600 mb-1.5">Khoa / Bộ
                                            môn</label>
                                        <select name="departmentId"
                                            class="w-full px-3.5 py-2.5 rounded-2xl bg-slate-50 border border-slate-200 text-xs font-semibold focus:bg-white focus:ring-2 focus:ring-sky-500/20 focus:border-sky-500 focus:outline-none transition-all">
                                            <option value="">-- Tất cả Khoa --</option>
                                            <c:forEach var="dept" items="${departments}">
                                                <option value="${dept.id}" ${selectedDept==dept.id ? 'selected' : '' }>
                                                    ${dept.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <button type="submit"
                                        class="btn-ui btn-ui-primary w-full justify-center py-2.5 text-xs shadow-sm">
                                        <i data-lucide="filter" class="w-3.5 h-3.5"></i> Áp dụng bộ lọc
                                    </button>

                                    <c:if test="${not empty keyword || not empty selectedDept}">
                                        <a href="${pageContext.request.contextPath}/"
                                            class="block text-center text-xs font-bold text-slate-500 hover:text-sky-600 transition-colors">
                                            &times; Xóa bộ lọc
                                        </a>
                                    </c:if>
                                </form>
                            </div>

                            <!-- Quick Guide Card -->
                            <div id="guideSection"
                                class="bg-white rounded-3xl border border-slate-200/90 shadow-xs p-6 space-y-4">
                                <h3 class="text-sm font-extrabold text-slate-900 flex items-center gap-2">
                                    <i data-lucide="compass" class="w-4 h-4 text-sky-600"></i> Hướng dẫn thao tác
                                </h3>
                                <ol class="space-y-3 text-xs text-slate-600 leading-relaxed">
                                    <li class="flex gap-3">
                                        <span
                                            class="w-6 h-6 rounded-xl bg-sky-100 text-sky-700 text-xs font-bold flex items-center justify-center shrink-0">1</span>
                                        <span><strong class="text-slate-800">Đăng nhập</strong> bằng tài khoản email
                                            được nhà trường cấp.</span>
                                    </li>
                                    <li class="flex gap-3">
                                        <span
                                            class="w-6 h-6 rounded-xl bg-sky-100 text-sky-700 text-xs font-bold flex items-center justify-center shrink-0">2</span>
                                        <span><strong class="text-slate-800">Lập nhóm:</strong> Sinh viên vào mục Nhóm
                                            để tạo nhóm và mời bạn.</span>
                                    </li>
                                    <li class="flex gap-3">
                                        <span
                                            class="w-6 h-6 rounded-xl bg-sky-100 text-sky-700 text-xs font-bold flex items-center justify-center shrink-0">3</span>
                                        <span><strong class="text-slate-800">Nhóm trưởng đăng ký:</strong> Chọn đề tài
                                            phù hợp và gửi đăng ký.</span>
                                    </li>
                                    <li class="flex gap-3">
                                        <span
                                            class="w-6 h-6 rounded-xl bg-sky-100 text-sky-700 text-xs font-bold flex items-center justify-center shrink-0">4</span>
                                        <span><strong class="text-slate-800">Theo dõi:</strong> Cập nhật trạng thái
                                            duyệt và nộp báo cáo đúng hạn.</span>
                                    </li>
                                </ol>
                            </div>
                        </aside>

                        <!-- Right Topics Grid -->
                        <section class="flex-1 min-w-0">
                            <div class="flex flex-col sm:flex-row sm:items-end sm:justify-between gap-3 mb-6">
                                <div>
                                    <h2 class="text-xl font-black text-slate-900 tracking-tight">Danh Mục Đề Tài Công Bố
                                    </h2>
                                    <p class="text-xs text-slate-500 mt-1">Đăng nhập bằng tài khoản Nhóm trưởng để gửi
                                        yêu cầu đăng ký đề tài.</p>
                                </div>
                                <span class="status-badge status-info text-xs self-start sm:self-auto">
                                    ${fn:length(topics)} đề tài hiển thị
                                </span>
                            </div>

                            <c:choose>
                                <c:when test="${empty topics}">
                                    <div
                                        class="empty-state py-16 bg-white rounded-3xl border border-slate-200 shadow-sm">
                                        <div class="empty-state-icon-wrap w-14 h-14 mb-3">
                                            <i data-lucide="inbox" class="w-7 h-7 opacity-40"></i>
                                        </div>
                                        <div class="empty-state-title text-base font-bold text-slate-800">Không tìm thấy
                                            đề tài nào</div>
                                        <div class="empty-state-desc text-xs text-slate-500 mt-1 max-w-sm mx-auto">Thử
                                            đổi từ khóa hoặc chọn lại bộ lọc khoa. Có thể đợt hiện tại chưa công bố đề
                                            tài mới.</div>
                                        <a href="${pageContext.request.contextPath}/"
                                            class="btn-ui btn-ui-outline text-xs py-2 px-4 mt-4 inline-flex">
                                            Xem tất cả đề tài
                                        </a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6" data-pagination-list>
                                        <c:forEach var="topic" items="${topics}">
                                            <article data-pagination-item
                                                class="bg-white rounded-3xl border border-slate-200/90 p-6 shadow-xs hover:shadow-xl hover:-translate-y-1 transition-all duration-300 flex flex-col justify-between group relative overflow-hidden">
                                                <!-- Top accent line -->
                                                <div
                                                    class="absolute top-0 left-0 right-0 h-1 bg-gradient-to-r from-sky-400 via-blue-500 to-indigo-500 opacity-0 group-hover:opacity-100 transition-opacity">
                                                </div>

                                                <div>
                                                    <div class="flex items-start justify-between gap-2 mb-3">
                                                        <span
                                                            class="px-2.5 py-1 rounded-xl font-mono font-bold text-xs bg-sky-50 text-sky-700 border border-sky-200/80 shadow-2xs">${topic.code}</span>
                                                        <span
                                                            class="px-2.5 py-0.5 rounded-lg text-[10px] font-bold uppercase tracking-wider bg-slate-100 text-slate-600 border border-slate-200 truncate max-w-[45%]">
                                                            ${topic.department != null ? topic.department.name : 'CNTT'}
                                                        </span>
                                                    </div>
                                                    <h3
                                                        class="text-sm font-bold text-slate-900 group-hover:text-sky-600 transition-colors leading-snug mb-2 line-clamp-2">
                                                        ${topic.title}</h3>
                                                    <p
                                                        class="text-xs text-slate-500 leading-relaxed line-clamp-3 mb-4 flex-1">
                                                        ${topic.description != null ? topic.description : 'Chưa có mô tả
                                                        chi tiết.'}
                                                    </p>
                                                </div>

                                                <div class="pt-3.5 border-t border-slate-100 space-y-3">
                                                    <div class="text-xs text-slate-700 flex items-start gap-2">
                                                        <i data-lucide="user-check"
                                                            class="w-3.5 h-3.5 text-sky-600 mt-0.5 shrink-0"></i>
                                                        <div class="min-w-0">
                                                            <span class="text-slate-500">GVHD:</span>
                                                            <strong
                                                                class="font-semibold text-slate-800">${topic.lecturer !=
                                                                null ? topic.lecturer.user.fullName : 'Chưa phân
                                                                công'}</strong>
                                                            <c:if test="${not empty topic.coLecturer}">
                                                                <div class="text-[11px] text-slate-500 mt-0.5 truncate">
                                                                    Đồng HD: ${topic.coLecturer.user.fullName}</div>
                                                            </c:if>
                                                        </div>
                                                    </div>

                                                    <div class="flex items-center justify-between gap-2 pt-1">
                                                        <span
                                                            class="text-[11px] font-semibold text-slate-500 bg-slate-100 px-2.5 py-1 rounded-lg border border-slate-200">
                                                            Tối đa <strong
                                                                class="text-slate-700">${topic.maxStudents}</strong> SV
                                                        </span>
                                                        <a href="${pageContext.request.contextPath}/login"
                                                            class="btn-ui btn-ui-primary text-xs py-1.5 px-3.5 shadow-sm">
                                                            Đăng ký <i data-lucide="arrow-right"
                                                                class="w-3.5 h-3.5"></i>
                                                        </a>
                                                    </div>
                                                </div>
                                            </article>
                                        </c:forEach>
                                    </div>

                                    <div data-pagination-controls
                                        class="mt-8 flex flex-col sm:flex-row items-center justify-between gap-3"></div>
                                </c:otherwise>
                            </c:choose>
                        </section>
                    </div>
                </main>

                <!-- Bottom CTA Banner -->
                <section class="border-t border-slate-200/80 bg-white py-14">
                    <div
                        class="max-w-7xl mx-auto px-4 sm:px-6 flex flex-col md:flex-row md:items-center md:justify-between gap-6">
                        <div>
                            <span
                                class="px-3 py-1 rounded-full bg-sky-100 text-sky-700 text-xs font-bold uppercase tracking-wider">
                                THAM GIA NGAY
                            </span>
                            <h2 class="text-2xl font-extrabold text-slate-900 tracking-tight mt-2">Sẵn sàng bắt đầu khóa
                                luận tốt nghiệp?</h2>
                            <p class="text-xs text-slate-500 mt-1">Đăng nhập tài khoản trường để tra cứu đề tài, lập
                                nhóm và nộp báo cáo trực tuyến.</p>
                        </div>
                        <div class="flex flex-wrap gap-3">
                            <a href="${pageContext.request.contextPath}/login"
                                class="btn-ui btn-ui-primary text-xs py-3 px-6 shadow-md shadow-sky-500/20">
                                <i data-lucide="log-in" class="w-4 h-4"></i> Đăng nhập hệ thống
                            </a>
                            <a href="${pageContext.request.contextPath}/register"
                                class="btn-ui btn-ui-outline text-xs py-3 px-5">
                                <i data-lucide="user-plus" class="w-4 h-4"></i> Đăng ký tài khoản
                            </a>
                        </div>
                    </div>
                </section>

                <!-- Footer -->
                <footer class="border-t border-slate-200 bg-slate-950 text-slate-400 mt-auto">
                    <div
                        class="max-w-7xl mx-auto px-4 sm:px-6 py-10 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 text-xs">
                        <div>
                            <div class="font-extrabold text-white text-sm mb-1">HCMUTE &bull; Trường Đại học Sư phạm Kỹ
                                thuật TP.HCM</div>
                            <div>Hệ thống Quản lý Đề tài Sinh viên &copy; 2026</div>
                        </div>
                        <div class="text-[11px] text-slate-500">
                            Java Spring Boot + JSP + Tailwind CSS
                        </div>
                    </div>
                </footer>

                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        if (typeof lucide !== 'undefined') lucide.createIcons();

                        // Pagination for public topic cards - Standard 10 items / page
                        const pageSize = 10;
                        const list = document.querySelector('[data-pagination-list]');
                        const controls = document.querySelector('[data-pagination-controls]');
                        if (!list || !controls) return;

                        const items = Array.from(list.querySelectorAll('[data-pagination-item]'));
                        const pageCount = Math.ceil(items.length / pageSize);
                        if (pageCount <= 1) return;

                        let currentPage = 1;
                        const render = function () {
                            const start = (currentPage - 1) * pageSize;
                            items.forEach(function (item, index) {
                                item.classList.toggle('hidden', index < start || index >= start + pageSize);
                            });

                            controls.innerHTML = '';
                            const summary = document.createElement('span');
                            summary.className = 'text-xs font-semibold text-slate-500';
                            summary.textContent = 'Trang ' + currentPage + ' / ' + pageCount;

                            const navigation = document.createElement('div');
                            navigation.className = 'flex items-center gap-1.5';
                            const previous = createPageButton('Trước', currentPage === 1);
                            previous.addEventListener('click', function () {
                                if (currentPage > 1) {
                                    currentPage -= 1;
                                    render();
                                }
                            });
                            navigation.appendChild(previous);

                            for (let page = 1; page <= pageCount; page += 1) {
                                const button = createPageButton(String(page), false);
                                if (page === currentPage) {
                                    button.className = 'min-w-8 h-8 px-2.5 rounded-xl bg-sky-600 text-white text-xs font-bold shadow-sm';
                                }
                                button.addEventListener('click', function () {
                                    currentPage = page;
                                    render();
                                });
                                navigation.appendChild(button);
                            }

                            const next = createPageButton('Sau', currentPage === pageCount);
                            next.addEventListener('click', function () {
                                if (currentPage < pageCount) {
                                    currentPage += 1;
                                    render();
                                }
                            });
                            navigation.appendChild(next);
                            controls.appendChild(summary);
                            controls.appendChild(navigation);
                        };

                        const createPageButton = function (label, disabled) {
                            const button = document.createElement('button');
                            button.type = 'button';
                            button.className = 'min-w-8 h-8 px-2.5 rounded-xl border border-slate-200 bg-white text-slate-600 text-xs font-bold hover:border-sky-300 hover:text-sky-600 disabled:opacity-40 disabled:cursor-not-allowed transition-colors';
                            button.textContent = label;
                            button.disabled = disabled;
                            return button;
                        };

                        render();
                    });
                </script>

                <!-- AI Assistant Chatbox Component -->
                <jsp:include page="common/ai-chatbox.jsp" />

                <script src="${pageContext.request.contextPath}/assets/js/enterprise-ui.js?v=4.4.1"></script>
            </body>

            </html>
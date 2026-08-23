<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HCMUTE FIT — Cổng Quản lý Đề tài Sinh viên</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: { sans: ['"Plus Jakarta Sans"', 'sans-serif'] },
                    colors: {
                        brand: { 50:'#eff6ff',100:'#dbeafe',500:'#3b82f6',600:'#2563eb',700:'#1d4ed8',800:'#1e40af',900:'#1e3a8a',950:'#0b1b3a' }
                    }
                }
            }
        }
    </script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        :root {
            --ink: #0f172a;
            --muted: #64748b;
            --brand: #2563eb;
            --hcmute-red: #dc2626;
        }
        body { font-family: "Plus Jakarta Sans", sans-serif; }
        .hero-plane {
            min-height: 590px;
            isolation: isolate;
            background:
                linear-gradient(90deg, rgba(2, 6, 23, .96) 0%, rgba(8, 30, 72, .88) 38%, rgba(8, 30, 72, .42) 68%, rgba(8, 30, 72, .24) 100%),
                url('${pageContext.request.contextPath}/assets/img/logo/images.jpg') 68% center / cover no-repeat;
        }
        .hero-plane::after {
            position: absolute;
            inset: 0;
            z-index: -1;
            background: linear-gradient(180deg, rgba(2, 6, 23, .12), rgba(2, 6, 23, .28));
            content: '';
        }
        .hero-content { max-width: 680px; }
        .hero-kicker { color: #bfdbfe; letter-spacing: .2em; }
        .hero-title { text-wrap: balance; text-shadow: 0 4px 26px rgba(2, 6, 23, .22); }
        .hero-copy { color: rgba(239, 246, 255, .86); }
        .hero-action { transition: transform .2s ease, box-shadow .2s ease, background-color .2s ease; }
        .hero-action:hover { transform: translateY(-2px); box-shadow: 0 14px 28px rgba(2, 6, 23, .24); }
        .period-strip { background: rgba(15, 23, 42, .35); border-color: rgba(191, 219, 254, .28); box-shadow: 0 18px 45px rgba(2, 6, 23, .16); }
        .brand-mark { position: relative; }
        .brand-mark::after { position: absolute; right: -2px; bottom: -2px; width: 9px; height: 9px; border: 2px solid white; border-radius: 999px; background: var(--hcmute-red); content: ''; }
        @media (max-width: 640px) {
            .hero-plane { min-height: 640px; background-position: 64% center; }
            .hero-title { font-size: 2.25rem; line-height: 1.12; }
        }
        .topic-card { transition: transform .22s ease, box-shadow .22s ease, border-color .22s ease; }
        .topic-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 18px 40px rgba(15, 23, 42, .1);
            border-color: #93c5fd;
        }
        .line-clamp-3 {
            display: -webkit-box;
            line-clamp: 3;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        .fade-up { animation: fadeUp .55s ease both; }
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(12px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .stat-card { transition: transform .2s ease, box-shadow .2s ease; }
        .stat-card:hover { transform: translateY(-2px); box-shadow: 0 12px 28px rgba(15,23,42,.08); }
    </style>
</head>
<body class="bg-slate-50 text-slate-800 antialiased">

<!-- Sticky Top Nav -->
<header class="sticky top-0 z-50 bg-white/90 backdrop-blur-md border-b border-slate-200/80">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 h-16 flex items-center justify-between gap-4">
        <a href="${pageContext.request.contextPath}/" class="flex items-center gap-3 min-w-0">
            <div class="brand-mark w-10 h-10 rounded-xl bg-gradient-to-br from-blue-600 to-blue-800 text-white flex items-center justify-center shadow-md shadow-blue-600/25 shrink-0">
                <i data-lucide="graduation-cap" class="w-5 h-5"></i>
            </div>
            <div class="min-w-0">
                <div class="font-extrabold text-slate-900 tracking-tight leading-none">HCMUTE · FIT</div>
                <div class="text-[10px] font-bold tracking-[0.14em] text-blue-600 mt-0.5">Thesis portal</div>
            </div>
        </a>

        <nav class="hidden md:flex items-center gap-1 text-xs font-semibold text-slate-600">
            <a href="#topicsSection" class="px-3 py-2 rounded-lg hover:bg-slate-100 hover:text-blue-700 transition-colors">Đề tài</a>
            <a href="#processSection" class="px-3 py-2 rounded-lg hover:bg-slate-100 hover:text-blue-700 transition-colors">Quy trình</a>
            <a href="#guideSection" class="px-3 py-2 rounded-lg hover:bg-slate-100 hover:text-blue-700 transition-colors">Hướng dẫn</a>
        </nav>

        <div class="flex items-center gap-2">
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <c:set var="dashUrl" value="${sessionScope.userRole == 'ADMIN' || sessionScope.userRole == 'DEAN' ? 'admin' : sessionScope.userRole == 'LECTURER' ? 'lecturer' : 'student'}" />
                    <a href="${pageContext.request.contextPath}/${dashUrl}/dashboard"
                       class="inline-flex items-center gap-2 px-4 py-2.5 rounded-xl bg-blue-600 hover:bg-blue-700 text-white text-xs font-bold shadow-sm transition-all">
                        <i data-lucide="layout-dashboard" class="w-4 h-4"></i>
                        <span class="hidden sm:inline">Bảng điều khiển</span>
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login"
                       class="inline-flex items-center gap-1.5 px-3.5 py-2 rounded-xl border border-slate-200 text-slate-700 text-xs font-bold hover:bg-slate-50 transition-colors">
                        <i data-lucide="log-in" class="w-4 h-4"></i> Đăng nhập
                    </a>
                    <a href="${pageContext.request.contextPath}/register"
                       class="inline-flex items-center gap-1.5 px-3.5 py-2 rounded-xl bg-blue-600 hover:bg-blue-700 text-white text-xs font-bold shadow-sm transition-all">
                        <i data-lucide="user-plus" class="w-4 h-4"></i>
                        <span class="hidden sm:inline">Đăng ký</span>
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</header>

<!-- Full-bleed Hero -->
<section class="hero-plane text-white relative overflow-hidden">
    <div class="absolute inset-0 opacity-[0.025]" style="background-image:url('data:image/svg+xml,%3Csvg width=\'60\' height=\'60\' viewBox=\'0 0 60 60\' xmlns=\'http://www.w3.org/2000/svg\'%3E%3Cg fill=\'none\' fill-rule=\'evenodd\'%3E%3Cg fill=\'%23ffffff\' fill-opacity=\'1\'%3E%3Cpath d=\'M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z\'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E');"></div>
    <div class="max-w-7xl mx-auto px-4 sm:px-6 py-16 sm:py-20 lg:py-24 relative z-10">
        <div class="hero-content fade-up">
            <p class="hero-kicker text-[11px] font-bold uppercase mb-5">Khoa Công nghệ Thông tin · HCMUTE</p>
            <h1 class="hero-title text-3xl sm:text-4xl lg:text-5xl font-extrabold tracking-tight leading-[1.15] mb-5">
                Hệ thống quản lý<br class="hidden sm:block"> đề tài sinh viên
            </h1>
            <p class="hero-copy text-sm sm:text-base leading-relaxed max-w-xl mb-9">
                Từ đề xuất đề tài, lập nhóm, đăng ký, nộp báo cáo đến hội đồng phản biện và công bố điểm — một cổng thông tin thống nhất cho Sinh viên, Giảng viên và Khoa.
            </p>
            <div class="flex flex-wrap gap-3">
                <a href="#topicsSection"
                   class="hero-action inline-flex items-center gap-2 px-5 py-3 rounded-xl bg-white text-blue-800 text-sm font-bold shadow-lg shadow-blue-950/20 hover:bg-blue-50">
                    <i data-lucide="search" class="w-4 h-4"></i> Tra cứu đề tài
                </a>
                <a href="${pageContext.request.contextPath}/login"
                         class="hero-action inline-flex items-center gap-2 px-5 py-3 rounded-xl border border-white/35 text-white text-sm font-bold hover:bg-white/10">
                    <i data-lucide="arrow-right" class="w-4 h-4"></i> Vào hệ thống
                </a>
            </div>
        </div>

        <!-- Active period strip (not floating badge clutter) -->
        <c:if test="${not empty activePeriod}">
            <div class="period-strip mt-14 max-w-3xl rounded-2xl border backdrop-blur-md p-4 sm:p-5 fade-up" style="animation-delay:.12s">
                <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3">
                    <div>
                        <div class="text-[10px] font-bold uppercase tracking-wider text-amber-300 mb-1">Đợt đang mở</div>
                        <div class="font-bold text-white text-sm sm:text-base">${activePeriod.name}</div>
                    </div>
                    <div class="flex flex-wrap gap-x-5 gap-y-1 text-xs text-blue-100">
                        <span class="inline-flex items-center gap-1.5"><i data-lucide="calendar" class="w-3.5 h-3.5"></i> SV đến ${activePeriod.studentEndDate}</span>
                        <c:if test="${not empty activePeriod.reviewerDeadline}">
                            <span class="inline-flex items-center gap-1.5"><i data-lucide="clock" class="w-3.5 h-3.5"></i> GVPB ${activePeriod.reviewerDeadline}</span>
                        </c:if>
                        <c:if test="${not empty activePeriod.councilReportDate}">
                            <span class="inline-flex items-center gap-1.5"><i data-lucide="scale" class="w-3.5 h-3.5"></i> HĐ ${activePeriod.councilReportDate}</span>
                        </c:if>
                    </div>
                </div>
            </div>
        </c:if>
    </div>
</section>

<!-- Stats -->
<section class="relative z-20 -mt-8 sm:-mt-10">
    <div class="max-w-7xl mx-auto px-4 sm:px-6">
        <div class="grid grid-cols-2 lg:grid-cols-4 gap-3 sm:gap-4">
            <div class="stat-card bg-white rounded-2xl border border-slate-200 p-4 sm:p-5 shadow-sm">
                <div class="flex items-center justify-between mb-2">
                    <span class="text-[10px] font-bold uppercase tracking-wider text-slate-500">Đề tài</span>
                    <span class="w-8 h-8 rounded-lg bg-blue-50 text-blue-600 flex items-center justify-center"><i data-lucide="book-marked" class="w-4 h-4"></i></span>
                </div>
                <div class="text-2xl sm:text-3xl font-black text-slate-900">${publishedTopics != null ? publishedTopics : totalTopics}</div>
                <div class="text-[11px] text-slate-500 mt-0.5 font-medium">Đã công bố</div>
            </div>
            <div class="stat-card bg-white rounded-2xl border border-slate-200 p-4 sm:p-5 shadow-sm">
                <div class="flex items-center justify-between mb-2">
                    <span class="text-[10px] font-bold uppercase tracking-wider text-slate-500">Nhóm SV</span>
                    <span class="w-8 h-8 rounded-lg bg-emerald-50 text-emerald-600 flex items-center justify-center"><i data-lucide="users" class="w-4 h-4"></i></span>
                </div>
                <div class="text-2xl sm:text-3xl font-black text-slate-900">${totalGroups}</div>
                <div class="text-[11px] text-slate-500 mt-0.5 font-medium">Đã thành lập</div>
            </div>
            <div class="stat-card bg-white rounded-2xl border border-slate-200 p-4 sm:p-5 shadow-sm">
                <div class="flex items-center justify-between mb-2">
                    <span class="text-[10px] font-bold uppercase tracking-wider text-slate-500">Giảng viên</span>
                    <span class="w-8 h-8 rounded-lg bg-amber-50 text-amber-600 flex items-center justify-center"><i data-lucide="user-check" class="w-4 h-4"></i></span>
                </div>
                <div class="text-2xl sm:text-3xl font-black text-slate-900">${totalLecturers}</div>
                <div class="text-[11px] text-slate-500 mt-0.5 font-medium">Hướng dẫn / HĐ</div>
            </div>
            <div class="stat-card bg-white rounded-2xl border border-slate-200 p-4 sm:p-5 shadow-sm">
                <div class="flex items-center justify-between mb-2">
                    <span class="text-[10px] font-bold uppercase tracking-wider text-slate-500">Sinh viên</span>
                    <span class="w-8 h-8 rounded-lg bg-sky-50 text-sky-600 flex items-center justify-center"><i data-lucide="graduation-cap" class="w-4 h-4"></i></span>
                </div>
                <div class="text-2xl sm:text-3xl font-black text-slate-900">${totalStudents}</div>
                <div class="text-[11px] text-slate-500 mt-0.5 font-medium">Tham gia hệ thống</div>
            </div>
        </div>
    </div>
</section>

<!-- Process -->
<section id="processSection" class="max-w-7xl mx-auto px-4 sm:px-6 py-12 sm:py-16">
    <div class="text-center max-w-2xl mx-auto mb-8">
        <h2 class="text-xl sm:text-2xl font-extrabold text-slate-900 tracking-tight">Quy trình 4 bước</h2>
        <p class="text-sm text-slate-500 mt-2">Luồng nghiệp vụ chuẩn từ Khoa đến Sinh viên và Hội đồng phản biện.</p>
    </div>
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <div class="bg-white rounded-2xl border border-slate-200 p-5 shadow-sm">
            <div class="w-9 h-9 rounded-xl bg-blue-600 text-white font-black text-sm flex items-center justify-center mb-3">01</div>
            <h3 class="font-bold text-slate-900 text-sm mb-1">Mở đợt & đề xuất</h3>
            <p class="text-xs text-slate-500 leading-relaxed">Khoa mở đợt đăng ký; Giảng viên đề xuất đề tài để duyệt.</p>
        </div>
        <div class="bg-white rounded-2xl border border-slate-200 p-5 shadow-sm">
            <div class="w-9 h-9 rounded-xl bg-blue-600 text-white font-black text-sm flex items-center justify-center mb-3">02</div>
            <h3 class="font-bold text-slate-900 text-sm mb-1">Lập nhóm & đăng ký</h3>
            <p class="text-xs text-slate-500 leading-relaxed">Nhóm tối đa 3 SV; Nhóm trưởng gửi yêu cầu đăng ký đề tài.</p>
        </div>
        <div class="bg-white rounded-2xl border border-slate-200 p-5 shadow-sm">
            <div class="w-9 h-9 rounded-xl bg-blue-600 text-white font-black text-sm flex items-center justify-center mb-3">03</div>
            <h3 class="font-bold text-slate-900 text-sm mb-1">Nộp báo cáo</h3>
            <p class="text-xs text-slate-500 leading-relaxed">Upload tiến độ / báo cáo cuối; GVHD theo dõi và phản hồi.</p>
        </div>
        <div class="bg-white rounded-2xl border border-slate-200 p-5 shadow-sm">
            <div class="w-9 h-9 rounded-xl bg-blue-600 text-white font-black text-sm flex items-center justify-center mb-3">04</div>
            <h3 class="font-bold text-slate-900 text-sm mb-1">Hội đồng & điểm</h3>
            <p class="text-xs text-slate-500 leading-relaxed">Phân công hội đồng, chấm điểm độc lập, công bố kết quả.</p>
        </div>
    </div>
</section>

<!-- Catalog: Filter + Topics + News -->
<main id="topicsSection" class="max-w-7xl mx-auto px-4 sm:px-6 pb-16">
    <div class="flex flex-col lg:flex-row gap-6 lg:gap-8">

        <!-- Left rail -->
        <aside class="lg:w-72 shrink-0 space-y-4">
            <div class="bg-white rounded-2xl border border-slate-200 shadow-sm p-5">
                <h3 class="text-sm font-extrabold text-slate-900 flex items-center gap-2 mb-4">
                    <i data-lucide="sliders-horizontal" class="w-4 h-4 text-blue-600"></i> Bộ lọc đề tài
                </h3>
                <form method="get" action="${pageContext.request.contextPath}/" class="space-y-3">
                    <div>
                        <label class="block text-[11px] font-bold text-slate-600 mb-1">Từ khóa</label>
                        <div class="relative">
                            <i data-lucide="search" class="w-4 h-4 text-slate-400 absolute left-3 top-1/2 -translate-y-1/2"></i>
                            <input type="text" name="keyword" value="${keyword}"
                                   placeholder="Mã, tên đề tài, GVHD..."
                                   class="w-full pl-9 pr-3 py-2.5 rounded-xl bg-slate-50 border border-slate-200 text-xs focus:bg-white focus:ring-2 focus:ring-blue-500 focus:outline-none">
                        </div>
                    </div>
                    <div>
                        <label class="block text-[11px] font-bold text-slate-600 mb-1">Bộ môn</label>
                        <select name="departmentId"
                                class="w-full px-3 py-2.5 rounded-xl bg-slate-50 border border-slate-200 text-xs font-semibold focus:bg-white focus:ring-2 focus:ring-blue-500 focus:outline-none">
                            <option value="">-- Tất cả Bộ môn --</option>
                            <c:forEach var="dept" items="${departments}">
                                <option value="${dept.id}" ${selectedDept == dept.id ? 'selected' : ''}>${dept.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <button type="submit"
                            class="w-full py-2.5 rounded-xl bg-blue-600 hover:bg-blue-700 text-white text-xs font-bold transition-colors flex items-center justify-center gap-2">
                        <i data-lucide="filter" class="w-3.5 h-3.5"></i> Áp dụng lọc
                    </button>
                    <c:if test="${not empty keyword || not empty selectedDept}">
                        <a href="${pageContext.request.contextPath}/" class="block text-center text-[11px] font-semibold text-slate-500 hover:text-blue-600">Xóa bộ lọc</a>
                    </c:if>
                </form>
            </div>

            <div id="guideSection" class="bg-white rounded-2xl border border-slate-200 shadow-sm p-5">
                <h3 class="text-sm font-extrabold text-slate-900 flex items-center gap-2 mb-4">
                    <i data-lucide="book-open" class="w-4 h-4 text-blue-600"></i> Hướng dẫn nhanh
                </h3>
                <ol class="space-y-3 text-xs text-slate-600">
                    <li class="flex gap-2.5">
                        <span class="w-5 h-5 rounded-md bg-blue-600 text-white text-[10px] font-bold flex items-center justify-center shrink-0">1</span>
                        <span><strong class="text-slate-800">Đăng nhập</strong> bằng email HCMUTE (SV / GV / Khoa).</span>
                    </li>
                    <li class="flex gap-2.5">
                        <span class="w-5 h-5 rounded-md bg-blue-600 text-white text-[10px] font-bold flex items-center justify-center shrink-0">2</span>
                        <span><strong class="text-slate-800">Sinh viên:</strong> tạo nhóm (tối đa 3 SV), Nhóm trưởng đăng ký đề tài.</span>
                    </li>
                    <li class="flex gap-2.5">
                        <span class="w-5 h-5 rounded-md bg-blue-600 text-white text-[10px] font-bold flex items-center justify-center shrink-0">3</span>
                        <span><strong class="text-slate-800">Giảng viên:</strong> đề xuất đề tài, duyệt nhóm và chấm hội đồng.</span>
                    </li>
                    <li class="flex gap-2.5">
                        <span class="w-5 h-5 rounded-md bg-blue-600 text-white text-[10px] font-bold flex items-center justify-center shrink-0">4</span>
                        <span><strong class="text-slate-800">Nộp báo cáo</strong> theo hạn đợt; xem lịch & điểm tại mục Kết quả.</span>
                    </li>
                </ol>
                <a href="${pageContext.request.contextPath}/login"
                   class="mt-4 w-full inline-flex items-center justify-center gap-2 px-3 py-2.5 rounded-xl bg-slate-900 hover:bg-slate-800 text-white text-xs font-bold transition-colors">
                    <i data-lucide="log-in" class="w-3.5 h-3.5"></i> Bắt đầu đăng nhập
                </a>
            </div>
        </aside>

        <!-- Topic grid -->
        <section class="flex-1 min-w-0">
            <div class="flex flex-col sm:flex-row sm:items-end sm:justify-between gap-2 mb-5">
                <div>
                    <h2 class="text-xl font-extrabold text-slate-900 tracking-tight">Đề tài công bố</h2>
                    <p class="text-xs text-slate-500 mt-0.5">Đăng nhập bằng tài khoản Nhóm trưởng để gửi yêu cầu đăng ký.</p>
                </div>
                <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-blue-50 text-blue-700 text-[11px] font-bold border border-blue-100 self-start sm:self-auto">
                    ${fn:length(topics)} đề tài
                </span>
            </div>

            <c:choose>
                <c:when test="${empty topics}">
                    <div class="bg-white rounded-2xl border border-dashed border-slate-300 p-12 text-center">
                        <div class="w-14 h-14 rounded-2xl bg-slate-100 text-slate-400 flex items-center justify-center mx-auto mb-3">
                            <i data-lucide="inbox" class="w-7 h-7"></i>
                        </div>
                        <h3 class="font-bold text-slate-800 text-sm">Không tìm thấy đề tài</h3>
                        <p class="text-xs text-slate-500 mt-1 max-w-sm mx-auto">Thử đổi từ khóa hoặc chọn lại bộ môn. Có thể đợt hiện tại chưa công bố đề tài mới.</p>
                        <a href="${pageContext.request.contextPath}/" class="inline-flex mt-4 text-xs font-bold text-blue-600 hover:text-blue-700">Xem tất cả đề tài</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <c:forEach var="topic" items="${topics}">
                            <article class="topic-card bg-white rounded-2xl border border-slate-200 p-5 shadow-sm flex flex-col">
                                <div class="flex items-start justify-between gap-2 mb-3">
                                    <span class="px-2.5 py-1 rounded-lg font-mono text-[11px] font-bold bg-blue-50 text-blue-700 border border-blue-100">${topic.code}</span>
                                    <span class="px-2 py-0.5 rounded-md text-[10px] font-semibold bg-slate-100 text-slate-600 border border-slate-200 truncate max-w-[45%]">
                                        ${topic.department != null ? topic.department.name : 'CNTT'}
                                    </span>
                                </div>
                                <h3 class="text-sm font-bold text-slate-900 leading-snug mb-2 line-clamp-2">${topic.title}</h3>
                                <p class="text-xs text-slate-500 leading-relaxed line-clamp-3 mb-4 flex-1">
                                    ${topic.description != null ? topic.description : 'Chưa có mô tả chi tiết.'}
                                </p>
                                <div class="pt-3 border-t border-slate-100 space-y-2.5">
                                    <div class="text-xs text-slate-700 flex items-start gap-1.5">
                                        <i data-lucide="user-check" class="w-3.5 h-3.5 text-blue-600 mt-0.5 shrink-0"></i>
                                        <span>
                                            <span class="text-slate-500">GVHD:</span>
                                            <strong class="font-semibold">${topic.lecturer != null ? topic.lecturer.user.fullName : 'Chưa phân công'}</strong>
                                            <c:if test="${not empty topic.coLecturer}">
                                                <span class="block text-[11px] text-slate-500 mt-0.5">Đồng HD: ${topic.coLecturer.user.fullName}</span>
                                            </c:if>
                                        </span>
                                    </div>
                                    <div class="flex items-center justify-between gap-2">
                                        <span class="text-[11px] font-semibold text-slate-500 bg-slate-50 border border-slate-200 px-2 py-0.5 rounded-md">
                                            <i class="fa-solid fa-users text-slate-400 mr-1"></i> Tối đa ${topic.maxStudents} SV
                                        </span>
                                        <a href="${pageContext.request.contextPath}/login"
                                           class="inline-flex items-center gap-1.5 px-3.5 py-1.5 rounded-xl bg-blue-600 hover:bg-blue-700 text-white text-xs font-bold transition-colors shadow-sm">
                                            Đăng ký <i data-lucide="arrow-right" class="w-3.5 h-3.5"></i>
                                        </a>
                                    </div>
                                </div>
                            </article>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>
    </div>
</main>

<!-- CTA -->
<section class="border-t border-slate-200 bg-white">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 py-12 flex flex-col md:flex-row md:items-center md:justify-between gap-6">
        <div>
            <h2 class="text-lg font-extrabold text-slate-900">Sẵn sàng tham gia đợt đăng ký?</h2>
            <p class="text-sm text-slate-500 mt-1">Đăng nhập bằng email HCMUTE để quản lý nhóm, đề tài và báo cáo.</p>
        </div>
        <div class="flex flex-wrap gap-2">
            <a href="${pageContext.request.contextPath}/login" class="inline-flex items-center gap-2 px-5 py-2.5 rounded-xl bg-blue-600 hover:bg-blue-700 text-white text-xs font-bold transition-colors">
                <i data-lucide="log-in" class="w-4 h-4"></i> Đăng nhập ngay
            </a>
            <a href="${pageContext.request.contextPath}/register" class="inline-flex items-center gap-2 px-5 py-2.5 rounded-xl border border-slate-200 text-slate-700 text-xs font-bold hover:bg-slate-50 transition-colors">
                Tạo tài khoản
            </a>
        </div>
    </div>
</section>

<footer class="border-t border-slate-200 bg-slate-950 text-slate-400">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 py-8 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3 text-xs">
        <div>
            <div class="font-bold text-white mb-0.5">HCMUTE · Khoa Công nghệ Thông tin</div>
            <div>Hệ thống Quản lý Đề tài Sinh viên © 2026</div>
        </div>
        <div class="text-[11px]">Enterprise Portal · Spring Boot MVC + Tailwind</div>
    </div>
</footer>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        if (typeof lucide !== 'undefined') lucide.createIcons();
    });
</script>
</body>
</html>

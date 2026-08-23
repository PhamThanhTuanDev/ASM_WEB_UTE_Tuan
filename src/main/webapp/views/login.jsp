<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - Hệ thống Quản lý Đề tài Khoa CNTT (HCMUTE)</title>
    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: {
                        sans: ['"Plus Jakarta Sans"', 'sans-serif'],
                    },
                    colors: {
                        brand: {
                            50: '#eff6ff',
                            100: '#dbeafe',
                            500: '#3b82f6',
                            600: '#2563eb',
                            700: '#1d4ed8',
                            800: '#1e40af',
                            900: '#1e3a8a',
                            950: '#0f172a',
                        }
                    }
                }
            }
        }
    </script>
    <!-- Lucide Icons -->
    <script src="https://unpkg.com/lucide@latest"></script>
</head>
<body class="bg-gradient-to-br from-slate-950 via-blue-950 to-indigo-950 min-h-screen flex items-center justify-center p-4 antialiased font-sans relative overflow-x-hidden">
    <!-- Ambient Light Orbs -->
    <div class="absolute -top-32 -left-32 w-96 h-96 bg-blue-600/20 rounded-full blur-3xl pointer-events-none"></div>
    <div class="absolute -bottom-32 -right-32 w-96 h-96 bg-indigo-600/20 rounded-full blur-3xl pointer-events-none"></div>

    <div class="bg-white rounded-3xl shadow-2xl border border-white/20 overflow-hidden max-w-4xl w-full relative z-10 grid grid-cols-1 lg:grid-cols-12">
        <!-- Left Branding Panel (5 cols) -->
        <div class="lg:col-span-5 bg-gradient-to-br from-blue-900 via-indigo-900 to-blue-950 text-white p-8 lg:p-10 flex flex-col justify-between relative overflow-hidden hidden sm:flex">
            <!-- Background Decoration -->
            <div class="absolute -bottom-16 -right-16 w-64 h-64 bg-white/5 rounded-full blur-2xl pointer-events-none"></div>

            <div class="space-y-6 relative z-10">
                <div class="flex items-center gap-3">
                    <div class="w-12 h-12 rounded-2xl bg-gradient-to-tr from-blue-500 to-indigo-600 flex items-center justify-center text-white shadow-lg shadow-blue-500/30">
                        <i data-lucide="graduation-cap" class="w-7 h-7"></i>
                    </div>
                    <div>
                        <h2 class="font-black text-lg text-white leading-tight">HCMUTE &bull; FIT</h2>
                        <p class="text-[10px] uppercase font-bold tracking-wider text-blue-200">Khoa CNTT - Đề Tài Tốt Nghiệp</p>
                    </div>
                </div>

                <div class="space-y-2">
                    <h3 class="text-xl font-black text-white leading-snug">
                        Hệ Thống Quản Lý Đề Tài & Khóa Luận Tốt Nghiệp
                    </h3>
                    <p class="text-xs text-blue-100/80 leading-relaxed">
                        Tự động hóa toàn diện quy trình: Lập đợt, đề xuất đề tài, ghép nhóm 3 SV, nộp báo cáo tiến độ, chấm điểm phản biện và công bố kết quả.
                    </p>
                </div>

                <!-- RBAC Highlights -->
                <div class="p-4 bg-white/10 rounded-2xl border border-white/10 text-xs space-y-2.5">
                    <div class="font-bold text-amber-300 flex items-center gap-1.5 text-xs">
                        <i data-lucide="shield-check" class="w-4 h-4"></i> Phân Quyền Độc Lập 4 Vai Trò (RBAC):
                    </div>
                    <div class="grid grid-cols-2 gap-2 text-[11px] text-blue-100">
                        <div class="flex items-center gap-1">
                            <span class="w-1.5 h-1.5 rounded-full bg-rose-400"></span>
                            <span><strong>Admin:</strong> Toàn quyền</span>
                        </div>
                        <div class="flex items-center gap-1">
                            <span class="w-1.5 h-1.5 rounded-full bg-blue-400"></span>
                            <span><strong>Trưởng khoa:</strong> Duyệt đợt</span>
                        </div>
                        <div class="flex items-center gap-1">
                            <span class="w-1.5 h-1.5 rounded-full bg-amber-400"></span>
                            <span><strong>Giảng viên:</strong> Chấm điểm</span>
                        </div>
                        <div class="flex items-center gap-1">
                            <span class="w-1.5 h-1.5 rounded-full bg-emerald-400"></span>
                            <span><strong>Sinh viên:</strong> Nhóm 3 SV</span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="pt-6 border-t border-white/10 text-[11px] text-blue-200/90 flex items-center gap-2 relative z-10">
                <i data-lucide="mail-check" class="w-4 h-4 text-amber-300 shrink-0"></i>
                <span>Hỗ trợ đăng nhập trực tiếp qua <strong>Email HCMUTE</strong></span>
            </div>
        </div>

        <!-- Right Form Panel (7 cols) -->
        <div class="lg:col-span-7 p-8 lg:p-10 space-y-6">
            <div>
                <h3 class="text-xl font-black text-slate-900">Đăng Nhập Hệ Thống</h3>
                <p class="text-xs text-slate-500 mt-1">Nhập tài khoản email HCMUTE của bạn hoặc dùng nút Đăng nhập nhanh Demo</p>
            </div>

            <c:if test="${not empty error}">
                <div class="p-3.5 bg-rose-50 border border-rose-200 text-rose-800 rounded-2xl text-xs flex items-center gap-2">
                    <i data-lucide="alert-circle" class="w-4 h-4 text-rose-600 shrink-0"></i>
                    <span>${error}</span>
                </div>
            </c:if>

            <c:if test="${not empty successMessage}">
                <div class="p-3.5 bg-emerald-50 border border-emerald-200 text-emerald-800 rounded-2xl text-xs flex items-center gap-2">
                    <i data-lucide="check-circle" class="w-4 h-4 text-emerald-600 shrink-0"></i>
                    <span>${successMessage}</span>
                </div>
            </c:if>

            <!-- Login Form -->
            <form method="post" action="${pageContext.request.contextPath}/login" class="space-y-4">
                <div>
                    <label class="block text-xs font-bold text-slate-700 mb-1">Email HCMUTE / Gmail</label>
                    <div class="relative">
                        <i data-lucide="mail" class="w-4 h-4 text-slate-400 absolute left-3.5 top-1/2 -translate-y-1/2"></i>
                        <input type="email" name="email" value="25810176@student.hcmute.edu.vn" 
                               class="w-full pl-10 pr-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs font-medium focus:bg-white focus:ring-2 focus:ring-blue-500 focus:outline-none" required>
                    </div>
                </div>

                <div>
                    <div class="flex items-center justify-between mb-1">
                        <label class="block text-xs font-bold text-slate-700">Mật khẩu</label>
                        <a href="javascript:void(0)" class="text-[11px] font-semibold text-blue-600 hover:underline">Quên mật khẩu?</a>
                    </div>
                    <div class="relative">
                        <i data-lucide="lock" class="w-4 h-4 text-slate-400 absolute left-3.5 top-1/2 -translate-y-1/2"></i>
                        <input type="password" name="password" value="123456"
                               placeholder="Mật khẩu mặc định: 123456"
                               class="w-full pl-10 pr-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs font-medium focus:bg-white focus:ring-2 focus:ring-blue-500 focus:outline-none" required>
                        <p class="mt-1.5 text-[10px] text-slate-400">Tài khoản demo: mật khẩu mặc định <strong class="text-slate-600">123456</strong></p>
                    </div>
                </div>

                <button type="submit" class="w-full py-3 bg-blue-600 hover:bg-blue-700 text-white font-bold rounded-xl text-xs shadow-sm hover:shadow-md transition-all flex items-center justify-center gap-2">
                    <i data-lucide="log-in" class="w-4 h-4"></i> Đăng Nhập Vào Cổng Thông Tin
                </button>
            </form>

            <!-- Quick Demo 1-Click Switcher for Instant Testing (4 Roles) -->
            <div class="pt-4 border-t border-slate-100 space-y-3">
                <div class="text-[11px] font-bold uppercase tracking-wider text-slate-400 flex items-center gap-1">
                    <i data-lucide="zap" class="w-3.5 h-3.5 text-amber-500"></i> Đăng nhập nhanh Demo 1-Click (4 Quyền HCMUTE):
                </div>

                <div class="grid grid-cols-1 sm:grid-cols-2 gap-2">
                    <a href="${pageContext.request.contextPath}/quick-login?username=admin@hcmute.edu.vn" 
                       class="p-2.5 rounded-xl bg-slate-900 hover:bg-slate-800 text-white flex items-center gap-2.5 transition-all group shadow-xs">
                        <div class="w-8 h-8 rounded-lg bg-rose-600 text-white flex items-center justify-center shrink-0">
                            <i data-lucide="shield-alert" class="w-4 h-4"></i>
                        </div>
                        <div class="min-w-0">
                            <div class="font-bold text-xs truncate">1. Quản Trị Viên (Admin)</div>
                            <div class="text-[10px] text-slate-400 truncate">admin@hcmute.edu.vn</div>
                        </div>
                    </a>

                    <a href="${pageContext.request.contextPath}/quick-login?username=dean.fit@hcmute.edu.vn" 
                       class="p-2.5 rounded-xl bg-blue-600 hover:bg-blue-700 text-white flex items-center gap-2.5 transition-all group shadow-xs">
                        <div class="w-8 h-8 rounded-lg bg-white/20 text-white flex items-center justify-center shrink-0">
                            <i data-lucide="user-check" class="w-4 h-4"></i>
                        </div>
                        <div class="min-w-0">
                            <div class="font-bold text-xs truncate">2. Trưởng Khoa (Dean)</div>
                            <div class="text-[10px] text-blue-200 truncate">dean.fit@hcmute.edu.vn / 123456</div>
                        </div>
                    </a>

                    <a href="${pageContext.request.contextPath}/quick-login?username=25810176@teacher.hcmute.edu.vn" 
                       class="p-2.5 rounded-xl bg-amber-50 hover:bg-amber-100 border border-amber-200 text-slate-900 flex items-center gap-2.5 transition-all group">
                        <div class="w-8 h-8 rounded-lg bg-amber-500 text-white flex items-center justify-center shrink-0">
                            <i data-lucide="book-marked" class="w-4 h-4"></i>
                        </div>
                        <div class="min-w-0">
                            <div class="font-bold text-xs truncate">3. Giảng Viên (TS. An)</div>
                            <div class="text-[10px] text-slate-500 truncate">25810176@teacher...</div>
                        </div>
                    </a>

                    <a href="${pageContext.request.contextPath}/quick-login?username=25810176@student.hcmute.edu.vn" 
                       class="p-2.5 rounded-xl bg-emerald-50 hover:bg-emerald-100 border border-emerald-200 text-slate-900 flex items-center gap-2.5 transition-all group">
                        <div class="w-8 h-8 rounded-lg bg-emerald-600 text-white flex items-center justify-center shrink-0">
                            <i data-lucide="crown" class="w-4 h-4"></i>
                        </div>
                        <div class="min-w-0">
                            <div class="font-bold text-xs truncate">4. SV Nhóm Trưởng</div>
                            <div class="text-[10px] text-slate-500 truncate">25810176@student...</div>
                        </div>
                    </a>
                </div>
            </div>

            <div class="text-center pt-2 text-xs text-slate-500">
                <span>Chưa có tài khoản?</span>
                <a href="${pageContext.request.contextPath}/register" class="text-blue-600 font-bold hover:underline ml-1">Đăng ký mới</a>
                <span class="mx-2">&bull;</span>
                <a href="${pageContext.request.contextPath}/" class="hover:underline">Về trang chủ</a>
            </div>
        </div>
    </div>

    <script>
        lucide.createIcons();
    </script>
</body>
</html>


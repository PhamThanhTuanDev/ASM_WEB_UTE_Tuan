<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập | Cổng Quản Lý Đề Tài HCMUTE</title>
    <meta name="description" content="Đăng nhập hệ thống quản lý đề tài khoa CNTT - HCMUTE">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logo/logo_hcmute.png">

    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">

    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: { sans: ['"Be Vietnam Pro"', 'system-ui', 'sans-serif'] },
                    colors: {
                        brand: {
                            50: '#f0f9ff', 100: '#e0f2fe', 500: '#0ea5e9',
                            600: '#006da8', 700: '#00568c', 900: '#003865'
                        }
                    }
                }
            }
        }
    </script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/custom-theme.css?v=5.2.0">
    <style>
        .login-visual-container {
            background: linear-gradient(135deg, #003865 0%, #00568c 50%, #006da8 100%);
            box-shadow: inset -10px 0 30px rgba(0, 0, 0, 0.1);
        }
        .glass-panel {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        .demo-chip:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>

<body class="bg-gradient-to-br from-slate-950 via-slate-900 to-[#001e38] min-h-screen flex items-center justify-center p-4 antialiased font-sans relative overflow-x-hidden">
    
    <!-- Ambient Glowing Orbs -->
    <div class="absolute -top-40 -left-40 w-96 h-96 bg-brand-500/15 rounded-full blur-3xl pointer-events-none"></div>
    <div class="absolute -bottom-40 -right-40 w-96 h-96 bg-indigo-500/15 rounded-full blur-3xl pointer-events-none"></div>

    <!-- Main Card Container -->
    <div class="bg-white rounded-3xl shadow-2xl border border-white/20 overflow-hidden max-w-4xl w-full relative z-10 grid grid-cols-1 md:grid-cols-2">

        <!-- LEFT PANEL: Visual -->
        <div class="login-visual-container text-white p-6 lg:p-8 flex flex-col justify-between relative overflow-hidden hidden md:flex select-none">
            
            <div class="space-y-4 relative z-10">
                <div class="flex items-center gap-3">
                    <div class="w-10 h-10 bg-white rounded-xl flex items-center justify-center shadow-lg p-1">
                        <img src="${pageContext.request.contextPath}/assets/img/logo/logo_hcmute.png" alt="HCMUTE" class="w-full h-full object-contain">
                    </div>
                    <div>
                        <h2 class="text-sm font-black tracking-tight leading-none">HCMUTE • FIT</h2>
                        <p class="text-[10px] text-sky-200 font-bold uppercase tracking-wider mt-0.5">Khoa Công nghệ Thông tin</p>
                    </div>
                </div>

                <div class="pt-2">
                    <div class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full bg-white/10 text-sky-100 text-[10px] font-bold border border-white/20">
                        <i data-lucide="sparkles" class="w-3 h-3 text-amber-300"></i> Nền tảng quản lý đề tài
                    </div>
                    <h1 class="text-3xl font-black mt-3 leading-tight tracking-tight">Cổng Đề Tài và Khóa Luận</h1>
                    <p class="text-xs text-sky-100/90 mt-2 leading-relaxed opacity-90">Hệ thống thông minh kết nối Sinh viên, Giảng viên và Hội đồng. Tự động hóa từ đăng ký nhóm đến bảo vệ khóa luận.</p>
                </div>
            </div>

            <!-- Role Tags -->
            <div class="glass-panel rounded-2xl p-4 mt-6 relative z-10">
                <div class="text-[10px] text-sky-200 font-bold uppercase flex items-center gap-1.5 mb-2.5">
                    <i data-lucide="shield-check" class="w-3 h-3 text-amber-400"></i> Phân quyền chuyên biệt
                </div>
                <div class="grid grid-cols-2 gap-2 text-[11px] font-medium text-white/90">
                    <div class="flex items-center gap-1.5"><div class="w-1.5 h-1.5 rounded-full bg-rose-400"></div> Quản trị viên</div>
                    <div class="flex items-center gap-1.5"><div class="w-1.5 h-1.5 rounded-full bg-sky-400"></div> Trưởng khoa</div>
                    <div class="flex items-center gap-1.5"><div class="w-1.5 h-1.5 rounded-full bg-amber-400"></div> Giảng viên</div>
                    <div class="flex items-center gap-1.5"><div class="w-1.5 h-1.5 rounded-full bg-emerald-400"></div> Sinh viên</div>
                </div>
            </div>

            <!-- Background abstract shapes -->
            <div class="absolute -bottom-20 -right-20 w-64 h-64 border-[30px] border-white/5 rounded-full"></div>
            <div class="absolute -top-10 -right-10 w-32 h-32 bg-white/5 rounded-full blur-xl"></div>
        </div>

        <!-- RIGHT PANEL: Login Form -->
        <div class="p-6 lg:p-8 flex flex-col justify-center space-y-5 bg-white">
            
            <div class="text-center md:text-left">
                <h2 class="text-2xl font-black text-slate-900 tracking-tight">Đăng Nhập</h2>
                <p class="text-xs text-slate-500 mt-1">Truy cập không gian làm việc học thuật của bạn</p>
            </div>

            <!-- Alerts -->
            <c:if test="${param.error == 'account_not_found' || param.error == 'missing_profile' || param.error == 'account_disabled' || param.error == 'unverified_email'}">
                <div class="p-3 bg-rose-50 border border-rose-200 text-rose-800 rounded-xl text-xs">
                    Tài khoản chưa được cấp đầy đủ hồ sơ, đã bị khóa hoặc email chưa xác minh. Vui lòng liên hệ quản trị viên.
                </div>
            </c:if>
            <c:if test="${param.error == 'invalid_domain'}">
                <div class="p-3 bg-rose-50 border border-rose-200 text-rose-800 rounded-xl text-xs flex items-center gap-2">
                    <i data-lucide="alert-circle" class="w-4 h-4 text-rose-600 shrink-0"></i>
                    <span>Chỉ hỗ trợ email đuôi hcmute.edu.vn</span>
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="p-3 bg-rose-50 border border-rose-200 text-rose-800 rounded-xl text-xs flex items-center gap-2">
                    <i data-lucide="alert-circle" class="w-4 h-4 text-rose-600 shrink-0"></i>
                    <span>${error}</span>
                </div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="p-3 bg-rose-50 border border-rose-200 text-rose-800 rounded-xl text-xs flex items-center gap-2">
                    <i data-lucide="alert-circle" class="w-4 h-4 text-rose-600 shrink-0"></i>
                    <span><c:out value="${errorMessage}" /></span>
                </div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/login" class="space-y-3.5">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                <div>
                    <div class="relative">
                        <i data-lucide="mail" class="w-4 h-4 text-slate-400 absolute left-3.5 top-1/2 -translate-y-1/2"></i>
                        <input type="email" name="email" value="${param.email}" placeholder="Email (Ví dụ: 25810176@student.hcmute.edu.vn)"
                            class="w-full pl-10 pr-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs font-medium focus:bg-white focus:ring-2 focus:ring-brand-500 focus:outline-none transition-all" required>
                    </div>
                </div>

                <div>
                    <div class="relative">
                        <i data-lucide="lock" class="w-4 h-4 text-slate-400 absolute left-3.5 top-1/2 -translate-y-1/2"></i>
                        <input type="password" name="password" id="loginPassword" placeholder="Mật khẩu (Dùng thử: 123456)"
                            class="w-full pl-10 pr-11 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs font-medium focus:bg-white focus:ring-2 focus:ring-brand-500 focus:outline-none transition-all" required>
                        <button type="button" id="togglePassword" class="absolute right-3.5 top-1/2 -translate-y-1/2 text-slate-400 hover:text-brand-600">
                            <i data-lucide="eye" class="w-4 h-4"></i>
                        </button>
                    </div>
                    <div class="flex justify-end mt-1.5">
                        <a href="#" class="text-[10px] font-bold text-brand-600 hover:text-brand-700">Quên mật khẩu?</a>
                    </div>
                </div>

                <button type="submit" class="w-full py-2.5 bg-brand-600 hover:bg-brand-700 text-white font-bold rounded-xl text-xs shadow-md shadow-brand-600/20 hover:shadow-lg transition-all flex items-center justify-center gap-2 mt-2">
                    <i data-lucide="log-in" class="w-4 h-4"></i> Đăng nhập hệ thống
                </button>
            </form>

            <div class="relative flex py-1 items-center">
                <div class="flex-grow border-t border-slate-100"></div>
                <span class="flex-shrink-0 mx-3 text-slate-400 text-[10px] uppercase font-bold tracking-wider">Hoặc</span>
                <div class="flex-grow border-t border-slate-100"></div>
            </div>

            <a href="${pageContext.request.contextPath}/oauth2/authorization/google"
                class="w-full py-2.5 bg-white border border-slate-200 hover:bg-slate-50 text-slate-700 font-bold rounded-xl text-xs transition-all flex items-center justify-center gap-2 shadow-sm">
                <svg class="w-4 h-4" viewBox="0 0 24 24"><path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/><path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/><path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/><path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/></svg>
                Đăng nhập bằng Google (HCMUTE)
            </a>

            <!-- Compact Quick Demo Roles -->
            <c:if test="${quickLoginEnabled}">
            <div class="bg-slate-50 border border-slate-100 rounded-xl p-3 mt-2">
                <div class="text-[10px] font-bold text-slate-500 uppercase tracking-wider mb-2 text-center">Tài khoản trải nghiệm nhanh</div>
                <div class="flex flex-wrap justify-center gap-2">
                    <a href="${pageContext.request.contextPath}/quick-login?username=admin@hcmute.edu.vn" 
                        class="demo-chip flex items-center gap-1.5 px-3 py-1.5 bg-rose-50 text-rose-700 border border-rose-200 rounded-lg text-[10px] font-bold transition-all">
                        <i data-lucide="shield" class="w-3.5 h-3.5"></i> Quản trị viên
                    </a>
                    <a href="${pageContext.request.contextPath}/quick-login?username=dean.fit@hcmute.edu.vn" 
                        class="demo-chip flex items-center gap-1.5 px-3 py-1.5 bg-brand-50 text-brand-700 border border-brand-200 rounded-lg text-[10px] font-bold transition-all">
                        <i data-lucide="award" class="w-3.5 h-3.5"></i> Trưởng Khoa
                    </a>
                    <a href="${pageContext.request.contextPath}/quick-login?username=25810176@teacher.hcmute.edu.vn" 
                        class="demo-chip flex items-center gap-1.5 px-3 py-1.5 bg-amber-50 text-amber-700 border border-amber-200 rounded-lg text-[10px] font-bold transition-all">
                        <i data-lucide="book-open" class="w-3.5 h-3.5"></i> Giảng viên
                    </a>
                    <a href="${pageContext.request.contextPath}/quick-login?username=25810176@student.hcmute.edu.vn" 
                        class="demo-chip flex items-center gap-1.5 px-3 py-1.5 bg-emerald-50 text-emerald-700 border border-emerald-200 rounded-lg text-[10px] font-bold transition-all">
                        <i data-lucide="graduation-cap" class="w-3.5 h-3.5"></i> Sinh viên
                    </a>
                </div>
            </div>

            <!-- Footer -->
            </c:if>
            <div class="text-center pt-1">
                <a href="${pageContext.request.contextPath}/" class="text-[11px] text-slate-400 hover:text-brand-600 font-medium transition-colors">Về trang chủ Portal</a>
            </div>

        </div>
    </div>

    <!-- Scripts -->
    <script>
        lucide.createIcons();
        document.getElementById('togglePassword').addEventListener('click', function () {
            const pwdInput = document.getElementById('loginPassword');
            const icon = this.querySelector('i');
            if (pwdInput.type === 'password') {
                pwdInput.type = 'text';
                icon.setAttribute('data-lucide', 'eye-off');
            } else {
                pwdInput.type = 'password';
                icon.setAttribute('data-lucide', 'eye');
            }
            lucide.createIcons();
        });
    </script>
</body>
</html>

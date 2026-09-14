<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Đăng nhập | HCMUTE Thesis Portal</title>
            <meta name="description"
                content="Cổng quản lý đề tài tốt nghiệp Khoa CNTT - Trường ĐH Sư phạm Kỹ thuật TP.HCM">
            <meta name="theme-color" content="#003865">
            <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logo/logo_hcmute.png">

            <!-- Fonts -->
            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <link
                href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800;900&display=swap"
                rel="stylesheet">

            <!-- Tailwind CSS -->
            <script src="https://cdn.tailwindcss.com"></script>
            <script>
                tailwind.config = {
                    theme: {
                        extend: {
                            fontFamily: { sans: ['"Plus Jakarta Sans"', 'system-ui', 'sans-serif'] },
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
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/custom-theme.css?v=4.4.0">
        </head>

        <body
            class="bg-gradient-to-br from-slate-950 via-slate-900 to-[#001e38] min-h-screen flex items-center justify-center p-4 antialiased font-sans relative overflow-x-hidden">
            <!-- Page Loader -->
            <div id="pageLoader" class="page-loader" aria-label="Đang tải trang" role="status">
                <div class="page-loader-content">
                    <div class="page-loader-logo-wrap">
                        <img class="page-loader-logo"
                            src="${pageContext.request.contextPath}/assets/img/logo/logo_nav_hcmute.png" alt="HCMUTE">
                    </div>
                    <div class="page-loader-text">HCMUTE • THESIS PORTAL</div>
                </div>
            </div>

            <!-- Ambient Glowing Orbs -->
            <div class="absolute -top-40 -left-40 w-96 h-96 bg-sky-500/15 rounded-full blur-3xl pointer-events-none">
            </div>
            <div
                class="absolute -bottom-40 -right-40 w-96 h-96 bg-indigo-500/15 rounded-full blur-3xl pointer-events-none">
            </div>

            <!-- Main Card Container -->
            <div
                class="bg-white rounded-3xl shadow-2xl border border-white/20 overflow-hidden max-w-5xl w-full relative z-10 grid grid-cols-1 lg:grid-cols-12">

                <!-- LEFT PANEL: 3D Academic Visual (5 cols) -->
                <div
                    class="lg:col-span-5 login-visual-container text-white p-8 lg:p-10 flex flex-col justify-between relative overflow-hidden hidden sm:flex select-none">
                    <!-- 3D Geometric Objects with animation -->
                    <div class="login-3d-sphere" aria-hidden="true"></div>
                    <div class="hero-orbit" style="right: 2rem; top: 38%; width: 7rem; height: 7rem;"
                        aria-hidden="true"></div>
                    <!-- Floating layered glass badge & particles -->
                    <div class="academic-badge-float top-20 right-4" style="animation-delay: -1.5s;">
                        <i data-lucide="sparkles" class="w-3.5 h-3.5 text-amber-300"></i>
                        <span>FIT UTE Thesis</span>
                    </div>
                    <div class="floating-particle w-2 h-2 top-14 right-16" style="animation-delay: -2s;"></div>
                    <div class="floating-particle w-1.5 h-1.5 bottom-20 left-8" style="animation-delay: -4s;"></div>

                    <div class="space-y-6 relative z-10">
                        <!-- University Branding Lockup -->
                        <div class="flex items-center gap-3.5">
                            <div
                                class="w-12 h-12 rounded-2xl bg-gradient-to-tr from-sky-500 to-blue-700 flex items-center justify-center text-white shadow-lg shadow-sky-500/30 p-2">
                                <img src="${pageContext.request.contextPath}/assets/img/logo/logo_nav_hcmute.png"
                                    alt="HCMUTE" class="w-full h-full object-contain">
                            </div>
                            <div>
                                <h2 class="font-black text-lg text-white leading-tight tracking-tight">HCMUTE &bull; FIT
                                </h2>
                                <p class="text-[10px] uppercase font-bold tracking-widest text-sky-200">Khoa Công Nghệ
                                    Thông Tin</p>
                            </div>
                        </div>

                        <div class="space-y-2.5 pt-2">
                            <div
                                class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-sky-500/20 text-sky-300 text-[11px] font-bold border border-sky-400/30">
                                <i data-lucide="sparkles" class="w-3.5 h-3.5 text-amber-300"></i>
                                <span>Nền tảng Quản lý Đề tài Thông minh</span>
                            </div>
                            <h3 class="text-2xl font-black text-white leading-tight tracking-tight">
                                Cổng Đề Tài &amp; Khóa Luận Tốt Nghiệp
                            </h3>
                            <p class="text-xs text-sky-100/80 leading-relaxed">
                                Tự động hóa đồng bộ quy trình từ đề xuất, đăng ký nhóm sinh viên, nộp báo cáo tiến độ
                                đến bảo vệ hội đồng và xếp loại kết quả.
                            </p>
                        </div>

                        <!-- Academic Highlights Card -->
                        <div
                            class="p-4 bg-white/10 rounded-2xl border border-white/10 backdrop-blur-md text-xs space-y-2.5">
                            <div class="font-bold text-amber-300 flex items-center gap-1.5 text-xs">
                                <i data-lucide="shield-check" class="w-4 h-4"></i> Phân quyền chuyên biệt (RBAC):
                            </div>
                            <div class="grid grid-cols-2 gap-2 text-[11px] text-blue-100">
                                <div class="flex items-center gap-1.5">
                                    <span class="w-2 h-2 rounded-full bg-rose-400 shadow-sm shadow-rose-400/50"></span>
                                    <span><strong>Admin:</strong> Quản trị đợt</span>
                                </div>
                                <div class="flex items-center gap-1.5">
                                    <span class="w-2 h-2 rounded-full bg-sky-400 shadow-sm shadow-sky-400/50"></span>
                                    <span><strong>Trưởng khoa:</strong> Duyệt đề tài</span>
                                </div>
                                <div class="flex items-center gap-1.5">
                                    <span
                                        class="w-2 h-2 rounded-full bg-amber-400 shadow-sm shadow-amber-400/50"></span>
                                    <span><strong>Giảng viên:</strong> Chấm điểm</span>
                                </div>
                                <div class="flex items-center gap-1.5">
                                    <span
                                        class="w-2 h-2 rounded-full bg-emerald-400 shadow-sm shadow-emerald-400/50"></span>
                                    <span><strong>Sinh viên:</strong> Nhóm 3 SV</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div
                        class="pt-6 border-t border-white/10 text-[11px] text-sky-200/90 flex items-center gap-2 relative z-10">
                        <i data-lucide="check-circle-2" class="w-4 h-4 text-emerald-400 shrink-0"></i>
                        <span>Tài khoản xác thực theo chuẩn phân quyền Đại học</span>
                    </div>
                </div>

                <!-- RIGHT PANEL: Login Form (7 cols) -->
                <div class="lg:col-span-7 p-8 lg:p-12 flex flex-col justify-between space-y-6">
                    <div>
                        <div class="flex items-center justify-between">
                            <div>
                                <h3 class="text-2xl font-black text-slate-900 tracking-tight">Đăng Nhập</h3>
                                <p class="text-xs text-slate-500 mt-1">Truy cập không gian làm việc học thuật HCMUTE của
                                    bạn</p>
                            </div>
                            <div
                                class="w-10 h-10 rounded-xl bg-sky-50 text-sky-700 flex items-center justify-center border border-sky-100">
                                <i data-lucide="key-round" class="w-5 h-5"></i>
                            </div>
                        </div>

                        <!-- Alert Messages -->
                        <c:if test="${not empty error}">
                            <div
                                class="mt-4 p-3.5 bg-rose-50 border border-rose-200 text-rose-800 rounded-2xl text-xs flex items-center gap-2">
                                <i data-lucide="alert-circle" class="w-4 h-4 text-rose-600 shrink-0"></i>
                                <span>${error}</span>
                            </div>
                        </c:if>
                        <c:if test="${not empty errorMessage}">
                            <div
                                class="mt-4 p-3.5 bg-rose-50 border border-rose-200 text-rose-800 rounded-2xl text-xs flex items-center gap-2">
                                <i data-lucide="alert-circle" class="w-4 h-4 text-rose-600 shrink-0"></i>
                                <span>${errorMessage}</span>
                            </div>
                        </c:if>
                        <c:if test="${not empty successMessage}">
                            <div
                                class="mt-4 p-3.5 bg-emerald-50 border border-emerald-200 text-emerald-800 rounded-2xl text-xs flex items-center gap-2">
                                <i data-lucide="check-circle" class="w-4 h-4 text-emerald-600 shrink-0"></i>
                                <span>${successMessage}</span>
                            </div>
                        </c:if>

                        <!-- Login Form -->
                        <form method="post" action="${pageContext.request.contextPath}/login" class="space-y-4 mt-5">
                            <div>
                                <label class="block text-xs font-bold text-slate-700 mb-1.5">Email tài khoản
                                    HCMUTE</label>
                                <div class="relative">
                                    <i data-lucide="mail"
                                        class="w-4 h-4 text-slate-400 absolute left-3.5 top-1/2 -translate-y-1/2"></i>
                                    <input type="email" name="email" id="loginEmail" value="${param.email}"
                                        autocomplete="username" placeholder="email@hcmute.edu.vn"
                                        class="w-full pl-10 pr-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs font-medium focus:bg-white focus:ring-2 focus:ring-sky-500 focus:outline-none transition-all"
                                        required>
                                </div>
                            </div>

                            <div>
                                <div class="flex items-center justify-between mb-1.5">
                                    <label class="block text-xs font-bold text-slate-700">Mật khẩu</label>
                                    <a href="javascript:void(0)"
                                        class="text-[11px] font-semibold text-sky-600 hover:underline">Quên mật
                                        khẩu?</a>
                                </div>
                                <div class="relative">
                                    <i data-lucide="lock"
                                        class="w-4 h-4 text-slate-400 absolute left-3.5 top-1/2 -translate-y-1/2"></i>
                                    <input type="password" name="password" id="loginPassword"
                                        autocomplete="current-password" placeholder="Nhập mật khẩu (Demo: 123456)"
                                        class="w-full pl-10 pr-11 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs font-medium focus:bg-white focus:ring-2 focus:ring-sky-500 focus:outline-none transition-all"
                                        required>
                                    <button type="button" id="togglePassword"
                                        class="absolute right-3.5 top-1/2 -translate-y-1/2 text-slate-400 hover:text-sky-600 transition-colors"
                                        aria-label="Hiện mật khẩu">
                                        <i data-lucide="eye" class="w-4 h-4"></i>
                                    </button>
                                </div>
                                <p class="mt-1.5 text-[10px] text-slate-400">Tài khoản thử nghiệm có mật khẩu mặc định:
                                    <strong class="text-slate-600">123456</strong></p>
                            </div>

                            <div class="flex items-center justify-between pt-1">
                                <label
                                    class="flex items-center gap-2 text-[11px] text-slate-500 cursor-pointer select-none">
                                    <input type="checkbox" id="rememberEmail"
                                        class="w-3.5 h-3.5 rounded border-slate-300 text-sky-600 focus:ring-sky-500">
                                    Ghi nhớ email trên thiết bị này
                                </label>
                            </div>

                            <button type="submit"
                                class="w-full py-3 bg-sky-600 hover:bg-sky-700 text-white font-bold rounded-xl text-xs shadow-md shadow-sky-600/20 hover:shadow-lg transition-all flex items-center justify-center gap-2">
                                <i data-lucide="log-in" class="w-4 h-4"></i>
                                <span>Đăng Nhập Vào Cổng Thông Tin</span>
                            </button>
                        </form>

                        <!-- Quick Demo 1-Click Role Switcher -->
                        <div class="pt-5 mt-5 border-t border-slate-100 space-y-2.5">
                            <div
                                class="text-[10px] font-bold uppercase tracking-wider text-slate-400 flex items-center gap-1.5">
                                <i data-lucide="zap" class="w-3.5 h-3.5 text-amber-500"></i> Đăng nhập nhanh Demo (4 Vai
                                trò):
                            </div>
                            <div class="grid grid-cols-1 sm:grid-cols-2 gap-2">
                                <a href="${pageContext.request.contextPath}/quick-login?username=admin@hcmute.edu.vn"
                                    class="p-2.5 rounded-xl bg-slate-900 hover:bg-slate-800 text-white flex items-center gap-2.5 transition-all shadow-xs group">
                                    <div
                                        class="w-7 h-7 rounded-lg bg-rose-600 text-white flex items-center justify-center shrink-0">
                                        <i data-lucide="shield-alert" class="w-3.5 h-3.5"></i>
                                    </div>
                                    <div class="min-w-0">
                                        <div class="font-bold text-xs truncate">1. Quản Trị Viên (Admin)</div>
                                        <div class="text-[10px] text-slate-400 truncate">admin@hcmute.edu.vn</div>
                                    </div>
                                </a>

                                <a href="${pageContext.request.contextPath}/quick-login?username=dean.fit@hcmute.edu.vn"
                                    class="p-2.5 rounded-xl bg-sky-600 hover:bg-sky-700 text-white flex items-center gap-2.5 transition-all shadow-xs group">
                                    <div
                                        class="w-7 h-7 rounded-lg bg-white/20 text-white flex items-center justify-center shrink-0">
                                        <i data-lucide="award" class="w-3.5 h-3.5"></i>
                                    </div>
                                    <div class="min-w-0">
                                        <div class="font-bold text-xs truncate">2. Trưởng Khoa (Dean)</div>
                                        <div class="text-[10px] text-sky-200 truncate">dean.fit@hcmute.edu.vn</div>
                                    </div>
                                </a>

                                <a href="${pageContext.request.contextPath}/quick-login?username=25810176@teacher.hcmute.edu.vn"
                                    class="p-2.5 rounded-xl bg-amber-50 hover:bg-amber-100 border border-amber-200 text-slate-900 flex items-center gap-2.5 transition-all group">
                                    <div
                                        class="w-7 h-7 rounded-lg bg-amber-500 text-white flex items-center justify-center shrink-0">
                                        <i data-lucide="book-marked" class="w-3.5 h-3.5"></i>
                                    </div>
                                    <div class="min-w-0">
                                        <div class="font-bold text-xs truncate">3. Giảng Viên (TS. An)</div>
                                        <div class="text-[10px] text-slate-500 truncate">25810176@teacher...</div>
                                    </div>
                                </a>

                                <a href="${pageContext.request.contextPath}/quick-login?username=25810176@student.hcmute.edu.vn"
                                    class="p-2.5 rounded-xl bg-emerald-50 hover:bg-emerald-100 border border-emerald-200 text-slate-900 flex items-center gap-2.5 transition-all group">
                                    <div
                                        class="w-7 h-7 rounded-lg bg-emerald-600 text-white flex items-center justify-center shrink-0">
                                        <i data-lucide="graduation-cap" class="w-3.5 h-3.5"></i>
                                    </div>
                                    <div class="min-w-0">
                                        <div class="font-bold text-xs truncate">4. Sinh Viên (Nhóm Trưởng)</div>
                                        <div class="text-[10px] text-slate-500 truncate">25810176@student...</div>
                                    </div>
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Footer navigation -->
                    <div class="text-center pt-3 text-xs text-slate-500 border-t border-slate-100">
                        <span>Chưa có tài khoản?</span>
                        <a href="${pageContext.request.contextPath}/register" data-page-loader
                            class="text-sky-600 font-bold hover:underline ml-1">Đăng ký mới</a>
                        <span class="mx-2">&bull;</span>
                        <a href="${pageContext.request.contextPath}/" data-page-loader class="hover:underline">Về trang
                            chủ Portal</a>
                    </div>
                </div>
            </div>

            <!-- Scripts -->
            <script>
                lucide.createIcons();
                (function () {
                    const emailInput = document.getElementById('loginEmail');
                    const passwordInput = document.getElementById('loginPassword');
                    const rememberEmail = document.getElementById('rememberEmail');
                    const togglePassword = document.getElementById('togglePassword');
                    const rememberedEmail = window.localStorage.getItem('asmWebUte.loginEmail');

                    if (emailInput && !emailInput.value && rememberedEmail) {
                        emailInput.value = rememberedEmail;
                        if (rememberEmail) rememberEmail.checked = true;
                    }

                    if (togglePassword && passwordInput) {
                        togglePassword.addEventListener('click', function () {
                            const isPassword = passwordInput.type === 'password';
                            passwordInput.type = isPassword ? 'text' : 'password';
                            togglePassword.setAttribute('aria-label', isPassword ? 'Ẩn mật khẩu' : 'Hiện mật khẩu');
                            togglePassword.innerHTML = '<i data-lucide="' + (isPassword ? 'eye-off' : 'eye') + '" class="w-4 h-4"></i>';
                            lucide.createIcons();
                        });
                    }

                    const loginForm = document.querySelector('form[action$="/login"]');
                    if (loginForm && emailInput && rememberEmail) {
                        loginForm.addEventListener('submit', function () {
                            if (rememberEmail.checked) {
                                window.localStorage.setItem('asmWebUte.loginEmail', emailInput.value.trim());
                            } else {
                                window.localStorage.removeItem('asmWebUte.loginEmail');
                            }
                        });
                    }

                    const loader = document.getElementById('pageLoader');
                    const hideLoader = function () { window.setTimeout(function () { loader.classList.add('is-hidden'); }, 200); };
                    window.addEventListener('load', hideLoader, { once: true });
                    document.addEventListener('click', function (event) {
                        const link = event.target.closest('a[data-page-loader]');
                        if (!link || event.defaultPrevented || link.target === '_blank') return;
                        loader.classList.remove('is-hidden');
                    });
                })();
            </script>
            <script src="${pageContext.request.contextPath}/assets/js/enterprise-ui.js?v=4.4.0"></script>
        </body>

        </html>
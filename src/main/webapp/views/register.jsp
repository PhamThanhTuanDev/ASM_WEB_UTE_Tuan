<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Đăng ký tài khoản | HCMUTE Thesis Portal</title>
            <meta name="description"
                content="Đăng ký tài khoản sinh viên hoặc giảng viên trên cổng quản lý đề tài ASM_WEB_UTE của HCMUTE.">
            <meta name="theme-color" content="#003865">
            <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logo/logo_hcmute.png">

            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <link
                href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800;900&display=swap"
                rel="stylesheet">
            <script src="https://cdn.tailwindcss.com"></script>
            <script src="https://unpkg.com/lucide@latest"></script>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/custom-theme.css?v=4.4.0">
        </head>

        <body
            class="bg-gradient-to-br from-slate-950 via-slate-900 to-[#001e38] min-h-screen flex items-center justify-center p-4 antialiased font-sans relative overflow-x-hidden">
            <div id="pageLoader" class="page-loader" aria-label="Đang tải trang" role="status">
                <div class="page-loader-content">
                    <div class="page-loader-logo-wrap">
                        <img class="page-loader-logo"
                            src="${pageContext.request.contextPath}/assets/img/logo/logo_nav_hcmute.png" alt="HCMUTE">
                    </div>
                    <div class="page-loader-text">HCMUTE • THESIS PORTAL</div>
                </div>
            </div>

            <!-- 3D Perspective Grid Floor & Ambient Glow Orbs -->
            <div class="landing-grid-floor opacity-35 pointer-events-none" aria-hidden="true"></div>
            <div class="subtle-glowing-orb w-96 h-96 bg-sky-500/15 -top-20 -left-20" aria-hidden="true"></div>
            <div class="subtle-glowing-orb w-96 h-96 bg-indigo-500/15 -bottom-20 -right-20"
                style="animation-delay: -4s;" aria-hidden="true"></div>
            <div class="hero-orbit w-80 h-80 top-10 right-10 opacity-20 pointer-events-none hidden md:block"
                aria-hidden="true"></div>
            <div class="hero-3d-cube bottom-10 left-10 opacity-30 pointer-events-none hidden md:block"
                aria-hidden="true"></div>

            <div
                class="register-visual-card bg-white rounded-3xl shadow-2xl border border-white/20 overflow-hidden max-w-2xl w-full relative z-10 p-8 sm:p-10">
                <div class="text-center mb-6">
                    <div
                        class="w-12 h-12 rounded-2xl bg-sky-50 text-sky-700 flex items-center justify-center mx-auto mb-3 border border-sky-100 shadow-sm">
                        <i data-lucide="user-plus" class="w-6 h-6"></i>
                    </div>
                    <h1 class="text-2xl font-black text-slate-900 tracking-tight">Tạo Tài Khoản Hệ Thống</h1>
                    <p class="text-xs text-slate-500 mt-1">Cổng thông tin &amp; Quản lý đề tài Khoa CNTT &bull; HCMUTE
                    </p>
                </div>

                <c:if test="${not empty error}">
                    <div
                        class="p-3.5 bg-rose-50 border border-rose-200 text-rose-800 rounded-2xl text-xs flex items-center gap-2 mb-4">
                        <i data-lucide="alert-circle" class="w-4 h-4 text-rose-600 shrink-0"></i>
                        <span>${error}</span>
                    </div>
                </c:if>

                <form method="post" action="${pageContext.request.contextPath}/register" class="space-y-4">
                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                        <div>
                            <label class="block text-xs font-bold text-slate-700 mb-1.5">Tên đăng nhập
                                (Username)</label>
                            <input type="text" name="username" placeholder="Ví dụ: 21110006 hoặc gv006"
                                class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs font-medium focus:bg-white focus:ring-2 focus:ring-sky-500 focus:outline-none transition-all"
                                required>
                        </div>
                        <div>
                            <label class="block text-xs font-bold text-slate-700 mb-1.5">Mật khẩu</label>
                            <input type="password" name="password" placeholder="Tối thiểu 6 ký tự"
                                class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs font-medium focus:bg-white focus:ring-2 focus:ring-sky-500 focus:outline-none transition-all"
                                required>
                        </div>
                    </div>

                    <div>
                        <label class="block text-xs font-bold text-slate-700 mb-1.5">Họ và tên đầy đủ</label>
                        <input type="text" name="fullName" placeholder="Ví dụ: Nguyễn Văn Hùng"
                            class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs font-medium focus:bg-white focus:ring-2 focus:ring-sky-500 focus:outline-none transition-all"
                            required>
                    </div>

                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                        <div>
                            <label class="block text-xs font-bold text-slate-700 mb-1.5">Email trường cấp</label>
                            <input type="email" id="emailInput" name="email"
                                placeholder="25810176@student.hcmute.edu.vn"
                                class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs font-medium focus:bg-white focus:ring-2 focus:ring-sky-500 focus:outline-none transition-all"
                                required>
                            <div id="emailHint" class="text-[11px] text-slate-400 mt-1">Sinh viên:
                                MSSV@student.hcmute.edu.vn</div>
                        </div>
                        <div>
                            <label class="block text-xs font-bold text-slate-700 mb-1.5">Số điện thoại liên hệ</label>
                            <input type="text" name="phone" placeholder="090..."
                                class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs font-medium focus:bg-white focus:ring-2 focus:ring-sky-500 focus:outline-none transition-all"
                                required>
                        </div>
                    </div>

                    <div>
                        <label class="block text-xs font-bold text-slate-700 mb-1.5">Vai trò trong hệ thống</label>
                        <select id="roleInput" name="role"
                            class="w-full px-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs font-medium focus:bg-white focus:ring-2 focus:ring-sky-500 focus:outline-none transition-all"
                            required>
                            <option value="STUDENT">Sinh viên (STUDENT)</option>
                            <option value="LECTURER">Giảng viên (LECTURER)</option>
                        </select>
                    </div>

                    <button type="submit"
                        class="w-full py-3 bg-sky-600 hover:bg-sky-700 text-white font-bold rounded-xl text-xs shadow-md shadow-sky-600/20 hover:shadow-lg transition-all flex items-center justify-center gap-2 mt-2">
                        <i data-lucide="user-check" class="w-4 h-4"></i>
                        <span>Hoàn Tất Đăng Ký Tài Khoản</span>
                    </button>
                </form>

                <div class="text-center mt-5 text-xs text-slate-500 border-t border-slate-100 pt-4">
                    <span>Đã có tài khoản?</span>
                    <a href="${pageContext.request.contextPath}/login" data-page-loader
                        class="text-sky-600 font-bold hover:underline ms-1">Đăng nhập ngay</a>
                    <span class="mx-2">&bull;</span>
                    <a href="${pageContext.request.contextPath}/" data-page-loader class="hover:underline">Về trang
                        chủ</a>
                </div>
            </div>

            <script>
                lucide.createIcons();
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
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cập nhật hồ sơ sinh viên | HCMUTE Thesis Portal</title>
    <meta name="description" content="Cập nhật hồ sơ sinh viên Khoa CNTT - Trường ĐH Sư phạm Kỹ thuật TP.HCM">
    <meta name="theme-color" content="#003865">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/logo/logo_hcmute.png">

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

<body class="bg-gradient-to-br from-slate-950 via-slate-900 to-[#001e38] min-h-screen flex items-center justify-center p-4 antialiased font-sans relative overflow-x-hidden">
    <!-- Ambient Glowing Orbs -->
    <div class="absolute -top-40 -left-40 w-96 h-96 bg-sky-500/15 rounded-full blur-3xl pointer-events-none"></div>
    <div class="absolute -bottom-40 -right-40 w-96 h-96 bg-indigo-500/15 rounded-full blur-3xl pointer-events-none"></div>

    <!-- Main Card Container -->
    <div class="bg-white rounded-3xl shadow-2xl border border-white/20 overflow-hidden max-w-4xl w-full relative z-10">
        
        <!-- Header Section -->
        <div class="bg-gradient-to-r from-brand-600 to-brand-800 p-8 text-center text-white relative overflow-hidden">
            <!-- Decorative overlay -->
            <div class="absolute top-0 right-0 -mt-10 -mr-10 w-40 h-40 bg-white/10 rounded-full blur-2xl"></div>
            <div class="absolute bottom-0 left-0 -mb-10 -ml-10 w-40 h-40 bg-white/10 rounded-full blur-2xl"></div>
            
            <div class="relative z-10 flex flex-col items-center justify-center">
                <div class="w-16 h-16 rounded-2xl bg-white/10 backdrop-blur flex items-center justify-center mb-4 shadow-lg border border-white/20">
                    <i data-lucide="user-check" class="w-8 h-8 text-sky-100"></i>
                </div>
                <h2 class="text-3xl font-black mb-2 tracking-tight">Hoàn Thiện Hồ Sơ Sinh Viên</h2>
                <p class="text-sky-100/90 text-sm max-w-md mx-auto">Vui lòng cung cấp đầy đủ thông tin học thuật để hệ thống có thể sắp xếp nhóm và đề tài một cách chính xác nhất.</p>
            </div>
        </div>

        <!-- Form Section -->
        <form action="${pageContext.request.contextPath}/student/profile/update" method="POST" class="p-8 lg:p-10 space-y-6">
            <c:if test="${not empty errorMessage}">
                <div class="p-4 bg-rose-50 border border-rose-200 text-rose-800 rounded-2xl text-xs flex items-center gap-3 shadow-sm">
                    <i data-lucide="alert-circle" class="w-5 h-5 text-rose-600 shrink-0"></i>
                    <span class="font-medium">${errorMessage}</span>
                </div>
            </c:if>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-x-8 gap-y-6">
                <!-- MSSV -->
                <div>
                    <label class="block text-xs font-bold text-slate-700 mb-1.5">Mã số sinh viên *</label>
                    <div class="relative">
                        <i data-lucide="badge-info" class="w-4 h-4 text-slate-400 absolute left-3.5 top-1/2 -translate-y-1/2"></i>
                        <input type="text" name="studentCode" required value="${student.studentCode}"
                            class="w-full pl-10 pr-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-sm font-medium focus:bg-white focus:ring-2 focus:ring-sky-500 focus:outline-none transition-all" />
                    </div>
                </div>

                <!-- Điện thoại -->
                <div>
                    <label class="block text-xs font-bold text-slate-700 mb-1.5">Số điện thoại liên lạc *</label>
                    <div class="relative">
                        <i data-lucide="phone" class="w-4 h-4 text-slate-400 absolute left-3.5 top-1/2 -translate-y-1/2"></i>
                        <input type="text" name="phone" required value="${student.user.phone}"
                            class="w-full pl-10 pr-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-sm font-medium focus:bg-white focus:ring-2 focus:ring-sky-500 focus:outline-none transition-all" />
                    </div>
                </div>

                <!-- Khóa học -->
                <div>
                    <label class="block text-xs font-bold text-slate-700 mb-1.5">Khóa học (VD: K21) *</label>
                    <div class="relative">
                        <i data-lucide="calendar" class="w-4 h-4 text-slate-400 absolute left-3.5 top-1/2 -translate-y-1/2"></i>
                        <input type="text" name="courseYear" required value="${student.courseYear == 'Chưa cập nhật' ? '' : student.courseYear}"
                            class="w-full pl-10 pr-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-sm font-medium focus:bg-white focus:ring-2 focus:ring-sky-500 focus:outline-none transition-all" />
                    </div>
                </div>

                <!-- Lớp -->
                <div>
                    <label class="block text-xs font-bold text-slate-700 mb-1.5">Lớp (VD: 21T10201) *</label>
                    <div class="relative">
                        <i data-lucide="users" class="w-4 h-4 text-slate-400 absolute left-3.5 top-1/2 -translate-y-1/2"></i>
                        <input type="text" name="className" required value="${student.className == 'Chưa cập nhật' ? '' : student.className}"
                            class="w-full pl-10 pr-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-sm font-medium focus:bg-white focus:ring-2 focus:ring-sky-500 focus:outline-none transition-all" />
                    </div>
                </div>

                <!-- Ngành học -->
                <div>
                    <label class="block text-xs font-bold text-slate-700 mb-1.5">Ngành đào tạo *</label>
                    <div class="relative">
                        <i data-lucide="book-open" class="w-4 h-4 text-slate-400 absolute left-3.5 top-1/2 -translate-y-1/2"></i>
                        <input type="text" name="major" required value="${student.major == 'Chưa cập nhật' ? '' : student.major}" placeholder="Ví dụ: Công nghệ thông tin"
                            class="w-full pl-10 pr-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-sm font-medium focus:bg-white focus:ring-2 focus:ring-sky-500 focus:outline-none transition-all" />
                    </div>
                </div>

                <!-- Khoa -->
                <div>
                    <label class="block text-xs font-bold text-slate-700 mb-1.5">Khoa trực thuộc *</label>
                    <div class="relative">
                        <i data-lucide="building-2" class="w-4 h-4 text-slate-400 absolute left-3.5 top-1/2 -translate-y-1/2"></i>
                        <select name="departmentId" required
                            class="w-full pl-10 pr-3.5 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-sm font-medium focus:bg-white focus:ring-2 focus:ring-sky-500 focus:outline-none transition-all appearance-none">
                            <option value="">-- Chọn Khoa --</option>
                            <c:forEach items="${departments}" var="dept">
                                <option value="${dept.id}" ${student.department != null && student.department.id == dept.id ? 'selected' : '' }>
                                    ${dept.name}
                                </option>
                            </c:forEach>
                        </select>
                        <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center px-4 text-slate-500">
                            <i data-lucide="chevron-down" class="w-4 h-4"></i>
                        </div>
                    </div>
                </div>
            </div>

            <div class="pt-4 border-t border-slate-100 mt-6">
                <button type="submit"
                    class="w-full py-3 bg-brand-600 hover:bg-brand-700 text-white font-bold rounded-xl text-sm shadow-md shadow-brand-600/20 hover:shadow-lg hover:-translate-y-0.5 transition-all flex items-center justify-center gap-2">
                    <i data-lucide="save" class="w-4 h-4"></i>
                    <span>Lưu thông tin & Truy cập hệ thống</span>
                </button>
            </div>
        </form>
    </div>

    <script>
        lucide.createIcons();
    </script>
</body>

</html>
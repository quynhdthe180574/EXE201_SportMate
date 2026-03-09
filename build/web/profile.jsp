<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="model.User"%>
<%
    User u = (User) session.getAttribute("user");
    if (u == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ sơ | SportMate</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght@400;500;600&display=swap" rel="stylesheet"/>
    <script>
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        primary: "#13ec6d",
                        "primary-dark": "#0fa855",
                        "background-light": "#f8fafc",
                        "background-dark": "#0f172a",
                    },
                    fontFamily: { display: ["Inter"] },
                },
            },
        }
    </script>
    <style>
        body { font-family: 'Inter', sans-serif; }
        .tab-active { border-bottom: 3px solid #13ec6d; color: #13ec6d; font-weight: 700; }
        .edit-field { transition: all 0.3s; }
        .status-dot { animation: pulse 2s infinite; }
    </style>
</head>
<body class="bg-background-light dark:bg-background-dark min-h-screen">

<%-- ==================== HEADER GIỐNG HỆT CÁC TRANG TRƯỚC ==================== --%>
<%
    Object userObj = session.getAttribute("user");
    String userName = "";
    String userFirstChar = "U";
    if (userObj != null) {
        userName = ((User)userObj).getFullname();
        if (!userName.isEmpty()) userFirstChar = String.valueOf(userName.charAt(0)).toUpperCase();
    }
    pageContext.setAttribute("isLoggedIn", userObj != null);
    pageContext.setAttribute("userName", userName);
    pageContext.setAttribute("userFirstChar", userFirstChar);
%>
<header class="sticky top-0 z-50 w-full bg-white/80 dark:bg-background-dark/80 backdrop-blur-md border-b border-primary/10">
    <div class="max-w-7xl mx-auto px-6 py-5">
        <div class="flex justify-between items-center">
            <div class="flex items-center gap-3">
                <div class="bg-primary p-2.5 rounded-2xl">
                    <span class="material-symbols-outlined text-3xl text-white">sports_soccer</span>
                </div>
                <span class="text-3xl font-extrabold tracking-tighter text-slate-900 dark:text-white">Sport<span class="text-primary">Mate</span></span>
            </div>
            <nav class="hidden md:flex items-center gap-10 text-sm font-semibold">
                <a href="home.jsp" class="hover:text-primary transition-colors">Trang chủ</a>
                <a href="fieldList.jsp" class="hover:text-primary transition-colors">Danh sách sân</a>
                <a href="#" class="hover:text-primary transition-colors">Về chúng tôi</a>
                <a href="#" class="hover:text-primary transition-colors">Liên hệ</a>
            </nav>
            <div class="flex items-center gap-4">
                <c:choose>
                    <c:when test="${isLoggedIn}">
                        <div class="relative group">
                            <button class="flex items-center gap-3 px-4 py-2 rounded-3xl bg-primary/10 hover:bg-primary/20 transition-all">
                                <div class="w-8 h-8 rounded-2xl bg-primary flex items-center justify-center text-white font-bold text-sm">
                                    ${userFirstChar}
                                </div>
                                <span class="hidden sm:block font-semibold text-slate-900 dark:text-white">${userName}</span>
                                <span class="material-symbols-outlined text-xl">expand_more</span>
                            </button>
                            <div class="absolute right-0 mt-3 w-56 bg-white dark:bg-slate-800 rounded-3xl shadow-2xl border border-primary/10 py-2 opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all">
                                <div class="px-6 py-4 border-b border-primary/10">
                                    <p class="font-bold">${userName}</p>
                                    <p class="text-xs text-slate-500">Tài khoản của tôi</p>
                                </div>
                                <a href="profile.jsp" class="flex items-center gap-3 px-6 py-3 text-sm hover:bg-primary/5 font-medium">
                                    <span class="material-symbols-outlined">person</span>
                                    Hồ sơ cá nhân
                                </a>
                                <a href="bookingHistory.jsp" class="flex items-center gap-3 px-6 py-3 text-sm hover:bg-primary/5 font-medium">
                                    <span class="material-symbols-outlined">calendar_today</span>
                                    Lịch sử đặt sân
                                </a>
                                <div class="border-t border-primary/10 my-2"></div>
                                <a href="logout" class="flex items-center gap-3 px-6 py-3 text-red-600 hover:bg-red-50 font-medium">
                                    <span class="material-symbols-outlined">logout</span>
                                    Đăng xuất
                                </a>
                            </div>
                        </div>
                    </c:when>
                </c:choose>
            </div>
        </div>
    </div>
</header>

<div class="max-w-7xl mx-auto px-6 py-12">
    <div class="grid grid-cols-1 lg:grid-cols-12 gap-8">
        
        <!-- SIDEBAR -->
        <div class="lg:col-span-3">
            <div class="bg-white dark:bg-slate-900 rounded-3xl shadow-sm border border-slate-200 dark:border-slate-700 p-8 sticky top-24">
                <div class="text-center mb-8">
                    <div class="w-24 h-24 mx-auto bg-primary/10 rounded-3xl flex items-center justify-center text-5xl font-bold text-primary">
                        <%= u.getFullname().substring(0,1).toUpperCase() %>
                    </div>
                    <h3 class="mt-6 text-2xl font-bold"><%= u.getFullname() %></h3>
                    <p class="text-slate-500"><%= u.getEmail() %></p>
                </div>
                
                <div class="space-y-2">
                    <a href="profile.jsp" 
                       class="flex items-center gap-3 px-6 py-4 rounded-2xl bg-primary/10 text-primary font-semibold">
                        <span class="material-symbols-outlined">person</span>
                        Thông tin tài khoản
                    </a>
                    <a href="#" onclick="showTab('passwordTab')" 
                       class="flex items-center gap-3 px-6 py-4 rounded-2xl hover:bg-slate-100 dark:hover:bg-slate-800 transition text-slate-700 dark:text-slate-300">
                        <span class="material-symbols-outlined">lock</span>
                        Đổi mật khẩu
                    </a>
                    <a href="bookingHistory.jsp" 
                       class="flex items-center gap-3 px-6 py-4 rounded-2xl hover:bg-slate-100 dark:hover:bg-slate-800 transition text-slate-700 dark:text-slate-300">
                        <span class="material-symbols-outlined">calendar_today</span>
                        Lịch đã đặt
                    </a>
                </div>
            </div>
        </div>

        <!-- MAIN PROFILE CARD -->
        <div class="lg:col-span-9">
            <div class="bg-white dark:bg-slate-900 rounded-3xl shadow-sm border border-slate-200 dark:border-slate-700 p-10">
                
                <!-- TAB NAV -->
                <div class="flex border-b border-slate-200 dark:border-slate-700 mb-8">
                    <button onclick="showTab('profileTab')" 
                            id="tabProfileBtn"
                            class="tab-active px-8 py-4 text-lg">Thông tin cá nhân</button>
                    <button onclick="showTab('passwordTab')" 
                            id="tabPasswordBtn"
                            class="px-8 py-4 text-lg text-slate-500 hover:text-slate-900 dark:hover:text-white">Đổi mật khẩu</button>
                </div>

                <!-- TAB 1: THÔNG TIN CÁ NHÂN -->
                <div id="profileTab">
                    <div class="flex justify-between items-center mb-8">
                        <div>
                            <h2 class="text-3xl font-bold">Thông tin cá nhân</h2>
                            <p class="text-slate-500 mt-1">Quản lý thông tin hồ sơ để bảo mật tài khoản</p>
                        </div>
                    </div>
                    
                    <form action="edit-profile" method="post" id="profileForm">
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div>
                                <label class="block text-sm font-medium text-slate-600 mb-2">Họ & tên</label>
                                <input type="text" name="fullname" 
                                       value="<%= u.getFullname() %>"
                                       class="edit-field w-full px-5 py-4 bg-slate-100 dark:bg-slate-800 border-0 rounded-2xl focus:ring-2 focus:ring-primary" disabled>
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-slate-600 mb-2">Email</label>
                                <input type="email" name="email" 
                                       value="<%= u.getEmail() %>"
                                       class="edit-field w-full px-5 py-4 bg-slate-100 dark:bg-slate-800 border-0 rounded-2xl focus:ring-2 focus:ring-primary" disabled>
                            </div>
                        </div>
                        
                        <div class="mt-6">
                            <label class="block text-sm font-medium text-slate-600 mb-2">Số điện thoại</label>
                            <input type="text" name="phone" 
                                   value="<%= u.getPhone() %>"
                                   class="edit-field w-full px-5 py-4 bg-slate-100 dark:bg-slate-800 border-0 rounded-2xl focus:ring-2 focus:ring-primary" disabled>
                        </div>

                        <div class="mt-10 flex items-center justify-between">
                            <button type="button" id="editBtn"
                                    onclick="enableEdit()"
                                    class="bg-primary hover:bg-primary-dark text-white font-bold px-10 py-4 rounded-3xl transition flex items-center gap-3">
                                <span class="material-symbols-outlined">edit</span>
                                Chỉnh sửa
                            </button>
                            
                            <button type="submit" id="saveBtn"
                                    class="hidden bg-emerald-600 hover:bg-emerald-700 text-white font-bold px-10 py-4 rounded-3xl transition">
                                Lưu thay đổi
                            </button>
                            
                            <button type="button" onclick="confirmDelete()"
                                    class="border border-red-500 text-red-600 hover:bg-red-50 px-8 py-4 rounded-3xl font-medium transition">
                                Xóa tài khoản
                            </button>
                        </div>
                    </form>
                </div>

                <!-- TAB 2: ĐỔI MẬT KHẨU -->
                <div id="passwordTab" class="hidden">
                    <div class="max-w-md mx-auto text-center mb-8">
                        <h2 class="text-3xl font-bold">Đổi mật khẩu</h2>
                        <p class="text-slate-500 mt-2">Cập nhật mật khẩu để bảo vệ tài khoản</p>
                    </div>
                    
                    <form method="post" action="change-password" class="max-w-md mx-auto">
                        <div class="space-y-6">
                            <div>
                                <label class="block text-sm font-medium text-slate-600 mb-2">Mật khẩu cũ</label>
                                <input type="password" name="oldPassword" 
                                       class="w-full px-5 py-4 bg-slate-100 dark:bg-slate-800 border-0 rounded-2xl" required>
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-slate-600 mb-2">Mật khẩu mới</label>
                                <input type="password" name="newPassword" 
                                       class="w-full px-5 py-4 bg-slate-100 dark:bg-slate-800 border-0 rounded-2xl" required>
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-slate-600 mb-2">Xác nhận mật khẩu mới</label>
                                <input type="password" name="confirmPassword" 
                                       class="w-full px-5 py-4 bg-slate-100 dark:bg-slate-800 border-0 rounded-2xl" required>
                            </div>
                        </div>
                        
                        <button type="submit" 
                                class="mt-8 w-full bg-primary hover:bg-primary-dark text-white font-bold py-4 rounded-3xl transition">
                            Đổi mật khẩu
                        </button>
                    </form>
                    
                    <c:if test="${not empty error}">
                        <div class="mt-6 text-center text-red-600 font-medium">${error}</div>
                    </c:if>
                    <c:if test="${not empty success}">
                        <div class="mt-6 text-center text-emerald-600 font-medium">${success}</div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- FOOTER -->
<footer class="bg-slate-900 text-slate-400 py-10 mt-auto">
    <div class="max-w-7xl mx-auto px-6 text-center text-sm">
        © 2026 SportMate - Đặt sân thể thao. All rights reserved.
    </div>
</footer>

<!-- SweetAlert -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    function enableEdit() {
        document.querySelectorAll('.edit-field').forEach(el => {
            el.removeAttribute("disabled");
        });
        document.getElementById("editBtn").classList.add("hidden");
        document.getElementById("saveBtn").classList.remove("hidden");
    }

    function showTab(tabId) {
        document.getElementById("profileTab").classList.add("hidden");
        document.getElementById("passwordTab").classList.add("hidden");
        document.getElementById(tabId).classList.remove("hidden");

        // Update active tab style
        if (tabId === "profileTab") {
            document.getElementById("tabProfileBtn").classList.add("tab-active");
            document.getElementById("tabPasswordBtn").classList.remove("tab-active");
        } else {
            document.getElementById("tabProfileBtn").classList.remove("tab-active");
            document.getElementById("tabPasswordBtn").classList.add("tab-active");
        }
    }

    function confirmDelete() {
        Swal.fire({
            title: 'Bạn chắc chắn muốn xóa tài khoản?',
            text: "Hành động này không thể hoàn tác!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#dc2626',
            cancelButtonColor: '#64748b',
            confirmButtonText: 'Xóa ngay',
            cancelButtonText: 'Hủy'
        });
    }

    // SweetAlert thông báo (giữ nguyên logic cũ)
    <c:if test="${not empty profileSuccess}">
    Swal.fire({
        icon: 'success',
        title: 'Thành công!',
        text: '${profileSuccess}',
        showConfirmButton: false,
        timer: 2500
    });
    </c:if>
    <c:if test="${not empty passwordSuccess}">
    Swal.fire({
        icon: 'success',
        title: 'Thành công!',
        text: '${passwordSuccess}',
        showConfirmButton: false,
        timer: 2500
    });
    </c:if>
</script>
</body>
</html>
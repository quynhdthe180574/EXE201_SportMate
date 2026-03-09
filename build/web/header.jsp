<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- ==================== HEADER CHUẨN (dùng cho tất cả các trang) ==================== --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    // Import model.User (thêm dòng này nếu chưa có)
    model.User user = (model.User) session.getAttribute("user");
    String userName = "";
    String userFirstChar = "U";
    
    if (user != null) {
        userName = user.getFullname();
        if (userName == null || userName.trim().isEmpty()) {
            userName = user.getEmail(); // fallback nếu fullname rỗng
        }
        if (!userName.isEmpty()) {
            userFirstChar = String.valueOf(userName.charAt(0)).toUpperCase();
        }
    }
    pageContext.setAttribute("isLoggedIn", user != null);
    pageContext.setAttribute("userName", userName);
    pageContext.setAttribute("userFirstChar", userFirstChar);
%>
<header class="sticky top-0 z-50 w-full bg-white/80 dark:bg-background-dark/80 backdrop-blur-md border-b border-primary/10">
    <div class="max-w-7xl mx-auto px-6 py-5">
        <div class="flex justify-between items-center">
            <!-- Logo -->
            <div class="flex items-center gap-3">
                <div class="bg-primary p-2.5 rounded-2xl">
                    <span class="material-symbols-outlined text-3xl text-white">sports_soccer</span>
                </div>
                <span class="text-3xl font-extrabold tracking-tighter text-slate-900 dark:text-white">Sport<span class="text-primary">Mate</span></span>
            </div>

            <!-- Nav -->
            <nav class="hidden md:flex items-center gap-10 text-sm font-semibold">
                <a href="home.jsp" class="hover:text-primary transition-colors">Trang chủ</a>
                <a href="fieldList.jsp" class="hover:text-primary transition-colors">Danh sách sân</a>
                <a href="Aboutus.jsp" class="hover:text-primary transition-colors">Về chúng tôi</a>    
                <a href="Notification.jsp" class="hover:text-primary transition-colors">Thông báo</a>    
            </nav>

            <!-- User -->
            <div class="flex items-center gap-4">
                <c:choose>
                    <c:when test="${isLoggedIn}">
                        <div class="relative group">
                            <button class="flex items-center gap-3 px-5 py-2 rounded-3xl bg-primary/10 hover:bg-primary/20 transition-all">
                                <div class="w-8 h-8 rounded-2xl bg-primary flex items-center justify-center text-white font-bold text-sm">
                                    ${userFirstChar}
                                </div>
                                <span class="hidden sm:block font-semibold text-slate-900 dark:text-white">${userName}</span>
                                <span class="material-symbols-outlined text-xl">expand_more</span>
                            </button>
                            <!-- Dropdown -->
                            <div class="absolute right-0 mt-3 w-56 bg-white dark:bg-slate-800 rounded-3xl shadow-2xl border border-primary/10 py-2 opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all">
                                <a href="profile.jsp" class="flex items-center gap-3 px-6 py-3 text-sm hover:bg-primary/5">Hồ sơ cá nhân</a>
                                <a href="bookingHistory.jsp" class="flex items-center gap-3 px-6 py-3 text-sm hover:bg-primary/5">Lịch sử đặt sân</a>
                                <div class="border-t border-primary/10 my-2"></div>
                                <a href="logout" class="flex items-center gap-3 px-6 py-3 text-red-600 hover:bg-red-50">Đăng xuất</a>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <a href="login.jsp" class="px-6 py-3 font-semibold hover:text-primary">Đăng nhập</a>
                        <a href="register.jsp" class="px-8 py-3 bg-primary text-white font-bold rounded-3xl">Đăng ký</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</header>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch sử đặt sân</title>
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
        .status-badge {
            padding: 6px 16px;
            border-radius: 9999px;
            font-size: 0.85rem;
            font-weight: 600;
        }
        tr:hover { background-color: #f8fafc; }
    </style>
</head>
<body class="bg-background-light dark:bg-background-dark min-h-screen">

<%-- ==================== HEADER GIỐNG HỆT CÁC TRANG TRƯỚC (SportMate) ==================== --%>
<%
    // Get user from session (giữ nguyên logic cũ của bạn)
    model.User user = (model.User) session.getAttribute("user");
    String userName = "";
    String userFirstChar = "U";
    
    if (user != null) {
        userName = user.getFullname();
        if (userName == null || userName.trim().isEmpty()) {
            userName = user.getEmail(); // fallback
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

            <!-- Navigation -->
            <nav class="hidden md:flex items-center gap-10 text-sm font-semibold">
                <a href="home.jsp" class="hover:text-primary transition-colors">Trang chủ</a>
                <a href="fieldList.jsp" class="hover:text-primary transition-colors">Danh sách sân</a>
                <a href="#" class="hover:text-primary transition-colors">Về chúng tôi</a>
                <a href="#" class="hover:text-primary transition-colors">Liên hệ</a>
                 <a href="BookingHistory" class="text-primary font-semibold border-b-2 border-primary pb-1">Lịch sử</a>
            </nav>

            <!-- User Area -->
            <div class="flex items-center gap-4">
                <c:choose>
                    <c:when test="${isLoggedIn}">
                        <!-- Avatar + Dropdown -->
                        <div class="relative group">
                            <button class="flex items-center gap-3 px-4 py-2 rounded-3xl bg-primary/10 hover:bg-primary/20 transition-all">
                                <div class="w-8 h-8 rounded-2xl bg-primary flex items-center justify-center text-white font-bold text-sm">
                                    ${userFirstChar}
                                </div>
                                <span class="hidden sm:block font-semibold text-slate-900 dark:text-white">${userName}</span>
                                <span class="material-symbols-outlined text-xl">expand_more</span>
                            </button>
                            <!-- Dropdown -->
                            <div class="absolute right-0 mt-3 w-56 bg-white dark:bg-slate-800 rounded-3xl shadow-2xl border border-primary/10 py-2 opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all">
                                <div class="px-6 py-4 border-b border-primary/10">
                                    <p class="font-bold">${userName}</p>
                                    <p class="text-xs text-slate-500">Tài khoản của tôi</p>
                                </div>
                                <a href="bookingHistory.jsp" class="flex items-center gap-3 px-6 py-3 text-sm hover:bg-primary/5 font-medium">
                                    <span class="material-symbols-outlined">calendar_today</span>
                                    Lịch sử đặt sân
                                </a>
                                <a href="profile.jsp" class="flex items-center gap-3 px-6 py-3 text-sm hover:bg-primary/5 font-medium">
                                    <span class="material-symbols-outlined">person</span>
                                    Hồ sơ cá nhân
                                </a>
                                <div class="border-t border-primary/10 my-2"></div>
                                <a href="logout" class="flex items-center gap-3 px-6 py-3 text-red-600 hover:bg-red-50 font-medium">
                                    <span class="material-symbols-outlined">logout</span>
                                    Đăng xuất
                                </a>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <a href="login.jsp" class="px-6 py-3 font-semibold hover:text-primary">Đăng nhập</a>
                        <a href="signup.jsp" class="px-8 py-3 bg-primary text-white font-bold rounded-3xl hover:bg-primary-dark transition">Đăng ký</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</header>

<!-- ==================== NỘI DUNG CHÍNH (GIỮ NGUYÊN BACKEND) ==================== -->
<div class="max-w-7xl mx-auto px-6 py-12">
    <div class="flex justify-between items-end mb-10">
        <div>
            <h1 class="text-4xl font-extrabold tracking-tight">Lịch sử đặt sân</h1>
            <p class="text-slate-600 dark:text-slate-400 mt-2">Xem và quản lý tất cả lượt đặt sân của bạn</p>
        </div>
        <a href="home.jsp" class="flex items-center gap-3 bg-primary text-white px-8 py-4 rounded-3xl font-bold hover:scale-105 transition">
            <span class="material-symbols-outlined">add_circle</span>
            Đặt sân mới
        </a>
    </div>

    <div class="bg-white dark:bg-slate-900 rounded-3xl shadow-sm border border-slate-200 dark:border-slate-700 overflow-hidden">
        <div class="overflow-x-auto">
            <table class="w-full">
                <thead>
                    <tr class="bg-slate-50 dark:bg-slate-800 border-b">
                        <th class="px-10 py-6 text-left text-sm font-semibold text-slate-500">MÃ ĐẶT SÂN</th>
                        <th class="px-10 py-6 text-left text-sm font-semibold text-slate-500">SÂN</th>
                        <th class="px-10 py-6 text-left text-sm font-semibold text-slate-500">NGÀY</th>
                        <th class="px-10 py-6 text-left text-sm font-semibold text-slate-500">GIỜ</th>
                        <th class="px-10 py-6 text-right text-sm font-semibold text-slate-500">SỐ TIỀN</th>
                        <th class="px-10 py-6 text-center text-sm font-semibold text-slate-500">TRẠNG THÁI</th>
                        <th class="px-10 py-6 text-center text-sm font-semibold text-slate-500">HÀNH ĐỘNG</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-100 dark:divide-slate-700">
                <%
                    List<Map<String, Object>> history = (List<Map<String, Object>>) request.getAttribute("history");
                    if (history != null && !history.isEmpty()) {
                        for (Map<String, Object> b : history) {
                            String status = b.get("booking_status").toString();
                            String statusText = "";
                            String statusClass = "";
                            switch(status) {
                                case "PENDING_PAYMENT":
                                    statusText = "⏳ Chờ thanh toán";
                                    statusClass = "bg-amber-100 text-amber-700 dark:bg-amber-900/30 dark:text-amber-400";
                                    break;
                                case "WAITING_CONFIRM":
                                    statusText = "🔍 Chờ xác nhận";
                                    statusClass = "bg-blue-100 text-blue-700 dark:bg-blue-900/30 dark:text-blue-400";
                                    break;
                                case "CONFIRMED":
                                    statusText = "✅ Đã xác nhận";
                                    statusClass = "bg-emerald-100 text-emerald-700 dark:bg-emerald-900/30 dark:text-emerald-400";
                                    break;
                                case "EXPIRED":
                                    statusText = "❌ Hết hạn";
                                    statusClass = "bg-red-100 text-red-700 dark:bg-red-900/30 dark:text-red-400";
                                    break;
                                default:
                                    statusText = status;
                                    statusClass = "bg-gray-100 text-gray-700";
                            }
                %>
                    <tr class="hover:bg-slate-50 dark:hover:bg-slate-800 transition-colors">
                        <td class="px-10 py-7 font-mono font-medium text-primary">#<%= b.get("booking_id") %></td>
                        <td class="px-10 py-7 font-semibold"><%= b.get("field_name") %></td>
                        <td class="px-10 py-7"><%= b.get("booking_date") %></td>
                        <td class="px-10 py-7"><%= b.get("start_time") %> - <%= b.get("end_time") %></td>
                        <td class="px-10 py-7 text-right font-bold text-emerald-600">
                            <fmt:formatNumber value="<%= b.get(\"total_price\") %>" type="number" maxFractionDigits="0"/> ₫
                        </td>
                        <td class="px-10 py-7 text-center">
                            <span class="status-badge <%= statusClass %>"><%= statusText %></span>
                        </td>
                        <td class="px-10 py-7 text-center">
                            <a href="payment.jsp?bookingId=<%= b.get("booking_id") %>" 
                               class="inline-flex items-center gap-2 px-7 py-3 bg-primary text-white rounded-3xl text-sm font-semibold hover:bg-primary-dark transition">
                                <span class="material-symbols-outlined">visibility</span>
                                Chi tiết
                            </a>
                        </td>
                    </tr>
                <%
                        }
                    } else {
                %>
                    <tr>
                        <td colspan="7" class="px-10 py-24 text-center">
                            <span class="material-symbols-outlined text-8xl text-slate-200 dark:text-slate-700 mb-6 block">event_busy</span>
                            <p class="text-2xl font-semibold text-slate-400">Chưa có lịch sử đặt sân nào</p>
                        </td>
                    </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Footer -->
<footer class="bg-slate-900 text-slate-400 py-10 mt-auto">
    <div class="max-w-7xl mx-auto px-6 text-center text-sm">
        © 2026 SportMate - Đặt sân thể thao. All rights reserved.
    </div>
</footer>

</body>
</html>
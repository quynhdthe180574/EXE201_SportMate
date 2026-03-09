<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="dao.FieldDao" %>
<%@ page import="dao.FieldImageDAO" %>
<%@ page import="model.FieldImage" %>
<%@ page import="dao.ReviewDAO" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.util.*" %>

<%
    // Kiểm tra login
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

    // Lấy fieldId
    int fieldId = 0;
    String fieldIdParam = request.getParameter("fieldId");
    if (fieldIdParam == null || fieldIdParam.isEmpty()) {
        response.sendRedirect("fieldList.jsp");
        return;
    }
    try {
        fieldId = Integer.parseInt(fieldIdParam);
    } catch (NumberFormatException e) {
        response.sendRedirect("fieldList.jsp");
        return;
    }

    // Lấy ngày đặt (mặc định hôm nay)
    String dateParam = request.getParameter("bookingDate");
    Date bookingDate = new Date(System.currentTimeMillis());
    if (dateParam != null && !dateParam.isEmpty()) {
        try {
            bookingDate = Date.valueOf(dateParam);
        } catch (IllegalArgumentException e) {
            // giữ nguyên ngày hôm nay
        }
    }

    FieldDao fieldDao = new FieldDao();
    Map<String, Object> field = fieldDao.getFieldDetail(fieldId);
    if (field == null) {
        response.sendRedirect("fieldList.jsp");
        return;
    }

    List<Map<String, Object>> prices = fieldDao.getFieldPrices(fieldId);
    List<Map<String, Object>> availableSlots = fieldDao.getAvailableSlots(fieldId, bookingDate);

    pageContext.setAttribute("field", field);
    pageContext.setAttribute("prices", prices);
    pageContext.setAttribute("availableSlots", availableSlots);
    pageContext.setAttribute("bookingDate", bookingDate.toString());

    // Xử lý ảnh sân
    FieldImageDAO fieldImageDAO = new FieldImageDAO();
    List<FieldImage> images = fieldImageDAO.getImagesByField(fieldId);

    String courtImage = "https://via.placeholder.com/800x450?text=Không+có+hình+ảnh";
    if (images != null && !images.isEmpty()) {
        courtImage = images.get(0).getImageUrl();
    } else {
        // Fallback images (cố định ảnh đầu tiên hoặc random nếu muốn)
        String[] fallbackImages = {
            "https://images.unsplash.com/photo-1544911845-1f34a3eb46b7?w=800",
            "https://images.unsplash.com/photo-1552664730-d307ca884978?w=800",
            "https://images.unsplash.com/photo-1624880357913-7f9a0a56f94f?w=800"
        };
        courtImage = fallbackImages[0];  // hoặc random: fallbackImages[new Random().nextInt(fallbackImages.length)]
    }
    pageContext.setAttribute("courtImage", courtImage);
    // Khởi tạo ReviewDAO
    dao.ReviewDAO reviewDAO = new dao.ReviewDAO();

    // Lấy danh sách review
    List<model.Review> reviews = reviewDAO.getReviewsByFieldId(fieldId);

    // Lấy trung bình rating và số lượng (để hiển thị header đẹp hơn)
    double avgRating = reviewDAO.getAverageRatingByField(fieldId);
    int reviewCount = reviewDAO.getReviewCountByField(fieldId);

    // Đưa vào pageContext để dùng JSTL
    pageContext.setAttribute("reviews", reviews);
    pageContext.setAttribute("avgRating", avgRating);
    pageContext.setAttribute("reviewCount", reviewCount);
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${field.fieldName} - Chi tiết Sân</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght@100..700,0..1&display=swap" rel="stylesheet">
    <script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        "primary": "#13ec6d",
                        "background-light": "#f6f8f7",
                        "background-dark": "#102218",
                    },
                },
            },
        }
    </script>
    <style>
        body { font-family: 'Inter', sans-serif; }
        .no-scrollbar::-webkit-scrollbar { display: none; }
        .no-scrollbar { -ms-overflow-style: none; scrollbar-width: none; }
    </style>
</head>
<body class="bg-background-light dark:bg-background-dark font-display text-slate-900 dark:text-slate-100">

<!-- Header -->
<header class="sticky top-0 z-50 w-full bg-white/80 dark:bg-background-dark/80 backdrop-blur-md border-b border-primary/10">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center h-20">
            <div class="flex items-center gap-2">
                <span class="text-2xl font-extrabold tracking-tight text-slate-900 dark:text-white uppercase">Sport<span class="text-primary">Mate</span></span>
            </div>
            <nav class="hidden md:flex space-x-10">
                <a class="nav-link text-sm font-semibold hover:text-primary transition-colors" href="home.jsp">Trang chủ</a>
                <a class="nav-link text-sm font-semibold hover:text-primary transition-colors" href="fieldList.jsp">Danh sách sân</a>
                <a class="nav-link text-sm font-semibold hover:text-primary transition-colors" href="#">Về chúng tôi</a>
                <a class="nav-link text-sm font-semibold hover:text-primary transition-colors" href="#">Liên hệ</a>
            </nav>
            <div class="flex items-center gap-4">
                <c:choose>
                    <c:when test="${isLoggedIn}">
                        <div class="relative group">
                            <button class="flex items-center gap-2 px-3 py-2 rounded-full bg-primary/10 hover:bg-primary/20 transition-colors">
                                <div class="size-7 rounded-full bg-primary flex items-center justify-center text-slate-900 font-bold text-xs">
                                    ${userFirstChar}
                                </div>
                                <span class="hidden sm:block text-xs font-bold text-slate-900 dark:text-slate-100">${userName}</span>
                            </button>
                            <div class="absolute right-0 mt-2 w-48 bg-white dark:bg-slate-800 rounded-lg border border-primary/10 shadow-xl opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-200">
                                <div class="px-4 py-3 border-b border-primary/10">
                                    <p class="text-xs font-bold text-slate-900 dark:text-slate-100">${userName}</p>
                                    <p class="text-xs text-slate-500">Tài khoản của tôi</p>
                                </div>
                                <div class="py-2">
                                    <a href="bookingHistory.jsp" class="flex items-center gap-2 px-4 py-2 text-xs font-semibold text-slate-600 dark:text-slate-400 hover:text-primary hover:bg-primary/5 dark:hover:bg-primary/10 transition-colors">
                                        Lịch sử đặt sân
                                    </a>
                                    <a href="profile.jsp" class="flex items-center gap-2 px-4 py-2 text-xs font-semibold text-slate-600 dark:text-slate-400 hover:text-primary hover:bg-primary/5 dark:hover:bg-primary/10 transition-colors">
                                        Hồ sơ cá nhân
                                    </a>
                                </div>
                                <div class="border-t border-primary/10"></div>
                                <div class="py-2">
                                    <a href="${pageContext.request.contextPath}/logout.jsp" class="flex items-center gap-2 px-4 py-2 text-xs font-semibold text-red-600 dark:text-red-400 hover:text-red-700 dark:text-red-300 hover:bg-red-50 dark:hover:bg-red-900/20 transition-colors">
                                        Đăng xuất
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <button onclick="window.location.href='login.jsp'" class="px-6 py-2.5 text-sm font-bold text-slate-700 dark:text-slate-200 hover:text-primary transition-colors">
                            Đăng nhập
                        </button>
                        <button onclick="window.location.href='signup.jsp'" class="px-6 py-2.5 bg-primary text-background-dark rounded-full text-sm font-bold hover:opacity-90 transition-all shadow-lg shadow-primary/20">
                            Đăng ký
                        </button>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</header>

<main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    <!-- Breadcrumb -->
    <div class="flex items-center gap-2 text-sm text-slate-500 mb-8">
        <a href="home.jsp" class="hover:text-primary transition-colors">Trang chủ</a>
        <span class="text-slate-400">/</span>
        <a href="fieldList.jsp" class="hover:text-primary transition-colors">Danh sách sân</a>
        <span class="text-slate-400">/</span>
        <span class="text-slate-900 dark:text-slate-100 font-bold">${field.fieldName}</span>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <!-- Main Content -->
        <div class="lg:col-span-2 space-y-8">
            <!-- Field Hero Image -->
            <div class="rounded-2xl overflow-hidden bg-gradient-to-br from-primary/20 to-primary/5 border border-slate-200 dark:border-slate-700 shadow-lg">
                <div class="aspect-video bg-slate-200 dark:bg-slate-800 flex items-center justify-center">
                    <img class="w-full h-full object-cover transition-transform duration-500 hover:scale-110"
                         src="${courtImage}"
                         alt="${field.fieldName}"
                         onerror="this.src='https://via.placeholder.com/800x450?text=Load+Error'" />
                </div>
            </div>

            <!-- Field Info Card -->
            <div class="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 p-6 sm:p-8 space-y-6 shadow-lg">
                <div>
                    <h1 class="text-3xl sm:text-4xl font-black mb-4">${field.fieldName}</h1>
                    <div class="flex flex-wrap items-center gap-3 sm:gap-4 text-sm">
                        <div class="flex items-center gap-2 text-slate-600 dark:text-slate-400">
                            <span>${field.venueName}</span>
                        </div>
                        <div class="flex items-center gap-2 text-slate-600 dark:text-slate-400">
                            <span>${field.districtName}, ${field.provinceName}</span>
                        </div>
                        <c:if test="${field.avgRating != null}">
                            <div class="flex items-center gap-2 bg-amber-100 dark:bg-amber-900/30 text-amber-600 dark:text-amber-400 px-3 py-1 rounded-full">
                                <span class="material-symbols-outlined text-lg fill-1">star</span>
                                <span class="font-bold"><fmt:formatNumber value="${field.avgRating}" pattern="#.##"/></span>
                                <span class="text-xs">(${field.reviewCount != null ? field.reviewCount : 0} đánh giá)</span>
                            </div>
                        </c:if>
                    </div>
                </div>

                <!-- Info Grid -->
                <div class="grid grid-cols-2 sm:grid-cols-3 gap-4 py-6 border-y border-slate-200 dark:border-slate-700">
                    <div class="flex items-center gap-3">
                        <div class="size-10 rounded-full bg-primary/10 flex items-center justify-center text-primary flex-shrink-0">
                            
                        </div>
                        <div>
                            <p class="text-xs text-slate-500 dark:text-slate-400">Giờ mở cửa</p>
                            <p class="font-bold text-sm">05:00 - 23:00</p>
                        </div>
                    </div>
                    <div class="flex items-center gap-3">
                        <div class="size-10 rounded-full bg-primary/10 flex items-center justify-center text-primary flex-shrink-0">
                            
                        </div>
                        <div>
                            <p class="text-xs text-slate-500 dark:text-slate-400">Môn thể thao</p>
                            <p class="font-bold text-sm">${field.sportName}</p>
                        </div>
                    </div>
                    <div class="flex items-center gap-3">
                        <div class="size-10 rounded-full bg-primary/10 flex items-center justify-center text-primary flex-shrink-0">
                            
                        </div>
                        <div>
                            <p class="text-xs text-slate-500 dark:text-slate-400">Giá từ</p>
                            <p class="font-bold text-sm text-primary">
                                <c:choose>
                                    <c:when test="${not empty prices}">
                                        <fmt:formatNumber value="${prices[0].price}" type="number" maxFractionDigits="0"/>₫
                                    </c:when>
                                    <c:otherwise>
                                        Chưa cập nhật
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Description -->
                <div>
                    <h3 class="font-bold text-lg mb-3">Mô tả chi tiết</h3>
                    <p class="text-slate-600 dark:text-slate-400 leading-relaxed text-justify">
                        ${field.description != null ? field.description : 'Chưa có mô tả chi tiết.'}
                    </p>
                </div>

                <!-- Amenities (có thể lấy từ DB sau này) -->
                <div class="grid grid-cols-2 gap-3">
                    <div class="flex items-center gap-2 p-3 bg-slate-50 dark:bg-slate-800 rounded-lg hover:bg-primary/5 dark:hover:bg-primary/10 transition-colors">
                        
                        <span class="text-sm font-medium">Wifi miễn phí</span>
                    </div>
                    <div class="flex items-center gap-2 p-3 bg-slate-50 dark:bg-slate-800 rounded-lg hover:bg-primary/5 dark:hover:bg-primary/10 transition-colors">
                        
                        <span class="text-sm font-medium">Bãi đỗ xe</span>
                    </div>
                    <div class="flex items-center gap-2 p-3 bg-slate-50 dark:bg-slate-800 rounded-lg hover:bg-primary/5 dark:hover:bg-primary/10 transition-colors">
                      
                        <span class="text-sm font-medium">Canteen</span>
                    </div>
                    <div class="flex items-center gap-2 p-3 bg-slate-50 dark:bg-slate-800 rounded-lg hover:bg-primary/5 dark:hover:bg-primary/10 transition-colors">
                      
                        <span class="text-sm font-medium">Phòng thay đồ</span>
                    </div>
                </div>
            </div>
        </div>
    
        <!-- Sidebar - Booking -->
        <div class="lg:col-span-1">
            <div class="sticky top-24 space-y-6">
                <!-- Booking Card -->
                <div class="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 p-6 sm:p-8 shadow-lg">
                    <h2 class="text-2xl font-bold mb-6 text-center">Đặt sân nhanh</h2>

                    <!-- Date Selection -->
                    <form method="get" action="fieldDetail.jsp" class="mb-6">
                        <input type="hidden" name="fieldId" value="${field.fieldId}">
                        <div class="mb-4">
                            <label class="block text-sm font-bold mb-2">📅 Ngày đặt</label>
                            <input type="date" name="bookingDate"
                                   value="${bookingDate}"
                                   min="<%= new java.sql.Date(System.currentTimeMillis()).toString() %>"
                                   class="w-full px-4 py-2 border border-slate-300 dark:border-slate-600 rounded-lg bg-white dark:bg-slate-800 focus:ring-2 focus:ring-primary focus:border-primary outline-none transition"
                                   required>
                        </div>
                        <button type="submit" class="w-full bg-slate-200 dark:bg-slate-700 hover:bg-slate-300 dark:hover:bg-slate-600 text-slate-900 dark:text-slate-100 font-bold py-2 rounded-lg transition-colors flex items-center justify-center gap-2">
                            <span class="material-symbols-outlined text-sm">search</span>
                            <span>Tìm kiếm</span>
                        </button>
                    </form>

                    <div class="border-t border-slate-200 dark:border-slate-700 pt-6">
                        <h3 class="font-bold mb-4">⏰ Khung giờ trống</h3>
                        <p class="text-xs text-slate-500 dark:text-slate-400 mb-4">Ngày: <strong class="text-primary">${bookingDate}</strong></p>

                        <c:choose>
                            <c:when test="${not empty availableSlots}">
                                <form action="BookingServlet" method="post" class="space-y-3">
                                    <input type="hidden" name="fieldId" value="${field.fieldId}">
                                    <input type="hidden" name="bookingDate" value="${bookingDate}">
                                    <c:forEach items="${availableSlots}" var="slot">
                                        <c:choose>
                                            <c:when test="${slot.status == 'BOOKED'}">
                                                <div class="flex items-center p-4 border-2 border-red-300 dark:border-red-700 rounded-xl bg-red-50 dark:bg-red-900/20 opacity-70 cursor-not-allowed">
                                                    <div class="w-6 h-6 rounded-full bg-red-500 flex items-center justify-center flex-shrink-0">
                                                        <span class="material-symbols-outlined text-sm text-white">close</span>
                                                    </div>
                                                    <div class="ml-4 flex-1">
                                                        <p class="font-bold text-sm text-red-700 dark:text-red-300">
                                                            <fmt:formatDate value="${slot.startTime}" pattern="HH:mm"/> -
                                                            <fmt:formatDate value="${slot.endTime}" pattern="HH:mm"/>
                                                        </p>
                                                        <p class="text-xs text-red-600 dark:text-red-400 font-semibold">Đã được đặt</p>
                                                    </div>
                                                    <p class="font-bold text-red-500 dark:text-red-400 text-sm line-through">
                                                        <fmt:formatNumber value="${slot.price}" type="number" maxFractionDigits="0"/>₫
                                                    </p>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <label class="group relative flex items-center gap-4 p-4 border-2 border-green-300 dark:border-green-700 rounded-xl cursor-pointer transition-all hover:border-primary hover:bg-primary/5 dark:hover:bg-primary/10 has-[:checked]:border-primary has-[:checked]:bg-primary/10 has-[:checked]:shadow-lg has-[:checked]:shadow-primary/20">
                                                    <input type="radio" name="slotId" value="${slot.slotId}"
                                                           class="w-5 h-5 text-primary border-slate-300 focus:ring-primary cursor-pointer" required />
                                                    <div class="w-10 h-10 rounded-lg bg-green-100 dark:bg-green-900/30 flex items-center justify-center flex-shrink-0">
                                                       
                                                    </div>
                                                    <div class="flex-1">
                                                        <p class="font-bold text-sm text-slate-900 dark:text-slate-100">
                                                            <fmt:formatDate value="${slot.startTime}" pattern="HH:mm"/> -
                                                            <fmt:formatDate value="${slot.endTime}" pattern="HH:mm"/>
                                                        </p>
                                                        <p class="text-xs text-green-600 dark:text-green-400 font-semibold">✓ Còn trống</p>
                                                    </div>
                                                    <p class="font-bold text-primary text-sm">
                                                        <fmt:formatNumber value="${slot.price}" type="number" maxFractionDigits="0"/>₫
                                                    </p>
                                                </label>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                    <button type="submit" class="w-full bg-primary hover:opacity-90 text-slate-900 font-bold py-3 rounded-lg mt-6 flex items-center justify-center gap-2 transition-all shadow-lg shadow-primary/20 hover:shadow-primary/30">
                                       
                                        <span>Đặt sân ngay</span>
                                    </button>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <div class="bg-yellow-50 dark:bg-yellow-900/20 border-l-4 border-yellow-400 p-4 rounded-r-lg">
                                    <p class="font-bold text-yellow-800 dark:text-yellow-200 text-sm">Không có khung giờ trống</p>
                                    <p class="text-xs text-yellow-700 dark:text-yellow-300 mt-1">Vui lòng chọn ngày khác</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Policy Card -->
                <div class="bg-primary/5 dark:bg-primary/10 border border-primary/20 rounded-2xl p-6 shadow-lg">
                    <div class="flex items-start gap-3">
                        <span class="material-symbols-outlined text-primary flex-shrink-0 mt-1">info</span>
                        <div>
                            <h4 class="font-bold text-primary mb-3">Chính sách hoàn trả</h4>
                            <ul class="text-xs text-slate-600 dark:text-slate-400 space-y-2">
                                <li class="flex items-center gap-2">
                                    <span class="text-green-500 font-bold">✓</span>
                                    <span>Hoàn 100% nếu hủy trước 24h</span>
                                </li>
                                <li class="flex items-center gap-2">
                                    <span class="text-green-500 font-bold">✓</span>
                                    <span>Hoàn 50% nếu hủy trước 12h</span>
                                </li>
                                <li class="flex items-center gap-2">
                                    <span class="text-red-500 font-bold">✗</span>
                                    <span>Không hoàn nếu hủy sau 12h</span>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
                        
</main>

<!-- Footer -->
<footer class="bg-background-dark text-slate-400 py-16 border-t border-white/5">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="grid grid-cols-1 md:grid-cols-4 gap-12 mb-12">
            <div>
                <div class="flex items-center gap-2 mb-6">
                    <span class="text-xl font-extrabold tracking-tight text-white uppercase">Sport<span class="text-primary">Mate</span></span>
                </div>
                <p class="text-sm leading-relaxed">
                    Nền tảng đặt sân thể thao hàng đầu Việt Nam, giúp kết nối cộng đồng yêu thể thao với những địa điểm tập luyện chất lượng nhất.
                </p>
            </div>
            <!-- Các cột footer khác giữ nguyên như code cũ của bạn -->
            <!-- ... -->
        </div>
        <div class="pt-12 border-t border-white/5 text-center text-xs">
            <p>© 2025 SportMate. Tất cả quyền lợi được bảo lưu.</p>
        </div>
    </div>
</footer>

</body>
</html>
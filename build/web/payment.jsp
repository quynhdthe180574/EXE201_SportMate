<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="dao.BookingDao" %>
<%@ page import="java.util.Map" %>
<%
    String bookingIdParam = request.getParameter("bookingId");
    if (bookingIdParam == null) {
        response.sendRedirect("home.jsp");
        return;
    }
    int bookingId = Integer.parseInt(bookingIdParam);
    BookingDao dao = new BookingDao();
    Map<String, Object> booking = dao.getBookingById(bookingId);
    if (booking == null) {
        response.sendRedirect("home.jsp");
        return;
    }
    String fieldName = booking.get("field_name").toString();
    String bookingDate = booking.get("booking_date").toString();
    String startTime = booking.get("start_time").toString();
    String endTime = booking.get("end_time").toString();
    String status = booking.get("booking_status").toString();
    if(!status.equals("Chờ thanh toán") && !status.equals("pending")){
        response.sendRedirect("home.jsp");
        return;
}
String fullName = booking.get("fullname").toString();
String email = booking.get("email").toString();
String phone = booking.get("phone").toString();
int fieldId = (Integer) booking.get("field_id"); // Để quay về chi tiết sân

String bankCode = "";
String bankAccount = "";
String accountName = "";
String bankName = "";

switch(fieldId){
    case 1:
        bankCode = "970422";
        bankAccount = "0981478291";
        accountName = "DUONG XUAN MANH";
        bankName = "MB Bank";
        break;
    case 2:
        bankCode = "970422";
        bankAccount = "0981478291";
        accountName = "DUONG XUAN MANH";
        bankName = "MB Bank";
        break;

    case 3:
        bankCode = "970422";
        bankAccount = "0981478291";
        accountName = "DUONG XUAN MANH";
        bankName = "MB Bank";
        break;
    case 4:
        bankCode = "970422";
        bankAccount = "0981478291";
        accountName = "DUONG XUAN MANH";
        bankName = "MB Bank";
        break;

    case 5:
        bankCode = "970422";
        bankAccount = "22032004666888";
        accountName = "DUONG THI QUYNH";
        bankName = "MB Bank";
        break;
    case 6:
        bankCode = "970422";
        bankAccount = "0981478291";
        accountName = "DUONG XUAN MANH";
        bankName = "MB Bank";
        break;
    case 7:
        bankCode = "970422";
        bankAccount = "0981478291";
        accountName = "DUONG XUAN MANH";
        bankName = "MB Bank";
        break;
    case 8:
       bankCode = "970422";
        bankAccount = "0981478291";
        accountName = "DUONG XUAN MANH";
        bankName = "MB Bank";
        break;
}

double totalPrice = Double.parseDouble(booking.get("total_price").toString());
double depositPercentage = 0.3;
double depositAmount = totalPrice * depositPercentage;
String fullAmountNoDot = String.valueOf((long) totalPrice);
String depositAmountNoDot = String.valueOf((long) depositAmount);
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thanh toán - <%= fieldName %></title>
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet"/>
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght@400;700&display=swap" rel="stylesheet"/>
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
                        fontFamily: {display: ["Inter"]},
                        borderRadius: {DEFAULT: "1rem", lg: "1.5rem", xl: "2rem", full: "9999px"},
                        boxShadow: {
                            card: "0 10px 25px -5px rgba(19, 236, 109, 0.1)",
                        },
                    },
                },
            }
        </script>
        <style>
            body {
                font-family: 'Inter', sans-serif;
                background: linear-gradient(to bottom, #f8fafc, #e2e8f0);
            }
            .dark body {
                background: linear-gradient(to bottom, #0f172a, #1e293b);
            }
            .material-symbols-outlined {
                vertical-align: middle;
            }
            .option:hover {
                transform: translateY(-2px);
                transition: all 0.2s ease;
            }
            .qr-box img {
                transition: transform 0.3s ease;
            }
            .qr-box:hover img {
                transform: scale(1.03);
            }
        </style>
    </head>
    <body class="min-h-screen">
        <%-- header.jsp - Updated with Session Management --%>

        <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <%
            // Get user from session
            Object userObj = session.getAttribute("user");
            String userName = "";
            String userFirstChar = "U";
    
            if (userObj != null) {
                // User is logged in
                userName = userObj.toString(); // Or use ((User)userObj).getFullname()
                if (!userName.isEmpty()) {
                    userFirstChar = String.valueOf(userName.charAt(0)).toUpperCase();
                }
            }
    
            pageContext.setAttribute("isLoggedIn", userObj != null);
            pageContext.setAttribute("userName", userName);
            pageContext.setAttribute("userFirstChar", userFirstChar);
        %>

        <header class="sticky top-0 z-50 w-full bg-white/80 dark:bg-background-dark/80 backdrop-blur-md border-b border-primary/10">

            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between items-center h-20">
                    <div class="flex items-center gap-2">
                        <div class="bg-primary p-2 rounded-lg">

                        </div>
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
                                <!-- User Logged In - Avatar with Dropdown -->
                                <div class="relative group">
                                    <!-- Avatar Button -->
                                    <button class="flex items-center gap-2 px-3 py-2 rounded-full bg-primary/10 hover:bg-primary/20 transition-colors">
                                        <div class="size-7 rounded-full bg-primary flex items-center justify-center text-slate-900 font-bold text-xs">
                                            ${userFirstChar}
                                        </div>
                                        <span class="hidden sm:block text-xs font-bold text-slate-900 dark:text-slate-100">${userName}</span>
                                        <span class="material-symbols-outlined text-base">expand_more</span>
                                    </button>

                                    <!-- Dropdown Menu -->
                                    <div class="absolute right-0 mt-2 w-48 bg-white dark:bg-slate-800 rounded-lg border border-primary/10 shadow-xl opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-200">
                                        <!-- User Info -->
                                        <div class="px-4 py-3 border-b border-primary/10">
                                            <p class="text-xs font-bold text-slate-900 dark:text-slate-100">${userName}</p>
                                            <p class="text-xs text-slate-500">Tài khoản của tôi</p>
                                        </div>

                                        <!-- Menu Items -->
                                        <div class="py-2">
                                            <a href="bookingHistory.jsp" class="flex items-center gap-2 px-4 py-2 text-xs font-semibold text-slate-600 dark:text-slate-400 hover:text-primary hover:bg-primary/5 dark:hover:bg-primary/10 transition-colors">

                                                <span>Lịch sử đặt sân</span>
                                            </a>
                                            <a href="profile.jsp" class="flex items-center gap-2 px-4 py-2 text-xs font-semibold text-slate-600 dark:text-slate-400 hover:text-primary hover:bg-primary/5 dark:hover:bg-primary/10 transition-colors">

                                                <span>Hồ sơ cá nhân</span>
                                            </a>

                                        </div>

                                        <!-- Divider -->
                                        <div class="border-t border-primary/10"></div>

                                        <!-- Logout -->
                                        <div class="py-2">
                                            <a href="logout.jsp" class="flex items-center gap-2 px-4 py-2 text-xs font-semibold text-red-600 dark:text-red-400 hover:text-red-700 dark:text-red-300 hover:bg-red-50 dark:hover:bg-red-900/20 transition-colors">

                                                <span>Đăng xuất</span>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <!-- User Not Logged In - Login & Signup Buttons -->
                                <button
                                    onclick="window.location.href = 'login.jsp'"
                                    class="px-6 py-2.5 text-sm font-bold text-slate-700 dark:text-slate-200 hover:text-primary transition-colors">
                                    Đăng nhập
                                </button>
                                <button onclick="window.location.href = 'signup.jsp'" class="px-6 py-2.5 bg-primary text-background-dark rounded-full text-sm font-bold hover:opacity-90 transition-all shadow-lg shadow-primary/20">Đăng ký</button>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </header>


        <main class="max-w-7xl mx-auto px-6 py-10">
            <nav class="flex items-center gap-2 text-sm text-slate-500 mb-8">
                <a href="home.jsp" class="hover:text-primary transition">Trang chủ</a>
                <span class="material-symbols-outlined text-sm">chevron_right</span>
                <a href="fieldDetail.jsp?fieldId=<%= fieldId %>" class="hover:text-primary transition">Chi tiết sân</a>
                <span class="material-symbols-outlined text-sm">chevron_right</span>
                <span class="text-primary font-medium">Thanh toán</span>
            </nav>

            <div class="grid grid-cols-1 lg:grid-cols-12 gap-8">
                <!-- LEFT -->
                <div class="lg:col-span-7 space-y-6">
                    <div class="text-center lg:text-left">
                        <h2 class="text-4xl font-extrabold mb-3 bg-gradient-to-r from-primary to-green-500 bg-clip-text text-transparent inline-block">
                            Thanh toán đặt sân
                        </h2>
                        <p class="text-slate-600 dark:text-slate-400">Hoàn tất nhanh chóng chỉ trong vài bước</p>
                    </div>

                    <!-- Payment Options -->
                    <div class="bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-2xl p-6 shadow-card">
                        <h3 class="text-xl font-bold mb-5 flex items-center gap-3">
                            <span class="material-symbols-outlined text-3xl text-primary">account_balance_wallet</span>
                            Chọn phương thức
                        </h3>
                        <div class="grid gap-4">
                            <label class="option flex items-center gap-5 p-5 border-2 border-slate-200 dark:border-slate-700 rounded-xl cursor-pointer transition hover:border-primary hover:shadow-md group">
                                <input checked name="paymentOption" value="full" type="radio" class="w-6 h-6 text-primary"/>
                                <div class="flex-1">
                                    <p class="font-bold text-lg">Thanh toán toàn bộ ngay</p>
                                    <p class="text-slate-600 dark:text-slate-400 mt-1">
                                        <span class="font-semibold text-primary"><fmt:formatNumber value="<%= totalPrice %>" type="number" maxFractionDigits="0"/>₫</span>
                                    </p>
                                </div>
                                <span class="material-symbols-outlined text-3xl text-primary opacity-0 group-has-[:checked]:opacity-100 transition-opacity">check_circle</span>
                            </label>

                            <label class="option flex items-center gap-5 p-5 border-2 border-slate-200 dark:border-slate-700 rounded-xl cursor-pointer transition hover:border-primary hover:shadow-md group">
                                <input name="paymentOption" value="deposit" type="radio" class="w-6 h-6 text-primary"/>
                                <div class="flex-1">
                                    <p class="font-bold text-lg">Cọc trước 30%</p>
                                    <p class="text-slate-600 dark:text-slate-400 mt-1">
                                        <span class="font-semibold text-primary"><fmt:formatNumber value="<%= depositAmount %>" type="number" maxFractionDigits="0"/>₫</span>
                                        <span class="text-xs"> (còn lại thanh toán sau)</span>
                                    </p>
                                </div>
                                <span class="material-symbols-outlined text-3xl text-primary opacity-0 group-has-[:checked]:opacity-100 transition-opacity">check_circle</span>
                            </label>
                        </div>
                    </div>

                    <!-- Booking Info -->
                    <div class="bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-2xl p-6 shadow-card">
                        <h3 class="text-xl font-bold mb-5 flex items-center gap-3">
                            <span class="material-symbols-outlined text-3xl text-primary">receipt_long</span>
                            Thông tin đơn hàng
                        </h3>
                        <div class="space-y-4 text-sm">
                            <div class="flex justify-between py-2 border-b border-slate-100 dark:border-slate-700">
                                <span class="text-slate-600">Mã đặt sân</span>
                                <span class="font-bold text-primary">#<%= bookingId %></span>
                            </div>
                            <div class="flex justify-between py-2 border-b border-slate-100 dark:border-slate-700">
                                <span class="text-slate-600">Người đặt</span>
                                <span class="font-semibold"><%= fullName %></span>
                            </div>
                            <div class="flex justify-between py-2 border-b border-slate-100 dark:border-slate-700">
                                <span class="text-slate-600">Sân</span>
                                <span class="font-semibold"><%= fieldName %></span>
                            </div>
                            <div class="flex justify-between py-2 border-b border-slate-100 dark:border-slate-700">
                                <span class="text-slate-600">Ngày giờ</span>
                                <span class="font-semibold"><%= bookingDate %> • <%= startTime %> - <%= endTime %></span>
                            </div>
                            <div class="flex justify-between pt-3">
                                <span class="text-slate-600 font-medium">Tổng tiền</span>
                                <span id="totalPrice" class="text-2xl font-bold text-primary"><fmt:formatNumber value="<%= totalPrice %>" type="number" maxFractionDigits="0"/>đ</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- RIGHT: QR -->
                <div class="lg:col-span-5">
                    <div class="bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-2xl p-6 shadow-card sticky top-6">
                        <h3 class="text-xl font-bold mb-5 flex items-center gap-3">
                            <span class="material-symbols-outlined text-3xl text-primary">qr_code</span>
                            Quét mã QR để thanh toán
                        </h3>
                        <div class="text-center">
                            <div class="inline-block p-4 bg-white dark:bg-slate-900 rounded-2xl shadow-inner border border-slate-200 dark:border-slate-700">
                                <img id="qrImage"
                                     src="https://api.vietqr.io/image/<%= bankCode %>-<%= bankAccount %>-compact.jpg?accountName=<%= java.net.URLEncoder.encode(accountName, "UTF-8") %>&amount=<%= fullAmountNoDot %>&addInfo=BOOKING<%= bookingId %>"
                                     alt="QR Thanh toán" class="w-64 h-64 mx-auto rounded-xl">
                            </div>
                            <p class="mt-5 text-sm text-slate-600">
                                <strong>Ngân hàng:</strong> <%= bankName %> • <%= bankAccount %><br>
                                <strong>Nội dung CK:</strong> <span id="qrContent" class="font-mono bg-slate-100 dark:bg-slate-800 px-2 py-1 rounded">BOOKING<%= bookingId %></span>
                            </p>
                            <p id="paymentStatus" style="color:green; font-weight:bold;"></p>
                            <p id="depositNote" class="mt-3 text-sm text-amber-600 font-medium hidden">
                                (Cọc 30% - còn lại thanh toán sau khi sử dụng sân)
                            </p>
                            <p class="mt-6 text-sm text-red-500 font-bold">
                                ⏳ Thời gian còn lại: <span id="countdown">10:00</span>
                            </p>
                        </div>

                        <!-- Action Buttons -->
                        <div class="mt-8 flex flex-col gap-4">

                            <a href="#" id="btnCancelBooking"
                               onclick="cancelAndRedirect(); return false;"
                               class="w-full py-4 bg-red-100 dark:bg-red-900/30 text-red-700 dark:text-red-300 font-bold text-lg rounded-xl hover:bg-red-200 dark:hover:bg-red-900/50 transition flex items-center justify-center gap-3">
                                <span class="material-symbols-outlined">cancel</span>
                                HỦY THANH TOÁN
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <!-- footer.jsp -->

        <footer class="bg-background-dark text-slate-400 py-16 border-t border-white/5">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="grid grid-cols-1 md:grid-cols-4 gap-12 mb-12">
                    <div>
                        <div class="flex items-center gap-2 mb-6">
                            <div class="bg-primary p-2 rounded-lg">

                            </div>
                            <span class="text-xl font-extrabold tracking-tight text-white uppercase">Sport<span class="text-primary">Mate</span></span>
                        </div>
                        <p class="text-sm leading-relaxed">
                            Nền tảng đặt sân thể thao hàng đầu Việt Nam, giúp kết nối cộng đồng yêu thể thao với những địa điểm tập luyện chất lượng nhất.
                        </p>
                    </div>
                    <div>
                        <h5 class="text-white font-bold mb-6">Về chúng tôi</h5>
                        <ul class="space-y-4 text-sm">
                            <li><a class="hover:text-primary transition-colors" href="#">Giới thiệu</a></li>
                            <li><a class="hover:text-primary transition-colors" href="fieldList.jsp">Danh sách sân</a></li>
                            <li><a class="hover:text-primary transition-colors" href="#">Tin tức thể thao</a></li>
                            <li><a class="hover:text-primary transition-colors" href="#">Tuyển dụng</a></li>
                        </ul>
                    </div>
                    <div>
                        <h5 class="text-white font-bold mb-6">Chính sách</h5>
                        <ul class="space-y-4 text-sm">
                            <li><a class="hover:text-primary transition-colors" href="#">Điều khoản sử dụng</a></li>
                            <li><a class="hover:text-primary transition-colors" href="#">Chính sách bảo mật</a></li>
                            <li><a class="hover:text-primary transition-colors" href="#">Quy định hoàn trả</a></li>
                            <li><a class="hover:text-primary transition-colors" href="#">Giải quyết khiếu nại</a></li>
                        </ul>
                    </div>
                    <div>
                        <h5 class="text-white font-bold mb-6">Liên hệ & Hỗ trợ</h5>
                        <div class="flex items-center gap-3 mb-4">
                            <span class="material-symbols-outlined text-primary">phone_in_talk</span>
                            <span class="text-white font-bold">1900 123 456</span>
                        </div>
                        <div class="flex items-center gap-3 mb-6">
                            <span class="material-symbols-outlined text-primary">mail</span>
                            <span>support@sportcourt.vn</span>
                        </div>
                        <div class="flex gap-4">
                            <a class="w-10 h-10 rounded-full bg-white/5 flex items-center justify-center hover:bg-primary hover:text-background-dark transition-all" href="#">
                                <span class="material-symbols-outlined text-xl">social_leaderboard</span>
                            </a>
                            <a class="w-10 h-10 rounded-full bg-white/5 flex items-center justify-center hover:bg-primary hover:text-background-dark transition-all" href="#">
                                <span class="material-symbols-outlined text-xl">share</span>
                            </a>
                        </div>
                    </div>
                </div>
                <div class="pt-12 border-t border-white/5 text-center text-xs">
                    <p>© 2024 SportCourt. Tất cả quyền lợi được bảo lưu. Thiết kế với đam mê thể thao.</p>
                </div>
            </div>
        </footer>

        <script>
            let paymentTime = 10 * 60;
            let checkInterval;
            let paymentCompleted = false; // Flag: đã thanh toán thành công chưa

            const bookingId = <%= bookingId %>;
            const fullAmount = <%= fullAmountNoDot %>;
            const depositAmount = <%= depositAmountNoDot %>;
            const bookingContent = "BOOKING<%= bookingId %>";
            const cancelUrl = "<%= request.getContextPath() %>/CancelBookingServlet?bookingId=<%= bookingId %>";

                // ==============================
                // Lấy loại thanh toán hiện tại
                // ==============================
                function getPaymentType() {
                    const selected = document.querySelector('input[name="paymentOption"]:checked');
                    return selected ? selected.value : 'full';
                }

                function getCurrentAmount() {
                    return getPaymentType() === 'deposit' ? depositAmount : fullAmount;
                }

                // ==============================
                // Cập nhật QR khi đổi option
                // ==============================
                document.querySelectorAll('input[name="paymentOption"]').forEach(function (radio) {
                    radio.addEventListener('change', function () {
                        const amount = getCurrentAmount();
                        const qrImg = document.getElementById('qrImage');
                        const depositNote = document.getElementById('depositNote');
                        const totalPriceEl = document.getElementById('totalPrice');

                        // Cập nhật QR
                        qrImg.src = "https://api.vietqr.io/image/<%= bankCode %>-<%= bankAccount %>-compact.jpg?accountName=<%= java.net.URLEncoder.encode(accountName, "UTF-8") %>&amount=" + amount + "&addInfo=BOOKING<%= bookingId %>";
                        // Cập nhật hiển thị giá
                        totalPriceEl.textContent = new Intl.NumberFormat('vi-VN').format(amount) + 'đ';

                        // Hiện/ẩn ghi chú cọc
                        if (getPaymentType() === 'deposit') {
                            depositNote.classList.remove('hidden');
                        } else {
                            depositNote.classList.add('hidden');
                        }
                    });
                });

                // ==============================
                // HỦY BOOKING - Nút bấm
                // ==============================
                function cancelAndRedirect() {
                    if (!confirm('Bạn có chắc muốn hủy thanh toán? Slot sẽ được trả lại.'))
                        return;
                    paymentCompleted = true; // Ngăn beforeunload gọi thêm lần nữa
                    window.location.href = cancelUrl;
                }

                // ==============================
                // TỰ ĐỘNG HỦY KHI RỜI TRANG
                // Bao gồm: đóng tab, refresh, back, chuyển trang
                // ==============================
                window.addEventListener('beforeunload', function (e) {
                    if (paymentCompleted)
                        return; // Đã thanh toán => không hủy
                    // Dùng sendBeacon để gửi request hủy ngay cả khi tab đóng
                    navigator.sendBeacon(cancelUrl);
                });

                // Backup: visibilitychange cho mobile browsers
                document.addEventListener('visibilitychange', function () {
                    if (document.visibilityState === 'hidden' && !paymentCompleted) {
                        navigator.sendBeacon(cancelUrl);
                    }
                });

                // ==============================
                // ĐẾM NGƯỢC thời gian thanh toán
                // ==============================
                function startCountdown() {
                    const countdownBox = document.getElementById("countdown");

                    const countdownInterval = setInterval(function () {
                        let minutes = Math.floor(paymentTime / 60);
                        let seconds = paymentTime % 60;
                        seconds = seconds < 10 ? "0" + seconds : seconds;
                        countdownBox.innerHTML = minutes + ":" + seconds;
                        paymentTime--;

                        if (paymentTime < 0) {
                            clearInterval(countdownInterval);
                            clearInterval(checkInterval);
                            countdownBox.innerHTML = "❌ Hết thời gian thanh toán";

                            // Hết giờ => hủy booking
                            paymentCompleted = true;
                            setTimeout(function () {
                                window.location.href = cancelUrl;
                            }, 2000);
                        }
                    }, 1000);
                }

                // ==============================
                // KIỂM TRA THANH TOÁN (Google Sheets)
                // ==============================
                async function checkPaid() {
                    try {
                        const response = await fetch(
                                "https://script.google.com/macros/s/AKfycbx_7YlpGObHcFXy-gsffVBIBn-ZDXFemTbYOdOX_nmqMaaoSqgySPv7YT6SHCIuHi8/exec"
                                );
                        const data = await response.json();

                        if (!data.data)
                            return;

                        const expectedAmount = getCurrentAmount();

                        for (let i = 0; i < data.data.length; i++) {
                            const paid = data.data[i];
                            const price = parseFloat(
                                    paid["Giá trị"].toString().replace(/[.,]/g, "")
                                    );
                            const content = paid["Mô tả"];

                            if (price >= expectedAmount && content && content.includes(bookingContent)) {
                                // THANH TOÁN THÀNH CÔNG!
                                paymentCompleted = true; // Ngăn beforeunload hủy booking
                                clearInterval(checkInterval);

                                document.getElementById("paymentStatus").innerHTML =
                                        "✅ Thanh toán thành công!<br>Đang xử lý...";

                                // Gọi server cập nhật trạng thái + lưu payment
                                const paymentType = getPaymentType();
                                await fetch("<%= request.getContextPath() %>/updatePaymentSatus?bookingId=<%= bookingId %>&paymentType=" + paymentType);

                                setTimeout(function () {
                                    window.location.href = "BookingHistory";
                                }, 3000);

                                break;
                            }
                        }
                    } catch (err) {
                        console.error("Lỗi check payment:", err);
                    }
                }

                // ==============================
                // KHỞI CHẠY
                // ==============================
                startCountdown();
                checkInterval = setInterval(checkPaid, 5000);
        </script>
    </body>
</html>
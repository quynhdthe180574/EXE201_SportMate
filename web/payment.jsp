<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.BookingDAO" %>
<%@ page import="java.util.Map" %>

<%
    String bookingIdParam = request.getParameter("bookingId");
    if (bookingIdParam == null) {
        response.sendRedirect("home.jsp");
        return;
    }

    int bookingId = Integer.parseInt(bookingIdParam);

    BookingDAO dao = new BookingDAO();
    Map<String, Object> booking = dao.getBookingById(bookingId);

    if (booking == null) {
        response.sendRedirect("home.jsp");
        return;
    }

    // LẤY DỮ LIỆU SAU KHI ĐÃ CÓ booking
    String fieldName = booking.get("field_name").toString();
    String bookingDate = booking.get("booking_date").toString();
    String startTime = booking.get("start_time").toString();
    String endTime = booking.get("end_time").toString();
    String status = booking.get("booking_status").toString();
    String fullName = booking.get("fullname").toString();
    String email = booking.get("email").toString();
    String phone = booking.get("phone").toString();
    
    double totalPrice = Double.parseDouble(booking.get("total_price").toString());
    String amountNoDot = String.valueOf((long) totalPrice);
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Thanh toán đặt sân</title>

        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: "Segoe UI", Arial, sans-serif;
            }

            body {
                min-height: 100vh;
                background:
                    linear-gradient(rgba(0,0,0,0.6), rgba(0,0,0,0.6)),
                    url("https://images.unsplash.com/photo-1508609349937-5ec4ae374ebf");
                background-size: cover;
                background-position: center;
                display: flex;
                justify-content: center;
                align-items: center;
            }

            .payment-wrapper {
                width: 100%;
                max-width: 1100px;
                background: #ffffff;
                border-radius: 20px;
                display: flex;
                overflow: hidden;
                box-shadow: 0 25px 60px rgba(0,0,0,0.4);
            }

            /* LEFT SIDE */
            .payment-left {
                flex: 1;
                padding: 50px;
                background: #f9f9f9;
            }

            .payment-left h1 {
                color: #0f8a3c;
                font-size: 32px;
                margin-bottom: 25px;
            }

            .info-row {
                margin-bottom: 18px;
                font-size: 17px;
                color: #333;
            }

            .info-row span {
                font-weight: 600;
            }

            .amount-box {
                margin-top: 30px;
                padding: 20px;
                background: #e8f5e9;
                border-radius: 12px;
                text-align: center;
            }

            .amount-box p {
                font-size: 16px;
                color: #2e7d32;
            }

            .amount {
                font-size: 32px;
                color: #d32f2f;
                font-weight: bold;
                margin-top: 10px;
            }

            /* RIGHT SIDE */
            .payment-right {
                flex: 1;
                padding: 50px;
                background: linear-gradient(135deg, #0f8a3c, #43a047);
                color: white;
                text-align: center;
            }

            .payment-right h2 {
                font-size: 26px;
                margin-bottom: 20px;
            }

            .qr-box {
                background: white;
                padding: 25px;
                border-radius: 16px;
                display: inline-block;
                box-shadow: 0 15px 30px rgba(0,0,0,0.3);
            }

            .qr-box img {
                width: 260px;
                height: 260px;
            }

            .payment-note {
                margin-top: 25px;
                font-size: 15px;
                line-height: 1.6;
            }

            .payment-note b {
                color: #ffeb3b;
            }
            .home-btn {
                display: inline-block;
                margin-top: 30px;
                padding: 14px 30px;
                background: white;
                color: #0f8a3c;
                border-radius: 30px;
                font-weight: bold;
                text-decoration: none;
                transition: 0.3s;
            }

            .home-btn:hover {
                background: #e8f5e9;
                transform: translateY(-2px);
            }
            .floating-home {
                position: fixed;
                left: 30px;
                top: 50%;
                transform: translateY(-50%);
                background: white;
                color: #0f8a3c;
                padding: 14px 22px;
                border-radius: 30px;
                font-weight: 600;
                text-decoration: none;
                box-shadow: 0 10px 25px rgba(0,0,0,0.25);
                transition: 0.3s;
            }

            .floating-home:hover {
                transform: translateY(-50%) translateX(5px);
                background: #e8f5e9;
            }

        </style>
    </head>

    <body>

        <div class="payment-wrapper">

            <!-- LEFT -->
            <div class="payment-left">

                <h1>⚽ THANH TOÁN ĐẶT SÂN</h1>

                <div class="info-row">
                    <span>Mã đặt sân:</span> #<%= bookingId %>
                </div>

                <div class="info-row">
                    <span>Người đặt:</span> <%= fullName %>
                </div>

                <div class="info-row">
                    <span>Email:</span> <%= email %>
                </div>

                <div class="info-row">
                    <span>SĐT:</span> <%= phone %>
                </div>
                <div class="info-row">
                    <span>Tên sân:</span> <%= fieldName %>
                </div>

                <div class="info-row">
                    <span>Ngày đặt:</span> <%= bookingDate %>
                </div>

                <div class="info-row">
                    <span>Khung giờ:</span> <%= startTime %> - <%= endTime %>
                </div>

                <div class="info-row">
                    <span>Trạng thái:</span> 
                    <%= status.equals("PENDING_PAYMENT") ? "Chờ thanh toán" : status %>
                </div>
                <div class="amount-box">
                    <p>Số tiền cần thanh toán</p>
                    <div class="amount">
                        <%= String.format("%,.0f", totalPrice) %> VNĐ
                    </div>
                </div>
            </div>

            <!-- RIGHT -->
            <div class="payment-right">
                <h2>Quét mã QR để thanh toán</h2>

                <div class="qr-box">
                    <img
                        src="https://api.vietqr.io/image/970422-22032004666888-compact2.jpg
                        ?accountName=DUONG%20THI%20QUYNH
                        &amount=<%= amountNoDot %>
                        &addInfo=BOOKING_<%= bookingId %>"                        alt="QR Thanh toán">
                </div>
                <div id="paymentMessage" 
                     style="display:none; margin-top:20px; padding:15px; border-radius:10px; font-weight:bold;">
                </div>

                <div id="countdownBox" 
                     style="margin-top:15px; font-weight:bold; font-size:16px;">
                </div>
                <div class="payment-note">
                    📱 Mở <b>ứng dụng ngân hàng</b> và quét mã QR<br>
                    💡 Vui lòng thanh toán <b>đúng số tiền</b>
                </div>
                <a href="home.jsp" class="home-btn">🏠 Về trang chủ</a>

            </div>

        </div>
        <script>

            // ===== THỜI GIAN ĐỢI (10 phút) =====
            let paymentTime = 10 * 60;
            let checkInterval;

            const bookingPrice = <%= amountNoDot %>;
            const bookingContent = "BOOKING<%= bookingId %>";

            function startCountdown() {

            const countdownBox = document.getElementById("countdownBox");
                    const countdownInterval = setInterval(() => {

                    let minutes = Math.floor(paymentTime / 60);
                            let seconds = paymentTime % 60;
                            seconds = seconds < 10 ? "0" + seconds : seconds;
                            countdownBox.innerHTML = "⏳ Thời gian còn lại: "
                            + minutes + ":" + seconds;
                            if (paymentTime < 60) {
                    countdownBox.style.color = "yellow";
                    }

                    paymentTime--;
                            if (paymentTime < 0) {
                    clearInterval(countdownInterval);
                            clearInterval(checkInterval);
                            countdownBox.innerHTML = "❌ Đã hết thời gian thanh toán.";
                            countdownBox.style.color = "red";
                            // Đợi 2 giây rồi về trang chủ
                            setTimeout(() => {
                            window.location.href = "home.jsp";
                            }, 10000);
                            }
    }, 1000);
}
                    async function checkPaid() {
                    try {

                    const response = await fetch("https://script.google.com/macros/s/AKfycbx_7YlpGObHcFXy-gsffVBIBn-ZDXFemTbYOdOX_nmqMaaoSqgySPv7YT6SHCIuHi8/exec");
                            const data = await response.json();
                            if (!data.data || data.data.length === 0)
                            return;
                            for (let i = 0; i < data.data.length; i++) {

                    const paid = data.data[i];
                            const price = parseFloat(
                                    paid["Giá trị"].toString().replace(/,/g, "")
                                    );
                            const content = paid["Mô tả"];
                            if (price === bookingPrice &&
                                    content &&
                                    content.includes(bookingContent)) {

                    clearInterval(checkInterval);
                            paymentTime = 0;
                            const msg = document.getElementById("paymentMessage");
                            msg.style.display = "block";
                            msg.style.background = "#e8f5e9";
                            msg.style.color = "#2e7d32";
                            msg.innerHTML = "✅ Đã nhận được thanh toán. Đang chờ xác nhận từ chủ sân.";
                            break;
                    }
                    }

                    } catch (err) {
                    console.error("Lỗi:", err);
                    }
                    }

                    startCountdown();
                            checkPaid();
                            checkInterval = setInterval(checkPaid, 5000);
        </script>

    </body>
</html>

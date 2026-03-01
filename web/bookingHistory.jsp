<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
    <title>Lịch sử đặt sân</title>
    <style>
/* Reset */
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

/* Cho body full chiều cao màn hình */
html, body {
    height: 100%;
    font-family: Arial, sans-serif;
    background: #f2f4f8;
}

/* Dùng flex để đẩy footer xuống */
body {
    display: flex;
    flex-direction: column;
}

/* Nội dung chính sẽ tự giãn */
.main-content {
    flex: 1;
    padding: 40px 0;
}

/* Header */
header {
    background: #1f8f3a;
    color: white;
    padding: 15px 40px;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

header a {
    color: white;
    text-decoration: none;
    margin-left: 20px;
    font-weight: 500;
}

header a:hover {
    text-decoration: underline;
}

/* Card chứa bảng */
.container {
    width: 80%;
    margin: auto;
    background: white;
    padding: 30px;
    border-radius: 12px;
    box-shadow: 0 5px 20px rgba(0,0,0,0.08);
}

/* Table */
table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
}

th {
    background: #1f8f3a;
    color: white;
    padding: 12px;
}

td {
    padding: 12px;
    border-bottom: 1px solid #ddd;
}

/* Footer */
footer {
    background: white;
    text-align: center;
    padding: 20px;
    margin-top: 20px;
    box-shadow: 0 -2px 10px rgba(0,0,0,0.05);
}
        footer {background: #111827; color: #9ca3af;}

</style>
</head>

<body>

<header>
    <div><strong>⚽ Football Booking System</strong></div>
    <div>
        <a href="home.jsp">Trang chủ</a>
        <a href="BookingHistory">Lịch sử</a>
        <a href="logout">Đăng xuất</a>
    </div>
</header>

<!-- CONTENT -->
<div class="container">
    <h2>LỊCH SỬ ĐẶT SÂN</h2>

    <table>
        <thead>
        <tr>
            <th>Mã</th>
            <th>Sân</th>
            <th>Ngày</th>
            <th>Giờ</th>
            <th>Số tiền</th>
            <th>Trạng thái</th>
        </tr>
        </thead>

        <tbody>
        <%
        List<Map<String, Object>> history =
                (List<Map<String, Object>>) request.getAttribute("history");

        if (history != null && !history.isEmpty()) {
            for (Map<String, Object> b : history) {

                String status = b.get("booking_status").toString();
                String statusText = "";
                String statusClass = "";

                switch(status) {
                    case "PENDING_PAYMENT":
                        statusText = "⏳ Chờ thanh toán";
                        statusClass = "pending";
                        break;
                    case "WAITING_CONFIRM":
                        statusText = "🔍 Chờ xác nhận";
                        statusClass = "waiting";
                        break;
                    case "CONFIRMED":
                        statusText = "✅ Đã xác nhận";
                        statusClass = "confirmed";
                        break;
                    case "EXPIRED":
                        statusText = "❌ Hết hạn";
                        statusClass = "expired";
                        break;
                    default:
                        statusText = status;
                }
        %>

        <tr>
            <td>#<%= b.get("booking_id") %></td>
            <td><%= b.get("field_name") %></td>
            <td><%= b.get("booking_date") %></td>
            <td>
                <%= b.get("start_time") %> - <%= b.get("end_time") %>
            </td>
            <td>
                <%= String.format("%,.0f", b.get("total_price")) %> VNĐ
            </td>
            <td class="<%= statusClass %>">
                <%= statusText %>
            </td>
        </tr>

        <%
            }
        } else {
        %>

        <tr>
            <td colspan="6" class="empty-row">
                Bạn chưa có lịch sử đặt sân nào.
            </td>
        </tr>

        <%
        }
        %>
        </tbody>
    </table>
</div>

<!-- FOOTER -->
<footer>
    © 2026 Đặt Sân Thể Thao. All rights reserved.
</footer>

</body>
</html>
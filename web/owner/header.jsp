<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Sport Booking - Chủ Sân</title>
        <style>
            :root {
                --blue-pastel: #A7C7E7;
                --green-pastel: #B2D8B2;
                --yellow-pastel: #FFFACD;
                --orange-pastel: #FFDAB9;
                --pink-pastel: #FFC1CC;
                --purple-pastel: #E0BBE4;
                --white: #ffffff;
                --gray-light: #f8f9fa;
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, var(--blue-pastel) 0%, var(--purple-pastel) 100%);
                min-height: 100vh;
                color: #444;
            }

            header {
                background: rgba(255, 255, 255, 0.9);
                backdrop-filter: blur(10px);
                padding: 15px 40px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
                position: sticky;
                top: 0;
                z-index: 1000;
            }

            .nav-container {
                max-width: 1400px;
                margin: auto;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .logo {
                font-size: 1.8rem;
                font-weight: bold;
                color: var(--blue-pastel);
                text-decoration: none;
            }

            nav a {
                margin-left: 25px;
                text-decoration: none;
                color: #555;
                font-weight: 500;
                transition: color 0.3s;
            }

            nav a:hover {
                color: var(--pink-pastel);
            }

            .main-content {
                max-width: 1400px;
                margin: 30px auto;
                padding: 0 30px;
            }
        </style>
    </head>

    <body>

        <header>
            <div class="nav-container">
                <a href="${pageContext.request.contextPath}/owner/dashboard" class="logo">Sport Booking Owner</a>
                <nav>
                    <a href="${pageContext.request.contextPath}/owner/dashboard">Dashboard</a>
                    <a href="${pageContext.request.contextPath}/owner/bookings">Quản lý Booking</a>
                    <a href="${pageContext.request.contextPath}/owner/payments">Lịch sử thanh toán</a>
                    <a href="${pageContext.request.contextPath}/owner/add-venue">Thêm sân</a>
                    <a href="${pageContext.request.contextPath}/owner/promotions">Quản lý khuyến mãi</a>
                    <a href="#">Quản lý khung giờ</a>
                    <a href="#">Quản lý ảnh</a>
                    <a href="${pageContext.request.contextPath}/LogoutServlet" style="color:var(--pink-pastel);">Đăng
                        xuất</a>
                </nav>
            </div>
        </header>

                        <div class="main-content"></div>
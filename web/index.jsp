<%-- 
    Document   : index
    Created on : Jan 21, 2026, 6:44:35 PM
    Author     : ADMIN (Pham)
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SportMate - Đặt Sân Thể Thao Nhanh Chóng</title>
    
    <!-- Google Fonts (tùy chọn, giúp font đẹp hơn) -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700;800&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --blue-pastel:   #A7C7E7;
            --green-pastel:  #B2D8B2;
            --yellow-pastel: #FFFACD;
            --orange-pastel: #FFDAB9;
            --pink-pastel:   #FFC1CC;
            --purple-pastel: #E0BBE4;
            --white:         #ffffff;
            --gray-light:    #f8f9fa;
            --dark-text:     #333;
        }
        * { 
            margin:0; 
            padding:0; 
            box-sizing:border-box; 
        }
        body {
            font-family: 'Poppins', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, var(--blue-pastel) 0%, var(--purple-pastel) 100%);
            min-height: 100vh;
            color: var(--dark-text);
            display: flex;
            flex-direction: column;
        }
        header {
            background: rgba(255,255,255,0.95);
            backdrop-filter: blur(12px);
            padding: 20px 60px;
            box-shadow: 0 4px 25px rgba(0,0,0,0.1);
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
            font-size: 2.5rem;
            font-weight: 800;
            color: var(--blue-pastel);
            text-decoration: none;
            letter-spacing: -1px;
        }
        nav a {
            margin-left: 40px;
            color: var(--dark-text);
            font-weight: 600;
            text-decoration: none;
            font-size: 1.15rem;
            transition: color 0.3s ease, transform 0.3s ease;
        }
        nav a:hover {
            color: var(--pink-pastel);
            transform: translateY(-2px);
        }

        .hero {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding: 0 40px;
        }
        .hero-content {
            max-width: 1000px;
            background: rgba(255,255,255,0.92);
            padding: 90px 80px;
            border-radius: 40px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.15);
        }
        h1 {
            font-size: 4.5rem;
            font-weight: 800;
            color: var(--blue-pastel);
            margin-bottom: 30px;
            line-height: 1.1;
        }
        .lead {
            font-size: 1.8rem;
            color: #555;
            margin-bottom: 60px;
            line-height: 1.6;
            font-weight: 400;
        }
        .btn-group {
            display: flex;
            gap: 35px;
            justify-content: center;
            flex-wrap: wrap;
        }
        .btn {
            padding: 20px 65px;
            font-size: 1.4rem;
            font-weight: 700;
            border-radius: 999px;
            text-decoration: none;
            transition: all 0.4s ease;
            box-shadow: 0 8px 25px rgba(0,0,0,0.12);
        }
        .btn-primary {
            background: var(--purple-pastel);
            color: white;
        }
        .btn-primary:hover {
            background: var(--pink-pastel);
            transform: translateY(-6px) scale(1.05);
            box-shadow: 0 20px 40px rgba(0,0,0,0.2);
        }
        .btn-secondary {
            background: var(--green-pastel);
            color: var(--dark-text);
        }
        .btn-secondary:hover {
            background: var(--orange-pastel);
            transform: translateY(-6px) scale(1.05);
            box-shadow: 0 20px 40px rgba(0,0,0,0.2);
        }

        footer {
            text-align: center;
            padding: 60px 20px;
            color: #555;
            font-size: 1.1rem;
            background: rgba(255,255,255,0.7);
            margin-top: auto;
            border-top: 1px solid rgba(0,0,0,0.05);
        }

        @media (max-width: 768px) {
            h1 { font-size: 3.2rem; }
            .lead { font-size: 1.4rem; }
            .btn { padding: 16px 50px; font-size: 1.2rem; }
            header { padding: 15px 30px; }
            nav a { margin-left: 20px; font-size: 1rem; }
        }
    </style>
</head>
<body>

<header>
    <div class="nav-container">
        <a href="${pageContext.request.contextPath}/" class="logo">SportMate</a>
        <nav>
            <a href="${pageContext.request.contextPath}/owner/dashboard">Dashboard Chủ Sân</a>
            <a href="${pageContext.request.contextPath}/search">Tìm & Đặt Sân</a>
            <a href="${pageContext.request.contextPath}/login">Đăng Nhập</a>
            <a href="${pageContext.request.contextPath}/register">Đăng Ký</a>
        </nav>
    </div>
</header>

<div class="hero">
    <div class="hero-content">
        <h1>Đặt Sân Thể Thao – Nhanh Chóng & Chuyên Nghiệp</h1>
        <p class="lead">
            SportMate giúp bạn tìm kiếm và đặt sân bóng đá, cầu lông, tennis, pickleball... chỉ trong vài cú click. 
            Chủ sân quản lý sân bãi, khung giờ, hình ảnh, booking và doanh thu một cách hiện đại, dễ dàng.
        </p>

        <div class="btn-group">
            <a href="${pageContext.request.contextPath}/owner/dashboard" class="btn btn-primary">
                Vào Dashboard Chủ Sân
            </a>
            <a href="${pageContext.request.contextPath}/search" class="btn btn-secondary">
                Tìm Sân Gần Đây
            </a>
        </div>
    </div>
</div>

<footer>
    © 2026 SportMate – Hệ thống đặt sân thể thao thông minh | Phát triển tại Hà Nội, Việt Nam
</footer>

</body>
</html>
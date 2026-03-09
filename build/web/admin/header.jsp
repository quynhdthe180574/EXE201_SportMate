<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Sport Mate - Admin</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
            rel="stylesheet">
        <style>
            :root {
                --primary: #15803d;
                --primary-light: #22c55e;
                --primary-bg: #f0fdf4;
                --primary-hover: #dcfce7;
                --accent: #166534;
                --white: #ffffff;
                --gray-50: #f9fafb;
                --gray-100: #f3f4f6;
                --gray-200: #e5e7eb;
                --gray-500: #6b7280;
                --gray-700: #374151;
                --gray-900: #111827;
                --danger: #ef4444;
                --warning: #f59e0b;
                --success: #10b981;

                /* backward compat for pages still using old vars */
                --green-pastel: #22c55e;
                --blue-pastel: #3b82f6;
                --pink-pastel: #ef4444;
                --purple-pastel: #15803d;
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Inter', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #f0fdf4 0%, #dcfce7 50%, #f0fdf4 100%);
                min-height: 100vh;
                color: var(--gray-700);
            }

            header {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(12px);
                padding: 0 40px;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.08), 0 4px 15px rgba(21, 128, 61, 0.06);
                position: sticky;
                top: 0;
                z-index: 1000;
                border-bottom: 2px solid var(--primary-light);
            }

            .nav-container {
                max-width: 1400px;
                margin: auto;
                display: flex;
                justify-content: space-between;
                align-items: center;
                height: 64px;
            }

            .logo {
                font-size: 1.5rem;
                font-weight: 800;
                color: var(--primary);
                text-decoration: none;
                display: flex;
                align-items: center;
                gap: 10px;
                letter-spacing: -0.5px;
            }

            .logo::before {
                content: '⚽';
                font-size: 1.6rem;
            }

            .logo span {
                color: var(--primary-light);
            }

            nav {
                display: flex;
                align-items: center;
                gap: 4px;
            }

            nav a {
                text-decoration: none;
                color: var(--gray-500);
                font-weight: 600;
                font-size: 0.85rem;
                padding: 8px 14px;
                border-radius: 8px;
                transition: all 0.2s ease;
            }

            nav a:hover {
                color: var(--primary);
                background: var(--primary-hover);
            }

            nav a.logout-btn {
                color: var(--danger) !important;
                margin-left: 8px;
            }

            nav a.logout-btn:hover {
                background: #fef2f2;
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
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="logo">Sport<span>Mate</span>
                    Admin</a>
                <nav>
                    <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
                    <a href="${pageContext.request.contextPath}/admin/users">Users</a>
                    <a href="${pageContext.request.contextPath}/admin/owner-requests">Owner Requests</a>
                    <a href="${pageContext.request.contextPath}/admin/venues">Venues</a>
                    <a href="${pageContext.request.contextPath}/admin/bookings">Bookings</a>
                    <a href="${pageContext.request.contextPath}/admin/reviews">Reviews</a>
                    <a href="${pageContext.request.contextPath}/admin/promotions">Promotions</a>
                    <a href="${pageContext.request.contextPath}/admin/account.jsp">Tài khoản</a>
                    <a href="${pageContext.request.contextPath}/LogoutServlet" class="logout-btn">Đăng xuất</a>
                </nav>
            </div>
        </header>

        <div class="main-content">
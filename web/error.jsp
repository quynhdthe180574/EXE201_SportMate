<%-- 
    Document   : error
    Created on : Jan 26, 2026
    Author     : Pham
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lỗi - SportMate</title>
    
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
        * { margin:0; padding:0; box-sizing:border-box; }
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, var(--blue-pastel) 0%, var(--purple-pastel) 100%);
            min-height: 100vh;
            color: var(--dark-text);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding: 40px 20px;
        }
        .error-container {
            background: rgba(255, 255, 255, 0.95);
            padding: 60px 80px;
            border-radius: 32px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.15);
            max-width: 700px;
            width: 100%;
        }
        h1 {
            font-size: 6rem;
            font-weight: 800;
            color: var(--pink-pastel);
            margin-bottom: 20px;
            line-height: 1;
        }
        h2 {
            font-size: 2.2rem;
            color: var(--blue-pastel);
            margin-bottom: 25px;
        }
        .message {
            font-size: 1.3rem;
            color: #555;
            margin-bottom: 40px;
            line-height: 1.6;
        }
        .error-detail {
            background: var(--gray-light);
            padding: 20px;
            border-radius: 16px;
            font-family: monospace;
            font-size: 1rem;
            color: #d32f2f;
            text-align: left;
            margin-bottom: 40px;
            max-height: 200px;
            overflow-y: auto;
            border: 1px solid #eee;
        }
        .btn {
            display: inline-block;
            padding: 16px 50px;
            font-size: 1.3rem;
            font-weight: 700;
            border-radius: 999px;
            text-decoration: none;
            transition: all 0.4s ease;
            margin: 10px;
        }
        .btn-home {
            background: var(--purple-pastel);
            color: white;
        }
        .btn-home:hover {
            background: var(--pink-pastel);
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.2);
        }
        .btn-dashboard {
            background: var(--green-pastel);
            color: var(--dark-text);
        }
        .btn-dashboard:hover {
            background: var(--orange-pastel);
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.2);
        }
        footer {
            margin-top: 60px;
            color: rgba(255,255,255,0.9);
            font-size: 1.1rem;
        }
    </style>
</head>
<body>

<div class="error-container">
    <h1>Ối!</h1>
    <h2>Có lỗi xảy ra rồi...</h2>
    
    <p class="message">
        <c:choose>
            <c:when test="${not empty errorMessage}">
                ${errorMessage}
            </c:when>
            <c:otherwise>
                Đã xảy ra lỗi không mong muốn. Đội ngũ SportMate đang kiểm tra và khắc phục ngay!
            </c:otherwise>
        </c:choose>
    </p>

    <!-- Hiển thị chi tiết lỗi nếu có (chỉ hiện khi debug, có thể comment khi production) -->
    <c:if test="${not empty requestScope.exception}">
        <div class="error-detail">
            <strong>Chi tiết lỗi:</strong><br>
            ${requestScope.exception.message}<br><br>
            <c:forEach var="stack" items="${requestScope.exception.stackTrace}">
                ${stack}<br>
            </c:forEach>
        </div>
    </c:if>

    <div>
        <a href="${pageContext.request.contextPath}/" class="btn btn-home">Về Trang Chủ</a>
        <a href="${pageContext.request.contextPath}/owner/dashboard" class="btn btn-dashboard">Thử Vào Dashboard</a>
    </div>
</div>

<footer>
    © 2026 SportMate – Hệ thống đặt sân thể thao thông minh | Hà Nội, Việt Nam
</footer>

</body>
</html>
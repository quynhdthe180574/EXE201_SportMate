<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Kết quả giao dịch</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" 
              integrity="sha512-z3gLpd7yknf1YoNbCzqRKc4qyor8gaKU1qmn+CShxbuBusANI9QpRohGBreCFkKxLhei6S9CQXFEbbKuqLg0DA==" 
              crossorigin="anonymous" referrerpolicy="no-referrer" />
    </head>
    <style>
        body {
            background-color: #ffeef4;
            font-family: "Segoe UI", Arial, sans-serif;
            margin: 0;
            padding: 0;
        }

        section {
            max-width: 600px;
            margin: 60px auto;
            background: #fff;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 4px 15px rgba(255, 105, 180, 0.2);
            text-align: center;
        }

        h3 {
            font-size: 22px;
            margin-bottom: 15px;
        }

        p {
            font-size: 17px;
            margin: 10px 0;
        }

        strong {
            font-size: 22px;
        }

        .btn-home {
            display: inline-block;
            margin-top: 30px;
            padding: 12px 28px;
            background: #ffb6c1;
            color: #fff;
            text-decoration: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: bold;
            transition: 0.3s ease;
        }

        .btn-home:hover {
            background: #ff8fab;
            box-shadow: 0 4px 10px rgba(255, 105, 180, 0.3);
        }
        img {
            width: 120px;
            height: 120px;
            margin-bottom: 20px;
        }
    </style>
    <body style="background-color: #f4f4f4; font-family: Arial, sans-serif; margin: 0; padding: 20px;">


        <section style="margin-top: 50px; text-align: center;">
            <div>
                <img src="https://cdn2.cellphones.com.vn/insecure/rs:fill:150:0/q:90/plain/https://cellphones.com.vn/media/wysiwyg/Review-empty.png" 
                     alt="Transaction Status" 
                     style="width: 120px; height: 120px; margin-bottom: 20px;">
            </div>

            <!-- Giao dịch thành công -->
            <c:if test="${transResult}">
                <div>
                    <h3 style="font-weight: bold; color: #28a745;">
                        Transaction has been successful!                    
                        <i class="fas fa-check-circle"></i>
                    </h3>
                    <p style="font-size: 18px; margin-top: 15px;">Please note the consultant's phone number:</p>
                    <strong style="color: red; font-size: 24px;">0383459560</strong>
                </div>
            </c:if>

            <!-- Giao dịch thất bại -->
            <c:if test="${transResult == false}">
                <div>
                    <h3 style="font-weight: bold; color: #dc3545;">
                        Transaction order failed!
                    </h3>
                    <p style="font-size: 18px; margin-top: 15px;">Thank you for using our service.</p>
                    <p style="font-size: 18px;">Contact the hotline for advice:</p>
                    <strong style="color: red; font-size: 24px;">0385684262</strong>
                </div>
            </c:if>

            <!-- Đang xử lý giao dịch -->
            <c:if test="${transResult == null}">
                <div>
                    <h3 style="font-weight: bold; color: #ffc107;">
                        We have received your order, please wait for processing!
                    </h3>
                    <p style="font-size: 18px; margin-top: 15px;">Please note the consultant's phone number:</p>
                    <strong style="color: red; font-size: 24px;">0385684262</strong>
                </div>
            </c:if>
            <a href="${pageContext.request.contextPath}/homepage"
               style="display: inline-block; background-color: #ffb3d9; color: white;
               padding: 12px 24px; border-radius: 25px; text-decoration: none;
               font-size: 16px; font-weight: 600; margin: 8px;
               transition: all 0.3s ease;">
                🏠 Back to Home
            </a>
            <a href="${pageContext.request.contextPath}/history"
               style="display: inline-block; background-color: #ffb3d9; color: white;
               padding: 12px 24px; border-radius: 25px; text-decoration: none;
               font-size: 16px; font-weight: 600; margin: 8px;
               transition: all 0.3s ease;">
                📜 View Order History
            </a>
        </section>

    </body>
</html>

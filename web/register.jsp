<%-- 
    Document   : register
    Created on : Jan 26, 2026, 9:52:54 PM
    Author     : FPTSHOP
--%>

<%-- 
    Document   : register
    Created on : Jan 26, 2026
    Author     : FPTSHOP
--%>

<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng ký | Sport Mate</title>

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Google Font -->
    <link href="https://fonts.googleapis.com/css2?family=Oswald:wght@400;600&display=swap" rel="stylesheet">

    <style>
        body {
            background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
            font-family: 'Oswald', sans-serif;
        }

        .auth-card {
            background: #111;
            border-radius: 16px;
            box-shadow: 0 15px 40px rgba(0,0,0,0.6);
            color: #fff;
        }

        .auth-card h4 {
            font-weight: 600;
            letter-spacing: 1px;
        }

        label {
            font-size: 14px;
            color: #aaa;
        }

        .form-control {
            background: #1c1c1c;
            border: 1px solid #333;
            color: #fff;
        }

        .form-control:focus {
            background: #1c1c1c;
            color: #fff;
            border-color: #28a745;
            box-shadow: none;
        }

        .btn-main {
            background: linear-gradient(90deg, #28a745, #5ddf72);
            border: none;
            color: #000;
            font-weight: 600;
            letter-spacing: 1px;
            transition: all 0.3s;
        }

        .btn-main:hover {
            transform: scale(1.03);
            box-shadow: 0 0 15px rgba(40, 167, 69, 0.7);
        }

        .sport-icon {
            font-size: 40px;
            color: #28a745;
        }

        .error-text {
            font-size: 14px;
        }
    </style>
</head>

<body>

<div class="container d-flex justify-content-center align-items-center" style="min-height:100vh">
    <div class="card auth-card p-4" style="width:450px">

        <div class="text-center mb-3">
            
            <h4>SPORT MATE</h4>
            <small class="text-success">Train harder • Live stronger</small>
        </div>

        <form action="register" method="post">
            <div class="mb-3">
                <label>Họ và tên</label>
                <input name="fullname" class="form-control" placeholder="Nguyễn Văn A" required>
            </div>

            <div class="mb-3">
                <label>Email</label>
                <input name="email" type="email" class="form-control" placeholder="you@email.com" required>
            </div>

            <div class="mb-3">
                <label>Mật khẩu</label>
                <input type="password" name="password" class="form-control" placeholder="••••••••" required>
            </div>

            <button class="btn btn-main w-100 mt-2">
                TẠO TÀI KHOẢN
            </button>
        </form>

        <div class="text-danger text-center mt-3 error-text">
            ${error}
        </div>

        <div class="text-center mt-3">
            <small class="text-secondary">
                Đã có tài khoản?
                <a href="login.jsp" class="text-success text-decoration-none">Đăng nhập</a>
            </small>
        </div>

    </div>
</div>

</body>
</html>



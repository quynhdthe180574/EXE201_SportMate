<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
    <title>Đặt lại mật khẩu</title>

    <style>
        body{
            font-family: Arial, sans-serif;
            background:#eef2ee;
            display:flex;
            justify-content:center;
            align-items:center;
            height:100vh;
        }

        .card{
            width:400px;
            background:white;
            border-radius:12px;
            padding:30px;
            box-shadow:0 6px 20px rgba(0,0,0,0.1);
        }

        .title{
            font-size:22px;
            font-weight:bold;
            margin-bottom:5px;
        }

        .subtitle{
            color:#777;
            font-size:14px;
            margin-bottom:20px;
        }

        label{
            font-size:14px;
            font-weight:bold;
        }

        input{
            width:100%;
            padding:10px;
            margin-top:6px;
            margin-bottom:15px;
            border:1px solid #ddd;
            border-radius:6px;
            background:#f7f7f7;
        }

        .btn{
            width:100%;
            padding:12px;
            border:none;
            border-radius:6px;
            background:#118a2f;
            color:white;
            font-size:15px;
            cursor:pointer;
        }

        .btn:hover{
            background:#0d6f25;
        }

        .error{
            color:red;
            margin-bottom:10px;
            text-align:center;
        }

        .footer{
            text-align:center;
            margin-top:15px;
            font-size:13px;
        }

        .footer a{
            color:#118a2f;
            text-decoration:none;
        }

        .otp-note{
            font-size:12px;
            color:#777;
            margin-top:-10px;
            margin-bottom:15px;
        }
    </style>

</head>

<body>

<div class="card">

    <div class="title">Đặt lại mật khẩu</div>
    <div class="subtitle">Nhập mã OTP và mật khẩu mới của bạn</div>

    <c:if test="${not empty error}">
        <div class="error">${error}</div>
    </c:if>

    <form action="reset-password" method="post">

        <label>Mã OTP</label>
        <input type="text" name="otp" placeholder="Nhập mã OTP 6 số" required>

        <div class="otp-note">
            Mã OTP đã được gửi đến email/điện thoại của bạn
        </div>

        <label>Mật khẩu mới</label>
        <input type="password" name="newPassword" placeholder="Nhập mật khẩu mới" required>

        <label>Xác nhận mật khẩu</label>
        <input type="password" name="confirmPassword" placeholder="Nhập lại mật khẩu mới" required>

        <button class="btn" type="submit">
            Đổi mật khẩu
        </button>

    </form>

    <div class="footer">
        Không nhận được mã OTP? 
        <a href="forgot-password.jsp">Gửi lại mã</a>
    </div>

</div>

</body>
</html>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
    <title>Quên mật khẩu</title>

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
            width:380px;
            background:white;
            border-radius:10px;
            padding:30px;
            box-shadow:0 5px 20px rgba(0,0,0,0.1);
        }

        .title{
            text-align:center;
            font-size:22px;
            font-weight:bold;
            margin-bottom:10px;
        }

        .subtitle{
            text-align:center;
            color:#666;
            font-size:14px;
            margin-bottom:25px;
        }

        label{
            font-size:14px;
            font-weight:bold;
        }

        input{
            width:100%;
            padding:10px;
            margin-top:5px;
            margin-bottom:15px;
            border:1px solid #ccc;
            border-radius:6px;
            background:#f3f7f3;
        }

        .btn{
            width:100%;
            padding:12px;
            border:none;
            border-radius:6px;
            cursor:pointer;
            font-size:14px;
        }

        .btn-send{
            background:#138c2f;
            color:white;
        }

        .btn-send:hover{
            background:#0f7225;
        }

        .divider{
            text-align:center;
            margin:15px 0;
            color:#999;
            font-size:13px;
        }

        .btn-back{
            background:#e8f1e8;
        }

        .btn-back:hover{
            background:#d7e8d7;
        }

        .msg-error{
            color:red;
            text-align:center;
            margin-bottom:10px;
        }

        .msg-success{
            color:green;
            text-align:center;
            margin-bottom:10px;
        }

        .register{
            text-align:center;
            font-size:13px;
            margin-top:15px;
        }

        .register a{
            color:#138c2f;
            text-decoration:none;
            font-weight:bold;
        }
    </style>
</head>

<body>

<div class="card">

    <div class="title">Quên mật khẩu?</div>
    <div class="subtitle">
        Nhập email của bạn, chúng tôi sẽ gửi mã OTP để đặt lại mật khẩu
    </div>

    <c:if test="${not empty error}">
        <div class="msg-error">${error}</div>
    </c:if>

    <c:if test="${not empty success}">
        <div class="msg-success">${success}</div>
    </c:if>

    <form action="forgot-password" method="post">

        <label>Địa chỉ Email</label>
        <input type="email" name="email" placeholder="example@gmail.com" required>

        <button class="btn btn-send" type="submit">
            Gửi mã OTP
        </button>

    </form>

    <div class="divider">HOẶC</div>

    <a href="login.jsp">
        <button class="btn btn-back">
            ← Quay lại đăng nhập
        </button>
    </a>

</div>

</body>
</html>
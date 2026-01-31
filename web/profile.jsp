<%-- 
    Document   : profile
    Created on : Jan 26, 2026
    Author     : FPTSHOP
--%>

<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>  
<%@page import="model.User"%>

<%
    User u = (User) session.getAttribute("user");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hồ sơ | Sport Zone</title>

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
            color: #fff;
            border-radius: 16px;
            box-shadow: 0 15px 40px rgba(0,0,0,0.6);
        }

        h4 {
            font-weight: 600;
            letter-spacing: 1px;
        }

        .profile-icon {
            font-size: 48px;
            color: #28a745;
        }

        .info-label {
            color: #aaa;
            font-size: 14px;
        }

        .info-value {
            font-size: 18px;
        }

        .btn-outline-success {
            border-color: #28a745;
            color: #28a745;
        }

        .btn-outline-success:hover {
            background: #28a745;
            color: #000;
        }

        .btn-logout {
            border-color: #dc3545;
            color: #dc3545;
        }

        .btn-logout:hover {
            background: #dc3545;
            color: #fff;
        }
    </style>
</head>

<body>

<div class="container d-flex justify-content-center align-items-center" style="min-height:100vh">
    <div class="card auth-card p-4" style="width:450px">

        <div class="text-center mb-3">
            
            <h4>HỒ SƠ CÁ NHÂN</h4>
            <small class="text-success">Train • Improve • Repeat</small>
        </div>

        <hr>

        <div class="mb-3">
            <div class="info-label">Họ và tên</div>
            <div class="info-value"><%= u.getFullname() %></div>
        </div>

        <div class="mb-4">
            <div class="info-label">Email</div>
            <div class="info-value"><%= u.getEmail() %></div>
        </div>

        <div class="d-flex justify-content-between">
            <a href="change-password.jsp" class="btn btn-outline-success btn-sm">
                 Đổi mật khẩu
            </a>

            <a href="logout" class="btn btn-logout btn-sm">
                Đăng xuất
            </a>
        </div>

    </div>
</div>

</body>
</html>

<%-- 
    Document   : reset-password
    Created on : Mar 1, 2026, 10:57:54 PM
    Author     : FPTSHOP
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Đặt lại mật khẩu</title>
</head>
<body>

<h2>Nhập OTP và mật khẩu mới</h2>

<form action="reset-password" method="post">

    <input type="text" name="otp" placeholder="Nhập OTP" required><br><br>

    <input type="password" name="newPassword" placeholder="Mật khẩu mới" required><br><br>

    <input type="password" name="confirmPassword" placeholder="Xác nhận mật khẩu" required><br><br>

    <button type="submit">Đổi mật khẩu</button>

</form>

<c:if test="${not empty error}">
    <p style="color:red">${error}</p>
</c:if>

</body>
</html>

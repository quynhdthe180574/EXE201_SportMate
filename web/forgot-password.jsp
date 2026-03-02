<%-- 
    Document   : forgot-password
    Created on : Mar 1, 2026, 10:56:48 PM
    Author     : FPTSHOP
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Quên mật khẩu</title>
</head>
<body>

<h2>Quên mật khẩu</h2>

<form action="forgot-password" method="post">
    <input type="email" name="email" placeholder="Nhập email của bạn" required>
    <button type="submit">Gửi OTP</button>
</form>

<c:if test="${not empty error}">
    <p style="color:red">${error}</p>
</c:if>

<c:if test="${not empty success}">
    <p style="color:green">${success}</p>
</c:if>

</body>
</html>

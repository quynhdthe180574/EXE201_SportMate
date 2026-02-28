<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Home</title>
    </head>
    <body>

        <c:choose>
            <c:when test="${sessionScope.user.roleId == 3}">
                <h3>Chào Người chơi 👋</h3>
                <a href="owner-request" class="btn btn-warning">
                    Trở thành Chủ sân
                </a>
            </c:when>

            <c:when test="${sessionScope.user.roleId == 2}">
                <h3>Chào Chủ Sân 🏟</h3>
            </c:when>

            <c:when test="${sessionScope.user.roleId == 1}">
                <h3>Chào Admin 👑</h3>
            </c:when>
        </c:choose>
    </body>
</html>
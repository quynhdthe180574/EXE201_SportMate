<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="java.util.List"%>
<%@page import="model.Notification"%>
<%
    List<Notification> list =
        (List<Notification>) request.getAttribute("list");

    int totalCount = (list != null) ? list.size() : 0;
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Home</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    </head>
    <body>

        <c:if test="${sessionScope.user != null}">
            <a href="notifications"
               class="position-relative text-dark fs-4">

                🔔

                <% if(totalCount > 0){ %>
                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                    <%= totalCount %>
                </span>
                <% } %>

            </a>
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

        </c:if>

    </body>
</html>
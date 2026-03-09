<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:include page="header.jsp" />

<style>
    h1 { text-align: center; color: var(--blue-pastel); margin: 30px 0; }
    table {
        width: 90%; margin: 20px auto; border-collapse: collapse;
        background: white; box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    }
    th, td { padding: 14px; text-align: left; border-bottom: 1px solid #ddd; }
    th { background: var(--blue-pastel); color: white; }
    tr:hover { background: #f5faff; }
    .no-data { text-align: center; color: #777; font-size: 1.2rem; padding: 40px; }
</style>

<h1>Danh Sách Tất Cả Sân</h1>

<c:choose>
    <c:when test="${empty venues or venues.size() == 0}">
        <p class="no-data">Chưa có sân nào trong hệ thống.</p>
    </c:when>
    <c:otherwise>
        <table>
            <tr>
                <th>ID</th>
                <th>Tên sân</th>
                <th>Chủ sân ID</th>
                <th>Địa chỉ</th>
                <th>Trạng thái</th>
            </tr>
            <c:forEach var="v" items="${venues}">
                <tr>
                    <td>${v.venueId}</td>
                    <td>${v.venueName}</td>
                    <td>${v.userId}</td>
                    <td>${v.addressDetail}</td>
                    <td>${v.status}</td>
                </tr>
            </c:forEach>
        </table>
    </c:otherwise>
</c:choose>

<jsp:include page="footer.jsp" />
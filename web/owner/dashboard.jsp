<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Dashboard Chủ Sân - SportMate</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="bg-light">
        <div class="container mt-5">
            <h1 class="text-center mb-4">Dashboard Chủ Sân</h1>

            <div class="row mb-4">
                <div class="col-md-4">
                    <div class="card text-white bg-primary">
                        <div class="card-body">
                            <h5 class="card-title">Tổng số sân</h5>
                            <p class="card-text display-4">${totalVenues}</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card text-white bg-success">
                        <div class="card-body">
                            <h5 class="card-title">Tổng booking</h5>
                            <p class="card-text display-4">${totalBookings}</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card text-white bg-info">
                        <div class="card-body">
                            <h5 class="card-title">Doanh thu sơ bộ</h5>
                            <p class="card-text display-4">
                                <fmt:formatNumber value="${totalRevenue}" type="currency" currencyCode="VND"/>
                            </p>
                        </div>
                    </div>
                </div>
            </div>

            <div class="d-flex justify-content-between mb-3">
                <h3>Danh sách sân của bạn</h3>
                <a href="${pageContext.request.contextPath}/owner/add-venue" class="btn btn-success">+ Thêm sân mới</a>
            </div>

            <table class="table table-striped table-hover">
                <thead class="table-dark">
                    <tr>
                        <th>Tên sân</th>
                        <th>Địa chỉ</th>
                        <th>Giờ mở cửa</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="venue" items="${venues}">
                        <tr>
                            <td>${venue.venueName}</td>
                            <td>${venue.addressDetail}</td>
                            <td>${venue.openTime} - ${venue.closeTime}</td>
                            <td>
                                <span class="badge ${venue.status == 'Hoạt động' ? 'bg-success' : 'bg-danger'}">
                                    ${venue.status}
                                </span>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/owner/view-venue?id=${venue.venueId}" 
                                   class="btn btn-sm btn-info">Xem chi tiết</a>
                                <form action="${pageContext.request.contextPath}/owner/edit-venue" method="get" style="display:inline;">
                                    <input type="hidden" name="venueId" value="${venue.venueId}">
                                    <button type="submit" class="btn btn-sm btn-warning">Sửa</button>
                                </form>
                                <c:if test="${venue.status != 'Ẩn'}">
                                    <form action="${pageContext.request.contextPath}/owner/hide-venue" method="post" style="display:inline;">
                                        <input type="hidden" name="venueId" value="${venue.venueId}">
                                        <button type="submit" class="btn btn-sm btn-danger" 
                                                onclick="return confirm('Ẩn sân này?')">Ẩn</button>
                                    </form>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <c:if test="${not empty error}">
                <div class="alert alert-danger mt-3">${error}</div>
            </c:if>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thiết lập khung giờ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container mt-5">
        <h2 class="text-center mb-4">Thiết lập khung giờ & giá</h2>

        <h4>Khung giờ hiện có</h4>
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Bắt đầu</th>
                    <th>Kết thúc</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="slot" items="${timeSlots}">
                    <tr>
                        <td>${slot.slotId}</td>
                        <td>${slot.startTime}</td>
                        <td>${slot.endTime}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <h4 class="mt-5">Thêm khung giờ mới</h4>
        <form action="${pageContext.request.contextPath}/owner/set-timeslots" method="post">
            <div class="row mb-3">
                <div class="col-md-6">
                    <label class="form-label">Giờ bắt đầu (HH:mm:ss)</label>
                    <input type="time" name="startTime" class="form-control" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Giờ kết thúc (HH:mm:ss)</label>
                    <input type="time" name="endTime" class="form-control" required>
                </div>
            </div>
            <button type="submit" class="btn btn-primary">Thêm khung giờ</button>
        </form>

        <a href="${pageContext.request.contextPath}/owner/dashboard" class="btn btn-secondary mt-4">Quay lại Dashboard</a>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
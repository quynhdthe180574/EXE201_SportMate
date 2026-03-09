<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm sân mới - SportMate</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container mt-5">
        <h2 class="text-center mb-4">Thêm sân mới</h2>

        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/owner/add-venue" method="post">
            <div class="mb-3">
                <label class="form-label">Tên sân</label>
                <input type="text" name="venueName" class="form-control" required>
            </div>

            <div class="row mb-3">
                <div class="col-md-6">
                    <label class="form-label">Tỉnh/Thành phố (provinceId)</label>
                    <input type="number" name="provinceId" class="form-control" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Quận/Huyện (districtId)</label>
                    <input type="number" name="districtId" class="form-control" required>
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label">Địa chỉ chi tiết</label>
                <input type="text" name="addressDetail" class="form-control" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Mô tả sân</label>
                <textarea name="description" class="form-control" rows="4"></textarea>
            </div>

            <div class="row mb-3">
                <div class="col-md-6">
                    <label class="form-label">Giờ mở cửa (HH:mm:ss)</label>
                    <input type="time" name="openTime" class="form-control" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Giờ đóng cửa (HH:mm:ss)</label>
                    <input type="time" name="closeTime" class="form-control" required>
                </div>
            </div>

            <button type="submit" class="btn btn-primary">Thêm sân</button>
            <a href="${pageContext.request.contextPath}/owner/dashboard" class="btn btn-secondary">Quay lại</a>
        </form>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
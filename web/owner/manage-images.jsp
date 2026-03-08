<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý hình ảnh sân con</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container mt-5">
        <h2 class="text-center mb-4">Quản lý hình ảnh - Field ID: ${fieldId}</h2>

        <c:if test="${not empty param.success}">
            <div class="alert alert-success">Thêm ảnh thành công!</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>

        <!-- Form thêm bằng URL (khớp với servlet hiện tại) -->
        <form action="${pageContext.request.contextPath}/owner/manage-images" method="post">
            <input type="hidden" name="fieldId" value="${fieldId}">
            <div class="mb-3">
                <label class="form-label">URL ảnh mới (dán link ảnh)</label>
                <input type="url" name="imageUrl" class="form-control" 
                       placeholder="https://example.com/san-bong.jpg" required>
            </div>
            <button type="submit" class="btn btn-primary mb-4">Thêm ảnh</button>
        </form>

        <h4>Danh sách ảnh (${images.size()})</h4>

        <c:if test="${empty images}">
            <p class="text-muted">Chưa có ảnh nào cho sân con này.</p>
        </c:if>

        <div class="row">
            <c:forEach var="img" items="${images}">
                <div class="col-md-3 mb-4">
                    <div class="card">
                        <img src="${img.imageUrl}" class="card-img-top" alt="Ảnh sân" 
                             style="height: 160px; object-fit: cover;"
                             onerror="this.src='https://via.placeholder.com/300x160?text=Ảnh lỗi';">
                        <div class="card-body text-center">
                            <form action="${pageContext.request.contextPath}/owner/delete-image" method="post" style="display:inline;">
                                <input type="hidden" name="imageId" value="${img.imageId}">
                                <button type="submit" class="btn btn-sm btn-danger"
                                        onclick="return confirm('Xóa ảnh này?')">Xóa</button>
                            </form>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <a href="${pageContext.request.contextPath}/owner/dashboard" class="btn btn-secondary mt-3">Quay lại Dashboard</a>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
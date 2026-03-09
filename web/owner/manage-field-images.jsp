<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý ảnh - ${field.fieldName} - SportMate</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        body { background: linear-gradient(135deg, #0f0c29, #302b63, #24243e); min-height: 100vh; color: #e0e0e0; }
        .form-container { background: rgba(255,255,255,0.06); border: 1px solid rgba(255,255,255,0.1); border-radius: 16px; padding: 2rem; backdrop-filter: blur(10px); }
        .form-control { background: rgba(255,255,255,0.08); border: 1px solid rgba(255,255,255,0.15); color: #fff; }
        .form-control:focus { background: rgba(255,255,255,0.12); color: #fff; border-color: #667eea; box-shadow: 0 0 0 0.2rem rgba(102,126,234,0.25); }
        .form-control::placeholder { color: rgba(255,255,255,0.4); }
        .form-label { color: #a0a0ff; font-weight: 500; }
        .img-card { position: relative; border-radius: 12px; overflow: hidden; border: 2px solid rgba(255,255,255,0.1); transition: transform 0.3s; }
        .img-card:hover { transform: scale(1.03); }
        .img-card img { width: 100%; height: 200px; object-fit: cover; }
        .img-card .overlay { position: absolute; bottom: 0; left: 0; right: 0; background: linear-gradient(transparent, rgba(0,0,0,0.8)); padding: 0.8rem; }
        .badge-thumbnail { background: linear-gradient(135deg, #f093fb, #f5576c); }
    </style>
</head>
<body>
    <jsp:include page="header.jsp"/>
    <div class="container py-4">
        <a href="${pageContext.request.contextPath}/owner/fields?venueId=${venue.venueId}" class="text-decoration-none text-white-50">
            <i class="bi bi-arrow-left me-1"></i> Quay lại danh sách sân
        </a>
        <h2 class="text-white mt-3 mb-1"><i class="bi bi-images me-2"></i>Quản lý ảnh: ${field.fieldName}</h2>
        <p class="text-white-50 mb-4">Thuộc: ${venue.venueName}</p>

        <!-- Form thêm ảnh -->
        <div class="form-container mb-4" style="max-width: 600px;">
            <h5 class="text-white mb-3"><i class="bi bi-plus-circle me-2"></i>Thêm ảnh mới</h5>
            <form action="${pageContext.request.contextPath}/owner/field-images" method="post">
                <input type="hidden" name="action" value="upload">
                <input type="hidden" name="fieldId" value="${field.fieldId}">
                <div class="mb-3">
                    <label for="imageUrl" class="form-label">URL ảnh <span class="text-danger">*</span></label>
                    <input type="url" class="form-control" id="imageUrl" name="imageUrl"
                           placeholder="https://example.com/image.jpg" required>
                    <div class="form-text text-white-50">Nhập đường dẫn URL của ảnh sân.</div>
                </div>
                <button type="submit" class="btn btn-success">
                    <i class="bi bi-upload me-1"></i> Thêm ảnh
                </button>
            </form>
        </div>

        <!-- Gallery ảnh -->
        <h5 class="text-white mb-3">
            <i class="bi bi-grid me-2"></i>Ảnh hiện có
            <span class="badge bg-secondary ms-1">${images.size()} ảnh</span>
        </h5>

        <div class="row g-3">
            <c:forEach var="img" items="${images}" varStatus="status">
                <div class="col-lg-3 col-md-4 col-6">
                    <div class="img-card">
                        <img src="${img.imageUrl}" alt="Ảnh sân ${status.index + 1}">
                        <div class="overlay d-flex justify-content-between align-items-end">
                            <c:if test="${status.first}">
                                <span class="badge badge-thumbnail"><i class="bi bi-star-fill me-1"></i>Ảnh đại diện</span>
                            </c:if>
                            <c:if test="${!status.first}">
                                <span></span>
                            </c:if>
                            <form action="${pageContext.request.contextPath}/owner/field-images" method="post"
                                  onsubmit="return confirm('Xóa ảnh này?')">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="fieldId" value="${field.fieldId}">
                                <input type="hidden" name="imageId" value="${img.imageId}">
                                <button type="submit" class="btn btn-sm btn-danger">
                                    <i class="bi bi-trash"></i>
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </c:forEach>

            <c:if test="${empty images}">
                <div class="col-12 text-center py-5">
                    <i class="bi bi-image text-white-50" style="font-size:4rem"></i>
                    <p class="text-white-50 mt-3 mb-0">Chưa có ảnh nào cho sân này.</p>
                </div>
            </c:if>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

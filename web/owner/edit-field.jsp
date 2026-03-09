<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sửa sân - ${field.fieldName} - SportMate</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        body { background: linear-gradient(135deg, #0f0c29, #302b63, #24243e); min-height: 100vh; color: #e0e0e0; }
        .form-container { background: rgba(255,255,255,0.06); border: 1px solid rgba(255,255,255,0.1); border-radius: 16px; padding: 2rem; backdrop-filter: blur(10px); }
        .form-control, .form-select { background: rgba(255,255,255,0.08); border: 1px solid rgba(255,255,255,0.15); color: #fff; }
        .form-control:focus, .form-select:focus { background: rgba(255,255,255,0.12); color: #fff; border-color: #667eea; box-shadow: 0 0 0 0.2rem rgba(102,126,234,0.25); }
        .form-label { color: #a0a0ff; font-weight: 500; }
        option { background: #1a1a2e; color: #fff; }
        .img-thumbnail-custom { width: 120px; height: 90px; object-fit: cover; border-radius: 8px; border: 2px solid rgba(255,255,255,0.1); }
    </style>
</head>
<body>
    <jsp:include page="header.jsp"/>
    <div class="container py-4">
        <a href="${pageContext.request.contextPath}/owner/fields?venueId=${venue.venueId}" class="text-decoration-none text-white-50">
            <i class="bi bi-arrow-left me-1"></i> Quay lại danh sách sân
        </a>
        <h2 class="text-white mt-3 mb-4"><i class="bi bi-pencil-square me-2"></i>Sửa sân: ${field.fieldName}</h2>

        <div class="row">
            <div class="col-lg-6">
                <div class="form-container">
                    <form action="${pageContext.request.contextPath}/owner/fields" method="post">
                        <input type="hidden" name="action" value="edit">
                        <input type="hidden" name="fieldId" value="${field.fieldId}">

                        <div class="mb-3">
                            <label for="fieldName" class="form-label">Tên sân <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="fieldName" name="fieldName"
                                   value="${field.fieldName}" required>
                        </div>

                        <div class="mb-3">
                            <label for="sportTypeId" class="form-label">Loại sân <span class="text-danger">*</span></label>
                            <select class="form-select" id="sportTypeId" name="sportTypeId" required>
                                <c:forEach var="st" items="${sportTypes}">
                                    <option value="${st.sportTypeId}" ${st.sportTypeId == field.sportTypeId ? 'selected' : ''}>${st.sportName}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-warning">
                                <i class="bi bi-check-lg me-1"></i> Lưu thay đổi
                            </button>
                            <a href="${pageContext.request.contextPath}/owner/fields?venueId=${venue.venueId}" class="btn btn-secondary">
                                Hủy
                            </a>
                        </div>
                    </form>
                </div>
            </div>

            <div class="col-lg-6 mt-4 mt-lg-0">
                <div class="form-container">
                    <h5 class="text-white mb-3"><i class="bi bi-images me-2"></i>Ảnh hiện tại</h5>
                    <div class="d-flex flex-wrap gap-2">
                        <c:forEach var="img" items="${images}">
                            <img src="${img.imageUrl}" alt="Ảnh sân" class="img-thumbnail-custom">
                        </c:forEach>
                        <c:if test="${empty images}">
                            <p class="text-white-50 mb-0">Chưa có ảnh.</p>
                        </c:if>
                    </div>
                    <a href="${pageContext.request.contextPath}/owner/field-images?fieldId=${field.fieldId}"
                       class="btn btn-sm btn-outline-info mt-3">
                        <i class="bi bi-images me-1"></i> Quản lý ảnh
                    </a>
                </div>

                <div class="form-container mt-3">
                    <h5 class="text-white mb-3"><i class="bi bi-cash-coin me-2"></i>Quản lý giá</h5>
                    <a href="${pageContext.request.contextPath}/owner/field-prices?fieldId=${field.fieldId}"
                       class="btn btn-sm btn-outline-success">
                        <i class="bi bi-cash-coin me-1"></i> Cấu hình giá theo khung giờ
                    </a>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách sân - ${venue.venueName} - SportMate</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        body { background: linear-gradient(135deg, #0f0c29, #302b63, #24243e); min-height: 100vh; color: #e0e0e0; }
        .field-card { background: rgba(255,255,255,0.06); border: 1px solid rgba(255,255,255,0.1); border-radius: 16px; transition: transform 0.3s, box-shadow 0.3s; overflow: hidden; }
        .field-card:hover { transform: translateY(-4px); box-shadow: 0 8px 30px rgba(102,126,234,0.3); }
        .field-card img { height: 180px; object-fit: cover; width: 100%; }
        .field-card .card-body { padding: 1.2rem; }
        .badge-sport { background: linear-gradient(135deg, #667eea, #764ba2); }
        .btn-action { border-radius: 8px; font-size: 0.85rem; }
    </style>
</head>
<body>
    <jsp:include page="header.jsp"/>
    <div class="container py-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <a href="${pageContext.request.contextPath}/owner/dashboard" class="text-decoration-none text-white-50">
                    <i class="bi bi-arrow-left me-1"></i> Dashboard
                </a>
                <h2 class="text-white mt-2 mb-1">
                    <i class="bi bi-grid-3x3-gap-fill me-2"></i>Sân thuộc: ${venue.venueName}
                </h2>
                <p class="text-white-50 mb-0"><i class="bi bi-geo-alt me-1"></i>${venue.addressDetail}</p>
            </div>
            <a href="${pageContext.request.contextPath}/owner/fields?action=add&venueId=${venue.venueId}"
               class="btn btn-success">
                <i class="bi bi-plus-circle me-1"></i> Thêm sân mới
            </a>
        </div>

        <c:if test="${not empty param.success}">
            <div class="alert alert-success alert-dismissible fade show">
                <i class="bi bi-check-circle me-1"></i>
                <c:choose>
                    <c:when test="${param.success == 'added'}">Thêm sân thành công!</c:when>
                    <c:when test="${param.success == 'updated'}">Cập nhật sân thành công!</c:when>
                    <c:when test="${param.success == 'deleted'}">Xóa sân thành công!</c:when>
                    <c:otherwise>Thao tác thành công!</c:otherwise>
                </c:choose>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${param.error == 'has_bookings'}">
            <div class="alert alert-danger alert-dismissible fade show">
                <i class="bi bi-exclamation-triangle me-1"></i>
                Không thể xóa sân này vì đã có đơn đặt sân. Vui lòng ẩn địa điểm nếu không muốn nhận booking mới.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="row g-4">
            <c:forEach var="field" items="${fields}">
                <div class="col-lg-4 col-md-6">
                    <div class="card field-card">
                        <c:choose>
                            <c:when test="${not empty field.imageUrls}">
                                <img src="${field.imageUrls[0]}" alt="${field.fieldName}">
                            </c:when>
                            <c:otherwise>
                                <div style="height:180px; background:linear-gradient(135deg,#667eea,#764ba2); display:flex; align-items:center; justify-content:center;">
                                    <i class="bi bi-image text-white" style="font-size:3rem; opacity:0.5"></i>
                                </div>
                            </c:otherwise>
                        </c:choose>
                        <div class="card-body">
                            <h5 class="text-white mb-2">${field.fieldName}</h5>
                            <span class="badge badge-sport mb-3">
                                <c:choose>
                                    <c:when test="${field.sportTypeId == 1}">⚽ Bóng đá</c:when>
                                    <c:when test="${field.sportTypeId == 2}">🏸 Cầu lông</c:when>
                                    <c:otherwise>🏟️ Khác</c:otherwise>
                                </c:choose>
                            </span>
                            <div class="d-flex flex-wrap gap-2 mt-2">
                                <a href="${pageContext.request.contextPath}/owner/fields?action=edit&fieldId=${field.fieldId}"
                                   class="btn btn-sm btn-outline-warning btn-action">
                                    <i class="bi bi-pencil"></i> Sửa
                                </a>
                                <a href="${pageContext.request.contextPath}/owner/field-images?fieldId=${field.fieldId}"
                                   class="btn btn-sm btn-outline-info btn-action">
                                    <i class="bi bi-images"></i> Ảnh
                                </a>
                                <a href="${pageContext.request.contextPath}/owner/field-prices?fieldId=${field.fieldId}"
                                   class="btn btn-sm btn-outline-success btn-action">
                                    <i class="bi bi-cash-coin"></i> Giá
                                </a>
                                <form action="${pageContext.request.contextPath}/owner/fields" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="fieldId" value="${field.fieldId}">
                                    <button type="submit" class="btn btn-sm btn-outline-danger btn-action"
                                            onclick="return confirm('Bạn có chắc muốn xóa sân này? Hành động không thể hoàn tác!')">
                                        <i class="bi bi-trash"></i> Xóa
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>

            <c:if test="${empty fields}">
                <div class="col-12 text-center py-5">
                    <i class="bi bi-inbox text-white-50" style="font-size:4rem"></i>
                    <p class="text-white-50 mt-3 mb-0">Chưa có sân nào trong địa điểm này.</p>
                    <a href="${pageContext.request.contextPath}/owner/fields?action=add&venueId=${venue.venueId}"
                       class="btn btn-success mt-3"><i class="bi bi-plus-circle me-1"></i> Thêm sân đầu tiên</a>
                </div>
            </c:if>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

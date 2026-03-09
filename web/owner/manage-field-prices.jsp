<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cấu hình giá - ${field.fieldName} - SportMate</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        body { background: linear-gradient(135deg, #0f0c29, #302b63, #24243e); min-height: 100vh; color: #e0e0e0; }
        .form-container { background: rgba(255,255,255,0.06); border: 1px solid rgba(255,255,255,0.1); border-radius: 16px; padding: 2rem; backdrop-filter: blur(10px); }
        .form-control { background: rgba(255,255,255,0.08); border: 1px solid rgba(255,255,255,0.15); color: #fff; text-align: right; }
        .form-control:focus { background: rgba(255,255,255,0.12); color: #fff; border-color: #667eea; box-shadow: 0 0 0 0.2rem rgba(102,126,234,0.25); }
        .form-control::placeholder { color: rgba(255,255,255,0.4); }
        .table-custom { background: transparent; }
        .table-custom th { background: rgba(255,255,255,0.1); border: none; color: #a0a0ff; }
        .table-custom td { border-color: rgba(255,255,255,0.05); vertical-align: middle; }
        .time-badge { background: linear-gradient(135deg, #667eea, #764ba2); border-radius: 8px; padding: 0.4rem 0.8rem; display: inline-block; font-weight: 500; }
        .input-group-text { background: rgba(255,255,255,0.1); border: 1px solid rgba(255,255,255,0.15); color: #a0a0ff; }
    </style>
</head>
<body>
    <jsp:include page="header.jsp"/>
    <div class="container py-4">
        <a href="${pageContext.request.contextPath}/owner/fields?venueId=${venue.venueId}" class="text-decoration-none text-white-50">
            <i class="bi bi-arrow-left me-1"></i> Quay lại danh sách sân
        </a>
        <h2 class="text-white mt-3 mb-1"><i class="bi bi-cash-coin me-2"></i>Cấu hình giá: ${field.fieldName}</h2>
        <p class="text-white-50 mb-4">Thuộc: ${venue.venueName} | Nhập giá cho từng khung giờ. Để trống nếu không mở bán khung giờ đó.</p>

        <c:if test="${not empty param.success}">
            <div class="alert alert-success alert-dismissible fade show">
                <i class="bi bi-check-circle me-1"></i> Đã lưu cấu hình giá thành công!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="form-container">
            <form action="${pageContext.request.contextPath}/owner/field-prices" method="post">
                <input type="hidden" name="fieldId" value="${field.fieldId}">

                <table class="table table-custom table-dark table-hover">
                    <thead>
                        <tr>
                            <th style="width:40%">Khung giờ</th>
                            <th style="width:40%">Giá thuê (VNĐ)</th>
                            <th style="width:20%">Trạng thái</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="slot" items="${prices}">
                            <tr>
                                <td>
                                    <input type="hidden" name="slotId" value="${slot.slotId}">
                                    <span class="time-badge">
                                        <i class="bi bi-clock me-1"></i>
                                        ${slot.startTime} - ${slot.endTime}
                                    </span>
                                </td>
                                <td>
                                    <div class="input-group">
                                        <input type="number" class="form-control" name="price_${slot.slotId}"
                                               value="${slot.price != null ? slot.price.intValue() : ''}"
                                               placeholder="0" min="0" step="10000">
                                        <span class="input-group-text">đ</span>
                                    </div>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${slot.price != null && slot.price > 0}">
                                            <span class="badge bg-success"><i class="bi bi-check-circle me-1"></i>Đang bán</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary"><i class="bi bi-dash-circle me-1"></i>Chưa cấu hình</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <div class="d-flex gap-2 mt-3">
                    <button type="submit" class="btn btn-success btn-lg">
                        <i class="bi bi-check-lg me-1"></i> Lưu cấu hình giá
                    </button>
                    <a href="${pageContext.request.contextPath}/owner/fields?venueId=${venue.venueId}"
                       class="btn btn-secondary btn-lg">Hủy</a>
                </div>
            </form>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

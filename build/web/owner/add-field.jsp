<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm sân mới - SportMate</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        body { background: linear-gradient(135deg, #0f0c29, #302b63, #24243e); min-height: 100vh; color: #e0e0e0; }
        .form-container { background: rgba(255,255,255,0.06); border: 1px solid rgba(255,255,255,0.1); border-radius: 16px; padding: 2rem; backdrop-filter: blur(10px); }
        .form-control, .form-select { background: rgba(255,255,255,0.08); border: 1px solid rgba(255,255,255,0.15); color: #fff; }
        .form-control:focus, .form-select:focus { background: rgba(255,255,255,0.12); color: #fff; border-color: #667eea; box-shadow: 0 0 0 0.2rem rgba(102,126,234,0.25); }
        .form-control::placeholder { color: rgba(255,255,255,0.4); }
        .form-label { color: #a0a0ff; font-weight: 500; }
        option { background: #1a1a2e; color: #fff; }
    </style>
</head>
<body>
    <jsp:include page="header.jsp"/>
    <div class="container py-4">
        <a href="${pageContext.request.contextPath}/owner/fields?venueId=${venue.venueId}" class="text-decoration-none text-white-50">
            <i class="bi bi-arrow-left me-1"></i> Quay lại danh sách sân
        </a>
        <h2 class="text-white mt-3 mb-4"><i class="bi bi-plus-square me-2"></i>Thêm sân mới - ${venue.venueName}</h2>

        <c:if test="${not empty param.error}">
            <div class="alert alert-danger">
                <i class="bi bi-exclamation-triangle me-1"></i>
                Vui lòng điền đầy đủ thông tin bắt buộc.
            </div>
        </c:if>

        <div class="form-container" style="max-width: 600px;">
            <form action="${pageContext.request.contextPath}/owner/fields" method="post">
                <input type="hidden" name="action" value="add">
                <input type="hidden" name="venueId" value="${venue.venueId}">

                <div class="mb-3">
                    <label for="fieldName" class="form-label">Tên sân <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="fieldName" name="fieldName"
                           placeholder="VD: Sân bóng đá - Sân 1" required>
                </div>

                <div class="mb-3">
                    <label for="sportTypeId" class="form-label">Loại sân <span class="text-danger">*</span></label>
                    <select class="form-select" id="sportTypeId" name="sportTypeId" required>
                        <option value="">-- Chọn loại sân --</option>
                        <c:forEach var="st" items="${sportTypes}">
                            <option value="${st.sportTypeId}">${st.sportName}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-success">
                        <i class="bi bi-check-lg me-1"></i> Thêm sân
                    </button>
                    <a href="${pageContext.request.contextPath}/owner/fields?venueId=${venue.venueId}" class="btn btn-secondary">
                        Hủy
                    </a>
                </div>
            </form>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

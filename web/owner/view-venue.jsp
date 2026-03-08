<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết sân: ${venue.venueName}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container mt-5">
        <h1 class="text-center mb-4">Chi tiết sân: ${venue.venueName}</h1>

        <div class="card mb-4">
            <div class="card-body">
                <p><strong>Địa chỉ:</strong> ${venue.addressDetail}</p>
                <p><strong>Mô tả:</strong> ${venue.description}</p>
                <p><strong>Giờ hoạt động:</strong> ${venue.openTime} - ${venue.closeTime}</p>
                <p><strong>Trạng thái:</strong> 
                    <span class="badge ${venue.status == 'Hoạt động' ? 'bg-success' : 'bg-danger'}">
                        ${venue.status}
                    </span>
                </p>
            </div>
        </div>

        <h3>Danh sách sân con (Fields)</h3>
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Tên sân con</th>
                    <th>Loại thể thao (ID)</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="field" items="${fields}">
                    <tr>
                        <td>${field.fieldId}</td>
                        <td>${field.fieldName}</td>
                        <td>${field.sportTypeId}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/owner/manage-images?fieldId=${field.fieldId}" 
                               class="btn btn-sm btn-primary">Quản lý ảnh</a>
                            <!-- Có thể thêm link thiết lập giá nếu có -->
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <a href="${pageContext.request.contextPath}/owner/dashboard" class="btn btn-secondary mt-3">Quay lại Dashboard</a>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
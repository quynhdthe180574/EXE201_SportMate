<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="dao.VenueDAO" %>
<%@ page import="model.Venue" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sửa sân - SportMate</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container mt-5">
        <h2 class="text-center mb-4">Sửa thông tin sân</h2>
        <%
            String venueIdStr = request.getParameter("venueId");
            String error = request.getParameter("error");
            Venue venue = null;
            if (venueIdStr != null && !venueIdStr.trim().isEmpty()) {
                try {
                    int venueId = Integer.parseInt(venueIdStr.trim());
                    VenueDAO dao = new VenueDAO();
                    Integer ownerId = (Integer) session.getAttribute("userId");
                    if (ownerId != null) {
                        venue = dao.getVenueById(venueId, ownerId);
                    }
                } catch (Exception e) {
                    // ignore
                }
            }
        %>
        <c:if test="${not empty param.error}">
            <div class="alert alert-danger"><%= error != null ? error : "" %></div>
        </c:if>
        <% if (venue == null) { %>
            <div class="alert alert-warning">Không tìm thấy sân hoặc bạn không có quyền chỉnh sửa.</div>
            <a href="${pageContext.request.contextPath}/owner/dashboard" class="btn btn-secondary">Quay lại Dashboard</a>
        <% } else { %>
            <form action="${pageContext.request.contextPath}/owner/edit-venue" method="post">
                <input type="hidden" name="venueId" value="<%= venue.getVenueId() %>">
                <div class="mb-3">
                    <label class="form-label">Tên sân</label>
                    <input type="text" name="venueName" class="form-control" value="<%= venue.getVenueName() %>" required>
                </div>
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label">Tỉnh/Thành phố (ID)</label>
                        <input type="number" name="provinceId" class="form-control" value="<%= venue.getProvinceId() %>" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Quận/Huyện (ID)</label>
                        <input type="number" name="districtId" class="form-control" value="<%= venue.getDistrictId() %>" required>
                    </div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Địa chỉ chi tiết</label>
                    <input type="text" name="addressDetail" class="form-control" value="<%= venue.getAddressDetail() %>" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Mô tả</label>
                    <textarea name="description" class="form-control" rows="4"><%= venue.getDescription() != null ? venue.getDescription() : "" %></textarea>
                </div>
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label">Giờ mở cửa</label>
                        <input type="time" name="openTime" class="form-control"
                               value="<%= venue.getOpenTime() != null ? venue.getOpenTime().toString().substring(0,5) : "" %>" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Giờ đóng cửa</label>
                        <input type="time" name="closeTime" class="form-control"
                               value="<%= venue.getCloseTime() != null ? venue.getCloseTime().toString().substring(0,5) : "" %>" required>
                    </div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Trạng thái</label>
                    <select name="status" class="form-select">
                        <option value="Hoạt động" <%= "Hoạt động".equals(venue.getStatus()) ? "selected" : "" %>>Hoạt động</option>
                        <option value="Ẩn" <%= "Ẩn".equals(venue.getStatus()) ? "selected" : "" %>>Ẩn</option>
                        <option value="Bảo trì" <%= "Bảo trì".equals(venue.getStatus()) ? "selected" : "" %>>Bảo trì</option>
                    </select>
                </div>
                <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                <a href="${pageContext.request.contextPath}/owner/dashboard" class="btn btn-secondary">Quay lại</a>
            </form>
        <% } %>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
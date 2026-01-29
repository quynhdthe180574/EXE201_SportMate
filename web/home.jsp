<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="dao.FieldDao" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.util.*" %>
<%
    // ==================== XỬ LÝ PARAMETERS ====================
    String keyword = request.getParameter("keyword");
    if (keyword == null) keyword = "";

    Integer provinceId = null;
    String provParam = request.getParameter("provinceId");
    if (provParam != null && !provParam.isEmpty()) {
        try { provinceId = Integer.parseInt(provParam); } catch (NumberFormatException e) {}
    }

    Integer districtId = null;
    String distParam = request.getParameter("districtId");
    if (distParam != null && !distParam.isEmpty()) {
        try { districtId = Integer.parseInt(distParam); } catch (NumberFormatException e) {}
    }

    Integer sportTypeId = null;
    String sportParam = request.getParameter("sportTypeId");
    if (sportParam != null && !sportParam.isEmpty()) {
        try { sportTypeId = Integer.parseInt(sportParam); } catch (NumberFormatException e) {}
    }

    Integer slotId = null;
    String slotParam = request.getParameter("slotId");
    if (slotParam != null && !slotParam.isEmpty()) {
        try { slotId = Integer.parseInt(slotParam); } catch (NumberFormatException e) {}
    }

    Double minPrice = null;
    String minPriceParam = request.getParameter("minPrice");
    if (minPriceParam != null && !minPriceParam.isEmpty()) {
        try { minPrice = Double.parseDouble(minPriceParam); } catch (NumberFormatException e) {}
    }

    Double maxPrice = null;
    String maxPriceParam = request.getParameter("maxPrice");
    if (maxPriceParam != null && !maxPriceParam.isEmpty()) {
        try { maxPrice = Double.parseDouble(maxPriceParam); } catch (NumberFormatException e) {}
    }

    String bookingDateStr = request.getParameter("bookingDate");
    Date bookingDate = null;
    if (bookingDateStr != null && !bookingDateStr.isEmpty()) {
        try { bookingDate = Date.valueOf(bookingDateStr); } catch (IllegalArgumentException e) {}
    }

    int pageNum = 1;
    String pageParam = request.getParameter("page");
    if (pageParam != null && !pageParam.isEmpty()) {
        try { pageNum = Integer.parseInt(pageParam); if (pageNum < 1) pageNum = 1; } catch (NumberFormatException e) {}
    }
    int pageSize = 9;

    String sortBy = request.getParameter("sortBy");
    if (sortBy == null || sortBy.isEmpty()) sortBy = "avg_rating";

    String order = request.getParameter("order");
    if (order == null || order.isEmpty()) order = "DESC";

    // ==================== GỌI DAO ====================
    FieldDao fieldDao = new FieldDao();

    List<Map<String, Object>> fields;
    int totalFields;
    Map<String, Object> selectedSlot = null;
    boolean availableMode = (bookingDate != null && slotId != null);

    // Nếu đang ở chế độ lọc sân trống → điều chỉnh sortBy nếu cần
    String effectiveSortBy = sortBy;
    if (availableMode && "min_price".equals(sortBy)) {
        effectiveSortBy = "slot_price"; // vì trong available query dùng slot_price
    }

    if (availableMode) {
        fields = fieldDao.getAvailableFields(
                keyword.isEmpty() ? null : keyword,
                provinceId, districtId, sportTypeId,
                minPrice, maxPrice, bookingDate, slotId,
                pageNum, pageSize, effectiveSortBy, order);
        totalFields = fieldDao.getTotalAvailableFields(
                keyword.isEmpty() ? null : keyword,
                provinceId, districtId, sportTypeId,
                minPrice, maxPrice, bookingDate, slotId);
        selectedSlot = fieldDao.getTimeSlotById(slotId);
    } else {
        fields = fieldDao.searchAndFilterFields(
                keyword.isEmpty() ? null : keyword,
                provinceId, districtId, sportTypeId,
                minPrice, maxPrice,
                pageNum, pageSize, effectiveSortBy, order);
        totalFields = fieldDao.getTotalFiltered(
                keyword.isEmpty() ? null : keyword,
                provinceId, districtId, sportTypeId,
                minPrice, maxPrice);
    }

    int totalPages = (int) Math.ceil((double) totalFields / pageSize);
    if (totalPages < 1) totalPages = 1;

    // Dropdown data
    List<Map<String, Object>> provinces = fieldDao.getProvinces();
    List<Map<String, Object>> districts = fieldDao.getDistricts(provinceId);
    List<Map<String, Object>> sportTypes = fieldDao.getSportTypes();
    List<Map<String, Object>> timeSlots = fieldDao.getTimeSlots();

    // Set attributes cho JSTL
    pageContext.setAttribute("fields", fields);
    pageContext.setAttribute("provinces", provinces);
    pageContext.setAttribute("districts", districts);
    pageContext.setAttribute("sportTypes", sportTypes);
    pageContext.setAttribute("timeSlots", timeSlots);
    pageContext.setAttribute("selectedSlot", selectedSlot);
    pageContext.setAttribute("availableMode", availableMode);
    pageContext.setAttribute("currentPage", pageNum);
    pageContext.setAttribute("totalPages", totalPages);
    pageContext.setAttribute("keyword", keyword);
    pageContext.setAttribute("bookingDateStr", bookingDateStr);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Đặt Sân Thể Thao - Trang Chủ</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        .field-card{transition:.2s; border-radius:12px; overflow:hidden;}
        .field-card:hover{transform:translateY(-5px); box-shadow:0 8px 20px rgba(0,0,0,.15);}
        .field-img-placeholder{background:#e9ecef; height:200px; display:flex; align-items:center; justify-content:center; color:#6c757d; font-size:1.2rem;}
        .rating-stars{color:#ffc107;}
        .price-range{font-weight:bold; color:#198754;}
        .filter-section{background:#f8f9fa; border-radius:12px; padding:20px;}
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-success">
        <div class="container">
            <a class="navbar-brand fw-bold" href="home.jsp"><i class="fas fa-futbol me-2"></i>Đặt Sân Thể Thao</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link" href="#">Đăng nhập</a></li>
                    <li class="nav-item"><a class="nav-link" href="#">Đăng ký</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container my-5">
        <h2 class="mb-4 text-center">Tìm kiếm và đặt sân thể thao nhanh chóng</h2>

        <!-- Form lọc -->
        <form method="get" action="home.jsp" class="mb-5">
            <div class="row g-3 filter-section">
                <div class="col-md-3">
                    <input type="text" name="keyword" class="form-control" placeholder="Tên sân hoặc địa điểm..." value="${keyword}">
                </div>
                <div class="col-md-2">
                    <select name="provinceId" class="form-select" onchange="this.form.submit()">
                        <option value="">Tất cả tỉnh/thành</option>
                        <c:forEach items="${provinces}" var="p">
                            <option value="${p.provinceId}" ${p.provinceId == param.provinceId ? 'selected' : ''}>${p.provinceName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-2">
                    <select name="districtId" class="form-select">
                        <option value="">Tất cả quận/huyện</option>
                        <c:forEach items="${districts}" var="d">
                            <option value="${d.districtId}" ${d.districtId == param.districtId ? 'selected' : ''}>${d.districtName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-2">
                    <select name="sportTypeId" class="form-select">
                        <option value="">Tất cả môn</option>
                        <c:forEach items="${sportTypes}" var="s">
                            <option value="${s.sportTypeId}" ${s.sportTypeId == param.sportTypeId ? 'selected' : ''}>${s.sportName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-2">
                    <input type="date" name="bookingDate" class="form-control" value="${param.bookingDate}">
                </div>
                <div class="col-md-2">
                    <select name="slotId" class="form-select">
                        <option value="">Tất cả khung giờ</option>
                        <c:forEach items="${timeSlots}" var="ts">
                            <option value="${ts.slotId}" ${ts.slotId == param.slotId ? 'selected' : ''}>
                                <fmt:formatDate value="${ts.startTime}" pattern="HH:mm"/> - <fmt:formatDate value="${ts.endTime}" pattern="HH:mm"/>
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-1">
                    <input type="number" name="minPrice" class="form-control" placeholder="Giá từ" value="${param.minPrice}">
                </div>
                <div class="col-md-1">
                    <input type="number" name="maxPrice" class="form-control" placeholder="Giá đến" value="${param.maxPrice}">
                </div>
                <div class="col-12 text-md-end mt-3 mt-md-0">
                    <button type="submit" class="btn btn-success"><i class="fas fa-search"></i> Tìm kiếm</button>
                </div>
            </div>
            <input type="hidden" name="page" value="1">
            <input type="hidden" name="sortBy" value="${param.sortBy != null ? param.sortBy : 'avg_rating'}">
            <input type="hidden" name="order" value="${param.order != null ? param.order : 'DESC'}">
        </form>

        <!-- Tiêu đề kết quả khi lọc sân trống -->
        <c:if test="${availableMode}">
            <div class="alert alert-success text-center">
                <strong>Sân trống ngày ${param.bookingDate}</strong> khung giờ 
                <fmt:formatDate value="${selectedSlot.startTime}" pattern="HH:mm"/> - 
                <fmt:formatDate value="${selectedSlot.endTime}" pattern="HH:mm"/>
            </div>
        </c:if>

        <!-- Sắp xếp -->
        <div class="mb-4 text-end">
            <small>Sắp xếp theo:</small>
            <a href="home.jsp?sortBy=avg_rating&order=DESC&page=1&keyword=${keyword}&provinceId=${param.provinceId}&districtId=${param.districtId}&sportTypeId=${param.sportTypeId}&bookingDate=${param.bookingDate}&slotId=${param.slotId}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}" 
               class="btn btn-outline-secondary btn-sm ${'avg_rating'.equals(param.sortBy) && 'DESC'.equals(param.order) ? 'active' : ''}">Đánh giá cao</a>
            <a href="home.jsp?sortBy=min_price&order=ASC&page=1&keyword=${keyword}&provinceId=${param.provinceId}&districtId=${param.districtId}&sportTypeId=${param.sportTypeId}&bookingDate=${param.bookingDate}&slotId=${param.slotId}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}" 
               class="btn btn-outline-secondary btn-sm ${'min_price'.equals(param.sortBy) && 'ASC'.equals(param.order) ? 'active' : ''}">Giá thấp</a>
        </div>

        <!-- Danh sách sân -->
        <c:choose>
            <c:when test="${empty fields}">
                <div class="alert alert-info text-center">
                    <c:choose>
                        <c:when test="${availableMode}">Không có sân nào trống vào thời gian này.</c:when>
                        <c:otherwise>Không tìm thấy sân nào phù hợp.</c:otherwise>
                    </c:choose>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row row-cols-1 row-cols-md-3 g-4">
                    <c:forEach items="${fields}" var="field">
                        <div class="col">
                            <div class="card h-100 field-card">
                                <div class="field-img-placeholder"><i class="fas fa-image fa-3x"></i></div>
                                <div class="card-body d-flex flex-column">
                                    <h5 class="card-title">${field.fieldName}</h5>
                                    <p class="card-text text-muted">
                                        <i class="fas fa-map-marker-alt"></i> ${field.venueName} - ${field.districtName}, ${field.provinceName}
                                    </p>
                                    <p class="card-text"><strong>Môn:</strong> ${field.sportName}</p>
                                    <p class="card-text"><strong>Giờ mở cửa:</strong> 
                                        <fmt:formatDate value="${field.openTime}" pattern="HH:mm"/> - 
                                        <fmt:formatDate value="${field.closeTime}" pattern="HH:mm"/>
                                    </p>

                                    <c:choose>
                                        <c:when test="${availableMode}">
                                            <p class="card-text"><strong>Khung giờ:</strong> 
                                                <fmt:formatDate value="${field.slotStartTime}" pattern="HH:mm"/> - 
                                                <fmt:formatDate value="${field.slotEndTime}" pattern="HH:mm"/>
                                            </p>
                                            <p class="card-text price-range">
                                                Giá: <fmt:formatNumber value="${field.slotPrice}" type="currency" currencySymbol="₫"/>
                                            </p>
                                            <p class="text-success fw-bold">✓ Còn trống</p>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="card-text price-range">
                                                Giá từ: <fmt:formatNumber value="${field.minPrice}" type="currency" currencySymbol="₫"/> 
                                                - <fmt:formatNumber value="${field.maxPrice}" type="currency" currencySymbol="₫"/>
                                            </p>
                                        </c:otherwise>
                                    </c:choose>

                                    <div class="mt-auto">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <c:choose>
                                                    <c:when test="${field.avgRating != null}">
                                                        <span class="rating-stars">
                                                            <c:forEach begin="1" end="5" var="i">
                                                                <i class="fas fa-star${i <= field.avgRating ? '' : '-o'}"></i>
                                                            </c:forEach>
                                                        </span>
                                                        <small>(${field.reviewCount} đánh giá)</small>
                                                    </c:when>
                                                    <c:otherwise><small>Chưa có đánh giá</small></c:otherwise>
                                                </c:choose>
                                            </div>
                                            <a href="FieldDetailServlet?fieldId=${field.fieldId}" class="btn btn-success btn-sm">Xem chi tiết</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <nav aria-label="Page navigation" class="mt-5">
                        <ul class="pagination justify-content-center">
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="home.jsp?page=${currentPage - 1}&sortBy=${param.sortBy}&order=${param.order}&keyword=${keyword}&provinceId=${param.provinceId}&districtId=${param.districtId}&sportTypeId=${param.sportTypeId}&bookingDate=${param.bookingDate}&slotId=${param.slotId}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}">Previous</a>
                            </li>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="home.jsp?page=${i}&sortBy=${param.sortBy}&order=${param.order}&keyword=${keyword}&provinceId=${param.provinceId}&districtId=${param.districtId}&sportTypeId=${param.sportTypeId}&bookingDate=${param.bookingDate}&slotId=${param.slotId}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}">${i}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="home.jsp?page=${currentPage + 1}&sortBy=${param.sortBy}&order=${param.order}&keyword=${keyword}&provinceId=${param.provinceId}&districtId=${param.districtId}&sportTypeId=${param.sportTypeId}&bookingDate=${param.bookingDate}&slotId=${param.slotId}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}">Next</a>
                            </li>
                        </ul>
                    </nav>
                </c:if>
            </c:otherwise>
        </c:choose>
    </div>

    <footer class="bg-dark text-white py-4 mt-5">
        <div class="container text-center">
            <p>&copy; 2026 Đặt Sân Thể Thao. All rights reserved.</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

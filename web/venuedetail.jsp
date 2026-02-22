<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="dao.FieldDao" %>
<%@ page import="java.util.*" %>
<%
    // Lấy venueId từ parameter
    int venueId = 0;
    String venueIdParam = request.getParameter("venueId");
    if (venueIdParam != null && !venueIdParam.isEmpty()) {
        try {
            venueId = Integer.parseInt(venueIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect("home.jsp");
            return;
        }
    } else {
        response.sendRedirect("home.jsp");
        return;
    }
    int pageNum = 1;
    String pageParam = request.getParameter("page");
    if (pageParam != null && !pageParam.isEmpty()) {
        try { pageNum = Integer.parseInt(pageParam); if (pageNum < 1) pageNum = 1; } catch (NumberFormatException e) {}
    }
    int pageSize = 12;
    FieldDao fieldDao = new FieldDao();
    Map<String, Object> venue = fieldDao.getVenueDetail(venueId);
    List<Map<String, Object>> fields = fieldDao.getFieldsByVenueId(venueId, pageNum, pageSize);
    int totalFields = fields.size(); // Placeholder
    int totalPages = 1;
    pageContext.setAttribute("venue", venue);
    pageContext.setAttribute("fields", fields);
    pageContext.setAttribute("currentPage", pageNum);
    pageContext.setAttribute("totalPages", totalPages);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>${venue != null ? venue.venueName : 'Địa điểm'} - Chi tiết</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {font-family: 'Inter', sans-serif; background: #f9fafb; color: #1f2937;}
        .navbar {box-shadow: 0 2px 10px rgba(0,0,0,0.1);}
        .venue-hero {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: white;
            padding: 100px 0 60px;
            position: relative;
            overflow: hidden;
        }
        .venue-hero::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background: url('https://via.placeholder.com/1600x600?text=Anh+Dia+Diem+Lon') center/cover no-repeat;
            opacity: 0.3;
        }
        .venue-hero .container {position: relative; z-index: 1;}
        .field-card {
            background: white;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 8px 25px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
        }
        .field-card:hover {
            transform: translateY(-12px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
        }
        .field-img {
            height: 200px;
            background: linear-gradient(135deg, #c7d2fe, #e0e7ff);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 4rem;
            color: #6366f1;
        }
        .price-badge {
            background: #10b981;
            color: white;
            padding: 8px 16px;
            border-radius: 50px;
            font-weight: 600;
            font-size: 0.95rem;
        }
        .rating-badge {
            background: #f59e0b;
            color: white;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 0.85rem;
        }
        .description-section {
            background: white;
            border-radius: 16px;
            padding: 32px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.08);
        }
        footer {background: #111827; color: #9ca3af;}
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-success">
        <div class="container">
            <a class="navbar-brand fw-bold fs-4" href="home.jsp">
                <i class="fas fa-futbol me-2"></i>Đặt Sân Thể Thao
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link fw-medium" href="home.jsp">Trang chủ</a></li>
                    <li class="nav-item"><a class="nav-link fw-medium" href="#">Đăng nhập</a></li>
                    <li class="nav-item"><a class="nav-link fw-medium btn btn-outline-light ms-3 px-4" href="#">Đăng ký</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero Venue -->
    <c:choose>
        <c:when test="${venue != null}">
            <section class="venue-hero text-center">
                <div class="container">
                    <h1 class="display-3 fw-bold mb-3">${venue.venueName}</h1>
                    <p class="lead fs-3 mb-2">
                        <i class="fas fa-map-marker-alt me-2"></i>
                        ${venue.addressDetail}, ${venue.districtName}, ${venue.provinceName}
                    </p>
                    <p class="fs-4">
                        <i class="fas fa-clock me-2"></i>
                        Giờ mở cửa: <fmt:formatDate value="${venue.openTime}" pattern="HH:mm"/> - 
                        <fmt:formatDate value="${venue.closeTime}" pattern="HH:mm"/>
                    </p>
                </div>
            </section>

            <div class="container my-5">
                <!-- Mô tả venue -->
                <c:if test="${not empty venue.description}">
                    <div class="description-section mb-5">
                        <h3 class="mb-4">Giới thiệu</h3>
                        <p class="lead fs-5">${venue.description}</p>
                    </div>
                </c:if>

                <!-- Danh sách sân -->
                <h3 class="mb-4 text-center">Danh sách sân (${fields.size()})</h3>

                <c:choose>
                    <c:when test="${empty fields}">
                        <div class="text-center py-5">
                            <i class="fas fa-futbol fa-4x text-muted mb-3"></i>
                            <h4 class="text-muted">Hiện chưa có sân nào tại địa điểm này</h4>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="row row-cols-1 row-cols-md-3 g-5">
                            <c:forEach items="${fields}" var="field">
                                <div class="col">
                                    <div class="field-card h-100 d-flex flex-column">
                                        <div class="field-img">
                                            <i class="fas fa-futbol"></i>
                                        </div>
                                        <div class="card-body d-flex flex-column flex-grow-1">
                                            <h5 class="card-title fw-bold fs-4">${field.fieldName}</h5>
                                            <p class="text-muted mb-3">
                                                <i class="fas fa-trophy text-warning me-2"></i>${field.sportName}
                                            </p>

                                            <c:if test="${field.minPrice != null && field.maxPrice != null}">
                                                <div class="price-badge mb-3">
                                                    <fmt:formatNumber value="${field.minPrice}" type="currency" currencySymbol="₫"/> 
                                                    - <fmt:formatNumber value="${field.maxPrice}" type="currency" currencySymbol="₫"/>
                                                </div>
                                            </c:if>

                                            <div class="mt-auto d-flex justify-content-between align-items-end">
                                                <div>
                                                    <c:choose>
                                                        <c:when test="${field.avgRating != null}">
                                                            <span class="rating-badge me-2">
                                                                <i class="fas fa-star"></i> ${field.avgRating}
                                                            </span>
                                                            <small class="text-muted">(${field.reviewCount} đánh giá)</small>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <small class="text-muted">Chưa có đánh giá</small>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <a href="FieldDetail.jsp?fieldId=${field.fieldId}" class="btn btn-success btn-lg px-4">
                                                    Đặt sân ngay
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <!-- Pagination -->
                        <c:if test="${totalPages > 1}">
                            <nav class="mt-5 d-flex justify-content-center">
                                <ul class="pagination">
                                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                        <a class="page-link" href="VenueDetail.jsp?venueId=${venue.venueId}&page=${currentPage - 1}">‹</a>
                                    </li>
                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                                            <a class="page-link" href="VenueDetail.jsp?venueId=${venue.venueId}&page=${i}">${i}</a>
                                        </li>
                                    </c:forEach>
                                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                        <a class="page-link" href="VenueDetail.jsp?venueId=${venue.venueId}&page=${currentPage + 1}">›</a>
                                    </li>
                                </ul>
                            </nav>
                        </c:if>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:when>
        <c:otherwise>
            <div class="container my-5 text-center py-5">
                <i class="fas fa-exclamation-triangle fa-4x text-danger mb-3"></i>
                <h3 class="text-danger">Không tìm thấy địa điểm</h3>
                <a href="home.jsp" class="btn btn-success btn-lg mt-3">Quay về trang chủ</a>
            </div>
        </c:otherwise>
    </c:choose>

    <!-- Footer -->
    <footer class="py-5">
        <div class="container text-center">
            <p class="mb-0">&copy; 2026 Đặt Sân Thể Thao. All rights reserved.</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
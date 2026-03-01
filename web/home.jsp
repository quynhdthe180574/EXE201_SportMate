<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="dao.FieldDao" %>
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

    List<Map<String, Object>> venues = fieldDao.getAllVenues(
            keyword.isEmpty() ? null : keyword,
            provinceId, districtId,
            minPrice, maxPrice,
            pageNum, pageSize, sortBy, order);

    int totalVenues = fieldDao.getTotalVenues(
            keyword.isEmpty() ? null : keyword,
            provinceId, districtId,
            minPrice, maxPrice);

    int totalPages = (int) Math.ceil((double) totalVenues / pageSize);
    if (totalPages < 1) totalPages = 1;

    // Dropdown data
    List<Map<String, Object>> provinces = fieldDao.getProvinces();
    List<Map<String, Object>> districts = fieldDao.getDistricts(provinceId);

    // Set attributes cho JSTL
    pageContext.setAttribute("venues", venues);
    pageContext.setAttribute("provinces", provinces);
    pageContext.setAttribute("districts", districts);
    pageContext.setAttribute("currentPage", pageNum);
    pageContext.setAttribute("totalPages", totalPages);
    pageContext.setAttribute("keyword", keyword);
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <title>Đặt Sân Thể Thao - Trang Chủ</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <style>
            body {
                font-family: 'Inter', sans-serif;
                background: #f9fafb;
                color: #1f2937;
            }
            .navbar {
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            .hero-section {
                background: linear-gradient(135deg, #10b981 0%, #059669 100%);
                color: white;
                padding: 80px 0;
                text-align: center;
            }
            .hero-section h1 {
                font-size: 3rem;
                font-weight: 700;
            }
            .hero-section p {
                font-size: 1.25rem;
                opacity: 0.9;
            }
            .filter-card {
                background: white;
                border-radius: 16px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.08);
                padding: 24px;
            }
            .venue-card {
                background: white;
                border-radius: 16px;
                overflow: hidden;
                box-shadow: 0 8px 25px rgba(0,0,0,0.08);
                transition: all 0.3s ease;
            }
            .venue-card:hover {
                transform: translateY(-12px);
                box-shadow: 0 20px 40px rgba(0,0,0,0.15);
            }
            .venue-img {
                height: 220px;
                background: linear-gradient(135deg, #e0e7ff, #c7d2fe);
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
            .sort-buttons .btn {
                border-radius: 50px;
                padding: 8px 20px;
                font-weight: 500;
            }
            .pagination .page-link {
                border-radius: 50%;
                width: 40px;
                height: 40px;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 5px;
            }
            footer {
                background: #111827;
                color: #9ca3af;
            }
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
                    <ul class="navbar-nav ms-auto align-items-center">

                        <c:choose>

                            <%-- Nếu chưa đăng nhập --%>
                            <c:when test="${sessionScope.user == null}">
                                <li class="nav-item">
                                    <a class="nav-link fw-medium" href="login.jsp">Đăng nhập</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link fw-medium btn btn-outline-light ms-3 px-4" href="register.jsp">
                                        Đăng ký
                                    </a>
                                </li>
                            </c:when>

                            <%-- Nếu đã đăng nhập --%>
                            <c:otherwise>

                                <li class="nav-item me-3 text-white fw-semibold">

                                    <c:choose>

                                        <c:when test="${sessionScope.user.roleId == 3}">
                                            👋 Chào Người chơi
                                        </c:when>

                                        <c:when test="${sessionScope.user.roleId == 2}">
                                            🏟 Chào Chủ sân
                                        </c:when>

                                        <c:when test="${sessionScope.user.roleId == 1}">
                                            👑 Chào Admin
                                        </c:when>

                                    </c:choose>

                                </li>

                                <%-- Nút riêng cho Player --%>
                                <c:if test="${sessionScope.user.roleId == 3}">
                                    <li class="nav-item">
                                        <a href="owner-request" class="btn btn-warning me-3">
                                            Trở thành Chủ sân
                                        </a>
                                    </li>
                                </c:if>

                                <li class="nav-item">
                                    <a class="nav-link fw-medium btn btn-outline-light px-4 me-3" href="BookingHistory">
                                        Trang cá nhân
                                    </a>
                                </li>

                                <li class="nav-item">
                                    <a class="nav-link fw-medium btn btn-danger px-4" href="logout">
                                        Đăng xuất
                                    </a>
                                </li>

                            </c:otherwise>

                        </c:choose>

                    </ul>
                </div>
            </div>
        </nav>

        <!-- Hero Section -->
        <section class="hero-section">
            <div class="container">
                <h1>Tìm & Đặt Sân Thể Thao Dễ Dàng</h1>
                <p>Khám phá hàng trăm địa điểm chất lượng cao với giá tốt nhất</p>
            </div>
        </section>

        <div class="container my-5">
            <!-- Filter Card -->
            <div class="filter-card mb-5">
                <form method="get" action="home.jsp">
                    <div class="row g-3 align-items-end">
                        <div class="col-lg-4">
                            <label class="form-label fw-semibold">Tìm kiếm</label>
                            <input type="text" name="keyword" class="form-control form-control-lg" placeholder="Tên địa điểm, địa chỉ..." value="${keyword}">
                        </div>
                        <div class="col-lg-2">
                            <label class="form-label fw-semibold">Tỉnh/Thành</label>
                            <select name="provinceId" class="form-select form-select-lg" onchange="this.form.submit()">
                                <option value="">Tất cả</option>
                                <c:forEach items="${provinces}" var="p">
                                    <option value="${p.provinceId}" ${p.provinceId == param.provinceId ? 'selected' : ''}>${p.provinceName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-lg-2">
                            <label class="form-label fw-semibold">Quận/Huyện</label>
                            <select name="districtId" class="form-select form-select-lg">
                                <option value="">Tất cả</option>
                                <c:forEach items="${districts}" var="d">
                                    <option value="${d.districtId}" ${d.districtId == param.districtId ? 'selected' : ''}>${d.districtName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-lg-1">
                            <label class="form-label fw-semibold">Giá từ</label>
                            <input type="number" name="minPrice" class="form-control form-control-lg" placeholder="₫" value="${param.minPrice}">
                        </div>
                        <div class="col-lg-1">
                            <label class="form-label fw-semibold">Giá đến</label>
                            <input type="number" name="maxPrice" class="form-control form-control-lg" placeholder="₫" value="${param.maxPrice}">
                        </div>
                        <div class="col-lg-2">
                            <button type="submit" class="btn btn-success btn-lg w-100">
                                <i class="fas fa-search me-2"></i>Tìm kiếm
                            </button>
                        </div>
                    </div>
                    <input type="hidden" name="page" value="1">
                    <input type="hidden" name="sortBy" value="${param.sortBy != null ? param.sortBy : 'avg_rating'}">
                    <input type="hidden" name="order" value="${param.order != null ? param.order : 'DESC'}">
                </form>
            </div>

            <!-- Sort Buttons -->
            <div class="d-flex justify-content-end mb-4 sort-buttons gap-3">
                <a href="home.jsp?sortBy=avg_rating&order=DESC&page=1&keyword=${keyword}&provinceId=${param.provinceId}&districtId=${param.districtId}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}"
                   class="btn ${'avg_rating'.equals(param.sortBy) && 'DESC'.equals(param.order) ? 'btn-success' : 'btn-outline-success'}">
                    <i class="fas fa-star me-1"></i> Đánh giá cao nhất
                </a>
                <a href="home.jsp?sortBy=min_price&order=ASC&page=1&keyword=${keyword}&provinceId=${param.provinceId}&districtId=${param.districtId}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}"
                   class="btn ${'min_price'.equals(param.sortBy) && 'ASC'.equals(param.order) ? 'btn-success' : 'btn-outline-success'}">
                    <i class="fas fa-tag me-1"></i> Giá thấp nhất
                </a>
            </div>

            <!-- Danh sách Venue -->
            <c:choose>
                <c:when test="${empty venues}">
                    <div class="text-center py-5">
                        <i class="fas fa-search fa-4x text-muted mb-3"></i>
                        <h4 class="text-muted">Không tìm thấy địa điểm nào phù hợp</h4>
                        <p class="text-muted">Thử thay đổi bộ lọc hoặc tìm kiếm từ khóa khác</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="row row-cols-1 row-cols-md-3 g-5">
                        <c:forEach items="${venues}" var="venue">
                            <div class="col">
                                <div class="venue-card h-100 d-flex flex-column">
                                    <div class="venue-img">
                                        <i class="fas fa-stadium"></i>
                                    </div>
                                    <div class="card-body d-flex flex-column flex-grow-1">
                                        <h5 class="card-title fw-bold fs-4">${venue.venueName}</h5>
                                        <p class="text-muted mb-2">
                                            <i class="fas fa-map-marker-alt text-success me-2"></i>
                                            ${venue.districtName}, ${venue.provinceName}
                                        </p>
                                        <p class="mb-3">
                                            <i class="fas fa-clock text-primary me-2"></i>
                                            <fmt:formatDate value="${venue.openTime}" pattern="HH:mm"/> - 
                                            <fmt:formatDate value="${venue.closeTime}" pattern="HH:mm"/>
                                        </p>

                                        <c:if test="${venue.minPrice != null && venue.maxPrice != null}">
                                            <div class="price-badge mb-3">
                                                <fmt:formatNumber value="${venue.minPrice}" type="currency" currencySymbol="₫"/> 
                                                - <fmt:formatNumber value="${venue.maxPrice}" type="currency" currencySymbol="₫"/>
                                            </div>
                                        </c:if>

                                        <div class="mt-auto d-flex justify-content-between align-items-end">
                                            <div>
                                                <c:choose>
                                                    <c:when test="${venue.avgRating != null}">
                                                        <span class="rating-badge me-2">
                                                            <i class="fas fa-star"></i> ${venue.avgRating}
                                                        </span>
                                                        <small class="text-muted">(${venue.reviewCount} đánh giá)</small>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <small class="text-muted">Chưa có đánh giá</small>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <a href="venuedetail.jsp?venueId=${venue.venueId}" class="btn btn-success btn-lg px-4">
                                                Xem chi tiết
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
                                    <a class="page-link" href="home.jsp?page=${currentPage - 1}&sortBy=${param.sortBy}&order=${param.order}&keyword=${keyword}&provinceId=${param.provinceId}&districtId=${param.districtId}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}">‹</a>
                                </li>
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                                        <a class="page-link" href="home.jsp?page=${i}&sortBy=${param.sortBy}&order=${param.order}&keyword=${keyword}&provinceId=${param.provinceId}&districtId=${param.districtId}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}">${i}</a>
                                    </li>
                                </c:forEach>
                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="home.jsp?page=${currentPage + 1}&sortBy=${param.sortBy}&order=${param.order}&keyword=${keyword}&provinceId=${param.provinceId}&districtId=${param.districtId}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}">›</a>
                                </li>
                            </ul>
                        </nav>
                    </c:if>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Footer -->
        <footer class="py-5">
            <div class="container text-center">
                <p class="mb-0">&copy; 2026 Đặt Sân Thể Thao. All rights reserved.</p>
            </div>
        </footer>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
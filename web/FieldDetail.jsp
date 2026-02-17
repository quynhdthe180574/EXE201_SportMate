<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="dao.FieldDao" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.util.*" %>
<%
    // Lấy fieldId
    int fieldId = 0;
    String fieldIdParam = request.getParameter("fieldId");
    if (fieldIdParam == null || fieldIdParam.isEmpty()) {
        response.sendRedirect("home.jsp");
        return;
    }
    try {
        fieldId = Integer.parseInt(fieldIdParam);
    } catch (NumberFormatException e) {
        response.sendRedirect("home.jsp");
        return;
    }

    // Lấy ngày đặt (mặc định hôm nay)
    String dateParam = request.getParameter("bookingDate");
    Date bookingDate = null;
    if (dateParam != null && !dateParam.isEmpty()) {
        try {
            bookingDate = Date.valueOf(dateParam);
        } catch (IllegalArgumentException e) {
            bookingDate = new Date(System.currentTimeMillis());
        }
    } else {
        bookingDate = new Date(System.currentTimeMillis());
    }

    FieldDao fieldDao = new FieldDao();

    Map<String, Object> field = fieldDao.getFieldDetail(fieldId);
    if (field == null) {
        response.sendRedirect("home.jsp");
        return;
    }

    List<Map<String, Object>> prices = fieldDao.getFieldPrices(fieldId);
    List<Map<String, Object>> availableSlots = fieldDao.getAvailableSlots(fieldId, bookingDate);

    pageContext.setAttribute("field", field);
    pageContext.setAttribute("prices", prices);
    pageContext.setAttribute("availableSlots", availableSlots);
    pageContext.setAttribute("bookingDate", bookingDate.toString());
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>${field.fieldName} - Chi tiết & Đặt sân</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {font-family: 'Inter', sans-serif; background: #f9fafb; color: #1f2937;}
        .navbar {box-shadow: 0 2px 10px rgba(0,0,0,0.1);}
        .field-hero {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: white;
            padding: 120px 0 80px;
            position: relative;
            overflow: hidden;
        }
        .field-hero::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background: url('https://via.placeholder.com/1600x800?text=Anh+San+Lon') center/cover no-repeat;
            opacity: 0.3;
        }
        .field-hero .container {position: relative; z-index: 1;}
        .info-card {background: white; border-radius: 16px; box-shadow: 0 8px 25px rgba(0,0,0,0.08); padding: 32px;}
        .price-table {
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 8px 25px rgba(0,0,0,0.08);
        }
        .price-table th {background: #10b981; color: white;}
        .price-table td {font-weight: 500;}
        .booking-sidebar {
            background: white;
            border-radius: 16px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            padding: 24px;
            position: sticky;
            top: 20px;
        }
        .slot-item {
            background: #f0fdf4;
            border: 1px solid #86efac;
            border-radius: 12px;
            padding: 16px;
            margin-bottom: 12px;
            transition: all 0.2s;
        }
        .slot-item:hover {background: #dcfce7;}
        .slot-item input[type="radio"]:checked + div {font-weight: 600;}
        .no-slot {background: #fef3c7; border-left: 5px solid #f59e0b;}
        .rating-badge {
            background: #f59e0b;
            color: white;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.9rem;
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

    <!-- Hero Field -->
    <section class="field-hero text-center">
        <div class="container">
            <h1 class="display-3 fw-bold mb-3">${field.fieldName}</h1>
            <p class="lead fs-3 mb-2">
                <i class="fas fa-map-marker-alt me-2"></i>
                ${field.venueName} - ${field.districtName}, ${field.provinceName}
            </p>
            <p class="fs-4">
                <i class="fas fa-trophy text-warning me-2"></i>Môn thể thao: ${field.sportName}
            </p>
        </div>
    </section>

    <div class="container my-5">
        <div class="row g-5">
            <!-- Nội dung chính bên trái -->
            <div class="col-lg-8">
                <!-- Ảnh sân -->
                <div class="mb-5">
                    <img src="https://via.placeholder.com/1200x600?text=Anh+San+Chinh" class="img-fluid rounded-4 shadow-lg" alt="Ảnh sân chính">
                </div>

                <!-- Thông tin cơ bản -->
                <div class="info-card mb-5">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div>
                            <h4 class="mb-2">
                                <i class="fas fa-clock text-primary me-2"></i>Giờ mở cửa
                            </h4>
                            <p class="fs-5 fw-semibold">
                                <fmt:formatDate value="${field.openTime}" pattern="HH:mm"/> - 
                                <fmt:formatDate value="${field.closeTime}" pattern="HH:mm"/>
                            </p>
                        </div>
                        <div>
                            <c:choose>
                                <c:when test="${field.avgRating != null}">
                                    <span class="rating-badge fs-5">
                                        <i class="fas fa-star me-1"></i> ${field.avgRating}
                                    </span>
                                    <p class="text-muted small mt-1">(${field.reviewCount} đánh giá)</p>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-muted">Chưa có đánh giá</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <!-- Bảng giá khung giờ -->
                <h3 class="mb-4">Bảng giá theo khung giờ</h3>
                <div class="table-responsive mb-5">
                    <table class="table price-table text-center">
                        <thead>
                            <tr>
                                <th>Khung giờ</th>
                                <th>Giá</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${prices}" var="p">
                                <tr>
                                    <td class="fw-semibold">
                                        <fmt:formatDate value="${p.startTime}" pattern="HH:mm"/> - 
                                        <fmt:formatDate value="${p.endTime}" pattern="HH:mm"/>
                                    </td>
                                    <td class="fw-bold text-success fs-5">
                                        <fmt:formatNumber value="${p.price}" type="currency" currencySymbol="₫"/>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Sidebar đặt sân -->
            <div class="col-lg-4">
                <div class="booking-sidebar">
                    <h4 class="mb-4 text-center">Đặt sân nhanh</h4>

                    <form method="get" action="FieldDetail.jsp" class="mb-4">
                        <input type="hidden" name="fieldId" value="${field.fieldId}">
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Chọn ngày đặt</label>
                            <input type="date" name="bookingDate" class="form-control form-control-lg" 
                                   value="${bookingDate}" min="<%= new java.sql.Date(System.currentTimeMillis()).toString() %>" required>
                        </div>
                        <button type="submit" class="btn btn-outline-success btn-lg w-100">
                            <i class="fas fa-calendar-check me-2"></i>Xem khung giờ trống
                        </button>
                    </form>

                    <hr class="my-4">

                    <h5 class="mb-3">Khung giờ trống ngày <strong class="text-success">${bookingDate}</strong></h5>

                    <c:choose>
                        <c:when test="${not empty availableSlots}">
                            <form action="BookingServlet" method="post">
                                <input type="hidden" name="fieldId" value="${field.fieldId}">
                                <input type="hidden" name="bookingDate" value="${bookingDate}">
                                <div class="d-grid gap-3">
                                    <c:forEach items="${availableSlots}" var="slot">
                                        <label class="slot-item d-block cursor-pointer">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="radio" name="slotId" value="${slot.slotId}" id="slot${slot.slotId}" required>
                                                    <label class="form-check-label fw-semibold" for="slot${slot.slotId}">
                                                        <fmt:formatDate value="${slot.startTime}" pattern="HH:mm"/> - 
                                                        <fmt:formatDate value="${slot.endTime}" pattern="HH:mm"/>
                                                    </label>
                                                </div>
                                                <span class="text-success fw-bold">
                                                    <fmt:formatNumber value="${slot.price}" type="currency" currencySymbol="₫"/>
                                                </span>
                                            </div>
                                        </label>
                                    </c:forEach>
                                </div>
                                <button type="submit" class="btn btn-success btn-lg w-100 mt-4">
                                    <i class="fas fa-check-circle me-2"></i>Đặt sân ngay
                                </button>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <div class="alert no-slot text-center py-4">
                                <i class="fas fa-calendar-times fa-3x text-warning mb-3"></i>
                                <p class="fw-bold">Không còn khung giờ trống</p>
                                <small>Vui lòng chọn ngày khác</small>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
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
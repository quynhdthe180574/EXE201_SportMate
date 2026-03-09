<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Chủ Sân - SportMate</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body { background: linear-gradient(135deg, #0f0c29, #302b63, #24243e); min-height: 100vh; color: #e0e0e0; }
        .stat-card { border: none; border-radius: 16px; transition: transform 0.3s; }
        .stat-card:hover { transform: translateY(-5px); }
        .stat-card .card-body { padding: 1.5rem; }
        .stat-card .card-title { font-size: 0.9rem; text-transform: uppercase; letter-spacing: 1px; opacity: 0.85; }
        .stat-card .display-5 { font-weight: 700; }
        .stat-card .icon-circle { width: 50px; height: 50px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.4rem; }
        .card-gradient-1 { background: linear-gradient(135deg, #667eea, #764ba2); }
        .card-gradient-2 { background: linear-gradient(135deg, #f093fb, #f5576c); }
        .card-gradient-3 { background: linear-gradient(135deg, #4facfe, #00f2fe); }
        .card-gradient-4 { background: linear-gradient(135deg, #43e97b, #38f9d7); }
        .chart-container { background: rgba(255,255,255,0.05); border-radius: 16px; padding: 1.5rem; backdrop-filter: blur(10px); }
        .table-dark-custom { background: rgba(255,255,255,0.05); backdrop-filter: blur(10px); border-radius: 12px; overflow: hidden; }
        .table-dark-custom th { background: rgba(255,255,255,0.1); border: none; color: #a0a0ff; }
        .table-dark-custom td { border-color: rgba(255,255,255,0.05); vertical-align: middle; }
        .btn-glow { box-shadow: 0 0 15px rgba(102, 126, 234, 0.4); }
        .page-header { border-bottom: 1px solid rgba(255,255,255,0.1); padding-bottom: 1rem; margin-bottom: 2rem; }
    </style>
</head>
<body>
    <jsp:include page="header.jsp"/>
    <div class="container py-4">
        <div class="page-header d-flex justify-content-between align-items-center">
            <div>
                <h2 class="text-white mb-1"><i class="bi bi-speedometer2 me-2"></i>Dashboard Chủ Sân</h2>
                <p class="text-white-50 mb-0">Tổng quan hoạt động kinh doanh của bạn</p>
            </div>
            <a href="${pageContext.request.contextPath}/owner/add-venue" class="btn btn-light btn-glow">
                <i class="bi bi-plus-circle me-1"></i> Thêm địa điểm mới
            </a>
        </div>

        <!-- Thống kê -->
        <div class="row g-4 mb-4">
            <div class="col-xl-3 col-md-6">
                <div class="card stat-card card-gradient-1 text-white">
                    <div class="card-body d-flex align-items-center justify-content-between">
                        <div>
                            <h6 class="card-title">Tổng Địa Điểm</h6>
                            <p class="display-5 mb-0">${totalVenues}</p>
                        </div>
                        <div class="icon-circle bg-white bg-opacity-25"><i class="bi bi-geo-alt-fill"></i></div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="card stat-card card-gradient-2 text-white">
                    <div class="card-body d-flex align-items-center justify-content-between">
                        <div>
                            <h6 class="card-title">Tổng Số Sân</h6>
                            <p class="display-5 mb-0">${totalFields}</p>
                        </div>
                        <div class="icon-circle bg-white bg-opacity-25"><i class="bi bi-grid-3x3-gap-fill"></i></div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="card stat-card card-gradient-3 text-white">
                    <div class="card-body d-flex align-items-center justify-content-between">
                        <div>
                            <h6 class="card-title">Tổng Booking</h6>
                            <p class="display-5 mb-0">${totalBookings}</p>
                        </div>
                        <div class="icon-circle bg-white bg-opacity-25"><i class="bi bi-calendar-check-fill"></i></div>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6">
                <div class="card stat-card card-gradient-4 text-white">
                    <div class="card-body d-flex align-items-center justify-content-between">
                        <div>
                            <h6 class="card-title">Doanh Thu</h6>
                            <p class="display-5 mb-0" style="font-size:1.6rem">
                                <fmt:formatNumber value="${totalRevenue}" type="currency" currencyCode="VND"/>
                            </p>
                        </div>
                        <div class="icon-circle bg-white bg-opacity-25"><i class="bi bi-cash-stack"></i></div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Biểu đồ doanh thu -->
        <div class="chart-container mb-4">
            <h5 class="text-white mb-3"><i class="bi bi-graph-up me-2"></i>Doanh thu 30 ngày gần nhất</h5>
            <canvas id="revenueChart" height="80"></canvas>
        </div>

        <!-- Danh sách Venue -->
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h4 class="text-white mb-0"><i class="bi bi-building me-2"></i>Địa điểm của bạn</h4>
        </div>

        <c:if test="${not empty param.success}">
            <div class="alert alert-success alert-dismissible fade show">
                <i class="bi bi-check-circle me-1"></i>
                <c:choose>
                    <c:when test="${param.success == 'add'}">Thêm địa điểm thành công!</c:when>
                    <c:when test="${param.success == 'update'}">Cập nhật thành công!</c:when>
                    <c:otherwise>Thao tác thành công!</c:otherwise>
                </c:choose>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="table-dark-custom">
            <table class="table table-dark table-hover mb-0">
                <thead>
                    <tr>
                        <th>Tên địa điểm</th>
                        <th>Địa chỉ</th>
                        <th>Giờ hoạt động</th>
                        <th>Trạng thái</th>
                        <th class="text-center">Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="venue" items="${venues}">
                        <tr>
                            <td><strong>${venue.venueName}</strong></td>
                            <td>${venue.addressDetail}</td>
                            <td>${venue.openTime} - ${venue.closeTime}</td>
                            <td>
                                <span class="badge ${venue.status == 'Hoạt động' ? 'bg-success' : 'bg-danger'}">
                                    ${venue.status}
                                </span>
                            </td>
                            <td class="text-center">
                                <a href="${pageContext.request.contextPath}/owner/fields?venueId=${venue.venueId}"
                                   class="btn btn-sm btn-outline-info me-1" title="Quản lý sân">
                                    <i class="bi bi-grid-3x3-gap"></i> Sân
                                </a>
                                <a href="${pageContext.request.contextPath}/owner/view-venue?id=${venue.venueId}"
                                   class="btn btn-sm btn-outline-light me-1" title="Xem chi tiết">
                                    <i class="bi bi-eye"></i>
                                </a>
                                <form action="${pageContext.request.contextPath}/owner/edit-venue" method="get" style="display:inline;">
                                    <input type="hidden" name="id" value="${venue.venueId}">
                                    <button type="submit" class="btn btn-sm btn-outline-warning me-1" title="Sửa">
                                        <i class="bi bi-pencil"></i>
                                    </button>
                                </form>
                                <c:if test="${venue.status != 'Ẩn'}">
                                    <form action="${pageContext.request.contextPath}/owner/hide-venue" method="post" style="display:inline;">
                                        <input type="hidden" name="venueId" value="${venue.venueId}">
                                        <button type="submit" class="btn btn-sm btn-outline-danger" title="Ẩn"
                                                onclick="return confirm('Ẩn địa điểm này?')">
                                            <i class="bi bi-eye-slash"></i>
                                        </button>
                                    </form>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty venues}">
                        <tr><td colspan="5" class="text-center text-white-50 py-4">Chưa có địa điểm nào. Hãy thêm địa điểm mới!</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger mt-3">${error}</div>
        </c:if>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const ctx = document.getElementById('revenueChart').getContext('2d');
        const labels = ${empty revenueLabels ? '[]' : revenueLabels};
        const data = ${empty revenueData ? '[]' : revenueData};

        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Doanh thu (VNĐ)',
                    data: data,
                    backgroundColor: 'rgba(102, 126, 234, 0.6)',
                    borderColor: 'rgba(102, 126, 234, 1)',
                    borderWidth: 1,
                    borderRadius: 6
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: { labels: { color: '#ccc' } }
                },
                scales: {
                    x: { ticks: { color: '#aaa' }, grid: { color: 'rgba(255,255,255,0.05)' } },
                    y: { ticks: { color: '#aaa', callback: v => v.toLocaleString('vi-VN') + ' đ' }, grid: { color: 'rgba(255,255,255,0.05)' } }
                }
            }
        });
    </script>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

            <jsp:include page="header.jsp" />

            <style>
                .page-title {
                    text-align: center;
                    color: var(--purple-pastel);
                    margin-bottom: 25px;
                    font-size: 2rem;
                }

                /* ===== Stats Grid ===== */
                .stats-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                    gap: 18px;
                    margin-bottom: 30px;
                }

                .stat-card {
                    background: rgba(255, 255, 255, 0.92);
                    border-radius: 16px;
                    padding: 24px 20px;
                    text-align: center;
                    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.06);
                    transition: transform 0.2s;
                }

                .stat-card:hover {
                    transform: translateY(-4px);
                }

                .stat-icon {
                    font-size: 2rem;
                    margin-bottom: 8px;
                }

                .stat-number {
                    font-size: 2.4rem;
                    font-weight: 700;
                    color: var(--purple-pastel);
                }

                .stat-label {
                    color: #777;
                    font-size: 0.9rem;
                    margin-top: 5px;
                }

                /* ===== Recent Bookings Table ===== */
                .section-title {
                    font-size: 1.3rem;
                    color: #555;
                    margin-bottom: 15px;
                    font-weight: 600;
                }

                .data-table {
                    width: 100%;
                    border-collapse: collapse;
                    background: white;
                    border-radius: 16px;
                    overflow: hidden;
                    box-shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
                }

                .data-table thead th {
                    background: var(--purple-pastel);
                    color: white;
                    padding: 14px 12px;
                    font-size: 0.88rem;
                    text-align: left;
                    white-space: nowrap;
                }

                .data-table tbody td {
                    padding: 12px;
                    border-bottom: 1px solid #f0f0f0;
                    font-size: 0.88rem;
                    vertical-align: middle;
                }

                .data-table tbody tr:hover {
                    background: var(--primary-hover);
                }

                .data-table tbody tr:last-child td {
                    border-bottom: none;
                }

                /* ===== Status Badge ===== */
                .status-badge {
                    display: inline-block;
                    padding: 4px 12px;
                    border-radius: 15px;
                    font-size: 0.8rem;
                    font-weight: 600;
                }

                .status-confirmed {
                    background: #d4edda;
                    color: #155724;
                }

                .status-pending {
                    background: #fff3cd;
                    color: #856404;
                }

                .status-cancelled {
                    background: #f8d7da;
                    color: #721c24;
                }

                .no-data {
                    text-align: center;
                    padding: 40px;
                    color: #999;
                    font-style: italic;
                }

                @media (max-width: 768px) {
                    .stats-grid {
                        grid-template-columns: repeat(2, 1fr);
                    }

                    .data-table {
                        display: block;
                        overflow-x: auto;
                    }
                }
            </style>

            <h1 class="page-title">📊 Dashboard Tổng Quan</h1>

            <!-- Stats Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon">👥</div>
                    <div class="stat-number">${totalUsers}</div>
                    <div class="stat-label">Tổng Users</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">🏟️</div>
                    <div class="stat-number">${totalVenues}</div>
                    <div class="stat-label">Tổng Sân</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">📋</div>
                    <div class="stat-number">${totalBookings}</div>
                    <div class="stat-label">Tổng Booking</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">💰</div>
                    <div class="stat-number">
                        <fmt:formatNumber value="${totalRevenue}" type="number" groupingUsed="true"
                            maxFractionDigits="0" />đ
                    </div>
                    <div class="stat-label">Doanh thu</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">📝</div>
                    <div class="stat-number" style="color: #e67e22;">${pendingRequests}</div>
                    <div class="stat-label">Owner Requests chờ duyệt</div>
                </div>
            </div>

            <!-- Recent Bookings -->
            <h2 class="section-title">📅 Booking Gần Đây</h2>

            <c:if test="${not empty recentBookings}">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Người đặt</th>
                            <th>Sân</th>
                            <th>Ngày</th>
                            <th>Giờ</th>
                            <th>Giá</th>
                            <th>Trạng thái</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${recentBookings}" var="b">
                            <tr>
                                <td><strong>#${b.bookingId}</strong></td>
                                <td>${b.fullname}</td>
                                <td>${b.fieldName}</td>
                                <td>${b.bookingDate}</td>
                                <td>${b.startTime} - ${b.endTime}</td>
                                <td>
                                    <fmt:formatNumber value="${b.totalPrice}" type="number" groupingUsed="true"
                                        maxFractionDigits="0" />đ
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${b.bookingStatus == 'CONFIRMED'}">
                                            <span class="status-badge status-confirmed">✅ Confirmed</span>
                                        </c:when>
                                        <c:when test="${b.bookingStatus == 'CANCELLED'}">
                                            <span class="status-badge status-cancelled">❌ Cancelled</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge status-pending">⏳ ${b.bookingStatus}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>

            <c:if test="${empty recentBookings}">
                <div class="no-data">Chưa có booking nào</div>
            </c:if>

            <jsp:include page="footer.jsp" />
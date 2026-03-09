<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

            <jsp:include page="header.jsp" />

            <style>
                .page-title {
                    text-align: center;
                    color: var(--purple-pastel);
                    margin-bottom: 10px;
                    font-size: 2rem;
                }

                /* Stats */
                .stats-row {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
                    gap: 15px;
                    margin-bottom: 25px;
                }

                .stat-card {
                    background: rgba(255, 255, 255, 0.9);
                    border-radius: 14px;
                    padding: 20px;
                    text-align: center;
                    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.06);
                }

                .stat-card .stat-number {
                    font-size: 2.2rem;
                    font-weight: 700;
                    color: var(--purple-pastel);
                }

                .stat-card .stat-label {
                    color: #777;
                    font-size: 0.9rem;
                    margin-top: 5px;
                }

                /* Table */
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

                /* Status */
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
                    padding: 60px;
                    color: #999;
                    font-size: 1.2rem;
                    font-style: italic;
                }

                @media (max-width: 900px) {
                    .data-table {
                        display: block;
                        overflow-x: auto;
                    }
                }
            </style>

            <h1 class="page-title">📋 Quản lý Booking</h1>

            <!-- Stats -->
            <c:set var="confirmedCount" value="0" />
            <c:set var="pendingCount" value="0" />
            <c:set var="cancelledCount" value="0" />
            <c:forEach items="${bookings}" var="b">
                <c:if test="${b.bookingStatus == 'CONFIRMED'}">
                    <c:set var="confirmedCount" value="${confirmedCount + 1}" />
                </c:if>
                <c:if test="${b.bookingStatus == 'PENDING' || b.bookingStatus == 'PENDING_PAYMENT'}">
                    <c:set var="pendingCount" value="${pendingCount + 1}" />
                </c:if>
                <c:if test="${b.bookingStatus == 'CANCELLED'}">
                    <c:set var="cancelledCount" value="${cancelledCount + 1}" />
                </c:if>
            </c:forEach>

            <div class="stats-row">
                <div class="stat-card">
                    <div class="stat-number">${bookings.size()}</div>
                    <div class="stat-label">Tổng Booking</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number" style="color: var(--green-pastel);">${confirmedCount}</div>
                    <div class="stat-label">Confirmed</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number" style="color: #e67e22;">${pendingCount}</div>
                    <div class="stat-label">Pending</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number" style="color: #721c24;">${cancelledCount}</div>
                    <div class="stat-label">Cancelled</div>
                </div>
            </div>

            <!-- Table -->
            <c:if test="${not empty bookings}">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Người đặt</th>
                            <th>Venue</th>
                            <th>Sân</th>
                            <th>Ngày</th>
                            <th>Giờ</th>
                            <th>Giá</th>
                            <th>Trạng thái</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${bookings}" var="b">
                            <tr>
                                <td><strong>#${b.bookingId}</strong></td>
                                <td>${b.fullname}</td>
                                <td>${b.venueName}</td>
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

            <c:if test="${empty bookings}">
                <div class="no-data">Chưa có booking nào</div>
            </c:if>

            <jsp:include page="footer.jsp" />
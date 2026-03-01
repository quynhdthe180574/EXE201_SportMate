<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

            <jsp:include page="header.jsp" />

            <style>
                .page-title {
                    text-align: center;
                    color: var(--blue-pastel);
                    margin-bottom: 10px;
                    font-size: 2rem;
                }

                /* ===== Filter Bar ===== */
                .filter-bar {
                    display: flex;
                    gap: 15px;
                    flex-wrap: wrap;
                    align-items: center;
                    background: rgba(255, 255, 255, 0.9);
                    padding: 20px 25px;
                    border-radius: 16px;
                    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.06);
                    margin-bottom: 25px;
                }

                .filter-bar label {
                    font-weight: 600;
                    color: #555;
                    font-size: 0.95rem;
                }

                .filter-bar select,
                .filter-bar input[type="date"] {
                    padding: 10px 16px;
                    border: 2px solid #e0e0e0;
                    border-radius: 10px;
                    font-size: 0.95rem;
                    background: white;
                    min-width: 160px;
                    transition: border-color 0.3s;
                }

                .filter-bar select:focus,
                .filter-bar input[type="date"]:focus {
                    border-color: var(--blue-pastel);
                    outline: none;
                }

                .filter-bar button {
                    padding: 10px 24px;
                    background: var(--blue-pastel);
                    color: white;
                    border: none;
                    border-radius: 10px;
                    font-weight: 600;
                    cursor: pointer;
                    transition: background 0.3s, transform 0.2s;
                }

                .filter-bar button:hover {
                    background: #8ab4d8;
                    transform: translateY(-1px);
                }

                .filter-bar .reset-btn {
                    background: #e0e0e0;
                    color: #555;
                }

                .filter-bar .reset-btn:hover {
                    background: #ccc;
                }

                /* ===== Revenue Card ===== */
                .revenue-card {
                    background: rgba(255, 255, 255, 0.9);
                    border-radius: 16px;
                    padding: 25px 35px;
                    text-align: center;
                    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.06);
                    margin-bottom: 25px;
                    display: flex;
                    justify-content: space-around;
                    flex-wrap: wrap;
                    gap: 20px;
                }

                .revenue-item {
                    text-align: center;
                }

                .revenue-item .revenue-number {
                    font-size: 2.2rem;
                    font-weight: 700;
                    color: var(--blue-pastel);
                }

                .revenue-item .revenue-label {
                    color: #777;
                    font-size: 0.9rem;
                    margin-top: 5px;
                }

                /* ===== Table ===== */
                .payment-table {
                    width: 100%;
                    border-collapse: collapse;
                    background: white;
                    border-radius: 16px;
                    overflow: hidden;
                    box-shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
                }

                .payment-table thead th {
                    background: var(--blue-pastel);
                    color: white;
                    padding: 16px 12px;
                    font-size: 0.9rem;
                    text-align: left;
                    white-space: nowrap;
                }

                .payment-table tbody td {
                    padding: 14px 12px;
                    border-bottom: 1px solid #f0f0f0;
                    font-size: 0.9rem;
                    vertical-align: middle;
                }

                .payment-table tbody tr:hover {
                    background: #f8fbff;
                }

                .payment-table tbody tr:last-child td {
                    border-bottom: none;
                }

                /* ===== Method Badge ===== */
                .method-badge {
                    display: inline-block;
                    padding: 4px 12px;
                    border-radius: 15px;
                    font-size: 0.82rem;
                    font-weight: 600;
                    background: #e8f4fd;
                    color: #1976d2;
                }

                /* ===== Status Badges ===== */
                .status-badge {
                    display: inline-block;
                    padding: 4px 12px;
                    border-radius: 15px;
                    font-size: 0.82rem;
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

                /* ===== No Data ===== */
                .no-data {
                    text-align: center;
                    padding: 60px 20px;
                    color: #999;
                    font-size: 1.2rem;
                    font-style: italic;
                }

                .no-data-icon {
                    font-size: 3rem;
                    margin-bottom: 15px;
                    display: block;
                }

                /* ===== Responsive ===== */
                @media (max-width: 900px) {
                    .payment-table {
                        display: block;
                        overflow-x: auto;
                    }

                    .filter-bar {
                        flex-direction: column;
                        align-items: stretch;
                    }
                }
            </style>

            <h1 class="page-title">Lịch sử thanh toán</h1>

            <!-- Filter Bar -->
            <form class="filter-bar" method="get" action="${pageContext.request.contextPath}/owner/payments">
                <label>Sân:</label>
                <select name="venueId">
                    <option value="">-- Tất cả sân --</option>
                    <c:forEach items="${venues}" var="v">
                        <option value="${v.venueId}" ${selectedVenueId==v.venueId ? 'selected' : '' }>
                            ${v.venueName}
                        </option>
                    </c:forEach>
                </select>

                <label>Từ ngày:</label>
                <input type="date" name="fromDate" value="${fromDate}" />

                <label>Đến ngày:</label>
                <input type="date" name="toDate" value="${toDate}" />

                <button type="submit">🔍 Lọc</button>
                <a href="${pageContext.request.contextPath}/owner/payments">
                    <button type="button" class="reset-btn">↺ Xóa bộ lọc</button>
                </a>
            </form>

            <!-- Revenue Summary -->
            <div class="revenue-card">
                <div class="revenue-item">
                    <div class="revenue-number">${payments.size()}</div>
                    <div class="revenue-label">Tổng giao dịch</div>
                </div>
                <div class="revenue-item">
                    <div class="revenue-number">
                        <fmt:formatNumber value="${totalRevenue}" type="number" groupingUsed="true" />₫
                    </div>
                    <div class="revenue-label">Tổng doanh thu</div>
                </div>
            </div>

            <!-- Payment Table -->
            <c:if test="${not empty payments}">
                <table class="payment-table">
                    <thead>
                        <tr>
                            <th>Mã GD</th>
                            <th>Booking</th>
                            <th>Sân</th>
                            <th>Người đặt</th>
                            <th>Ngày đặt</th>
                            <th>Khung giờ</th>
                            <th>Phương thức</th>
                            <th>Số tiền</th>
                            <th>Trạng thái</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${payments}" var="p">
                            <tr>
                                <td><strong>#${p.paymentId}</strong></td>
                                <td>#${p.bookingId}</td>
                                <td>
                                    <div>${p.fieldName}</div>
                                    <div style="font-size:0.8rem; color:#999;">${p.venueName}</div>
                                </td>
                                <td>
                                    <div style="font-weight:600;">${p.fullname}</div>
                                    <div style="font-size:0.82rem; color:#888;">📞 ${p.phone}</div>
                                </td>
                                <td>
                                    <fmt:formatDate value="${p.bookingDate}" pattern="dd/MM/yyyy" />
                                </td>
                                <td>${p.startTime} - ${p.endTime}</td>
                                <td>
                                    <span class="method-badge">${p.paymentMethod}</span>
                                </td>
                                <td>
                                    <strong>
                                        <fmt:formatNumber value="${p.amount}" type="number" groupingUsed="true" />₫
                                    </strong>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${p.bookingStatus == 'Đã xác nhận'}">
                                            <span class="status-badge status-confirmed">${p.bookingStatus}</span>
                                        </c:when>
                                        <c:when test="${p.bookingStatus == 'Chờ thanh toán'}">
                                            <span class="status-badge status-pending">${p.bookingStatus}</span>
                                        </c:when>
                                        <c:when test="${p.bookingStatus == 'Đã hủy'}">
                                            <span class="status-badge status-cancelled">${p.bookingStatus}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge">${p.bookingStatus}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>

            <c:if test="${empty payments}">
                <div class="no-data">
                    <span class="no-data-icon">💳</span>
                    Chưa có giao dịch nào
                    <c:if test="${not empty selectedVenueId || not empty fromDate || not empty toDate}">
                        phù hợp với bộ lọc
                    </c:if>
                </div>
            </c:if>

            <jsp:include page="footer.jsp" />
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

                /* ===== Alert Messages ===== */
                .alert {
                    padding: 14px 24px;
                    border-radius: 12px;
                    margin-bottom: 20px;
                    font-weight: 500;
                    display: flex;
                    align-items: center;
                    gap: 10px;
                }

                .alert-success {
                    background: #d4edda;
                    color: #155724;
                    border: 1px solid #c3e6cb;
                }

                .alert-error {
                    background: #f8d7da;
                    color: #721c24;
                    border: 1px solid #f5c6cb;
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

                .filter-bar select {
                    padding: 10px 16px;
                    border: 2px solid #e0e0e0;
                    border-radius: 10px;
                    font-size: 0.95rem;
                    background: white;
                    min-width: 180px;
                    transition: border-color 0.3s;
                }

                .filter-bar select:focus {
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

                /* ===== Stats Summary ===== */
                .booking-stats {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
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
                    color: var(--blue-pastel);
                }

                .stat-card .stat-label {
                    color: #777;
                    font-size: 0.9rem;
                    margin-top: 5px;
                }

                /* ===== Table ===== */
                .booking-table {
                    width: 100%;
                    border-collapse: collapse;
                    background: white;
                    border-radius: 16px;
                    overflow: hidden;
                    box-shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
                }

                .booking-table thead th {
                    background: var(--blue-pastel);
                    color: white;
                    padding: 16px 12px;
                    font-size: 0.9rem;
                    text-align: left;
                    white-space: nowrap;
                }

                .booking-table tbody td {
                    padding: 14px 12px;
                    border-bottom: 1px solid #f0f0f0;
                    font-size: 0.9rem;
                    vertical-align: middle;
                }

                .booking-table tbody tr:hover {
                    background: #f8fbff;
                }

                .booking-table tbody tr:last-child td {
                    border-bottom: none;
                }

                /* ===== Status Badges ===== */
                .status-badge {
                    display: inline-block;
                    padding: 5px 14px;
                    border-radius: 20px;
                    font-size: 0.82rem;
                    font-weight: 600;
                    white-space: nowrap;
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

                /* ===== Action Buttons ===== */
                .action-btns {
                    display: flex;
                    gap: 6px;
                }

                .action-btns form {
                    display: inline;
                }

                .btn-confirm {
                    padding: 6px 14px;
                    background: var(--green-pastel);
                    color: #2d5a2d;
                    border: none;
                    border-radius: 8px;
                    font-weight: 600;
                    cursor: pointer;
                    font-size: 0.82rem;
                    transition: all 0.2s;
                }

                .btn-confirm:hover {
                    background: #9acb9a;
                    transform: translateY(-1px);
                }

                .btn-cancel {
                    padding: 6px 14px;
                    background: var(--pink-pastel);
                    color: #8b2252;
                    border: none;
                    border-radius: 8px;
                    font-weight: 600;
                    cursor: pointer;
                    font-size: 0.82rem;
                    transition: all 0.2s;
                }

                .btn-cancel:hover {
                    background: #f0a0b0;
                    transform: translateY(-1px);
                }

                /* ===== Customer Info ===== */
                .customer-info {
                    line-height: 1.5;
                }

                .customer-info .name {
                    font-weight: 600;
                    color: #333;
                }

                .customer-info .detail {
                    font-size: 0.82rem;
                    color: #888;
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
                    .booking-table {
                        display: block;
                        overflow-x: auto;
                    }

                    .filter-bar {
                        flex-direction: column;
                        align-items: stretch;
                    }
                }
            </style>

            <h1 class="page-title">Quản lý Booking</h1>

            <!-- Alert Messages -->
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success">
                    ✅ ${sessionScope.successMessage}
                </div>
                <c:remove var="successMessage" scope="session" />
            </c:if>
            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-error">
                    ❌ ${sessionScope.errorMessage}
                </div>
                <c:remove var="errorMessage" scope="session" />
            </c:if>

            <!-- Filter Bar -->
            <form class="filter-bar" method="get" action="${pageContext.request.contextPath}/owner/bookings">
                <label>Sân:</label>
                <select name="venueId">
                    <option value="">-- Tất cả sân --</option>
                    <c:forEach items="${venues}" var="v">
                        <option value="${v.venueId}" ${selectedVenueId==v.venueId ? 'selected' : '' }>
                            ${v.venueName}
                        </option>
                    </c:forEach>
                </select>

                <label>Trạng thái:</label>
                <select name="status">
                    <option value="">-- Tất cả --</option>
                    <option value="Chờ thanh toán" ${selectedStatus=='Chờ thanh toán' ? 'selected' : '' }>Chờ thanh toán
                    </option>
                    <option value="Đã xác nhận" ${selectedStatus=='Đã xác nhận' ? 'selected' : '' }>Đã xác nhận</option>
                    <option value="Đã hủy" ${selectedStatus=='Đã hủy' ? 'selected' : '' }>Đã hủy</option>
                </select>

                <button type="submit">🔍 Lọc</button>
                <a href="${pageContext.request.contextPath}/owner/bookings">
                    <button type="button" class="reset-btn">↺ Xóa bộ lọc</button>
                </a>
            </form>

            <!-- Stats -->
            <div class="booking-stats">
                <div class="stat-card">
                    <div class="stat-number">${bookings.size()}</div>
                    <div class="stat-label">Tổng booking hiển thị</div>
                </div>

                <c:set var="pendingCount" value="0" />
                <c:set var="confirmedCount" value="0" />
                <c:set var="cancelledCount" value="0" />
                <c:forEach items="${bookings}" var="b">
                    <c:if test="${b.bookingStatus == 'Chờ thanh toán'}">
                        <c:set var="pendingCount" value="${pendingCount + 1}" />
                    </c:if>
                    <c:if test="${b.bookingStatus == 'Đã xác nhận'}">
                        <c:set var="confirmedCount" value="${confirmedCount + 1}" />
                    </c:if>
                    <c:if test="${b.bookingStatus == 'Đã hủy'}">
                        <c:set var="cancelledCount" value="${cancelledCount + 1}" />
                    </c:if>
                </c:forEach>

                <div class="stat-card">
                    <div class="stat-number" style="color: #856404;">${pendingCount}</div>
                    <div class="stat-label">Chờ xử lý</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number" style="color: #155724;">${confirmedCount}</div>
                    <div class="stat-label">Đã xác nhận</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number" style="color: #721c24;">${cancelledCount}</div>
                    <div class="stat-label">Đã hủy</div>
                </div>
            </div>

            <!-- Booking Table -->
            <c:if test="${not empty bookings}">
                <table class="booking-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Sân</th>
                            <th>Người đặt</th>
                            <th>Ngày</th>
                            <th>Khung giờ</th>
                            <th>Giá</th>
                            <th>Trạng thái</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${bookings}" var="b">
                            <tr>
                                <td><strong>#${b.bookingId}</strong></td>
                                <td>
                                    <div>${b.fieldName}</div>
                                    <div style="font-size:0.8rem; color:#999;">${b.venueName}</div>
                                </td>
                                <td>
                                    <div class="customer-info">
                                        <div class="name">${b.fullname}</div>
                                        <div class="detail">📧 ${b.email}</div>
                                        <div class="detail">📞 ${b.phone}</div>
                                    </div>
                                </td>
                                <td>
                                    <fmt:formatDate value="${b.bookingDate}" pattern="dd/MM/yyyy" />
                                </td>
                                <td>${b.startTime} - ${b.endTime}</td>
                                <td>
                                    <strong>
                                        <fmt:formatNumber value="${b.totalPrice}" type="number" groupingUsed="true" />₫
                                    </strong>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${b.bookingStatus == 'Đã xác nhận'}">
                                            <span class="status-badge status-confirmed">${b.bookingStatus}</span>
                                        </c:when>
                                        <c:when test="${b.bookingStatus == 'Chờ thanh toán'}">
                                            <span class="status-badge status-pending">${b.bookingStatus}</span>
                                        </c:when>
                                        <c:when test="${b.bookingStatus == 'Đã hủy'}">
                                            <span class="status-badge status-cancelled">${b.bookingStatus}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge">${b.bookingStatus}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="action-btns">
                                        <c:if test="${b.bookingStatus != 'Đã xác nhận' && b.bookingStatus != 'Đã hủy'}">
                                            <form method="post"
                                                action="${pageContext.request.contextPath}/owner/bookings">
                                                <input type="hidden" name="bookingId" value="${b.bookingId}" />
                                                <input type="hidden" name="action" value="confirm" />
                                                <button type="submit" class="btn-confirm"
                                                    onclick="return confirm('Xác nhận booking #${b.bookingId}?')">
                                                    ✓ Xác nhận
                                                </button>
                                            </form>
                                        </c:if>
                                        <c:if test="${b.bookingStatus != 'Đã hủy'}">
                                            <form method="post"
                                                action="${pageContext.request.contextPath}/owner/bookings">
                                                <input type="hidden" name="bookingId" value="${b.bookingId}" />
                                                <input type="hidden" name="action" value="cancel" />
                                                <button type="submit" class="btn-cancel"
                                                    onclick="return confirm('Hủy booking #${b.bookingId}?')">
                                                    ✗ Hủy
                                                </button>
                                            </form>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>

            <c:if test="${empty bookings}">
                <div class="no-data">
                    <span class="no-data-icon">📋</span>
                    Chưa có booking nào
                    <c:if test="${not empty selectedVenueId || not empty selectedStatus}">
                        phù hợp với bộ lọc
                    </c:if>
                </div>
            </c:if>

            <jsp:include page="footer.jsp" />
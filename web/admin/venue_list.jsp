<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

            <jsp:include page="header.jsp" />

            <style>
                .page-title {
                    text-align: center;
                    color: var(--primary);
                    margin-bottom: 10px;
                    font-size: 2rem;
                    font-weight: 800;
                }

                /* Toast */
                .toast-container {
                    position: fixed;
                    top: 80px;
                    right: 20px;
                    z-index: 9999;
                }

                .toast {
                    padding: 14px 24px;
                    border-radius: 12px;
                    font-weight: 500;
                    font-size: 0.9rem;
                    box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
                    animation: slideIn 0.4s ease, fadeOut 0.6s ease 4.4s forwards;
                    max-width: 350px;
                }

                .toast-success {
                    background: #d4edda;
                    color: #155724;
                    border-left: 4px solid #28a745;
                }

                .toast-error {
                    background: #f8d7da;
                    color: #721c24;
                    border-left: 4px solid #dc3545;
                }

                @keyframes slideIn {
                    from {
                        transform: translateX(100%);
                        opacity: 0;
                    }

                    to {
                        transform: translateX(0);
                        opacity: 1;
                    }
                }

                @keyframes fadeOut {
                    from {
                        opacity: 1;
                    }

                    to {
                        opacity: 0;
                        transform: translateX(50px);
                    }
                }

                /* Stats */
                .stats-row {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
                    gap: 15px;
                    margin-bottom: 25px;
                }

                .stat-card {
                    background: rgba(255, 255, 255, 0.95);
                    border-radius: 16px;
                    padding: 22px;
                    text-align: center;
                    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.06);
                    border: 1px solid var(--gray-200);
                    transition: transform 0.2s, box-shadow 0.2s;
                }

                .stat-card:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
                }

                .stat-card .stat-icon {
                    font-size: 1.8rem;
                    margin-bottom: 6px;
                }

                .stat-card .stat-number {
                    font-size: 2rem;
                    font-weight: 700;
                    color: var(--primary);
                }

                .stat-card .stat-label {
                    color: var(--gray-500);
                    font-size: 0.85rem;
                    margin-top: 4px;
                    font-weight: 500;
                }

                /* Search & Filter Bar */
                .toolbar {
                    display: flex;
                    align-items: center;
                    gap: 12px;
                    margin-bottom: 20px;
                    flex-wrap: wrap;
                }

                .search-box {
                    flex: 1;
                    min-width: 250px;
                    position: relative;
                }

                .search-box input {
                    width: 100%;
                    padding: 12px 16px 12px 42px;
                    border: 2px solid var(--gray-200);
                    border-radius: 12px;
                    font-size: 0.9rem;
                    font-family: inherit;
                    transition: border-color 0.2s, box-shadow 0.2s;
                    background: white;
                }

                .search-box input:focus {
                    outline: none;
                    border-color: var(--primary-light);
                    box-shadow: 0 0 0 3px rgba(34, 197, 94, 0.15);
                }

                .search-box::before {
                    content: '🔍';
                    position: absolute;
                    left: 14px;
                    top: 50%;
                    transform: translateY(-50%);
                    font-size: 1rem;
                    z-index: 1;
                }

                .filter-select {
                    padding: 12px 16px;
                    border: 2px solid var(--gray-200);
                    border-radius: 12px;
                    font-size: 0.9rem;
                    font-family: inherit;
                    background: white;
                    cursor: pointer;
                    min-width: 160px;
                    transition: border-color 0.2s;
                }

                .filter-select:focus {
                    outline: none;
                    border-color: var(--primary-light);
                }

                .result-count {
                    font-size: 0.85rem;
                    color: var(--gray-500);
                    font-weight: 500;
                    padding: 8px 16px;
                    background: var(--primary-bg);
                    border-radius: 20px;
                }

                /* Table */
                .table-wrapper {
                    background: white;
                    border-radius: 16px;
                    overflow: hidden;
                    box-shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
                    border: 1px solid var(--gray-200);
                }

                .data-table {
                    width: 100%;
                    border-collapse: collapse;
                }

                .data-table thead th {
                    background: var(--primary);
                    color: white;
                    padding: 14px 12px;
                    font-size: 0.82rem;
                    text-align: left;
                    white-space: nowrap;
                    font-weight: 600;
                    text-transform: uppercase;
                    letter-spacing: 0.3px;
                }

                .data-table tbody td {
                    padding: 14px 12px;
                    border-bottom: 1px solid var(--gray-100);
                    font-size: 0.86rem;
                    vertical-align: middle;
                }

                .data-table tbody tr {
                    transition: background 0.15s;
                }

                .data-table tbody tr:hover {
                    background: var(--primary-bg);
                }

                .data-table tbody tr:last-child td {
                    border-bottom: none;
                }

                /* Venue name cell */
                .venue-name {
                    font-weight: 700;
                    color: var(--gray-900);
                }

                /* Owner cell */
                .owner-info {
                    display: flex;
                    flex-direction: column;
                }

                .owner-info .name {
                    font-weight: 600;
                    color: var(--gray-900);
                    font-size: 0.86rem;
                }

                .owner-info .email {
                    font-size: 0.76rem;
                    color: var(--gray-500);
                }

                /* Address cell */
                .address-info {
                    max-width: 200px;
                    line-height: 1.4;
                }

                .address-info .area {
                    font-weight: 600;
                    color: var(--gray-700);
                    font-size: 0.82rem;
                }

                .address-info .detail {
                    color: var(--gray-500);
                    font-size: 0.78rem;
                }

                /* Numeric cells */
                .num-cell {
                    text-align: center;
                    font-weight: 600;
                }

                .num-highlight {
                    background: var(--primary-bg);
                    color: var(--primary);
                    padding: 4px 10px;
                    border-radius: 8px;
                    display: inline-block;
                    font-size: 0.85rem;
                }

                /* Rating */
                .rating-cell {
                    display: flex;
                    flex-direction: column;
                    align-items: center;
                    gap: 2px;
                }

                .rating-cell .stars {
                    color: #f59e0b;
                    font-size: 0.85rem;
                    letter-spacing: 1px;
                }

                .rating-cell .avg-num {
                    font-weight: 700;
                    font-size: 0.9rem;
                    color: var(--gray-900);
                }

                .rating-cell .review-num {
                    font-size: 0.72rem;
                    color: var(--gray-500);
                }

                /* Revenue */
                .revenue-cell {
                    font-weight: 700;
                    color: var(--primary);
                }

                /* Status */
                .status-badge {
                    display: inline-flex;
                    align-items: center;
                    gap: 4px;
                    padding: 5px 14px;
                    border-radius: 20px;
                    font-size: 0.78rem;
                    font-weight: 600;
                    white-space: nowrap;
                }

                .status-active {
                    background: #dcfce7;
                    color: #166534;
                }

                .status-hidden {
                    background: #fef2f2;
                    color: #991b1b;
                }

                /* Buttons */
                .btn-action {
                    padding: 7px 16px;
                    border: none;
                    border-radius: 8px;
                    font-weight: 600;
                    cursor: pointer;
                    font-size: 0.8rem;
                    transition: all 0.2s;
                    display: inline-flex;
                    align-items: center;
                    gap: 4px;
                }

                .btn-lock {
                    background: #fef2f2;
                    color: var(--danger);
                    border: 1px solid #fecaca;
                }

                .btn-lock:hover {
                    background: var(--danger);
                    color: white;
                    transform: translateY(-1px);
                    box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3);
                }

                .btn-unlock {
                    background: #dcfce7;
                    color: #166534;
                    border: 1px solid #bbf7d0;
                }

                .btn-unlock:hover {
                    background: var(--success);
                    color: white;
                    transform: translateY(-1px);
                    box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
                }

                /* Time cell */
                .time-cell {
                    white-space: nowrap;
                    font-size: 0.82rem;
                    color: var(--gray-700);
                }

                .no-data {
                    text-align: center;
                    padding: 60px;
                    color: var(--gray-500);
                    font-size: 1.2rem;
                    font-style: italic;
                    background: white;
                    border-radius: 16px;
                    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.06);
                }

                .no-data-icon {
                    font-size: 3rem;
                    margin-bottom: 12px;
                    display: block;
                }

                @media (max-width: 1200px) {
                    .data-table {
                        display: block;
                        overflow-x: auto;
                    }
                }
            </style>

            <h1 class="page-title">🏟️ Quản lý Sân</h1>

            <!-- Toast -->
            <div class="toast-container">
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="toast toast-success" id="toastMsg">✅ ${sessionScope.successMessage}</div>
                    <c:remove var="successMessage" scope="session" />
                </c:if>
                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="toast toast-error" id="toastMsg">❌ ${sessionScope.errorMessage}</div>
                    <c:remove var="errorMessage" scope="session" />
                </c:if>
            </div>
            <script>
                var toast = document.getElementById('toastMsg');
                if (toast) { setTimeout(function () { toast.remove(); }, 5000); }
            </script>

            <!-- Stats -->
            <div class="stats-row">
                <div class="stat-card">
                    <div class="stat-icon">🏟️</div>
                    <div class="stat-number">${totalVenues}</div>
                    <div class="stat-label">Tổng số sân</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">✅</div>
                    <div class="stat-number" style="color: var(--success);">${activeCount}</div>
                    <div class="stat-label">Đang hoạt động</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">🔒</div>
                    <div class="stat-number" style="color: var(--danger);">${hiddenCount}</div>
                    <div class="stat-label">Đã khóa</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">📋</div>
                    <div class="stat-number" style="color: var(--warning);">${totalBookings}</div>
                    <div class="stat-label">Tổng lượt đặt</div>
                </div>
            </div>

            <!-- Search + Filter -->
            <div class="toolbar">
                <div class="search-box">
                    <input type="text" id="searchInput" placeholder="Tìm theo tên sân hoặc chủ sân..."
                        onkeyup="filterTable()">
                </div>
                <select class="filter-select" id="statusFilter" onchange="filterTable()">
                    <option value="all">📋 Tất cả trạng thái</option>
                    <option value="active">✅ Hoạt động</option>
                    <option value="hidden">🔒 Đã khóa</option>
                </select>
                <span class="result-count" id="resultCount">${totalVenues} sân</span>
            </div>

            <!-- Table -->
            <c:if test="${not empty venues}">
                <div class="table-wrapper">
                    <table class="data-table" id="venueTable">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tên sân</th>
                                <th>Chủ sân</th>
                                <th>Địa chỉ</th>
                                <th>Sân con</th>
                                <th>Lượt đặt</th>
                                <th>Rating</th>
                                <th>Doanh thu</th>
                                <th>Giờ mở</th>
                                <th>Trạng thái</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${venues}" var="v">
                                <tr data-status="${v.status}" data-search="${v.venueName} ${v.ownerName}">
                                    <td><strong>#${v.venueId}</strong></td>
                                    <td class="venue-name">${v.venueName}</td>
                                    <td>
                                        <div class="owner-info">
                                            <span class="name">${v.ownerName}</span>
                                            <span class="email">${v.ownerEmail}</span>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="address-info">
                                            <div class="area">
                                                <c:if test="${not empty v.provinceName}">${v.provinceName}</c:if>
                                                <c:if test="${not empty v.districtName}">, ${v.districtName}</c:if>
                                            </div>
                                            <div class="detail">${v.addressDetail}</div>
                                        </div>
                                    </td>
                                    <td class="num-cell">
                                        <span class="num-highlight">${v.fieldCount}</span>
                                    </td>
                                    <td class="num-cell">
                                        <span class="num-highlight">${v.bookingCount}</span>
                                    </td>
                                    <td>
                                        <div class="rating-cell">
                                            <c:choose>
                                                <c:when test="${v.reviewCount > 0}">
                                                    <span class="avg-num">
                                                        <fmt:formatNumber value="${v.avgRating}"
                                                            maxFractionDigits="1" />
                                                    </span>
                                                    <span class="stars">
                                                        <c:forEach begin="1" end="5" var="i">
                                                            <c:choose>
                                                                <c:when test="${i <= v.avgRating}">★</c:when>
                                                                <c:otherwise>☆</c:otherwise>
                                                            </c:choose>
                                                        </c:forEach>
                                                    </span>
                                                    <span class="review-num">${v.reviewCount} đánh giá</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color: var(--gray-500); font-size: 0.8rem;">Chưa
                                                        có</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                    <td class="revenue-cell">
                                        <c:choose>
                                            <c:when test="${v.totalRevenue > 0}">
                                                <fmt:formatNumber value="${v.totalRevenue}" type="number"
                                                    groupingUsed="true" />đ
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: var(--gray-500);">0đ</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="time-cell">${v.openTime} - ${v.closeTime}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${v.status == 'active'}">
                                                <span class="status-badge status-active">✅ Hoạt động</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge status-hidden">🔒 Đã khóa</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${v.status == 'active'}">
                                                <form method="post"
                                                    action="${pageContext.request.contextPath}/admin/venues"
                                                    style="display:inline;">
                                                    <input type="hidden" name="venueId" value="${v.venueId}" />
                                                    <input type="hidden" name="action" value="hide" />
                                                    <button type="submit" class="btn-action btn-lock"
                                                        onclick="return confirm('Khóa sân ${v.venueName}?')">🔒
                                                        Khóa</button>
                                                </form>
                                            </c:when>
                                            <c:otherwise>
                                                <form method="post"
                                                    action="${pageContext.request.contextPath}/admin/venues"
                                                    style="display:inline;">
                                                    <input type="hidden" name="venueId" value="${v.venueId}" />
                                                    <input type="hidden" name="action" value="show" />
                                                    <button type="submit" class="btn-action btn-unlock"
                                                        onclick="return confirm('Mở sân ${v.venueName}?')">🔓
                                                        Mở</button>
                                                </form>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:if>

            <c:if test="${empty venues}">
                <div class="no-data">
                    <span class="no-data-icon">🏟️</span>
                    Không có sân nào trong hệ thống
                </div>
            </c:if>

            <!-- Search + Filter JS -->
            <script>
                function filterTable() {
                    var searchText = document.getElementById('searchInput').value.toLowerCase();
                    var statusFilter = document.getElementById('statusFilter').value;
                    var rows = document.querySelectorAll('#venueTable tbody tr');
                    var visibleCount = 0;

                    rows.forEach(function (row) {
                        var searchData = row.getAttribute('data-search').toLowerCase();
                        var rowStatus = row.getAttribute('data-status');

                        var matchSearch = searchText === '' || searchData.indexOf(searchText) !== -1;
                        var matchStatus = statusFilter === 'all' || rowStatus === statusFilter;

                        if (matchSearch && matchStatus) {
                            row.style.display = '';
                            visibleCount++;
                        } else {
                            row.style.display = 'none';
                        }
                    });

                    document.getElementById('resultCount').textContent = visibleCount + ' sân';
                }
            </script>

            <jsp:include page="footer.jsp" />
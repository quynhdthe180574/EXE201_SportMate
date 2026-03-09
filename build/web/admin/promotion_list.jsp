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

                .status-active {
                    background: #d4edda;
                    color: #155724;
                }

                .status-inactive {
                    background: #e2e3e5;
                    color: #383d41;
                }

                /* Buttons */
                .action-btns {
                    display: flex;
                    gap: 6px;
                    align-items: center;
                    flex-wrap: wrap;
                }

                .btn-toggle {
                    padding: 6px 14px;
                    background: var(--blue-pastel);
                    color: white;
                    border: none;
                    border-radius: 8px;
                    font-weight: 600;
                    cursor: pointer;
                    font-size: 0.82rem;
                    transition: all 0.2s;
                }

                .btn-toggle:hover {
                    background: var(--primary-light);
                    transform: translateY(-1px);
                }

                .btn-delete {
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

                .btn-delete:hover {
                    background: #f0a0b0;
                    transform: translateY(-1px);
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

            <h1 class="page-title">🎫 Quản lý Promotion</h1>

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
            <c:set var="activeCount" value="0" />
            <c:set var="inactiveCount" value="0" />
            <c:forEach items="${promotions}" var="p">
                <c:if test="${p.status == 'active'}">
                    <c:set var="activeCount" value="${activeCount + 1}" />
                </c:if>
                <c:if test="${p.status != 'active'}">
                    <c:set var="inactiveCount" value="${inactiveCount + 1}" />
                </c:if>
            </c:forEach>

            <div class="stats-row">
                <div class="stat-card">
                    <div class="stat-number">${promotions.size()}</div>
                    <div class="stat-label">Tổng Promotion</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number" style="color: var(--green-pastel);">${activeCount}</div>
                    <div class="stat-label">Đang Active</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number" style="color: #6c757d;">${inactiveCount}</div>
                    <div class="stat-label">Inactive</div>
                </div>
            </div>

            <!-- Table -->
            <c:if test="${not empty promotions}">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Tên</th>
                            <th>Chủ sân</th>
                            <th>Giảm giá</th>
                            <th>Bắt đầu</th>
                            <th>Kết thúc</th>
                            <th>Giới hạn</th>
                            <th>Trạng thái</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${promotions}" var="p">
                            <tr>
                                <td><strong>#${p.promotionId}</strong></td>
                                <td>${p.name}</td>
                                <td>${p.ownerName}</td>
                                <td>
                                    <fmt:formatNumber value="${p.discountValue}" type="number" maxFractionDigits="0" />%
                                </td>
                                <td>${p.startDate}</td>
                                <td>${p.endDate}</td>
                                <td>${p.usageLimit}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${p.status == 'active'}">
                                            <span class="status-badge status-active">✅ Active</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge status-inactive">⏸️ Inactive</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="action-btns">
                                        <form method="post"
                                            action="${pageContext.request.contextPath}/admin/promotions">
                                            <input type="hidden" name="promoId" value="${p.promotionId}" />
                                            <input type="hidden" name="action" value="toggle" />
                                            <button type="submit" class="btn-toggle">🔄 Toggle</button>
                                        </form>
                                        <form method="post"
                                            action="${pageContext.request.contextPath}/admin/promotions">
                                            <input type="hidden" name="promoId" value="${p.promotionId}" />
                                            <input type="hidden" name="action" value="delete" />
                                            <button type="submit" class="btn-delete"
                                                onclick="return confirm('Xóa promotion #${p.promotionId}?')">🗑️
                                                Xóa</button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>

            <c:if test="${empty promotions}">
                <div class="no-data">Chưa có promotion nào</div>
            </c:if>

            <jsp:include page="footer.jsp" />
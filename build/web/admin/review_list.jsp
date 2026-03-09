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
                    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                    gap: 15px;
                    margin-bottom: 25px;
                }

                .stat-card {
                    background: rgba(255, 255, 255, 0.95);
                    border-radius: 16px;
                    padding: 24px;
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
                    font-size: 2rem;
                    margin-bottom: 8px;
                }

                .stat-card .stat-number {
                    font-size: 2.2rem;
                    font-weight: 700;
                    color: var(--primary);
                }

                .stat-card .stat-label {
                    color: var(--gray-500);
                    font-size: 0.9rem;
                    margin-top: 5px;
                    font-weight: 500;
                }

                /* Field Cards Grid */
                .fields-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
                    gap: 20px;
                    margin-top: 20px;
                }

                .field-card {
                    background: white;
                    border-radius: 16px;
                    padding: 24px;
                    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.06);
                    border: 1px solid var(--gray-200);
                    cursor: pointer;
                    transition: all 0.3s ease;
                    text-decoration: none;
                    color: inherit;
                    display: block;
                    position: relative;
                    overflow: hidden;
                }

                .field-card::before {
                    content: '';
                    position: absolute;
                    top: 0;
                    left: 0;
                    right: 0;
                    height: 4px;
                    background: linear-gradient(90deg, var(--primary), var(--primary-light));
                    opacity: 0;
                    transition: opacity 0.3s;
                }

                .field-card:hover {
                    transform: translateY(-4px);
                    box-shadow: 0 12px 35px rgba(21, 128, 61, 0.12);
                    border-color: var(--primary-light);
                }

                .field-card:hover::before {
                    opacity: 1;
                }

                .field-card-header {
                    display: flex;
                    align-items: center;
                    gap: 12px;
                    margin-bottom: 16px;
                }

                .field-card-icon {
                    width: 48px;
                    height: 48px;
                    background: var(--primary-bg);
                    border-radius: 12px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 1.4rem;
                    flex-shrink: 0;
                }

                .field-card-title {
                    font-size: 1.05rem;
                    font-weight: 700;
                    color: var(--gray-900);
                    line-height: 1.3;
                }

                .field-card-venue {
                    font-size: 0.82rem;
                    color: var(--gray-500);
                    font-weight: 500;
                    margin-top: 2px;
                }

                .field-card-stats {
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    padding-top: 16px;
                    border-top: 1px solid var(--gray-100);
                }

                .field-card-rating {
                    display: flex;
                    align-items: center;
                    gap: 6px;
                }

                .field-card-rating .stars {
                    color: #f59e0b;
                    font-size: 1rem;
                    letter-spacing: 1px;
                }

                .field-card-rating .avg-value {
                    font-weight: 700;
                    font-size: 1.1rem;
                    color: var(--gray-900);
                }

                .field-card-count {
                    background: var(--primary-bg);
                    color: var(--primary);
                    padding: 4px 12px;
                    border-radius: 20px;
                    font-size: 0.82rem;
                    font-weight: 600;
                }

                .field-card-arrow {
                    position: absolute;
                    right: 20px;
                    top: 50%;
                    transform: translateY(-50%);
                    color: var(--gray-200);
                    font-size: 1.2rem;
                    transition: all 0.3s;
                }

                .field-card:hover .field-card-arrow {
                    color: var(--primary);
                    right: 16px;
                }

                /* Back button */
                .btn-back {
                    display: inline-flex;
                    align-items: center;
                    gap: 8px;
                    padding: 10px 20px;
                    background: white;
                    color: var(--primary);
                    border: 2px solid var(--primary);
                    border-radius: 10px;
                    font-weight: 600;
                    font-size: 0.88rem;
                    text-decoration: none;
                    transition: all 0.2s;
                    margin-bottom: 20px;
                }

                .btn-back:hover {
                    background: var(--primary);
                    color: white;
                    transform: translateX(-3px);
                }

                /* Detail header */
                .detail-header {
                    background: white;
                    border-radius: 16px;
                    padding: 24px;
                    margin-bottom: 20px;
                    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.06);
                    border: 1px solid var(--gray-200);
                    display: flex;
                    align-items: center;
                    gap: 20px;
                }

                .detail-header-icon {
                    width: 64px;
                    height: 64px;
                    background: linear-gradient(135deg, var(--primary-bg), var(--primary-hover));
                    border-radius: 16px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 1.8rem;
                    flex-shrink: 0;
                }

                .detail-header-info h2 {
                    font-size: 1.3rem;
                    color: var(--gray-900);
                    margin-bottom: 4px;
                }

                .detail-header-info .venue-label {
                    color: var(--gray-500);
                    font-size: 0.9rem;
                    font-weight: 500;
                }

                .detail-header-stats {
                    margin-left: auto;
                    display: flex;
                    gap: 24px;
                    align-items: center;
                }

                .detail-stat {
                    text-align: center;
                }

                .detail-stat .value {
                    font-size: 1.5rem;
                    font-weight: 700;
                    color: var(--primary);
                }

                .detail-stat .label {
                    font-size: 0.8rem;
                    color: var(--gray-500);
                    font-weight: 500;
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
                    background: var(--primary);
                    color: white;
                    padding: 14px 16px;
                    font-size: 0.88rem;
                    text-align: left;
                    white-space: nowrap;
                    font-weight: 600;
                }

                .data-table tbody td {
                    padding: 14px 16px;
                    border-bottom: 1px solid var(--gray-100);
                    font-size: 0.88rem;
                    vertical-align: middle;
                }

                .data-table tbody tr:hover {
                    background: var(--primary-bg);
                }

                .data-table tbody tr:last-child td {
                    border-bottom: none;
                }

                /* Stars */
                .stars {
                    color: #f59e0b;
                    font-size: 1rem;
                    letter-spacing: 1px;
                }

                /* User info in table */
                .user-info {
                    display: flex;
                    flex-direction: column;
                }

                .user-info .name {
                    font-weight: 600;
                    color: var(--gray-900);
                }

                .user-info .email {
                    font-size: 0.78rem;
                    color: var(--gray-500);
                }

                /* Button */
                .btn-delete {
                    padding: 6px 14px;
                    background: #fef2f2;
                    color: var(--danger);
                    border: 1px solid #fecaca;
                    border-radius: 8px;
                    font-weight: 600;
                    cursor: pointer;
                    font-size: 0.82rem;
                    transition: all 0.2s;
                }

                .btn-delete:hover {
                    background: var(--danger);
                    color: white;
                    transform: translateY(-1px);
                    box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3);
                }

                .comment-cell {
                    max-width: 300px;
                    white-space: normal;
                    line-height: 1.5;
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

                .section-title {
                    font-size: 1.15rem;
                    font-weight: 700;
                    color: var(--gray-900);
                    margin-bottom: 16px;
                    display: flex;
                    align-items: center;
                    gap: 8px;
                }

                @media (max-width: 900px) {
                    .data-table {
                        display: block;
                        overflow-x: auto;
                    }

                    .fields-grid {
                        grid-template-columns: 1fr;
                    }

                    .detail-header {
                        flex-direction: column;
                        text-align: center;
                    }

                    .detail-header-stats {
                        margin-left: 0;
                    }
                }
            </style>

            <h1 class="page-title">⭐ Quản lý Review</h1>

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

            <!-- ============ OVERVIEW MODE ============ -->
            <c:if test="${viewMode == 'overview'}">

                <!-- Stats -->
                <div class="stats-row">
                    <div class="stat-card">
                        <div class="stat-icon">🏟️</div>
                        <div class="stat-number">${totalFields}</div>
                        <div class="stat-label">Tổng số sân</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon">📝</div>
                        <div class="stat-number">${totalReviews}</div>
                        <div class="stat-label">Tổng lượt đánh giá</div>
                    </div>
                </div>

                <!-- Field Cards -->
                <div class="section-title">📋 Danh sách sân có đánh giá</div>

                <c:if test="${not empty fieldSummaries}">
                    <div class="fields-grid">
                        <c:forEach items="${fieldSummaries}" var="f">
                            <a href="${pageContext.request.contextPath}/admin/reviews?fieldId=${f.fieldId}"
                                class="field-card">
                                <div class="field-card-header">
                                    <div class="field-card-icon">⚽</div>
                                    <div>
                                        <div class="field-card-title">${f.fieldName}</div>
                                        <div class="field-card-venue">📍 ${f.venueName}</div>
                                    </div>
                                </div>
                                <div class="field-card-stats">
                                    <div class="field-card-rating">
                                        <span class="avg-value">
                                            <fmt:formatNumber value="${f.avgRating}" maxFractionDigits="1" />
                                        </span>
                                        <span class="stars">
                                            <c:forEach begin="1" end="5" var="i">
                                                <c:choose>
                                                    <c:when test="${i <= f.avgRating}">★</c:when>
                                                    <c:otherwise>☆</c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                        </span>
                                    </div>
                                    <div class="field-card-count">${f.reviewCount} đánh giá</div>
                                </div>
                                <div class="field-card-arrow">→</div>
                            </a>
                        </c:forEach>
                    </div>
                </c:if>

                <c:if test="${empty fieldSummaries}">
                    <div class="no-data">
                        <span class="no-data-icon">📭</span>
                        Chưa có đánh giá nào trong hệ thống
                    </div>
                </c:if>

            </c:if>

            <!-- ============ DETAIL MODE ============ -->
            <c:if test="${viewMode == 'detail'}">

                <!-- Back button -->
                <a href="${pageContext.request.contextPath}/admin/reviews" class="btn-back">
                    ← Quay lại danh sách
                </a>

                <!-- Field info header -->
                <c:if test="${fieldInfo != null}">
                    <div class="detail-header">
                        <div class="detail-header-icon">⚽</div>
                        <div class="detail-header-info">
                            <h2>${fieldInfo.fieldName}</h2>
                            <div class="venue-label">📍 ${fieldInfo.venueName}</div>
                        </div>
                        <div class="detail-header-stats">
                            <div class="detail-stat">
                                <div class="value">${fieldReviews.size()}</div>
                                <div class="label">Đánh giá</div>
                            </div>
                            <c:if test="${fieldReviews.size() > 0}">
                                <c:set var="totalRating" value="0" />
                                <c:forEach items="${fieldReviews}" var="r">
                                    <c:set var="totalRating" value="${totalRating + r.rating}" />
                                </c:forEach>
                                <div class="detail-stat">
                                    <div class="value" style="color: #f59e0b;">
                                        <fmt:formatNumber value="${totalRating / fieldReviews.size()}"
                                            maxFractionDigits="1" /> ⭐
                                    </div>
                                    <div class="label">TB Rating</div>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </c:if>

                <!-- Reviews table -->
                <div class="section-title">💬 Các đánh giá của khách hàng</div>

                <c:if test="${not empty fieldReviews}">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Người đánh giá</th>
                                <th>Rating</th>
                                <th>Nội dung</th>
                                <th>Ngày</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${fieldReviews}" var="r">
                                <tr>
                                    <td><strong>#${r.reviewId}</strong></td>
                                    <td>
                                        <div class="user-info">
                                            <span class="name">${r.fullname}</span>
                                            <span class="email">${r.email}</span>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="stars">
                                            <c:forEach begin="1" end="${r.rating}">★</c:forEach>
                                            <c:forEach begin="${r.rating + 1}" end="5">☆</c:forEach>
                                        </span>
                                    </td>
                                    <td class="comment-cell">${r.comment}</td>
                                    <td>
                                        <fmt:formatDate value="${r.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                    </td>
                                    <td>
                                        <form method="post" action="${pageContext.request.contextPath}/admin/reviews">
                                            <input type="hidden" name="reviewId" value="${r.reviewId}" />
                                            <input type="hidden" name="fieldId" value="${selectedFieldId}" />
                                            <input type="hidden" name="action" value="delete" />
                                            <button type="submit" class="btn-delete"
                                                onclick="return confirm('Bạn có chắc muốn xóa đánh giá #${r.reviewId}?')">🗑️
                                                Xóa</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:if>

                <c:if test="${empty fieldReviews}">
                    <div class="no-data">
                        <span class="no-data-icon">📭</span>
                        Sân này chưa có đánh giá nào
                    </div>
                </c:if>

            </c:if>

            <jsp:include page="footer.jsp" />
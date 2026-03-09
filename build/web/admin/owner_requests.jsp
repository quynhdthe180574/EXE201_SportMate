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

                /* Status badges */
                .status-badge {
                    display: inline-block;
                    padding: 4px 12px;
                    border-radius: 15px;
                    font-size: 0.8rem;
                    font-weight: 600;
                }

                .status-pending {
                    background: #fff3cd;
                    color: #856404;
                }

                .status-approved {
                    background: #d4edda;
                    color: #155724;
                }

                .status-rejected {
                    background: #f8d7da;
                    color: #721c24;
                }

                /* Action buttons */
                .btn-approve {
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

                .btn-approve:hover {
                    background: #9acb9a;
                    transform: translateY(-1px);
                }

                .btn-reject {
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

                .btn-reject:hover {
                    background: #f0a0b0;
                    transform: translateY(-1px);
                }

                .desc-cell {
                    max-width: 200px;
                    white-space: nowrap;
                    overflow: hidden;
                    text-overflow: ellipsis;
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

            <h1 class="page-title">📝 Quản lý Owner Requests</h1>

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
            <c:set var="pendingCount" value="0" />
            <c:set var="approvedCount" value="0" />
            <c:set var="rejectedCount" value="0" />
            <c:forEach items="${requests}" var="r">
                <c:if test="${r.status == 'PENDING'}">
                    <c:set var="pendingCount" value="${pendingCount + 1}" />
                </c:if>
                <c:if test="${r.status == 'APPROVED'}">
                    <c:set var="approvedCount" value="${approvedCount + 1}" />
                </c:if>
                <c:if test="${r.status == 'REJECTED'}">
                    <c:set var="rejectedCount" value="${rejectedCount + 1}" />
                </c:if>
            </c:forEach>

            <div class="stats-row">
                <div class="stat-card">
                    <div class="stat-number">${requests.size()}</div>
                    <div class="stat-label">Tổng yêu cầu</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number" style="color: #e67e22;">${pendingCount}</div>
                    <div class="stat-label">Đang chờ</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number" style="color: var(--green-pastel);">${approvedCount}</div>
                    <div class="stat-label">Đã duyệt</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number" style="color: #721c24;">${rejectedCount}</div>
                    <div class="stat-label">Đã từ chối</div>
                </div>
            </div>

            <!-- Table -->
            <c:if test="${not empty requests}">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Người gửi</th>
                            <th>Email</th>
                            <th>SĐT</th>
                            <th>Địa chỉ</th>
                            <th>Mô tả</th>
                            <th>Ngày gửi</th>
                            <th>Trạng thái</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${requests}" var="r">
                            <tr>
                                <td><strong>#${r.requestId}</strong></td>
                                <td>${r.fullname}</td>
                                <td>${r.email}</td>
                                <td>${r.phone}</td>
                                <td class="desc-cell" title="${r.addressDetail}">${r.addressDetail}</td>
                                <td class="desc-cell" title="${r.description}">${r.description}</td>
                                <td>
                                    <fmt:formatDate value="${r.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${r.status == 'PENDING'}">
                                            <span class="status-badge status-pending">⏳ Đang chờ</span>
                                        </c:when>
                                        <c:when test="${r.status == 'APPROVED'}">
                                            <span class="status-badge status-approved">✅ Đã duyệt</span>
                                        </c:when>
                                        <c:when test="${r.status == 'REJECTED'}">
                                            <span class="status-badge status-rejected">❌ Từ chối</span>
                                        </c:when>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:if test="${r.status == 'PENDING'}">
                                        <div style="display:flex; gap:6px;">
                                            <form method="post"
                                                action="${pageContext.request.contextPath}/admin/owner-requests">
                                                <input type="hidden" name="requestId" value="${r.requestId}" />
                                                <input type="hidden" name="action" value="approve" />
                                                <button type="submit" class="btn-approve"
                                                    onclick="return confirm('Duyệt yêu cầu #${r.requestId}? User sẽ được chuyển thành Owner.')">
                                                    ✅ Duyệt
                                                </button>
                                            </form>
                                            <form method="post"
                                                action="${pageContext.request.contextPath}/admin/owner-requests">
                                                <input type="hidden" name="requestId" value="${r.requestId}" />
                                                <input type="hidden" name="action" value="reject" />
                                                <button type="submit" class="btn-reject"
                                                    onclick="return confirm('Từ chối yêu cầu #${r.requestId}?')">
                                                    ❌ Từ chối
                                                </button>
                                            </form>
                                        </div>
                                    </c:if>
                                    <c:if test="${r.status != 'PENDING'}">
                                        <span style="color:#999; font-size:0.82rem;">Đã xử lý</span>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>

            <c:if test="${empty requests}">
                <div class="no-data">Không có yêu cầu nào</div>
            </c:if>

            <jsp:include page="footer.jsp" />
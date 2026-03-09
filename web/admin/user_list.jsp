<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <jsp:include page="header.jsp" />

        <style>
            .page-title {
                text-align: center;
                color: var(--purple-pastel);
                margin-bottom: 10px;
                font-size: 2rem;
            }

            /* ===== Toast Notification ===== */
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

            /* ===== Stats ===== */
            .user-stats {
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

            /* ===== Table ===== */
            .user-table {
                width: 100%;
                border-collapse: collapse;
                background: white;
                border-radius: 16px;
                overflow: hidden;
                box-shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
            }

            .user-table thead th {
                background: var(--purple-pastel);
                color: white;
                padding: 16px 12px;
                font-size: 0.9rem;
                text-align: left;
                white-space: nowrap;
            }

            .user-table tbody td {
                padding: 14px 12px;
                border-bottom: 1px solid #f0f0f0;
                font-size: 0.9rem;
                vertical-align: middle;
            }

            .user-table tbody tr:hover {
                background: var(--primary-hover);
            }

            .user-table tbody tr:last-child td {
                border-bottom: none;
            }

            /* ===== Role Badge ===== */
            .role-badge {
                display: inline-block;
                padding: 4px 12px;
                border-radius: 15px;
                font-size: 0.82rem;
                font-weight: 600;
            }

            .role-admin {
                background: var(--purple-pastel);
                color: white;
            }

            .role-owner {
                background: var(--blue-pastel);
                color: white;
            }

            .role-player {
                background: var(--green-pastel);
                color: #333;
            }

            /* ===== Status Badge ===== */
            .status-badge {
                display: inline-block;
                padding: 4px 12px;
                border-radius: 15px;
                font-size: 0.82rem;
                font-weight: 600;
            }

            .status-active {
                background: #d4edda;
                color: #155724;
            }

            .status-locked {
                background: #f8d7da;
                color: #721c24;
            }

            /* ===== Action Buttons ===== */
            .action-btns {
                display: flex;
                gap: 6px;
                align-items: center;
                flex-wrap: wrap;
            }

            .action-btns form {
                display: inline-flex;
                align-items: center;
                gap: 4px;
            }

            .btn-lock {
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

            .btn-lock:hover {
                background: #f0a0b0;
                transform: translateY(-1px);
            }

            .btn-unlock {
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

            .btn-unlock:hover {
                background: #9acb9a;
                transform: translateY(-1px);
            }

            /* ===== Role Change ===== */
            .role-change-form {
                display: inline-flex;
                align-items: center;
                gap: 4px;
            }

            .role-change-form select {
                padding: 5px 8px;
                border: 1px solid #ddd;
                border-radius: 6px;
                font-size: 0.82rem;
            }

            .btn-role {
                padding: 5px 10px;
                background: var(--blue-pastel);
                color: white;
                border: none;
                border-radius: 6px;
                font-weight: 600;
                cursor: pointer;
                font-size: 0.78rem;
                transition: all 0.2s;
            }

            .btn-role:hover {
                background: var(--primary-light);
                transform: translateY(-1px);
            }

            /* ===== No Data ===== */
            .no-data {
                text-align: center;
                padding: 60px 20px;
                color: #999;
                font-size: 1.2rem;
                font-style: italic;
            }

            /* ===== Responsive ===== */
            @media (max-width: 900px) {
                .user-table {
                    display: block;
                    overflow-x: auto;
                }
            }
        </style>

        <h1 class="page-title">Quản lý User</h1>

        <!-- Toast Notifications -->
        <div class="toast-container">
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="toast toast-success" id="toastMsg">
                    ✅ ${sessionScope.successMessage}
                </div>
                <c:remove var="successMessage" scope="session" />
            </c:if>
            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="toast toast-error" id="toastMsg">
                    ❌ ${sessionScope.errorMessage}
                </div>
                <c:remove var="errorMessage" scope="session" />
            </c:if>
        </div>
        <script>
            // Tự động xóa toast sau 5 giây
            var toast = document.getElementById('toastMsg');
            if (toast) {
                setTimeout(function () {
                    toast.remove();
                }, 5000);
            }
        </script>

        <!-- Stats -->
        <c:set var="totalUsers" value="${users.size()}" />
        <c:set var="adminCount" value="0" />
        <c:set var="ownerCount" value="0" />
        <c:set var="playerCount" value="0" />
        <c:set var="lockedCount" value="0" />
        <c:forEach items="${users}" var="u">
            <c:if test="${u.roleId == 1}">
                <c:set var="adminCount" value="${adminCount + 1}" />
            </c:if>
            <c:if test="${u.roleId == 2}">
                <c:set var="ownerCount" value="${ownerCount + 1}" />
            </c:if>
            <c:if test="${u.roleId == 3}">
                <c:set var="playerCount" value="${playerCount + 1}" />
            </c:if>
            <c:if test="${u.status == 'Bị khóa'}">
                <c:set var="lockedCount" value="${lockedCount + 1}" />
            </c:if>
        </c:forEach>

        <div class="user-stats">
            <div class="stat-card">
                <div class="stat-number">${totalUsers}</div>
                <div class="stat-label">Tổng user</div>
            </div>
            <div class="stat-card">
                <div class="stat-number" style="color: var(--purple-pastel);">${adminCount}</div>
                <div class="stat-label">Admin</div>
            </div>
            <div class="stat-card">
                <div class="stat-number" style="color: var(--blue-pastel);">${ownerCount}</div>
                <div class="stat-label">Chủ sân</div>
            </div>
            <div class="stat-card">
                <div class="stat-number" style="color: var(--green-pastel);">${playerCount}</div>
                <div class="stat-label">Người chơi</div>
            </div>
            <div class="stat-card">
                <div class="stat-number" style="color: #721c24;">${lockedCount}</div>
                <div class="stat-label">Bị khóa</div>
            </div>
        </div>

        <!-- User Table -->
        <c:if test="${not empty users}">
            <table class="user-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Họ tên</th>
                        <th>Email</th>
                        <th>SĐT</th>
                        <th>Role</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${users}" var="u">
                        <tr>
                            <td><strong>#${u.userId}</strong></td>
                            <td>${u.fullname}</td>
                            <td>${u.email}</td>
                            <td>${u.phone}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${u.roleId == 1}">
                                        <span class="role-badge role-admin">${u.roleName}</span>
                                    </c:when>
                                    <c:when test="${u.roleId == 2}">
                                        <span class="role-badge role-owner">${u.roleName}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="role-badge role-player">${u.roleName}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${u.status == 'Bị khóa'}">
                                        <span class="status-badge status-locked">🔒 Bị khóa</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge status-active">✅ Hoạt động</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="action-btns">
                                    <!-- Khóa / Mở -->
                                    <c:if test="${u.roleId != 1}">
                                        <c:choose>
                                            <c:when test="${u.status == 'Bị khóa'}">
                                                <form method="post"
                                                    action="${pageContext.request.contextPath}/admin/users">
                                                    <input type="hidden" name="userId" value="${u.userId}" />
                                                    <input type="hidden" name="action" value="unlock" />
                                                    <button type="submit" class="btn-unlock"
                                                        onclick="return confirm('Mở khóa user #${u.userId}?')">
                                                        🔓 Mở khóa
                                                    </button>
                                                </form>
                                            </c:when>
                                            <c:otherwise>
                                                <form method="post"
                                                    action="${pageContext.request.contextPath}/admin/users">
                                                    <input type="hidden" name="userId" value="${u.userId}" />
                                                    <input type="hidden" name="action" value="lock" />
                                                    <button type="submit" class="btn-lock"
                                                        onclick="return confirm('Khóa user #${u.userId}?')">
                                                        🔒 Khóa
                                                    </button>
                                                </form>
                                            </c:otherwise>
                                        </c:choose>

                                        <!-- Đổi Role -->
                                        <form method="post" action="${pageContext.request.contextPath}/admin/users"
                                            class="role-change-form">
                                            <input type="hidden" name="userId" value="${u.userId}" />
                                            <input type="hidden" name="action" value="changeRole" />
                                            <select name="roleId">
                                                <c:forEach items="${roles}" var="r">
                                                    <c:if test="${r.roleId != 1}">
                                                        <option value="${r.roleId}" ${r.roleId==u.roleId ? 'selected'
                                                            : '' }>
                                                            ${r.roleName}
                                                        </option>
                                                    </c:if>
                                                </c:forEach>
                                            </select>
                                            <button type="submit" class="btn-role"
                                                onclick="return confirm('Đổi role user #${u.userId}?')">
                                                Đổi
                                            </button>
                                        </form>
                                    </c:if>

                                    <c:if test="${u.roleId == 1}">
                                        <span style="color:#999; font-size:0.82rem;">Admin (không thể sửa)</span>
                                    </c:if>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:if>

        <c:if test="${empty users}">
            <div class="no-data">
                Không có user nào
            </div>
        </c:if>

        <jsp:include page="footer.jsp" />
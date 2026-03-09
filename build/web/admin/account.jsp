<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ page import="model.User" %>
            <% User u=(User) session.getAttribute("user"); if (u==null) { response.sendRedirect(request.getContextPath()
                + "/login.jsp" ); return; } %>

                <jsp:include page="header.jsp" />

                <style>
                    .page-title {
                        text-align: center;
                        color: var(--purple-pastel);
                        margin-bottom: 25px;
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

                    /* Profile card */
                    .profile-container {
                        max-width: 700px;
                        margin: 0 auto;
                    }

                    .profile-card {
                        background: rgba(255, 255, 255, 0.95);
                        border-radius: 20px;
                        padding: 40px;
                        box-shadow: 0 6px 25px rgba(0, 0, 0, 0.08);
                    }

                    .profile-avatar {
                        width: 80px;
                        height: 80px;
                        border-radius: 50%;
                        background: var(--primary);
                        color: white;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-size: 2.5rem;
                        font-weight: 700;
                        margin: 0 auto 20px;
                    }

                    .profile-name {
                        text-align: center;
                        font-size: 1.5rem;
                        font-weight: 700;
                        color: #333;
                    }

                    .profile-email {
                        text-align: center;
                        color: #999;
                        margin-bottom: 30px;
                    }

                    /* Tabs */
                    .tabs {
                        display: flex;
                        border-bottom: 2px solid #eee;
                        margin-bottom: 30px;
                    }

                    .tab-btn {
                        padding: 12px 24px;
                        border: none;
                        background: none;
                        font-size: 1rem;
                        font-weight: 600;
                        color: #999;
                        cursor: pointer;
                        transition: all 0.3s;
                        border-bottom: 3px solid transparent;
                    }

                    .tab-btn.active {
                        color: var(--purple-pastel);
                        border-bottom-color: var(--purple-pastel);
                    }

                    .tab-content {
                        display: none;
                    }

                    .tab-content.active {
                        display: block;
                    }

                    /* Form */
                    .form-group {
                        margin-bottom: 20px;
                    }

                    .form-group label {
                        display: block;
                        font-weight: 600;
                        color: #555;
                        margin-bottom: 8px;
                        font-size: 0.9rem;
                    }

                    .form-group input {
                        width: 100%;
                        padding: 12px 16px;
                        border: 2px solid #e0e0e0;
                        border-radius: 12px;
                        font-size: 0.95rem;
                        transition: border-color 0.3s;
                        background: #f9f9f9;
                    }

                    .form-group input:focus {
                        border-color: var(--purple-pastel);
                        outline: none;
                        background: white;
                    }

                    .form-group input:disabled {
                        background: #f0f0f0;
                        color: #888;
                    }

                    .btn-primary {
                        padding: 12px 30px;
                        background: var(--purple-pastel);
                        color: white;
                        border: none;
                        border-radius: 12px;
                        font-weight: 600;
                        cursor: pointer;
                        font-size: 0.95rem;
                        transition: all 0.2s;
                    }

                    .btn-primary:hover {
                        background: var(--primary-light);
                        transform: translateY(-1px);
                    }

                    .btn-edit {
                        padding: 12px 30px;
                        background: var(--green-pastel);
                        color: #2d5a2d;
                        border: none;
                        border-radius: 12px;
                        font-weight: 600;
                        cursor: pointer;
                        font-size: 0.95rem;
                        transition: all 0.2s;
                    }

                    .btn-edit:hover {
                        background: #9acb9a;
                        transform: translateY(-1px);
                    }

                    .btn-row {
                        display: flex;
                        gap: 12px;
                        margin-top: 25px;
                    }
                </style>

                <h1 class="page-title">👤 Quản lý Tài khoản</h1>

                <!-- Toast -->
                <div class="toast-container">
                    <c:if test="${not empty sessionScope.profileSuccess}">
                        <div class="toast toast-success" id="toastMsg">✅ ${sessionScope.profileSuccess}</div>
                        <c:remove var="profileSuccess" scope="session" />
                    </c:if>
                    <c:if test="${not empty sessionScope.error}">
                        <div class="toast toast-error" id="toastMsg">❌ ${sessionScope.error}</div>
                        <c:remove var="error" scope="session" />
                    </c:if>
                    <c:if test="${not empty sessionScope.success}">
                        <div class="toast toast-success" id="toastMsg">✅ ${sessionScope.success}</div>
                        <c:remove var="success" scope="session" />
                    </c:if>
                </div>
                <script>
                    var toast = document.getElementById('toastMsg');
                    if (toast) { setTimeout(function () { toast.remove(); }, 5000); }
                </script>

                <div class="profile-container">
                    <div class="profile-card">
                        <div class="profile-avatar">
                            <%= u.getFullname().substring(0,1).toUpperCase() %>
                        </div>
                        <div class="profile-name">
                            <%= u.getFullname() %>
                        </div>
                        <div class="profile-email">
                            <%= u.getEmail() %>
                        </div>

                        <!-- Tabs -->
                        <div class="tabs">
                            <button class="tab-btn active" onclick="showTab('infoTab', this)">📝 Thông tin</button>
                            <button class="tab-btn" onclick="showTab('passwordTab', this)">🔒 Đổi mật khẩu</button>
                        </div>

                        <!-- Tab 1: Thông tin cá nhân -->
                        <div id="infoTab" class="tab-content active">
                            <form action="${pageContext.request.contextPath}/edit-profile" method="post"
                                id="profileForm">
                                <div class="form-group">
                                    <label>Họ & tên</label>
                                    <input type="text" name="fullname" value="<%= u.getFullname() %>" disabled
                                        id="f_fullname">
                                </div>
                                <div class="form-group">
                                    <label>Email</label>
                                    <input type="email" name="email" value="<%= u.getEmail() %>" disabled id="f_email">
                                </div>
                                <div class="form-group">
                                    <label>Số điện thoại</label>
                                    <input type="text" name="phone"
                                        value="<%= u.getPhone() != null ? u.getPhone() : "" %>" disabled id="f_phone">
                                </div>
                                <div class="btn-row">
                                    <button type="button" class="btn-edit" id="editBtn" onclick="enableEdit()">✏️ Chỉnh
                                        sửa</button>
                                    <button type="submit" class="btn-primary" id="saveBtn" style="display:none;">💾 Lưu
                                        thay đổi</button>
                                </div>
                            </form>
                        </div>

                        <!-- Tab 2: Đổi mật khẩu -->
                        <div id="passwordTab" class="tab-content">
                            <form action="${pageContext.request.contextPath}/change-password" method="post">
                                <div class="form-group">
                                    <label>Mật khẩu cũ</label>
                                    <input type="password" name="oldPassword" required>
                                </div>
                                <div class="form-group">
                                    <label>Mật khẩu mới</label>
                                    <input type="password" name="newPassword" required>
                                </div>
                                <div class="form-group">
                                    <label>Xác nhận mật khẩu mới</label>
                                    <input type="password" name="confirmPassword" required>
                                </div>
                                <div class="btn-row">
                                    <button type="submit" class="btn-primary">🔒 Đổi mật khẩu</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <script>
                    function showTab(tabId, btn) {
                        document.querySelectorAll('.tab-content').forEach(el => el.classList.remove('active'));
                        document.querySelectorAll('.tab-btn').forEach(el => el.classList.remove('active'));
                        document.getElementById(tabId).classList.add('active');
                        btn.classList.add('active');
                    }

                    function enableEdit() {
                        document.getElementById('f_fullname').disabled = false;
                        document.getElementById('f_email').disabled = false;
                        document.getElementById('f_phone').disabled = false;
                        document.getElementById('editBtn').style.display = 'none';
                        document.getElementById('saveBtn').style.display = 'inline-block';
                    }
                </script>

                <jsp:include page="footer.jsp" />
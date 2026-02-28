<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="model.User"%>

<%
    User u = (User) session.getAttribute("user");
    if (u == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Hồ sơ | SportMate</title>

        <!-- Bootstrap 5 -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

        <style>
            body {
                background: #f4f6f9;
            }

            /* HEADER */
            .main-header {
                background: white;
                padding: 15px 0;
                border-bottom: 1px solid #eee;
            }

            .logo {
                font-weight: bold;
                font-size: 20px;
                color: #1a7f5a;
            }

            .nav-link {
                color: #555 !important;
                font-weight: 500;
            }

            .btn-book {
                background: #198754;
                color: white;
                border-radius: 20px;
                padding: 6px 18px;
                font-weight: 500;
            }

            /* SIDEBAR */
            .sidebar {
                background: white;
                border-radius: 12px;
                padding: 25px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            }

            .sidebar a {
                display: block;
                padding: 8px 0;
                text-decoration: none;
                color: #444;
            }

            .sidebar a:hover {
                color: #198754;
            }

            .avatar-circle {
                width: 90px;
                height: 90px;
                border-radius: 50%;
                background: #e6f4ea;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 32px;
                font-weight: bold;
                color: #198754;
                margin: 0 auto 10px auto;
            }

            /* MAIN CARD */
            .profile-card {
                background: white;
                border-radius: 14px;
                padding: 30px;
                box-shadow: 0 2px 12px rgba(0,0,0,0.06);
            }

            .profile-title {
                font-size: 22px;
                font-weight: 700;
            }

            .form-control {
                background: #f1f3f5;
                border: none;
                border-radius: 8px;
            }

            .btn-edit {
                background: #157347;       /* xanh lá đậm */
                color: white;
                border: none;
                border-radius: 10px;
                padding: 10px 38px;        /* to khung ra */
                font-weight: 600;
                font-size: 16px;
                transition: 0.2s ease-in-out;
            }

            .btn-edit:hover {
                background: #115c38;       /* đậm hơn khi hover */
                transform: translateY(-1px);
            }

            .security-box {
                background: #e9f7ef;
                padding: 15px;
                border-radius: 10px;
                margin-top: 20px;
                font-size: 14px;
            }

            .delete-box {
                border-top: 1px solid #eee;
                margin-top: 25px;
                padding-top: 20px;
            }

            .btn-delete {
                border: 1px solid #dc3545;
                color: #dc3545;
                border-radius: 8px;
                background: white;
            }

            .btn-delete:hover {
                background: #dc3545;
                color: white;
            }
        </style>
    </head>

    <body>

        <!-- HEADER -->
        <div class="main-header">
            <div class="container d-flex justify-content-between align-items-center">

                <div>
                    <span class="logo">SPORTMATE</span>
                    <a href="home" class="nav-link d-inline ms-4">Trang chủ</a>
                    <a href="fields" class="nav-link d-inline">Danh sách sân</a>
                    <a href="#" class="nav-link d-inline">Giới thiệu</a>
                    <a href="#" class="nav-link d-inline">Chính sách</a>
                    <a href="#" class="nav-link d-inline">Liên hệ</a>
                </div>

                <div class="d-flex align-items-center gap-3">
                    <a href="booking" class="btn btn-book">Đặt Lịch</a>
                    <div class="avatar-circle" style="width:40px;height:40px;font-size:16px;">
                        <%= u.getFullname().substring(0,1).toUpperCase() %>
                    </div>
                </div>

            </div>
        </div>

        <!-- CONTENT -->
        <div class="container mt-5">
            <div class="row g-4">

                <!-- SIDEBAR -->
                <div class="col-md-4 col-lg-3">
                    <div class="sidebar text-center">

                        <div class="avatar-circle">
                            <%= u.getFullname().substring(0,1).toUpperCase() %>
                        </div>

                        <h6 class="fw-bold"><%= u.getFullname() %></h6>
                        <p class="text-muted small"><%= u.getEmail() %></p>

                        <hr>

                        <div class="text-start">
                            <p class="fw-bold small text-uppercase">Tài khoản của tôi</p>
                            <a href="profile.jsp">Thông tin tài khoản</a>
                            <a href="#" onclick="showTab('passwordTab')">Đổi mật khẩu</a>

                            <p class="fw-bold small text-uppercase mt-3">Danh sách lịch</p>
                            <a href="booking-history">Lịch đã đặt</a>
                        </div>

                    </div>
                </div>

                <!-- PROFILE -->
                <div class="col-md-8 col-lg-9">

                    <div class="profile-card">

                        <!-- TAB 1: THÔNG TIN -->
                        <div id="profileTab">

                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <div>
                                    <div class="profile-title">Thông tin cá nhân</div>
                                    <small class="text-muted">
                                        Quản lý thông tin hồ sơ để bảo mật tài khoản
                                    </small>
                                </div>
                            </div>

                            <form action="edit-profile" method="post" id="profileForm">

                                <div class="mb-3">
                                    <label class="form-label">Họ & tên</label>
                                    <input type="text" name="fullname"
                                           value="<%= u.getFullname() %>"
                                           class="form-control edit-field" disabled>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Email</label>
                                    <input type="email" name="email"
                                           value="<%= u.getEmail() %>"
                                           class="form-control edit-field" disabled>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Số điện thoại</label>
                                    <input type="text" name="phone"
                                           value="<%= u.getPhone() %>"
                                           class="form-control edit-field" disabled>
                                </div>

                                <div class="delete-box d-flex justify-content-between align-items-center mt-4">

                                    <div>
                                        <!-- Nút chỉnh sửa -->
                                        <button type="button"
                                                class="btn btn-edit"
                                                id="editBtn"
                                                onclick="enableEdit()">
                                            Chỉnh sửa
                                        </button>

                                        <!-- Nút lưu -->
                                        <button type="submit"
                                                form="profileForm"
                                                class="btn btn-success d-none"
                                                id="saveBtn">
                                            Lưu thay đổi
                                        </button>
                                    </div>

                                    <!-- Nút xóa -->
                                    <button type="button"
                                            class="btn btn-delete"
                                            onclick="confirmDelete()">
                                        Xóa tài khoản
                                    </button>

                                </div>
                            </form>

                        </div>


                        <!-- TAB 2: ĐỔI MẬT KHẨU -->
                        <div id="passwordTab" style="display:none;">

                            <div class="text-center mb-4">
                                <h4 class="fw-bold">Đổi mật khẩu</h4>
                                <p class="text-muted">Cập nhật mật khẩu để bảo vệ tài khoản của bạn</p>
                            </div>

                            <form method="post" action="change-password">

                                <div class="mb-3">
                                    <label class="form-label">Mật khẩu cũ</label>
                                    <input type="password" name="oldPassword"
                                           class="form-control" required>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Mật khẩu mới</label>
                                    <input type="password" name="newPassword"
                                           class="form-control" required>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Xác nhận mật khẩu</label>
                                    <input type="password" name="confirmPassword"
                                           class="form-control" required>
                                </div>

                                <button type="submit" class="btn btn-success w-100">
                                    Đổi mật khẩu
                                </button>
                            </form>

                            <c:if test="${not empty error}">
                                <div class="alert alert-danger mt-3 text-center">
                                    ${error}
                                </div>
                            </c:if>

                            <c:if test="${not empty success}">
                                <div class="alert alert-success mt-3 text-center">
                                    ${success}
                                </div>
                                <c:remove var="success" scope="session"/>
                            </c:if>

                        </div>

                    </div>

                </div>

            </div>
        </div>

        <!-- SweetAlert -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

        <script>
                                                function enableEdit() {

                                                    // Bỏ disabled input
                                                    document.querySelectorAll('.edit-field').forEach(el => {
                                                        el.removeAttribute("disabled");
                                                    });

                                                    // Ẩn nút chỉnh sửa
                                                    document.getElementById("editBtn").classList.add("d-none");

                                                    // Hiện nút lưu
                                                    document.getElementById("saveBtn").classList.remove("d-none");
                                                }
        </script>

        <c:if test="${not empty profileSuccess}">
            <script>
                Swal.fire({
                    icon: 'success',
                    title: 'Thành công!',
                    text: '${profileSuccess}',
                    showConfirmButton: false,
                    timer: 2500
                });
            </script>
            <c:remove var="profileSuccess" scope="session"/>
        </c:if>
        <c:if test="${not empty passwordSuccess}">
            <script>
                showTab('passwordTab');
                Swal.fire({
                    icon: 'success',
                    title: 'Thành công!',
                    text: '${passwordSuccess}',
                    showConfirmButton: false,
                    timer: 2500
                });
            </script>
            <c:remove var="passwordSuccess" scope="session"/>
        </c:if>
        <c:if test="${not empty error}">
            <script>
                showTab('passwordTab');
            </script>
        </c:if>
    </body>
</html>
<script>
    function showTab(tabId) {
        document.getElementById("profileTab").style.display = "none";
        document.getElementById("passwordTab").style.display = "none";

        document.getElementById(tabId).style.display = "block";
    }
</script>
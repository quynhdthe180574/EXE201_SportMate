<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Đổi mật khẩu | Sport Mate</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

        <style>
            body {
                margin: 0;
                min-height: 100vh;
                background: #f3f5f7;
                display: flex;
                justify-content: center;
                align-items: center;
                font-family: 'Segoe UI', sans-serif;
            }

            .card-box {
                width: 100%;
                max-width: 500px;
                background: #fff;
                padding: 40px;
                border-radius: 16px;
                box-shadow: 0 15px 40px rgba(0,0,0,0.08);
            }

            .lock-icon {
                width: 70px;
                height: 70px;
                background: #e8f5e9;
                color: #198754;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 28px;
                margin: 0 auto 20px auto;
            }

            .card-box h3 {
                text-align: center;
                font-weight: 700;
                margin-bottom: 10px;
            }

            .card-box p {
                text-align: center;
                color: #6c757d;
                margin-bottom: 30px;
            }

            .form-label {
                font-weight: 500;
            }

            .form-control {
                height: 45px;
                border-radius: 10px;
            }

            .form-control:focus {
                border-color: #198754;
                box-shadow: 0 0 0 0.2rem rgba(25,135,84,0.25);
            }

            .input-group-text {
                background: transparent;
                border-left: 0;
            }

            .btn-main {
                background: #198754;
                border: none;
                height: 48px;
                font-weight: 600;
                border-radius: 10px;
            }

            .btn-main:hover {
                background: #157347;
            }

            .bottom-link {
                text-align: center;
                margin-top: 20px;
            }

            .bottom-link a {
                text-decoration: none;
                color: #198754;
                font-weight: 500;
            }

            .alert {
                margin-top: 15px;
            }
        </style>
    </head>

    <body>

        <div class="card-box">

            <div class="lock-icon">
                <i class="bi bi-lock"></i>
            </div>

            <h3>Đổi mật khẩu</h3>
            <p>Cập nhật mật khẩu để bảo vệ tài khoản của bạn</p>

            <form method="post" action="change-password">

                <div class="mb-3">
                    <label class="form-label">Mật khẩu cũ</label>
                    <div class="input-group">
                        <input type="password" name="oldPassword"
                               class="form-control"
                               placeholder="Nhập mật khẩu cũ" required>
                        <span class="input-group-text">
                            <i class="bi bi-eye"></i>
                        </span>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Mật khẩu mới</label>
                    <div class="input-group">
                        <input type="password" name="newPassword"
                               class="form-control"
                               placeholder="Nhập mật khẩu mới" required>
                        <span class="input-group-text">
                            <i class="bi bi-eye"></i>
                        </span>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Xác nhận mật khẩu</label>
                    <div class="input-group">
                        <input type="password" name="confirmPassword"
                               class="form-control"
                               placeholder="Nhập lại mật khẩu mới" required>
                        <span class="input-group-text">
                            <i class="bi bi-eye"></i>
                        </span>
                    </div>
                </div>

                <button type="submit" class="btn btn-main w-100 text-white">
                    Đổi mật khẩu
                </button>

            </form>

            <!-- Thông báo lỗi -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger text-center">
                    ${error}
                </div>
            </c:if>

            <!-- Thông báo thành công -->
            <c:if test="${not empty success}">
                <div class="alert alert-success text-center">
                    ${success}
                </div>
                <c:remove var="success" scope="session"/>
            </c:if>

        </div>

    </body>
</html>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Đăng ký | Sport Mate</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

        <style>
            body {
                margin: 0;
                font-family: 'Segoe UI', sans-serif;
                height: 100vh;
                overflow: hidden;
            }

            .left-side {
                background: linear-gradient(rgba(0,0,0,0.55), rgba(0,0,0,0.55)),
                    url('image/register.png');
                background-size: cover;
                background-position: center;
                color: white;
                padding: 60px;
                display: flex;
                flex-direction: column;
                justify-content: space-between;
            }

            .brand {
                font-size: 40px;
                font-weight: 700;
            }
            .tagline {
                margin-top: 210px;   /* chỉnh 100px–200px tuỳ bạn */
            }
            .tagline h2 {
                font-weight: 700;
                margin-bottom: 20px;
            }

            .feature {
                display: flex;
                align-items: start;
                gap: 10px;
                margin-bottom: 15px;
            }

            .feature i {
                font-size: 20px;
                color: #28a745;
            }

            .right-side {
                background: #f8f9fa;
                padding: 60px;
                display: flex;
                align-items: center;
            }

            .form-wrapper {
                width: 100%;
                max-width: 420px;
                margin: auto;
            }

            .form-wrapper h3 {
                font-weight: 700;
            }

            .form-control {
                height: 45px;
            }

            .form-control:focus {
                border-color: #28a745;
                box-shadow: 0 0 0 0.2rem rgba(40,167,69,0.25);
            }

            .btn-main {
                background: #198754;
                border: none;
                font-weight: 600;
                height: 45px;
            }

            .btn-main:hover {
                background: #157347;
            }

            .small-link {
                font-size: 14px;
            }

            @media (max-width: 992px) {
                .left-side {
                    display: none;
                }
                body {
                    overflow: auto;
                }
            }
        </style>
    </head>

    <body>

        <div class="container-fluid">
            <div class="row vh-100">

                <!-- LEFT SIDE -->
                <div class="col-lg-7 left-side d-none d-lg-flex">

                    <div class="brand">
                        SPORT MATE
                        <div style="font-size:17px; font-weight:400;">Đặt sân thể thao trực tuyến</div>
                    </div>

                    <div class="tagline">
                        <h2>Đặt sân dễ dàng,<br>chơi thể thao thoải mái</h2>
                        <p>
                            Nền tảng đặt sân thể thao trực tuyến.
                            Kết nối bạn với hàng nghìn sân bóng, cầu lông, tennis và nhiều hơn nữa.
                        </p>

                        <div class="mt-4">
                            <div class="feature">
                                <i class="bi bi-geo-alt-fill"></i>
                                <div>
                                    <strong>Tìm sân gần bạn</strong><br>
                                    <small>Hệ thống sân thể thao rộng khắp.</small>
                                </div>
                            </div>

                            <div class="feature">
                                <i class="bi bi-lightning-fill"></i>
                                <div>
                                    <strong>Đặt sân nhanh chóng</strong><br>
                                    <small>Chỉ vài bước đơn giản.</small>
                                </div>
                            </div>

                            <div class="feature">
                                <i class="bi bi-shield-check"></i>
                                <div>
                                    <strong>Thanh toán an toàn</strong><br>
                                    <small>Bảo mật thông tin tuyệt đối.</small>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div></div>

                </div>

                <!-- RIGHT SIDE -->
                <div class="col-lg-5 right-side">

                    <div class="form-wrapper">

                        <h3>Tạo tài khoản</h3>
                        <p class="text-muted">
                            Đăng ký ngay để trải nghiệm đặt sân nhanh chóng và nhận nhiều ưu đãi hấp dẫn.
                        </p>

                        <form action="register" method="post">

                            <div class="mb-3">
                                <label>Họ và tên</label>
                                <input name="fullname" class="form-control"
                                       value="${fullname}" placeholder="Nguyễn Văn A" required>
                            </div>

                            <div class="mb-3">
                                <label>Email</label>
                                <input name="email" type="email"
                                       class="form-control"
                                       value="${email}" placeholder="you@email.com" required>
                            </div>

                            <div class="mb-3">
                                <label>Số điện thoại</label>
                                <input name="phone" class="form-control"
                                       value="${phone}" placeholder="0123 456 789" required>
                            </div>

                            <div class="mb-3">
                                <label>Mật khẩu</label>
                                <input type="password" name="password"
                                       class="form-control"
                                       placeholder="••••••••" required>
                            </div>

                            <div class="mb-3">
                                <label>Xác nhận mật khẩu</label>
                                <input type="password" name="confirmPassword"
                                       class="form-control"
                                       placeholder="Nhập lại mật khẩu" required>
                            </div>

                            <%
                                String error = (String) request.getAttribute("error");
                                if (error != null && !error.trim().isEmpty()) {
                            %>
                            <div class="alert alert-danger text-center">
                                <%= error %>
                            </div>
                            <%
                                }
                            %>

                            <button class="btn btn-main w-100 mt-2 text-white">
                                TẠO TÀI KHOẢN
                            </button>

                        </form>

                        <div class="text-center mt-3 small-link">
                            Đã có tài khoản?
                            <a href="login.jsp" class="text-success text-decoration-none">
                                Đăng nhập
                            </a>
                        </div>

                    </div>

                </div>

            </div>
        </div>

    </body>
</html>
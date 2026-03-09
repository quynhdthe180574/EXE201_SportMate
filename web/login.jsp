<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Đăng nhập | Sport Mate</title>

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
                background: linear-gradient(rgba(0,0,0,0.55), rgba(0,128,0,0.55)),
                    url('image/login.png');
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
            .hero-text {
                margin-top: 250px;
            }
            .hero-text h1 {
                font-size: 48px;
                font-weight: 800;
                line-height: 1.2;
            }

            .hero-text span {
                color: #28a745;
            }

            .stats {
                display: flex;
                gap: 30px;
                margin-top: 30px;
            }

            .stat-box {
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .stat-box i {
                font-size: 22px;
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
                border-color: #198754;
                box-shadow: 0 0 0 0.2rem rgba(25,135,84,0.25);
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

            .divider {
                display: flex;
                align-items: center;
                text-align: center;
                margin: 20px 0;
            }

            .divider::before,
            .divider::after {
                content: "";
                flex: 1;
                border-bottom: 1px solid #ccc;
            }

            .divider span {
                margin: 0 10px;
                color: #777;
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
                        <div style="font-size:20px; font-weight:400;">
                            Nền tảng đặt sân thể thao
                        </div>
                    </div>

                    <div class="hero-text">
                        <h1>
                            ĐẶT SÂN <br>
                            <span>THỂ THAO</span><br>
                            DỄ DÀNG
                        </h1>

                        <p class="mt-3">
                            Tìm và đặt sân thể thao gần bạn chỉ với vài thao tác.
                            Nhanh chóng, tiện lợi và đáng tin cậy.
                        </p>

                        <div class="stats">
                            <div class="stat-box">
                                <i class="bi bi-geo-alt-fill"></i>
                                <div>
                                    <strong>5+sân thể thao</strong><br>
                                    <small>Khu vực Hòa Lạc</small>
                                </div>
                            </div>

                            <div class="stat-box">
                                <i class="bi bi-clock-fill"></i>
                                <div>
                                    <strong>Đặt sân 24/7</strong><br>
                                    <small>Nhanh chóng, tiện lợi</small>
                                </div>
                            </div>

                            <div class="stat-box">
                                <i class="bi bi-shield-check"></i>
                                <div>
                                    <strong>Bảo mật</strong><br>
                                    <small>An toàn, tin cậy</small>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div></div>

                </div>

                <!-- RIGHT SIDE -->
                <div class="col-lg-5 right-side">

                    <div class="form-wrapper">

                        <h3>Đăng nhập</h3>
                        <p class="text-muted">
                            Đăng nhập để đặt sân và quản lý lịch trình của bạn
                        </p>

                        <form action="login" method="post">

                            <div class="mb-3">
                                <label>Email</label>
                                <input name="email" type="email"
                                       class="form-control"
                                       placeholder="your@email.com" required>
                            </div>

                            <div class="mb-3">
                                <div class="d-flex justify-content-between">
                                    <label>Mật khẩu</label>
                                    <a href="forgot-password.jsp" class="text-success small">Quên mật khẩu?</a>
                                </div>
                                <input type="password" name="password"
                                       class="form-control"
                                       placeholder="Nhập mật khẩu" required>
                            </div>

                            <button class="btn btn-main w-100 text-white mt-2">
                                ĐĂNG NHẬP
                            </button>

                        </form>

                        <div class="text-danger text-center mt-3">
                            ${error}
                        </div>

                        <div class="text-center mt-3">
                            <small>
                                Chưa có tài khoản?
                                <a href="register.jsp" class="text-success">
                                    Đăng ký ngay
                                </a>
                            </small>
                        </div>

                        <div class="text-center mt-4 text-muted small">
                            © 2026 Sport Mate. All rights reserved.
                        </div>

                    </div>

                </div>

            </div>
        </div>

    </body>
</html>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Đăng ký trở thành Chủ sân</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">

        <style>
            body {
                background-color: #f3faf1;
                font-family: 'Segoe UI', sans-serif;
            }

            /* HERO */
            .hero {
                background: linear-gradient(rgba(0,0,0,0.55), rgba(0,0,0,0.55)),
                    url('https://theexpgroup.com/cdn/shop/articles/Football-business-strategy_ef119916-2b13-4e26-9d9f-75eff0e52563.png?v=1762521690&width=1280');
                background-size: cover;
                background-position: center;
                padding: 100px 0;
                text-align: center;
                color: white;
            }

            .hero .badge {
                background: rgba(255,255,255,0.2);
                padding: 6px 15px;
                border-radius: 20px;
                font-size: 13px;
                margin-bottom: 15px;
            }

            .hero h1 {
                font-weight: 700;
            }

            /* FORM CARD */
            .form-card {
                max-width: 550px;
                margin: -60px auto 60px auto;
                background: white;
                padding: 30px;
                border-radius: 15px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            }

            .btn-green {
                background-color: #1e7e34;
                border: none;
                font-weight: 600;
                padding: 10px;
            }

            .btn-green:hover {
                background-color: #166c2a;
            }

            /* SECTION TITLE */
            .section-title {
                text-align: center;
                margin-bottom: 40px;
            }

            /* REASON BOX */
            .reason-box {
                background: white;
                padding: 20px;
                border-radius: 12px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.05);
                text-align: center;
                transition: 0.3s;
            }

            .reason-box:hover {
                transform: translateY(-4px);
                box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            }

            .reason-icon {
                font-size: 22px;
                color: #1e7e34;
                margin-bottom: 10px;
            }

            .highlight-box {
                max-width: 400px;
                margin: 40px auto 0 auto;
                background: #e6f4ea;
                padding: 25px;
                border-radius: 14px;
                text-align: center;
            }
            .reason-icon {
                width: 60px;
                height: 60px;
                margin: 0 auto 15px auto;
                background: #e6f4ea;
                border-radius: 16px;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .reason-icon i {
                font-size: 26px;
                color: #198754;
            }
            .btn-green {
                background-color: #1e7e34;
                border: none;
                font-weight: 600;
                padding: 12px;
                font-size: 18px;   /* chữ to hơn */
                color: white;      /* chữ trắng */
            }
        </style>
    </head>

    <body>

        <!-- HERO -->
        <div class="hero">
            <div class="container">                
                <h1>Đăng ký trở thành Chủ sân</h1>
                <p>Gia nhập nền tảng đặt sân thể thao lớn nhất Việt Nam và tăng trưởng doanh thu của bạn ngay hôm nay.</p>
            </div>
        </div>

        <!-- FORM -->
        <div class="form-card">

            <h3 class="mb-3">Thông tin đăng ký</h3>
            <p class="text-muted" style="font-size:14px;">
                Vui lòng điền đầy đủ thông tin bên dưới. Chúng tôi sẽ xem xét và phản hồi trong thời gian sớm nhất.
            </p>

            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>
            <c:if test="${not empty success}">
                <div class="alert alert-success">${success}</div>
            </c:if>
            <form action="become-owner" method="post">

                <div class="mb-3">
                    <label class="form-label">Số điện thoại *</label>
                    <input type="text" name="phone" class="form-control" placeholder="VD: 0901234567" required>
                    <small class="text-muted">Nhập số điện thoại để chúng tôi có thể liên hệ với bạn</small>
                </div>

                <div class="mb-3">
                    <label class="form-label">Địa chỉ sân *</label>
                    <input type="text" name="address" class="form-control" placeholder="VD: 123 Nguyễn Huệ, Quận 1, TP.HCM" required>
                    <small class="text-muted">Địa chỉ cụ thể nơi sân đang hoạt động</small>
                </div>

                <div class="mb-4">
                    <label class="form-label">Mô tả sân</label>
                    <textarea name="description" rows="4" class="form-control"
                              placeholder="VD: Sân bóng đá 5 người, có đèn chiếu sáng, có chỗ đậu xe..."></textarea>
                    <small class="text-muted">Mô tả cơ sở vật chất, loại sân, dịch vụ đi kèm...</small>
                </div>

                <button type="submit" class="btn btn-green w-100">
                    Gửi yêu cầu đăng ký
                </button>

            </form>

        </div>

        <!-- REASON SECTION -->
        <div class="container mb-5">

            <div class="section-title">
                <h2>Tại sao nên trở thành đối tác của chúng tôi?</h2>
                <p class="text-muted">
                    Tham gia nền tảng đặt sân thể thao hàng đầu để tăng trưởng kinh doanh của bạn.
                </p>
            </div>

            <div class="row g-4">

                <div class="col-md-4">
                    <div class="reason-box">
                        <div class="reason-icon">
                            <i class="bi bi-graph-up-arrow"></i>
                        </div>
                        <h6>Tăng doanh thu</h6>
                        <small>Tiếp cận hàng nghìn người chơi mỗi ngày</small>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="reason-box">
                        <div class="reason-icon">
                            <i class="bi bi-calendar-check"></i>
                        </div>
                        <h6>Quản lý lịch đặt</h6>
                        <small>Hệ thống tự động quản lý lịch sân và thông báo</small>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="reason-box">
                        <div class="reason-icon">
                            <i class="bi bi-people"></i>
                        </div>
                        <h6>Mở rộng khách hàng</h6>
                        <small>Kết nối cộng đồng thể thao trên toàn quốc</small>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="reason-box">
                        <div class="reason-icon">
                            <i class="bi bi-bar-chart-line"></i>
                        </div>
                        <h6>Báo cáo chi tiết</h6>
                        <small>Theo dõi doanh thu, lượt đặt và đánh giá khách hàng</small>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="reason-box">
                        <div class="reason-icon">
                            <i class="bi bi-clock"></i>
                        </div>
                        <h6>Tiết kiệm thời gian</h6>
                        <small>Tự động hóa quy trình đặt sân và giảm thao tác thủ công</small>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="reason-box">
                        <div class="reason-icon">
                            <i class="bi bi-shield-check"></i>
                        </div>
                        <h6>An toàn & Tin cậy</h6>
                        <small>Bảo mật thanh toán và hỗ trợ 24/7</small>
                    </div>
                </div>

            </div>          

        </div>
        <!-- SUCCESS MODAL -->
        <div class="modal fade" id="successModal" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content text-center p-4">
                    <div class="modal-body">
                        <h4 class="text-success">🎉 Đăng ký thành công!</h4>
                        <p class="mt-3">
                            Yêu cầu của bạn đã được gửi. 
                            Bạn sẽ được chuyển về trang chủ...
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <!-- ERROR MODAL -->
        <div class="modal fade" id="errorModal" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content text-center p-4">
                    <div class="modal-body">
                        <h4 class="text-danger">❌ Đăng ký thất bại!</h4>
                        <p class="mt-3">
                            Có lỗi xảy ra. Vui lòng thử lại.
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <!-- DUPLICATE MODAL -->
        <div class="modal fade" id="duplicateModal" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content text-center p-4">
                    <div class="modal-body">
                        <h4 class="text-warning">⚠ Bạn đã gửi yêu cầu trước đó</h4>
                        <p class="mt-3">
                            Yêu cầu của bạn đang chờ admin duyệt.
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

        <c:if test="${param.success == 'true'}">
            <script>
                var myModal = new bootstrap.Modal(document.getElementById('successModal'));
                myModal.show();

                // Sau 2.5 giây chuyển về home
                setTimeout(function () {
                    window.location.href = "home";
                }, 2500);
            </script>
        </c:if>
        <c:if test="${param.error == 'true'}">
            <script>
                var errorModal = new bootstrap.Modal(document.getElementById('errorModal'));
                errorModal.show();
            </script>
        </c:if>

        <c:if test="${param.duplicate == 'true'}">
            <script>
                var duplicateModal = new bootstrap.Modal(document.getElementById('duplicateModal'));
                duplicateModal.show();
            </script>
        </c:if>
    </body>
</html>
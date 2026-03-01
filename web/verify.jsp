<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Xác thực tài khoản | Sport Mate</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
        }
        .card {
            background: #111;
            color: #fff;
            border-radius: 15px;
        }
        .form-control {
            background: #1c1c1c;
            border: 1px solid #333;
            color: #fff;
        }
        .btn-main {
            background: linear-gradient(90deg, #28a745, #5ddf72);
            border: none;
            font-weight: bold;
        }
    </style>
</head>
<body>

<div class="container d-flex justify-content-center align-items-center" style="min-height:100vh">
    <div class="card p-4" style="width:400px">

        <div class="text-center mb-3">
            <h4>Nhập mã xác thực</h4>
            <small class="text-success">
                Mã OTP đã được gửi về email của bạn
            </small>
        </div>

        <form action="verify" method="post">

            <div class="mb-3">
                <label>Mã OTP</label>
                <input type="text" name="otp" 
                       class="form-control text-center" 
                       placeholder="Nhập 6 số OTP" required>
            </div>

            <button class="btn btn-main w-100">
                XÁC THỰC
            </button>
        </form>

        <div class="text-danger text-center mt-3">
            ${error}
        </div>

    </div>
</div>

</body>
</html>
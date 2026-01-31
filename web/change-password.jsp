<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đổi mật khẩu</title>

    <style>
        body {
            margin: 0;
            min-height: 100vh;
            background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
            display: flex;
            justify-content: center;
            align-items: center;
            font-family: Arial, sans-serif;
        }

        .card {
            width: 360px;
            background: #fff;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.25);
        }

        .card h2 {
            text-align: center;
            margin-bottom: 25px;
            color: #333;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group input {
            width: 100%;
            padding: 10px 12px;
            border-radius: 6px;
            border: 1px solid #ccc;
            outline: none;
            font-size: 14px;
        }

        .form-group input:focus {
            border-color: #2c5364;
        }

        .btn-submit {
            width: 100%;
            padding: 10px;
            border: none;
            border-radius: 6px;
            background: #2c5364;
            color: white;
            font-weight: bold;
            cursor: pointer;
            transition: 0.3s;
        }

        .btn-submit:hover {
            background: #203a43;
        }

        .msg-error {
            margin-top: 15px;
            color: #d9534f;
            text-align: center;
            font-size: 14px;
        }

        .msg-success {
            margin-top: 15px;
            color: #28a745;
            text-align: center;
            font-size: 14px;
        }
    </style>
</head>

<body>

<div class="card">
    <h2>Đổi mật khẩu</h2>

    <form method="post" action="change-password">
        <div class="form-group">
            <input type="password" name="oldPassword"
                   placeholder="Mật khẩu cũ" required>
        </div>

        <div class="form-group">
            <input type="password" name="newPassword"
                   placeholder="Mật khẩu mới" required>
        </div>

        <div class="form-group">
            <input type="password" name="confirmPassword"
                   placeholder="Xác nhận mật khẩu" required>
        </div>

        <button type="submit" class="btn-submit">
            Đổi mật khẩu
        </button>
    </form>

    <div class="msg-error">${error}</div>
    <div class="msg-success">${success}</div>
</div>

</body>
</html>

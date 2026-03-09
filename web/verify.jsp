<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Xác thực tài khoản | Sport Mate</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<style>

body{
    background: linear-gradient(135deg,#f6f9fc,#e9f7ef);
    height:100vh;
    display:flex;
    justify-content:center;
    align-items:center;
    font-family:Segoe UI;
}

.card-box{
    width:420px;
    background:white;
    border-radius:16px;
    padding:35px;
    text-align:center;
    box-shadow:0 8px 30px rgba(0,0,0,0.08);
}

.logo{
    background:#22a95a;
    width:45px;
    height:45px;
    border-radius:12px;
    display:flex;
    align-items:center;
    justify-content:center;
    margin:auto;
    margin-bottom:12px;
    color:white;
    font-weight:bold;
}

h4{
    font-weight:600;
}

.otp-group{
    display:flex;
    justify-content:space-between;
    margin:25px 0;
}

.otp-input{
    width:50px;
    height:55px;
    border:1px solid #dcdcdc;
    border-radius:10px;
    text-align:center;
    font-size:20px;
    font-weight:600;
}

.otp-input:focus{
    border-color:#22a95a;
    outline:none;
    box-shadow:0 0 0 2px rgba(34,169,90,0.15);
}

.btn-verify{
    width:100%;
    background:#22a95a;
    border:none;
    padding:12px;
    border-radius:10px;
    color:white;
    font-weight:600;
}

.btn-verify:hover{
    background:#1c944e;
}

.link{
    font-size:14px;
}

</style>

<script>
function moveNext(current,next){
    if(current.value.length>=1){
        document.getElementById(next).focus();
    }
}

function combineOTP(){
    let otp="";
    for(let i=1;i<=6;i++){
        otp+=document.getElementById("otp"+i).value;
    }
    document.getElementById("otp").value=otp;
}
</script>

</head>

<body>

<div class="card-box">

    <h3>Nhập mã xác thực</h3>

    <small class="text-muted">
        Mã OTP đã được gửi về email của bạn
    </small>

    <form action="verify" method="post" onsubmit="combineOTP()">

        <div class="otp-group">
            <input id="otp1" maxlength="1" class="otp-input" onkeyup="moveNext(this,'otp2')">
            <input id="otp2" maxlength="1" class="otp-input" onkeyup="moveNext(this,'otp3')">
            <input id="otp3" maxlength="1" class="otp-input" onkeyup="moveNext(this,'otp4')">
            <input id="otp4" maxlength="1" class="otp-input" onkeyup="moveNext(this,'otp5')">
            <input id="otp5" maxlength="1" class="otp-input" onkeyup="moveNext(this,'otp6')">
            <input id="otp6" maxlength="1" class="otp-input">
        </div>

        <input type="hidden" name="otp" id="otp">

        <button class="btn-verify">
            XÁC THỰC
        </button>

    </form>

    <div class="text-danger mt-3">
        ${error}
    </div>

    <div class="mt-3 link">
        Không nhận được mã? 
        <a href="resendOTP" style="color:#22a95a;font-weight:500">
            Gửi lại mã
        </a>
    </div>

    <div class="mt-2 link">
        <a href="login.jsp" class="text-secondary">
            ← Quay lại đăng nhập
        </a>
    </div>

</div>

</body>
</html>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
/* ===== RESET BODY ĐỂ HEADER SÁT TRÊN ===== */
body {
    margin: 0;
    padding: 0;
}

/* ===== SITE HEADER ===== */
.site-header {
    background: linear-gradient(135deg, #1b5e20, #43a047);
    color: #ffffff;
    padding: 14px 0;
}

/* INNER */
.site-header .inner {
    max-width: 1200px;
    margin: 0 auto;
    padding: 0 20px;
    display: flex;
    align-items: center;
    justify-content: space-between;
}

/* LOGO */
.site-header .logo {
    font-size: 22px;
    font-weight: 800;
    letter-spacing: 1px;
}

/* NAV */
.site-header nav a {
    margin-left: 20px;
    font-weight: 600;
    font-size: 14px;
    color: #ffffff;
    opacity: 0.95;
    text-decoration: none;
}

.site-header nav a:hover {
    opacity: 1;
    text-decoration: underline;
}
</style>


<div class="site-header">
    <div class="inner">
        <div class="logo">🏟️ SPORTMATE</div>
        <nav>
            <a href="<%=request.getContextPath()%>/home">Trang chủ</a>
            <a href="<%=request.getContextPath()%>/fields">Sân thể thao</a>
            <a href="<%=request.getContextPath()%>/booking">Đặt sân</a>
            <a href="<%=request.getContextPath()%>/contact">Liên hệ</a>
        </nav>
    </div>
</div>

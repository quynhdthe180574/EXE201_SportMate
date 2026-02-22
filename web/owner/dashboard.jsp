<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:include page="header.jsp" />

<style>
    .stats {
        display:grid;
        grid-template-columns:repeat(auto-fit, minmax(240px,1fr));
        gap:25px;
        margin:40px 0;
    }
    .card {
        background:var(--white);
        border-radius:16px;
        padding:28px;
        text-align:center;
        box-shadow:0 6px 20px rgba(0,0,0,0.08);
        transition:transform 0.3s, box-shadow 0.3s;
    }
    .card:hover {
        transform:translateY(-8px);
        box-shadow:0 12px 30px rgba(0,0,0,0.12);
    }
    .card h3 {
        color:var(--green-pastel);
        margin-bottom:12px;
        font-size:1.15rem;
    }
    .card p {
        font-size:3rem;
        font-weight:700;
        color:#555;
        margin:0;
    }
    table {
        width:100%;
        border-collapse:collapse;
        background:var(--yellow-pastel);
        border-radius:12px;
        overflow:hidden;
        margin-top:30px;
    }
    th {
        background:var(--blue-pastel);
        color:white;
        padding:16px;
    }
    td {
        padding:16px;
        border-bottom:1px solid #eee;
    }
    tr:hover {
        background:var(--orange-pastel);
    }
    .actions a {
        padding:8px 16px;
        border-radius:8px;
        text-decoration:none;
        margin-right:12px;
        font-weight:500;
    }
    .edit {
        background:var(--green-pastel);
        color:#333;
    }
    .hide {
        background:var(--pink-pastel);
        color:#333;
    }
    .add-btn {
        display:inline-block;
        margin:40px 0;
        padding:16px 40px;
        background:var(--purple-pastel);
        color:white;
        border-radius:50px;
        text-decoration:none;
        font-size:1.1rem;
        font-weight:bold;
        transition:0.3s;
    }
    .add-btn:hover {
        background:var(--pink-pastel);
        transform:scale(1.05);
    }
    .no-data {
        text-align:center;
        color:#777;
        font-size:1.3rem;
        padding:40px 0;
        font-style:italic;
    }
</style>

<h1 style="text-align:center; color:var(--blue-pastel); margin-bottom:20px;">Dashboard Chủ Sân</h1>

<div class="stats">
    <div class="card"><h3>Tổng số sân</h3><p>${venueCount}</p></div>
    <div class="card"><h3>Tổng booking</h3><p>${bookingCount}</p></div>
    <div class="card"><h3>Doanh thu sơ bộ</h3><p>${revenue} ₫</p></div>
</div>

<h2 style="color:var(--blue-pastel); margin:40px 0 20px;">Danh sách sân của bạn</h2>


<c:if test="${not empty venues}">
    <table>
        <tr>
            <th>ID</th>
            <th>Tên sân</th>
            <th>Địa chỉ</th>
            <th>Giờ mở – đóng</th>
            <th>Trạng thái</th>
            <th>Thao tác</th>
        </tr>

        <c:forEach items="${venues}" var="v">
            <tr>
                <td>${v.venueId}</td>
                <td>${v.venueName}</td>
                <td>${v.addressDetail}</td>
                <td>${v.openTime} – ${v.closeTime}</td>
                <td style="color:${v.status == 'Hoạt động' ? '#4CAF50' : '#f44336'}; font-weight: bold;">
                    ${v.status}
                </td>
                <td class="actions">
                    <a href="${pageContext.request.contextPath}/owner/edit-venue?id=${v.venueId}" class="edit">Sửa</a>
                    <a href="${pageContext.request.contextPath}/owner/hide-venue?id=${v.venueId}" class="hide" onclick="return confirm('Ẩn sân này?')">Ẩn</a>
                </td>
            </tr>
        </c:forEach>
    </table>
</c:if>

<c:if test="${empty venues}">
    <p class="no-data">Bạn chưa có sân nào. Hãy thêm sân mới ngay!</p>
</c:if>

<a href="${pageContext.request.contextPath}/owner/add-venue" class="add-btn">+ Thêm sân mới</a>

<jsp:include page="footer.jsp" />
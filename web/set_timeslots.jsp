<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="header.jsp" />

<style>
    .form-box { max-width:600px; margin:60px auto; background:var(--white); padding:50px; border-radius:20px; box-shadow:0 10px 40px rgba(0,0,0,0.12); }
    h1 { text-align:center; color:var(--blue-pastel); margin-bottom:40px; }
    label { display:block; margin:20px 0 8px; font-weight:600; color:#555; }
    input, select { width:100%; padding:14px; border:2px solid var(--green-pastel); border-radius:10px; font-size:1rem; }
    input:focus, select:focus { border-color:var(--pink-pastel); outline:none; box-shadow:0 0 0 4px rgba(255,193,204,0.25); }
    button { width:100%; padding:16px; margin-top:40px; background:var(--purple-pastel); color:white; border:none; border-radius:12px; font-size:1.15rem; font-weight:bold; cursor:pointer; }
    button:hover { background:var(--pink-pastel); }
</style>

<div class="form-box">
    <h1>Thiết Lập Khung Giờ</h1>
    <form action="${pageContext.request.contextPath}/owner/set-timeslots" method="post">
        <label>Giờ bắt đầu (HH:mm):</label>
        <input type="time" name="start_time" required>

        <label>Giờ kết thúc (HH:mm):</label>
        <input type="time" name="end_time" required>

        <label>Trạng thái:</label>
        <select name="status">
            <option value="Hoạt động">Hoạt động</option>
            <option value="Ngưng">Ngưng</option>
        </select>

        <button type="submit">Thêm khung giờ</button>
    </form>
</div>

<jsp:include page="footer.jsp" />
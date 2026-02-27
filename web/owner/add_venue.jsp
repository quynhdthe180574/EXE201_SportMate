<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="header.jsp" />

<style>
    .form-box {
        max-width:700px; margin:40px auto; background:var(--white);
        padding:50px; border-radius:20px; box-shadow:0 10px 40px rgba(0,0,0,0.12);
    }
    h1 { text-align:center; color:var(--blue-pastel); margin-bottom:40px; }
    label { display:block; margin:20px 0 8px; font-weight:600; color:#555; }
    input, textarea, select {
        width:100%; padding:14px; border:2px solid var(--green-pastel);
        border-radius:10px; font-size:1rem;
    }
    input:focus, textarea:focus {
        border-color:var(--pink-pastel); outline:none; box-shadow:0 0 0 4px rgba(255,193,204,0.25);
    }
    button {
        width:100%; padding:16px; margin-top:40px;
        background:var(--purple-pastel); color:white; border:none;
        border-radius:12px; font-size:1.15rem; font-weight:bold;
        cursor:pointer; transition:0.3s;
    }
    button:hover { background:var(--pink-pastel); transform:scale(1.02); }
    .file-input { margin:15px 0; }
</style>

<div class="form-box">
    <h1>Thêm Sân Mới</h1>
    <form action="${pageContext.request.contextPath}/owner/add-venue" method="post" 
          enctype="multipart/form-data">
        
        <label>Tên sân:</label>
        <input type="text" name="venue_name" required>

        <label>Tỉnh ID (1 = Hà Nội, 2 = TP.HCM):</label>
        <input type="number" name="province_id" min="1" max="2" required>

        <label>Quận ID:</label>
        <input type="number" name="district_id" required>

        <label>Địa chỉ chi tiết:</label>
        <input type="text" name="address_detail" required>

        <label>Mô tả sân:</label>
        <textarea name="description" rows="4"></textarea>

        <label>Giờ mở cửa (HH:mm):</label>
        <input type="time" name="open_time" required>

        <label>Giờ đóng cửa (HH:mm):</label>
        <input type="time" name="close_time" required>

        <label>Ảnh sân (có thể chọn nhiều ảnh):</label>
        <input type="file" name="venue_images" accept="image/*" multiple class="file-input">

        <button type="submit">Thêm sân mới</button>
    </form>
</div>

<jsp:include page="footer.jsp" />
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<jsp:include page="header.jsp" />

<style>
    .form-box { max-width:700px; margin:40px auto; background:var(--white); padding:50px; border-radius:20px; box-shadow:0 10px 40px rgba(0,0,0,0.12); }
    h1 { text-align:center; color:var(--blue-pastel); margin-bottom:40px; }
    label { display:block; margin:20px 0 8px; font-weight:600; color:#555; }
    input, textarea, select { width:100%; padding:14px; border:2px solid var(--green-pastel); border-radius:10px; font-size:1rem; }
    button { width:100%; padding:16px; margin-top:40px; background:var(--purple-pastel); color:white; border:none; border-radius:12px; font-size:1.15rem; font-weight:bold; cursor:pointer; }
</style>

<div class="form-box">
    <h1>Sửa Thông Tin Sân</h1>

    <form action="${pageContext.request.contextPath}/owner/edit-venue" method="post">

        <input type="hidden" name="venue_id" value="${venue.venueId}">

        <label>Tên sân:</label>
        <input type="text" name="venue_name" value="${venue.venueName}" required>

        <label>Tỉnh ID:</label>
        <input type="number" name="province_id" value="${venue.provinceId}" required>

        <label>Quận ID:</label>
        <input type="number" name="district_id" value="${venue.districtId}" required>

        <label>Địa chỉ chi tiết:</label>
        <input type="text" name="address_detail" value="${venue.addressDetail}" required>

        <label>Mô tả:</label>
        <textarea name="description" rows="4">${venue.description}</textarea>

        <label>Giờ mở cửa:</label>
        <input type="time" name="open_time"
               value="${fn:substring(venue.openTime,0,5)}" required>

        <label>Giờ đóng cửa:</label>
        <input type="time" name="close_time"
               value="${fn:substring(venue.closeTime,0,5)}" required>

        <label>Trạng thái:</label>
        <select name="status">
            <option value="Hoạt động" ${venue.status == 'Hoạt động' ? 'selected' : ''}>Hoạt động</option>
            <option value="Ẩn" ${venue.status == 'Ẩn' ? 'selected' : ''}>Ẩn</option>
        </select>

        <button type="submit">Cập nhật sân</button>
    </form>
</div>

<jsp:include page="footer.jsp" />

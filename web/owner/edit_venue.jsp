<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<jsp:include page="header.jsp" />

<style>
    .form-box { max-width: 900px; margin: 40px auto; background: var(--white); padding: 40px; border-radius: 20px; box-shadow: 0 10px 40px rgba(0,0,0,0.12); }
    h1 { text-align: center; color: var(--blue-pastel); margin-bottom: 30px; }
    label { display: block; margin: 25px 0 10px; font-weight: 600; color: #555; }
    input, textarea, select { width: 100%; padding: 14px; border: 2px solid var(--green-pastel); border-radius: 10px; font-size: 1rem; box-sizing: border-box; }
    button { width: 100%; padding: 16px; margin-top: 35px; background: var(--purple-pastel); color: white; border: none; border-radius: 12px; font-size: 1.15rem; font-weight: bold; cursor: pointer; transition: 0.3s; }
    button:hover { background: var(--pink-pastel); transform: scale(1.02); }
    .field-block { margin: 25px 0; padding: 20px; border: 1px solid #eee; border-radius: 12px; background: #fafafa; }
    .field-title { margin: 0 0 15px 0; color: var(--blue-pastel); font-size: 1.25rem; font-weight: 600; }
    .image-grid { display: flex; flex-wrap: wrap; gap: 15px; }
    .image-item { width: 200px; position: relative; }
    .image-item img { width: 100%; height: 140px; object-fit: cover; border-radius: 10px; border: 1px solid #ddd; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
    .no-image { color: #777; font-style: italic; padding: 15px 0; text-align: center; background: #f8f8f8; border-radius: 8px; }
    .file-input { margin: 15px 0; padding: 12px; border: 2px dashed #ccc; border-radius: 10px; background: #f9f9f9; text-align: center; }
</style>

<div class="form-box">
    <h1>Sửa Thông Tin Sân</h1>

    <form action="${pageContext.request.contextPath}/owner/edit-venue" method="post" enctype="multipart/form-data">

        <input type="hidden" name="venue_id" value="${venue.venueId}">

        <label>Tên sân:</label>
        <input type="text" name="venue_name" value="${venue.venueName}" required>

        <label>Tỉnh ID (1=Hà Nội, 2=TP.HCM):</label>
        <input type="number" name="province_id" value="${venue.provinceId}" min="1" max="2" required>

        <label>Quận ID:</label>
        <input type="number" name="district_id" value="${venue.districtId}" required>

        <label>Địa chỉ chi tiết:</label>
        <input type="text" name="address_detail" value="${venue.addressDetail}" required>

        <label>Mô tả sân:</label>
        <textarea name="description" rows="4">${venue.description}</textarea>

        <label>Giờ mở cửa (HH:mm):</label>
        <input type="time" name="open_time" 
               value="${fn:substring(venue.openTime != null ? venue.openTime.toString() : '', 0, 5)}" required>

        <label>Giờ đóng cửa (HH:mm):</label>
        <input type="time" name="close_time" 
               value="${fn:substring(venue.closeTime != null ? venue.closeTime.toString() : '', 0, 5)}" required>

        <label>Trạng thái:</label>
        <select name="status">
            <option value="Hoạt động" ${venue.status == 'Hoạt động' ? 'selected' : ''}>Hoạt động</option>
            <option value="Ẩn" ${venue.status == 'Ẩn' ? 'selected' : ''}>Ẩn</option>
        </select>

        <!-- Ảnh sân hiện tại -->
        <label style="margin-top: 40px; font-size: 1.2rem; color: #333;">Ảnh sân hiện tại (của các sân con):</label>

        <c:choose>
            <c:when test="${not empty fields}">
                <c:forEach items="${fields}" var="field">
                    <div class="field-block">
                        <div class="field-title">${field.fieldName} (Loại: ${field.sportTypeId})</div>

                        <c:choose>
                            <c:when test="${not empty field.imageUrls && field.imageUrls.size() > 0}">
                                <div class="image-grid">
                                    <c:forEach items="${field.imageUrls}" var="img">
                                        <div class="image-item">
                                            <img src="${img}" 
                                                 alt="${field.fieldName}"
                                                 onerror="this.onerror=null; this.src='https://via.placeholder.com/200x140?text=Ảnh+không+tải+được';"
                                                 loading="lazy">
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <p class="no-image">Chưa có ảnh cho sân này</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <p class="no-image" style="text-align: center; padding: 40px;">Chưa có sân con nào để hiển thị ảnh.</p>
            </c:otherwise>
        </c:choose>

        <!-- Upload ảnh mới -->
        <label style="margin-top: 40px;">Thêm ảnh mới (lưu chung cho sân - có thể mở rộng cho từng sân con sau):</label>
        <input type="file" name="venue_images" accept="image/*" multiple class="file-input">

        <button type="submit">Cập nhật sân</button>
    </form>
</div>

<jsp:include page="footer.jsp" />
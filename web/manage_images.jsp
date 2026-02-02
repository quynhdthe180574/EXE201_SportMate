<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="header.jsp" />

<style>
    .gallery { display:grid; grid-template-columns:repeat(auto-fill, minmax(220px,1fr)); gap:20px; margin:40px 0; }
    .img-card {
        background:var(--white); border-radius:12px; overflow:hidden;
        box-shadow:0 4px 15px rgba(0,0,0,0.08); transition:0.3s;
    }
    .img-card:hover { transform:scale(1.03); box-shadow:0 8px 25px rgba(0,0,0,0.12); }
    .img-card img { width:100%; height:180px; object-fit:cover; }
    .img-actions { padding:12px; text-align:center; }
    .delete-btn {
        background:var(--pink-pastel); color:white; border:none; padding:8px 16px;
        border-radius:8px; cursor:pointer; font-weight:bold;
    }
    form { margin:40px 0; text-align:center; }
    input[type="file"] { margin:20px 0; }
    button { padding:14px 40px; background:var(--purple-pastel); color:white; border:none; border-radius:12px; cursor:pointer; font-size:1.1rem; }
    button:hover { background:var(--pink-pastel); }
</style>

<div style="text-align:center;">
    <h1 style="color:var(--blue-pastel);">Quản Lý Hình Ảnh Sân (Field ID: ${field_id})</h1>

    <form action="${pageContext.request.contextPath}/owner/manage-images" method="post" enctype="multipart/form-data">
        <input type="hidden" name="field_id" value="${field_id}">
        <input type="file" name="image" accept="image/*" required>
        <button type="submit">Upload Ảnh Mới</button>
    </form>

    <div class="gallery">
        <c:forEach var="img" items="${images}">
            <div class="img-card">
                <img src="${pageContext.request.contextPath}/${img.imageUrl}" alt="Field Image">
                <div class="img-actions">
                    <a href="${pageContext.request.contextPath}/owner/delete-image?image_id=${img.imageId}&field_id=${field_id}" 
                       class="delete-btn" onclick="return confirm('Xóa ảnh này?')">Xóa</a>
                </div>
            </div>
        </c:forEach>
    </div>

    <c:if test="${empty images}">
        <p style="color:#777; font-size:1.2rem;">Chưa có ảnh nào. Hãy upload ảnh đầu tiên!</p>
    </c:if>
</div>

<jsp:include page="footer.jsp" />

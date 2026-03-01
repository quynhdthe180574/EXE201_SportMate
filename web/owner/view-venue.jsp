<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:include page="header.jsp" />

<style>
    .container { max-width: 1100px; margin: 40px auto; padding: 0 20px; }
    .venue-title { color: var(--blue-pastel); margin-bottom: 10px; }
    .venue-info { background: white; border-radius: 12px; padding: 25px; box-shadow: 0 4px 15px rgba(0,0,0,0.08); margin-bottom: 30px; }
    .info-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; }
    .info-item strong { color: var(--blue-pastel); display: block; margin-bottom: 6px; }
    .field-section { margin-top: 40px; }
    .field-card { 
        background: white; 
        border-radius: 12px; 
        padding: 20px; 
        margin-bottom: 25px; 
        box-shadow: 0 4px 15px rgba(0,0,0,0.06);
    }
    .field-images { display: flex; flex-wrap: wrap; gap: 15px; margin-top: 15px; }
    .field-images img { 
        width: 220px; 
        height: 140px; 
        object-fit: cover; 
        border-radius: 8px; 
        border: 1px solid #eee; 
        transition: transform 0.2s;
    }
    .field-images img:hover { transform: scale(1.04); }
    .no-images { color: #777; font-style: italic; }
</style>

<div class="container">
    <h1 class="venue-title">${venue.venueName}</h1>
    <p style="color:#555; margin-bottom:30px;">ID: ${venue.venueId} | Trạng thái: ${venue.status}</p>

    <div class="venue-info">
        <div class="info-grid">
            <div class="info-item">
                <strong>Địa chỉ chi tiết</strong>
                ${venue.addressDetail}
            </div>
            <div class="info-item">
                <strong>Giờ hoạt động</strong>
                ${v.openTime} – ${v.closeTime}
            </div>
            <div class="info-item">
                <strong>Mô tả sân</strong>
                ${venue.description != null && !venue.description.isEmpty() ? venue.description : 'Chưa có mô tả chi tiết'}
            </div>
        </div>
    </div>

    <div class="field-section">
        <h2 style="color: var(--blue-pastel);">Các sân con / Loại sân</h2>

        <c:if test="${not empty fields}">
            <c:forEach items="${fields}" var="field">
                <div class="field-card">
                    <h3>${field.fieldName}</h3>
                    <p style="color:#555;">Loại: ${field.sportTypeId} (cần join SportTypes nếu muốn hiển thị tên)</p>

                    <div class="field-images">
                        <c:choose>
                            <c:when test="${not empty field.imageUrls && field.imageUrls.size() > 0}">
                                <c:forEach items="${field.imageUrls}" var="img">
                                    <img src="${img}" alt="${field.fieldName}">
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <p class="no-images">Chưa có ảnh cho sân này</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:forEach>
        </c:if>

        <c:if test="${empty fields}">
            <p style="text-align:center; color:#888; font-style:italic; padding:40px 0;">
                Hiện tại chưa có sân con nào thuộc địa điểm này.
            </p>
        </c:if>
    </div>

    <div style="text-align:center; margin:50px 0;">
        <a href="${pageContext.request.contextPath}/owner/dashboard" 
           style="padding:14px 40px; background:#6c757d; color:white; border-radius:50px; text-decoration:none; font-weight:bold;">
            ← Quay lại Dashboard
        </a>
    </div>
</div>

<jsp:include page="footer.jsp" />
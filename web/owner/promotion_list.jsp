<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

            <jsp:include page="header.jsp" />

            <style>
                .promo-title {
                    text-align: center;
                    color: #6b5b95;
                    margin: 10px 0 25px;
                    font-size: 1.6rem;
                }

                /* ===== Toast Notification ===== */
                .toast-container {
                    position: fixed;
                    top: 25px;
                    right: 25px;
                    z-index: 9999;
                    display: flex;
                    flex-direction: column;
                    gap: 10px;
                }

                .toast {
                    display: flex;
                    align-items: center;
                    gap: 12px;
                    min-width: 320px;
                    max-width: 450px;
                    padding: 14px 20px;
                    border-radius: 12px;
                    box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
                    font-size: 0.92rem;
                    font-weight: 500;
                    animation: toastSlideIn 0.4s ease-out;
                    position: relative;
                    backdrop-filter: blur(10px);
                }

                .toast-success {
                    background: linear-gradient(135deg, #d4edda, #c3e6cb);
                    color: #155724;
                    border-left: 5px solid #28a745;
                }

                .toast-error {
                    background: linear-gradient(135deg, #f8d7da, #f5c6cb);
                    color: #721c24;
                    border-left: 5px solid #dc3545;
                }

                .toast-icon {
                    font-size: 1.4rem;
                    flex-shrink: 0;
                }

                .toast-message {
                    flex: 1;
                }

                .toast-close {
                    background: none;
                    border: none;
                    font-size: 1.2rem;
                    cursor: pointer;
                    opacity: 0.6;
                    transition: opacity 0.2s;
                    padding: 0 4px;
                    color: inherit;
                    flex-shrink: 0;
                }

                .toast-close:hover {
                    opacity: 1;
                }

                .toast-progress {
                    position: absolute;
                    bottom: 0;
                    left: 5px;
                    right: 0;
                    height: 3px;
                    border-radius: 0 0 12px 0;
                    animation: toastProgress 5s linear forwards;
                }

                .toast-success .toast-progress {
                    background: #28a745;
                }

                .toast-error .toast-progress {
                    background: #dc3545;
                }

                @keyframes toastSlideIn {
                    from {
                        transform: translateX(120%);
                        opacity: 0;
                    }

                    to {
                        transform: translateX(0);
                        opacity: 1;
                    }
                }

                @keyframes toastFadeOut {
                    from {
                        transform: translateX(0);
                        opacity: 1;
                    }

                    to {
                        transform: translateX(120%);
                        opacity: 0;
                    }
                }

                @keyframes toastProgress {
                    from {
                        width: 100%;
                    }

                    to {
                        width: 0%;
                    }
                }

                /* ===== Form ===== */
                .promo-form-card {
                    background: rgba(255, 255, 255, 0.95);
                    border-radius: 16px;
                    padding: 25px 30px;
                    box-shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
                    margin-bottom: 30px;
                }

                .promo-form-card h2 {
                    color: #6b5b95;
                    margin-bottom: 18px;
                    font-size: 1.2rem;
                }

                .form-grid {
                    display: grid;
                    grid-template-columns: 1fr 1fr;
                    gap: 15px;
                }

                .form-group {
                    display: flex;
                    flex-direction: column;
                }

                .form-group.full-width {
                    grid-column: 1 / -1;
                }

                .form-group label {
                    font-weight: 600;
                    color: #555;
                    margin-bottom: 5px;
                    font-size: 0.9rem;
                }

                .form-group input,
                .form-group textarea {
                    padding: 10px 14px;
                    border: 1.5px solid #ddd;
                    border-radius: 10px;
                    font-size: 0.95rem;
                    transition: border-color 0.3s, box-shadow 0.3s;
                }

                .form-group input:focus,
                .form-group textarea:focus {
                    outline: none;
                    border-color: var(--purple-pastel);
                    box-shadow: 0 0 0 3px rgba(224, 187, 228, 0.3);
                }

                .form-group textarea {
                    resize: vertical;
                    min-height: 60px;
                }

                /* ===== Field Error Styles ===== */
                .form-group input.field-error,
                .form-group textarea.field-error {
                    border-color: #dc3545 !important;
                    box-shadow: 0 0 0 3px rgba(220, 53, 69, 0.15) !important;
                }

                .form-group input.field-success,
                .form-group textarea.field-success {
                    border-color: #28a745 !important;
                    box-shadow: 0 0 0 3px rgba(40, 167, 69, 0.1) !important;
                }

                .error-msg {
                    color: #dc3545;
                    font-size: 0.8rem;
                    margin-top: 4px;
                    min-height: 18px;
                    display: block;
                    font-weight: 500;
                    transition: opacity 0.3s;
                }

                .error-msg:empty {
                    opacity: 0;
                }

                .form-actions {
                    display: flex;
                    gap: 10px;
                    margin-top: 15px;
                }

                .btn {
                    padding: 10px 22px;
                    border: none;
                    border-radius: 10px;
                    font-size: 0.95rem;
                    font-weight: 600;
                    cursor: pointer;
                    transition: all 0.3s;
                    text-decoration: none;
                    display: inline-block;
                    text-align: center;
                }

                .btn-primary {
                    background: linear-gradient(135deg, var(--purple-pastel), var(--blue-pastel));
                    color: white;
                }

                .btn-primary:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 4px 12px rgba(167, 199, 231, 0.5);
                }

                .btn-secondary {
                    background: #eee;
                    color: #555;
                }

                .btn-secondary:hover {
                    background: #ddd;
                }

                /* ===== Table ===== */
                .promo-table-card {
                    background: rgba(255, 255, 255, 0.95);
                    border-radius: 16px;
                    padding: 25px 30px;
                    box-shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
                }

                .promo-table {
                    width: 100%;
                    border-collapse: collapse;
                }

                .promo-table th {
                    background: linear-gradient(135deg, var(--purple-pastel), var(--blue-pastel));
                    color: white;
                    padding: 12px 14px;
                    text-align: left;
                    font-size: 0.9rem;
                }

                .promo-table th:first-child {
                    border-radius: 10px 0 0 0;
                }

                .promo-table th:last-child {
                    border-radius: 0 10px 0 0;
                }

                .promo-table td {
                    padding: 12px 14px;
                    border-bottom: 1px solid #eee;
                    font-size: 0.9rem;
                    color: #444;
                }

                .promo-table tr:hover {
                    background: rgba(224, 187, 228, 0.1);
                }

                .promo-table tr:last-child td {
                    border-bottom: none;
                }

                /* Status badges */
                .badge {
                    padding: 4px 12px;
                    border-radius: 20px;
                    font-size: 0.8rem;
                    font-weight: 600;
                }

                .badge-active {
                    background: #d4edda;
                    color: #155724;
                }

                .badge-inactive {
                    background: #f8d7da;
                    color: #721c24;
                }

                /* Action buttons */
                .btn-sm {
                    padding: 6px 14px;
                    font-size: 0.82rem;
                    border-radius: 8px;
                    border: none;
                    cursor: pointer;
                    font-weight: 600;
                    transition: all 0.3s;
                }

                .btn-edit {
                    background: var(--blue-pastel);
                    color: white;
                }

                .btn-toggle {
                    background: var(--orange-pastel);
                    color: #856404;
                }

                .btn-delete {
                    background: var(--pink-pastel);
                    color: white;
                }

                .btn-sm:hover {
                    transform: translateY(-1px);
                    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
                }

                .action-form {
                    display: inline;
                }

                .no-data {
                    text-align: center;
                    color: #888;
                    padding: 40px;
                    font-size: 1.1rem;
                }
            </style>

            <!-- Toast Container -->
            <div class="toast-container" id="toastContainer"></div>

            <h1 class="promo-title">🎉 Quản Lý Khuyến Mãi</h1>

            <!-- Form Tạo / Sửa -->
            <div class="promo-form-card">
                <c:choose>
                    <c:when test="${not empty editPromo}">
                        <h2>✏️ Sửa Khuyến Mãi #${editPromo.promotionId}</h2>
                        <form method="post" action="${pageContext.request.contextPath}/owner/promotions" id="promoForm"
                            onsubmit="return validateForm(this)">
                            <input type="hidden" name="action" value="update" />
                            <input type="hidden" name="promotionId" value="${editPromo.promotionId}" />
                            <div class="form-grid">
                                <div class="form-group">
                                    <label>Tên khuyến mãi *</label>
                                    <input type="text" name="name" id="name" value="${editPromo.name}" />
                                    <span class="error-msg" id="err-name"></span>
                                </div>
                                <div class="form-group">
                                    <label>Giá trị giảm (%) *</label>
                                    <input type="number" name="discountValue" id="discountValue" step="0.01" min="0"
                                        max="100" value="${editPromo.discountValue}" />
                                    <span class="error-msg" id="err-discountValue"></span>
                                </div>
                                <div class="form-group">
                                    <label>Ngày bắt đầu *</label>
                                    <input type="date" name="startDate" id="startDate" value="${editPromo.startDate}" />
                                    <span class="error-msg" id="err-startDate"></span>
                                </div>
                                <div class="form-group">
                                    <label>Ngày kết thúc *</label>
                                    <input type="date" name="endDate" id="endDate" value="${editPromo.endDate}" />
                                    <span class="error-msg" id="err-endDate"></span>
                                </div>
                                <div class="form-group">
                                    <label>Giới hạn sử dụng</label>
                                    <input type="number" name="usageLimit" id="usageLimit" min="0"
                                        value="${editPromo.usageLimit}" />
                                    <span class="error-msg" id="err-usageLimit"></span>
                                </div>
                                <div class="form-group full-width">
                                    <label>Mô tả</label>
                                    <textarea name="description">${editPromo.description}</textarea>
                                </div>
                            </div>
                            <div class="form-actions">
                                <button type="submit" class="btn btn-primary">💾 Lưu thay đổi</button>
                                <a href="${pageContext.request.contextPath}/owner/promotions"
                                    class="btn btn-secondary">Hủy</a>
                            </div>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <h2>➕ Tạo Khuyến Mãi Mới</h2>
                        <form method="post" action="${pageContext.request.contextPath}/owner/promotions" id="promoForm"
                            onsubmit="return validateForm(this)">
                            <input type="hidden" name="action" value="create" />
                            <div class="form-grid">
                                <div class="form-group">
                                    <label>Tên khuyến mãi *</label>
                                    <input type="text" name="name" id="name" placeholder="VD: Giảm 20% cuối tuần" />
                                    <span class="error-msg" id="err-name"></span>
                                </div>
                                <div class="form-group">
                                    <label>Giá trị giảm (%) *</label>
                                    <input type="number" name="discountValue" id="discountValue" step="0.01" min="0"
                                        max="100" placeholder="VD: 20" />
                                    <span class="error-msg" id="err-discountValue"></span>
                                </div>
                                <div class="form-group">
                                    <label>Ngày bắt đầu *</label>
                                    <input type="date" name="startDate" id="startDate" />
                                    <span class="error-msg" id="err-startDate"></span>
                                </div>
                                <div class="form-group">
                                    <label>Ngày kết thúc *</label>
                                    <input type="date" name="endDate" id="endDate" />
                                    <span class="error-msg" id="err-endDate"></span>
                                </div>
                                <div class="form-group">
                                    <label>Giới hạn sử dụng</label>
                                    <input type="number" name="usageLimit" id="usageLimit" min="0"
                                        placeholder="VD: 100" />
                                    <span class="error-msg" id="err-usageLimit"></span>
                                </div>
                                <div class="form-group full-width">
                                    <label>Mô tả</label>
                                    <textarea name="description" placeholder="Mô tả chi tiết khuyến mãi..."></textarea>
                                </div>
                            </div>
                            <div class="form-actions">
                                <button type="submit" class="btn btn-primary">🎁 Tạo khuyến mãi</button>
                            </div>
                        </form>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Bảng danh sách -->
            <div class="promo-table-card">
                <c:choose>
                    <c:when test="${empty promotions}">
                        <p class="no-data">Chưa có khuyến mãi nào. Hãy tạo mã khuyến mãi đầu tiên! 🎉</p>
                    </c:when>
                    <c:otherwise>
                        <table class="promo-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Tên</th>
                                    <th>Giảm (%)</th>
                                    <th>Bắt đầu</th>
                                    <th>Kết thúc</th>
                                    <th>Giới hạn</th>
                                    <th>Trạng thái</th>
                                    <th>Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${promotions}">
                                    <tr>
                                        <td>${p.promotionId}</td>
                                        <td><strong>${p.name}</strong>
                                            <c:if test="${not empty p.description}">
                                                <br /><small style="color:#888;">${p.description}</small>
                                            </c:if>
                                        </td>
                                        <td>${p.discountValue}%</td>
                                        <td>${p.startDate}</td>
                                        <td>${p.endDate}</td>
                                        <td>${p.usageLimit}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${p.status == 'active'}">
                                                    <span class="badge badge-active">✅ Hoạt động</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-inactive">⛔ Tắt</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <!-- Sửa -->
                                            <a href="${pageContext.request.contextPath}/owner/promotions?editId=${p.promotionId}"
                                                class="btn-sm btn-edit">✏️ Sửa</a>

                                            <!-- Bật/Tắt -->
                                            <form class="action-form" method="post"
                                                action="${pageContext.request.contextPath}/owner/promotions">
                                                <input type="hidden" name="action" value="toggle" />
                                                <input type="hidden" name="promotionId" value="${p.promotionId}" />
                                                <button type="submit" class="btn-sm btn-toggle">
                                                    <c:choose>
                                                        <c:when test="${p.status == 'active'}">🔕 Tắt</c:when>
                                                        <c:otherwise>🔔 Bật</c:otherwise>
                                                    </c:choose>
                                                </button>
                                            </form>

                                            <!-- Xóa -->
                                            <form class="action-form" method="post"
                                                action="${pageContext.request.contextPath}/owner/promotions"
                                                onsubmit="return confirm('Bạn chắc chắn muốn xóa khuyến mãi này?');">
                                                <input type="hidden" name="action" value="delete" />
                                                <input type="hidden" name="promotionId" value="${p.promotionId}" />
                                                <button type="submit" class="btn-sm btn-delete">🗑️ Xóa</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>

            <script>
                // ===== Toast Notification System =====
                function showToast(message, type) {
                    var container = document.getElementById('toastContainer');
                    var toast = document.createElement('div');
                    toast.className = 'toast toast-' + type;

                    var icon = type === 'success' ? '✅' : '❌';

                    toast.innerHTML =
                        '<span class="toast-icon">' + icon + '</span>' +
                        '<span class="toast-message">' + message + '</span>' +
                        '<button class="toast-close" onclick="closeToast(this)">&times;</button>' +
                        '<div class="toast-progress"></div>';

                    container.appendChild(toast);

                    // Tự biến mất sau 5 giây
                    setTimeout(function () {
                        if (toast.parentNode) {
                            toast.style.animation = 'toastFadeOut 0.4s ease-in forwards';
                            setTimeout(function () {
                                if (toast.parentNode) toast.parentNode.removeChild(toast);
                            }, 400);
                        }
                    }, 5000);
                }

                function closeToast(btn) {
                    var toast = btn.parentElement;
                    toast.style.animation = 'toastFadeOut 0.3s ease-in forwards';
                    setTimeout(function () {
                        if (toast.parentNode) toast.parentNode.removeChild(toast);
                    }, 300);
                }

                // ===== Hiển thị toast từ server session messages =====
                <c:if test="${not empty sessionScope.successMessage}">
                    showToast('${sessionScope.successMessage}', 'success');
                </c:if>
                <c:if test="${not empty sessionScope.errorMessage}">
                    showToast('${sessionScope.errorMessage}', 'error');
                </c:if>
                <c:remove var="successMessage" scope="session" />
                <c:remove var="errorMessage" scope="session" />

                // ===== Field Validation =====
                function setError(fieldId, message) {
                    var input = document.getElementById(fieldId);
                    var errSpan = document.getElementById('err-' + fieldId);
                    if (input) {
                        input.classList.add('field-error');
                        input.classList.remove('field-success');
                    }
                    if (errSpan) {
                        errSpan.textContent = message;
                        errSpan.style.opacity = '1';
                    }
                }

                function clearError(fieldId) {
                    var input = document.getElementById(fieldId);
                    var errSpan = document.getElementById('err-' + fieldId);
                    if (input) {
                        input.classList.remove('field-error');
                        input.classList.add('field-success');
                    }
                    if (errSpan) {
                        errSpan.textContent = '';
                        errSpan.style.opacity = '0';
                    }
                }

                function resetField(fieldId) {
                    var input = document.getElementById(fieldId);
                    var errSpan = document.getElementById('err-' + fieldId);
                    if (input) {
                        input.classList.remove('field-error');
                        input.classList.remove('field-success');
                    }
                    if (errSpan) {
                        errSpan.textContent = '';
                        errSpan.style.opacity = '0';
                    }
                }

                function validateName() {
                    var val = document.getElementById('name').value.trim();
                    if (val === '') {
                        setError('name', 'Tên khuyến mãi không được để trống.');
                        return false;
                    }
                    if (val.length > 200) {
                        setError('name', 'Tên khuyến mãi tối đa 200 ký tự.');
                        return false;
                    }
                    clearError('name');
                    return true;
                }

                function validateDiscount() {
                    var input = document.getElementById('discountValue');
                    var val = input.value.trim();
                    if (val === '') {
                        setError('discountValue', 'Giá trị giảm không được để trống.');
                        return false;
                    }
                    var num = parseFloat(val);
                    if (isNaN(num)) {
                        setError('discountValue', 'Giá trị giảm phải là một số hợp lệ.');
                        return false;
                    }
                    if (num <= 0) {
                        setError('discountValue', 'Giá trị giảm phải lớn hơn 0%.');
                        return false;
                    }
                    if (num > 100) {
                        setError('discountValue', 'Giá trị giảm không được vượt quá 100%.');
                        return false;
                    }
                    clearError('discountValue');
                    return true;
                }

                function validateStartDate() {
                    var val = document.getElementById('startDate').value;
                    if (val === '') {
                        setError('startDate', 'Ngày bắt đầu không được để trống.');
                        return false;
                    }
                    clearError('startDate');
                    // Re-validate end date when start date changes
                    var endVal = document.getElementById('endDate').value;
                    if (endVal !== '') {
                        validateEndDate();
                    }
                    return true;
                }

                function validateEndDate() {
                    var endVal = document.getElementById('endDate').value;
                    if (endVal === '') {
                        setError('endDate', 'Ngày kết thúc không được để trống.');
                        return false;
                    }
                    var startVal = document.getElementById('startDate').value;
                    if (startVal !== '' && endVal < startVal) {
                        setError('endDate', 'Ngày kết thúc phải sau hoặc bằng ngày bắt đầu.');
                        return false;
                    }
                    clearError('endDate');
                    return true;
                }

                function validateUsageLimit() {
                    var val = document.getElementById('usageLimit').value.trim();
                    if (val === '') {
                        resetField('usageLimit');
                        return true; // Không bắt buộc
                    }
                    var num = parseInt(val);
                    if (isNaN(num) || num < 0) {
                        setError('usageLimit', 'Giới hạn sử dụng phải là số nguyên >= 0.');
                        return false;
                    }
                    clearError('usageLimit');
                    return true;
                }

                // ===== Realtime validation on input/blur =====
                document.addEventListener('DOMContentLoaded', function () {
                    var nameInput = document.getElementById('name');
                    var discountInput = document.getElementById('discountValue');
                    var startInput = document.getElementById('startDate');
                    var endInput = document.getElementById('endDate');
                    var usageInput = document.getElementById('usageLimit');

                    if (nameInput) {
                        nameInput.addEventListener('blur', validateName);
                        nameInput.addEventListener('input', function () {
                            if (this.value.trim() !== '') clearError('name');
                        });
                    }
                    if (discountInput) {
                        discountInput.addEventListener('blur', validateDiscount);
                        discountInput.addEventListener('input', function () {
                            var num = parseFloat(this.value);
                            if (!isNaN(num) && num > 0 && num <= 100) clearError('discountValue');
                        });
                    }
                    if (startInput) {
                        startInput.addEventListener('change', validateStartDate);
                    }
                    if (endInput) {
                        endInput.addEventListener('change', validateEndDate);
                    }
                    if (usageInput) {
                        usageInput.addEventListener('blur', validateUsageLimit);
                        usageInput.addEventListener('input', function () {
                            var val = this.value.trim();
                            if (val === '') {
                                resetField('usageLimit');
                            } else {
                                var num = parseInt(val);
                                if (!isNaN(num) && num >= 0) clearError('usageLimit');
                            }
                        });
                    }
                });

                // ===== Form submit validation =====
                function validateForm(form) {
                    var isValid = true;

                    if (!validateName()) isValid = false;
                    if (!validateDiscount()) isValid = false;
                    if (!validateStartDate()) isValid = false;
                    if (!validateEndDate()) isValid = false;
                    if (!validateUsageLimit()) isValid = false;

                    if (!isValid) {
                        showToast('Vui lòng kiểm tra lại các trường có lỗi.', 'error');
                    }

                    return isValid;
                }
            </script>

            <jsp:include page="footer.jsp" />
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Đặt sân Pickleball</title>

<style>
/* ================== RESET ================== */
* {
    box-sizing: border-box;
}
body {
    margin: 0;
    font-family: "Segoe UI", Arial, sans-serif;
    background: #f3f6f9;
    color: #1f2937;
}

/* ================== PAGE ================== */
.page {
    max-width: 1200px;
    margin: auto;
    padding: 20px;
}

/* ================== HEADER ================== */
.header {
    background: linear-gradient(135deg, #e3f2fd, #f8fbff);
    padding: 18px 22px;
    border-radius: 12px;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.header h2 {
    margin: 0;
    font-size: 22px;
}
.header p {
    margin: 4px 0 0;
    font-size: 14px;
    color: #555;
}
.verified {
    color: #1e88e5;
    font-size: 14px;
    margin-left: 6px;
}

/* ================== MAIN ================== */
.main {
    display: grid;
    grid-template-columns: 2.3fr 1fr;
    gap: 20px;
    margin-top: 20px;
}

/* ================== LEFT ================== */
.left {
    display: flex;
    flex-direction: column;
    gap: 16px;
}

/* Images */
.images {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 12px;
}
.images img {
    width: 100%;
    height: 220px;
    object-fit: cover;
    border-radius: 12px;
}

/* Tags */
.tags {
    display: flex;
    gap: 10px;
}
.tag {
    padding: 6px 14px;
    border-radius: 20px;
    font-size: 13px;
    font-weight: 500;
}
.tag.free { background: #e8f5e9; color: #2e7d32; }
.tag.booked { background: #eeeeee; color: #616161; }
.tag.selected { background: #e3f2fd; color: #1565c0; }

/* Time grid */
.time-grid {
    background: #ffffff;
    border-radius: 12px;
    padding: 16px;
}
.time-grid h3 {
    margin-top: 0;
    margin-bottom: 12px;
    font-size: 16px;
}

.court {
    display: flex;
    align-items: center;
    margin-bottom: 12px;
}
.court-name {
    width: 70px;
    font-weight: 600;
}
.slots {
    display: flex;
    gap: 6px;
}

.slot {
    width: 28px;
    height: 28px;
    border-radius: 6px;
    cursor: pointer;
}
.slot.free { background: #c8e6c9; }
.slot.booked {
    background: #bdbdbd;
    cursor: not-allowed;
}
.slot.selected { background: #64b5f6; }

/* ================== RIGHT ================== */
.right {
    background: #ffffff;
    padding: 20px;
    border-radius: 12px;
    position: sticky;
    top: 20px;
    height: fit-content;
}

.right h3 {
    margin-top: 0;
    margin-bottom: 14px;
    font-size: 17px;
}

.right input,
.right select,
.right textarea {
    width: 100%;
    padding: 10px 12px;
    margin-bottom: 12px;
    border-radius: 8px;
    border: 1px solid #cfd8dc;
    font-size: 14px;
}

.right textarea {
    resize: none;
    height: 80px;
}

.total {
    font-weight: 700;
    margin: 12px 0;
    color: #1e88e5;
}

.right button {
    width: 100%;
    padding: 14px;
    background: #1e88e5;
    border: none;
    border-radius: 10px;
    color: #fff;
    font-size: 15px;
    font-weight: 700;
    cursor: pointer;
}
.right button:hover {
    background: #1565c0;
}
</style>
</head>

<body>

    <jsp:include page="header.jsp" />
<div class="page">

    <!-- HEADER -->
    
    
    
    <div class="page">
        <div>
            <h2>Sân Pickleball New Sports <span class="verified">✔ verified</span></h2>
            <p>38 P. Bích Câu, Văn Miếu – Đống Đa, Hà Nội</p>
        </div>
        <div>⭐ 4.5 (1 đánh giá)</div>
    </div>


    
    <!-- MAIN -->
    <div class="main">

        <!-- LEFT -->
        <div class="left">

            <!-- IMAGES -->
            <div class="images">
                <img src="https://images.unsplash.com/photo-1546519638-68e109498ffc">
                <img src="https://images.unsplash.com/photo-1517649763962-0c623066013b">
            </div>

            <!-- TAGS -->
            <div class="tags">
                <div class="tag free">Giờ trống</div>
                <div class="tag booked">Đã đặt</div>
                <div class="tag selected">Đã chọn</div>
            </div>

            <!-- TIME GRID -->
            <div class="time-grid">
                <h3>Lịch sân hôm nay</h3>

                <div class="court">
                    <div class="court-name">Sân 01</div>
                    <div class="slots">
                        <div class="slot booked"></div>
                        <div class="slot free"></div>
                        <div class="slot free"></div>
                        <div class="slot free"></div>
                        <div class="slot booked"></div>
                    </div>
                </div>

                <div class="court">
                    <div class="court-name">Sân 02</div>
                    <div class="slots">
                        <div class="slot free"></div>
                        <div class="slot free"></div>
                        <div class="slot booked"></div>
                        <div class="slot free"></div>
                        <div class="slot free"></div>
                    </div>
                </div>

            </div>

        </div>

        <!-- RIGHT -->
        <div class="right">
            <h3>Đặt sân theo yêu cầu</h3>

            <input type="text" placeholder="Họ và tên">
            <input type="email" placeholder="Email">
            <input type="text" placeholder="Số điện thoại">

            <select>
                <option>Chọn mục đích</option>
                <option>Giao lưu</option>
                <option>Tập luyện</option>
                <option>Thi đấu</option>
            </select>

            <input type="date">

            <select>
                <option>Chọn giờ</option>
                <option>18:00 - 19:00</option>
                <option>19:00 - 20:00</option>
            </select>

            <textarea placeholder="Ghi chú cho chủ sân"></textarea>

            <div class="total">Tổng tiền: 135.000 đ</div>
<!--<form action="${pageContext.request.contextPath}/VNPayPayment" method="post">
            <button>ĐẶT SÂN</button>
</form>-->
               <a href="payment.jsp?bookingId=${booking.bookingId}"
   class="btn btn-success btn-sm">
   💳 Thanh toán
</a>
        </div>

    </div>
</div>

<script>
document.addEventListener("click", function (e) {
    if (e.target.classList.contains("slot") &&
        e.target.classList.contains("free")) {
        e.target.classList.toggle("selected");
    }
});
</script>

    <!-- ===== INCLUDE FOOTER ===== -->
<jsp:include page="footer.jsp" />
</body>
</html>

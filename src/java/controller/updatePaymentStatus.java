/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.BookingDao;
import java.io.IOException;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet xử lý cập nhật trạng thái thanh toán.
 * Hỗ trợ thanh toán toàn bộ và đặt cọc 30%.
 * 
 * @author kieun
 */
@WebServlet("/updatePaymentSatus")
public class updatePaymentStatus extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            String paymentType = request.getParameter("paymentType"); // "full" hoặc "deposit"

            BookingDao dao = new BookingDao();

            // Lấy thông tin booking để tính số tiền
            Map<String, Object> booking = dao.getBookingById(bookingId);
            if (booking == null) {
                response.getWriter().write("BOOKING_NOT_FOUND");
                return;
            }

            double totalPrice = Double.parseDouble(booking.get("total_price").toString());
            double paidAmount;
            String newStatus;

            if ("deposit".equals(paymentType)) {
                // Đặt cọc 30%
                paidAmount = totalPrice * 0.3;
                newStatus = "Đã cọc 30%";
            } else {
                // Thanh toán toàn bộ (mặc định)
                paidAmount = totalPrice;
                newStatus = "Đã thanh toán";
            }

            // 1. Cập nhật trạng thái booking
            dao.updateStatus(bookingId, newStatus);

            // 2. Lưu thông tin thanh toán vào bảng Payment
            dao.insertPayment(bookingId, "QR_TRANSFER", paidAmount);

            System.out.println("[updatePaymentStatus] bookingId=" + bookingId
                    + " | type=" + paymentType
                    + " | paid=" + paidAmount
                    + " | status=" + newStatus);

            response.setContentType("text/plain;charset=UTF-8");
            response.getWriter().write("PAID");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("ERROR");
        }
    }
}
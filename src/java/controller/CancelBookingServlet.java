package controller;

import dao.BookingDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Servlet xử lý hủy booking (trả lại slot).
 * Hỗ trợ cả GET (từ nút hủy / redirect) và POST (từ JavaScript beacon/fetch).
 */
public class CancelBookingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processCancel(request, response, true);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processCancel(request, response, false);
    }

    private void processCancel(HttpServletRequest request, HttpServletResponse response, boolean redirect)
            throws IOException {
        try {
            String bookingIdParam = request.getParameter("bookingId");
            if (bookingIdParam == null || bookingIdParam.isEmpty()) {
                if (redirect) {
                    response.sendRedirect("home.jsp");
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("MISSING_BOOKING_ID");
                }
                return;
            }

            int bookingId = Integer.parseInt(bookingIdParam);

            BookingDao dao = new BookingDao();

            // Chỉ hủy nếu booking đang ở trạng thái "Chờ thanh toán" hoặc "pending"
            java.util.Map<String, Object> booking = dao.getBookingById(bookingId);
            if (booking != null) {
                String status = booking.get("booking_status").toString();
                if (status.equals("Chờ thanh toán") || status.equals("pending")) {
                    // Xóa booking để trả lại slot (do có UNIQUE constraint trên field_id, slot_id,
                    // booking_date)
                    dao.deleteBooking(bookingId);
                    System.out.println("[CancelBooking] Đã hủy và xóa booking #" + bookingId + " - slot được trả lại");
                } else {
                    System.out.println(
                            "[CancelBooking] Booking #" + bookingId + " không ở trạng thái chờ thanh toán, bỏ qua.");
                }
            }

            if (redirect) {
                response.sendRedirect("home.jsp");
            } else {
                // Trả về cho JavaScript (beacon/fetch)
                response.setStatus(HttpServletResponse.SC_OK);
                response.setContentType("text/plain;charset=UTF-8");
                response.getWriter().write("CANCELLED");
            }

        } catch (Exception e) {
            e.printStackTrace();
            if (redirect) {
                response.sendRedirect("home.jsp");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("ERROR");
            }
        }
    }
}

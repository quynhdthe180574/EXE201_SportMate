package controller;

import dao.OwnerPaymentDAO;
import dao.VenueDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Venue;

import java.io.IOException;
import java.sql.Date;
import java.util.List;
import java.util.Map;

@WebServlet("/owner/payments")
public class OwnerPaymentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Owner ID cố định = 2 (khớp với dữ liệu test)
        int ownerId = 2;

        // Lấy filter parameters
        String venueIdStr = request.getParameter("venueId");
        String fromDateStr = request.getParameter("fromDate");
        String toDateStr = request.getParameter("toDate");

        Integer venueId = null;
        Date fromDate = null;
        Date toDate = null;

        if (venueIdStr != null && !venueIdStr.trim().isEmpty()) {
            try {
                venueId = Integer.parseInt(venueIdStr);
            } catch (NumberFormatException ignored) {
            }
        }
        if (fromDateStr != null && !fromDateStr.trim().isEmpty()) {
            try {
                fromDate = Date.valueOf(fromDateStr);
            } catch (IllegalArgumentException ignored) {
            }
        }
        if (toDateStr != null && !toDateStr.trim().isEmpty()) {
            try {
                toDate = Date.valueOf(toDateStr);
            } catch (IllegalArgumentException ignored) {
            }
        }

        // Ngăn cache
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        try {
            OwnerPaymentDAO paymentDAO = new OwnerPaymentDAO();
            VenueDAO venueDAO = new VenueDAO();

            // Lấy danh sách thanh toán (có filter)
            List<Map<String, Object>> payments = paymentDAO.getPaymentsByOwner(ownerId, fromDate, toDate, venueId);

            // Tổng doanh thu theo filter
            double totalRevenue = paymentDAO.getTotalRevenue(ownerId, fromDate, toDate, venueId);

            // Danh sách venue cho dropdown filter
            List<Venue> venues = venueDAO.getVenuesByOwner(ownerId);

            request.setAttribute("payments", payments);
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("venues", venues);
            request.setAttribute("selectedVenueId", venueId);
            request.setAttribute("fromDate", fromDateStr);
            request.setAttribute("toDate", toDateStr);

            request.getRequestDispatcher("/owner/payment_history.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("[OwnerPaymentServlet] doGet - LỖI: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi tải lịch sử thanh toán: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}

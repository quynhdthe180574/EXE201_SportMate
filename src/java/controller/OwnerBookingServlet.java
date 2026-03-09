package controller;

import dao.OwnerBookingDAO;
import dao.VenueDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.User;
import model.Venue;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/owner/bookings")
public class OwnerBookingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy session và user đăng nhập
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || user.getRoleId() != 2) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int ownerId = user.getUserId(); // ⭐ LẤY ID OWNER TỪ SESSION

        // Lấy filter parameters
        String venueIdStr = request.getParameter("venueId");
        String statusFilter = request.getParameter("status");

        Integer venueId = null;
        if (venueIdStr != null && !venueIdStr.trim().isEmpty()) {
            try {
                venueId = Integer.parseInt(venueIdStr);
            } catch (NumberFormatException ignored) {
            }
        }

        // Ngăn cache
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        try {
            OwnerBookingDAO bookingDAO = new OwnerBookingDAO();
            VenueDAO venueDAO = new VenueDAO();

            // Lấy danh sách booking
            List<Map<String, Object>> bookings;
            if (venueId != null || (statusFilter != null && !statusFilter.trim().isEmpty())) {
                bookings = bookingDAO.getBookingsByOwnerFiltered(ownerId, venueId, statusFilter);
            } else {
                bookings = bookingDAO.getBookingsByOwner(ownerId);
            }

            // Lấy danh sách venue của owner
            List<Venue> venues = venueDAO.getVenuesByOwner(ownerId);

            request.setAttribute("bookings", bookings);
            request.setAttribute("venues", venues);
            request.setAttribute("selectedVenueId", venueId);
            request.setAttribute("selectedStatus", statusFilter);

            request.getRequestDispatcher("/owner/booking_list.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("[OwnerBookingServlet] doGet - LỖI: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi tải danh sách booking: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy session và user
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || user.getRoleId() != 2) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int ownerId = user.getUserId(); // ⭐ LẤY OWNER ID

        String action = request.getParameter("action");
        String bookingIdStr = request.getParameter("bookingId");

        if (action == null || bookingIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/owner/bookings");
            return;
        }

        try {
            int bookingId = Integer.parseInt(bookingIdStr);
            OwnerBookingDAO bookingDAO = new OwnerBookingDAO();

            String newStatus = null;

            switch (action) {
                case "confirm":
                    newStatus = "Đã xác nhận";
                    break;

                case "cancel":
                    newStatus = "Đã hủy";
                    break;

                default:
                    response.sendRedirect(request.getContextPath() + "/owner/bookings");
                    return;
            }

            boolean success = bookingDAO.updateBookingStatus(bookingId, newStatus, ownerId);

            if (success) {
                request.getSession().setAttribute("successMessage",
                        "Booking #" + bookingId + " đã được cập nhật thành: " + newStatus);
            } else {
                request.getSession().setAttribute("errorMessage",
                        "Không thể cập nhật booking #" + bookingId);
            }

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "ID booking không hợp lệ");
        }

        response.sendRedirect(request.getContextPath() + "/owner/bookings");
    }
}

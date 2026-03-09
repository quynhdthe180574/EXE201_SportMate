package controller;

import dao.AdminVenueDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/venues")
public class AdminVenueServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        // Kiểm tra quyền Admin
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null || user.getRoleId() != 1) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            AdminVenueDAO dao = new AdminVenueDAO();
            List<Map<String, Object>> venues = dao.getAllVenuesForAdmin();

            // Tính tổng thống kê (safe casting)
            int activeCount = 0;
            int hiddenCount = 0;
            int totalBookings = 0;
            double totalRevenue = 0;

            for (Map<String, Object> v : venues) {
                String status = String.valueOf(v.get("status"));
                if ("active".equalsIgnoreCase(status)) {
                    activeCount++;
                } else {
                    hiddenCount++;
                }
                totalBookings += toInt(v.get("bookingCount"));
                totalRevenue += toDouble(v.get("totalRevenue"));
            }

            request.setAttribute("venues", venues);
            request.setAttribute("totalVenues", venues.size());
            request.setAttribute("activeCount", activeCount);
            request.setAttribute("hiddenCount", hiddenCount);
            request.setAttribute("totalBookings", totalBookings);
            request.setAttribute("totalRevenue", totalRevenue);

            request.getRequestDispatcher("/admin/venue_list.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi tải danh sách venue: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    /** Safe int conversion */
    private int toInt(Object obj) {
        if (obj == null)
            return 0;
        if (obj instanceof Number)
            return ((Number) obj).intValue();
        try {
            return Integer.parseInt(obj.toString());
        } catch (Exception e) {
            return 0;
        }
    }

    /** Safe double conversion */
    private double toDouble(Object obj) {
        if (obj == null)
            return 0.0;
        if (obj instanceof Number)
            return ((Number) obj).doubleValue();
        try {
            return Double.parseDouble(obj.toString());
        } catch (Exception e) {
            return 0.0;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Kiểm tra quyền Admin
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null || user.getRoleId() != 1) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String venueIdStr = request.getParameter("venueId");

        if (action == null || venueIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/admin/venues");
            return;
        }

        try {
            int venueId = Integer.parseInt(venueIdStr);
            AdminVenueDAO dao = new AdminVenueDAO();
            boolean success = false;
            String message = "";

            switch (action) {
                case "hide":
                    success = dao.hideVenue(venueId);
                    message = success ? "Đã khóa sân #" + venueId : "Không thể khóa sân #" + venueId;
                    break;
                case "show":
                    success = dao.showVenue(venueId);
                    message = success ? "Đã mở sân #" + venueId : "Không thể mở sân #" + venueId;
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/venues");
                    return;
            }

            if (success) {
                request.getSession().setAttribute("successMessage", message);
            } else {
                request.getSession().setAttribute("errorMessage", message);
            }

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "ID không hợp lệ");
        }

        response.sendRedirect(request.getContextPath() + "/admin/venues");
    }
}

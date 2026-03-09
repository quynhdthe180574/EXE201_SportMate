package controller;

import dao.AdminDashboardDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

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
            AdminDashboardDAO dao = new AdminDashboardDAO();

            request.setAttribute("totalUsers", dao.countTotalUsers());
            request.setAttribute("totalVenues", dao.countTotalVenues());
            request.setAttribute("totalBookings", dao.countTotalBookings());
            request.setAttribute("totalRevenue", dao.sumTotalRevenue());
            request.setAttribute("pendingRequests", dao.countPendingOwnerRequests());
            request.setAttribute("recentBookings", dao.getRecentBookings(5));

            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi tải dashboard: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}

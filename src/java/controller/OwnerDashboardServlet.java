// controller/OwnerDashboardServlet.java
package controller;

import dao.BookingDAO;
import dao.DashboardDAO;
import dao.VenueDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/owner/dashboard")
public class OwnerDashboardServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("userId") == null || (int) session.getAttribute("roleId") != 2) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int ownerId = (int) session.getAttribute("userId");

        DashboardDAO dashboardDAO = new DashboardDAO();
        VenueDAO venueDAO = new VenueDAO();
        BookingDAO bookingDAO = new BookingDAO();

        request.setAttribute("totalVenues", dashboardDAO.getTotalVenuesByOwner(ownerId));
        request.setAttribute("totalBookings", bookingDAO.getTotalBookingsByOwner(ownerId));
        request.setAttribute("totalRevenue", dashboardDAO.getTotalRevenueByOwner(ownerId));
        request.setAttribute("venues", venueDAO.getVenuesByOwner(ownerId));
        request.setAttribute("bookings", bookingDAO.getBookingsByOwner(ownerId));

        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }
}
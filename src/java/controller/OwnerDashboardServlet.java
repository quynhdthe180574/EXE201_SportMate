package controller;

import dao.BookingDao;
import dao.DashboardDAO;
import dao.VenueDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/owner/dashboard")
public class OwnerDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null ||
            session.getAttribute("roleId") == null || (Integer) session.getAttribute("roleId") != 2) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int ownerId = (Integer) session.getAttribute("userId");

        DashboardDAO dashboardDAO = new DashboardDAO();
        VenueDAO venueDAO = new VenueDAO();
        BookingDao bookingDao = new BookingDao();

        // Thống kê số liệu
        request.setAttribute("totalVenues", dashboardDAO.countVenues(ownerId));
        request.setAttribute("totalFields", dashboardDAO.countFields(ownerId));
        request.setAttribute("totalBookings", bookingDao.countBookings(ownerId));
        request.setAttribute("totalRevenue", dashboardDAO.sumRevenue(ownerId));

        // Doanh thu theo ngày (30 ngày gần nhất) cho biểu đồ
        List<Map<String, Object>> revenueByDate = dashboardDAO.getRevenueByDate(ownerId, 30);
        StringBuilder labelsJson = new StringBuilder("[");
        StringBuilder dataJson = new StringBuilder("[");
        for (int i = 0; i < revenueByDate.size(); i++) {
            if (i > 0) { labelsJson.append(","); dataJson.append(","); }
            labelsJson.append("\"").append(revenueByDate.get(i).get("date")).append("\"");
            dataJson.append(revenueByDate.get(i).get("revenue"));
        }
        labelsJson.append("]");
        dataJson.append("]");
        request.setAttribute("revenueLabels", labelsJson.toString());
        request.setAttribute("revenueData", dataJson.toString());

        // Danh sách chi tiết
        request.setAttribute("venues", venueDAO.getVenuesByOwner(ownerId));
        request.setAttribute("bookings", bookingDao.getBookingsByOwner(ownerId));

        request.getRequestDispatcher("/owner/dashboard.jsp").forward(request, response);
    }
}
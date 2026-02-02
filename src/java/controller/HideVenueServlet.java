package controller;

import dao.VenueDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/owner/hide-venue")
public class HideVenueServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null || !"2".equals(session.getAttribute("role_id"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int venueId = Integer.parseInt(request.getParameter("id"));
        VenueDAO venueDAO = new VenueDAO();

        // Không cho ẩn nếu có booking
        if (venueDAO.hasBookings(venueId)) {
            request.setAttribute("error", "Không thể ẩn sân vì đang có booking!");
            request.getRequestDispatcher("/owner/dashboard").forward(request, response);
            return;
        }

        venueDAO.hideVenue(venueId);

        response.sendRedirect(request.getContextPath() + "/owner/dashboard");
    }
}
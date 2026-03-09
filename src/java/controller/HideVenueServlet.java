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
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Không cho phép GET → chuyển hướng về dashboard
        response.sendRedirect(request.getContextPath() + "/owner/dashboard?error=invalid_method");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null ||
            session.getAttribute("roleId") == null || (Integer) session.getAttribute("roleId") != 2) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int ownerId = (Integer) session.getAttribute("userId");
        String venueIdStr = request.getParameter("venueId");

        if (venueIdStr == null || venueIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/owner/dashboard?error=missing_venueId");
            return;
        }

        int venueId;
        try {
            venueId = Integer.parseInt(venueIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/owner/dashboard?error=invalid_venueId");
            return;
        }

        VenueDAO dao = new VenueDAO();
        if (dao.hideVenue(venueId, ownerId)) {
            response.sendRedirect(request.getContextPath() + "/owner/dashboard?success=hidden");
        } else {
            request.setAttribute("error", "Không thể ẩn vì có booking đang hoạt động");
response.sendRedirect(request.getContextPath() + "/owner/dashboard?error=active_booking");        }
    }
}
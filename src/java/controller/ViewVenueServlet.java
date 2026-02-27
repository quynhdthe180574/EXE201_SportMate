package controller;

import dao.VenueDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Venue;
import model.Field;

import java.io.IOException;
import java.util.List;

@WebServlet("/owner/view-venue")
public class ViewVenueServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        int venueId;
        try {
            venueId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/owner/dashboard");
            return;
        }

        VenueDAO venueDAO = new VenueDAO();
        Venue venue = venueDAO.getVenueDetail(venueId);

        if (venue == null) {
            response.sendRedirect(request.getContextPath() + "/owner/dashboard");
            return;
        }

        List<Field> fields = venueDAO.getFieldsByVenue(venueId);

        request.setAttribute("venue", venue);
        request.setAttribute("fields", fields);

        request.getRequestDispatcher("/owner/view-venue.jsp").forward(request, response);
    }
}
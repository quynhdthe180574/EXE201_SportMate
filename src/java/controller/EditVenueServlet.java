package controller;

import dao.VenueDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Venue;

import java.io.IOException;
import java.sql.Time;
import java.time.LocalTime;

@WebServlet("/owner/edit-venue")
public class EditVenueServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int venueId = Integer.parseInt(request.getParameter("id"));

        VenueDAO venueDAO = new VenueDAO();
        Venue venue = venueDAO.getVenueById(venueId);

        if (venue == null) {
            response.sendRedirect(request.getContextPath() + "/owner/dashboard");
            return;
        }

        request.setAttribute("venue", venue);
        request.getRequestDispatcher("/owner/edit_venue.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int ownerId = 2; // hardcode để test
        int venueId = Integer.parseInt(request.getParameter("venue_id"));

        Venue venue = new Venue();
        venue.setVenueId(venueId);
        venue.setUserId(ownerId);
        venue.setVenueName(request.getParameter("venue_name"));
        venue.setProvinceId(Integer.parseInt(request.getParameter("province_id")));
        venue.setDistrictId(Integer.parseInt(request.getParameter("district_id")));
        venue.setAddressDetail(request.getParameter("address_detail"));
        venue.setDescription(request.getParameter("description"));
        venue.setStatus(request.getParameter("status"));

        // ==== FIX LỖI TIME 500 ====
        String openTimeStr = request.getParameter("open_time");
        String closeTimeStr = request.getParameter("close_time");

        if (openTimeStr != null && !openTimeStr.isBlank()) {
            venue.setOpenTime(Time.valueOf(LocalTime.parse(openTimeStr)));
        }

        if (closeTimeStr != null && !closeTimeStr.isBlank()) {
            venue.setCloseTime(Time.valueOf(LocalTime.parse(closeTimeStr)));
        }
        // =========================

        new VenueDAO().updateVenue(venue);

        response.sendRedirect(request.getContextPath() + "/owner/dashboard");
    }
}
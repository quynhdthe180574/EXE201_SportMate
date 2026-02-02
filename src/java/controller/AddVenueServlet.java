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

@WebServlet("/owner/add-venue")
public class AddVenueServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/owner/add_venue.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        int ownerId = 2;  // KHỚP VỚI DASHBOARD

        try {
            Venue venue = new Venue();
            venue.setUserId(ownerId);
            venue.setVenueName(request.getParameter("venue_name"));

            String provinceIdStr = request.getParameter("province_id");
            String districtIdStr = request.getParameter("district_id");
            if (provinceIdStr != null && !provinceIdStr.isEmpty()) {
                venue.setProvinceId(Integer.parseInt(provinceIdStr));
            }
            if (districtIdStr != null && !districtIdStr.isEmpty()) {
                venue.setDistrictId(Integer.parseInt(districtIdStr));
            }

            venue.setAddressDetail(request.getParameter("address_detail"));
            venue.setDescription(request.getParameter("description"));

            String openTimeStr = request.getParameter("open_time");
            if (openTimeStr != null && !openTimeStr.isEmpty()) {
                venue.setOpenTime(Time.valueOf(openTimeStr + ":00"));
            }

            String closeTimeStr = request.getParameter("close_time");
            if (closeTimeStr != null && !closeTimeStr.isEmpty()) {
                venue.setCloseTime(Time.valueOf(closeTimeStr + ":00"));
            }

            venue.setStatus("Hoạt động");

            new VenueDAO().addVenue(venue);

            // Redirect với no-cache + timestamp để buộc load lại dữ liệu mới
            String redirectUrl = request.getContextPath() + "/owner/dashboard?t=" + System.currentTimeMillis();
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            response.setHeader("Pragma", "no-cache");
            response.setDateHeader("Expires", 0);
            response.sendRedirect(redirectUrl);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi thêm sân: " + e.getMessage());
            request.getRequestDispatcher("/owner/add_venue.jsp").forward(request, response);
        }
    }
}
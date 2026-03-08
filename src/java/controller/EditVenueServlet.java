package controller;

import dao.VenueDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Venue;
import java.io.IOException;
import java.sql.Time;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/owner/edit-venue")
public class EditVenueServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null ||
            session.getAttribute("roleId") == null || (Integer) session.getAttribute("roleId") != 2) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String venueIdStr = request.getParameter("venueId");
        if (venueIdStr == null || venueIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/owner/dashboard?error=missing_venueId");
            return;
        }

        int venueId;
        try {
            venueId = Integer.parseInt(venueIdStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/owner/dashboard?error=invalid_venueId");
            return;
        }

        int ownerId = (Integer) session.getAttribute("userId");
        VenueDAO dao = new VenueDAO();
        Venue venue = dao.getVenueById(venueId, ownerId);

        if (venue == null) {
            response.sendRedirect(request.getContextPath() + "/owner/dashboard?error=notowner");
            return;
        }

        // Redirect đến JSP (vì JSP ngoài WEB-INF)
        response.sendRedirect(request.getContextPath() + "/owner/edit-venue.jsp?venueId=" + venueId);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null ||
            session.getAttribute("roleId") == null || (Integer) session.getAttribute("roleId") != 2) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String venueIdStr = request.getParameter("venueId");
        if (venueIdStr == null || venueIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/owner/dashboard?error=missing_venueId");
            return;
        }

        int venueId;
        try {
            venueId = Integer.parseInt(venueIdStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/owner/dashboard?error=invalid_venueId");
            return;
        }

        int ownerId = (Integer) session.getAttribute("userId");
        VenueDAO dao = new VenueDAO();
        Venue current = dao.getVenueById(venueId, ownerId);
        if (current == null) {
            response.sendRedirect(request.getContextPath() + "/owner/dashboard?error=notowner");
            return;
        }

        try {
            String venueName     = request.getParameter("venueName");
            String provinceStr   = request.getParameter("provinceId");
            String districtStr   = request.getParameter("districtId");
            String addressDetail = request.getParameter("addressDetail");
            String description   = request.getParameter("description");
            String openTimeStr   = request.getParameter("openTime");
            String closeTimeStr  = request.getParameter("closeTime");
            String status        = request.getParameter("status");

            if (isEmpty(venueName) || isEmpty(provinceStr) || isEmpty(districtStr) ||
                isEmpty(addressDetail) || isEmpty(openTimeStr) || isEmpty(closeTimeStr)) {
                String err = URLEncoder.encode("Vui lòng điền đầy đủ thông tin bắt buộc.", StandardCharsets.UTF_8);
                response.sendRedirect(request.getContextPath() + "/owner/edit-venue.jsp?venueId=" + venueId + "&error=" + err);
                return;
            }

            int provinceId = Integer.parseInt(provinceStr.trim());
            int districtId = Integer.parseInt(districtStr.trim());

            openTimeStr = openTimeStr.trim() + ":00";
            closeTimeStr = closeTimeStr.trim() + ":00";
            Time openTime = Time.valueOf(openTimeStr);
            Time closeTime = Time.valueOf(closeTimeStr);

            Venue venue = new Venue();
            venue.setVenueId(venueId);
            venue.setUserId(ownerId);
            venue.setVenueName(venueName.trim());
            venue.setProvinceId(provinceId);
            venue.setDistrictId(districtId);
            venue.setAddressDetail(addressDetail.trim());
            venue.setDescription(description != null ? description.trim() : "");
            venue.setOpenTime(openTime);
            venue.setCloseTime(closeTime);
            venue.setStatus(status != null && !status.trim().isEmpty() ? status.trim() : "Hoạt động");

            if (dao.updateVenue(venue)) {
                response.sendRedirect(request.getContextPath() + "/owner/dashboard?success=update");
            } else {
                String err = URLEncoder.encode("Cập nhật thất bại. Vui lòng thử lại.", StandardCharsets.UTF_8);
                response.sendRedirect(request.getContextPath() + "/owner/edit-venue.jsp?venueId=" + venueId + "&error=" + err);
            }
        } catch (NumberFormatException e) {
            String err = URLEncoder.encode("provinceId hoặc districtId không hợp lệ.", StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/owner/edit-venue.jsp?venueId=" + venueId + "&error=" + err);
        } catch (IllegalArgumentException e) {
            String err = URLEncoder.encode("Định dạng giờ không hợp lệ (HH:mm).", StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/owner/edit-venue.jsp?venueId=" + venueId + "&error=" + err);
        } catch (Exception e) {
            e.printStackTrace();
            String err = URLEncoder.encode("Lỗi hệ thống: " + e.getMessage(), StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/owner/edit-venue.jsp?venueId=" + venueId + "&error=" + err);
        }
    }

    private boolean isEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }
}
package controller;

import dao.VenueDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Venue;
import model.Field;

import java.io.IOException;
import java.util.List;

@WebServlet("/owner/view-venue")
public class ViewVenueServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        // Kiểm tra đăng nhập và quyền Owner (role_id = 2)
        if (session == null || session.getAttribute("userId") == null ||
            session.getAttribute("roleId") == null || 
            (Integer) session.getAttribute("roleId") != 2) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int ownerId = (Integer) session.getAttribute("userId");
        String idStr = request.getParameter("id");

        int venueId;
        try {
            venueId = Integer.parseInt(idStr);
        } catch (NumberFormatException | NullPointerException e) {
            response.sendRedirect(request.getContextPath() + "/owner/dashboard?error=invalid_id");
            return;
        }

        VenueDAO venueDAO = new VenueDAO();

        // Chỉ lấy sân nếu thuộc owner hiện tại
        Venue venue = venueDAO.getVenueByIdAndOwner(venueId, ownerId);
        if (venue == null) {
            // Không tìm thấy hoặc không phải sân của owner
            response.sendRedirect(request.getContextPath() + "/owner/dashboard?error=not_found_or_not_owner");
            return;
        }

        // Lấy danh sách sân con (fields) của venue này
        List<Field> fields = venueDAO.getFieldsByVenue(venueId);

        // Đặt attribute cho JSP
        request.setAttribute("venue", venue);
        request.setAttribute("fields", fields);

        // Forward đến trang chi tiết
        request.getRequestDispatcher("view-venue.jsp").forward(request, response);
    }
}
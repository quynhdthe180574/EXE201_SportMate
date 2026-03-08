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

@WebServlet("/owner/add-venue")
public class AddVenueServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null ||
            session.getAttribute("roleId") == null || (Integer) session.getAttribute("roleId") != 2) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        request.getRequestDispatcher("/owner/add-venue.jsp").forward(request, response);
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

        int ownerId = (Integer) session.getAttribute("userId");

        try {
            String venueName     = request.getParameter("venueName");
            String provinceStr   = request.getParameter("provinceId");
            String districtStr   = request.getParameter("districtId");
            String addressDetail = request.getParameter("addressDetail");
            String description   = request.getParameter("description");
            String openTimeStr   = request.getParameter("openTime");
            String closeTimeStr  = request.getParameter("closeTime");

            if (isEmpty(venueName) || isEmpty(provinceStr) || isEmpty(districtStr) ||
                isEmpty(addressDetail) || isEmpty(openTimeStr) || isEmpty(closeTimeStr)) {
                request.setAttribute("error", "Vui lòng điền đầy đủ thông tin bắt buộc.");
                request.getRequestDispatcher("/owner/add-venue.jsp").forward(request, response);
                return;
            }

            int provinceId = Integer.parseInt(provinceStr.trim());
            int districtId = Integer.parseInt(districtStr.trim());

            openTimeStr = openTimeStr.trim() + ":00";
            closeTimeStr = closeTimeStr.trim() + ":00";
            Time openTime  = Time.valueOf(openTimeStr);
            Time closeTime = Time.valueOf(closeTimeStr);

            Venue venue = new Venue();
            venue.setUserId(ownerId);
            venue.setVenueName(venueName.trim());
            venue.setProvinceId(provinceId);
            venue.setDistrictId(districtId);
            venue.setAddressDetail(addressDetail.trim());
            venue.setDescription(description != null ? description.trim() : "");
            venue.setOpenTime(openTime);
            venue.setCloseTime(closeTime);
            venue.setStatus("Hoạt động");

            VenueDAO dao = new VenueDAO();
            int venueId = dao.addVenue(venue);

            if (venueId > 0) {
                response.sendRedirect(request.getContextPath() + "/owner/dashboard?success=add");
            } else {
                request.setAttribute("error", "Thêm sân thất bại. Vui lòng thử lại.");
                request.getRequestDispatcher("/owner/add-venue.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "provinceId hoặc districtId không hợp lệ.");
            request.getRequestDispatcher("/owner/add-venue.jsp").forward(request, response);
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Định dạng giờ không hợp lệ (HH:mm).");
            request.getRequestDispatcher("/owner/add-venue.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/owner/add-venue.jsp").forward(request, response);
        }
    }

    private boolean isEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }
}
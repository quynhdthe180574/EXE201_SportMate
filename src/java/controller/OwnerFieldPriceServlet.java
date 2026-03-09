package controller;

import dao.FieldDao;
import dao.VenueDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Field;
import model.Venue;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/owner/field-prices")
public class OwnerFieldPriceServlet extends HttpServlet {

    private int getOwnerIdOrRedirect(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null ||
            session.getAttribute("roleId") == null || (Integer) session.getAttribute("roleId") != 2) {
            response.sendRedirect(request.getContextPath() + "/login");
            return -1;
        }
        return (Integer) session.getAttribute("userId");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int ownerId = getOwnerIdOrRedirect(request, response);
        if (ownerId == -1) return;

        String fieldIdStr = request.getParameter("fieldId");
        if (fieldIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/owner/dashboard");
            return;
        }

        int fieldId = Integer.parseInt(fieldIdStr);
        FieldDao fieldDao = new FieldDao();
        VenueDAO venueDAO = new VenueDAO();
        Field field = fieldDao.getFieldById(fieldId);
        if (field == null) {
            response.sendRedirect(request.getContextPath() + "/owner/dashboard?error=field_not_found");
            return;
        }
        Venue venue = venueDAO.getVenueByIdAndOwner(field.getVenueId(), ownerId);
        if (venue == null) {
            response.sendRedirect(request.getContextPath() + "/owner/dashboard?error=notowner");
            return;
        }

        List<Map<String, Object>> prices = fieldDao.getFieldPricesList(fieldId);
        request.setAttribute("field", field);
        request.setAttribute("venue", venue);
        request.setAttribute("prices", prices);
        request.getRequestDispatcher("/owner/manage-field-prices.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        int ownerId = getOwnerIdOrRedirect(request, response);
        if (ownerId == -1) return;

        String fieldIdStr = request.getParameter("fieldId");
        int fieldId = Integer.parseInt(fieldIdStr);

        FieldDao fieldDao = new FieldDao();
        VenueDAO venueDAO = new VenueDAO();
        Field field = fieldDao.getFieldById(fieldId);
        if (field == null) {
            response.sendRedirect(request.getContextPath() + "/owner/dashboard?error=field_not_found");
            return;
        }
        Venue venue = venueDAO.getVenueByIdAndOwner(field.getVenueId(), ownerId);
        if (venue == null) {
            response.sendRedirect(request.getContextPath() + "/owner/dashboard?error=notowner");
            return;
        }

        // Lấy danh sách slot_id và giá từ form
        String[] slotIds = request.getParameterValues("slotId");
        if (slotIds != null) {
            for (String slotIdStr : slotIds) {
                int slotId = Integer.parseInt(slotIdStr);
                String priceStr = request.getParameter("price_" + slotId);
                if (priceStr != null && !priceStr.trim().isEmpty()) {
                    try {
                        double price = Double.parseDouble(priceStr.trim());
                        if (price > 0) {
                            fieldDao.upsertFieldPrice(fieldId, slotId, price);
                        } else {
                            fieldDao.deleteFieldPrice(fieldId, slotId);
                        }
                    } catch (NumberFormatException ignored) {}
                } else {
                    // Nếu để trống → xóa giá slot đó
                    fieldDao.deleteFieldPrice(fieldId, slotId);
                }
            }
        }

        response.sendRedirect(request.getContextPath() + "/owner/field-prices?fieldId=" + fieldId + "&success=saved");
    }
}

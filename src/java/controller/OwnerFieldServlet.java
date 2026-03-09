package controller;

import dao.FieldDao;
import dao.VenueDAO;
import dao.FieldImageDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Field;
import model.FieldImage;
import model.Venue;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/owner/fields")
public class OwnerFieldServlet extends HttpServlet {

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

        String action = request.getParameter("action");
        if (action == null) action = "list";

        FieldDao fieldDao = new FieldDao();
        VenueDAO venueDAO = new VenueDAO();

        switch (action) {
            case "add" -> {
                String venueIdStr = request.getParameter("venueId");
                if (venueIdStr == null) {
                    response.sendRedirect(request.getContextPath() + "/owner/dashboard");
                    return;
                }
                int venueId = Integer.parseInt(venueIdStr);
                Venue venue = venueDAO.getVenueByIdAndOwner(venueId, ownerId);
                if (venue == null) {
                    response.sendRedirect(request.getContextPath() + "/owner/dashboard?error=notowner");
                    return;
                }
                request.setAttribute("venue", venue);
                try {
                    request.setAttribute("sportTypes", fieldDao.getSportTypes());
                } catch (Exception e) { e.printStackTrace(); }
                request.getRequestDispatcher("/owner/add-field.jsp").forward(request, response);
            }

            case "edit" -> {
                String fieldIdStr = request.getParameter("fieldId");
                if (fieldIdStr == null) {
                    response.sendRedirect(request.getContextPath() + "/owner/dashboard");
                    return;
                }
                int fieldId = Integer.parseInt(fieldIdStr);
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
                request.setAttribute("field", field);
                request.setAttribute("venue", venue);
                try {
                    request.setAttribute("sportTypes", fieldDao.getSportTypes());
                } catch (Exception e) { e.printStackTrace(); }

                FieldImageDAO imageDAO = new FieldImageDAO();
                request.setAttribute("images", imageDAO.getImagesByField(fieldId));
                request.getRequestDispatcher("/owner/edit-field.jsp").forward(request, response);
            }

            default -> { // list
                String venueIdStr = request.getParameter("venueId");
                if (venueIdStr == null) {
                    response.sendRedirect(request.getContextPath() + "/owner/dashboard");
                    return;
                }
                int venueId = Integer.parseInt(venueIdStr);
                Venue venue = venueDAO.getVenueByIdAndOwner(venueId, ownerId);
                if (venue == null) {
                    response.sendRedirect(request.getContextPath() + "/owner/dashboard?error=notowner");
                    return;
                }
                List<Field> fields = venueDAO.getFieldsByVenue(venueId);

                // Lấy ảnh đầu tiên làm thumbnail cho mỗi field
                FieldImageDAO imageDAO = new FieldImageDAO();
                for (Field f : fields) {
                    List<FieldImage> imgs = imageDAO.getImagesByField(f.getFieldId());
                    if (!imgs.isEmpty()) {
                        f.getImageUrls().add(imgs.get(0).getImageUrl());
                    }
                }

                request.setAttribute("venue", venue);
                request.setAttribute("fields", fields);
                request.getRequestDispatcher("/owner/field-list.jsp").forward(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        int ownerId = getOwnerIdOrRedirect(request, response);
        if (ownerId == -1) return;

        String action = request.getParameter("action");
        FieldDao fieldDao = new FieldDao();
        VenueDAO venueDAO = new VenueDAO();

        switch (action) {
            case "add" -> {
                String venueIdStr = request.getParameter("venueId");
                int venueId = Integer.parseInt(venueIdStr);
                Venue venue = venueDAO.getVenueByIdAndOwner(venueId, ownerId);
                if (venue == null) {
                    response.sendRedirect(request.getContextPath() + "/owner/dashboard?error=notowner");
                    return;
                }

                String fieldName = request.getParameter("fieldName");
                String sportTypeStr = request.getParameter("sportTypeId");
                if (fieldName == null || fieldName.trim().isEmpty() || sportTypeStr == null) {
                    response.sendRedirect(request.getContextPath() + "/owner/fields?action=add&venueId=" + venueId + "&error=missing");
                    return;
                }

                Field field = new Field();
                field.setVenueId(venueId);
                field.setFieldName(fieldName.trim());
                field.setSportTypeId(Integer.parseInt(sportTypeStr));
                fieldDao.addField(field);

                response.sendRedirect(request.getContextPath() + "/owner/fields?venueId=" + venueId + "&success=added");
            }

            case "edit" -> {
                String fieldIdStr = request.getParameter("fieldId");
                int fieldId = Integer.parseInt(fieldIdStr);
                Field existing = fieldDao.getFieldById(fieldId);
                if (existing == null) {
                    response.sendRedirect(request.getContextPath() + "/owner/dashboard?error=field_not_found");
                    return;
                }
                Venue venue = venueDAO.getVenueByIdAndOwner(existing.getVenueId(), ownerId);
                if (venue == null) {
                    response.sendRedirect(request.getContextPath() + "/owner/dashboard?error=notowner");
                    return;
                }

                String fieldName = request.getParameter("fieldName");
                String sportTypeStr = request.getParameter("sportTypeId");
                existing.setFieldName(fieldName.trim());
                existing.setSportTypeId(Integer.parseInt(sportTypeStr));
                fieldDao.updateField(existing);

                response.sendRedirect(request.getContextPath() + "/owner/fields?venueId=" + existing.getVenueId() + "&success=updated");
            }

            case "delete" -> {
                String fieldIdStr = request.getParameter("fieldId");
                int fieldId = Integer.parseInt(fieldIdStr);
                Field existing = fieldDao.getFieldById(fieldId);
                if (existing == null) {
                    response.sendRedirect(request.getContextPath() + "/owner/dashboard?error=field_not_found");
                    return;
                }
                Venue venue = venueDAO.getVenueByIdAndOwner(existing.getVenueId(), ownerId);
                if (venue == null) {
                    response.sendRedirect(request.getContextPath() + "/owner/dashboard?error=notowner");
                    return;
                }

                if (fieldDao.hasBookingsByField(fieldId)) {
                    response.sendRedirect(request.getContextPath() + "/owner/fields?venueId=" + existing.getVenueId() + "&error=has_bookings");
                    return;
                }

                fieldDao.deleteField(fieldId);
                response.sendRedirect(request.getContextPath() + "/owner/fields?venueId=" + existing.getVenueId() + "&success=deleted");
            }

            default -> response.sendRedirect(request.getContextPath() + "/owner/dashboard");
        }
    }
}

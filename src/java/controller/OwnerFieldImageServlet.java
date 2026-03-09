package controller;

import dao.FieldDao;
import dao.FieldImageDAO;
import dao.VenueDAO;
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

@WebServlet("/owner/field-images")
public class OwnerFieldImageServlet extends HttpServlet {

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

        FieldImageDAO imageDAO = new FieldImageDAO();
        List<FieldImage> images = imageDAO.getImagesByField(fieldId);

        request.setAttribute("field", field);
        request.setAttribute("venue", venue);
        request.setAttribute("images", images);
        request.getRequestDispatcher("/owner/manage-field-images.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        int ownerId = getOwnerIdOrRedirect(request, response);
        if (ownerId == -1) return;

        String action = request.getParameter("action");
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

        FieldImageDAO imageDAO = new FieldImageDAO();

        if ("upload".equals(action)) {
            String imageUrl = request.getParameter("imageUrl");
            if (imageUrl != null && !imageUrl.trim().isEmpty()) {
                imageDAO.addImage(fieldId, imageUrl.trim());
            }
        } else if ("delete".equals(action)) {
            String imageIdStr = request.getParameter("imageId");
            if (imageIdStr != null) {
                imageDAO.deleteImage(Integer.parseInt(imageIdStr));
            }
        }

        response.sendRedirect(request.getContextPath() + "/owner/field-images?fieldId=" + fieldId);
    }
}

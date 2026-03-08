package controller;

import dao.FieldImageDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.FieldImage;
import java.io.IOException;

@WebServlet("/owner/manage-images")
public class ManageImagesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null ||
            session.getAttribute("roleId") == null || (Integer) session.getAttribute("roleId") != 2) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String fieldIdStr = request.getParameter("fieldId");
        if (fieldIdStr == null || fieldIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/owner/dashboard?error=missing_fieldId");
            return;
        }

        int fieldId;
        try {
            fieldId = Integer.parseInt(fieldIdStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/owner/dashboard?error=invalid_fieldId");
            return;
        }

        FieldImageDAO dao = new FieldImageDAO();
        request.setAttribute("images", dao.getImagesByField(fieldId));
        request.setAttribute("fieldId", fieldId);

        // Forward đến file JSP đúng vị trí và tên
        request.getRequestDispatcher("manage-images.jsp").forward(request, response);
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

        String fieldIdStr = request.getParameter("fieldId");
        String imageUrl = request.getParameter("imageUrl");

        if (fieldIdStr == null || fieldIdStr.trim().isEmpty() ||
            imageUrl == null || imageUrl.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ Field ID và URL ảnh.");
            doGet(request, response);
            return;
        }

        int fieldId;
        try {
            fieldId = Integer.parseInt(fieldIdStr.trim());
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Field ID không hợp lệ (phải là số).");
            doGet(request, response);
            return;
        }

        FieldImage image = new FieldImage();
        image.setFieldId(fieldId);
        image.setImageUrl(imageUrl.trim());

        FieldImageDAO dao = new FieldImageDAO();
        boolean success = dao.addImage(image);

        if (success) {
            response.sendRedirect(request.getContextPath() + "manage-images?fieldId=" + fieldId + "&success=added");
        } else {
            request.setAttribute("error", "Thêm ảnh thất bại. Vui lòng thử lại.");
            doGet(request, response);
        }
    }
}
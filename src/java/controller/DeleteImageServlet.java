package controller;

import dao.FieldImageDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/owner/delete-image")
public class DeleteImageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null || !"2".equals(session.getAttribute("role_id"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int imageId = Integer.parseInt(request.getParameter("image_id"));
        int fieldId = Integer.parseInt(request.getParameter("field_id"));

        new FieldImageDAO().deleteImage(imageId);

        response.sendRedirect(request.getContextPath() + "/owner/manage-images?field_id=" + fieldId);
    }
}
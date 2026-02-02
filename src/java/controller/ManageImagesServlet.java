package controller;

import dao.FieldImageDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.FieldImage;

import java.io.File;
import java.io.IOException;
import java.util.List;

@WebServlet("/owner/manage-images")
@MultipartConfig(fileSizeThreshold = 1024 * 1024,    // 1MB
                 maxFileSize = 1024 * 1024 * 10,     // 10MB
                 maxRequestSize = 1024 * 1024 * 50)  // 50MB
public class ManageImagesServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null || !"2".equals(session.getAttribute("role_id"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int fieldId = Integer.parseInt(request.getParameter("field_id"));
        FieldImageDAO imageDAO = new FieldImageDAO();

        List<FieldImage> images = imageDAO.getImagesByField(fieldId);
        request.setAttribute("images", images);
        request.setAttribute("field_id", fieldId);

        request.getRequestDispatcher("/owner/manage_images.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null || !"2".equals(session.getAttribute("role_id"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int fieldId = Integer.parseInt(request.getParameter("field_id"));

        // Tạo thư mục uploads nếu chưa có
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdir();

        for (Part part : request.getParts()) {
            if (part.getName().equals("image") && part.getSize() > 0) {
                String fileName = extractFileName(part);
                String filePath = uploadPath + File.separator + fileName;
                part.write(filePath);

                // Lưu đường dẫn tương đối vào DB
                String dbPath = UPLOAD_DIR + "/" + fileName;
                new FieldImageDAO().addImage(fieldId, dbPath);
            }
        }

        response.sendRedirect(request.getContextPath() + "/owner/manage-images?field_id=" + fieldId);
    }

    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf("=") + 2, s.length() - 1);
            }
        }
        return "";
    }
}
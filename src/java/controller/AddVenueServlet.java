package controller;

import dao.VenueDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.Venue;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/owner/add-venue")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1,  // 1MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB mỗi file
    maxRequestSize = 1024 * 1024 * 50     // 50MB tổng request
)
public class AddVenueServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads/venues";  // thư mục lưu ảnh (tạo trong webapp)

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/owner/add_venue.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        int ownerId = 2;  // tạm fix, sau này lấy từ session

        try {
            Venue venue = new Venue();
            venue.setUserId(ownerId);
            venue.setVenueName(request.getParameter("venue_name"));
            venue.setProvinceId(Integer.parseInt(request.getParameter("province_id")));
            venue.setDistrictId(Integer.parseInt(request.getParameter("district_id")));
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

            // Thêm venue trước để lấy venue_id mới
            VenueDAO venueDAO = new VenueDAO();
            venueDAO.addVenue(venue);  // venue giờ đã có venueId

            // Xử lý upload ảnh
            String appPath = getServletContext().getRealPath("");
            String savePath = appPath + File.separator + UPLOAD_DIR;

            // Tạo thư mục nếu chưa có
            File uploadDir = new File(savePath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            List<String> imageUrls = new ArrayList<>();

            for (Part part : request.getParts()) {
                if (part.getName().equals("venue_images") && part.getSize() > 0) {
                    String fileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                    String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
                    String filePath = savePath + File.separator + uniqueFileName;

                    // Lưu file
                    Files.copy(part.getInputStream(), Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);

                    // Đường dẫn tương đối để lưu DB (dùng trong src img)
                    String dbPath = "/" + UPLOAD_DIR + "/" + uniqueFileName;
                    imageUrls.add(dbPath);
                }
            }

            // Lưu ảnh vào DB (thêm method mới trong VenueDAO)
            if (!imageUrls.isEmpty()) {
                venueDAO.addVenueImages(venue.getVenueId(), imageUrls);
            }

            // Redirect về dashboard
            String redirectUrl = request.getContextPath() + "/owner/dashboard?t=" + System.currentTimeMillis();
            response.sendRedirect(redirectUrl);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi thêm sân: " + e.getMessage());
            request.getRequestDispatcher("/owner/add_venue.jsp").forward(request, response);
        }
    }
}
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
import model.Field;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.Time;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/owner/edit-venue")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1,  // 1MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB mỗi file
    maxRequestSize = 1024 * 1024 * 50     // 50MB tổng
)
public class EditVenueServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads/venues";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        int venueId;
        try {
            venueId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/owner/dashboard");
            return;
        }

        VenueDAO venueDAO = new VenueDAO();
        Venue venue = venueDAO.getVenueById(venueId);

        if (venue == null) {
            response.sendRedirect(request.getContextPath() + "/owner/dashboard");
            return;
        }

        // Lấy danh sách Field + ảnh của chúng (phải có imageUrls trong model Field)
        List<Field> fields = venueDAO.getFieldsByVenue(venueId);

        request.setAttribute("venue", venue);
        request.setAttribute("fields", fields);
        request.getRequestDispatcher("/owner/edit_venue.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int ownerId = 2; // hardcode test, sau này lấy từ session
        int venueId = Integer.parseInt(request.getParameter("venue_id"));

        Venue venue = new Venue();
        venue.setVenueId(venueId);
        venue.setUserId(ownerId);
        venue.setVenueName(request.getParameter("venue_name"));
        venue.setProvinceId(Integer.parseInt(request.getParameter("province_id")));
        venue.setDistrictId(Integer.parseInt(request.getParameter("district_id")));
        venue.setAddressDetail(request.getParameter("address_detail"));
        venue.setDescription(request.getParameter("description"));
        venue.setStatus(request.getParameter("status"));

        // Xử lý thời gian an toàn
        String openTimeStr = request.getParameter("open_time");
        if (openTimeStr != null && !openTimeStr.trim().isEmpty()) {
            try {
                LocalTime lt = LocalTime.parse(openTimeStr);
                venue.setOpenTime(Time.valueOf(lt));
            } catch (Exception e) {
                System.err.println("Lỗi parse open_time: " + openTimeStr);
            }
        }

        String closeTimeStr = request.getParameter("close_time");
        if (closeTimeStr != null && !closeTimeStr.trim().isEmpty()) {
            try {
                LocalTime lt = LocalTime.parse(closeTimeStr);
                venue.setCloseTime(Time.valueOf(lt));
            } catch (Exception e) {
                System.err.println("Lỗi parse close_time: " + closeTimeStr);
            }
        }

        VenueDAO venueDAO = new VenueDAO();
        venueDAO.updateVenue(venue);

        // Xử lý xóa ảnh (hiện tại chỉ hỗ trợ xóa từ VenueImages - nếu cần xóa FieldImages thì mở rộng sau)
        String[] deleteImages = request.getParameterValues("delete_images");
        if (deleteImages != null) {
            for (String imgUrl : deleteImages) {
                venueDAO.deleteVenueImage(imgUrl);
                String filePath = getServletContext().getRealPath("") + imgUrl;
                new File(filePath).delete();
            }
        }

        // Xử lý upload ảnh mới (lưu vào VenueImages)
        String appPath = getServletContext().getRealPath("");
        String savePath = appPath + File.separator + UPLOAD_DIR;
        new File(savePath).mkdirs();

        List<String> newImageUrls = new ArrayList<>();

        for (Part part : request.getParts()) {
            if ("venue_images".equals(part.getName()) && part.getSize() > 0) {
                String fileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                String uniqueName = System.currentTimeMillis() + "_" + fileName;
                String filePath = savePath + File.separator + uniqueName;

                Files.copy(part.getInputStream(), Paths.get(filePath), StandardCopyOption.REPLACE_EXISTING);

                String dbPath = "/" + UPLOAD_DIR + "/" + uniqueName;
                newImageUrls.add(dbPath);
            }
        }

        if (!newImageUrls.isEmpty()) {
            venueDAO.addVenueImages(venueId, newImageUrls);
        }

        response.sendRedirect(request.getContextPath() + "/owner/dashboard?t=" + System.currentTimeMillis());
    }
}
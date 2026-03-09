package controller;

import dao.VenueDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.Field;
import model.Venue;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.Time;
import java.time.LocalTime;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/owner/edit-venue")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1,    // 1MB
    maxFileSize = 1024 * 1024 * 10,         // 10MB mỗi file
    maxRequestSize = 1024 * 1024 * 50       // 50MB tổng request
)
public class EditVenueServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads/venues";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null ||
            session.getAttribute("roleId") == null || (Integer) session.getAttribute("roleId") != 2) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String venueIdStr = request.getParameter("id"); // hoặc "venueId" tùy JSP gửi
        if (venueIdStr == null || venueIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/owner/dashboard?error=missing_venueId");
            return;
        }

        int venueId;
        try {
            venueId = Integer.parseInt(venueIdStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/owner/dashboard?error=invalid_venueId");
            return;
        }

        int ownerId = (Integer) session.getAttribute("userId");
        VenueDAO dao = new VenueDAO();
        Venue venue = dao.getVenueByIdAndOwner(venueId, ownerId); // check quyền owner

        if (venue == null) {
            response.sendRedirect(request.getContextPath() + "/owner/dashboard?error=notowner_or_notfound");
            return;
        }

        // Lấy danh sách Field + ảnh (nếu model Field có imageUrls)
        List<Field> fields = dao.getFieldsByVenue(venueId);

        request.setAttribute("venue", venue);
        request.setAttribute("fields", fields);
        request.getRequestDispatcher("/owner/edit-venue.jsp").forward(request, response);
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

        String venueIdStr = request.getParameter("venue_id"); // hoặc "venueId"
        if (venueIdStr == null || venueIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/owner/dashboard?error=missing_venueId");
            return;
        }

        int venueId;
        try {
            venueId = Integer.parseInt(venueIdStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/owner/dashboard?error=invalid_venueId");
            return;
        }

        VenueDAO dao = new VenueDAO();
        Venue current = dao.getVenueByIdAndOwner(venueId, ownerId);
        if (current == null) {
            response.sendRedirect(request.getContextPath() + "/owner/dashboard?error=notowner");
            return;
        }

        try {
            // Lấy dữ liệu form
            String venueName      = request.getParameter("venue_name");
            String provinceStr    = request.getParameter("province_id");
            String districtStr    = request.getParameter("district_id");
            String addressDetail  = request.getParameter("address_detail");
            String description    = request.getParameter("description");
            String openTimeStr    = request.getParameter("open_time");
            String closeTimeStr   = request.getParameter("close_time");
            String status         = request.getParameter("status");

            // Validate bắt buộc
            if (isEmpty(venueName) || isEmpty(provinceStr) || isEmpty(districtStr) ||
                isEmpty(addressDetail) || isEmpty(openTimeStr) || isEmpty(closeTimeStr)) {
                String err = URLEncoder.encode("Vui lòng điền đầy đủ thông tin bắt buộc.", StandardCharsets.UTF_8);
                response.sendRedirect(request.getContextPath() + "/owner/edit-venue?id=" + venueId + "&error=" + err);
                return;
            }

            int provinceId = Integer.parseInt(provinceStr.trim());
            int districtId = Integer.parseInt(districtStr.trim());

            // Parse thời gian (thêm :00 nếu cần)
            openTimeStr = openTimeStr.trim();
            if (!openTimeStr.contains(":")) openTimeStr += ":00";
            closeTimeStr = closeTimeStr.trim();
            if (!closeTimeStr.contains(":")) closeTimeStr += ":00";

            Time openTime  = Time.valueOf(LocalTime.parse(openTimeStr));
            Time closeTime = Time.valueOf(LocalTime.parse(closeTimeStr));

            // Tạo object Venue
            Venue venue = new Venue();
            venue.setVenueId(venueId);
            venue.setUserId(ownerId);
            venue.setVenueName(venueName.trim());
            venue.setProvinceId(provinceId);
            venue.setDistrictId(districtId);
            venue.setAddressDetail(addressDetail.trim());
            venue.setDescription(description != null ? description.trim() : "");
            venue.setOpenTime(openTime);
            venue.setCloseTime(closeTime);
            venue.setStatus(status != null && !status.trim().isEmpty() ? status.trim() : "Hoạt động");

            // Cập nhật venue
            boolean updated = dao.updateVenueWithOwner(venue); // dùng bản an toàn check owner

            // Xử lý xóa ảnh cũ (nếu có checkbox delete)
            String[] deleteImages = request.getParameterValues("delete_images");
            if (deleteImages != null) {
                String appPath = getServletContext().getRealPath("");
                for (String imgUrl : deleteImages) {
                    dao.deleteVenueImage(imgUrl);
                    // Xóa file vật lý
                    String filePath = appPath + imgUrl;
                    File file = new File(filePath);
                    if (file.exists()) file.delete();
                }
            }

            // Xử lý upload ảnh mới
            String savePath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
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
                dao.addVenueImages(venueId, newImageUrls);
            }

            // Redirect với thông báo
            if (updated) {
                response.sendRedirect(request.getContextPath() + "/owner/dashboard?success=update&t=" + System.currentTimeMillis());
            } else {
                String err = URLEncoder.encode("Cập nhật thất bại. Vui lòng thử lại.", StandardCharsets.UTF_8);
                response.sendRedirect(request.getContextPath() + "/owner/edit-venue?id=" + venueId + "&error=" + err);
            }

        } catch (NumberFormatException e) {
            String err = URLEncoder.encode("provinceId hoặc districtId không hợp lệ.", StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/owner/edit-venue?id=" + venueId + "&error=" + err);
        } catch (IllegalArgumentException e) {
            String err = URLEncoder.encode("Định dạng giờ không hợp lệ (HH:mm).", StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/owner/edit-venue?id=" + venueId + "&error=" + err);
        } catch (Exception e) {
            e.printStackTrace();
            String err = URLEncoder.encode("Lỗi hệ thống: " + e.getMessage(), StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/owner/edit-venue?id=" + venueId + "&error=" + err);
        }
    }

    private boolean isEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }
}
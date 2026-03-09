package dao;

import model.FieldImage;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object cho FieldImage (ảnh của sân bóng)
 * Hỗ trợ lấy ảnh theo sân, thêm ảnh, xóa ảnh
 */
public class FieldImageDAO {

    /**
     * Lấy tất cả ảnh của một sân (field)
     * @param fieldId ID của sân
     * @return List<FieldImage> (rỗng nếu không có hoặc lỗi)
     */
    public List<FieldImage> getImagesByField(int fieldId) {
        List<FieldImage> list = new ArrayList<>();
        String sql = "SELECT * FROM FieldImages WHERE field_id = ? ORDER BY image_id";

        Connection conn = DBConnection.getConnection();
        if (conn == null) {
            System.err.println("[FieldImageDAO] getImagesByField - CONNECTION NULL for fieldId = " + fieldId);
            return list;
        }

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, fieldId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    FieldImage img = new FieldImage();
                    img.setImageId(rs.getInt("image_id"));
                    img.setFieldId(rs.getInt("field_id"));
                    img.setImageUrl(rs.getString("image_url"));
                    list.add(img);
                }
            }
        } catch (SQLException e) {
            System.err.println("[FieldImageDAO] getImagesByField lỗi: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Thêm một ảnh mới cho sân (dùng object FieldImage)
     * @param image Object FieldImage chứa fieldId và imageUrl
     * @return true nếu thêm thành công, false nếu thất bại
     */
    public boolean addImage(FieldImage image) {
        if (image == null || image.getFieldId() <= 0 || image.getImageUrl() == null) {
            System.err.println("[FieldImageDAO] addImage - Dữ liệu không hợp lệ");
            return false;
        }

        String sql = "INSERT INTO FieldImages (field_id, image_url) VALUES (?, ?)";

        Connection conn = DBConnection.getConnection();
        if (conn == null) return false;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, image.getFieldId());
            ps.setString(2, image.getImageUrl());
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("[FieldImageDAO] addImage lỗi: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Thêm một ảnh mới cho sân (dùng tham số trực tiếp - tương thích bản cũ)
     * @param fieldId ID của sân
     * @param imageUrl Đường dẫn ảnh
     */
    public void addImage(int fieldId, String imageUrl) {
        if (fieldId <= 0 || imageUrl == null || imageUrl.trim().isEmpty()) {
            System.err.println("[FieldImageDAO] addImage - Dữ liệu không hợp lệ: fieldId=" + fieldId);
            return;
        }

        String sql = "INSERT INTO FieldImages (field_id, image_url) VALUES (?, ?)";

        Connection conn = DBConnection.getConnection();
        if (conn == null) return;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, fieldId);
            ps.setString(2, imageUrl);
            ps.executeUpdate();
            System.out.println("[FieldImageDAO] addImage - Đã thêm ảnh cho fieldId = " + fieldId);
        } catch (SQLException e) {
            System.err.println("[FieldImageDAO] addImage lỗi: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Xóa một ảnh theo image_id (trả về boolean - bản mới)
     * @param imageId ID của ảnh cần xóa
     * @return true nếu xóa thành công, false nếu thất bại
     */
    public boolean deleteImage(int imageId) {
        String sql = "DELETE FROM FieldImages WHERE image_id = ?";

        Connection conn = DBConnection.getConnection();
        if (conn == null) return false;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, imageId);
            int rows = ps.executeUpdate();
            if (rows > 0) {
                System.out.println("[FieldImageDAO] deleteImage - Đã xóa ảnh ID = " + imageId);
                return true;
            }
            return false;
        } catch (SQLException e) {
            System.err.println("[FieldImageDAO] deleteImage lỗi: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Xóa một ảnh theo image_id (void - tương thích bản cũ)
     * @param imageId ID của ảnh cần xóa
     */
    public void deleteImageVoid(int imageId) {
        String sql = "DELETE FROM FieldImages WHERE image_id = ?";

        Connection conn = DBConnection.getConnection();
        if (conn == null) return;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, imageId);
            ps.executeUpdate();
            System.out.println("[FieldImageDAO] deleteImageVoid - Đã xóa ảnh ID = " + imageId);
        } catch (SQLException e) {
            System.err.println("[FieldImageDAO] deleteImageVoid lỗi: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
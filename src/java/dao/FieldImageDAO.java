package dao;

import model.FieldImage;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FieldImageDAO {

    public List<FieldImage> getImagesByField(int fieldId) {
        List<FieldImage> list = new ArrayList<>();
        String sql = "SELECT * FROM FieldImages WHERE field_id = ?";

        DBConnection db = new DBConnection();
        Connection conn = db.getConnection();
        if (conn == null) return list;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, fieldId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                FieldImage img = new FieldImage();
                img.setImageId(rs.getInt("image_id"));
                img.setFieldId(rs.getInt("field_id"));
                img.setImageUrl(rs.getString("image_url"));
                list.add(img);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void addImage(int fieldId, String imageUrl) {
        String sql = "INSERT INTO FieldImages (field_id, image_url) VALUES (?, ?)";

        DBConnection db = new DBConnection();
        Connection conn = db.getConnection();
        if (conn == null) return;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, fieldId);
            ps.setString(2, imageUrl);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteImage(int imageId) {
        String sql = "DELETE FROM FieldImages WHERE image_id = ?";

        DBConnection db = new DBConnection();
        Connection conn = db.getConnection();
        if (conn == null) return;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, imageId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
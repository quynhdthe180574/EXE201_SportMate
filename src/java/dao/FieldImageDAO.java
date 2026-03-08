// dao/FieldImageDAO.java
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
        Connection conn = DBConnection.getConnection();
        if (conn == null) return list;
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, fieldId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    FieldImage fi = new FieldImage();
                    fi.setImageId(rs.getInt("image_id"));
                    fi.setFieldId(rs.getInt("field_id"));
                    fi.setImageUrl(rs.getString("image_url"));
                    list.add(fi);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addImage(FieldImage image) {
        String sql = "INSERT INTO FieldImages (field_id, image_url) VALUES (?, ?)";
        Connection conn = DBConnection.getConnection();
        if (conn == null) return false;
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, image.getFieldId());
            ps.setString(2, image.getImageUrl());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteImage(int imageId) {
        String sql = "DELETE FROM FieldImages WHERE image_id = ?";
        Connection conn = DBConnection.getConnection();
        if (conn == null) return false;
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, imageId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
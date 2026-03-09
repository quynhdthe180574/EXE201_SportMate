package dao;

import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AdminReviewDAO {

    /**
     * Lấy tổng quan: mỗi sân (field) kèm số review + rating trung bình
     * JOIN Field → Venue để lấy tên venue
     */
    public List<Map<String, Object>> getFieldReviewSummary() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
                SELECT f.field_id, f.field_name, v.venue_name,
                       COUNT(r.review_id) AS review_count,
                       AVG(r.rating) AS avg_rating
                FROM Review r
                JOIN Field f ON r.field_id = f.field_id
                JOIN Venue v ON f.venue_id = v.venue_id
                GROUP BY f.field_id, f.field_name, v.venue_name
                ORDER BY review_count DESC
                """;
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("fieldId", rs.getInt("field_id"));
                map.put("fieldName", rs.getString("field_name"));
                map.put("venueName", rs.getString("venue_name"));
                map.put("reviewCount", rs.getInt("review_count"));
                map.put("avgRating", rs.getDouble("avg_rating"));
                list.add(map);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Lấy chi tiết review của 1 sân cụ thể (theo field_id)
     */
    public List<Map<String, Object>> getReviewsByFieldId(int fieldId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
                SELECT r.review_id, r.rating, r.comment, r.created_at,
                       u.fullname, u.email
                FROM Review r
                JOIN Users u ON r.user_id = u.user_id
                WHERE r.field_id = ?
                ORDER BY r.created_at DESC
                """;
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, fieldId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("reviewId", rs.getInt("review_id"));
                    map.put("rating", rs.getInt("rating"));
                    map.put("comment", rs.getString("comment"));
                    map.put("createdAt", rs.getTimestamp("created_at"));
                    map.put("fullname", rs.getString("fullname"));
                    map.put("email", rs.getString("email"));
                    list.add(map);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Lấy thông tin 1 field (tên sân + tên venue) để hiển thị breadcrumb
     */
    public Map<String, Object> getFieldInfo(int fieldId) {
        String sql = """
                SELECT f.field_id, f.field_name, v.venue_name
                FROM Field f
                JOIN Venue v ON f.venue_id = v.venue_id
                WHERE f.field_id = ?
                """;
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, fieldId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("fieldId", rs.getInt("field_id"));
                    map.put("fieldName", rs.getString("field_name"));
                    map.put("venueName", rs.getString("venue_name"));
                    return map;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Lấy tất cả reviews - JOIN Users, Field (giữ lại cho tương thích)
     */
    public List<Map<String, Object>> getAllReviewsForAdmin() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
                SELECT r.review_id, r.rating, r.comment, r.created_at,
                       u.fullname, u.email,
                       f.field_name
                FROM Review r
                JOIN Users u ON r.user_id = u.user_id
                JOIN Field f ON r.field_id = f.field_id
                ORDER BY r.created_at DESC
                """;
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("reviewId", rs.getInt("review_id"));
                map.put("rating", rs.getInt("rating"));
                map.put("comment", rs.getString("comment"));
                map.put("createdAt", rs.getTimestamp("created_at"));
                map.put("fullname", rs.getString("fullname"));
                map.put("email", rs.getString("email"));
                map.put("fieldName", rs.getString("field_name"));
                list.add(map);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Xóa review
     */
    public boolean deleteReview(int reviewId) {
        String sql = "DELETE FROM Review WHERE review_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reviewId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}

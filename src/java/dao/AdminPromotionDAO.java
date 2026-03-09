package dao;

import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AdminPromotionDAO {

    /**
     * Lấy tất cả promotions - JOIN Users để lấy tên owner
     */
    public List<Map<String, Object>> getAllPromotionsForAdmin() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
                SELECT p.promotion_id, p.name, p.description, p.discount_value,
                       p.start_date, p.end_date, p.usage_limit, p.status,
                       u.fullname AS owner_name
                FROM Promotion p
                LEFT JOIN Users u ON p.owner_id = u.user_id
                ORDER BY p.promotion_id DESC
                """;
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("promotionId", rs.getInt("promotion_id"));
                map.put("name", rs.getString("name"));
                map.put("description", rs.getString("description"));
                map.put("discountValue", rs.getDouble("discount_value"));
                map.put("startDate", rs.getDate("start_date"));
                map.put("endDate", rs.getDate("end_date"));
                map.put("usageLimit", rs.getInt("usage_limit"));
                map.put("status", rs.getString("status"));
                map.put("ownerName", rs.getString("owner_name"));
                list.add(map);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Toggle trạng thái promotion: active <-> inactive
     */
    public boolean togglePromotionStatus(int promoId) {
        String sql = """
                UPDATE Promotion
                SET status = CASE WHEN status = 'active' THEN 'inactive' ELSE 'active' END
                WHERE promotion_id = ?
                """;
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, promoId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Xóa promotion
     */
    public boolean deletePromotion(int promoId) {
        // Xóa references trong FieldPromotion trước
        String sqlFK = "DELETE FROM FieldPromotion WHERE promotion_id = ?";
        String sqlMain = "DELETE FROM Promotion WHERE promotion_id = ?";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                try (PreparedStatement ps1 = conn.prepareStatement(sqlFK)) {
                    ps1.setInt(1, promoId);
                    ps1.executeUpdate();
                }
                try (PreparedStatement ps2 = conn.prepareStatement(sqlMain)) {
                    ps2.setInt(1, promoId);
                    int rows = ps2.executeUpdate();
                    conn.commit();
                    return rows > 0;
                }
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}

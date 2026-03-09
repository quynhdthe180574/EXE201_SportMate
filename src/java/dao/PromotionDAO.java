package dao;

import model.Promotion;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PromotionDAO {

    // Lấy tất cả promotion của 1 owner
    public List<Promotion> getPromotionsByOwner(int ownerId) {
        List<Promotion> list = new ArrayList<>();
        String sql = """
                    SELECT promotion_id, name, description, discount_value,
                           start_date, end_date, usage_limit, status, owner_id
                    FROM Promotions
                    WHERE owner_id = ?
                    ORDER BY promotion_id DESC
                """;

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            if (conn == null)
                return list;

            ps = conn.prepareStatement(sql);
            ps.setInt(1, ownerId);
            rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapPromotion(rs));
            }
        } catch (SQLException e) {
            System.err.println("[PromotionDAO] getPromotionsByOwner - LỖI: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, ps, conn);
        }
        return list;
    }

    // Lấy 1 promotion theo ID (kiểm tra thuộc owner)
    public Promotion getPromotionById(int promoId, int ownerId) {
        String sql = """
                    SELECT promotion_id, name, description, discount_value,
                           start_date, end_date, usage_limit, status, owner_id
                    FROM Promotions
                    WHERE promotion_id = ? AND owner_id = ?
                """;

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            if (conn == null)
                return null;

            ps = conn.prepareStatement(sql);
            ps.setInt(1, promoId);
            ps.setInt(2, ownerId);
            rs = ps.executeQuery();

            if (rs.next()) {
                return mapPromotion(rs);
            }
        } catch (SQLException e) {
            System.err.println("[PromotionDAO] getPromotionById - LỖI: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, ps, conn);
        }
        return null;
    }

    // Tạo mới promotion
    public boolean addPromotion(Promotion p) {
        String sql = """
                    INSERT INTO Promotions (name, description, discount_value,
                                           start_date, end_date, usage_limit, status, owner_id)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?)
                """;

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBConnection.getConnection();
            if (conn == null) {
                System.err.println("[PromotionDAO] addPromotion - Không kết nối được DB!");
                return false;
            }

            ps = conn.prepareStatement(sql);
            ps.setString(1, p.getName());
            ps.setString(2, p.getDescription());
            ps.setDouble(3, p.getDiscountValue());
            ps.setDate(4, p.getStartDate());
            ps.setDate(5, p.getEndDate());
            ps.setInt(6, p.getUsageLimit());
            ps.setString(7, p.getStatus());
            ps.setInt(8, p.getOwnerId());

            System.out.println("[PromotionDAO] addPromotion - Đang thêm: name=" + p.getName()
                    + ", discount=" + p.getDiscountValue() + ", ownerId=" + p.getOwnerId());

            int rows = ps.executeUpdate();
            System.out.println("[PromotionDAO] addPromotion - Rows affected: " + rows);
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("[PromotionDAO] addPromotion - LỖI: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(null, ps, conn);
        }
        return false;
    }

    // Cập nhật promotion (chỉ cho đúng owner)
    public boolean updatePromotion(Promotion p) {
        String sql = """
                    UPDATE Promotions
                    SET name = ?, description = ?, discount_value = ?,
                        start_date = ?, end_date = ?, usage_limit = ?
                    WHERE promotion_id = ? AND owner_id = ?
                """;

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBConnection.getConnection();
            if (conn == null)
                return false;

            ps = conn.prepareStatement(sql);
            ps.setString(1, p.getName());
            ps.setString(2, p.getDescription());
            ps.setDouble(3, p.getDiscountValue());
            ps.setDate(4, p.getStartDate());
            ps.setDate(5, p.getEndDate());
            ps.setInt(6, p.getUsageLimit());
            ps.setInt(7, p.getPromotionId());
            ps.setInt(8, p.getOwnerId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[PromotionDAO] updatePromotion - LỖI: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(null, ps, conn);
        }
        return false;
    }

    // Bật/tắt trạng thái (active <-> inactive)
    public boolean toggleStatus(int promoId, int ownerId) {
        String sql = """
                    UPDATE Promotions
                    SET status = CASE WHEN status = 'active' THEN 'inactive' ELSE 'active' END
                    WHERE promotion_id = ? AND owner_id = ?
                """;

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBConnection.getConnection();
            if (conn == null)
                return false;

            ps = conn.prepareStatement(sql);
            ps.setInt(1, promoId);
            ps.setInt(2, ownerId);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[PromotionDAO] toggleStatus - LỖI: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(null, ps, conn);
        }
        return false;
    }

    // Xóa promotion (chỉ cho đúng owner)
    public boolean deletePromotion(int promoId, int ownerId) {
        // Xóa FieldPromotion liên quan trước
        String sqlFP = "DELETE FROM FieldPromotions WHERE promotion_id = ?";
        String sqlP = "DELETE FROM Promotions WHERE promotion_id = ? AND owner_id = ?";

        Connection conn = null;
        PreparedStatement ps1 = null;
        PreparedStatement ps2 = null;

        try {
            conn = DBConnection.getConnection();
            if (conn == null)
                return false;

            // Xóa liên kết FieldPromotion trước
            ps1 = conn.prepareStatement(sqlFP);
            ps1.setInt(1, promoId);
            ps1.executeUpdate();

            // Xóa promotion
            ps2 = conn.prepareStatement(sqlP);
            ps2.setInt(1, promoId);
            ps2.setInt(2, ownerId);

            return ps2.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[PromotionDAO] deletePromotion - LỖI: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(null, ps1, null);
            closeResources(null, ps2, conn);
        }
        return false;
    }

    // Helper: Map ResultSet -> Promotion
    private Promotion mapPromotion(ResultSet rs) throws SQLException {
        Promotion p = new Promotion();
        p.setPromotionId(rs.getInt("promotion_id"));
        p.setName(rs.getString("name"));
        p.setDescription(rs.getString("description"));
        p.setDiscountValue(rs.getDouble("discount_value"));
        p.setStartDate(rs.getDate("start_date"));
        p.setEndDate(rs.getDate("end_date"));
        p.setUsageLimit(rs.getInt("usage_limit"));
        p.setStatus(rs.getString("status"));
        p.setOwnerId(rs.getInt("owner_id"));
        return p;
    }

    // Helper: Đóng resources
    private void closeResources(ResultSet rs, PreparedStatement ps, Connection conn) {
        try {
            if (rs != null)
                rs.close();
        } catch (Exception ignored) {
        }
        try {
            if (ps != null)
                ps.close();
        } catch (Exception ignored) {
        }
        try {
            if (conn != null)
                conn.close();
        } catch (Exception ignored) {
        }
    }
}

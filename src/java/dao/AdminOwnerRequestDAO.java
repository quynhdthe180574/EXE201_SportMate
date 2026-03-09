package dao;

import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AdminOwnerRequestDAO {

    /**
     * Lấy tất cả owner requests, JOIN Users để lấy tên + email
     */
    public List<Map<String, Object>> getAllRequests() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
                SELECT r.request_id, r.user_id, u.fullname, u.email,
                       r.phone, r.address_detail, r.description,
                       r.status, r.created_at
                FROM OwnerRequest r
                JOIN Users u ON r.user_id = u.user_id
                ORDER BY
                    CASE r.status WHEN 'PENDING' THEN 0 ELSE 1 END,
                    r.created_at DESC
                """;
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("requestId", rs.getInt("request_id"));
                map.put("userId", rs.getInt("user_id"));
                map.put("fullname", rs.getString("fullname"));
                map.put("email", rs.getString("email"));
                map.put("phone", rs.getString("phone"));
                map.put("addressDetail", rs.getString("address_detail"));
                map.put("description", rs.getString("description"));
                map.put("status", rs.getString("status"));
                map.put("createdAt", rs.getTimestamp("created_at"));
                list.add(map);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Duyệt request: cập nhật status = APPROVED và đổi role user thành Owner
     * (role_id = 2)
     */
    public boolean approveRequest(int requestId) {
        String sqlUpdate = "UPDATE OwnerRequest SET status = 'APPROVED' WHERE request_id = ? AND status = 'PENDING'";
        String sqlRole = """
                UPDATE Users SET role_id = 2
                WHERE user_id = (SELECT user_id FROM OwnerRequest WHERE request_id = ?)
                """;

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // 1. Update request status
                try (PreparedStatement ps1 = conn.prepareStatement(sqlUpdate)) {
                    ps1.setInt(1, requestId);
                    int rows = ps1.executeUpdate();
                    if (rows == 0) {
                        conn.rollback();
                        return false;
                    }
                }
                // 2. Update user role to Owner
                try (PreparedStatement ps2 = conn.prepareStatement(sqlRole)) {
                    ps2.setInt(1, requestId);
                    ps2.executeUpdate();
                }
                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Từ chối request
     */
    public boolean rejectRequest(int requestId) {
        String sql = "UPDATE OwnerRequest SET status = 'REJECTED' WHERE request_id = ? AND status = 'PENDING'";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}

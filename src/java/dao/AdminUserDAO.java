package dao;

import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AdminUserDAO {

    /**
     * Lấy danh sách tất cả users (JOIN Roles để lấy tên role)
     */
    public List<Map<String, Object>> getAllUsers() {
        List<Map<String, Object>> list = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {

            String sql = """
                    SELECT u.user_id, u.fullname, u.email, u.phone, u.role_id,
                           r.role_name, ISNULL(u.Status, 1) AS Status
                    FROM Users u
                    LEFT JOIN Roles r ON u.role_id = r.role_id
                    ORDER BY u.user_id ASC
                    """;

            try (PreparedStatement ps = conn.prepareStatement(sql);
                    ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("userId", rs.getInt("user_id"));
                    map.put("fullname", rs.getString("fullname"));
                    map.put("email", rs.getString("email"));
                    map.put("phone", rs.getString("phone"));
                    map.put("roleId", rs.getInt("role_id"));
                    map.put("roleName", rs.getString("role_name"));

                    // Status trong DB là INT: 1 = Hoạt động, 0 = Bị khóa
                    int statusInt = rs.getInt("Status");
                    String statusStr = (statusInt == 0) ? "Bị khóa" : "Hoạt động";
                    map.put("status", statusStr);

                    list.add(map);
                }
            }

        } catch (SQLException e) {
            System.err.println("[AdminUserDAO] getAllUsers - LỖI: " + e.getMessage());
            e.printStackTrace();
        }

        return list;
    }

    /**
     * Khóa / mở tài khoản user
     * Tự động tạo cột status nếu chưa có
     */
    public boolean updateUserStatus(int userId, String newStatus) {
        try (Connection conn = DBConnection.getConnection()) {

            // Status trong DB là INT: 1 = Hoạt động, 0 = Bị khóa
            int statusValue = "Bị khóa".equals(newStatus) ? 0 : 1;

            String sql = "UPDATE Users SET Status = ? WHERE user_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, statusValue);
                ps.setInt(2, userId);

                int rows = ps.executeUpdate();
                System.out.println("[AdminUserDAO] updateUserStatus - userId=" + userId
                        + " newStatus=" + newStatus + " (INT=" + statusValue + ") rows=" + rows);
                return rows > 0;
            }

        } catch (SQLException e) {
            System.err.println("[AdminUserDAO] updateUserStatus - LỖI: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Đổi role cho user
     */
    public boolean updateUserRole(int userId, int newRoleId) {
        String sql = "UPDATE Users SET role_id = ? WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, newRoleId);
            ps.setInt(2, userId);

            int rows = ps.executeUpdate();
            System.out.println("[AdminUserDAO] updateUserRole - userId=" + userId
                    + " newRoleId=" + newRoleId + " rows=" + rows);
            return rows > 0;

        } catch (SQLException e) {
            System.err.println("[AdminUserDAO] updateUserRole - LỖI: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Lấy danh sách roles
     */
    public List<Map<String, Object>> getAllRoles() {
        List<Map<String, Object>> list = new ArrayList<>();

        String sql = "SELECT role_id, role_name FROM Roles ORDER BY role_id";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("roleId", rs.getInt("role_id"));
                map.put("roleName", rs.getString("role_name"));
                list.add(map);
            }

        } catch (SQLException e) {
            System.err.println("[AdminUserDAO] getAllRoles - LỖI: " + e.getMessage());
            e.printStackTrace();
        }

        return list;
    }

}

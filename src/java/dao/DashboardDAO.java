package dao;

import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DashboardDAO {

    public int countVenues(int ownerId) {
        String sql = "SELECT COUNT(*) FROM Venue WHERE user_id = ?";

        System.out.println("[DashboardDAO] countVenues - Bắt đầu cho ownerId = " + ownerId);

        Connection conn = DBConnection.getConnection(); // Sử dụng static method
        if (conn == null) {
            System.err.println("[DashboardDAO] countVenues - Connection NULL");
            return 0;
        }

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int count = rs.getInt(1);
                    System.out.println("[DashboardDAO] countVenues - Kết quả: " + count);
                    return count;
                }
            }
        } catch (SQLException e) {
            System.err.println("[DashboardDAO] countVenues - LỖI SQL: " + e.getMessage());
            e.printStackTrace();
        } finally {
            // Không đóng connection ở đây vì dùng singleton DBConnection
            // Chỉ đóng khi ứng dụng shutdown nếu cần
        }
        return 0;
    }

    public int countBookings(int ownerId) {
        String sql = """
            SELECT COUNT(*)
            FROM Booking b
            JOIN Field f ON b.field_id = f.field_id
            JOIN Venue v ON f.venue_id = v.venue_id
            WHERE v.user_id = ?
            """;

        System.out.println("[DashboardDAO] countBookings - Bắt đầu cho ownerId = " + ownerId);

        Connection conn = DBConnection.getConnection();
        if (conn == null) return 0;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int count = rs.getInt(1);
                    System.out.println("[DashboardDAO] countBookings - Kết quả: " + count);
                    return count;
                }
            }
        } catch (SQLException e) {
            System.err.println("[DashboardDAO] countBookings - LỖI SQL: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    public double sumRevenue(int ownerId) {
        String sql = """
            SELECT ISNULL(SUM(b.total_price), 0)
            FROM Booking b
            JOIN Field f ON b.field_id = f.field_id
            JOIN Venue v ON f.venue_id = v.venue_id
            WHERE v.user_id = ?
            """;

        System.out.println("[DashboardDAO] sumRevenue - Bắt đầu cho ownerId = " + ownerId);

        Connection conn = DBConnection.getConnection();
        if (conn == null) return 0.0;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    double rev = rs.getDouble(1);
                    System.out.println("[DashboardDAO] sumRevenue - Kết quả: " + rev);
                    return rev;
                }
            }
        } catch (SQLException e) {
            System.err.println("[DashboardDAO] sumRevenue - LỖI SQL: " + e.getMessage());
            e.printStackTrace();
        }
        return 0.0;
    }
}
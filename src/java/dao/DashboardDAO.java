package dao;

import util.DBConnection;
import java.sql.*;

/**
 * Data Access Object cho Dashboard - thống kê nhanh cho chủ sân (owner)
 */
public class DashboardDAO {

    // ────────────────────────────────────────────────
    //                  VENUE STATISTICS
    // ────────────────────────────────────────────────

    /**
     * Đếm tổng số sân vận động (venue) của owner
     * @param ownerId user_id của chủ sân
     * @return số lượng venue hoặc 0 nếu lỗi
     */
    public int countVenues(int ownerId) {
        String sql = "SELECT COUNT(*) FROM Venue WHERE user_id = ?";
        logStart("countVenues", ownerId);

        Connection conn = DBConnection.getConnection();
        if (conn == null) {
            logError("countVenues", "CONNECTION NULL");
            return 0;
        }

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int count = rs.getInt(1);
                    logResult("countVenues", count);
                    return count;
                }
            }
        } catch (SQLException e) {
            logSqlError("countVenues", e);
        }
        return 0;
    }

    // ────────────────────────────────────────────────
    //                  BOOKING STATISTICS
    // ────────────────────────────────────────────────

    /**
     * Đếm tổng số booking của tất cả sân thuộc venue của owner
     * @param ownerId user_id của chủ sân
     * @return số lượng booking hoặc 0 nếu lỗi
     */
    public int countBookings(int ownerId) {
        String sql = """
            SELECT COUNT(*)
            FROM Booking b
            JOIN Field f ON b.field_id = f.field_id
            JOIN Venue v ON f.venue_id = v.venue_id
            WHERE v.user_id = ?
            """;

        logStart("countBookings", ownerId);

        Connection conn = DBConnection.getConnection();
        if (conn == null) {
            logError("countBookings", "CONNECTION NULL");
            return 0;
        }

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int count = rs.getInt(1);
                    logResult("countBookings", count);
                    return count;
                }
            }
        } catch (SQLException e) {
            logSqlError("countBookings", e);
        }
        return 0;
    }

    // ────────────────────────────────────────────────
    //                  REVENUE STATISTICS
    // ────────────────────────────────────────────────

    /**
     * Tính tổng doanh thu từ tất cả booking của owner
     * @param ownerId user_id của chủ sân
     * @return tổng doanh thu hoặc 0.0 nếu lỗi/không có
     */
    public double sumRevenue(int ownerId) {
        String sql = """
            SELECT ISNULL(SUM(b.total_price), 0)
            FROM Booking b
            JOIN Field f ON b.field_id = f.field_id
            JOIN Venue v ON f.venue_id = v.venue_id
            WHERE v.user_id = ?
            """;

        logStart("sumRevenue", ownerId);

        Connection conn = DBConnection.getConnection();
        if (conn == null) {
            logError("sumRevenue", "CONNECTION NULL");
            return 0.0;
        }

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    double revenue = rs.getDouble(1);
                    logResult("sumRevenue", revenue);
                    return revenue;
                }
            }
        } catch (SQLException e) {
            logSqlError("sumRevenue", e);
        }
        return 0.0;
    }

    // ────────────────────────────────────────────────
    //                  FIELD COUNT
    // ────────────────────────────────────────────────

    public int countFields(int ownerId) {
        String sql = """
            SELECT COUNT(*)
            FROM Field f
            JOIN Venue v ON f.venue_id = v.venue_id
            WHERE v.user_id = ?
            """;
        logStart("countFields", ownerId);

        Connection conn = DBConnection.getConnection();
        if (conn == null) {
            logError("countFields", "CONNECTION NULL");
            return 0;
        }

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int count = rs.getInt(1);
                    logResult("countFields", count);
                    return count;
                }
            }
        } catch (SQLException e) {
            logSqlError("countFields", e);
        }
        return 0;
    }

    // ────────────────────────────────────────────────
    //                  REVENUE BY DATE (for chart)
    // ────────────────────────────────────────────────

    public java.util.List<java.util.Map<String, Object>> getRevenueByDate(int ownerId, int days) {
        java.util.List<java.util.Map<String, Object>> list = new java.util.ArrayList<>();
        String sql = """
            SELECT b.booking_date, ISNULL(SUM(b.total_price), 0) as daily_revenue
            FROM Booking b
            JOIN Field f ON b.field_id = f.field_id
            JOIN Venue v ON f.venue_id = v.venue_id
            WHERE v.user_id = ?
              AND b.booking_date >= DATEADD(DAY, ?, GETDATE())
              AND b.booking_status = 'CONFIRMED'
            GROUP BY b.booking_date
            ORDER BY b.booking_date
            """;
        logStart("getRevenueByDate", ownerId);

        Connection conn = DBConnection.getConnection();
        if (conn == null) return list;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            ps.setInt(2, -days);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    java.util.Map<String, Object> map = new java.util.HashMap<>();
                    map.put("date", rs.getDate("booking_date").toString());
                    map.put("revenue", rs.getDouble("daily_revenue"));
                    list.add(map);
                }
            }
        } catch (SQLException e) {
            logSqlError("getRevenueByDate", e);
        }
        return list;
    }

    // ────────────────────────────────────────────────
    //             Compatibility / Old method names
    // ────────────────────────────────────────────────

    /**
     * @deprecated Sử dụng countVenues(int ownerId) thay thế
     */
    @Deprecated
    public int getTotalVenuesByOwner(int ownerId) {
        return countVenues(ownerId);
    }

    /**
     * @deprecated Sử dụng sumRevenue(int ownerId) thay thế
     */
    @Deprecated
    public double getTotalRevenueByOwner(int ownerId) {
        return sumRevenue(ownerId);
    }

    // ────────────────────────────────────────────────
    //                  Logging Helpers
    // ────────────────────────────────────────────────

    private void logStart(String method, int ownerId) {
        System.out.println("[DashboardDAO] " + method + " - Bắt đầu cho ownerId = " + ownerId);
    }

    private void logResult(String method, Object result) {
        System.out.println("[DashboardDAO] " + method + " - Kết quả: " + result);
    }

    private void logError(String method, String message) {
        System.err.println("[DashboardDAO] " + method + " - " + message);
    }

    private void logSqlError(String method, SQLException e) {
        System.err.println("[DashboardDAO] " + method + " - LỖI SQL: " + e.getMessage());
        e.printStackTrace();
    }
}
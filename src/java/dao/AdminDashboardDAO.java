package dao;

import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AdminDashboardDAO {

    public int countTotalUsers() {
        String sql = "SELECT COUNT(*) FROM Users";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next())
                return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countTotalVenues() {
        String sql = "SELECT COUNT(*) FROM Venue";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next())
                return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countTotalBookings() {
        String sql = "SELECT COUNT(*) FROM Booking";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next())
                return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public double sumTotalRevenue() {
        String sql = "SELECT ISNULL(SUM(total_price), 0) FROM Booking WHERE booking_status = 'CONFIRMED'";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next())
                return rs.getDouble(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    public int countPendingOwnerRequests() {
        String sql = "SELECT COUNT(*) FROM OwnerRequest WHERE status = 'PENDING'";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next())
                return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Map<String, Object>> getRecentBookings(int limit) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
                SELECT TOP(?) b.booking_id, u.fullname, f.field_name,
                       t.start_time, t.end_time,
                       b.booking_date, b.total_price, b.booking_status
                FROM Booking b
                JOIN Users u ON b.user_id = u.user_id
                JOIN Field f ON b.field_id = f.field_id
                JOIN TimeSlot t ON b.slot_id = t.slot_id
                ORDER BY b.booking_id DESC
                """;
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("bookingId", rs.getInt("booking_id"));
                    map.put("fullname", rs.getString("fullname"));
                    map.put("fieldName", rs.getString("field_name"));
                    map.put("startTime", rs.getTime("start_time"));
                    map.put("endTime", rs.getTime("end_time"));
                    map.put("bookingDate", rs.getDate("booking_date"));
                    map.put("totalPrice", rs.getDouble("total_price"));
                    map.put("bookingStatus", rs.getString("booking_status"));
                    list.add(map);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}

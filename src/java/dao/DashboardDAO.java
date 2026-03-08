// dao/DashboardDAO.java
package dao;

import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DashboardDAO {

    public int getTotalVenuesByOwner(int ownerId) {
        String sql = "SELECT COUNT(*) FROM Venue WHERE user_id = ?";
        Connection conn = DBConnection.getConnection();
        if (conn == null) return 0;
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public double getTotalRevenueByOwner(int ownerId) {
        String sql = "SELECT SUM(b.total_price) FROM Booking b JOIN Field f ON b.field_id = f.field_id JOIN Venue v ON f.venue_id = v.venue_id WHERE v.user_id = ?";
        Connection conn = DBConnection.getConnection();
        if (conn == null) return 0;
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
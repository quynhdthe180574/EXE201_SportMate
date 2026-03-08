// dao/BookingDAO.java
package dao;

import model.Booking;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    public int getTotalBookingsByOwner(int ownerId) {
        String sql = "SELECT COUNT(*) FROM Booking b JOIN Field f ON b.field_id = f.field_id JOIN Venue v ON f.venue_id = v.venue_id WHERE v.user_id = ?";
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

    public List<Booking> getBookingsByOwner(int ownerId) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.* FROM Booking b JOIN Field f ON b.field_id = f.field_id JOIN Venue v ON f.venue_id = v.venue_id WHERE v.user_id = ?";
        Connection conn = DBConnection.getConnection();
        if (conn == null) return list;
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking b = new Booking();
                    b.setBookingId(rs.getInt("booking_id"));
                    b.setUserId(rs.getInt("user_id"));
                    b.setFieldId(rs.getInt("field_id"));
                    b.setSlotId(rs.getInt("slot_id"));
                    b.setBookingDate(rs.getDate("booking_date"));
                    b.setTotalPrice(rs.getBigDecimal("total_price"));
                    b.setBookingStatus(rs.getString("booking_status"));
                    list.add(b);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
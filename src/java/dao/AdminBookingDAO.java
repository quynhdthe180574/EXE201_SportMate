package dao;

import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AdminBookingDAO {

    /**
     * Lấy tất cả bookings - JOIN Users, Field, TimeSlot, Venue
     */
    public List<Map<String, Object>> getAllBookingsForAdmin() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
                SELECT b.booking_id, b.booking_date, b.total_price, b.booking_status,
                       u.fullname, u.email,
                       f.field_name,
                       v.venue_name,
                       t.start_time, t.end_time
                FROM Booking b
                JOIN Users u ON b.user_id = u.user_id
                JOIN Field f ON b.field_id = f.field_id
                JOIN Venue v ON f.venue_id = v.venue_id
                JOIN TimeSlot t ON b.slot_id = t.slot_id
                ORDER BY b.booking_id DESC
                """;
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("bookingId", rs.getInt("booking_id"));
                map.put("bookingDate", rs.getDate("booking_date"));
                map.put("totalPrice", rs.getDouble("total_price"));
                map.put("bookingStatus", rs.getString("booking_status"));
                map.put("fullname", rs.getString("fullname"));
                map.put("email", rs.getString("email"));
                map.put("fieldName", rs.getString("field_name"));
                map.put("venueName", rs.getString("venue_name"));
                map.put("startTime", rs.getTime("start_time"));
                map.put("endTime", rs.getTime("end_time"));
                list.add(map);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}

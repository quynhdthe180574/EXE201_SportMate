package dao;

import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class OwnerBookingDAO {

    /**
     * Lấy tất cả booking của các sân thuộc owner
     */
    public List<Map<String, Object>> getBookingsByOwner(int ownerId) {
        List<Map<String, Object>> list = new ArrayList<>();

        String sql = """
                SELECT b.booking_id, b.booking_date, b.total_price, b.booking_status,
                       f.field_id, f.field_name,
                       v.venue_id, v.venue_name,
                       ts.slot_id, ts.start_time, ts.end_time,
                       u.user_id, u.fullname, u.email, u.phone
                FROM Booking b
                JOIN Field f ON b.field_id = f.field_id
                JOIN Venue v ON f.venue_id = v.venue_id
                JOIN TimeSlot ts ON b.slot_id = ts.slot_id
                JOIN Users u ON b.user_id = u.user_id
                WHERE v.user_id = ?
                ORDER BY b.booking_date DESC, ts.start_time ASC
                """;

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, ownerId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("bookingId", rs.getInt("booking_id"));
                map.put("bookingDate", rs.getDate("booking_date"));
                map.put("totalPrice", rs.getDouble("total_price"));
                map.put("bookingStatus", rs.getString("booking_status"));
                map.put("fieldId", rs.getInt("field_id"));
                map.put("fieldName", rs.getString("field_name"));
                map.put("venueId", rs.getInt("venue_id"));
                map.put("venueName", rs.getString("venue_name"));
                map.put("slotId", rs.getInt("slot_id"));
                map.put("startTime", rs.getTime("start_time"));
                map.put("endTime", rs.getTime("end_time"));
                map.put("userId", rs.getInt("user_id"));
                map.put("fullname", rs.getString("fullname"));
                map.put("email", rs.getString("email"));
                map.put("phone", rs.getString("phone"));
                list.add(map);
            }

        } catch (SQLException e) {
            System.err.println("[OwnerBookingDAO] getBookingsByOwner - LỖI: " + e.getMessage());
            e.printStackTrace();
        }

        return list;
    }

    /**
     * Lọc booking theo venueId (nếu có)
     */
    public List<Map<String, Object>> getBookingsByOwnerFiltered(int ownerId, Integer venueId, String status) {
        List<Map<String, Object>> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
                SELECT b.booking_id, b.booking_date, b.total_price, b.booking_status,
                       f.field_id, f.field_name,
                       v.venue_id, v.venue_name,
                       ts.slot_id, ts.start_time, ts.end_time,
                       u.user_id, u.fullname, u.email, u.phone
                FROM Booking b
                JOIN Field f ON b.field_id = f.field_id
                JOIN Venue v ON f.venue_id = v.venue_id
                JOIN TimeSlot ts ON b.slot_id = ts.slot_id
                JOIN Users u ON b.user_id = u.user_id
                WHERE v.user_id = ?
                """);

        List<Object> params = new ArrayList<>();
        params.add(ownerId);

        if (venueId != null) {
            sql.append(" AND v.venue_id = ?");
            params.add(venueId);
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND b.booking_status = ?");
            params.add(status);
        }

        sql.append(" ORDER BY b.booking_date DESC, ts.start_time ASC");

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("bookingId", rs.getInt("booking_id"));
                map.put("bookingDate", rs.getDate("booking_date"));
                map.put("totalPrice", rs.getDouble("total_price"));
                map.put("bookingStatus", rs.getString("booking_status"));
                map.put("fieldId", rs.getInt("field_id"));
                map.put("fieldName", rs.getString("field_name"));
                map.put("venueId", rs.getInt("venue_id"));
                map.put("venueName", rs.getString("venue_name"));
                map.put("slotId", rs.getInt("slot_id"));
                map.put("startTime", rs.getTime("start_time"));
                map.put("endTime", rs.getTime("end_time"));
                map.put("userId", rs.getInt("user_id"));
                map.put("fullname", rs.getString("fullname"));
                map.put("email", rs.getString("email"));
                map.put("phone", rs.getString("phone"));
                list.add(map);
            }

        } catch (SQLException e) {
            System.err.println("[OwnerBookingDAO] getBookingsByOwnerFiltered - LỖI: " + e.getMessage());
            e.printStackTrace();
        }

        return list;
    }

    /**
     * Cập nhật trạng thái booking (xác nhận / hủy)
     */
    public boolean updateBookingStatus(int bookingId, String newStatus, int ownerId) {
        // Kiểm tra booking thuộc sân của owner
        String sql = """
                UPDATE b
                SET b.booking_status = ?
                FROM Booking b
                JOIN Field f ON b.field_id = f.field_id
                JOIN Venue v ON f.venue_id = v.venue_id
                WHERE b.booking_id = ? AND v.user_id = ?
                """;

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newStatus);
            ps.setInt(2, bookingId);
            ps.setInt(3, ownerId);

            int rows = ps.executeUpdate();
            System.out.println("[OwnerBookingDAO] updateBookingStatus - bookingId=" + bookingId
                    + " newStatus=" + newStatus + " rows=" + rows);
            return rows > 0;

        } catch (SQLException e) {
            System.err.println("[OwnerBookingDAO] updateBookingStatus - LỖI: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Lấy chi tiết 1 booking
     */
    public Map<String, Object> getBookingDetail(int bookingId, int ownerId) {
        String sql = """
                SELECT b.booking_id, b.booking_date, b.total_price, b.booking_status,
                       f.field_id, f.field_name,
                       v.venue_id, v.venue_name, v.address_detail,
                       ts.slot_id, ts.start_time, ts.end_time,
                       u.user_id, u.fullname, u.email, u.phone
                FROM Booking b
                JOIN Field f ON b.field_id = f.field_id
                JOIN Venue v ON f.venue_id = v.venue_id
                JOIN TimeSlot ts ON b.slot_id = ts.slot_id
                JOIN Users u ON b.user_id = u.user_id
                WHERE b.booking_id = ? AND v.user_id = ?
                """;

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookingId);
            ps.setInt(2, ownerId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("bookingId", rs.getInt("booking_id"));
                map.put("bookingDate", rs.getDate("booking_date"));
                map.put("totalPrice", rs.getDouble("total_price"));
                map.put("bookingStatus", rs.getString("booking_status"));
                map.put("fieldId", rs.getInt("field_id"));
                map.put("fieldName", rs.getString("field_name"));
                map.put("venueId", rs.getInt("venue_id"));
                map.put("venueName", rs.getString("venue_name"));
                map.put("addressDetail", rs.getString("address_detail"));
                map.put("slotId", rs.getInt("slot_id"));
                map.put("startTime", rs.getTime("start_time"));
                map.put("endTime", rs.getTime("end_time"));
                map.put("userId", rs.getInt("user_id"));
                map.put("fullname", rs.getString("fullname"));
                map.put("email", rs.getString("email"));
                map.put("phone", rs.getString("phone"));
                return map;
            }

        } catch (SQLException e) {
            System.err.println("[OwnerBookingDAO] getBookingDetail - LỖI: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
}

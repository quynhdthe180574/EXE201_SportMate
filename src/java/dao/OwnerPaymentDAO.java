package dao;

import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class OwnerPaymentDAO {

    /**
     * Lấy lịch sử thanh toán của owner, hỗ trợ filter theo thời gian và venue
     */
    public List<Map<String, Object>> getPaymentsByOwner(int ownerId, Date fromDate, Date toDate, Integer venueId) {
        List<Map<String, Object>> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
                SELECT p.payment_id, p.payment_method, p.amount,
                       b.booking_id, b.booking_date, b.booking_status,
                       f.field_id, f.field_name,
                       v.venue_id, v.venue_name,
                       ts.start_time, ts.end_time,
                       u.fullname, u.email, u.phone
                FROM Payment p
                JOIN Booking b ON p.booking_id = b.booking_id
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
        if (fromDate != null) {
            sql.append(" AND b.booking_date >= ?");
            params.add(fromDate);
        }
        if (toDate != null) {
            sql.append(" AND b.booking_date <= ?");
            params.add(toDate);
        }

        sql.append(" ORDER BY p.payment_id DESC");

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("paymentId", rs.getInt("payment_id"));
                map.put("paymentMethod", rs.getString("payment_method"));
                map.put("amount", rs.getDouble("amount"));
                map.put("bookingId", rs.getInt("booking_id"));
                map.put("bookingDate", rs.getDate("booking_date"));
                map.put("bookingStatus", rs.getString("booking_status"));
                map.put("fieldId", rs.getInt("field_id"));
                map.put("fieldName", rs.getString("field_name"));
                map.put("venueId", rs.getInt("venue_id"));
                map.put("venueName", rs.getString("venue_name"));
                map.put("startTime", rs.getTime("start_time"));
                map.put("endTime", rs.getTime("end_time"));
                map.put("fullname", rs.getString("fullname"));
                map.put("email", rs.getString("email"));
                map.put("phone", rs.getString("phone"));
                list.add(map);
            }

        } catch (SQLException e) {
            System.err.println("[OwnerPaymentDAO] getPaymentsByOwner - LỖI: " + e.getMessage());
            e.printStackTrace();
        }

        return list;
    }

    /**
     * Tính tổng doanh thu theo filter
     */
    public double getTotalRevenue(int ownerId, Date fromDate, Date toDate, Integer venueId) {
        StringBuilder sql = new StringBuilder("""
                SELECT ISNULL(SUM(p.amount), 0) as total
                FROM Payment p
                JOIN Booking b ON p.booking_id = b.booking_id
                JOIN Field f ON b.field_id = f.field_id
                JOIN Venue v ON f.venue_id = v.venue_id
                WHERE v.user_id = ?
                """);

        List<Object> params = new ArrayList<>();
        params.add(ownerId);

        if (venueId != null) {
            sql.append(" AND v.venue_id = ?");
            params.add(venueId);
        }
        if (fromDate != null) {
            sql.append(" AND b.booking_date >= ?");
            params.add(fromDate);
        }
        if (toDate != null) {
            sql.append(" AND b.booking_date <= ?");
            params.add(toDate);
        }

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble("total");
            }

        } catch (SQLException e) {
            System.err.println("[OwnerPaymentDAO] getTotalRevenue - LỖI: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }
}

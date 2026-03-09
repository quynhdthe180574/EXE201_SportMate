package dao;

import model.Booking;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Data Access Object cho Booking
 * Xử lý đặt sân, thanh toán, hủy, lịch sử, thống kê cho owner
 */
public class BookingDao {

    // ────────────────────────────────────────────────
    //                  CREATE / UPDATE BOOKING
    // ────────────────────────────────────────────────

    /**
     * Tạo booking mới với status mặc định 'Chờ thanh toán'
     * @return booking_id mới sinh hoặc throw Exception nếu lỗi
     */
    public int createBooking(int userId, int fieldId, int slotId, Date bookingDate, double totalPrice)
            throws Exception {
        String sql = """
            INSERT INTO Booking (user_id, field_id, slot_id, booking_date, total_price, booking_status)
            VALUES (?, ?, ?, ?, ?, N'Chờ thanh toán')
            """;

        Connection conn = DBConnection.getConnection();
        if (conn == null) throw new Exception("Không kết nối được DB");

        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.setInt(2, fieldId);
            ps.setInt(3, slotId);
            ps.setDate(4, bookingDate);
            ps.setDouble(5, totalPrice);

            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1); // trả về booking_id mới
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("[BookingDao] createBooking SQL ERROR: " + e.getMessage());
            throw new Exception("Không tạo được booking: " + e.getMessage());
        }
        throw new Exception("Không tạo được booking");
    }

    /**
     * Cập nhật trạng thái booking
     */
    public void updateStatus(int bookingId, String status) {
        String sql = "UPDATE Booking SET booking_status = ? WHERE booking_id = ?";

        Connection conn = DBConnection.getConnection();
        if (conn == null) return;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, bookingId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ────────────────────────────────────────────────
    //                  GET PRICE
    // ────────────────────────────────────────────────

    public Double getPriceBySlotId(int slotId) {
        String sql = "SELECT price FROM FieldPrices WHERE slot_id = ?";

        Connection conn = DBConnection.getConnection();
        if (conn == null) return null;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, slotId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getDouble("price");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Double getPrice(int fieldId, int slotId) {
        String sql = "SELECT price FROM FieldPrices WHERE field_id = ? AND slot_id = ?";

        Connection conn = DBConnection.getConnection();
        if (conn == null) return null;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, fieldId);
            ps.setInt(2, slotId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getDouble("price");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ────────────────────────────────────────────────
    //                  BOOKING DETAIL & HISTORY
    // ────────────────────────────────────────────────

    public Map<String, Object> getBookingById(int bookingId) {
        String sql = """
            SELECT b.booking_id, b.user_id, b.field_id, b.slot_id, b.booking_date,
                   b.total_price, b.booking_status, f.field_name, t.start_time, t.end_time,
                   u.fullname, u.email, u.phone
            FROM Booking b
            JOIN Field f ON b.field_id = f.field_id
            JOIN TimeSlot t ON b.slot_id = t.slot_id
            JOIN Users u ON b.user_id = u.user_id
            WHERE b.booking_id = ?
            """;

        Connection conn = DBConnection.getConnection();
        if (conn == null) return null;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("booking_id", rs.getInt("booking_id"));
                    map.put("user_id", rs.getInt("user_id"));
                    map.put("field_id", rs.getInt("field_id"));
                    map.put("slot_id", rs.getInt("slot_id"));
                    map.put("booking_date", rs.getDate("booking_date"));
                    map.put("total_price", rs.getDouble("total_price"));
                    map.put("booking_status", rs.getString("booking_status"));
                    map.put("field_name", rs.getString("field_name"));
                    map.put("start_time", rs.getTime("start_time"));
                    map.put("end_time", rs.getTime("end_time"));
                    map.put("fullname", rs.getString("fullname"));
                    map.put("email", rs.getString("email"));
                    map.put("phone", rs.getString("phone"));
                    return map;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Map<String, Object>> getBookingHistory(int userId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
            SELECT b.booking_id, f.field_name, s.start_time, s.end_time,
                   b.booking_date, b.total_price, b.booking_status
            FROM Booking b
            JOIN Field f ON b.field_id = f.field_id
            JOIN TimeSlot s ON b.slot_id = s.slot_id
            WHERE b.user_id = ?
            ORDER BY b.booking_date DESC
            """;

        Connection conn = DBConnection.getConnection();
        if (conn == null) return list;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("booking_id", rs.getInt("booking_id"));
                    map.put("field_name", rs.getString("field_name"));
                    map.put("start_time", rs.getTime("start_time"));
                    map.put("end_time", rs.getTime("end_time"));
                    map.put("booking_date", rs.getDate("booking_date"));
                    map.put("total_price", rs.getDouble("total_price"));
                    map.put("booking_status", rs.getString("booking_status"));
                    list.add(map);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ────────────────────────────────────────────────
    //                  CANCEL / DELETE BOOKING
    // ────────────────────────────────────────────────

    public boolean cancelPendingBooking(int bookingId) {
        String sql = """
            UPDATE Booking
            SET booking_status = 'CANCELLED'
            WHERE booking_id = ?
              AND booking_status IN ('PENDING', 'Chờ thanh toán')
            """;

        Connection conn = DBConnection.getConnection();
        if (conn == null) return false;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            int rows = ps.executeUpdate();
            System.out.println("[BookingDao] cancelPendingBooking #" + bookingId + " | rows = " + rows);
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteBooking(int bookingId) {
        String sqlPayment = "DELETE FROM Payment WHERE booking_id = ?";
        String sqlBooking = "DELETE FROM Booking WHERE booking_id = ? AND booking_status IN (N'Chờ thanh toán', 'PENDING')";

        Connection conn = DBConnection.getConnection();
        if (conn == null) return false;

        try {
            // Xóa payment trước (nếu có)
            try (PreparedStatement ps = conn.prepareStatement(sqlPayment)) {
                ps.setInt(1, bookingId);
                ps.executeUpdate();
            }
            // Xóa booking
            try (PreparedStatement ps = conn.prepareStatement(sqlBooking)) {
                ps.setInt(1, bookingId);
                int rows = ps.executeUpdate();
                System.out.println("[BookingDao] deleteBooking #" + bookingId + " | rows = " + rows);
                return rows > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ────────────────────────────────────────────────
    //                  PAYMENT
    // ────────────────────────────────────────────────

    public boolean insertPayment(int bookingId, String paymentMethod, double amount) {
        String sql = "INSERT INTO Payment (booking_id, payment_method, amount) VALUES (?, ?, ?)";

        Connection conn = DBConnection.getConnection();
        if (conn == null) return false;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ps.setString(2, paymentMethod);
            ps.setDouble(3, amount);
            int rows = ps.executeUpdate();
            System.out.println("[BookingDao] insertPayment bookingId=" + bookingId +
                               " | method=" + paymentMethod + " amount=" + amount + " | rows=" + rows);
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ────────────────────────────────────────────────
    //                  OWNER STATISTICS
    // ────────────────────────────────────────────────

    public int getTotalBookingsByOwner(int ownerId) {
        String sql = """
            SELECT COUNT(*)
            FROM Booking b
            JOIN Field f ON b.field_id = f.field_id
            JOIN Venue v ON f.venue_id = v.venue_id
            WHERE v.user_id = ?
            """;

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
        String sql = """
            SELECT b.*
            FROM Booking b
            JOIN Field f ON b.field_id = f.field_id
            JOIN Venue v ON f.venue_id = v.venue_id
            WHERE v.user_id = ?
            ORDER BY b.booking_date DESC
            """;

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
                    b.setTotalPrice(rs.getDouble("total_price"));
                    b.setBookingStatus(rs.getString("booking_status"));
                    list.add(b);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    public int countBookings(int ownerId) {
    String sql = """
        SELECT COUNT(*)
        FROM Booking b
        JOIN Field f ON b.field_id = f.field_id
        JOIN Venue v ON f.venue_id = v.venue_id
        WHERE v.user_id = ?
        """;

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
}
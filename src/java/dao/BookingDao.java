package dao;

import java.sql.*;
import java.util.ArrayList;
import util.DBConnection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.User;

public class BookingDAO {

    private Connection conn;

    public BookingDAO() throws Exception {
        conn = DBConnection.getConnection();
    }

    public int createBooking(int userId, int fieldId, int slotId, Date bookingDate, double totalPrice) throws Exception {

        String sql = """
                INSERT INTO Booking (user_id, field_id, slot_id, booking_date, total_price, booking_status)
                VALUES (?, ?, ?, ?, ?, 'PENDING')
                """;

        PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
        ps.setInt(1, userId);
        ps.setInt(2, fieldId);
        ps.setInt(3, slotId);
        ps.setDate(4, bookingDate);
        ps.setDouble(5, totalPrice);

        try {
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("SQL ERROR: " + e.getMessage());
        }

        ResultSet rs = ps.getGeneratedKeys();
        if (rs.next()) {
            return rs.getInt(1); // bookingId
        }

        throw new Exception("Không tạo được booking");
    }

    public void updateStatus(int bookingId, String status) throws Exception {

        String sql = "UPDATE Booking SET status = ? WHERE booking_id = ?";

        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, status);
        ps.setInt(2, bookingId);

        ps.executeUpdate();
    }

    public Double getPriceBySlotId(int slotId) {

        String sql = """
        SELECT price
        FROM FieldPrices
        WHERE slot_id = ?
    """;

        Double price = null;

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, slotId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                price = rs.getDouble("price");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return price;
    }

    public Double getPrice(int fieldId, int slotId) {

        String sql = """
        SELECT price
        FROM FieldPrices
        WHERE field_id = ?
          AND slot_id = ?
    """;

        Double price = null;

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, fieldId);
            ps.setInt(2, slotId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                price = rs.getDouble("price");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return price;
    }

    public Map<String, Object> getBookingById(int bookingId) {

        String sql = """
    SELECT b.booking_id,
           b.user_id,
           b.field_id,
           b.slot_id,
           b.booking_date,
           b.total_price,
           b.booking_status,
           f.field_name,
           t.start_time,
           t.end_time,
           u.fullname,
           u.email,
           u.phone
    FROM Booking b
    JOIN Field f ON b.field_id = f.field_id
    JOIN TimeSlot t ON b.slot_id = t.slot_id
    JOIN Users u ON b.user_id = u.user_id
    WHERE b.booking_id = ?
""";

        Map<String, Object> booking = null;

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            System.out.println("BookingId = " + bookingId);

            if (rs.next()) {
                System.out.println("Found booking");

                booking = new HashMap<>();
                booking.put("booking_id", rs.getInt("booking_id"));
                booking.put("user_id", rs.getInt("user_id"));
                booking.put("field_id", rs.getInt("field_id"));
                booking.put("slot_id", rs.getInt("slot_id"));
                booking.put("booking_date", rs.getDate("booking_date"));
                booking.put("total_price", rs.getDouble("total_price"));
                booking.put("booking_status", rs.getString("booking_status"));
                booking.put("field_name", rs.getString("field_name"));
                booking.put("start_time", rs.getTime("start_time"));
                booking.put("end_time", rs.getTime("end_time"));
                booking.put("fullname", rs.getString("fullname"));
                booking.put("email", rs.getString("email"));
                booking.put("phone", rs.getString("phone"));
            } else {
                System.out.println("No booking found");

            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("SQL ERROR: " + e.getMessage());
        }

        return booking;
    }

    public List<Map<String, Object>> getBookingHistory(int userId) {

        List<Map<String, Object>> list = new ArrayList<>();

        String sql = """
        SELECT b.booking_id, f.field_name,
               s.start_time, s.end_time,
               b.booking_date, b.total_price,
               b.booking_status
        FROM Booking b
        JOIN Field f ON b.field_id = f.field_id
        JOIN TimeSlot s ON b.slot_id = s.slot_id
        WHERE b.user_id = ?
        ORDER BY b.booking_date DESC
    """;

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

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

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}

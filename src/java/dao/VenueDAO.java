// dao/VenueDAO.java
package dao;

import model.Venue;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Field;

public class VenueDAO {
// Trong VenueDAO.java
public Venue getVenueByIdAndOwner(int venueId, int ownerId) {
    String sql = "SELECT * FROM Venue WHERE venue_id = ? AND user_id = ?";
    Connection conn = DBConnection.getConnection();
    if (conn == null) return null;
    try (PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, venueId);
        ps.setInt(2, ownerId);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                Venue v = new Venue();
                v.setVenueId(rs.getInt("venue_id"));
                v.setUserId(rs.getInt("user_id"));
                v.setVenueName(rs.getString("venue_name"));
                v.setProvinceId(rs.getInt("province_id"));
                v.setDistrictId(rs.getInt("district_id"));
                v.setAddressDetail(rs.getString("address_detail"));
                v.setDescription(rs.getString("description"));
                v.setOpenTime(rs.getTime("open_time"));
                v.setCloseTime(rs.getTime("close_time"));
                v.setStatus(rs.getString("status"));
                return v;
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return null;
}

public List<Field> getFieldsByVenue(int venueId) {
    List<Field> list = new ArrayList<>();
    String sql = "SELECT * FROM Field WHERE venue_id = ?";
    Connection conn = DBConnection.getConnection();
    if (conn == null) return list;
    try (PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, venueId);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Field f = new Field();
                f.setFieldId(rs.getInt("field_id"));
                f.setVenueId(rs.getInt("venue_id"));
                f.setSportTypeId(rs.getInt("sport_type_id"));
                f.setFieldName(rs.getString("field_name"));
                list.add(f);
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return list;
}
    public List<Venue> getVenuesByOwner(int ownerId) {
        List<Venue> list = new ArrayList<>();
        String sql = "SELECT * FROM Venue WHERE user_id = ? ORDER BY venue_name";
        Connection conn = DBConnection.getConnection();
        if (conn == null) return list;
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Venue v = new Venue();
                    v.setVenueId(rs.getInt("venue_id"));
                    v.setUserId(rs.getInt("user_id"));
                    v.setVenueName(rs.getString("venue_name"));
                    v.setProvinceId(rs.getInt("province_id"));
                    v.setDistrictId(rs.getInt("district_id"));
                    v.setAddressDetail(rs.getString("address_detail"));
                    v.setDescription(rs.getString("description"));
                    v.setOpenTime(rs.getTime("open_time"));
                    v.setCloseTime(rs.getTime("close_time"));
                    v.setStatus(rs.getString("status"));
                    list.add(v);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Venue getVenueById(int venueId, int ownerId) {
        String sql = "SELECT * FROM Venue WHERE venue_id = ? AND user_id = ?";
        Connection conn = DBConnection.getConnection();
        if (conn == null) return null;
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, venueId);
            ps.setInt(2, ownerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Venue v = new Venue();
                    v.setVenueId(rs.getInt("venue_id"));
                    v.setUserId(rs.getInt("user_id"));
                    v.setVenueName(rs.getString("venue_name"));
                    v.setProvinceId(rs.getInt("province_id"));
                    v.setDistrictId(rs.getInt("district_id"));
                    v.setAddressDetail(rs.getString("address_detail"));
                    v.setDescription(rs.getString("description"));
                    v.setOpenTime(rs.getTime("open_time"));
                    v.setCloseTime(rs.getTime("close_time"));
                    v.setStatus(rs.getString("status"));
                    return v;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int addVenue(Venue venue) {
        String sql = "INSERT INTO Venue (user_id, venue_name, province_id, district_id, address_detail, description, open_time, close_time, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = DBConnection.getConnection();
        if (conn == null) return -1;
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, venue.getUserId());
            ps.setString(2, venue.getVenueName());
            ps.setInt(3, venue.getProvinceId());
            ps.setInt(4, venue.getDistrictId());
            ps.setString(5, venue.getAddressDetail());
            ps.setString(6, venue.getDescription());
            ps.setTime(7, venue.getOpenTime());
            ps.setTime(8, venue.getCloseTime());
            ps.setString(9, venue.getStatus());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean updateVenue(Venue venue) {
        String sql = "UPDATE Venue SET venue_name = ?, province_id = ?, district_id = ?, address_detail = ?, description = ?, open_time = ?, close_time = ?, status = ? WHERE venue_id = ? AND user_id = ?";
        Connection conn = DBConnection.getConnection();
        if (conn == null) return false;
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, venue.getVenueName());
            ps.setInt(2, venue.getProvinceId());
            ps.setInt(3, venue.getDistrictId());
            ps.setString(4, venue.getAddressDetail());
            ps.setString(5, venue.getDescription());
            ps.setTime(6, venue.getOpenTime());
            ps.setTime(7, venue.getCloseTime());
            ps.setString(8, venue.getStatus());
            ps.setInt(9, venue.getVenueId());
            ps.setInt(10, venue.getUserId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean hideVenue(int venueId, int ownerId) {
        String checkSql = "SELECT COUNT(*) FROM Booking b JOIN Field f ON b.field_id = f.field_id WHERE f.venue_id = ? AND b.booking_status IN ('Đã xác nhận', 'Chờ thanh toán')";
        Connection conn = DBConnection.getConnection();
        if (conn == null) return false;
        try (PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
            checkPs.setInt(1, venueId);
            try (ResultSet rs = checkPs.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) return false; // Có booking chưa hoàn thành
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        String sql = "UPDATE Venue SET status = 'Ẩn' WHERE venue_id = ? AND user_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, venueId);
            ps.setInt(2, ownerId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
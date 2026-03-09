package dao;

import model.Venue;
import model.Field;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object cho Venue và các thực thể liên quan (Field, VenueImages)
 */
public class VenueDAO {

    // ────────────────────────────────────────────────
    // READ METHODS
    // ────────────────────────────────────────────────
    /**
     * Lấy danh sách venue của chủ sân theo user_id
     */
    public List<Venue> getVenuesByOwner(int ownerId) {
        List<Venue> list = new ArrayList<>();
        String sql = """
            SELECT venue_id, user_id, venue_name, province_id, district_id,
                   address_detail, description, open_time, close_time, status
            FROM Venue
            WHERE user_id = ?
            ORDER BY venue_id DESC
            """;
        System.out.println("[VenueDAO] getVenuesByOwner - Bắt đầu - ownerId = " + ownerId);

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            if (conn == null) {
                System.err.println("[VenueDAO] getVenuesByOwner - CONNECTION NULL!");
                return list;
            }
            ps = conn.prepareStatement(sql);
            ps.setInt(1, ownerId);
            rs = ps.executeQuery();
            int count = 0;
            while (rs.next()) {
                count++;
                Venue v = mapVenue(rs);
                list.add(v);
                System.out.println("[VenueDAO] Row " + count + ": " + v.getVenueName() + " - " + v.getStatus());
            }
            System.out.println("[VenueDAO] getVenuesByOwner - Tổng: " + count + " venue");
        } catch (SQLException e) {
            System.err.println("[VenueDAO] getVenuesByOwner - LỖI: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeQuietly(rs, ps);
        }
        return list;
    }

    /**
     * Lấy chi tiết venue theo ID (không check owner)
     */
    public Venue getVenueDetail(int venueId) {
        String sql = """
            SELECT venue_id, user_id, venue_name, province_id, district_id,
                   address_detail, description, open_time, close_time, status
            FROM Venue WHERE venue_id = ?
            """;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            if (conn == null) {
                return null;
            }
            ps = conn.prepareStatement(sql);
            ps.setInt(1, venueId);
            rs = ps.executeQuery();
            if (rs.next()) {
                Venue v = mapVenue(rs);
                System.out.println("[VenueDAO] getVenueDetail - Tìm thấy venue_id " + venueId);
                return v;
            }
        } catch (SQLException e) {
            System.err.println("[VenueDAO] getVenueDetail - LỖI: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeQuietly(rs, ps);
        }
        return null;
    }

  public Venue getVenueById(int venueId, int ownerId) {
    Venue venue = null;

    String sql = "SELECT * FROM Venue WHERE venue_id = ? AND user_id = ?";

    try {
        Connection conn = DBConnection.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql);   // ⭐ THIẾU DÒNG NÀY

        ps.setInt(1, venueId);
        ps.setInt(2, ownerId);

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            venue = new Venue();
            venue.setVenueId(rs.getInt("venue_id"));
            venue.setVenueName(rs.getString("venue_name"));
            venue.setAddressDetail(rs.getString("address_detail"));
            venue.setProvinceId(rs.getInt("province_id"));
            venue.setDistrictId(rs.getInt("district_id"));
            venue.setDescription(rs.getString("description"));
            venue.setOpenTime(rs.getTime("open_time"));
            venue.setCloseTime(rs.getTime("close_time"));
            venue.setStatus(rs.getString("status"));
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return venue;
}

    /**
     * Lấy venue theo ID và kiểm tra quyền sở hữu
     */
    public Venue getVenueByIdAndOwner(int venueId, int ownerId) {
        String sql = """
            SELECT venue_id, user_id, venue_name, province_id, district_id,
                   address_detail, description, open_time, close_time, status
            FROM Venue WHERE venue_id = ? AND user_id = ?
            """;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            if (conn == null) {
                return null;
            }
            ps = conn.prepareStatement(sql);
            ps.setInt(1, venueId);
            ps.setInt(2, ownerId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapVenue(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeQuietly(rs, ps);
        }
        return null;
    }

    /**
     * Lấy tất cả venue (cho admin/public)
     */
    public List<Venue> getAllVenues() {
        List<Venue> list = new ArrayList<>();
        String sql = """
            SELECT venue_id, user_id, venue_name, province_id, district_id,
                   address_detail, description, open_time, close_time, status
            FROM Venue
            ORDER BY venue_id DESC
            """;
        System.out.println("[VenueDAO] getAllVenues - Lấy tất cả sân");

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            if (conn == null) {
                System.err.println("[VenueDAO] getAllVenues - CONNECTION NULL");
                return list;
            }
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            int count = 0;
            while (rs.next()) {
                count++;
                Venue v = mapVenue(rs);
                list.add(v);
                System.out.println("[AllVenues] Row " + count + ": " + v.getVenueName() + " (user_id = " + v.getUserId() + ")");
            }
            System.out.println("[VenueDAO] getAllVenues - Tổng: " + count);
        } catch (SQLException e) {
            System.err.println("[VenueDAO] getAllVenues ERROR: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeQuietly(rs, ps);
        }
        return list;
    }

    public List<String> getVenueImages(int venueId) {
        List<String> images = new ArrayList<>();
        String sql = """
            SELECT image_url
            FROM VenueImages
            WHERE venue_id = ?
            ORDER BY display_order, image_id
            """;
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, venueId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    images.add(rs.getString("image_url"));
                }
            }
        } catch (SQLException e) {
            System.err.println("[VenueDAO] getVenueImages lỗi: " + e.getMessage());
            e.printStackTrace();
        }
        return images;
    }

    public List<Field> getFieldsByVenue(int venueId) {
        List<Field> fields = new ArrayList<>();
        String sql = """
            SELECT f.field_id, f.venue_id, f.sport_type_id, f.field_name,
                   STRING_AGG(fi.image_url, ',') WITHIN GROUP (ORDER BY fi.image_id) AS image_urls
            FROM Field f
            LEFT JOIN FieldImages fi ON f.field_id = fi.field_id
            WHERE f.venue_id = ?
            GROUP BY f.field_id, f.venue_id, f.sport_type_id, f.field_name
            ORDER BY f.field_id
            """;

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            if (conn == null) {
                return fields;
            }
            ps = conn.prepareStatement(sql);
            ps.setInt(1, venueId);
            rs = ps.executeQuery();
            while (rs.next()) {
                Field f = new Field();
                f.setFieldId(rs.getInt("field_id"));
                f.setVenueId(rs.getInt("venue_id"));
                f.setSportTypeId(rs.getInt("sport_type_id"));
                f.setFieldName(rs.getString("field_name"));
                String urls = rs.getString("image_urls");
                if (urls != null && !urls.isEmpty()) {
                    List<String> imageList = new ArrayList<>();
                    for (String url : urls.split(",")) {
                        String trimmed = url.trim();
                        if (!trimmed.isEmpty()) {
                            imageList.add(trimmed);
                        }
                    }
                    f.setImageUrls(imageList); // giả sử Field có setter này
                }
                fields.add(f);
            }
        } catch (SQLException e) {
            System.err.println("[VenueDAO] getFieldsByVenue - LỖI: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeQuietly(rs, ps);
        }
        return fields;
    }

    public boolean hasBookings(int venueId) {
        String sql = """
            SELECT COUNT(*)
            FROM Booking b
            JOIN Field f ON b.field_id = f.field_id
            WHERE f.venue_id = ?
            """;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            if (conn == null) {
                return false;
            }
            ps = conn.prepareStatement(sql);
            ps.setInt(1, venueId);
            rs = ps.executeQuery();
            if (rs.next()) {
                boolean has = rs.getInt(1) > 0;
                System.out.println("[VenueDAO] hasBookings - venue " + venueId + " có booking: " + has);
                return has;
            }
        } catch (SQLException e) {
            System.err.println("[VenueDAO] hasBookings - LỖI: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeQuietly(rs, ps);
        }
        return false;
    }

    // ────────────────────────────────────────────────
    // CREATE / UPDATE / DELETE
    // ────────────────────────────────────────────────
    /**
     * Thêm venue mới và trả về venue_id mới sinh
     *
     * @param venue Object Venue cần thêm (sẽ được cập nhật venueId)
     * @return venue_id mới (hoặc -1 nếu lỗi)
     */
    public int addVenue(Venue venue) {
        String sql = """
            INSERT INTO Venue (user_id, venue_name, province_id, district_id,
                               address_detail, description, open_time, close_time, status)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
            """;

        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            if (conn == null) {
                System.err.println("[VenueDAO] addVenue - CONNECTION NULL");
                return -1;
            }

            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, venue.getUserId());
            ps.setString(2, venue.getVenueName());
            ps.setInt(3, venue.getProvinceId());
            ps.setInt(4, venue.getDistrictId());
            ps.setString(5, venue.getAddressDetail());
            ps.setString(6, venue.getDescription());
            ps.setTime(7, venue.getOpenTime());
            ps.setTime(8, venue.getCloseTime());
            ps.setString(9, venue.getStatus() != null ? venue.getStatus() : "Hoạt động");

            int rows = ps.executeUpdate();
            if (rows == 0) {
                return -1;
            }

            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    int newId = generatedKeys.getInt(1);
                    venue.setVenueId(newId);
                    System.out.println("[VenueDAO] addVenue - THÀNH CÔNG - venue_id mới: " + newId);
                    return newId;
                }
            }
        } catch (SQLException e) {
            System.err.println("[VenueDAO] addVenue - LỖI SQL: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeQuietly(null, ps);
        }
        return -1;
    }

    public void addVenueImages(int venueId, List<String> imageUrls) {
        String sql = "INSERT INTO VenueImages (venue_id, image_url, display_order) VALUES (?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            if (conn == null) {
                return;
            }
            ps = conn.prepareStatement(sql);
            int order = 0;
            for (String url : imageUrls) {
                ps.setInt(1, venueId);
                ps.setString(2, url);
                ps.setInt(3, order++);
                ps.addBatch();
            }
            ps.executeBatch();
            System.out.println("[VenueDAO] addVenueImages - Đã thêm " + imageUrls.size() + " ảnh cho venue " + venueId);
        } catch (SQLException e) {
            System.err.println("[VenueDAO] addVenueImages - LỖI: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeQuietly(null, ps);
        }
    }

    public void updateVenue(Venue venue) {
        String sql = """
            UPDATE Venue
            SET venue_name = ?, province_id = ?, district_id = ?,
                address_detail = ?, description = ?, open_time = ?,
                close_time = ?, status = ?
            WHERE venue_id = ?
            """;
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            if (conn == null) {
                return;
            }
            ps = conn.prepareStatement(sql);
            ps.setString(1, venue.getVenueName());
            ps.setInt(2, venue.getProvinceId());
            ps.setInt(3, venue.getDistrictId());
            ps.setString(4, venue.getAddressDetail());
            ps.setString(5, venue.getDescription());
            ps.setTime(6, venue.getOpenTime());
            ps.setTime(7, venue.getCloseTime());
            ps.setString(8, venue.getStatus());
            ps.setInt(9, venue.getVenueId());
            int rows = ps.executeUpdate();
            System.out.println("[VenueDAO] updateVenue - Cập nhật " + rows + " dòng cho venue_id " + venue.getVenueId());
        } catch (SQLException e) {
            System.err.println("[VenueDAO] updateVenue - LỖI: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeQuietly(null, ps);
        }
    }

    public boolean updateVenueWithOwner(Venue venue) {
        String sql = """
            UPDATE Venue
            SET venue_name = ?, province_id = ?, district_id = ?,
                address_detail = ?, description = ?, open_time = ?,
                close_time = ?, status = ?
            WHERE venue_id = ? AND user_id = ?
            """;
        Connection conn = DBConnection.getConnection();
        if (conn == null) {
            return false;
        }

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
            boolean success = ps.executeUpdate() > 0;
            System.out.println("[VenueDAO] updateVenueWithOwner - " + (success ? "THÀNH CÔNG" : "THẤT BẠI"));
            return success;
        } catch (SQLException e) {
            System.err.println("[VenueDAO] updateVenueWithOwner - LỖI: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public void hideVenue(int venueId) {
        String sql = "UPDATE Venue SET status = N'Ẩn' WHERE venue_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            if (conn == null) {
                return;
            }
            ps = conn.prepareStatement(sql);
            ps.setInt(1, venueId);
            int rows = ps.executeUpdate();
            System.out.println("[VenueDAO] hideVenue - Cập nhật " + rows + " dòng");
        } catch (SQLException e) {
            System.err.println("[VenueDAO] hideVenue - LỖI: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeQuietly(null, ps);
        }
    }

    public boolean hideVenue(int venueId, int ownerId) {
        String checkSql = """
            SELECT COUNT(*)
            FROM Booking b
            JOIN Field f ON b.field_id = f.field_id
            WHERE f.venue_id = ?
              AND b.booking_status IN ('Đã xác nhận', 'Chờ thanh toán')
            """;
        Connection conn = DBConnection.getConnection();
        if (conn == null) {
            return false;
        }

        try (PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
            checkPs.setInt(1, venueId);
            try (ResultSet rs = checkPs.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    System.out.println("[VenueDAO] hideVenue - Còn booking đang hoạt động");
                    return false;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }

        String sql = "UPDATE Venue SET status = N'Ẩn' WHERE venue_id = ? AND user_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, venueId);
            ps.setInt(2, ownerId);
            boolean success = ps.executeUpdate() > 0;
            System.out.println("[VenueDAO] hideVenue - " + (success ? "THÀNH CÔNG" : "THẤT BẠI"));
            return success;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public void deleteVenueImage(String imageUrl) {
        String sql = "DELETE FROM VenueImages WHERE image_url = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, imageUrl);
            ps.executeUpdate();
            System.out.println("[VenueDAO] deleteVenueImage - Xóa ảnh: " + imageUrl);
        } catch (SQLException e) {
            System.err.println("[VenueDAO] deleteVenueImage lỗi: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // ────────────────────────────────────────────────
    // HELPER METHODS
    // ────────────────────────────────────────────────
    private Venue mapVenue(ResultSet rs) throws SQLException {
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

    private void closeQuietly(ResultSet rs, PreparedStatement ps) {
        try {
            if (rs != null) {
                rs.close();
            }
        } catch (Exception ignored) {
        }
        try {
            if (ps != null) {
                ps.close();
            }
        } catch (Exception ignored) {
        }
    }
}

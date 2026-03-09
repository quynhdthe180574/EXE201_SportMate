package dao;

import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AdminVenueDAO {

    /**
     * Lấy tất cả venues kèm thông tin chi tiết
     */
    public List<Map<String, Object>> getAllVenuesForAdmin() {
        List<Map<String, Object>> list = new ArrayList<>();

        // Query cơ bản (giống bản cũ đã chạy tốt)
        String sqlBase = """
                SELECT v.venue_id, v.venue_name, v.address_detail,
                       v.open_time, v.close_time, v.status,
                       u.fullname AS owner_name, u.email AS owner_email, u.user_id AS owner_id,
                       p.province_name, d.district_name
                FROM Venue v
                LEFT JOIN Users u ON v.user_id = u.user_id
                LEFT JOIN Province p ON v.province_id = p.province_id
                LEFT JOIN Districts d ON v.district_id = d.district_id
                ORDER BY v.venue_id DESC
                """;

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            if (conn == null) {
                System.err.println("[AdminVenueDAO] CONNECTION NULL - không thể kết nối DB!");
                return list;
            }

            ps = conn.prepareStatement(sqlBase);
            rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("venueId", rs.getInt("venue_id"));
                map.put("venueName", rs.getString("venue_name"));
                map.put("addressDetail", rs.getString("address_detail"));
                map.put("openTime", rs.getTime("open_time"));
                map.put("closeTime", rs.getTime("close_time"));

                // Chuẩn hóa status
                String rawStatus = rs.getString("status");
                map.put("status", normalizeStatus(rawStatus));

                map.put("ownerName", rs.getString("owner_name"));
                map.put("ownerEmail", rs.getString("owner_email"));
                map.put("ownerId", rs.getInt("owner_id"));
                map.put("provinceName", rs.getString("province_name"));
                map.put("districtName", rs.getString("district_name"));

                // Giá trị mặc định
                map.put("fieldCount", 0);
                map.put("bookingCount", 0);
                map.put("totalRevenue", 0.0);
                map.put("avgRating", 0.0);
                map.put("reviewCount", 0);
                list.add(map);
            }
            System.out.println("[AdminVenueDAO] === Loaded " + list.size() + " venues ===");
        } catch (Exception e) {
            System.err.println("[AdminVenueDAO] LỖI query cơ bản: " + e.getClass().getName() + " - " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null)
                    rs.close();
            } catch (Exception ignored) {
            }
            try {
                if (ps != null)
                    ps.close();
            } catch (Exception ignored) {
            }
            try {
                if (conn != null)
                    conn.close();
            } catch (Exception ignored) {
            }
        }

        // Load thống kê cho từng venue
        for (Map<String, Object> venue : list) {
            int venueId = (int) venue.get("venueId");
            loadVenueStats(venue, venueId);
        }

        return list;
    }

    private String normalizeStatus(String rawStatus) {
        if (rawStatus == null)
            return "active";
        String s = rawStatus.trim().toLowerCase();
        if (s.equals("hidden") || s.contains("ẩn") || s.equals("inactive")) {
            return "hidden";
        }
        return "active";
    }

    private void loadVenueStats(Map<String, Object> venue, int venueId) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        // Đếm số sân con
        try {
            conn = DBConnection.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement("SELECT COUNT(*) AS cnt FROM Field WHERE venue_id = ?");
                ps.setInt(1, venueId);
                rs = ps.executeQuery();
                if (rs.next()) {
                    int cnt = rs.getInt("cnt");
                    venue.put("fieldCount", cnt);
                }
            }
        } catch (Exception e) {
            System.err.println("[AdminVenueDAO] Lỗi đếm field venue " + venueId + ": " + e.getMessage());
        } finally {
            try {
                if (rs != null)
                    rs.close();
            } catch (Exception ignored) {
            }
            try {
                if (ps != null)
                    ps.close();
            } catch (Exception ignored) {
            }
            try {
                if (conn != null)
                    conn.close();
            } catch (Exception ignored) {
            }
        }

        // Đếm lượt đặt + doanh thu
        conn = null;
        ps = null;
        rs = null;
        try {
            conn = DBConnection.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(
                        "SELECT COUNT(b.booking_id) AS booking_count, COALESCE(SUM(b.total_price), 0) AS total_revenue "
                                +
                                "FROM Booking b JOIN Field f ON b.field_id = f.field_id WHERE f.venue_id = ?");
                ps.setInt(1, venueId);
                rs = ps.executeQuery();
                if (rs.next()) {
                    venue.put("bookingCount", rs.getInt("booking_count"));
                    venue.put("totalRevenue", rs.getDouble("total_revenue"));
                }
            }
        } catch (Exception e) {
            System.err.println("[AdminVenueDAO] Lỗi đếm booking venue " + venueId + ": " + e.getMessage());
        } finally {
            try {
                if (rs != null)
                    rs.close();
            } catch (Exception ignored) {
            }
            try {
                if (ps != null)
                    ps.close();
            } catch (Exception ignored) {
            }
            try {
                if (conn != null)
                    conn.close();
            } catch (Exception ignored) {
            }
        }

        // Rating trung bình + số review
        conn = null;
        ps = null;
        rs = null;
        try {
            conn = DBConnection.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(
                        "SELECT COUNT(r.review_id) AS review_count, COALESCE(AVG(r.rating * 1.0), 0) AS avg_rating " +
                                "FROM Review r JOIN Field f ON r.field_id = f.field_id WHERE f.venue_id = ?");
                ps.setInt(1, venueId);
                rs = ps.executeQuery();
                if (rs.next()) {
                    venue.put("reviewCount", rs.getInt("review_count"));
                    venue.put("avgRating", rs.getDouble("avg_rating"));
                }
            }
        } catch (Exception e) {
            System.err.println("[AdminVenueDAO] Lỗi đếm review venue " + venueId + ": " + e.getMessage());
        } finally {
            try {
                if (rs != null)
                    rs.close();
            } catch (Exception ignored) {
            }
            try {
                if (ps != null)
                    ps.close();
            } catch (Exception ignored) {
            }
            try {
                if (conn != null)
                    conn.close();
            } catch (Exception ignored) {
            }
        }
    }

    public boolean hideVenue(int venueId) {
        String sql = "UPDATE Venue SET status = 'hidden' WHERE venue_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, venueId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean showVenue(int venueId) {
        String sql = "UPDATE Venue SET status = 'active' WHERE venue_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, venueId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}

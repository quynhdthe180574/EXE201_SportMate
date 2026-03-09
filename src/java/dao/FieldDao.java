package dao;

import model.Field;
import util.DBConnection;
import java.sql.*;
import java.util.*;

/**
 * Data Access Object cho Field và các chức năng liên quan
 * (tìm kiếm, filter, chi tiết sân, giá, slot trống, top booked, venue level, v.v.)
 * Tương thích DBConnection singleton - không đóng connection trong DAO
 */
public class FieldDao {

    // ────────────────────────────────────────────────
    //                  BASIC CRUD & VENUE-LEVEL
    // ────────────────────────────────────────────────

    /**
     * Lấy danh sách Field thuộc một Venue (dùng cho owner hoặc VenueDetail)
     */
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

    /**
     * Thêm một Field mới và gán field_id sinh tự động
     */
    public void addField(Field field) {
        String sql = "INSERT INTO Field (venue_id, sport_type_id, field_name) VALUES (?, ?, ?)";

        Connection conn = DBConnection.getConnection();
        if (conn == null) return;

        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, field.getVenueId());
            ps.setInt(2, field.getSportTypeId());
            ps.setString(3, field.getFieldName());
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    field.setFieldId(rs.getInt(1));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ────────────────────────────────────────────────
    //                  ALL FIELDS + PAGINATION
    // ────────────────────────────────────────────────

    /**
     * Lấy tất cả sân với phân trang, sort (cho danh sách sân)
     */
    public List<Map<String, Object>> getAllFields(int page, int pageSize, String sortBy, String order) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        String safeSortBy = sanitizeSortBy(sortBy);
        String safeOrder = sanitizeOrder(order);

        String sql = """
            SELECT f.field_id, f.field_name, v.venue_name, p.province_name, d.district_name,
                   st.sport_name, ISNULL(AVG(r.rating), 0) as avg_rating, COUNT(r.review_id) as review_count,
                   ISNULL(MIN(fp.price), 0) as min_price, ISNULL(MAX(fp.price), 0) as max_price,
                   v.open_time, v.close_time, v.address_detail
            FROM Field f
            JOIN Venue v ON f.venue_id = v.venue_id
            JOIN Province p ON v.province_id = p.province_id
            JOIN Districts d ON v.district_id = d.district_id
            JOIN SportTypes st ON f.sport_type_id = st.sport_type_id
            LEFT JOIN FieldPrices fp ON f.field_id = fp.field_id
            LEFT JOIN Review r ON f.field_id = r.field_id
            GROUP BY f.field_id, f.field_name, v.venue_name, p.province_name, d.district_name,
                     st.sport_name, v.open_time, v.close_time, v.address_detail
            ORDER BY %s %s
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """.formatted(safeSortBy, safeOrder);

        Connection conn = DBConnection.getConnection();
        if (conn == null) return list;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, (page - 1) * pageSize);
            ps.setInt(2, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("fieldId", rs.getInt("field_id"));
                    map.put("fieldName", rs.getString("field_name"));
                    map.put("venueName", rs.getString("venue_name"));
                    map.put("provinceName", rs.getString("province_name"));
                    map.put("districtName", rs.getString("district_name"));
                    map.put("sportName", rs.getString("sport_name"));
                    map.put("avgRating", rs.getDouble("avg_rating"));
                    map.put("reviewCount", rs.getInt("review_count"));
                    map.put("minPrice", rs.getDouble("min_price"));
                    map.put("maxPrice", rs.getDouble("max_price"));
                    map.put("openTime", rs.getTime("open_time"));
                    map.put("closeTime", rs.getTime("close_time"));
                    map.put("addressDetail", rs.getString("address_detail"));
                    list.add(map);
                }
            }
        }
        return list;
    }

    /**
     * Tổng số sân (cho phân trang)
     */
    public int getTotalFields() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Field";
        Connection conn = DBConnection.getConnection();
        if (conn == null) return 0;

        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    // ────────────────────────────────────────────────
    //                  SEARCH + FILTER (FULL)
    // ────────────────────────────────────────────────

    public List<Map<String, Object>> searchAndFilterFields(
            String keyword, Integer provinceId, Integer districtId, List<Integer> sportTypeIds,
            Double minPrice, Double maxPrice, int page, int pageSize, String sortBy, String order) throws SQLException {

        String safeSortBy = sanitizeSortBy(sortBy);
        String safeOrder = sanitizeOrder(order);

        List<Map<String, Object>> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
            SELECT f.field_id, f.field_name, v.venue_name, p.province_name, d.district_name,
                   st.sport_name, ISNULL(AVG(r.rating), 0) as avg_rating, COUNT(r.review_id) as review_count,
                   ISNULL(MIN(fp.price), 0) as min_price, ISNULL(MAX(fp.price), 0) as max_price,
                   v.open_time, v.close_time, v.address_detail
            FROM Field f
            JOIN Venue v ON f.venue_id = v.venue_id
            JOIN Province p ON v.province_id = p.province_id
            JOIN Districts d ON v.district_id = d.district_id
            JOIN SportTypes st ON f.sport_type_id = st.sport_type_id
            LEFT JOIN FieldPrices fp ON f.field_id = fp.field_id
            LEFT JOIN Review r ON f.field_id = r.field_id
            WHERE v.status = N'Hoạt động'
            """);

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (f.field_name LIKE ? OR v.venue_name LIKE ? OR v.address_detail LIKE ?)");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }
        if (provinceId != null) {
            sql.append(" AND v.province_id = ?");
            params.add(provinceId);
        }
        if (districtId != null) {
            sql.append(" AND v.district_id = ?");
            params.add(districtId);
        }
        if (sportTypeIds != null && !sportTypeIds.isEmpty()) {
            StringBuilder placeholders = new StringBuilder();
            for (int i = 0; i < sportTypeIds.size(); i++) {
                if (i > 0) placeholders.append(",");
                placeholders.append("?");
                params.add(sportTypeIds.get(i));
            }
            sql.append(" AND f.sport_type_id IN (").append(placeholders).append(")");
        }
        if (minPrice != null) {
            sql.append(" AND fp.price >= ?");
            params.add(minPrice);
        }
        if (maxPrice != null) {
            sql.append(" AND fp.price <= ?");
            params.add(maxPrice);
        }

        sql.append(" GROUP BY f.field_id, f.field_name, v.venue_name, p.province_name, d.district_name, st.sport_name, v.open_time, v.close_time, v.address_detail");
        sql.append(" ORDER BY ").append(safeSortBy).append(" ").append(safeOrder);
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        Connection conn = DBConnection.getConnection();
        if (conn == null) return list;

        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int index = 1;
            for (Object param : params) {
                ps.setObject(index++, param);
            }
            ps.setInt(index++, (page - 1) * pageSize);
            ps.setInt(index, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("fieldId", rs.getInt("field_id"));
                    map.put("fieldName", rs.getString("field_name"));
                    map.put("venueName", rs.getString("venue_name"));
                    map.put("provinceName", rs.getString("province_name"));
                    map.put("districtName", rs.getString("district_name"));
                    map.put("sportName", rs.getString("sport_name"));
                    map.put("avgRating", rs.getDouble("avg_rating"));
                    map.put("reviewCount", rs.getInt("review_count"));
                    map.put("minPrice", rs.getDouble("min_price"));
                    map.put("maxPrice", rs.getDouble("max_price"));
                    map.put("openTime", rs.getTime("open_time"));
                    map.put("closeTime", rs.getTime("close_time"));
                    map.put("addressDetail", rs.getString("address_detail"));
                    list.add(map);
                }
            }
        }
        return list;
    }

    // Backward compatible: single sportTypeId
    public List<Map<String, Object>> searchAndFilterFields(
            String keyword, Integer provinceId, Integer districtId, Integer sportTypeId,
            Double minPrice, Double maxPrice, int page, int pageSize, String sortBy, String order) throws SQLException {
        List<Integer> ids = sportTypeId != null ? List.of(sportTypeId) : null;
        return searchAndFilterFields(keyword, provinceId, districtId, ids, minPrice, maxPrice, page, pageSize, sortBy, order);
    }

    public int getTotalFiltered(String keyword, Integer provinceId, Integer districtId, List<Integer> sportTypeIds,
            Double minPrice, Double maxPrice) throws SQLException {
        StringBuilder sql = new StringBuilder("""
            SELECT COUNT(DISTINCT f.field_id)
            FROM Field f
            JOIN Venue v ON f.venue_id = v.venue_id
            JOIN Province p ON v.province_id = p.province_id
            JOIN Districts d ON v.district_id = d.district_id
            JOIN SportTypes st ON f.sport_type_id = st.sport_type_id
            LEFT JOIN FieldPrices fp ON f.field_id = fp.field_id
            WHERE v.status = N'Hoạt động'
            """);

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (f.field_name LIKE ? OR v.venue_name LIKE ? OR v.address_detail LIKE ?)");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }
        if (provinceId != null) {
            sql.append(" AND v.province_id = ?");
            params.add(provinceId);
        }
        if (districtId != null) {
            sql.append(" AND v.district_id = ?");
            params.add(districtId);
        }
        if (sportTypeIds != null && !sportTypeIds.isEmpty()) {
            StringBuilder placeholders = new StringBuilder();
            for (int i = 0; i < sportTypeIds.size(); i++) {
                if (i > 0) placeholders.append(",");
                placeholders.append("?");
                params.add(sportTypeIds.get(i));
            }
            sql.append(" AND f.sport_type_id IN (").append(placeholders).append(")");
        }
        if (minPrice != null) {
            sql.append(" AND fp.price >= ?");
            params.add(minPrice);
        }
        if (maxPrice != null) {
            sql.append(" AND fp.price <= ?");
            params.add(maxPrice);
        }

        Connection conn = DBConnection.getConnection();
        if (conn == null) return 0;

        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int index = 1;
            for (Object param : params) {
                ps.setObject(index++, param);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    public int getTotalFiltered(String keyword, Integer provinceId, Integer districtId, Integer sportTypeId,
            Double minPrice, Double maxPrice) throws SQLException {
        List<Integer> ids = sportTypeId != null ? List.of(sportTypeId) : null;
        return getTotalFiltered(keyword, provinceId, districtId, ids, minPrice, maxPrice);
    }

    // ────────────────────────────────────────────────
    //                  FIELD DETAIL & PRICES & SLOTS
    // ────────────────────────────────────────────────

    public Map<String, Object> getFieldDetail(int fieldId) throws SQLException {
        String sql = """
            SELECT f.field_id, f.field_name, v.venue_name, v.description, v.address_detail,
                   p.province_name, d.district_name, st.sport_name,
                   v.open_time, v.close_time,
                   ISNULL(AVG(r.rating), 0) as avg_rating, COUNT(r.review_id) as review_count
            FROM Field f
            JOIN Venue v ON f.venue_id = v.venue_id
            JOIN Province p ON v.province_id = p.province_id
            JOIN Districts d ON v.district_id = d.district_id
            JOIN SportTypes st ON f.sport_type_id = st.sport_type_id
            LEFT JOIN Review r ON f.field_id = r.field_id
            WHERE f.field_id = ?
            GROUP BY f.field_id, f.field_name, v.venue_name, v.description, v.address_detail,
                     p.province_name, d.district_name, st.sport_name, v.open_time, v.close_time
            """;

        Connection conn = DBConnection.getConnection();
        if (conn == null) return null;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, fieldId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("fieldId", rs.getInt("field_id"));
                    map.put("fieldName", rs.getString("field_name"));
                    map.put("venueName", rs.getString("venue_name"));
                    map.put("description", rs.getString("description"));
                    map.put("addressDetail", rs.getString("address_detail"));
                    map.put("provinceName", rs.getString("province_name"));
                    map.put("districtName", rs.getString("district_name"));
                    map.put("sportName", rs.getString("sport_name"));
                    map.put("openTime", rs.getTime("open_time"));
                    map.put("closeTime", rs.getTime("close_time"));
                    map.put("avgRating", rs.getDouble("avg_rating"));
                    map.put("reviewCount", rs.getInt("review_count"));
                    return map;
                }
            }
        }
        return null;
    }

    public List<Map<String, Object>> getFieldPrices(int fieldId) throws SQLException {
        List<Map<String, Object>> prices = new ArrayList<>();
        String sql = """
            SELECT ts.start_time, ts.end_time, fp.price
            FROM FieldPrices fp
            JOIN TimeSlot ts ON fp.slot_id = ts.slot_id
            WHERE fp.field_id = ?
            ORDER BY ts.start_time
            """;

        Connection conn = DBConnection.getConnection();
        if (conn == null) return prices;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, fieldId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("startTime", rs.getTime("start_time"));
                    map.put("endTime", rs.getTime("end_time"));
                    map.put("price", rs.getDouble("price"));
                    prices.add(map);
                }
            }
        }
        return prices;
    }

    public List<Map<String, Object>> getAvailableSlots(int fieldId, java.sql.Date bookingDate) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
            SELECT
                ts.slot_id,
                ts.start_time,
                ts.end_time,
                fp.price,
                CASE
                    WHEN b.booking_id IS NOT NULL THEN 'BOOKED'
                    ELSE 'AVAILABLE'
                END AS status
            FROM TimeSlot ts
            JOIN FieldPrices fp ON ts.slot_id = fp.slot_id
            LEFT JOIN Booking b ON b.field_id = ?
                               AND b.slot_id = ts.slot_id
                               AND b.booking_date = ?
                               AND b.booking_status != 'cancelled'
            WHERE fp.field_id = ?
            ORDER BY ts.start_time
            """;

        Connection conn = DBConnection.getConnection();
        if (conn == null) return list;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, fieldId);
            ps.setDate(2, bookingDate);
            ps.setInt(3, fieldId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("slotId", rs.getInt("slot_id"));
                    map.put("startTime", rs.getTime("start_time"));
                    map.put("endTime", rs.getTime("end_time"));
                    map.put("price", rs.getDouble("price"));
                    map.put("status", rs.getString("status"));
                    list.add(map);
                }
            }
        } catch (SQLException e) {
            System.err.println("[FieldDAO] getAvailableSlots lỗi: " + e.getMessage() + " → fallback AVAILABLE");
            String fallbackSql = """
                SELECT
                    ts.slot_id,
                    ts.start_time,
                    ts.end_time,
                    fp.price,
                    'AVAILABLE' AS status
                FROM TimeSlot ts
                JOIN FieldPrices fp ON ts.slot_id = fp.slot_id
                WHERE fp.field_id = ?
                ORDER BY ts.start_time
                """;
            try (PreparedStatement psFallback = conn.prepareStatement(fallbackSql)) {
                psFallback.setInt(1, fieldId);
                try (ResultSet rs = psFallback.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> map = new HashMap<>();
                        map.put("slotId", rs.getInt("slot_id"));
                        map.put("startTime", rs.getTime("start_time"));
                        map.put("endTime", rs.getTime("end_time"));
                        map.put("price", rs.getDouble("price"));
                        map.put("status", rs.getString("status"));
                        list.add(map);
                    }
                }
            }
        }
        return list;
    }

    // ────────────────────────────────────────────────
    //                  UTILITY & SUPPORT METHODS
    // ────────────────────────────────────────────────

    public static String sanitizeSortBy(String sortBy) {
        if (sortBy == null) return "AVG(r.rating)";
        return switch (sortBy) {
            case "MIN(fp.price)" -> "MIN(fp.price)";
            case "AVG(r.rating)" -> "AVG(r.rating)";
            case "COUNT(r.review_id)" -> "COUNT(r.review_id)";
            default -> "AVG(r.rating)";
        };
    }

    public static String sanitizeOrder(String order) {
        if ("ASC".equalsIgnoreCase(order)) return "ASC";
        return "DESC";
    }

    public List<Map<String, Object>> getSportTypesWithCount() throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
            SELECT st.sport_type_id, st.sport_name, COUNT(f.field_id) as field_count
            FROM SportTypes st
            LEFT JOIN Field f ON st.sport_type_id = f.sport_type_id
            LEFT JOIN Venue v ON f.venue_id = v.venue_id AND v.status = N'Hoạt động'
            GROUP BY st.sport_type_id, st.sport_name
            ORDER BY st.sport_name
            """;

        Connection conn = DBConnection.getConnection();
        if (conn == null) return list;

        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("sportTypeId", rs.getInt("sport_type_id"));
                map.put("sportName", rs.getString("sport_name"));
                map.put("fieldCount", rs.getInt("field_count"));
                list.add(map);
            }
        }
        return list;
    }

    public Map<String, Double> getPriceRange() throws SQLException {
        Map<String, Double> range = new HashMap<>();
        String sql = "SELECT MIN(price) as min_price, MAX(price) as max_price FROM FieldPrices";

        Connection conn = DBConnection.getConnection();
        if (conn == null) return range;

        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                range.put("minPrice", rs.getDouble("min_price"));
                range.put("maxPrice", rs.getDouble("max_price"));
            }
        }
        return range;
    }

    public List<Map<String, Object>> getProvinces() throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT province_id, province_name FROM Province ORDER BY province_name";

        Connection conn = DBConnection.getConnection();
        if (conn == null) return list;

        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("provinceId", rs.getInt("province_id"));
                map.put("provinceName", rs.getString("province_name"));
                list.add(map);
            }
        }
        return list;
    }

    public List<Map<String, Object>> getDistricts(Integer provinceId) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT district_id, district_name FROM Districts";
        if (provinceId != null) {
            sql += " WHERE province_id = ?";
        }
        sql += " ORDER BY district_name";

        Connection conn = DBConnection.getConnection();
        if (conn == null) return list;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            if (provinceId != null) ps.setInt(1, provinceId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("districtId", rs.getInt("district_id"));
                    map.put("districtName", rs.getString("district_name"));
                    list.add(map);
                }
            }
        }
        return list;
    }

    public List<Map<String, Object>> getSportTypes() throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT sport_type_id, sport_name FROM SportTypes ORDER BY sport_name";

        Connection conn = DBConnection.getConnection();
        if (conn == null) return list;

        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("sportTypeId", rs.getInt("sport_type_id"));
                map.put("sportName", rs.getString("sport_name"));
                list.add(map);
            }
        }
        return list;
    }

    public List<Map<String, Object>> getTimeSlots() throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT slot_id, start_time, end_time FROM TimeSlot ORDER BY start_time";

        Connection conn = DBConnection.getConnection();
        if (conn == null) return list;

        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("slotId", rs.getInt("slot_id"));
                map.put("startTime", rs.getTime("start_time"));
                map.put("endTime", rs.getTime("end_time"));
                list.add(map);
            }
        }
        return list;
    }

    public Map<String, Object> getTimeSlotById(int slotId) throws SQLException {
        String sql = "SELECT start_time, end_time FROM TimeSlot WHERE slot_id = ?";

        Connection conn = DBConnection.getConnection();
        if (conn == null) return null;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, slotId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("startTime", rs.getTime("start_time"));
                    map.put("endTime", rs.getTime("end_time"));
                    return map;
                }
            }
        }
        return null;
    }

    // ────────────────────────────────────────────────
    //                  AVAILABLE FIELDS BY DATE + SLOT
    // ────────────────────────────────────────────────

    public List<Map<String, Object>> getAvailableFields(
            String keyword, Integer provinceId, Integer districtId, Integer sportTypeId,
            Double minPrice, Double maxPrice, java.sql.Date bookingDate, int slotId,
            int page, int pageSize, String sortBy, String order) throws SQLException {

        List<Map<String, Object>> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
            SELECT f.field_id, f.field_name, v.venue_name, p.province_name, d.district_name,
                   st.sport_name, ISNULL(AVG(r.rating), 0) as avg_rating, COUNT(r.review_id) as review_count,
                   fp.price as slot_price, ts.start_time, ts.end_time,
                   v.open_time, v.close_time, v.address_detail
            FROM Field f
            JOIN Venue v ON f.venue_id = v.venue_id
            JOIN Province p ON v.province_id = p.province_id
            JOIN Districts d ON v.district_id = d.district_id
            JOIN SportTypes st ON f.sport_type_id = st.sport_type_id
            JOIN FieldPrices fp ON f.field_id = fp.field_id AND fp.slot_id = ?
            JOIN TimeSlot ts ON fp.slot_id = ts.slot_id
            LEFT JOIN Review r ON f.field_id = r.field_id
            LEFT JOIN Booking b ON f.field_id = b.field_id
                AND b.booking_date = ? AND b.slot_id = ? AND b.booking_status != 'cancelled'
            WHERE b.booking_id IS NULL
            """);

        List<Object> params = new ArrayList<>();
        params.add(slotId);
        params.add(bookingDate);
        params.add(slotId);

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (f.field_name LIKE ? OR v.venue_name LIKE ?)");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }
        if (provinceId != null) {
            sql.append(" AND v.province_id = ?");
            params.add(provinceId);
        }
        if (districtId != null) {
            sql.append(" AND v.district_id = ?");
            params.add(districtId);
        }
        if (sportTypeId != null) {
            sql.append(" AND f.sport_type_id = ?");
            params.add(sportTypeId);
        }
        if (minPrice != null) {
            sql.append(" AND fp.price >= ?");
            params.add(minPrice);
        }
        if (maxPrice != null) {
            sql.append(" AND fp.price <= ?");
            params.add(maxPrice);
        }

        sql.append(" GROUP BY f.field_id, f.field_name, v.venue_name, p.province_name, d.district_name, st.sport_name, fp.price, ts.start_time, ts.end_time, v.open_time, v.close_time, v.address_detail");
        sql.append(" ORDER BY ").append(sortBy).append(" ").append(order);
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        Connection conn = DBConnection.getConnection();
        if (conn == null) return list;

        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int index = 1;
            for (Object param : params) {
                ps.setObject(index++, param);
            }
            ps.setInt(index++, (page - 1) * pageSize);
            ps.setInt(index, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("fieldId", rs.getInt("field_id"));
                    map.put("fieldName", rs.getString("field_name"));
                    map.put("venueName", rs.getString("venue_name"));
                    map.put("provinceName", rs.getString("province_name"));
                    map.put("districtName", rs.getString("district_name"));
                    map.put("sportName", rs.getString("sport_name"));
                    map.put("avgRating", rs.getDouble("avg_rating"));
                    map.put("reviewCount", rs.getInt("review_count"));
                    map.put("slotPrice", rs.getDouble("slot_price"));
                    map.put("slotStartTime", rs.getTime("start_time"));
                    map.put("slotEndTime", rs.getTime("end_time"));
                    map.put("openTime", rs.getTime("open_time"));
                    map.put("closeTime", rs.getTime("close_time"));
                    map.put("addressDetail", rs.getString("address_detail"));
                    list.add(map);
                }
            }
        }
        return list;
    }

    public int getTotalAvailableFields(String keyword, Integer provinceId, Integer districtId, Integer sportTypeId,
            Double minPrice, Double maxPrice, java.sql.Date bookingDate, int slotId) throws SQLException {
        StringBuilder sql = new StringBuilder("""
            SELECT COUNT(DISTINCT f.field_id)
            FROM Field f
            JOIN Venue v ON f.venue_id = v.venue_id
            JOIN Province p ON v.province_id = p.province_id
            JOIN Districts d ON v.district_id = d.district_id
            JOIN SportTypes st ON f.sport_type_id = st.sport_type_id
            JOIN FieldPrices fp ON f.field_id = fp.field_id AND fp.slot_id = ?
            LEFT JOIN Review r ON f.field_id = r.field_id
            LEFT JOIN Booking b ON f.field_id = b.field_id
                AND b.booking_date = ? AND b.slot_id = ? AND b.booking_status != 'cancelled'
            WHERE b.booking_id IS NULL
            """);

        List<Object> params = new ArrayList<>();
        params.add(slotId);
        params.add(bookingDate);
        params.add(slotId);

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (f.field_name LIKE ? OR v.venue_name LIKE ?)");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }
        if (provinceId != null) {
            sql.append(" AND v.province_id = ?");
            params.add(provinceId);
        }
        if (districtId != null) {
            sql.append(" AND v.district_id = ?");
            params.add(districtId);
        }
        if (sportTypeId != null) {
            sql.append(" AND f.sport_type_id = ?");
            params.add(sportTypeId);
        }
        if (minPrice != null) {
            sql.append(" AND fp.price >= ?");
            params.add(minPrice);
        }
        if (maxPrice != null) {
            sql.append(" AND fp.price <= ?");
            params.add(maxPrice);
        }

        Connection conn = DBConnection.getConnection();
        if (conn == null) return 0;

        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int index = 1;
            for (Object param : params) {
                ps.setObject(index++, param);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    // ────────────────────────────────────────────────
    //                  TOP & VENUE LEVEL
    // ────────────────────────────────────────────────

    public List<Map<String, Object>> getTop10MostBookedFields() throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
            SELECT TOP 10
                   f.field_id, f.field_name, v.venue_name, v.address_detail,
                   p.province_name, d.district_name, st.sport_name,
                   COUNT(b.booking_id) AS booking_count,
                   ISNULL(AVG(r.rating), 0) AS avg_rating
            FROM Field f
            JOIN Venue v ON f.venue_id = v.venue_id
            JOIN Province p ON v.province_id = p.province_id
            JOIN Districts d ON v.district_id = d.district_id
            JOIN SportTypes st ON f.sport_type_id = st.sport_type_id
            LEFT JOIN Booking b ON f.field_id = b.field_id
            LEFT JOIN Review r ON f.field_id = r.field_id
            GROUP BY f.field_id, f.field_name, v.venue_name, v.address_detail,
                     p.province_name, d.district_name, st.sport_name
            ORDER BY COUNT(b.booking_id) DESC, ISNULL(AVG(r.rating), 0) DESC
            """;

        Connection conn = DBConnection.getConnection();
        if (conn == null) return list;

        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("fieldId", rs.getInt("field_id"));
                map.put("fieldName", rs.getString("field_name"));
                map.put("venueName", rs.getString("venue_name"));
                map.put("addressDetail", rs.getString("address_detail"));
                map.put("provinceName", rs.getString("province_name"));
                map.put("districtName", rs.getString("district_name"));
                map.put("sportName", rs.getString("sport_name"));
                map.put("bookingCount", rs.getInt("booking_count"));
                map.put("avgRating", rs.getDouble("avg_rating"));
                list.add(map);
            }
        } catch (SQLException e) {
            System.err.println("[FieldDAO] getTop10MostBookedFields lỗi (có thể bảng Booking chưa tồn tại): " + e.getMessage());
            return new ArrayList<>();
        }
        return list;
    }

    public List<Map<String, Object>> getAllVenues(
            String keyword, Integer provinceId, Integer districtId,
            Double minPrice, Double maxPrice,
            int page, int pageSize, String sortBy, String order) throws SQLException {

        List<Map<String, Object>> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
            SELECT v.venue_id, v.venue_name, v.address_detail, v.description,
                   p.province_name, d.district_name,
                   COUNT(f.field_id) AS field_count,
                   ISNULL(AVG(r.rating), 0) AS avg_rating, COUNT(r.review_id) AS review_count,
                   ISNULL(MIN(fp.price), 0) AS min_price, ISNULL(MAX(fp.price), 0) AS max_price,
                   v.open_time, v.close_time
            FROM Venue v
            JOIN Province p ON v.province_id = p.province_id
            JOIN Districts d ON v.district_id = d.district_id
            LEFT JOIN Field f ON v.venue_id = f.venue_id
            LEFT JOIN FieldPrices fp ON f.field_id = fp.field_id
            LEFT JOIN Review r ON f.field_id = r.field_id
            WHERE 1=1
            """);

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (v.venue_name LIKE ? OR v.address_detail LIKE ?)");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }
        if (provinceId != null) {
            sql.append(" AND v.province_id = ?");
            params.add(provinceId);
        }
        if (districtId != null) {
            sql.append(" AND v.district_id = ?");
            params.add(districtId);
        }

        sql.append(" GROUP BY v.venue_id, v.venue_name, v.address_detail, v.description, p.province_name, d.district_name, v.open_time, v.close_time");

        boolean hasPriceFilter = false;
        StringBuilder having = new StringBuilder();
        if (minPrice != null) {
            having.append(" MIN(fp.price) >= ?");
            params.add(minPrice);
            hasPriceFilter = true;
        }
        if (maxPrice != null) {
            if (hasPriceFilter) having.append(" AND ");
            having.append(" MAX(fp.price) <= ?");
            params.add(maxPrice);
            hasPriceFilter = true;
        }
        if (hasPriceFilter) {
            sql.append(" HAVING ").append(having);
        }

        sql.append(" ORDER BY ").append(sortBy).append(" ").append(order);
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        Connection conn = DBConnection.getConnection();
        if (conn == null) return list;

        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int index = 1;
            for (Object param : params) {
                ps.setObject(index++, param);
            }
            ps.setInt(index++, (page - 1) * pageSize);
            ps.setInt(index, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("venueId", rs.getInt("venue_id"));
                    map.put("venueName", rs.getString("venue_name"));
                    map.put("description", rs.getString("description"));
                    map.put("addressDetail", rs.getString("address_detail"));
                    map.put("provinceName", rs.getString("province_name"));
                    map.put("districtName", rs.getString("district_name"));
                    map.put("fieldCount", rs.getInt("field_count"));
                    map.put("avgRating", rs.getDouble("avg_rating"));
                    map.put("reviewCount", rs.getInt("review_count"));
                    map.put("minPrice", rs.getObject("min_price") != null ? rs.getDouble("min_price") : null);
                    map.put("maxPrice", rs.getObject("max_price") != null ? rs.getDouble("max_price") : null);
                    map.put("openTime", rs.getTime("open_time"));
                    map.put("closeTime", rs.getTime("close_time"));
                    list.add(map);
                }
            }
        }
        return list;
    }

    public int getTotalVenues(String keyword, Integer provinceId, Integer districtId,
                              Double minPrice, Double maxPrice) throws SQLException {
        StringBuilder sql = new StringBuilder("""
            SELECT COUNT(*) FROM (
                SELECT v.venue_id
                FROM Venue v
                JOIN Province p ON v.province_id = p.province_id
                JOIN Districts d ON v.district_id = d.district_id
                LEFT JOIN Field f ON v.venue_id = f.venue_id
                LEFT JOIN FieldPrices fp ON f.field_id = fp.field_id
                WHERE 1=1
            """);

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (v.venue_name LIKE ? OR v.address_detail LIKE ?)");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }
        if (provinceId != null) {
            sql.append(" AND v.province_id = ?");
            params.add(provinceId);
        }
        if (districtId != null) {
            sql.append(" AND v.district_id = ?");
            params.add(districtId);
        }

        sql.append(" GROUP BY v.venue_id");

        boolean hasPriceFilter = false;
        StringBuilder having = new StringBuilder();
        if (minPrice != null) {
            having.append(" MIN(fp.price) >= ?");
            params.add(minPrice);
            hasPriceFilter = true;
        }
        if (maxPrice != null) {
            if (hasPriceFilter) having.append(" AND ");
            having.append(" MAX(fp.price) <= ?");
            params.add(maxPrice);
        }
        if (hasPriceFilter) {
            sql.append(" HAVING ").append(having);
        }

        sql.append(") AS sub");

        Connection conn = DBConnection.getConnection();
        if (conn == null) return 0;

        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int index = 1;
            for (Object param : params) {
                ps.setObject(index++, param);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    public Map<String, Object> getVenueDetail(int venueId) throws SQLException {
        String sql = """
            SELECT v.venue_id, v.venue_name, v.description, v.address_detail,
                   p.province_name, d.district_name,
                   v.open_time, v.close_time
            FROM Venue v
            JOIN Province p ON v.province_id = p.province_id
            JOIN Districts d ON v.district_id = d.district_id
            WHERE v.venue_id = ?
            """;

        Connection conn = DBConnection.getConnection();
        if (conn == null) return null;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, venueId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("venueId", rs.getInt("venue_id"));
                    map.put("venueName", rs.getString("venue_name"));
                    map.put("description", rs.getString("description"));
                    map.put("addressDetail", rs.getString("address_detail"));
                    map.put("provinceName", rs.getString("province_name"));
                    map.put("districtName", rs.getString("district_name"));
                    map.put("openTime", rs.getTime("open_time"));
                    map.put("closeTime", rs.getTime("close_time"));
                    return map;
                }
            }
        }
        return null;
    }

    public List<Map<String, Object>> getFieldsByVenueId(int venueId, int page, int pageSize) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
            SELECT f.field_id, f.field_name, st.sport_name,
                   ISNULL(AVG(r.rating), 0) AS avg_rating, COUNT(r.review_id) AS review_count,
                   ISNULL(MIN(fp.price), 0) AS min_price, ISNULL(MAX(fp.price), 0) AS max_price
            FROM Field f
            JOIN SportTypes st ON f.sport_type_id = st.sport_type_id
            LEFT JOIN FieldPrices fp ON f.field_id = fp.field_id
            LEFT JOIN Review r ON f.field_id = r.field_id
            WHERE f.venue_id = ?
            GROUP BY f.field_id, f.field_name, st.sport_name
            ORDER BY f.field_name
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
            """;

        Connection conn = DBConnection.getConnection();
        if (conn == null) return list;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, venueId);
            ps.setInt(2, (page - 1) * pageSize);
            ps.setInt(3, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("fieldId", rs.getInt("field_id"));
                    map.put("fieldName", rs.getString("field_name"));
                    map.put("sportName", rs.getString("sport_name"));
                    map.put("avgRating", rs.getDouble("avg_rating"));
                    map.put("reviewCount", rs.getInt("review_count"));
                    map.put("minPrice", rs.getObject("min_price") != null ? rs.getDouble("min_price") : null);
                    map.put("maxPrice", rs.getObject("max_price") != null ? rs.getDouble("max_price") : null);
                    list.add(map);
                }
            }
        }
        return list;
    }

    // ────────────────────────────────────────────────
    //      FIELD-LEVEL CRUD (Owner Management)
    // ────────────────────────────────────────────────

    public Field getFieldById(int fieldId) {
        String sql = "SELECT field_id, venue_id, sport_type_id, field_name FROM Field WHERE field_id = ?";
        Connection conn = DBConnection.getConnection();
        if (conn == null) return null;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, fieldId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Field f = new Field();
                    f.setFieldId(rs.getInt("field_id"));
                    f.setVenueId(rs.getInt("venue_id"));
                    f.setSportTypeId(rs.getInt("sport_type_id"));
                    f.setFieldName(rs.getString("field_name"));
                    return f;
                }
            }
        } catch (SQLException e) {
            System.err.println("[FieldDao] getFieldById lỗi: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateField(Field field) {
        String sql = "UPDATE Field SET field_name = ?, sport_type_id = ? WHERE field_id = ?";
        Connection conn = DBConnection.getConnection();
        if (conn == null) return false;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, field.getFieldName());
            ps.setInt(2, field.getSportTypeId());
            ps.setInt(3, field.getFieldId());
            int rows = ps.executeUpdate();
            System.out.println("[FieldDao] updateField - field_id " + field.getFieldId() + " → " + rows + " dòng");
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("[FieldDao] updateField lỗi: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean hasBookingsByField(int fieldId) {
        String sql = "SELECT COUNT(*) FROM Booking WHERE field_id = ?";
        Connection conn = DBConnection.getConnection();
        if (conn == null) return true; // an toàn: giả sử có booking

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, fieldId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return true;
    }

    public boolean deleteField(int fieldId) {
        Connection conn = DBConnection.getConnection();
        if (conn == null) return false;

        try {
            // Xóa FieldPrices trước
            try (PreparedStatement ps = conn.prepareStatement("DELETE FROM FieldPrices WHERE field_id = ?")) {
                ps.setInt(1, fieldId);
                ps.executeUpdate();
            }
            // Xóa FieldImages
            try (PreparedStatement ps = conn.prepareStatement("DELETE FROM FieldImages WHERE field_id = ?")) {
                ps.setInt(1, fieldId);
                ps.executeUpdate();
            }
            // Xóa FieldPromotions
            try (PreparedStatement ps = conn.prepareStatement("DELETE FROM FieldPromotions WHERE field_id = ?")) {
                ps.setInt(1, fieldId);
                ps.executeUpdate();
            }
            // Xóa Review
            try (PreparedStatement ps = conn.prepareStatement("DELETE FROM Review WHERE field_id = ?")) {
                ps.setInt(1, fieldId);
                ps.executeUpdate();
            }
            // Xóa Field
            try (PreparedStatement ps = conn.prepareStatement("DELETE FROM Field WHERE field_id = ?")) {
                ps.setInt(1, fieldId);
                int rows = ps.executeUpdate();
                System.out.println("[FieldDao] deleteField - field_id " + fieldId + " → " + rows + " dòng");
                return rows > 0;
            }
        } catch (SQLException e) {
            System.err.println("[FieldDao] deleteField lỗi: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // ────────────────────────────────────────────────
    //      FIELD PRICE MANAGEMENT (Owner)
    // ────────────────────────────────────────────────

    public boolean upsertFieldPrice(int fieldId, int slotId, double price) {
        String checkSql = "SELECT field_price_id FROM FieldPrices WHERE field_id = ? AND slot_id = ?";
        String updateSql = "UPDATE FieldPrices SET price = ? WHERE field_id = ? AND slot_id = ?";
        String insertSql = "INSERT INTO FieldPrices (field_id, slot_id, price) VALUES (?, ?, ?)";

        Connection conn = DBConnection.getConnection();
        if (conn == null) return false;

        try {
            boolean exists = false;
            try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
                ps.setInt(1, fieldId);
                ps.setInt(2, slotId);
                try (ResultSet rs = ps.executeQuery()) {
                    exists = rs.next();
                }
            }
            if (exists) {
                try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                    ps.setDouble(1, price);
                    ps.setInt(2, fieldId);
                    ps.setInt(3, slotId);
                    return ps.executeUpdate() > 0;
                }
            } else {
                try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                    ps.setInt(1, fieldId);
                    ps.setInt(2, slotId);
                    ps.setDouble(3, price);
                    return ps.executeUpdate() > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("[FieldDao] upsertFieldPrice lỗi: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteFieldPrice(int fieldId, int slotId) {
        String sql = "DELETE FROM FieldPrices WHERE field_id = ? AND slot_id = ?";
        Connection conn = DBConnection.getConnection();
        if (conn == null) return false;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, fieldId);
            ps.setInt(2, slotId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Map<String, Object>> getFieldPricesList(int fieldId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
            SELECT ts.slot_id, ts.start_time, ts.end_time, fp.price
            FROM TimeSlot ts
            LEFT JOIN FieldPrices fp ON ts.slot_id = fp.slot_id AND fp.field_id = ?
            ORDER BY ts.start_time
            """;
        Connection conn = DBConnection.getConnection();
        if (conn == null) return list;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, fieldId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("slotId", rs.getInt("slot_id"));
                    map.put("startTime", rs.getTime("start_time"));
                    map.put("endTime", rs.getTime("end_time"));
                    double price = rs.getDouble("price");
                    map.put("price", rs.wasNull() ? null : price);
                    list.add(map);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

}
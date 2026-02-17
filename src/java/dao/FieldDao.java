/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.FieldImage;
import model.Review;

public class FieldDao {
    private Connection connection;

    public FieldDao() {
        connection = new util.DBConnection().getConnection();
    }

    // Lấy tất cả sân (cho danh sách sân + phân trang)
    public List<Map<String, Object>> getAllFields(int page, int pageSize, String sortBy, String order) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
            SELECT f.field_id, f.field_name, v.venue_name, p.province_name, d.district_name,
                   st.sport_name, AVG(r.rating) as avg_rating, COUNT(r.review_id) as review_count,
                   MIN(fp.price) as min_price, MAX(fp.price) as max_price,
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
        """.formatted(sortBy, order);

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, (page - 1) * pageSize);
            ps.setInt(2, pageSize);
            ResultSet rs = ps.executeQuery();
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
        return list;
    }

    // Lấy tổng số sân (cho phân trang)
    public int getTotalFields() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Field";
        try (Statement stmt = connection.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    // Tìm kiếm + lọc sân (tên, tỉnh, quận, loại sân, giá)
    public List<Map<String, Object>> searchAndFilterFields(
            String keyword, Integer provinceId, Integer districtId, Integer sportTypeId,
            Double minPrice, Double maxPrice, int page, int pageSize, String sortBy, String order) throws SQLException {

        List<Map<String, Object>> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
            SELECT f.field_id, f.field_name, v.venue_name, p.province_name, d.district_name,
                   st.sport_name, AVG(r.rating) as avg_rating, COUNT(r.review_id) as review_count,
                   MIN(fp.price) as min_price, MAX(fp.price) as max_price,
                   v.open_time, v.close_time, v.address_detail
            FROM Field f
            JOIN Venue v ON f.venue_id = v.venue_id
            JOIN Province p ON v.province_id = p.province_id
            JOIN Districts d ON v.district_id = d.district_id
            JOIN SportTypes st ON f.sport_type_id = st.sport_type_id
            LEFT JOIN FieldPrices fp ON f.field_id = fp.field_id
            LEFT JOIN Review r ON f.field_id = r.field_id
            WHERE 1=1
        """);

        List<Object> params = new ArrayList<>();

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

        sql.append(" GROUP BY f.field_id, f.field_name, v.venue_name, p.province_name, d.district_name, st.sport_name, v.open_time, v.close_time, v.address_detail");
        sql.append(" ORDER BY ").append(sortBy).append(" ").append(order);
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int index = 1;
            for (Object param : params) {
                ps.setObject(index++, param);
            }
            ps.setInt(index++, (page - 1) * pageSize);
            ps.setInt(index, pageSize);

            ResultSet rs = ps.executeQuery();
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
        return list;
    }

    // Lấy chi tiết 1 sân
    public Map<String, Object> getFieldDetail(int fieldId) throws SQLException {
        String sql = """
            SELECT f.field_id, f.field_name, v.venue_name, v.description, v.address_detail,
                   p.province_name, d.district_name, st.sport_name,
                   v.open_time, v.close_time,
                   AVG(r.rating) as avg_rating, COUNT(r.review_id) as review_count
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

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, fieldId);
            ResultSet rs = ps.executeQuery();
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
        return null;
    }

 

    // Lấy giá theo khung giờ
    public List<Map<String, Object>> getFieldPrices(int fieldId) throws SQLException {
        List<Map<String, Object>> prices = new ArrayList<>();
        String sql = """
            SELECT ts.start_time, ts.end_time, fp.price, ts.status
            FROM FieldPrices fp
            JOIN TimeSlot ts ON fp.slot_id = ts.slot_id
            WHERE fp.field_id = ?
            ORDER BY ts.start_time
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, fieldId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("startTime", rs.getTime("start_time"));
                map.put("endTime", rs.getTime("end_time"));
                map.put("price", rs.getDouble("price"));
                map.put("status", rs.getString("status"));
                prices.add(map);
            }
        }
        return prices;
    }
    // Lấy tất cả tỉnh
public List<Map<String, Object>> getProvinces() throws SQLException {
    List<Map<String, Object>> list = new ArrayList<>();
    String sql = "SELECT province_id, province_name FROM Province ORDER BY province_name";
    try (Statement stmt = connection.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
        while (rs.next()) {
            Map<String, Object> map = new HashMap<>();
            map.put("provinceId", rs.getInt("province_id"));
            map.put("provinceName", rs.getString("province_name"));
            list.add(map);
        }
    }
    return list;
}

// Lấy quận/huyện (nếu provinceId != null thì filter theo province)
public List<Map<String, Object>> getDistricts(Integer provinceId) throws SQLException {
    List<Map<String, Object>> list = new ArrayList<>();
    String sql = "SELECT district_id, district_name FROM Districts";
    if (provinceId != null) sql += " WHERE province_id = ?";
    sql += " ORDER BY district_name";
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        if (provinceId != null) ps.setInt(1, provinceId);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Map<String, Object> map = new HashMap<>();
            map.put("districtId", rs.getInt("district_id"));
            map.put("districtName", rs.getString("district_name"));
            list.add(map);
        }
    }
    return list;
}

// Lấy tất cả môn thể thao
public List<Map<String, Object>> getSportTypes() throws SQLException {
    List<Map<String, Object>> list = new ArrayList<>();
    String sql = "SELECT sport_type_id, sport_name FROM SportTypes ORDER BY sport_name";
    try (Statement stmt = connection.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
        while (rs.next()) {
            Map<String, Object> map = new HashMap<>();
            map.put("sportTypeId", rs.getInt("sport_type_id"));
            map.put("sportName", rs.getString("sport_name"));
            list.add(map);
        }
    }
    return list;
}

// Tổng số sân theo filter (cho phân trang chính xác)
public int getTotalFiltered(String keyword, Integer provinceId, Integer districtId, Integer sportTypeId,
                            Double minPrice, Double maxPrice) throws SQLException {
    StringBuilder sql = new StringBuilder("""
        SELECT COUNT(DISTINCT f.field_id)
        FROM Field f
        JOIN Venue v ON f.venue_id = v.venue_id
        JOIN Province p ON v.province_id = p.province_id
        JOIN Districts d ON v.district_id = d.district_id
        JOIN SportTypes st ON f.sport_type_id = st.sport_type_id
        LEFT JOIN FieldPrices fp ON f.field_id = fp.field_id
        WHERE 1=1
        """);
    List<Object> params = new ArrayList<>();
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
    try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }
        ResultSet rs = ps.executeQuery();
        if (rs.next()) return rs.getInt(1);
    }
    return 0;
}
// Lấy danh sách tất cả khung giờ (TimeSlot)
public List<Map<String, Object>> getTimeSlots() throws SQLException {
    List<Map<String, Object>> list = new ArrayList<>();
    String sql = "SELECT slot_id, start_time, end_time FROM TimeSlot ORDER BY start_time";
    try (Statement stmt = connection.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
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

// Lấy một TimeSlot theo ID (để hiển thị thông tin khung giờ đã chọn)
public Map<String, Object> getTimeSlotById(int slotId) throws SQLException {
    String sql = "SELECT start_time, end_time FROM TimeSlot WHERE slot_id = ?";
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, slotId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            Map<String, Object> map = new HashMap<>();
            map.put("startTime", rs.getTime("start_time"));
            map.put("endTime", rs.getTime("end_time"));
            return map;
        }
    }
    return null;
}

// Query mới: Lấy sân TRỐNG cho ngày + slot cụ thể (với các filter khác)
public List<Map<String, Object>> getAvailableFields(
        String keyword, Integer provinceId, Integer districtId, Integer sportTypeId,
        Double minPrice, Double maxPrice, java.sql.Date bookingDate, int slotId,
        int page, int pageSize, String sortBy, String order) throws SQLException {

    List<Map<String, Object>> list = new ArrayList<>();
    StringBuilder sql = new StringBuilder("""
        SELECT f.field_id, f.field_name, v.venue_name, p.province_name, d.district_name,
               st.sport_name, AVG(r.rating) as avg_rating, COUNT(r.review_id) as review_count,
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
        LEFT JOIN Bookings b ON f.field_id = b.field_id 
            AND b.booking_date = ? AND b.slot_id = ? AND b.status != 'cancelled'  -- giả sử có status
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
    if (provinceId != null) { sql.append(" AND v.province_id = ?"); params.add(provinceId); }
    if (districtId != null) { sql.append(" AND v.district_id = ?"); params.add(districtId); }
    if (sportTypeId != null) { sql.append(" AND f.sport_type_id = ?"); params.add(sportTypeId); }
    if (minPrice != null) { sql.append(" AND fp.price >= ?"); params.add(minPrice); }
    if (maxPrice != null) { sql.append(" AND fp.price <= ?"); params.add(maxPrice); }

    sql.append(" GROUP BY f.field_id, f.field_name, v.venue_name, p.province_name, d.district_name, st.sport_name," +
               " fp.price, ts.start_time, ts.end_time, v.open_time, v.close_time, v.address_detail");
    sql.append(" ORDER BY ").append(sortBy).append(" ").append(order);
    sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

    try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
        int index = 1;
        for (Object param : params) ps.setObject(index++, param);
        ps.setInt(index++, (page - 1) * pageSize);
        ps.setInt(index, pageSize);
        ResultSet rs = ps.executeQuery();
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
    return list;
}

      // Top 10 sân có nhiều lượt đặt nhất (tương thích SQL Server)
    public List<Map<String, Object>> getTop10MostBookedFields() throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
            SELECT TOP 10 
                   f.field_id, f.field_name, v.venue_name, v.address_detail,
                   p.province_name, d.district_name, st.sport_name,
                   COUNT(b.booking_id) AS booking_count,
                   AVG(r.rating) AS avg_rating
            FROM Field f
            JOIN Venue v ON f.venue_id = v.venue_id
            JOIN Province p ON v.province_id = p.province_id
            JOIN Districts d ON v.district_id = d.district_id
            JOIN SportTypes st ON f.sport_type_id = st.sport_type_id
            LEFT JOIN Bookings b ON f.field_id = b.field_id  -- Bỏ điều kiện status để tránh lỗi nếu cột chưa có
            LEFT JOIN Review r ON f.field_id = r.field_id
            GROUP BY f.field_id, f.field_name, v.venue_name, v.address_detail,
                     p.province_name, d.district_name, st.sport_name
            ORDER BY COUNT(b.booking_id) DESC, AVG(r.rating) DESC
            """;

        try (Statement stmt = connection.createStatement();
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
                map.put("avgRating", rs.getObject("avg_rating") != null ? rs.getDouble("avg_rating") : null);
                list.add(map);
            }
        } catch (SQLException e) {
            // Nếu bảng Bookings chưa tồn tại → trả về list rỗng (không crash trang)
            System.err.println("Lỗi lấy top fields (có thể bảng Bookings chưa tồn tại): " + e.getMessage());
            return new ArrayList<>();  // Trả về empty list → phần top sẽ ẩn
        }
        return list;
    }

// Tổng số sân trống (cho phân trang)
public int getTotalAvailableFields(String keyword, Integer provinceId, Integer districtId, Integer sportTypeId,
                                   Double minPrice, Double maxPrice, java.sql.Date bookingDate, int slotId) throws SQLException {
    // Tương tự query trên nhưng SELECT COUNT(DISTINCT f.field_id)
    // (copy phần WHERE tương tự, không cần OFFSET)
    // ... (bạn tự viết tương tự, chỉ thay SELECT và bỏ GROUP BY chi tiết)
        return 0;
    // Tương tự query trên nhưng SELECT COUNT(DISTINCT f.field_id)
    // (copy phần WHERE tương tự, không cần OFFSET)
    // ... (bạn tự viết tương tự, chỉ thay SELECT và bỏ GROUP BY chi tiết)
}

    // ==================== PHẦN MỚI: Venue level ====================

    // Lấy danh sách Venue (group by venue) với filter và phân trang
       // Lấy danh sách Venue (sửa filter giá vào HAVING để field_count luôn đúng)
    public List<Map<String, Object>> getAllVenues(
            String keyword, Integer provinceId, Integer districtId,
            Double minPrice, Double maxPrice,
            int page, int pageSize, String sortBy, String order) throws SQLException {

        List<Map<String, Object>> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
            SELECT v.venue_id, v.venue_name, v.address_detail, v.description,
                   p.province_name, d.district_name,
                   COUNT(f.field_id) AS field_count,
                   AVG(r.rating) AS avg_rating, COUNT(r.review_id) AS review_count,
                   MIN(fp.price) AS min_price, MAX(fp.price) AS max_price,
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

        // Di chuyển filter giá vào HAVING (không còn lọc ở WHERE)
        sql.append(" GROUP BY v.venue_id, v.venue_name, v.address_detail, v.description,")
           .append(" p.province_name, d.district_name, v.open_time, v.close_time");

        // Thêm HAVING cho filter giá
        boolean hasPriceFilter = false;
        StringBuilder having = new StringBuilder();
        if (minPrice != null) {
            having.append(" MIN(fp.price) >= ?");
            params.add(minPrice);
            hasPriceFilter = true;
        }
        if (maxPrice != null) {
            if (hasPriceFilter) having.append(" AND");
            having.append(" MAX(fp.price) <= ?");
            params.add(maxPrice);
            hasPriceFilter = true;
        }
        if (hasPriceFilter) {
            sql.append(" HAVING ").append(having);
        }

        sql.append(" ORDER BY ").append(sortBy).append(" ").append(order);
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int index = 1;
            for (Object param : params) {
                ps.setObject(index++, param);
            }
            ps.setInt(index++, (page - 1) * pageSize);
            ps.setInt(index, pageSize);

            ResultSet rs = ps.executeQuery();
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
        return list;
    }

    // Tổng số Venue (sửa tương tự: dùng subquery để áp dụng HAVING)
    public int getTotalVenues(
            String keyword, Integer provinceId, Integer districtId,
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
            if (hasPriceFilter) having.append(" AND");
            having.append(" MAX(fp.price) <= ?");
            params.add(maxPrice);
        }
        if (hasPriceFilter) {
            sql.append(" HAVING ").append(having);
        }

        sql.append(") AS sub");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int index = 1;
            for (Object param : params) {
                ps.setObject(index++, param);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    // Lấy chi tiết một Venue (dùng cho trang VenueDetail.jsp)
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

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, venueId);
            ResultSet rs = ps.executeQuery();
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
        return null;
    }

    // Lấy danh sách Field thuộc một Venue (cho trang VenueDetail.jsp)
    public List<Map<String, Object>> getFieldsByVenueId(int venueId, int page, int pageSize) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
            SELECT f.field_id, f.field_name, st.sport_name,
                   AVG(r.rating) AS avg_rating, COUNT(r.review_id) AS review_count,
                   MIN(fp.price) AS min_price, MAX(fp.price) AS max_price
            FROM Field f
            JOIN SportTypes st ON f.sport_type_id = st.sport_type_id
            LEFT JOIN FieldPrices fp ON f.field_id = fp.field_id
            LEFT JOIN Review r ON f.field_id = r.field_id
            WHERE f.venue_id = ?
            GROUP BY f.field_id, f.field_name, st.sport_name
            ORDER BY f.field_name
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
            """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, venueId);
            ps.setInt(2, (page - 1) * pageSize);
            ps.setInt(3, pageSize);

            ResultSet rs = ps.executeQuery();
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
        return list;
    }
    
        // Khung giờ TRỐNG theo ngày (an toàn nếu bảng Bookings chưa tồn tại)
        // Khung giờ TRỐNG theo ngày (an toàn nếu bảng Bookings chưa tồn tại)
    public List<Map<String, Object>> getAvailableSlots(int fieldId, java.sql.Date bookingDate) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();

        // Query chính: có kiểm tra booking
        String sqlWithBooking = """
            SELECT ts.slot_id, ts.start_time, ts.end_time, fp.price
            FROM TimeSlot ts
            JOIN FieldPrices fp ON ts.slot_id = fp.slot_id
            LEFT JOIN Bookings b ON fp.field_id = ? AND b.slot_id = ts.slot_id 
                AND b.booking_date = ? AND (b.status IS NULL OR b.status != 'cancelled')
            WHERE fp.field_id = ? AND b.booking_id IS NULL
            ORDER BY ts.start_time
            """;

        // Query fallback: nếu Bookings chưa tồn tại → coi tất cả slot đều trống
        String sqlFallback = """
            SELECT ts.slot_id, ts.start_time, ts.end_time, fp.price
            FROM TimeSlot ts
            JOIN FieldPrices fp ON ts.slot_id = fp.slot_id
            WHERE fp.field_id = ?
            ORDER BY ts.start_time
            """;

        try (PreparedStatement ps = connection.prepareStatement(sqlWithBooking)) {
            ps.setInt(1, fieldId);
            ps.setDate(2, bookingDate);
            ps.setInt(3, fieldId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("slotId", rs.getInt("slot_id"));
                map.put("startTime", rs.getTime("start_time"));
                map.put("endTime", rs.getTime("end_time"));
                map.put("price", rs.getDouble("price"));
                list.add(map);
            }
        } catch (SQLException e) {
            // Nếu lỗi (thường là bảng Bookings chưa tồn tại) → dùng fallback
            System.err.println("Lỗi kiểm tra slot trống (Bookings chưa tồn tại?): " + e.getMessage() + " → Dùng fallback tất cả slot trống.");
            try (PreparedStatement ps = connection.prepareStatement(sqlFallback)) {
                ps.setInt(1, fieldId);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("slotId", rs.getInt("slot_id"));
                    map.put("startTime", rs.getTime("start_time"));
                    map.put("endTime", rs.getTime("end_time"));
                    map.put("price", rs.getDouble("price"));
                    list.add(map);
                }
            }
        }
        return list;
    }
}

   
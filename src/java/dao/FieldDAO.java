package dao;

import model.Field;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FieldDAO {

    public List<Field> getFieldsByVenue(int venueId) {
        List<Field> list = new ArrayList<>();
        String sql = "SELECT * FROM Field WHERE venue_id = ?";

        DBConnection db = new DBConnection();
        Connection conn = db.getConnection();
        if (conn == null) return list;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, venueId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Field f = new Field();
                f.setFieldId(rs.getInt("field_id"));
                f.setVenueId(rs.getInt("venue_id"));
                f.setSportTypeId(rs.getInt("sport_type_id"));
                f.setFieldName(rs.getString("field_name"));
                list.add(f);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void addField(Field field) {
        String sql = "INSERT INTO Field (venue_id, sport_type_id, field_name) VALUES (?, ?, ?)";

        DBConnection db = new DBConnection();
        Connection conn = db.getConnection();
        if (conn == null) return;

        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, field.getVenueId());
            ps.setInt(2, field.getSportTypeId());
            ps.setString(3, field.getFieldName());
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) field.setFieldId(rs.getInt(1));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
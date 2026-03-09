package dao;

import model.TimeSlot;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TimeSlotDAO {

    public List<TimeSlot> getAllTimeSlots() {
        List<TimeSlot> list = new ArrayList<>();
        String sql = "SELECT slot_id, start_time, end_time FROM TimeSlot ORDER BY start_time";

        Connection conn = DBConnection.getConnection();
        if (conn == null) return list;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                TimeSlot ts = new TimeSlot();
                ts.setSlotId(rs.getInt("slot_id"));
                ts.setStartTime(rs.getTime("start_time"));
                ts.setEndTime(rs.getTime("end_time"));
                list.add(ts);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void addTimeSlot(TimeSlot ts) {
        String sql = "INSERT INTO TimeSlot (start_time, end_time) VALUES (?, ?)";

        Connection conn = DBConnection.getConnection();
        if (conn == null) return;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTime(1, ts.getStartTime());
            ps.setTime(2, ts.getEndTime());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
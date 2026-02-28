package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import util.DBConnection;

public class OwnerRequestDAO extends DBConnection {

    public void insert(int userId, String phone, String address, String description) {

        String sql = "INSERT INTO OwnerRequest "
                   + "(user_id, phone, address_detail, description, status) "
                   + "VALUES (?, ?, ?, ?, 'PENDING')";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setString(2, phone);
            ps.setString(3, address);
            ps.setString(4, description);
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean hasPendingRequest(int userId) {

        String sql = "SELECT 1 FROM OwnerRequest "
                   + "WHERE user_id = ? AND status = 'PENDING'";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
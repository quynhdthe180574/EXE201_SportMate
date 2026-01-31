/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author FPTSHOP
 */

import java.sql.*;
import java.util.*;
import model.Notification;
import util.DBConnection;

public class NotificationDAO {

    public List<Notification> getByUser(int userId) {
        List<Notification> list = new ArrayList<>();

        String sql = """
            SELECT notification_id, user_id, title, content,
                   notification_type, created_at
            FROM Notifications
            WHERE user_id = ?
            ORDER BY created_at DESC
        """;

        try {
            Connection con = new DBConnection().getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Notification n = new Notification();
                n.setNotificationId(rs.getInt("notification_id"));
                n.setUserId(rs.getInt("user_id"));
                n.setTitle(rs.getString("title"));
                n.setContent(rs.getString("content"));
                n.setNotificationType(rs.getString("notification_type"));
                n.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(n);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}


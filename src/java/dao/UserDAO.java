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
import model.User;
import util.DBConnection;
import util.PasswordUtil;

public class UserDAO {

    public boolean isEmailExist(String email) {
        String sql = "SELECT 1 FROM Users WHERE email = ?";
        try {
            Connection con = new DBConnection().getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public void register(User u) {
        String sql = """
            INSERT INTO Users(fullname, email, password, role_id)
            VALUES (?, ?, ?, ?)
        """;
        try {
            Connection con = new DBConnection().getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, u.getFullname());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getPassword());
            ps.setInt(4, u.getRoleId());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public User login(String email, String password) {
        String sql = "SELECT * FROM Users WHERE email=? AND password=?";
        try {
            Connection con = new DBConnection().getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setFullname(rs.getString("fullname"));
                u.setEmail(rs.getString("email"));
                u.setRoleId(rs.getInt("role_id"));
                return u;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
public boolean changePassword(int userId, String oldPass, String newPass) {

    String sqlGet = "SELECT password FROM users WHERE user_id = ?";
    String sqlUpdate = "UPDATE users SET password = ? WHERE user_id = ?";

    try (Connection con = new DBConnection().getConnection()) {

        // 1️⃣ Lấy password đã hash trong DB
        PreparedStatement ps = con.prepareStatement(sqlGet);
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();

        if (!rs.next()) return false;

        String passwordInDB = rs.getString("password");

        // 2️⃣ Hash mật khẩu cũ người dùng nhập
        String oldPassHash = PasswordUtil.hash(oldPass);

        // DEBUG (nếu cần)
        System.out.println("OLD HASH INPUT = " + oldPassHash);
        System.out.println("HASH IN DB     = " + passwordInDB);

        // 3️⃣ So sánh
        if (!oldPassHash.equals(passwordInDB)) {
            return false;
        }

        // 4️⃣ Hash mật khẩu mới
        String newPassHash = PasswordUtil.hash(newPass);

        // 5️⃣ Update DB
        PreparedStatement ps2 = con.prepareStatement(sqlUpdate);
        ps2.setString(1, newPassHash);
        ps2.setInt(2, userId);
        ps2.executeUpdate();

        return true;

    } catch (Exception e) {
        e.printStackTrace();
    }
    return false;
}
    


}

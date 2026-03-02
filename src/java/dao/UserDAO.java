package dao;

import java.sql.*;
import java.time.LocalDateTime;
import model.User;
import util.DBConnection;
import util.PasswordUtil;

public class UserDAO {

    // ================= CHECK EMAIL =================
    public boolean isEmailExist(String email) {
        String sql = "SELECT 1 FROM Users WHERE email = ?";
        try (Connection con = new DBConnection().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ================= REGISTER WITH OTP =================
    public boolean register(User u) {
        String sql = """
            INSERT INTO Users(fullname, email, password, phone, role_id, 
                              IsVerified, VerificationCode, VerificationExpiry, status)
            VALUES (?, ?, ?, ?, ?, 0, ?, ?, 1)
        """;

        try (Connection con = new DBConnection().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            String hashedPass = PasswordUtil.hash(u.getPassword());

            ps.setString(1, u.getFullname());
            ps.setString(2, u.getEmail());
            ps.setString(3, hashedPass);
            ps.setString(4, u.getPhone());
            ps.setInt(5, 3);
            ps.setString(6, u.getVerificationCode());
            ps.setTimestamp(7, Timestamp.valueOf(u.getVerificationExpiry()));

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ================= VERIFY OTP =================
    public boolean verifyAccount(String email, String otp) {
        String sql = """
            SELECT VerificationExpiry 
            FROM Users 
            WHERE email = ? AND VerificationCode = ? AND status = 1
        """;

        try (Connection con = new DBConnection().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, otp);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                Timestamp expiryTime = rs.getTimestamp("VerificationExpiry");
                LocalDateTime expiry = expiryTime.toLocalDateTime();

                if (expiry.isBefore(LocalDateTime.now())) {
                    return false; // OTP hết hạn
                }

                // Update verified
                String updateSql = """
                    UPDATE Users 
                    SET IsVerified = 1,
                        VerificationCode = NULL,
                        VerificationExpiry = NULL
                    WHERE email = ?
                """;

                PreparedStatement ps2 = con.prepareStatement(updateSql);
                ps2.setString(1, email);
                ps2.executeUpdate();

                return true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ================= LOGIN =================
    public User login(String email, String password) {

        String sql = "SELECT * FROM Users WHERE email=? AND status = 1";

        try (Connection con = new DBConnection().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                String passwordInDB = rs.getString("password");
                String inputHash = PasswordUtil.hash(password);

                if (!inputHash.equals(passwordInDB)) {
                    return null;
                }

                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setFullname(rs.getString("fullname"));
                u.setEmail(rs.getString("email"));
                u.setPhone(rs.getString("phone"));
                u.setRoleId(rs.getInt("role_id"));
                u.setVerified(rs.getBoolean("IsVerified"));
                u.setStatus(rs.getInt("status"));

                return u;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ================= CHANGE PASSWORD =================
    public boolean changePassword(int userId, String oldPass, String newPass) {

        String sqlGet = "SELECT password FROM Users WHERE user_id = ?";
        String sqlUpdate = "UPDATE Users SET password = ? WHERE user_id = ?";

        try (Connection con = new DBConnection().getConnection(); PreparedStatement psGet = con.prepareStatement(sqlGet)) {

            // 1️⃣ Lấy password hiện tại
            psGet.setInt(1, userId);

            try (ResultSet rs = psGet.executeQuery()) {

                if (!rs.next()) {
                    return false; // Không tìm thấy user
                }

                String passwordInDB = rs.getString("password");
                String oldPassHash = PasswordUtil.hash(oldPass);

                // 2️⃣ So sánh mật khẩu cũ
                if (!oldPassHash.equals(passwordInDB)) {
                    return false;
                }
            }

            // 3️⃣ Update mật khẩu mới
            try (PreparedStatement psUpdate = con.prepareStatement(sqlUpdate)) {

                String newPassHash = PasswordUtil.hash(newPass);

                psUpdate.setString(1, newPassHash);
                psUpdate.setInt(2, userId);

                int rows = psUpdate.executeUpdate();

                return rows > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ================= SOFT DELETE =================
    public void deactivateUser(int userId) {
        String sql = "UPDATE Users SET Status = 0 WHERE user_id = ?";
        try (Connection conn = new DBConnection().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateOTP(String email, String otp) throws Exception {
        String sql = "UPDATE users SET otp = ? WHERE email = ?";
        try (Connection con = new DBConnection().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, otp);
            ps.setString(2, email);
            ps.executeUpdate();
        }
    }

    public boolean updateProfile(int userId, String fullname, String email, String phone) {

        String sql = "UPDATE Users SET fullname=?, email=?, phone=? WHERE user_id=?";

        try (Connection con = new DBConnection().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, fullname);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setInt(4, userId);

            int rows = ps.executeUpdate();

            System.out.println("Rows updated: " + rows);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public User getUserByEmail(String email) {

        String sql = "SELECT * FROM Users WHERE email = ?";

        try (Connection conn = new DBConnection().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                User user = new User();

                user.setUserId(rs.getInt("user_id"));
                user.setFullname(rs.getString("fullname"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setRoleId(rs.getInt("role_id"));
                user.setStatus(rs.getInt("status"));

                return user;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updatePasswordByEmail(String email, String newPassword) {

        String sql = "UPDATE Users SET password = ? WHERE email = ?";

        try (Connection conn = new DBConnection().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newPassword);
            ps.setString(2, email);

            int rows = ps.executeUpdate();

            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public void requestBecomeOwner(int userId,
            String phone,
            String address,
            String description) throws Exception {

        String sql = "INSERT INTO OwnerRequest "
                + "(user_id, phone, address_detail, description, status) "
                + "VALUES (?, ?, ?, ?, 'PENDING')";

        try (Connection con = new DBConnection().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setString(2, phone);
            ps.setString(3, address);     // lưu vào address_detail
            ps.setString(4, description);

            ps.executeUpdate();
        }
    }

    public boolean hasPendingOwnerRequest(int userId) throws Exception {

        String sql = "SELECT 1 FROM OwnerRequest "
                + "WHERE user_id = ? AND status = 'PENDING'";

        try (Connection con = new DBConnection().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        }
    }
}

package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Review;
import model.User;
import util.DBConnection;

public class ReviewDAO {

    // 1. Lấy tất cả review của một field (sân cụ thể)
    public List<Review> getReviewsByFieldId(int fieldId) {
        List<Review> list = new ArrayList<>();
        String sql = "SELECT review_id, user_id, rating, comment, created_at "
                   + "FROM review "
                   + "WHERE field_id = ? "
                   + "ORDER BY created_at DESC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, fieldId);

            rs = ps.executeQuery();

            while (rs.next()) {
                Review review = new Review();
                review.setReviewId(rs.getInt("review_id"));

                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                review.setUser(user);

                review.setRating(rs.getInt("rating"));
                review.setComment(rs.getString("comment"));
                review.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());

                list.add(review);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ReviewDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                Logger.getLogger(ReviewDAO.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return list;
    }

    // 2. Thêm review mới cho một field
    public boolean addReview(Review review) {
        String sql = "INSERT INTO review (field_id, user_id, rating, comment, created_at) "
                   + "VALUES (?, ?, ?, ?, ?)";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);

            ps.setInt(1, review.getFieldId());          // ← quan trọng: lấy từ review object
            ps.setInt(2, review.getUser().getUserId());
            ps.setInt(3, review.getRating());
            ps.setString(4, review.getComment());
            ps.setTimestamp(5, java.sql.Timestamp.valueOf(review.getCreatedAt()));

            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(ReviewDAO.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                Logger.getLogger(ReviewDAO.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }

    // 3. Tính trung bình rating của field
    public double getAverageRatingByField(int fieldId) {
        String sql = "SELECT AVG(rating) as avg_rating FROM review WHERE field_id = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, fieldId);

            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble("avg_rating");
            }
        } catch (SQLException ex) {
            Logger.getLogger(ReviewDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                Logger.getLogger(ReviewDAO.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return 0.0;
    }

    // 4. Đếm số review của field
    public int getReviewCountByField(int fieldId) {
        String sql = "SELECT COUNT(*) as total FROM review WHERE field_id = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, fieldId);

            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException ex) {
            Logger.getLogger(ReviewDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                Logger.getLogger(ReviewDAO.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return 0;
    }

    // Nếu cần: xóa review
    public boolean deleteReview(int reviewId) {
        String sql = "DELETE FROM review WHERE review_id = ?";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, reviewId);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(ReviewDAO.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                Logger.getLogger(ReviewDAO.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }
     public static void main(String[] args) {
        ReviewDAO dao = new ReviewDAO();

        // Test 1: Lấy review của một field cụ thể (thay fieldId thật của bạn)
        int testFieldId = 1;  // ← thay bằng fieldId có thật trong DB của bạn

        System.out.println("=== Test 1: Lấy tất cả review của field ID = " + testFieldId + " ===");
        List<Review> reviews = dao.getReviewsByFieldId(testFieldId);
        if (reviews.isEmpty()) {
            System.out.println("→ Chưa có review nào cho field này.");
        } else {
            System.out.println("Tổng số review: " + reviews.size());
            for (Review r : reviews) {
                System.out.printf("Review ID: %d | User ID: %d | Rating: %d | Comment: %s | Time: %s%n",
                        r.getReviewId(),
                        r.getUser().getUserId(),
                        r.getRating(),
                        r.getComment(),
                        r.getCreatedAt());
            }
        }
     }
}

   
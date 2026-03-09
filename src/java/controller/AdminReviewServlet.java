package controller;

import dao.AdminReviewDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/reviews")
public class AdminReviewServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        // Kiểm tra quyền Admin
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null || user.getRoleId() != 1) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            AdminReviewDAO dao = new AdminReviewDAO();
            String fieldIdStr = request.getParameter("fieldId");

            if (fieldIdStr != null && !fieldIdStr.isEmpty()) {
                // === Chi tiết review của 1 sân ===
                int fieldId = Integer.parseInt(fieldIdStr);
                List<Map<String, Object>> fieldReviews = dao.getReviewsByFieldId(fieldId);
                Map<String, Object> fieldInfo = dao.getFieldInfo(fieldId);

                request.setAttribute("fieldReviews", fieldReviews);
                request.setAttribute("fieldInfo", fieldInfo);
                request.setAttribute("selectedFieldId", fieldId);
                request.setAttribute("viewMode", "detail");
            } else {
                // === Tổng quan: danh sách sân + thống kê ===
                List<Map<String, Object>> fieldSummaries = dao.getFieldReviewSummary();

                // Tính tổng review
                int totalReviews = 0;
                for (Map<String, Object> f : fieldSummaries) {
                    totalReviews += (int) f.get("reviewCount");
                }

                request.setAttribute("fieldSummaries", fieldSummaries);
                request.setAttribute("totalFields", fieldSummaries.size());
                request.setAttribute("totalReviews", totalReviews);
                request.setAttribute("viewMode", "overview");
            }

            request.getRequestDispatcher("/admin/review_list.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi tải danh sách review: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Kiểm tra quyền Admin
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null || user.getRoleId() != 1) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String reviewIdStr = request.getParameter("reviewId");
        String fieldIdStr = request.getParameter("fieldId");

        if (!"delete".equals(action) || reviewIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/admin/reviews");
            return;
        }

        try {
            int reviewId = Integer.parseInt(reviewIdStr);
            AdminReviewDAO dao = new AdminReviewDAO();
            boolean success = dao.deleteReview(reviewId);

            if (success) {
                request.getSession().setAttribute("successMessage", "Đã xóa review #" + reviewId);
            } else {
                request.getSession().setAttribute("errorMessage", "Không thể xóa review #" + reviewId);
            }

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "ID không hợp lệ");
        }

        // Redirect lại trang detail nếu có fieldId, không thì về overview
        if (fieldIdStr != null && !fieldIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/reviews?fieldId=" + fieldIdStr);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/reviews");
        }
    }
}

package controller;

import dao.AdminPromotionDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/promotions")
public class AdminPromotionServlet extends HttpServlet {

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
            AdminPromotionDAO dao = new AdminPromotionDAO();
            List<Map<String, Object>> promotions = dao.getAllPromotionsForAdmin();
            request.setAttribute("promotions", promotions);
            request.getRequestDispatcher("/admin/promotion_list.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi tải danh sách promotion: " + e.getMessage());
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
        String promoIdStr = request.getParameter("promoId");

        if (action == null || promoIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/admin/promotions");
            return;
        }

        try {
            int promoId = Integer.parseInt(promoIdStr);
            AdminPromotionDAO dao = new AdminPromotionDAO();
            boolean success = false;
            String message = "";

            switch (action) {
                case "toggle":
                    success = dao.togglePromotionStatus(promoId);
                    message = success ? "Đã đổi trạng thái promotion #" + promoId
                            : "Không thể đổi trạng thái promotion #" + promoId;
                    break;
                case "delete":
                    success = dao.deletePromotion(promoId);
                    message = success ? "Đã xóa promotion #" + promoId
                            : "Không thể xóa promotion #" + promoId;
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/promotions");
                    return;
            }

            if (success) {
                request.getSession().setAttribute("successMessage", message);
            } else {
                request.getSession().setAttribute("errorMessage", message);
            }

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "ID không hợp lệ");
        }

        response.sendRedirect(request.getContextPath() + "/admin/promotions");
    }
}

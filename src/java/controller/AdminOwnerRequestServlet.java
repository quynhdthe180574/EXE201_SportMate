package controller;

import dao.AdminOwnerRequestDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/owner-requests")
public class AdminOwnerRequestServlet extends HttpServlet {

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
            AdminOwnerRequestDAO dao = new AdminOwnerRequestDAO();
            List<Map<String, Object>> requests = dao.getAllRequests();
            request.setAttribute("requests", requests);
            request.getRequestDispatcher("/admin/owner_requests.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi tải danh sách owner requests: " + e.getMessage());
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
        String requestIdStr = request.getParameter("requestId");

        if (action == null || requestIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/admin/owner-requests");
            return;
        }

        try {
            int requestId = Integer.parseInt(requestIdStr);
            AdminOwnerRequestDAO dao = new AdminOwnerRequestDAO();
            boolean success = false;
            String message = "";

            switch (action) {
                case "approve":
                    success = dao.approveRequest(requestId);
                    message = success
                            ? "Đã duyệt yêu cầu #" + requestId + " và chuyển user thành Owner"
                            : "Không thể duyệt yêu cầu #" + requestId;
                    break;
                case "reject":
                    success = dao.rejectRequest(requestId);
                    message = success
                            ? "Đã từ chối yêu cầu #" + requestId
                            : "Không thể từ chối yêu cầu #" + requestId;
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/owner-requests");
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

        response.sendRedirect(request.getContextPath() + "/admin/owner-requests");
    }
}

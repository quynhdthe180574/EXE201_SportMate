package controller;

import dao.AdminUserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Admin ID cố định = 1 (khớp với dữ liệu test)
        // int adminId = 1;

        // Ngăn cache
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        try {
            AdminUserDAO userDAO = new AdminUserDAO();

            // Lấy danh sách users
            List<Map<String, Object>> users = userDAO.getAllUsers();

            // Lấy danh sách roles (cho dropdown đổi role)
            List<Map<String, Object>> roles = userDAO.getAllRoles();

            request.setAttribute("users", users);
            request.setAttribute("roles", roles);

            request.getRequestDispatcher("/admin/user_list.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("[AdminUserServlet] doGet - LỖI: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi tải danh sách user: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String userIdStr = request.getParameter("userId");

        if (action == null || userIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdStr);
            AdminUserDAO userDAO = new AdminUserDAO();
            boolean success = false;
            String message = "";

            switch (action) {
                case "lock":
                    success = userDAO.updateUserStatus(userId, "Bị khóa");
                    message = success ? "Đã khóa tài khoản user #" + userId
                            : "Không thể khóa tài khoản user #" + userId;
                    break;

                case "unlock":
                    success = userDAO.updateUserStatus(userId, "Hoạt động");
                    message = success ? "Đã mở khóa tài khoản user #" + userId
                            : "Không thể mở khóa tài khoản user #" + userId;
                    break;

                case "changeRole":
                    String roleIdStr = request.getParameter("roleId");
                    if (roleIdStr != null) {
                        int newRoleId = Integer.parseInt(roleIdStr);
                        success = userDAO.updateUserRole(userId, newRoleId);
                        message = success ? "Đã đổi role user #" + userId
                                : "Không thể đổi role user #" + userId;
                    }
                    break;

                default:
                    response.sendRedirect(request.getContextPath() + "/admin/users");
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

        response.sendRedirect(request.getContextPath() + "/admin/users");
    }
}

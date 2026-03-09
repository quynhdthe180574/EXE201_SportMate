package controller;

import dao.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;
import util.PasswordUtil;

@WebServlet("/change-password")
public class ChangePasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        String oldPass = req.getParameter("oldPassword");
        String newPass = req.getParameter("newPassword");
        String confirm = req.getParameter("confirmPassword");

        // 1️⃣ Check confirm
        if (!newPass.equals(confirm)) {
            req.setAttribute("error", "Mật khẩu xác nhận không khớp");
            req.setAttribute("activeTab", "password");
            req.getRequestDispatcher("profile.jsp").forward(req, resp);
            return;
        }

        // 2️⃣ Validate mật khẩu mới
        if (!PasswordUtil.isValidPassword(newPass)) {
            req.setAttribute("error",
                    "Mật khẩu phải có ít nhất 8 ký tự, gồm chữ hoa, chữ thường, số và ký tự đặc biệt.");
            req.setAttribute("activeTab", "password");
            req.getRequestDispatcher("profile.jsp").forward(req, resp);
            return;
        }

        // 3️⃣ Lấy user từ session
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        // 4️⃣ Đổi mật khẩu trong DB
        UserDao dao = new UserDao();
        boolean ok = dao.changePassword(
                user.getUserId(),
                oldPass,
                newPass
        );

        // 5️⃣ Phản hồi
        if (!ok) {
            req.setAttribute("error", "Mật khẩu cũ không đúng");
        } else {
            req.setAttribute("success", "Đổi mật khẩu thành công!");
        }

        req.setAttribute("activeTab", "password");
        req.getRequestDispatcher("profile.jsp").forward(req, resp);
    }
}
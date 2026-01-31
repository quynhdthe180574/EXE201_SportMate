package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

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

        // 1️⃣ check confirm
        if (!newPass.equals(confirm)) {
            req.setAttribute("error", "Mật khẩu xác nhận không khớp");
            req.getRequestDispatcher("change-password.jsp").forward(req, resp);
            return;
        }

        // 2️⃣ lấy user từ session
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        // 3️⃣ đổi mật khẩu trong DB
        UserDAO dao = new UserDAO();
        boolean ok = dao.changePassword(
                user.getUserId(),
                oldPass,
                newPass
        );

        // 4️⃣ phản hồi
        if (!ok) {
            req.setAttribute("error", "Mật khẩu cũ không đúng");
            req.getRequestDispatcher("change-password.jsp").forward(req, resp);
        } else {
            //  đổi mật khẩu thành công → quay về profile
            resp.sendRedirect("profile.jsp");
        }

    }
}

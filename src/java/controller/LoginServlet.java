package controller;

import dao.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.User;
import util.PasswordUtil;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        try {
            String email = req.getParameter("email");
            String password = req.getParameter("password");

            if (email == null || password == null || 
                email.isEmpty() || password.isEmpty()) {

                req.setAttribute("error", "Vui lòng nhập đầy đủ thông tin");
                req.getRequestDispatcher("login.jsp").forward(req, resp);
                return;
            }

            UserDao dao = new UserDao();
            User user = dao.login(email, PasswordUtil.hash(password));

            if (user == null) {
                req.setAttribute("error", "Sai thông tin đăng nhập");
                req.getRequestDispatcher("login.jsp").forward(req, resp);
                return;
            }

            // 🔥 Xóa session cũ (chống session fixation)
            HttpSession oldSession = req.getSession(false);
            if (oldSession != null) {
                oldSession.invalidate();
            }

            // 🔥 Tạo session mới
            HttpSession newSession = req.getSession(true);
            newSession.setAttribute("user", user);

            // (Optional) set timeout 30 phút
            newSession.setMaxInactiveInterval(30 * 60);

            resp.sendRedirect("home.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Lỗi đăng nhập", e);
        }
    }
}
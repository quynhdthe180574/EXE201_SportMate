package controller;

import dao.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.User;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        UserDao dao = new UserDao();
        User u = dao.login(email, password); // KHÔNG hash ở đây

        // 1️⃣ Sai thông tin
        if (u == null) {
            req.setAttribute("error", "Sai email hoặc mật khẩu");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
            return;
        }

        // 2️⃣ Chưa verify email
        if (!u.isVerified()) {
            req.setAttribute("error", "Tài khoản chưa được xác thực. Vui lòng kiểm tra email.");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
            return;
        }

        // 3️⃣ Tạo session
        HttpSession session = req.getSession();
        session.setAttribute("user", u);

        // 4️⃣ Redirect theo role
        switch (u.getRoleId()) {
            case 1: // Admin
                resp.sendRedirect("admin/dashboard.jsp");
                break;
            case 2: // chủ sân
                resp.sendRedirect("owner/dashboard.jsp");
                break;
            case 3: // người chơi
                resp.sendRedirect("home.jsp");               
                break;
            default:
                resp.sendRedirect("home.jsp");
        }
    }
}
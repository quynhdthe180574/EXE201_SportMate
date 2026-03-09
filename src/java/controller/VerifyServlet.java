package controller;

import dao.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/verify")
public class VerifyServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        HttpSession session = req.getSession();
        String email = (String) session.getAttribute("verifyEmail");
        String otp = req.getParameter("otp");

        if (email == null) {
            resp.sendRedirect("register.jsp");
            return;
        }

        UserDao dao = new UserDao();
        boolean success = dao.verifyAccount(email, otp);

        if (success) {

            // Xóa session verify
            session.removeAttribute("verifyEmail");

            req.setAttribute("success", 
                "Xác thực thành công! Bạn có thể đăng nhập.");
            req.getRequestDispatcher("login.jsp").forward(req, resp);

        } else {
            req.setAttribute("error", 
                "Mã OTP không đúng hoặc đã hết hạn.");
            req.getRequestDispatcher("verify.jsp").forward(req, resp);
        }
    }
}
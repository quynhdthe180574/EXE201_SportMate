package controller;

import dao.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import util.EmailUtil;

@WebServlet("/resend-otp")
public class ResendOtpServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            String email = (String) req.getSession().getAttribute("verifyEmail");

            if (email == null) {
                resp.sendRedirect("login.jsp");
                return;
            }

            // Tạo OTP mới
            String otp = String.valueOf((int) (Math.random() * 900000) + 100000);

            UserDAO dao = new UserDAO();
            dao.updateOTP(email, otp);

            // Gửi mail
            EmailUtil.sendOTP(email, otp);

            req.setAttribute("message", "Đã gửi lại OTP. Vui lòng kiểm tra email.");
            req.getRequestDispatcher("verify.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}

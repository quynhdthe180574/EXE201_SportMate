/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import util.PasswordUtil;

/**
 *
 * @author FPTSHOP
 */
@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();

        String otpInput = req.getParameter("otp");
        String newPass = req.getParameter("newPassword");
        String confirm = req.getParameter("confirmPassword");

        String otpSession = (String) session.getAttribute("otp");
        String email = (String) session.getAttribute("resetEmail");
        Long otpTime = (Long) session.getAttribute("otpTime");

        // 1️⃣ Kiểm tra session hợp lệ
        if (otpSession == null || email == null || otpTime == null) {
            resp.sendRedirect("forgot-password");
            return;
        }

        // 2️⃣ Kiểm tra OTP hết hạn (5 phút)
        if (System.currentTimeMillis() - otpTime > 5 * 60 * 1000) {
            req.setAttribute("error", "OTP đã hết hạn!");
            req.getRequestDispatcher("reset-password.jsp").forward(req, resp);
            return;
        }

        // 3️⃣ Kiểm tra OTP đúng
        if (otpInput == null || !otpInput.equals(otpSession)) {
            req.setAttribute("error", "OTP không đúng!");
            req.getRequestDispatcher("reset-password.jsp").forward(req, resp);
            return;
        }

        // 4️⃣ Kiểm tra confirm password
        if (!newPass.equals(confirm)) {
            req.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            req.getRequestDispatcher("reset-password.jsp").forward(req, resp);
            return;
        }

        // 5️⃣ Validate mật khẩu mạnh
        if (!PasswordUtil.isValidPassword(newPass)) {
            req.setAttribute("error",
                    "Mật khẩu phải có ít nhất 8 ký tự, gồm chữ hoa, chữ thường, số và ký tự đặc biệt.");
            req.getRequestDispatcher("reset-password.jsp").forward(req, resp);
            return;
        }

        // 6️⃣ Hash mật khẩu
        String hashed = PasswordUtil.hash(newPass);

        UserDAO dao = new UserDAO();
        boolean updated = dao.updatePasswordByEmail(email, hashed);

        if (!updated) {
            req.setAttribute("error", "Có lỗi xảy ra. Vui lòng thử lại.");
            req.getRequestDispatcher("reset-password.jsp").forward(req, resp);
            return;
        }

        // 7️⃣ Xóa OTP khỏi session
        session.removeAttribute("otp");
        session.removeAttribute("resetEmail");
        session.removeAttribute("otpTime");

        resp.sendRedirect("login.jsp");
    }
}
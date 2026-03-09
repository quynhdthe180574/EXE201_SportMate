/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
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
import util.EmailUtil;

/**
 *
 * @author FPTSHOP
 */
@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.getRequestDispatcher("forgot-password.jsp")
           .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập email!");
            req.getRequestDispatcher("forgot-password.jsp").forward(req, resp);
            return;
        }

        UserDao dao = new UserDao();
        User user = dao.getUserByEmail(email);

        if (user == null) {
            req.setAttribute("error", "Email không tồn tại!");
            req.getRequestDispatcher("forgot-password.jsp").forward(req, resp);
            return;
        }

        // Tạo OTP 6 số
        String otp = String.valueOf((int)(Math.random() * 900000) + 100000);

        HttpSession session = req.getSession();
        session.setAttribute("otp", otp);
        session.setAttribute("resetEmail", email);
        session.setAttribute("otpTime", System.currentTimeMillis());

        EmailUtil.sendResetPasswordOTP(email, otp);

        resp.sendRedirect("reset-password.jsp");
    }
}
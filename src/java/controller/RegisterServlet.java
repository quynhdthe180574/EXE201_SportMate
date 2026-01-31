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
import java.io.IOException;
import model.User;
import util.PasswordUtil;

/**
 *
 * @author FPTSHOP
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        try {
            UserDAO dao = new UserDAO();
            if (dao.isEmailExist(req.getParameter("email"))) {
                req.setAttribute("error", "Email đã tồn tại");
                req.getRequestDispatcher("register.jsp").forward(req, resp);
                return;
            }

            User u = new User();
            u.setFullname(req.getParameter("fullname"));
            u.setEmail(req.getParameter("email"));
            u.setPassword(PasswordUtil.hash(req.getParameter("password")));
            u.setRoleId(1); // USER

            dao.register(u);
            resp.sendRedirect("login.jsp");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}


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
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        try {
            UserDAO dao = new UserDAO();
            User u = dao.login(
                req.getParameter("email"),
                PasswordUtil.hash(req.getParameter("password"))
            );

            if (u == null) {
                req.setAttribute("error", "Sai thông tin đăng nhập");
                req.getRequestDispatcher("login.jsp").forward(req, resp);
                return;
            }

            req.getSession().setAttribute("user", u);
            resp.sendRedirect("home.jsp");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}


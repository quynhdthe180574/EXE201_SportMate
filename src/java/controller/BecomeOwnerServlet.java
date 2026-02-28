/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dao.UserDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 *
 * @author FPTSHOP
 */
@WebServlet("/become-owner")
public class BecomeOwnerServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        try {
            model.User user = (model.User) req.getSession().getAttribute("user");

            if (user == null) {
                resp.sendRedirect("login.jsp");
                return;
            }

            UserDAO dao = new UserDAO();
            dao.requestBecomeOwner(user.getUserId());

            resp.sendRedirect("notification.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

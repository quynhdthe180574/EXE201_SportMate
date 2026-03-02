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

/**
 *
 * @author FPTSHOP
 */
@WebServlet("/become-owner")
public class BecomeOwnerServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        try {
            HttpSession session = req.getSession();
            model.User user = (model.User) session.getAttribute("user");

            if (user == null) {
                resp.sendRedirect("login.jsp");
                return;
            }

            String phone = req.getParameter("phone");
            String address = req.getParameter("address");
            String description = req.getParameter("description");

            UserDAO dao = new UserDAO();

// 🔥 CHECK DUPLICATE THEO USER_ID
            if (dao.hasPendingOwnerRequest(user.getUserId())) {
                resp.sendRedirect("become-owner.jsp?duplicate=true");
                return;
            }

            dao.requestBecomeOwner(user.getUserId(), phone, address, description);

            resp.sendRedirect("home.jsp?success=true");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("become-owner.jsp?error=true");
        }
    }
}

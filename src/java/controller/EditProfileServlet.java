/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

/**
 *
 * @author FPTSHOP
 */
import dao.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.User;

@WebServlet("/edit-profile")
public class EditProfileServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String fullname = req.getParameter("fullname");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");

        UserDAO dao = new UserDAO();
        boolean updated = dao.updateProfile(
                user.getUserId(),
                fullname,
                email,
                phone
        );

        if (updated) {
            // cập nhật lại session
            user.setFullname(fullname);
            user.setEmail(email);
            user.setPhone(phone);
            session.setAttribute("user", user);

            req.getSession().setAttribute("profileSuccess", "Cập nhật thành công!");
        }

        resp.sendRedirect("profile.jsp");
    }
}

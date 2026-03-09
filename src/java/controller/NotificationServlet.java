/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dao.NotificationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import static java.util.Locale.filter;
import model.Notification;
import model.User;

/**
 *
 * @author FPTSHOP
 */
@WebServlet("/notifications")
public class NotificationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            User u = (User) req.getSession().getAttribute("user");

            if (u == null) {
                resp.sendRedirect("login.jsp");
                return;
            }
            String filter = req.getParameter("filter");
            if (filter == null) {
                filter = "all";
            }

            NotificationDAO dao = new NotificationDAO();
            List<Notification> list;

            switch (filter) {
                case "unread":
                    list = dao.getUnreadByUser(u.getUserId());
                    break;
                case "read":
                    list = dao.getReadByUser(u.getUserId());
                    break;
                default:
                    list = dao.getByUser(u.getUserId());
            }

            req.setAttribute("list", dao.getByUser(u.getUserId()));
            req.getRequestDispatcher("notification.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            User u = (User) req.getSession().getAttribute("user");

            if (u == null) {
                resp.sendRedirect("login.jsp");
                return;
            }

            String action = req.getParameter("action");
            NotificationDAO dao = new NotificationDAO();

            if ("markAllRead".equals(action)) {
                dao.markAllAsRead(u.getUserId());
            }

            if ("deleteAll".equals(action)) {
                dao.deleteAllByUser(u.getUserId());
            }

            if ("deleteOne".equals(action)) {
                int id = Integer.parseInt(req.getParameter("notificationId"));
                dao.deleteById(id);
            }
            resp.sendRedirect("notifications");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
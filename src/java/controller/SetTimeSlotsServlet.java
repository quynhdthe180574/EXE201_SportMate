package controller;

import dao.TimeSlotDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.TimeSlot;

import java.io.IOException;
import java.sql.Time;

@WebServlet("/owner/set-timeslots")
public class SetTimeSlotsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null || !"2".equals(session.getAttribute("role_id"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        request.getRequestDispatcher("/owner/set_timeslots.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null || !"2".equals(session.getAttribute("role_id"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        TimeSlot ts = new TimeSlot();
        ts.setStartTime(Time.valueOf(request.getParameter("start_time") + ":00"));
        ts.setEndTime(Time.valueOf(request.getParameter("end_time") + ":00"));
        ts.setStatus(request.getParameter("status"));

        new TimeSlotDAO().addTimeSlot(ts);

        response.sendRedirect(request.getContextPath() + "/owner/dashboard");
    }
}
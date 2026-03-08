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

@WebServlet("/owner/setTimeSlots")
public class SetTimeSlotsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null ||
            session.getAttribute("roleId") == null || (Integer) session.getAttribute("roleId") != 2) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        TimeSlotDAO dao = new TimeSlotDAO();
        request.setAttribute("timeSlots", dao.getAllTimeSlots());
        request.getRequestDispatcher("/WEB-INF/views/owner/setTimeSlots.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null ||
            session.getAttribute("roleId") == null || (Integer) session.getAttribute("roleId") != 2) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String start = request.getParameter("startTime");
        String end = request.getParameter("endTime");

        if (start == null || end == null || start.trim().isEmpty() || end.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng chọn giờ bắt đầu và kết thúc");
            doGet(request, response);
            return;
        }

        try {
            // input type="time" thường trả về HH:mm → thêm :00
            Time startTime = Time.valueOf(start + ":00");
            Time endTime = Time.valueOf(end + ":00");

            TimeSlot ts = new TimeSlot();
            ts.setStartTime(startTime);
            ts.setEndTime(endTime);

            TimeSlotDAO dao = new TimeSlotDAO();
            int slotId = dao.addTimeSlot(ts);

            if (slotId > 0) {
                response.sendRedirect(request.getContextPath() + "setTimeSlots?success=added");
            } else {
                request.setAttribute("error", "Thêm khung giờ thất bại");
                doGet(request, response);
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Định dạng giờ không hợp lệ (HH:mm)");
            doGet(request, response);
        }
    }
}
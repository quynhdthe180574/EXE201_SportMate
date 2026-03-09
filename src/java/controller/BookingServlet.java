package controller;

import dao.BookingDao;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;

@WebServlet("/BookingServlet")
public class BookingServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int fieldId = Integer.parseInt(request.getParameter("fieldId"));
            int slotId = Integer.parseInt(request.getParameter("slotId"));
            Date bookingDate = Date.valueOf(request.getParameter("bookingDate"));

            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            User user = (User) session.getAttribute("user");
            int userId = user.getUserId();

            BookingDao bookingDao = new BookingDao();

            // 🔥 Lấy giá từ DB (không lấy từ form)
            Double totalPrice = bookingDao.getPrice(fieldId, slotId);
            if (totalPrice == null) {
                response.sendRedirect("home.jsp");
                return;
            }

            int bookingId = bookingDao.createBooking(
                    userId,
                    fieldId,
                    slotId,
                    bookingDate,
                    totalPrice
            );

            if (bookingId > 0) {
                response.sendRedirect( request.getContextPath() + "/payment.jsp?bookingId=" + bookingId);
            } else {
                response.sendRedirect("home.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("home.jsp");
        }
    }
}

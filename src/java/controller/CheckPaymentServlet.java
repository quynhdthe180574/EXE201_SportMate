package controller;

import dao.BookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/CheckPaymentServlet")
public class CheckPaymentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));

            BookingDAO dao = new BookingDAO();

            // 👉 Update trạng thái thành PAID
            dao.updateStatus(bookingId, "PAID");

            // Chuyển sang trang thành công
            response.sendRedirect("paymentSuccess.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("home.jsp");
        }
    }
}
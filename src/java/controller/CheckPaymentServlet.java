package controller;

import dao.BookingDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.IOException;

@WebServlet("/CheckPaymentServlet")
public class CheckPaymentServlet extends HttpServlet {
   private static final String SHEET_API =
            "https://script.google.com/macros/s/AKfycbx_7YlpGObHcFXy-gsffVBIBn-ZDXFemTbYOdOX_nmqMaaoSqgySPv7YT6SHCIuHi8/exec";

  
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
 String keyword = "BOOKING" + bookingId;

            URL url = new URL(SHEET_API);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            BufferedReader reader =
                    new BufferedReader(new InputStreamReader(conn.getInputStream()));

            String line;
            boolean found = false;

            while ((line = reader.readLine()) != null) {

                if (line.contains(keyword)) {
                    found = true;
                    break;
                }

            }

            reader.close();

            if (found) {

                BookingDao dao = new BookingDao();
                dao.updateStatus(bookingId, "Đã thanh toán");

                response.getWriter().write("PAID");

            } else {

                response.getWriter().write("PENDING");

            }

        } catch (Exception e) {
            e.printStackTrace();
        }

    }
}
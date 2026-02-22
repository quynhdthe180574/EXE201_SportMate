package controller;

import dao.DashboardDAO;
import dao.VenueDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Venue;

import java.io.IOException;
import java.util.List;

@WebServlet("/owner/dashboard")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        // Owner ID cố định = 2 (khớp với dữ liệu test của bạn)
        int ownerId = 2;

        // Ngăn cache để load lại dữ liệu mới sau khi thêm sân
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        System.out.println("=== DASHBOARD SERVLET START - ownerId = " + ownerId + " ===");

        try {
            DashboardDAO dashboardDAO = new DashboardDAO();
            VenueDAO venueDAO = new VenueDAO();

            // Lấy số liệu thống kê (đã đúng)
            int venueCount = dashboardDAO.countVenues(ownerId);
            int bookingCount = dashboardDAO.countBookings(ownerId);
            double revenue = dashboardDAO.sumRevenue(ownerId);

            // Lấy danh sách sân của ownerId này
            List<Venue> venues = venueDAO.getVenuesByOwner(ownerId);

            // Debug chi tiết
            System.out.println("venueCount (số sân của user " + ownerId + "): " + venueCount);
            System.out.println("venues size (danh sách sân của user " + ownerId + "): " + (venues == null ? "NULL" : venues.size()));

            if (venues != null && !venues.isEmpty()) {
                System.out.println("Tên sân đầu tiên (mới nhất): " + venues.get(0).getVenueName());
                System.out.println("Số sân trong list: " + venues.size());
                for (int i = 0; i < Math.min(3, venues.size()); i++) {
                    Venue v = venues.get(i);
                    System.out.println("  Sân #" + (i+1) + ": ID=" + v.getVenueId() 
                            + " | Tên: " + v.getVenueName() 
                            + " | Địa chỉ: " + v.getAddressDetail()
                            + " | Giờ mở: " + v.getOpenTime()
                            + " | Trạng thái: " + v.getStatus());
                }
            } else {
                System.out.println("LIST VENUES RỖNG cho user " + ownerId);
            }

            // Set attribute cho JSP
            request.setAttribute("venueCount", venueCount);
            request.setAttribute("bookingCount", bookingCount);
            request.setAttribute("revenue", revenue);
            request.setAttribute("venues", venues);

            System.out.println("Forwarding đến: /owner/dashboard.jsp");
            request.getRequestDispatcher("/owner/dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("DashboardServlet - EXCEPTION: " + e.getClass().getSimpleName());
            System.err.println("Message: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi tải dashboard: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}
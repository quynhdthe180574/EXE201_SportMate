package controller;

import dao.VenueDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Venue;

import java.io.IOException;
import java.util.List;

@WebServlet("/list-all-venues")  // hoặc tên url bạn muốn
public class ListAllVenuesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        System.out.println("=== ListAllVenuesServlet START ===");

        VenueDAO venueDAO = new VenueDAO();
        List<Venue> venues = venueDAO.getAllVenues();  // cần thêm phương thức này nếu chưa có

        System.out.println("venues size: " + (venues == null ? "NULL" : venues.size()));

        request.setAttribute("venues", venues);

        request.getRequestDispatcher("/all_venues.jsp").forward(request, response); // tên file JSP của bạn
    }
}
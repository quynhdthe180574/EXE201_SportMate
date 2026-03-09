package controller;

import dal.OwnerRequestDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import model.User;

@WebServlet("/owner-request")
public class OwnerRequestController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        OwnerRequestDAO dao = new OwnerRequestDAO();

        if (dao.hasPendingRequest(user.getUserId())) {
            request.setAttribute("error", "Bạn đã gửi yêu cầu và đang chờ duyệt.");
        }

        request.getRequestDispatcher("become-owner.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String description = request.getParameter("description");

        OwnerRequestDAO dao = new OwnerRequestDAO();

        if (!dao.hasPendingRequest(user.getUserId())) {
            dao.insert(user.getUserId(), phone, address, description);
        }

        response.sendRedirect("home.jsp?ownerRequest=success");
    }
}
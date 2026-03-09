package controller;

import dao.FieldDao;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int page = 1;
        int pageSize = 6;

        String pageStr = request.getParameter("page");
        if (pageStr != null) {
            page = Integer.parseInt(pageStr);
        }

        String sortBy = request.getParameter("sortBy");
        String order = request.getParameter("order");

        if (sortBy == null) sortBy = "avg_rating";
        if (order == null) order = "DESC";

        FieldDao fieldDao = new FieldDao();

        try {
            List<Map<String, Object>> fields =
                    fieldDao.getAllFields(page, pageSize, sortBy, order);

            int totalFields = fieldDao.getTotalFields();
            int totalPages = (int) Math.ceil((double) totalFields / pageSize);

            request.setAttribute("fields", fields);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);

            request.getRequestDispatcher("home.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
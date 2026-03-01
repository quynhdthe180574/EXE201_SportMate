package controller;

import dao.PromotionDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Promotion;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet("/owner/promotions")
public class OwnerPromotionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Owner ID cố định = 2 (sau này lấy từ session)
        int ownerId = 2;

        // Ngăn cache
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        try {
            PromotionDAO dao = new PromotionDAO();
            List<Promotion> promotions = dao.getPromotionsByOwner(ownerId);
            request.setAttribute("promotions", promotions);

            // Nếu có param editId → load promotion để sửa
            String editIdStr = request.getParameter("editId");
            if (editIdStr != null && !editIdStr.trim().isEmpty()) {
                try {
                    int editId = Integer.parseInt(editIdStr);
                    Promotion editPromo = dao.getPromotionById(editId, ownerId);
                    if (editPromo != null) {
                        request.setAttribute("editPromo", editPromo);
                    }
                } catch (NumberFormatException ignored) {
                }
            }

            request.getRequestDispatcher("/owner/promotion_list.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("[OwnerPromotionServlet] doGet - LỖI: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi tải danh sách khuyến mãi: " + e.getMessage());
            request.getRequestDispatcher("/owner/promotion_list.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Owner ID cố định = 2
        int ownerId = 2;

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/owner/promotions");
            return;
        }

        try {
            PromotionDAO dao = new PromotionDAO();

            switch (action) {
                case "create": {
                    // --- Server-side validation ---
                    String name = request.getParameter("name");
                    if (name == null || name.trim().isEmpty()) {
                        request.getSession().setAttribute("errorMessage", "Tên khuyến mãi không được để trống.");
                        break;
                    }
                    if (name.trim().length() > 200) {
                        request.getSession().setAttribute("errorMessage", "Tên khuyến mãi tối đa 200 ký tự.");
                        break;
                    }

                    double discountValue = Double.parseDouble(request.getParameter("discountValue"));
                    if (discountValue <= 0 || discountValue > 100) {
                        request.getSession().setAttribute("errorMessage", "Giá trị giảm phải từ 0% đến 100%.");
                        break;
                    }

                    Date startDate = Date.valueOf(request.getParameter("startDate"));
                    Date endDate = Date.valueOf(request.getParameter("endDate"));
                    if (endDate.before(startDate)) {
                        request.getSession().setAttribute("errorMessage",
                                "Ngày kết thúc phải sau hoặc bằng ngày bắt đầu.");
                        break;
                    }

                    // usageLimit: nếu rỗng thì mặc định = 0
                    String usageLimitStr = request.getParameter("usageLimit");
                    int usageLimit = 0;
                    if (usageLimitStr != null && !usageLimitStr.trim().isEmpty()) {
                        usageLimit = Integer.parseInt(usageLimitStr);
                        if (usageLimit < 0) {
                            request.getSession().setAttribute("errorMessage", "Giới hạn sử dụng phải >= 0.");
                            break;
                        }
                    }

                    Promotion p = new Promotion();
                    p.setName(name.trim());
                    p.setDescription(request.getParameter("description"));
                    p.setDiscountValue(discountValue);
                    p.setStartDate(startDate);
                    p.setEndDate(endDate);
                    p.setUsageLimit(usageLimit);
                    p.setStatus("active");
                    p.setOwnerId(ownerId);

                    boolean created = dao.addPromotion(p);
                    if (created) {
                        request.getSession().setAttribute("successMessage", "Tạo khuyến mãi thành công!");
                    } else {
                        request.getSession().setAttribute("errorMessage",
                                "Không thể tạo khuyến mãi. Vui lòng thử lại.");
                    }
                    break;
                }

                case "update": {
                    int promoId = Integer.parseInt(request.getParameter("promotionId"));

                    // --- Server-side validation ---
                    String name = request.getParameter("name");
                    if (name == null || name.trim().isEmpty()) {
                        request.getSession().setAttribute("errorMessage", "Tên khuyến mãi không được để trống.");
                        break;
                    }
                    if (name.trim().length() > 200) {
                        request.getSession().setAttribute("errorMessage", "Tên khuyến mãi tối đa 200 ký tự.");
                        break;
                    }

                    double discountValue = Double.parseDouble(request.getParameter("discountValue"));
                    if (discountValue <= 0 || discountValue > 100) {
                        request.getSession().setAttribute("errorMessage", "Giá trị giảm phải từ 0% đến 100%.");
                        break;
                    }

                    Date startDate = Date.valueOf(request.getParameter("startDate"));
                    Date endDate = Date.valueOf(request.getParameter("endDate"));
                    if (endDate.before(startDate)) {
                        request.getSession().setAttribute("errorMessage",
                                "Ngày kết thúc phải sau hoặc bằng ngày bắt đầu.");
                        break;
                    }

                    String usageLimitStr = request.getParameter("usageLimit");
                    int usageLimit = 0;
                    if (usageLimitStr != null && !usageLimitStr.trim().isEmpty()) {
                        usageLimit = Integer.parseInt(usageLimitStr);
                        if (usageLimit < 0) {
                            request.getSession().setAttribute("errorMessage", "Giới hạn sử dụng phải >= 0.");
                            break;
                        }
                    }

                    Promotion p = new Promotion();
                    p.setPromotionId(promoId);
                    p.setName(name.trim());
                    p.setDescription(request.getParameter("description"));
                    p.setDiscountValue(discountValue);
                    p.setStartDate(startDate);
                    p.setEndDate(endDate);
                    p.setUsageLimit(usageLimit);
                    p.setOwnerId(ownerId);

                    boolean updated = dao.updatePromotion(p);
                    if (updated) {
                        request.getSession().setAttribute("successMessage",
                                "Cập nhật khuyến mãi #" + promoId + " thành công!");
                    } else {
                        request.getSession().setAttribute("errorMessage",
                                "Không thể cập nhật khuyến mãi #" + promoId + ". Vui lòng thử lại.");
                    }
                    break;
                }

                case "toggle": {
                    int promoId = Integer.parseInt(request.getParameter("promotionId"));
                    boolean toggled = dao.toggleStatus(promoId, ownerId);
                    if (toggled) {
                        request.getSession().setAttribute("successMessage",
                                "Đã thay đổi trạng thái khuyến mãi #" + promoId);
                    } else {
                        request.getSession().setAttribute("errorMessage",
                                "Không thể thay đổi trạng thái khuyến mãi #" + promoId);
                    }
                    break;
                }

                case "delete": {
                    int promoId = Integer.parseInt(request.getParameter("promotionId"));
                    boolean deleted = dao.deletePromotion(promoId, ownerId);
                    if (deleted) {
                        request.getSession().setAttribute("successMessage",
                                "Đã xóa khuyến mãi #" + promoId);
                    } else {
                        request.getSession().setAttribute("errorMessage",
                                "Không thể xóa khuyến mãi #" + promoId);
                    }
                    break;
                }

                default:
                    request.getSession().setAttribute("errorMessage", "Hành động không hợp lệ.");
                    break;
            }

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Dữ liệu nhập không hợp lệ.");
        } catch (Exception e) {
            System.err.println("[OwnerPromotionServlet] doPost - LỖI: " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Lỗi xử lý: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/owner/promotions");
    }
}

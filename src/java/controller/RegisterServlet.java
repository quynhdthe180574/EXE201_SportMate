package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.Random;
import model.User;
import util.EmailUtil;
import util.PasswordUtil;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private String generateOTP() {
        Random rand = new Random();
        int otp = 100000 + rand.nextInt(900000);
        return String.valueOf(otp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        String fullname = req.getParameter("fullname");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String roleParam = req.getParameter("roleId");
        int roleId = (roleParam != null) ? Integer.parseInt(roleParam) : 1;

        UserDAO dao = new UserDAO();

// Nếu password không hợp lệ
        req.setAttribute("fullname", fullname);
        req.setAttribute("email", email);
        req.setAttribute("phone", phone);

// ===== 1️⃣ VALIDATE PASSWORD FORMAT =====
        if (!PasswordUtil.isValidPassword(password)) {
            req.setAttribute("error",
                    "Mật khẩu phải ≥8 ký tự, có chữ hoa, chữ thường, số và ký tự đặc biệt");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
            return;
        }

// ===== 2️⃣ CHECK CONFIRM PASSWORD =====
        if (!password.equals(confirmPassword)) {
            req.setAttribute("error", "Mật khẩu xác nhận không khớp");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
            return;
        }

// ===== 3️⃣ CHECK EMAIL TỒN TẠI =====
        if (dao.isEmailExist(email)) {
            req.setAttribute("error", "Email đã tồn tại");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
            return;
        }

        // 3️⃣ Generate OTP
        String otp = generateOTP();
        LocalDateTime expiry = LocalDateTime.now().plusMinutes(5);

        // 4️⃣ Tạo User object
        User u = new User();
        u.setFullname(fullname);
        u.setEmail(email);
        u.setPhone(phone);
        u.setPassword(password); // DAO sẽ hash
        u.setRoleId(roleId);
        u.setVerificationCode(otp);
        u.setVerificationExpiry(expiry);

        // 5️⃣ Lưu vào DB
        boolean success = dao.register(u);

        if (success) {

            // 6️⃣ Gửi email
            EmailUtil.sendOTP(email, otp);

            // 7️⃣ Lưu email vào session để verify
            HttpSession session = req.getSession();
            session.setAttribute("verifyEmail", email);

            resp.sendRedirect("verify.jsp");
        } else {
            req.setAttribute("error", "Đăng ký thất bại");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
        }
    }
}

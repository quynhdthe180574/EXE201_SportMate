package util;

import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;

public class EmailUtil {

    // ⚠️ THAY BẰNG EMAIL CỦA BẠN
    private static final String FROM_EMAIL = "anthupham834@gmail.com";
//sportmate.system@gmail.com
    // ⚠️ THAY BẰNG APP PASSWORD (16 ký tự)
    private static final String APP_PASSWORD = "mgfkwlsbiinovosu";

    public static void sendOTP(String toEmail, String otp) {

        try {

            Properties props = new Properties();

            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "587");

            Session session = Session.getInstance(props,
                    new Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
                }
            });

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(
                    Message.RecipientType.TO,
                    InternetAddress.parse(toEmail)
            );

            message.setSubject("Sport Mate - Xác thực tài khoản");

            String emailContent = """
                <html>
                <body style="font-family: Arial, sans-serif;">
                    <p>Xin chào,</p>

                    <p>Mã xác thực (OTP) của bạn là:</p>

                    <h2 style="color: #2E86C1;">%s</h2>

                    <p>Mã có hiệu lực trong <b>5 phút</b>.</p>

                    <p>Nếu bạn không thực hiện đăng ký, vui lòng bỏ qua email này.</p>

                    <br>
                    <p><b>Sport Mate Team</b></p>
                </body>
                </html>
                """.formatted(otp);

            message.setContent(emailContent, "text/html; charset=UTF-8");

            Transport.send(message);

            System.out.println("OTP email sent successfully!");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void sendResetPasswordOTP(String toEmail, String otp) {

        try {

            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "587");

            Session session = Session.getInstance(props,
                    new Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
                }
            });

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(
                    Message.RecipientType.TO,
                    InternetAddress.parse(toEmail)
            );

            message.setSubject("SportMate - Đặt lại mật khẩu");

            String emailContent = """
            <html>
            <body style="font-family: Arial, sans-serif;">
                <p>Xin chào,</p>

                <p>Bạn vừa yêu cầu đặt lại mật khẩu cho tài khoản SportMate.</p>

                <p>Mã OTP của bạn là:</p>

                <h2 style="color: #28a745;">%s</h2>

                <p>Mã có hiệu lực trong <b>5 phút</b>.</p>

                <p>Nếu bạn không yêu cầu đặt lại mật khẩu, vui lòng bỏ qua email này.</p>

                <br>
                <p><b>SportMate Team</b></p>
            </body>
            </html>
            """.formatted(otp);

            message.setContent(emailContent, "text/html; charset=UTF-8");

            Transport.send(message);

            System.out.println("Reset password OTP email sent!");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
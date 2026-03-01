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
                    Xin chào,

                    Mã xác thực (OTP) của bạn là: %s

                    Mã có hiệu lực trong 5 phút.

                    Nếu bạn không thực hiện đăng ký, vui lòng bỏ qua email này.

                    Sport Mate Team
                    """.formatted(otp);

            message.setText(emailContent);

            Transport.send(message);

            System.out.println("OTP email sent successfully!");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
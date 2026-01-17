package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBConnection {
    private Connection connection;

    public DBConnection() {
        try {
            String user = "sa";
            String pass = "123456";
            String url = "jdbc:sqlserver://localhost:1433;databaseName=sport_booking;encrypt=false;trustServerCertificate=true;";
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            connection = DriverManager.getConnection(url, user, pass);

            if (connection != null && !connection.isClosed()) {
                System.out.println("[DBConnection] KẾT NỐI DB THÀNH CÔNG! Connection: " + connection);
            } else {
                System.err.println("[DBConnection] KẾT NỐI THẤT BẠI: connection = null hoặc đã đóng");
            }
        } catch (Exception ex) {
            System.err.println("[DBConnection] LỖI KẾT NỐI: " + ex.getMessage());
            ex.printStackTrace();
        }
    }

    public Connection getConnection() {
        return connection; // ← PHẢI TRẢ VỀ connection
    }

    public static void main(String[] args) {
        DBConnection db = new DBConnection();
        System.out.println("Test: " + db.getConnection());
    }
}
package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    private static final String USER = "sa";
    private static final String PASS = "123456";
    private static final String URL =
        "jdbc:sqlserver://localhost:1433;databaseName=sport_booking;" +
        "encrypt=false;trustServerCertificate=true;";

    public static Connection getConnection() {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            Connection conn = DriverManager.getConnection(URL, USER, PASS);

            if (conn != null && !conn.isClosed()) {
                System.out.println("[DBConnection] KẾT NỐI DB OK");
            }
            return conn;
        } catch (Exception e) {
            System.err.println("[DBConnection] LỖI: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
}

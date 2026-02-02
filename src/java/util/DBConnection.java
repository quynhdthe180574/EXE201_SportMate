package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=sport_booking;encrypt=false;trustServerCertificate=true;";
    private static final String USER = "sa";
    private static final String PASS = "123";

    private static Connection connection = null;

    static {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            connection = DriverManager.getConnection(URL, USER, PASS);
            System.out.println("[DBConnection] KẾT NỐI BAN ĐẦU THÀNH CÔNG!");
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("[DBConnection] LỖI KẾT NỐI BAN ĐẦU: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public static Connection getConnection() {
        try {
            if (connection == null || connection.isClosed()) {
                System.out.println("[DBConnection] Re-connecting...");
                connection = DriverManager.getConnection(URL, USER, PASS);
            }
            return connection;
        } catch (SQLException e) {
            System.err.println("[DBConnection] LỖI LẤY CONNECTION: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    public static void closeConnection() {
        if (connection != null) {
            try {
                connection.close();
                System.out.println("[DBConnection] Connection closed.");
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

/**
 *
 * @author FPTSHOP
 */

import java.security.MessageDigest;
import java.util.regex.Pattern;

public class PasswordUtil {
    public static String hash(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] bytes = md.digest(password.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : bytes)
                sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (Exception e) {
            return null;
        }
    }
    
    public static boolean isValidPassword(String password) {

        if (password == null) return false;

        // Regex:
        // At least 8 chars
        // 1 uppercase
        // 1 lowercase
        // 1 digit
        // 1 special char
        String regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@#$%^&+=!]).{8,}$";

        return Pattern.matches(regex, password);
    }
}


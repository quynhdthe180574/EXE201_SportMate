package model;

import java.time.LocalDateTime;

public class User {
    private int userId;
    private String fullname;
    private String email;
    private String password;
    private String phone;
    private int roleId;

    // ===== NEW FIELDS FOR AUTH SYSTEM =====
    private boolean isVerified;
    private String verificationCode;
    private LocalDateTime verificationExpiry;
    private int status; // 1 = active, 0 = deleted

    public User() {
    }

    public User(int userId, String fullname, String email, String password, 
                String phone, int roleId, boolean isVerified, 
                String verificationCode, LocalDateTime verificationExpiry, int status) {
        this.userId = userId;
        this.fullname = fullname;
        this.email = email;
        this.password = password;
        this.phone = phone;
        this.roleId = roleId;
        this.isVerified = isVerified;
        this.verificationCode = verificationCode;
        this.verificationExpiry = verificationExpiry;
        this.status = status;
    }

    // ===== GETTERS =====

    public int getUserId() {
        return userId;
    }

    public String getFullname() {
        return fullname;
    }

    public String getEmail() {
        return email;
    }

    public String getPassword() {
        return password;
    }

    public String getPhone() {
        return phone;
    }

    public int getRoleId() {
        return roleId;
    }

    public boolean isVerified() {
        return isVerified;
    }

    public String getVerificationCode() {
        return verificationCode;
    }

    public LocalDateTime getVerificationExpiry() {
        return verificationExpiry;
    }

    public int getStatus() {
        return status;
    }

    // ===== SETTERS =====

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public void setVerified(boolean verified) {
        isVerified = verified;
    }

    public void setVerificationCode(String verificationCode) {
        this.verificationCode = verificationCode;
    }

    public void setVerificationExpiry(LocalDateTime verificationExpiry) {
        this.verificationExpiry = verificationExpiry;
    }

    public void setStatus(int status) {
        this.status = status;
    }
}
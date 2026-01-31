/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author FPTSHOP
 */

public class User {
    private int userId;
    private String fullname;
    private String email;
    private String password;
    private String phone;
    private int roleId;

    public User() {
    }

    
    public User(int userId, String fullname, String email, String password, String phone, int roleId) {
        this.userId = userId;
        this.fullname = fullname;
        this.email = email;
        this.password = password;
        this.phone = phone;
        this.roleId = roleId;
    }

    public String getFullname() {
        return fullname;
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

    public int getUserId() {
        return userId;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
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

    public void setUserId(int userId) {
        this.userId = userId;
    }

    
}


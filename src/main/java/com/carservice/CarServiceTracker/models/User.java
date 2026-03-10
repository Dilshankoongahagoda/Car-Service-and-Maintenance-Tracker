package com.carservice.CarServiceTracker.models;

import com.carservice.CarServiceTracker.utils.ValidationUtil;

public abstract class User {
    private String userId;
    private String username;
    private String email;
    private String password;
    private String fullName;
    private String phone;
    private String firebaseUid;

    public User(String userId, String username, String email,
                String password, String fullName, String phone) {
        this.userId = userId;
        this.username = username;
        setEmail(email);
        this.password = password;
        this.fullName = fullName;
        this.phone = phone;
        this.firebaseUid = "";
    }

    public User(String userId, String username, String email,
                String password, String fullName, String phone, String firebaseUid) {
        this.userId = userId;
        this.username = username;
        setEmail(email);
        this.password = password;
        this.fullName = fullName;
        this.phone = phone;
        this.firebaseUid = firebaseUid != null ? firebaseUid : "";
    }

    public String getUserId() { return userId; }
    public String getUsername() { return username; }
    public String getEmail() { return email; }
    public String getPassword() { return password; }
    public String getFullName() { return fullName; }
    public String getPhone() { return phone; }
    public String getFirebaseUid() { return firebaseUid; }

    // Getters and setters with validation
    public void setEmail(String email) {
        if (ValidationUtil.isValidEmail(email)) {
            this.email = email;
        } else {
            throw new IllegalArgumentException("Invalid email format");
        }
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void setFullName(String fullName) { this.fullName = fullName; }
    public void setPhone(String phone) { this.phone = phone; }
    public void setFirebaseUid(String firebaseUid) { this.firebaseUid = firebaseUid; }

    // Abstract method for polymorphism
    public abstract String getUserRole();

    // File serialization
    // Format: userId|username|email|password|fullName|phone|role|firebaseUid
    public String toFileString() {
        return userId + "|" + username + "|" + email + "|" +
               password + "|" + fullName + "|" + phone + "|" +
               getUserRole() + "|" + firebaseUid;
    }

    public abstract boolean authenticate(String username, String password);
}

package com.carservice.CarServiceTracker.models;

public class AdminUser extends User {
    private String adminLevel; // e.g. "SUPER", "REGULAR"

    public AdminUser(String userId, String username, String email,
                     String password, String fullName, String phone,
                     String adminLevel) {
        super(userId, username, email, password, fullName, phone);
        this.adminLevel = adminLevel;
    }

    public AdminUser(String userId, String username, String email,
                     String password, String fullName, String phone,
                     String firebaseUid, String adminLevel) {
        super(userId, username, email, password, fullName, phone, firebaseUid);
        this.adminLevel = adminLevel;
    }

    @Override
    public String getUserRole() {
        return "AdminUser";
    }

    public String getAdminLevel() {
        return adminLevel;
    }

    public void setAdminLevel(String adminLevel) {
        this.adminLevel = adminLevel;
    }

    public boolean canDeleteUsers() {
        return "SUPER".equals(adminLevel);
    }

    // Example of Polymorphism
    @Override
    public boolean authenticate(String username, String password) {
        // Admin user might have extra security checks
        return this.getUsername().equals(username) && this.getPassword().equals(password);
    }

    @Override
    public String toFileString() {
        // Format: ...base...|firebaseUid|adminLevel
        String baseStr = super.toFileString();
        return baseStr + "|" + adminLevel;
    }
}

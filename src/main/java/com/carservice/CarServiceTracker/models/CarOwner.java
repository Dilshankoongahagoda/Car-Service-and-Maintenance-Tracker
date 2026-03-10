package com.carservice.CarServiceTracker.models;

import java.util.ArrayList;
import java.util.List;

public class CarOwner extends User {
    private List<String> vehicleIds;

    public CarOwner(String userId, String username, String email,
                    String password, String fullName, String phone) {
        super(userId, username, email, password, fullName, phone);
        this.vehicleIds = new ArrayList<>();
    }

    public CarOwner(String userId, String username, String email,
                    String password, String fullName, String phone,
                    String firebaseUid) {
        super(userId, username, email, password, fullName, phone, firebaseUid);
        this.vehicleIds = new ArrayList<>();
    }

    @Override
    public String getUserRole() {
        return "CarOwner";
    }

    public void addVehicle(String vehicleId) {
        if (!vehicleIds.contains(vehicleId)) {
            vehicleIds.add(vehicleId);
        }
    }

    public List<String> getVehicleIds() {
        return new ArrayList<>(vehicleIds); // Return a copy to maintain encapsulation
    }

    // Example of Polymorphism
    @Override
    public boolean authenticate(String username, String password) {
        return this.getUsername().equals(username) && this.getPassword().equals(password);
    }

    @Override
    public String toFileString() {
        // Format: ...base...|firebaseUid|vehicleIds
        String baseStr = super.toFileString();
        String vehicleListStr = String.join(",", vehicleIds);
        return baseStr + "|" + vehicleListStr;
    }
}

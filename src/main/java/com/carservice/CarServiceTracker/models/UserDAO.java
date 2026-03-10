package com.carservice.CarServiceTracker.models;

import com.carservice.CarServiceTracker.utils.FileHandler;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    private static final String FILE_NAME = "users.txt";

    public List<User> getAllUsers() {
        List<String> lines = FileHandler.readFile(FILE_NAME);
        List<User> users = new ArrayList<>();

        for (String line : lines) {
            String[] parts = line.split("\\|");
            if (parts.length >= 7) {
                // Format: userId|username|email|password|fullName|phone|role|firebaseUid|roleSpecificData
                String firebaseUid = parts.length > 7 ? parts[7] : "";
                if ("AdminUser".equals(parts[6])) {
                    String adminLevel = parts.length > 8 ? parts[8] : "REGULAR";
                    users.add(new AdminUser(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], firebaseUid, adminLevel));
                } else if ("CarOwner".equals(parts[6])) {
                    CarOwner owner = new CarOwner(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], firebaseUid);
                    if (parts.length > 8 && !parts[8].isEmpty()) {
                        String[] vIds = parts[8].split(",");
                        for (String vid : vIds) {
                            owner.addVehicle(vid);
                        }
                    }
                    users.add(owner);
                }
            }
        }
        return users;
    }

    public User getUserByUsername(String username) {
        return getAllUsers().stream()
                .filter(u -> u.getUsername().equals(username))
                .findFirst()
                .orElse(null);
    }

    public User getUserByEmail(String email) {
        return getAllUsers().stream()
                .filter(u -> u.getEmail().equals(email))
                .findFirst()
                .orElse(null);
    }

    public User getUserByFirebaseUid(String firebaseUid) {
        if (firebaseUid == null || firebaseUid.isEmpty()) return null;
        return getAllUsers().stream()
                .filter(u -> firebaseUid.equals(u.getFirebaseUid()))
                .findFirst()
                .orElse(null);
    }

    public User authenticateUser(String username, String password) {
        User user = getUserByUsername(username);
        if (user != null && user.authenticate(username, password)) {
            return user;
        }
        return null;
    }

    public void saveUser(User user) {
        List<String> lines = FileHandler.readFile(FILE_NAME);
        lines.add(user.toFileString());
        FileHandler.writeFile(FILE_NAME, lines);
    }

    public String generateUserId() {
        List<String> lines = FileHandler.readFile(FILE_NAME);
        return "U" + String.format("%03d", lines.size() + 1);
    }
}

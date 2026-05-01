package com.carservice.CarServiceTracker.models;

import com.carservice.CarServiceTracker.utils.FileHandler;
import java.util.ArrayList;
import java.util.List;

public class VehicleDAO {
    private static final String FILE_NAME = "vehicles.txt";

    public void save(Vehicle vehicle) {
        List<String> lines = FileHandler.readFile(FILE_NAME);
        lines.add(vehicle.toFileString());
        FileHandler.writeFile(FILE_NAME, lines);
    }

    public List<Vehicle> findAll() {
        List<String> lines = FileHandler.readFile(FILE_NAME);
        List<Vehicle> vehicles = new ArrayList<>();
        
        for (String line : lines) {
            String[] parts = line.split("\\|");
            if (parts.length >= 10) {
                if ("Car".equals(parts[8])) {
                    vehicles.add(new Car(parts));
                }
            }
        }
        return vehicles;
    }

    public List<Vehicle> findByOwnerId(String ownerId) {
        List<Vehicle> allVehicles = findAll();
        List<Vehicle> userVehicles = new ArrayList<>();
        for (Vehicle v : allVehicles) {
            if (v.getOwnerId().equals(ownerId)) {
                userVehicles.add(v);
            }
        }
        return userVehicles;
    }

    public void delete(String id) {
        List<String> lines = FileHandler.readFile(FILE_NAME);
        List<String> toKeep = new ArrayList<>();
        for (String line : lines) {
            if (!line.startsWith(id + "|")) {
                toKeep.add(line);
            }
        }
        FileHandler.writeFile(FILE_NAME, toKeep);
    }

    public String generateVehicleId() {
        return "V" + System.currentTimeMillis();
    }
}

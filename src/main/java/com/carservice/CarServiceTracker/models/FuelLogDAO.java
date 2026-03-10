package com.carservice.CarServiceTracker.models;

import com.carservice.CarServiceTracker.utils.FileHandler;
import java.util.ArrayList;
import java.util.List;

public class FuelLogDAO {
    private static final String FILE_NAME = "fuel_logs.txt";

    public void save(FuelLog log) {
        List<String> lines = FileHandler.readFile(FILE_NAME);
        lines.add(log.toFileString());
        FileHandler.writeFile(FILE_NAME, lines);
    }

    public List<FuelLog> findAll() {
        List<String> lines = FileHandler.readFile(FILE_NAME);
        List<FuelLog> logs = new ArrayList<>();
        
        for (String line : lines) {
            String[] parts = line.split("\\|");
            if (parts.length >= 8) {
                if ("Petrol".equals(parts[7])) {
                    logs.add(new PetrolLog(parts));
                } else if ("Diesel".equals(parts[7])) {
                    logs.add(new DieselLog(parts));
                }
            }
        }
        return logs;
    }

    public List<FuelLog> findByVehicleId(String vehicleId) {
        List<FuelLog> allLogs = findAll();
        List<FuelLog> vehicleLogs = new ArrayList<>();
        for (FuelLog l : allLogs) {
            if (l.getVehicleId().equals(vehicleId)) {
                vehicleLogs.add(l);
            }
        }
        return vehicleLogs;
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

    public String generateLogId() {
        List<String> lines = FileHandler.readFile(FILE_NAME);
        return "FL" + String.format("%03d", lines.size() + 1);
    }
}

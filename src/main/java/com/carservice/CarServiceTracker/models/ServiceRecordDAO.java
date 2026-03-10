package com.carservice.CarServiceTracker.models;

import com.carservice.CarServiceTracker.utils.FileHandler;
import java.util.ArrayList;
import java.util.List;

public class ServiceRecordDAO {
    private static final String FILE_NAME = "service_records.txt";

    public void save(ServiceRecord record) {
        List<String> lines = FileHandler.readFile(FILE_NAME);
        lines.add(record.toFileString());
        FileHandler.writeFile(FILE_NAME, lines);
    }

    public List<ServiceRecord> findAll() {
        List<String> lines = FileHandler.readFile(FILE_NAME);
        List<ServiceRecord> records = new ArrayList<>();
        
        for (String line : lines) {
            String[] parts = line.split("\\|");
            if (parts.length >= 9) {
                if ("Routine Maintenance".equals(parts[7])) {
                    records.add(new RoutineService(parts));
                } else if ("Repair Work".equals(parts[7])) {
                    records.add(new RepairService(parts));
                }
            }
        }
        return records;
    }

    public List<ServiceRecord> findByVehicleId(String vehicleId) {
        List<ServiceRecord> allRecords = findAll();
        List<ServiceRecord> vehicleRecords = new ArrayList<>();
        for (ServiceRecord r : allRecords) {
            if (r.getVehicleId().equals(vehicleId)) {
                vehicleRecords.add(r);
            }
        }
        return vehicleRecords;
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

    public String generateRecordId() {
        List<String> lines = FileHandler.readFile(FILE_NAME);
        return "SR" + String.format("%03d", lines.size() + 1);
    }
}

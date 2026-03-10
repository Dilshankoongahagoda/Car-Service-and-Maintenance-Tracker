package com.carservice.CarServiceTracker.models;

import com.carservice.CarServiceTracker.utils.FileHandler;
import java.util.ArrayList;
import java.util.List;

public class ReminderDAO {
    private static final String FILE_NAME = "reminders.txt";

    public void save(Reminder reminder) {
        List<String> lines = FileHandler.readFile(FILE_NAME);
        lines.add(reminder.toFileString());
        FileHandler.writeFile(FILE_NAME, lines);
    }

    public List<Reminder> findAll() {
        List<String> lines = FileHandler.readFile(FILE_NAME);
        List<Reminder> reminders = new ArrayList<>();
        
        for (String line : lines) {
            String[] parts = line.split("\\|");
            if (parts.length >= 8) {
                if ("Date".equals(parts[6])) {
                    reminders.add(new DateBasedReminder(parts));
                } else if ("Mileage".equals(parts[6])) {
                    reminders.add(new MileageBasedReminder(parts));
                }
            }
        }
        return reminders;
    }

    public List<Reminder> findByVehicleId(String vehicleId) {
        List<Reminder> allReminders = findAll();
        List<Reminder> vehicleReminders = new ArrayList<>();
        for (Reminder r : allReminders) {
            if (r.getVehicleId().equals(vehicleId)) {
                vehicleReminders.add(r);
            }
        }
        return vehicleReminders;
    }

    public void updateStatus(String id, boolean active) {
        List<String> lines = FileHandler.readFile(FILE_NAME);
        List<String> updated = new ArrayList<>();
        for (String line : lines) {
            if (line.startsWith(id + "|")) {
                String[] parts = line.split("\\|");
                parts[4] = String.valueOf(active);
                updated.add(String.join("|", parts));
            } else {
                updated.add(line);
            }
        }
        FileHandler.writeFile(FILE_NAME, updated);
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

    public String generateReminderId() {
        List<String> lines = FileHandler.readFile(FILE_NAME);
        return "R" + String.format("%03d", lines.size() + 1);
    }
}

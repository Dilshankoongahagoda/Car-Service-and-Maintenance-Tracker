package com.carservice.CarServiceTracker.models;

import com.carservice.CarServiceTracker.utils.FileHandler;
import java.util.ArrayList;
import java.util.List;

public class AppointmentDAO {
    private static final String FILE_NAME = "appointments.txt";

    public List<Appointment> findAll() {
        List<Appointment> appointments = new ArrayList<>();
        List<String> lines = FileHandler.readFile(FILE_NAME);
        for (String line : lines) {
            String[] p = line.split("\\|", -1);
            if (p.length >= 12) {
                appointments.add(new Appointment(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11]));
            }
        }
        return appointments;
    }

    public List<Appointment> findByUserId(String userId) {
        List<Appointment> result = new ArrayList<>();
        for (Appointment a : findAll()) {
            if (a.getUserId().equals(userId)) {
                result.add(a);
            }
        }
        return result;
    }

    public List<Appointment> findCompletedByUserId(String userId) {
        List<Appointment> result = new ArrayList<>();
        for (Appointment a : findAll()) {
            if (a.getUserId().equals(userId) && "COMPLETED".equals(a.getStatus())) {
                result.add(a);
            }
        }
        return result;
    }

    public List<Appointment> findByStatus(String status) {
        List<Appointment> result = new ArrayList<>();
        for (Appointment a : findAll()) {
            if (status.equals(a.getStatus())) {
                result.add(a);
            }
        }
        return result;
    }

    public Appointment findById(String id) {
        for (Appointment a : findAll()) {
            if (a.getAppointmentId().equals(id)) {
                return a;
            }
        }
        return null;
    }

    public void save(Appointment a) {
        List<String> lines = FileHandler.readFile(FILE_NAME);
        lines.add(toLine(a));
        FileHandler.writeFile(FILE_NAME, lines);
    }

    public void updateStatus(String id, String newStatus) {
        List<String> lines = FileHandler.readFile(FILE_NAME);
        List<String> newLines = new ArrayList<>();
        for (String line : lines) {
            if (line.startsWith(id + "|")) {
                String[] p = line.split("\\|", -1);
                if (p.length >= 12) {
                    p[11] = newStatus;
                    newLines.add(String.join("|", p));
                } else {
                    newLines.add(line);
                }
            } else {
                newLines.add(line);
            }
        }
        FileHandler.writeFile(FILE_NAME, newLines);
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

    public String generateId() {
        return "APT" + System.currentTimeMillis();
    }

    private String toLine(Appointment a) {
        return a.getAppointmentId() + "|" + a.getUserId() + "|" + safe(a.getUserName()) + "|"
             + a.getVehicleId() + "|" + safe(a.getVehicleInfo()) + "|" + safe(a.getServiceCategory()) + "|"
             + safe(a.getServiceName()) + "|" + safe(a.getServicePrice()) + "|"
             + safe(a.getPreferredDate()) + "|" + safe(a.getPreferredTime()) + "|"
             + safe(a.getNotes()) + "|" + a.getStatus();
    }

    private String safe(String s) {
        if (s == null) return "";
        // Strip newlines and pipe chars to prevent data corruption
        return s.replace("\n", " ").replace("\r", "").replace("|", " ");
    }
}

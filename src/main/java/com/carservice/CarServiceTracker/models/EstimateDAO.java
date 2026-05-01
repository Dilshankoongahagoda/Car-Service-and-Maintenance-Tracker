package com.carservice.CarServiceTracker.models;

import com.carservice.CarServiceTracker.utils.FileHandler;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class EstimateDAO {
    private static final String FILE_NAME = "estimates.txt";

    // Format: estimateId|appointmentId|userId|userName|vehicleId|vehicleInfo|serviceItems|servicePrices|additionalServices|additionalPrices|parts|partPrices|serviceCharge|subtotal|tax|total|notes|status|createdDate
    // 19 fields total

    public List<Estimate> findAll() {
        List<Estimate> estimates = new ArrayList<>();
        List<String> lines = FileHandler.readFile(FILE_NAME);
        for (String line : lines) {
            String[] p = line.split("\\|", -1);
            if (p.length >= 19) {
                estimates.add(new Estimate(
                    p[0], p[1], p[2], p[3], p[4], p[5],
                    p[6], p[7], p[8], p[9], p[10], p[11],
                    p[12], p[13], p[14], p[15], p[16], p[17], p[18]
                ));
            }
        }
        // Newest first — file appends chronologically, so reverse
        Collections.reverse(estimates);
        return estimates;
    }

    public List<Estimate> findByUserId(String userId) {
        List<Estimate> result = new ArrayList<>();
        for (Estimate e : findAll()) {
            if (e.getUserId().equals(userId)) {
                result.add(e);
            }
        }
        return result;
    }

    public Estimate findById(String id) {
        for (Estimate e : findAll()) {
            if (e.getEstimateId().equals(id)) {
                return e;
            }
        }
        return null;
    }

    public Estimate findByAppointmentId(String appointmentId) {
        for (Estimate e : findAll()) {
            if (e.getAppointmentId().equals(appointmentId)) {
                return e;
            }
        }
        return null;
    }

    public void save(Estimate e) {
        List<String> lines = FileHandler.readFile(FILE_NAME);
        lines.add(toLine(e));
        FileHandler.writeFile(FILE_NAME, lines);
    }

    public void updateStatus(String id, String newStatus) {
        List<String> lines = FileHandler.readFile(FILE_NAME);
        List<String> newLines = new ArrayList<>();
        for (String line : lines) {
            if (line.startsWith(id + "|")) {
                String[] p = line.split("\\|", -1);
                if (p.length >= 19) {
                    p[17] = newStatus;
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

    public void update(Estimate e) {
        List<String> lines = FileHandler.readFile(FILE_NAME);
        List<String> newLines = new ArrayList<>();
        for (String line : lines) {
            if (line.startsWith(e.getEstimateId() + "|")) {
                newLines.add(toLine(e));
            } else {
                newLines.add(line);
            }
        }
        FileHandler.writeFile(FILE_NAME, newLines);
    }

    public String generateId() {
        return "INV" + System.currentTimeMillis();
    }

    private String toLine(Estimate e) {
        return safe(e.getEstimateId()) + "|" + safe(e.getAppointmentId()) + "|"
             + safe(e.getUserId()) + "|" + safe(e.getUserName()) + "|"
             + safe(e.getVehicleId()) + "|" + safe(e.getVehicleInfo()) + "|"
             + safe(e.getServiceItems()) + "|" + safe(e.getServicePrices()) + "|"
             + safe(e.getAdditionalServices()) + "|" + safe(e.getAdditionalPrices()) + "|"
             + safe(e.getParts()) + "|" + safe(e.getPartPrices()) + "|"
             + safe(e.getServiceCharge()) + "|"
             + safe(e.getSubtotal()) + "|" + safe(e.getTax()) + "|" + safe(e.getTotal()) + "|"
             + safe(e.getNotes()) + "|" + safe(e.getStatus()) + "|" + safe(e.getCreatedDate());
    }

    private String safe(String s) {
        if (s == null) return "";
        return s.replace("\n", " ").replace("\r", "").replace("|", " ");
    }
}

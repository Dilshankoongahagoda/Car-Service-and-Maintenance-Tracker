package com.carservice.CarServiceTracker.models;

import java.time.LocalDate;

public class MileageBasedReminder extends Reminder {
    private int dueMileage;
    private int advanceNoticeKm;

    public MileageBasedReminder(String reminderId, String vehicleId, String title, String description,
                                boolean isActive, LocalDate createdDate, int dueMileage, int advanceNoticeKm) {
        super(reminderId, vehicleId, title, description, isActive, createdDate);
        this.dueMileage = dueMileage;
        this.advanceNoticeKm = advanceNoticeKm;
    }

    public MileageBasedReminder(String[] parts) {
        super(parts[0], parts[1], parts[2], parts[3], Boolean.parseBoolean(parts[4]), LocalDate.parse(parts[5]));
        String[] specificData = parts[7].split(",");
        this.dueMileage = Integer.parseInt(specificData[0]);
        this.advanceNoticeKm = Integer.parseInt(specificData[1]);
    }

    @Override
    public boolean isOverdue(Vehicle vehicle) {
        if (vehicle == null) return false;
        return vehicle.getCurrentMileage() > dueMileage;
    }

    @Override
    public String getStatusMessage(Vehicle vehicle) {
        if (!isActive()) return "Completed";
        if (vehicle == null) return "Vehicle data unavailable";

        int kmRemaining = dueMileage - vehicle.getCurrentMileage();
        if (kmRemaining < 0) {
            return "Overdue by " + Math.abs(kmRemaining) + " km";
        } else if (kmRemaining <= advanceNoticeKm) {
            return "Due in " + kmRemaining + " km";
        }
        return "Scheduled at " + dueMileage + " km";
    }

    @Override
    public String getReminderType() {
        return "Mileage";
    }

    @Override
    protected String getSpecificData() {
        return dueMileage + "," + advanceNoticeKm;
    }
}

package com.carservice.CarServiceTracker.models;

import java.time.LocalDate;

public abstract class Reminder {
    private String reminderId;
    private String vehicleId;
    private String title;
    private String description;
    private boolean isActive;
    private LocalDate createdDate;

    public Reminder(String reminderId, String vehicleId, String title, String description,
                    boolean isActive, LocalDate createdDate) {
        this.reminderId = reminderId;
        this.vehicleId = vehicleId;
        this.title = title;
        this.description = description;
        this.isActive = isActive;
        this.createdDate = createdDate;
    }

    public String getReminderId() { return reminderId; }
    public String getVehicleId() { return vehicleId; }
    public String getTitle() { return title; }
    public String getDescription() { return description; }
    public boolean isActive() { return isActive; }
    public LocalDate getCreatedDate() { return createdDate; }

    public void setActive(boolean active) { this.isActive = active; }

    public abstract boolean isOverdue(Vehicle vehicle);
    public abstract String getStatusMessage(Vehicle vehicle);
    public abstract String getReminderType();
    
    protected abstract String getSpecificData();

    public String toFileString() {
        return reminderId + "|" + vehicleId + "|" + title + "|" +
               description + "|" + isActive + "|" + createdDate + "|" +
               getReminderType() + "|" + getSpecificData();
    }
}

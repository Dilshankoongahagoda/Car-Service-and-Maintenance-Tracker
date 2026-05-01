package com.carservice.CarServiceTracker.models;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

public class DateBasedReminder extends Reminder {
    private final LocalDate dueDate;
    private final int advanceNoticeDays;

    public DateBasedReminder(String reminderId, String vehicleId, String title, String description,
                             boolean isActive, LocalDate createdDate, LocalDate dueDate, int advanceNoticeDays) {
        super(reminderId, vehicleId, title, description, isActive, createdDate);
        this.dueDate = dueDate;
        this.advanceNoticeDays = advanceNoticeDays;
    }

    public DateBasedReminder(String[] parts) {
        super(parts[0], parts[1], parts[2], parts[3], Boolean.parseBoolean(parts[4]), LocalDate.parse(parts[5]));
        String[] specificData = parts[7].split(",");
        this.dueDate = LocalDate.parse(specificData[0]);
        this.advanceNoticeDays = Integer.parseInt(specificData[1]);
    }

    @Override
    public boolean isOverdue(Vehicle vehicle) {
        return LocalDate.now().isAfter(dueDate);
    }

    @Override
    public String getStatusMessage(Vehicle vehicle) {
        if (!isActive()) return "Completed";
        
        long daysUntilDue = ChronoUnit.DAYS.between(LocalDate.now(), dueDate);
        if (daysUntilDue < 0) {
            return "Overdue by " + Math.abs(daysUntilDue) + " days";
        } else if (daysUntilDue <= advanceNoticeDays) {
            return "Due in " + daysUntilDue + " days";
        }
        return "Scheduled for " + dueDate;
    }

    @Override
    public String getReminderType() {
        return "Date";
    }

    @Override
    protected String getSpecificData() {
        return dueDate + "," + advanceNoticeDays;
    }
}

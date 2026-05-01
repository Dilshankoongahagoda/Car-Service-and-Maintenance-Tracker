package com.carservice.CarServiceTracker.models;

/**
 * POJO representing an auto-generated service reminder
 * based on a completed appointment's service date + service-specific interval.
 */
public class ServiceReminder {
    private String serviceName;
    private String vehicleInfo;
    private String completedDate;   // e.g. "2026-03-24"
    private String nextDueDate;     // e.g. "2026-09-24"
    private long daysRemaining;     // negative = overdue
    private String status;          // ON_TRACK, DUE_SOON, OVERDUE
    private int intervalMonths;
    private String appointmentId;

    public ServiceReminder() {}

    public ServiceReminder(String serviceName, String vehicleInfo, String completedDate,
                           String nextDueDate, long daysRemaining, String status,
                           int intervalMonths, String appointmentId) {
        this.serviceName = serviceName;
        this.vehicleInfo = vehicleInfo;
        this.completedDate = completedDate;
        this.nextDueDate = nextDueDate;
        this.daysRemaining = daysRemaining;
        this.status = status;
        this.intervalMonths = intervalMonths;
        this.appointmentId = appointmentId;
    }

    public String getServiceName() { return serviceName; }
    public void setServiceName(String serviceName) { this.serviceName = serviceName; }

    public String getVehicleInfo() { return vehicleInfo; }
    public void setVehicleInfo(String vehicleInfo) { this.vehicleInfo = vehicleInfo; }

    public String getCompletedDate() { return completedDate; }
    public void setCompletedDate(String completedDate) { this.completedDate = completedDate; }

    public String getNextDueDate() { return nextDueDate; }
    public void setNextDueDate(String nextDueDate) { this.nextDueDate = nextDueDate; }

    public long getDaysRemaining() { return daysRemaining; }
    public void setDaysRemaining(long daysRemaining) { this.daysRemaining = daysRemaining; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getIntervalMonths() { return intervalMonths; }
    public void setIntervalMonths(int intervalMonths) { this.intervalMonths = intervalMonths; }

    public String getAppointmentId() { return appointmentId; }
    public void setAppointmentId(String appointmentId) { this.appointmentId = appointmentId; }

    /**
     * Human-readable time remaining string.
     */
    public String getTimeRemainingText() {
        if (daysRemaining < 0) {
            long overdueDays = Math.abs(daysRemaining);
            if (overdueDays > 30) {
                long months = overdueDays / 30;
                long days = overdueDays % 30;
                return "Overdue by " + months + " month" + (months > 1 ? "s" : "") +
                       (days > 0 ? " " + days + " day" + (days > 1 ? "s" : "") : "");
            }
            return "Overdue by " + overdueDays + " day" + (overdueDays > 1 ? "s" : "");
        } else if (daysRemaining == 0) {
            return "Due today!";
        } else if (daysRemaining <= 30) {
            return daysRemaining + " day" + (daysRemaining > 1 ? "s" : "") + " remaining";
        } else {
            long months = daysRemaining / 30;
            long days = daysRemaining % 30;
            if (days == 0) {
                return months + " month" + (months > 1 ? "s" : "") + " remaining";
            }
            return months + " month" + (months > 1 ? "s" : "") + " " +
                   days + " day" + (days > 1 ? "s" : "") + " remaining";
        }
    }

    /**
     * Progress percentage (0-100) for the visual bar.
     * 100% = just completed, 0% = due now.
     */
    public int getProgressPercent() {
        long totalDays = intervalMonths * 30L;
        if (totalDays <= 0) return 0;
        long elapsed = totalDays - daysRemaining;
        if (elapsed < 0) elapsed = 0;
        if (elapsed > totalDays) elapsed = totalDays;
        int percent = (int) ((elapsed * 100) / totalDays);
        return Math.min(100, Math.max(0, percent));
    }
}

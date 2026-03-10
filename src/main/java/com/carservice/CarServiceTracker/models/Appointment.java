package com.carservice.CarServiceTracker.models;

public class Appointment {
    private String appointmentId;
    private String userId;
    private String userName;
    private String vehicleId;
    private String vehicleInfo;
    private String serviceCategory;
    private String serviceName;
    private String servicePrice;
    private String preferredDate;
    private String preferredTime;
    private String notes;
    private String status; // PENDING, CONFIRMED, COMPLETED, CANCELLED

    public Appointment() {}

    public Appointment(String appointmentId, String userId, String userName, String vehicleId,
                       String vehicleInfo, String serviceCategory, String serviceName,
                       String servicePrice, String preferredDate, String preferredTime,
                       String notes, String status) {
        this.appointmentId = appointmentId;
        this.userId = userId;
        this.userName = userName;
        this.vehicleId = vehicleId;
        this.vehicleInfo = vehicleInfo;
        this.serviceCategory = serviceCategory;
        this.serviceName = serviceName;
        this.servicePrice = servicePrice;
        this.preferredDate = preferredDate;
        this.preferredTime = preferredTime;
        this.notes = notes;
        this.status = status;
    }

    public String getAppointmentId() { return appointmentId; }
    public void setAppointmentId(String appointmentId) { this.appointmentId = appointmentId; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getVehicleId() { return vehicleId; }
    public void setVehicleId(String vehicleId) { this.vehicleId = vehicleId; }

    public String getVehicleInfo() { return vehicleInfo; }
    public void setVehicleInfo(String vehicleInfo) { this.vehicleInfo = vehicleInfo; }

    public String getServiceCategory() { return serviceCategory; }
    public void setServiceCategory(String serviceCategory) { this.serviceCategory = serviceCategory; }

    public String getServiceName() { return serviceName; }
    public void setServiceName(String serviceName) { this.serviceName = serviceName; }

    public String getServicePrice() { return servicePrice; }
    public void setServicePrice(String servicePrice) { this.servicePrice = servicePrice; }

    public String getPreferredDate() { return preferredDate; }
    public void setPreferredDate(String preferredDate) { this.preferredDate = preferredDate; }

    public String getPreferredTime() { return preferredTime; }
    public void setPreferredTime(String preferredTime) { this.preferredTime = preferredTime; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}

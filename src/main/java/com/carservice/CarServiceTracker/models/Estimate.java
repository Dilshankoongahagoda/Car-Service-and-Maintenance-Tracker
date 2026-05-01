package com.carservice.CarServiceTracker.models;

public class Estimate {
    private String estimateId;
    private String appointmentId;      // linked to the completed appointment
    private String userId;
    private String userName;
    private String vehicleId;
    private String vehicleInfo;
    private String serviceItems;       // comma-separated original service names from appointment
    private String servicePrices;      // comma-separated prices for original services
    private String additionalServices; // comma-separated extra services admin added
    private String additionalPrices;   // comma-separated prices for extra services
    private String parts;              // comma-separated part names
    private String partPrices;         // comma-separated part prices
    private String serviceCharge;      // service/labour charge
    private String subtotal;
    private String tax;
    private String total;
    private String notes;
    private String status;             // INVOICED, PAID
    private String createdDate;

    public Estimate() {}

    public Estimate(String estimateId, String appointmentId, String userId, String userName,
                    String vehicleId, String vehicleInfo,
                    String serviceItems, String servicePrices,
                    String additionalServices, String additionalPrices,
                    String parts, String partPrices, String serviceCharge,
                    String subtotal, String tax, String total,
                    String notes, String status, String createdDate) {
        this.estimateId = estimateId;
        this.appointmentId = appointmentId;
        this.userId = userId;
        this.userName = userName;
        this.vehicleId = vehicleId;
        this.vehicleInfo = vehicleInfo;
        this.serviceItems = serviceItems;
        this.servicePrices = servicePrices;
        this.additionalServices = additionalServices;
        this.additionalPrices = additionalPrices;
        this.parts = parts;
        this.partPrices = partPrices;
        this.serviceCharge = serviceCharge;
        this.subtotal = subtotal;
        this.tax = tax;
        this.total = total;
        this.notes = notes;
        this.status = status;
        this.createdDate = createdDate;
    }

    // Getters and Setters
    public String getEstimateId() { return estimateId; }
    public void setEstimateId(String estimateId) { this.estimateId = estimateId; }

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

    public String getServiceItems() { return serviceItems; }
    public void setServiceItems(String serviceItems) { this.serviceItems = serviceItems; }

    public String getServicePrices() { return servicePrices; }
    public void setServicePrices(String servicePrices) { this.servicePrices = servicePrices; }

    public String getAdditionalServices() { return additionalServices; }
    public void setAdditionalServices(String additionalServices) { this.additionalServices = additionalServices; }

    public String getAdditionalPrices() { return additionalPrices; }
    public void setAdditionalPrices(String additionalPrices) { this.additionalPrices = additionalPrices; }

    public String getParts() { return parts; }
    public void setParts(String parts) { this.parts = parts; }

    public String getPartPrices() { return partPrices; }
    public void setPartPrices(String partPrices) { this.partPrices = partPrices; }

    public String getServiceCharge() { return serviceCharge; }
    public void setServiceCharge(String serviceCharge) { this.serviceCharge = serviceCharge; }

    public String getSubtotal() { return subtotal; }
    public void setSubtotal(String subtotal) { this.subtotal = subtotal; }

    public String getTax() { return tax; }
    public void setTax(String tax) { this.tax = tax; }

    public String getTotal() { return total; }
    public void setTotal(String total) { this.total = total; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getCreatedDate() { return createdDate; }
    public void setCreatedDate(String createdDate) { this.createdDate = createdDate; }
}

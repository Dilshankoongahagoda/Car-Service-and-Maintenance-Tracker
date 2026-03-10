package com.carservice.CarServiceTracker.models;

import java.time.LocalDate;

public abstract class ServiceRecord {
    private String recordId;
    private String vehicleId;
    private LocalDate serviceDate;
    private int mileageAtService;
    private double cost;
    private String serviceCenterId;
    private String notes;

    public ServiceRecord(String recordId, String vehicleId, LocalDate serviceDate,
                         int mileageAtService, double cost, String serviceCenterId, String notes) {
        this.recordId = recordId;
        this.vehicleId = vehicleId;
        this.serviceDate = serviceDate;
        this.mileageAtService = mileageAtService;
        this.cost = cost;
        this.serviceCenterId = serviceCenterId;
        this.notes = notes;
    }

    public String getRecordId() { return recordId; }
    public String getVehicleId() { return vehicleId; }
    public LocalDate getServiceDate() { return serviceDate; }
    public int getMileageAtService() { return mileageAtService; }
    public double getCost() { return cost; }
    public String getServiceCenterId() { return serviceCenterId; }
    public String getNotes() { return notes; }

    public abstract String getServiceType();
    public abstract String getServiceSummary();

    public String toFileString() {
        return recordId + "|" + vehicleId + "|" + serviceDate + "|" +
               mileageAtService + "|" + cost + "|" + serviceCenterId + "|" +
               notes + "|" + getServiceType() + "|" + getSpecificData();
    }
    
    protected abstract String getSpecificData();
}

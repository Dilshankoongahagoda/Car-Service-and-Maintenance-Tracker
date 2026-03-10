package com.carservice.CarServiceTracker.models;

public abstract class Vehicle {
    private String vehicleId;
    private String ownerId;
    private String make;
    private String model;
    private int year;
    private String licensePlate;
    private int currentMileage;
    private String fuelType;

    public Vehicle(String vehicleId, String ownerId, String make, String model, int year,
                   String licensePlate, int currentMileage, String fuelType) {
        this.vehicleId = vehicleId;
        this.ownerId = ownerId;
        this.make = make;
        this.model = model;
        this.year = year;
        this.licensePlate = licensePlate;
        this.currentMileage = currentMileage;
        this.fuelType = fuelType;
    }

    public String getVehicleId() { return vehicleId; }
    public String getOwnerId() { return ownerId; }
    public String getMake() { return make; }
    public String getModel() { return model; }
    public int getYear() { return year; }
    public String getLicensePlate() { return licensePlate; }
    public int getCurrentMileage() { return currentMileage; }
    public String getFuelType() { return fuelType; }

    public void setCurrentMileage(int mileage) {
        if (mileage >= this.currentMileage) {
            this.currentMileage = mileage;
        } else {
            throw new IllegalArgumentException("Mileage cannot decrease");
        }
    }

    protected abstract int getServiceInterval();
    public abstract String getVehicleType();
    public abstract String getSpecificData();

    public String toFileString() {
        return vehicleId + "|" + ownerId + "|" + make + "|" +
               model + "|" + year + "|" + licensePlate + "|" +
               currentMileage + "|" + fuelType + "|" +
               getVehicleType() + "|" + getSpecificData();
    }
}

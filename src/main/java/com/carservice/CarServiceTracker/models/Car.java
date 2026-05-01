package com.carservice.CarServiceTracker.models;

public class Car extends Vehicle {
    private final int numberOfDoors;
    private final String transmissionType;

    public Car(String vehicleId, String ownerId, String make, String model, int year,
               String licensePlate, int currentMileage, String fuelType,
               int numberOfDoors, String transmissionType) {
        super(vehicleId, ownerId, make, model, year, licensePlate, currentMileage, fuelType);
        this.numberOfDoors = numberOfDoors;
        this.transmissionType = transmissionType;
    }

    public Car(String[] parts) {
        super(parts[0], parts[1], parts[2], parts[3], Integer.parseInt(parts[4]), parts[5], Integer.parseInt(parts[6]), parts[7]);
        String[] specificData = parts[9].split(",");
        this.numberOfDoors = Integer.parseInt(specificData[0].trim().replace("doors", ""));
        this.transmissionType = specificData[1];
    }
    
    public int getNumberOfDoors() { return numberOfDoors; }
    public String getTransmissionType() { return transmissionType; }

    @Override
    protected int getServiceInterval() {
        return 5000; // Cars: service every 5000 km
    }

    @Override
    public String getVehicleType() {
        return "Car";
    }

    @Override
    public String getSpecificData() {
        return numberOfDoors + "doors," + transmissionType;
    }
}

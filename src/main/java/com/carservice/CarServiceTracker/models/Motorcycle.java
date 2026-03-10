package com.carservice.CarServiceTracker.models;

public class Motorcycle extends Vehicle {
    private int engineCC;
    private boolean hasFairing;

    public Motorcycle(String vehicleId, String ownerId, String make, String model, int year,
                      String licensePlate, int currentMileage, String fuelType,
                      int engineCC, boolean hasFairing) {
        super(vehicleId, ownerId, make, model, year, licensePlate, currentMileage, fuelType);
        this.engineCC = engineCC;
        this.hasFairing = hasFairing;
    }

    public Motorcycle(String[] parts) {
        super(parts[0], parts[1], parts[2], parts[3], Integer.parseInt(parts[4]), parts[5], Integer.parseInt(parts[6]), parts[7]);
        String[] specificData = parts[9].split(",");
        this.engineCC = Integer.parseInt(specificData[0].replace("cc", ""));
        this.hasFairing = Boolean.parseBoolean(specificData[1]);
    }

    public int getEngineCC() { return engineCC; }
    public boolean hasFairing() { return hasFairing; }

    @Override
    protected int getServiceInterval() {
        return 3000; // Bikes: service every 3000 km
    }

    @Override
    public String getVehicleType() {
        return "Motorcycle";
    }

    @Override
    public String getSpecificData() {
        return engineCC + "cc," + hasFairing;
    }
}

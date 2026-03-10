package com.carservice.CarServiceTracker.models;

import java.time.LocalDate;

public abstract class FuelLog {
    private String logId;
    private String vehicleId;
    private LocalDate fillDate;
    private double liters;
    private double costPerLiter;
    private int odometerReading;
    private boolean isFullTank;

    public FuelLog(String logId, String vehicleId, LocalDate fillDate,
                   double liters, double costPerLiter, int odometerReading, boolean isFullTank) {
        this.logId = logId;
        this.vehicleId = vehicleId;
        this.fillDate = fillDate;
        this.liters = liters;
        this.costPerLiter = costPerLiter;
        this.odometerReading = odometerReading;
        this.isFullTank = isFullTank;
    }

    public String getLogId() { return logId; }
    public String getVehicleId() { return vehicleId; }
    public LocalDate getFillDate() { return fillDate; }
    public double getLiters() { return liters; }
    public double getCostPerLiter() { return costPerLiter; }
    public int getOdometerReading() { return odometerReading; }
    public boolean isFullTank() { return isFullTank; }

    public double getTotalCost() {
        return liters * costPerLiter;
    }

    public abstract double calculateEfficiency(int previousOdometer);
    public abstract String getFuelTypeDisplay();

    public String toFileString() {
        return logId + "|" + vehicleId + "|" + fillDate + "|" + liters + "|" +
               costPerLiter + "|" + odometerReading + "|" + isFullTank + "|" +
               getFuelTypeDisplay() + "|" + getSpecificData();
    }

    protected abstract String getSpecificData();
}

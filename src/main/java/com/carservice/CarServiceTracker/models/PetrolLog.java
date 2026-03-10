package com.carservice.CarServiceTracker.models;

import java.time.LocalDate;

public class PetrolLog extends FuelLog {
    private String octaneRating;

    public PetrolLog(String logId, String vehicleId, LocalDate fillDate,
                     double liters, double costPerLiter, int odometerReading,
                     boolean isFullTank, String octaneRating) {
        super(logId, vehicleId, fillDate, liters, costPerLiter, odometerReading, isFullTank);
        this.octaneRating = octaneRating;
    }

    public PetrolLog(String[] parts) {
        super(parts[0], parts[1], LocalDate.parse(parts[2]), Double.parseDouble(parts[3]),
                Double.parseDouble(parts[4]), Integer.parseInt(parts[5]), Boolean.parseBoolean(parts[6]));
        this.octaneRating = parts.length > 8 ? parts[8] : "92";
    }

    @Override
    public double calculateEfficiency(int previousOdometer) {
        if (previousOdometer == 0) return 0.0;
        int kmTraveled = getOdometerReading() - previousOdometer;
        double efficiency = kmTraveled / getLiters();
        
        if ("95".equals(octaneRating)) {
            efficiency *= 1.02; // Small efficiency boost
        }
        return efficiency;
    }

    @Override
    public String getFuelTypeDisplay() {
        return "Petrol";
    }

    @Override
    protected String getSpecificData() {
        return octaneRating;
    }
}

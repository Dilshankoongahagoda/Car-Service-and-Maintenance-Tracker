package com.carservice.CarServiceTracker.models;

import java.time.LocalDate;

public class DieselLog extends FuelLog {
    private boolean isAdBlueRequired;

    public DieselLog(String logId, String vehicleId, LocalDate fillDate,
                     double liters, double costPerLiter, int odometerReading,
                     boolean isFullTank, boolean isAdBlueRequired) {
        super(logId, vehicleId, fillDate, liters, costPerLiter, odometerReading, isFullTank);
        this.isAdBlueRequired = isAdBlueRequired;
    }

    public DieselLog(String[] parts) {
        super(parts[0], parts[1], LocalDate.parse(parts[2]), Double.parseDouble(parts[3]),
                Double.parseDouble(parts[4]), Integer.parseInt(parts[5]), Boolean.parseBoolean(parts[6]));
        this.isAdBlueRequired = parts.length > 8 && Boolean.parseBoolean(parts[8]);
    }

    @Override
    public double calculateEfficiency(int previousOdometer) {
        if (previousOdometer == 0) return 0.0;
        int kmTraveled = getOdometerReading() - previousOdometer;
        double efficiency = kmTraveled / getLiters();
        
        // Diesel typically has better efficiency
        return efficiency * 1.15;
    }

    @Override
    public String getFuelTypeDisplay() {
        return "Diesel";
    }

    @Override
    protected String getSpecificData() {
        return String.valueOf(isAdBlueRequired);
    }
}

package com.carservice.CarServiceTracker.models;

import java.time.LocalDate;

public class RepairService extends ServiceRecord {
    private String problemDescription;
    private String diagnosis;
    private boolean underWarranty;

    public RepairService(String recordId, String vehicleId, LocalDate serviceDate,
                         int mileageAtService, double cost, String serviceCenterId, String notes,
                         String problemDescription, String diagnosis, boolean underWarranty) {
        super(recordId, vehicleId, serviceDate, mileageAtService, cost, serviceCenterId, notes);
        this.problemDescription = problemDescription;
        this.diagnosis = diagnosis;
        this.underWarranty = underWarranty;
    }

    public RepairService(String[] parts) {
        super(parts[0], parts[1], LocalDate.parse(parts[2]), Integer.parseInt(parts[3]),
                Double.parseDouble(parts[4]), parts[5], parts[6]);
        String[] specificData = parts.length > 8 ? parts[8].split(",") : new String[]{"", "", "false"};
        this.problemDescription = specificData[0];
        this.diagnosis = specificData.length > 1 ? specificData[1] : "";
        this.underWarranty = specificData.length > 2 && Boolean.parseBoolean(specificData[2]);
    }

    @Override
    public String getServiceType() {
        return "Repair Work";
    }

    @Override
    public String getServiceSummary() {
        return "Repair: " + problemDescription;
    }

    @Override
    protected String getSpecificData() {
        return problemDescription + "," + diagnosis + "," + underWarranty;
    }
}

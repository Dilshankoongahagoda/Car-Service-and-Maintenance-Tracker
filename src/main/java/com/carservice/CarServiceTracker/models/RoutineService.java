package com.carservice.CarServiceTracker.models;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class RoutineService extends ServiceRecord {
    private String serviceCategory;
    private List<String> partsReplaced;

    public RoutineService(String recordId, String vehicleId, LocalDate serviceDate,
                          int mileageAtService, double cost, String serviceCenterId, String notes,
                          String serviceCategory, List<String> partsReplaced) {
        super(recordId, vehicleId, serviceDate, mileageAtService, cost, serviceCenterId, notes);
        this.serviceCategory = serviceCategory;
        this.partsReplaced = partsReplaced;
    }

    public RoutineService(String[] parts) {
        super(parts[0], parts[1], LocalDate.parse(parts[2]), Integer.parseInt(parts[3]),
                Double.parseDouble(parts[4]), parts[5], parts[6]);
        String[] specificData = parts.length > 8 ? parts[8].split(",") : new String[]{""};
        this.serviceCategory = specificData.length > 0 ? specificData[0] : "";
        this.partsReplaced = new ArrayList<>();
        if (specificData.length > 1) {
            String partsStr = specificData[1].replace("[", "").replace("]", "");
            if (!partsStr.isEmpty()) {
                 this.partsReplaced.addAll(Arrays.asList(partsStr.split(";")));
            }
        }
    }

    @Override
    public String getServiceType() {
        return "Routine Maintenance";
    }

    @Override
    public String getServiceSummary() {
        return serviceCategory + " - " + partsReplaced.size() + " parts replaced";
    }

    @Override
    protected String getSpecificData() {
        String partsStr = String.join(";", partsReplaced);
        return serviceCategory + ",[" + partsStr + "]";
    }
}

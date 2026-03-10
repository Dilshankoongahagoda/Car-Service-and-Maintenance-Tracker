package com.carservice.CarServiceTracker.servlets;

import com.carservice.CarServiceTracker.models.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Controller
public class FuelLogServlet {
    private FuelLogDAO fuelDao = new FuelLogDAO();
    private VehicleDAO vehicleDao = new VehicleDAO();

    @GetMapping("/fuel")
    public String handleGet(@RequestParam(value = "action", required = false) String action,
                            @RequestParam(value = "id", required = false) String id,
                            HttpSession session, Model model) {
        if (session == null || session.getAttribute("authUser") == null) {
            return "redirect:/user";
        }

        User authUser = (User) session.getAttribute("authUser");

        if ("add".equals(action)) {
            model.addAttribute("myVehicles", vehicleDao.findByOwnerId(authUser.getUserId()));
            return "add_fuel_log";
        } else if ("delete".equals(action)) {
            fuelDao.delete(id);
            return "redirect:/fuel?success=true";
        } else {
            List<FuelLog> allMyLogs = new ArrayList<>();
            List<Vehicle> myVehicles = vehicleDao.findByOwnerId(authUser.getUserId());
            for (Vehicle v : myVehicles) {
                allMyLogs.addAll(fuelDao.findByVehicleId(v.getVehicleId()));
            }
            model.addAttribute("fuelLogs", allMyLogs);
            return "fuel_logs";
        }
    }

    @PostMapping("/fuel")
    public String handlePost(@RequestParam("action") String action,
                             @RequestParam(value = "vehicleId", required = false) String vehicleId,
                             @RequestParam(value = "fillDate", required = false) String fillDateStr,
                             @RequestParam(value = "liters", required = false) String litersStr,
                             @RequestParam(value = "costPerLiter", required = false) String costPerLiterStr,
                             @RequestParam(value = "odometer", required = false) String odometerStr,
                             @RequestParam(value = "isFullTank", required = false) String isFullTankStr,
                             @RequestParam(value = "fuelType", required = false) String fuelType,
                             @RequestParam(value = "octaneRating", required = false) String octaneRating,
                             @RequestParam(value = "isAdBlueRequired", required = false) String isAdBlueStr) {
        if ("create".equals(action)) {
            try {
                LocalDate fillDate = LocalDate.parse(fillDateStr);
                double liters = Double.parseDouble(litersStr);
                double costPerLiter = Double.parseDouble(costPerLiterStr);
                int odometerReading = Integer.parseInt(odometerStr);
                boolean isFullTank = Boolean.parseBoolean(isFullTankStr);
                String logId = fuelDao.generateLogId();
                FuelLog log;

                if ("Petrol".equals(fuelType)) {
                    log = new PetrolLog(logId, vehicleId, fillDate, liters, costPerLiter, odometerReading, isFullTank, octaneRating);
                } else {
                    boolean adBlue = Boolean.parseBoolean(isAdBlueStr);
                    log = new DieselLog(logId, vehicleId, fillDate, liters, costPerLiter, odometerReading, isFullTank, adBlue);
                }

                fuelDao.save(log);
                return "redirect:/fuel?success=true";
            } catch (Exception e) {
                return "redirect:/fuel?action=add&error=true";
            }
        }
        return "redirect:/fuel";
    }
}

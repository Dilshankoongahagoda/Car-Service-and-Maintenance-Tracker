package com.carservice.CarServiceTracker.servlets;

import com.carservice.CarServiceTracker.models.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class VehicleServlet {
    private VehicleDAO dao = new VehicleDAO();

    @GetMapping("/vehicle")
    public String handleGet(@RequestParam(value = "action", required = false) String action,
                            @RequestParam(value = "id", required = false) String id,
                            @RequestParam(value = "redirect", required = false) String redirectParam,
                            HttpSession session, Model model) {
        if ("add".equals(action)) {
            return "add_vehicle";
        } else if ("delete".equals(action)) {
            dao.delete(id);
            if ("all_vehicles".equals(redirectParam)) {
                return "redirect:/all_vehicles?success=true";
            }
            return "redirect:/dashboard?success=true";
        }
        return "redirect:/dashboard";
    }

    @PostMapping("/vehicle")
    public String handlePost(@RequestParam("action") String action,
                             @RequestParam(value = "make", required = false) String make,
                             @RequestParam(value = "model", required = false) String modelName,
                             @RequestParam(value = "year", required = false) String yearStr,
                             @RequestParam(value = "licensePlate", required = false) String licensePlate,
                             @RequestParam(value = "mileage", required = false) String mileageStr,
                             @RequestParam(value = "fuelType", required = false) String fuelType,
                             @RequestParam(value = "vehicleType", required = false) String vehicleType,
                             @RequestParam(value = "doors", required = false) String doorsStr,
                             @RequestParam(value = "transmission", required = false) String transmission,
                             @RequestParam(value = "engineCC", required = false) String engineCCStr,
                             @RequestParam(value = "hasFairing", required = false) String hasFairingStr,
                             HttpSession session) {
        if ("create".equals(action)) {
            try {
                User owner = (User) session.getAttribute("authUser");
                int year = Integer.parseInt(yearStr);
                int mileage = Integer.parseInt(mileageStr);
                String vehicleId = dao.generateVehicleId();
                Vehicle vehicle;

                int doors = doorsStr != null && !doorsStr.isEmpty() ? Integer.parseInt(doorsStr) : 4;
                vehicle = new Car(vehicleId, owner.getUserId(), make, modelName, year,
                        licensePlate, mileage, fuelType, doors, transmission);

                dao.save(vehicle);
                return "redirect:/dashboard?success=true";
            } catch (Exception e) {
                return "redirect:/vehicle?action=add&error=true";
            }
        }
        return "redirect:/dashboard";
    }
}

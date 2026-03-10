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
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
public class ServiceRecordServlet {
    private ServiceRecordDAO recordDao = new ServiceRecordDAO();
    private VehicleDAO vehicleDao = new VehicleDAO();
    private ServicePackageDAO packageDao = new ServicePackageDAO();
    private ServiceCategoryDAO categoryDao = new ServiceCategoryDAO();
    private AppointmentDAO appointmentDao = new AppointmentDAO();

    @GetMapping("/service")
    public String handleGet(@RequestParam(value = "action", required = false) String action,
                            @RequestParam(value = "id", required = false) String id,
                            HttpSession session, Model model) {
        if (session == null || session.getAttribute("authUser") == null) {
            return "redirect:/user";
        }

        User authUser = (User) session.getAttribute("authUser");

        if ("add".equals(action)) {
            if ("AdminUser".equals(authUser.getUserRole())) {
                model.addAttribute("myVehicles", vehicleDao.findAll());
                return "add_service";
            }
            return "redirect:/service";
        } else if ("delete".equals(action)) {
            if ("AdminUser".equals(authUser.getUserRole())) {
                recordDao.delete(id);
                return "redirect:/service?success=true";
            }
            return "redirect:/service";
        } else if ("deletePackage".equals(action)) {
            if ("AdminUser".equals(authUser.getUserRole())) {
                packageDao.delete(id);
                return "redirect:/service?success=true";
            }
            return "redirect:/service";
        } else if ("editPackage".equals(action)) {
            if ("AdminUser".equals(authUser.getUserRole())) {
                ServicePackage pkg = packageDao.findById(id);
                if (pkg != null) {
                    model.addAttribute("editPackage", pkg);
                    List<ServiceCategory> allCategories = categoryDao.findAll();
                    model.addAttribute("allCategories", allCategories);
                    return "edit_package";
                }
            }
            return "redirect:/service";
        } else {
            List<ServiceRecord> allMyRecords = new ArrayList<>();
            List<Appointment> completedAppointments = new ArrayList<>();

            if ("AdminUser".equals(authUser.getUserRole())) {
                allMyRecords = recordDao.findAll();
            } else {
                List<Vehicle> myVehicles = vehicleDao.findByOwnerId(authUser.getUserId());
                for (Vehicle v : myVehicles) {
                    allMyRecords.addAll(recordDao.findByVehicleId(v.getVehicleId()));
                }
                completedAppointments = appointmentDao.findCompletedByUserId(authUser.getUserId());
            }
            model.addAttribute("serviceRecords", allMyRecords);
            model.addAttribute("completedAppointments", completedAppointments);

            List<ServiceCategory> allCategories = categoryDao.findAll();
            model.addAttribute("allCategories", allCategories);

            List<ServicePackage> allPackages = packageDao.findAll();
            Map<String, List<ServicePackage>> packagesByCategory = allPackages.stream()
                .collect(Collectors.groupingBy(ServicePackage::getCategory));
            model.addAttribute("packagesByCategory", packagesByCategory);
            
            return "services";
        }
    }

    @PostMapping("/service")
    public String handlePost(@RequestParam("action") String action,
                             @RequestParam(value = "vehicleId", required = false) String vehicleId,
                             @RequestParam(value = "serviceDate", required = false) String serviceDateStr,
                             @RequestParam(value = "mileage", required = false) String mileageStr,
                             @RequestParam(value = "cost", required = false) String costStr,
                             @RequestParam(value = "serviceCenterId", required = false) String serviceCenterId,
                             @RequestParam(value = "notes", required = false) String notes,
                             @RequestParam(value = "recordType", required = false) String recordType,
                             @RequestParam(value = "serviceCategory", required = false) String serviceCategory,
                             @RequestParam(value = "partsReplaced", required = false) String partsReplaced,
                             @RequestParam(value = "problemDescription", required = false) String problemDescription,
                             @RequestParam(value = "diagnosis", required = false) String diagnosis,
                             @RequestParam(value = "underWarranty", required = false) String underWarrantyStr,
                             @RequestParam(value = "name", required = false) String name,
                             @RequestParam(value = "category", required = false) String category,
                             @RequestParam(value = "packageDescription", required = false) String packageDescription,
                             @RequestParam(value = "packagePrice", required = false) String packagePrice,
                             @RequestParam(value = "packageId", required = false) String packageId) {
        if ("create".equals(action)) {
            try {
                LocalDate serviceDate = LocalDate.parse(serviceDateStr);
                int mileage = Integer.parseInt(mileageStr);
                double cost = Double.parseDouble(costStr);
                String recordId = recordDao.generateRecordId();
                ServiceRecord record;

                if ("Routine".equals(recordType)) {
                    List<String> parts = new ArrayList<>();
                    if (partsReplaced != null && !partsReplaced.trim().isEmpty()) {
                        parts = Arrays.asList(partsReplaced.split(","));
                    }
                    record = new RoutineService(recordId, vehicleId, serviceDate, mileage, cost, serviceCenterId, notes, serviceCategory, parts);
                } else {
                    boolean underWarranty = Boolean.parseBoolean(underWarrantyStr);
                    record = new RepairService(recordId, vehicleId, serviceDate, mileage, cost, serviceCenterId, notes, problemDescription, diagnosis, underWarranty);
                }

                recordDao.save(record);
                return "redirect:/service?success=true";
            } catch (Exception e) {
                return "redirect:/service?action=add&error=true";
            }
        } else if ("createPackage".equals(action)) {
            try {
                if (name != null && category != null) {
                    packageDao.save(new ServicePackage(packageDao.generateId(), category, name, packageDescription, packagePrice));
                }
                return "redirect:/service?success=true";
            } catch (Exception e) {
                return "redirect:/service?error=true";
            }
        } else if ("updatePackage".equals(action)) {
            try {
                if (packageId != null && name != null && category != null) {
                    ServicePackage pkg = new ServicePackage(packageId, category, name, packageDescription, packagePrice);
                    packageDao.update(pkg);
                }
                return "redirect:/service?success=true";
            } catch (Exception e) {
                return "redirect:/service?error=true";
            }
        }
        return "redirect:/service";
    }
}

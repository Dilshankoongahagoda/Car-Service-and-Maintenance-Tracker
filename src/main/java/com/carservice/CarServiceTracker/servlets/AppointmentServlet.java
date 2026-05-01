package com.carservice.CarServiceTracker.servlets;

import com.carservice.CarServiceTracker.models.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
public class AppointmentServlet {
    private AppointmentDAO appointmentDao = new AppointmentDAO();
    private VehicleDAO vehicleDao = new VehicleDAO();
    private ServicePackageDAO packageDao = new ServicePackageDAO();
    private ServiceCategoryDAO categoryDao = new ServiceCategoryDAO();

    @GetMapping("/appointment")
    public String handleGet(@RequestParam(value = "action", required = false) String action,
                            @RequestParam(value = "id", required = false) String id,
                            HttpSession session, Model model) {
        if (session == null || session.getAttribute("authUser") == null) {
            return "redirect:/user";
        }

        User authUser = (User) session.getAttribute("authUser");

        if ("book".equals(action)) {
            // Show booking form
            List<Vehicle> myVehicles = vehicleDao.findByOwnerId(authUser.getUserId());
            model.addAttribute("myVehicles", myVehicles);

            List<ServicePackage> allPackages = packageDao.findAll();
            model.addAttribute("allPackages", allPackages);

            List<ServiceCategory> allCategories = categoryDao.findAll();
            model.addAttribute("allCategories", allCategories);

            Map<String, List<ServicePackage>> packagesByCategory = allPackages.stream()
                .collect(Collectors.groupingBy(ServicePackage::getCategory));
            model.addAttribute("packagesByCategory", packagesByCategory);

            return "book_appointment";
        } else if ("cancel".equals(action)) {
            Appointment appt = appointmentDao.findById(id);
            if (appt != null && appt.getUserId().equals(authUser.getUserId())) {
                appointmentDao.updateStatus(id, "CANCELLED");
            }
            return "redirect:/appointment";
        } else if ("confirm".equals(action)) {
            if (authUser instanceof AdminUser) {
                appointmentDao.updateStatus(id, "CONFIRMED");
            }
            return "redirect:/appointment";
        } else if ("complete".equals(action)) {
            if (authUser instanceof AdminUser) {
                appointmentDao.updateStatus(id, "COMPLETED");
            }
            return "redirect:/appointment";
        } else if ("delete".equals(action)) {
            if (authUser instanceof AdminUser) {
                appointmentDao.delete(id);
            }
            return "redirect:/appointment";
        } else if ("completed".equals(action)) {
            if (authUser instanceof AdminUser) {
                List<Appointment> completedAppointments = appointmentDao.findByStatus("COMPLETED");
                model.addAttribute("completedAppointments", completedAppointments);
                // Calculate unique vehicles and users
                java.util.Set<String> vehicleSet = new java.util.HashSet<>();
                java.util.Set<String> userSet = new java.util.HashSet<>();
                for (Appointment a : completedAppointments) {
                    vehicleSet.add(a.getVehicleId());
                    userSet.add(a.getUserId());
                }
                model.addAttribute("uniqueVehicles", vehicleSet.size());
                model.addAttribute("uniqueUsers", userSet.size());
                return "completed_services";
            }
            return "redirect:/appointment";
        } else {
            // Show list of appointments
            if (authUser instanceof AdminUser) {
                List<Appointment> all = appointmentDao.findAll();
                // Sort by preferredDate descending (newest first)
                all.sort((a1, a2) -> {
                    int dateCmp = safeCompare(a2.getPreferredDate(), a1.getPreferredDate());
                    if (dateCmp != 0) return dateCmp;
                    return safeCompare(a1.getPreferredTime(), a2.getPreferredTime());
                });
                
                List<Appointment> pending = new java.util.ArrayList<>();
                List<Appointment> confirmed = new java.util.ArrayList<>();
                List<Appointment> completed = new java.util.ArrayList<>();
                
                for (Appointment a : all) {
                    if ("PENDING".equals(a.getStatus())) pending.add(a);
                    else if ("CONFIRMED".equals(a.getStatus())) confirmed.add(a);
                    else if ("COMPLETED".equals(a.getStatus())) completed.add(a);
                }
                
                model.addAttribute("pendingAppointments", pending);
                model.addAttribute("confirmedAppointments", confirmed);
                model.addAttribute("completedAppointments", completed);
                model.addAttribute("appointments", all);
                model.addAttribute("isAdmin", true);
            } else {
                List<Appointment> userAppts = appointmentDao.findByUserId(authUser.getUserId());
                // Sort newest first
                userAppts.sort((a1, a2) -> {
                    int dateCmp = safeCompare(a2.getPreferredDate(), a1.getPreferredDate());
                    if (dateCmp != 0) return dateCmp;
                    return safeCompare(a1.getPreferredTime(), a2.getPreferredTime());
                });

                List<Appointment> pending = new java.util.ArrayList<>();
                List<Appointment> confirmed = new java.util.ArrayList<>();
                List<Appointment> completed = new java.util.ArrayList<>();

                for (Appointment a : userAppts) {
                    if ("PENDING".equals(a.getStatus())) pending.add(a);
                    else if ("CONFIRMED".equals(a.getStatus())) confirmed.add(a);
                    else if ("COMPLETED".equals(a.getStatus())) completed.add(a);
                }

                model.addAttribute("pendingAppointments", pending);
                model.addAttribute("confirmedAppointments", confirmed);
                model.addAttribute("completedAppointments", completed);
                model.addAttribute("appointments", userAppts);
                model.addAttribute("isAdmin", false);
            }
            return "appointments";
        }
    }

    @PostMapping("/appointment")
    public String handlePost(@RequestParam("action") String action,
                             @RequestParam(value = "vehicleId", required = false) String vehicleId,
                             @RequestParam(value = "selectedServices", required = false) String selectedServices,
                             @RequestParam(value = "selectedCategories", required = false) String selectedCategories,
                             @RequestParam(value = "totalPrice", required = false) String totalPrice,
                             @RequestParam(value = "preferredDate", required = false) String preferredDate,
                             @RequestParam(value = "preferredTime", required = false) String preferredTime,
                             @RequestParam(value = "notes", required = false) String notes,
                             HttpSession session) {
        if (session == null || session.getAttribute("authUser") == null) {
            return "redirect:/user";
        }

        User authUser = (User) session.getAttribute("authUser");

        if ("create".equals(action)) {
            String vehicleInfo = "";
            List<Vehicle> allVehicles = vehicleDao.findByOwnerId(authUser.getUserId());
            for (Vehicle v : allVehicles) {
                if (v.getVehicleId().equals(vehicleId)) {
                    vehicleInfo = v.getMake() + " " + v.getModel() + " (" + v.getLicensePlate() + ")";
                    break;
                }
            }

            Appointment appointment = new Appointment(
                appointmentDao.generateId(),
                authUser.getUserId(),
                authUser.getFullName(),
                vehicleId,
                vehicleInfo,
                selectedCategories != null ? selectedCategories : "",
                selectedServices != null ? selectedServices : "",
                totalPrice != null ? totalPrice : "",
                preferredDate != null ? preferredDate : "",
                preferredTime != null ? preferredTime : "",
                notes != null ? notes : "",
                "PENDING"
            );

            appointmentDao.save(appointment);
            return "redirect:/appointment?success=true";
        }
        return "redirect:/appointment";
    }

    private int safeCompare(String a, String b) {
        if (a == null && b == null) return 0;
        if (a == null) return -1;
        if (b == null) return 1;
        return a.compareTo(b);
    }
}

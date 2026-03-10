package com.carservice.CarServiceTracker.servlets;

import com.carservice.CarServiceTracker.models.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;
import java.util.stream.Collectors;

@Controller
public class DashboardServlet {
    private VehicleDAO vehicleDAO = new VehicleDAO();
    private AppointmentDAO appointmentDAO = new AppointmentDAO();
    private ServiceRecordDAO serviceRecordDAO = new ServiceRecordDAO();
    private ServiceCategoryDAO serviceCategoryDAO = new ServiceCategoryDAO();
    private ServicePackageDAO servicePackageDAO = new ServicePackageDAO();
    private FuelLogDAO fuelLogDAO = new FuelLogDAO();
    private ReminderDAO reminderDAO = new ReminderDAO();

    @GetMapping("/dashboard")
    public String showDashboard(HttpSession session, Model model) {
        if (session == null || session.getAttribute("authUser") == null) {
            return "redirect:/user";
        }

        User authUser = (User) session.getAttribute("authUser");
        if (authUser instanceof AdminUser) {
            // --- Core Counts ---
            List<Vehicle> allVehicles = vehicleDAO.findAll();
            List<Appointment> allAppointments = appointmentDAO.findAll();
            List<ServiceRecord> allRecords = serviceRecordDAO.findAll();

            model.addAttribute("totalVehicles", allVehicles.size());
            model.addAttribute("totalAppointments", allAppointments.size());
            model.addAttribute("totalServiceRecords", allRecords.size());
            model.addAttribute("totalCategories", serviceCategoryDAO.findAll().size());
            model.addAttribute("totalPackages", servicePackageDAO.findAll().size());
            model.addAttribute("totalFuelLogs", fuelLogDAO.findAll().size());
            model.addAttribute("totalReminders", reminderDAO.findAll().size());

            // --- Appointment Status Breakdown ---
            long pending = allAppointments.stream().filter(a -> "PENDING".equals(a.getStatus())).count();
            long confirmed = allAppointments.stream().filter(a -> "CONFIRMED".equals(a.getStatus())).count();
            long completed = allAppointments.stream().filter(a -> "COMPLETED".equals(a.getStatus())).count();
            long cancelled = allAppointments.stream().filter(a -> "CANCELLED".equals(a.getStatus())).count();
            model.addAttribute("pendingAppointments", pending);
            model.addAttribute("confirmedAppointments", confirmed);
            model.addAttribute("completedAppointments", completed);
            model.addAttribute("cancelledAppointments", cancelled);

            // --- Completion Rate ---
            int completionRate = allAppointments.size() > 0 ? (int)((completed * 100) / allAppointments.size()) : 0;
            model.addAttribute("completionRate", completionRate);

            // --- Recent Appointments (last 5) ---
            List<Appointment> recentAppointments = allAppointments.stream()
                .sorted((a, b) -> b.getAppointmentId().compareTo(a.getAppointmentId()))
                .limit(5)
                .collect(Collectors.toList());
            model.addAttribute("recentAppointments", recentAppointments);

            // --- Vehicle Type Breakdown ---
            long totalCars = allVehicles.stream().filter(v -> "Car".equals(v.getVehicleType())).count();
            long totalMotorcycles = allVehicles.stream().filter(v -> "Motorcycle".equals(v.getVehicleType())).count();
            model.addAttribute("totalCars", totalCars);
            model.addAttribute("totalMotorcycles", totalMotorcycles);

            return "admin_dashboard";
        } else {
            model.addAttribute("myVehicles", vehicleDAO.findByOwnerId(authUser.getUserId()));
            return "dashboard";
        }
    }

    @GetMapping("/all_vehicles")
    public String showAllVehicles(HttpSession session, Model model) {
        if (session == null || session.getAttribute("authUser") == null) {
            return "redirect:/user";
        }

        User authUser = (User) session.getAttribute("authUser");
        if (authUser instanceof AdminUser) {
            model.addAttribute("allVehiclesList", vehicleDAO.findAll());
            return "all_vehicles";
        } else {
            return "redirect:/dashboard";
        }
    }
}

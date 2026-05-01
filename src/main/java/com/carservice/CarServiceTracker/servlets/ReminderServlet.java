package com.carservice.CarServiceTracker.servlets;

import com.carservice.CarServiceTracker.models.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.*;

@Controller
public class ReminderServlet {
    private VehicleDAO vehicleDao = new VehicleDAO();
    private AppointmentDAO appointmentDao = new AppointmentDAO();

    /**
     * Service-specific repeat intervals in months.
     * Services NOT in this map are one-off (no reminder).
     */
    private static final Map<String, Integer> SERVICE_INTERVALS = new LinkedHashMap<>();
    static {
        // Periodic Maintenance
        SERVICE_INTERVALS.put("Basic Lube Service", 6);
        SERVICE_INTERVALS.put("Full Service (Labor)", 12);
        SERVICE_INTERVALS.put("Radiator Coolant Flush", 12);

        // Mechanical & Engine
        SERVICE_INTERVALS.put("Engine Tune-up", 12);
        SERVICE_INTERVALS.put("Fuel Injector Cleaning (Set of 4)", 18);
        SERVICE_INTERVALS.put("Timing Belt Replacement", 36);

        // Brakes & Suspension
        SERVICE_INTERVALS.put("Brake Pad Replacement", 12);
        SERVICE_INTERVALS.put("Brake Disc Resurfacing", 18);
        SERVICE_INTERVALS.put("Shock Absorber Replacement", 24);
        SERVICE_INTERVALS.put("Wheel Alignment", 6);
        SERVICE_INTERVALS.put("Wheel Balancing (Per Wheel)", 6);

        // Electrical & Hybrid
        SERVICE_INTERVALS.put("Full System Scanning (OBDII)", 12);
        SERVICE_INTERVALS.put("AC Full Service", 12);
        SERVICE_INTERVALS.put("Hybrid Battery Service", 12);
        SERVICE_INTERVALS.put("Battery Replacement (Labor)", 24);

        // Detailing & Car Care
        SERVICE_INTERVALS.put("Full Detail Wash", 3);
        SERVICE_INTERVALS.put("Interior Grooming (Steam Clean)", 6);
        SERVICE_INTERVALS.put("Engine Degreasing", 12);
        SERVICE_INTERVALS.put("Cut & Polish", 6);
        SERVICE_INTERVALS.put("Ceramic Coating (9H)", 18);

        // NOTE: The following are ONE-OFF services — no reminders:
        // Denting / Tinkering, Chassis Straightening, Plastic/Bumper Repair,
        // Windscreen Replacement, Single/Full Body Paint, Scratch Touch-ups,
        // Insurance Reports, Damage Documentation, Claim Coordination
    }

    @GetMapping("/reminder")
    public String handleGet(@RequestParam(value = "action", required = false) String action,
                            HttpSession session, Model model) {
        if (session == null || session.getAttribute("authUser") == null) {
            return "redirect:/user";
        }

        User authUser = (User) session.getAttribute("authUser");
        List<Vehicle> myVehicles = vehicleDao.findByOwnerId(authUser.getUserId());

        // Fetch all COMPLETED appointments for this user
        List<Appointment> allAppointments = appointmentDao.findByUserId(authUser.getUserId());
        List<ServiceReminder> reminders = new ArrayList<>();

        for (Appointment appt : allAppointments) {
            if (!"COMPLETED".equals(appt.getStatus())) continue;
            if (appt.getPreferredDate() == null || appt.getPreferredDate().isEmpty()) continue;

            // Parse completed date
            LocalDate completedDate;
            try {
                completedDate = LocalDate.parse(appt.getPreferredDate().trim());
            } catch (Exception e) {
                continue; // Skip if date is invalid
            }

            // Split individual services from comma-separated serviceName
            String[] services = appt.getServiceName().split(",");
            for (String svcRaw : services) {
                String svc = svcRaw.trim();
                if (svc.isEmpty()) continue;

                // Look up interval — skip one-off services
                Integer intervalMonths = findInterval(svc);
                if (intervalMonths == null) continue;

                // Calculate next due date
                LocalDate nextDue = completedDate.plusMonths(intervalMonths);
                long daysRemaining = ChronoUnit.DAYS.between(LocalDate.now(), nextDue);

                // Determine status
                String status;
                if (daysRemaining < 0) {
                    status = "OVERDUE";
                } else if (daysRemaining <= 30) {
                    status = "DUE_SOON";
                } else {
                    status = "ON_TRACK";
                }

                ServiceReminder reminder = new ServiceReminder(
                    svc,
                    appt.getVehicleInfo(),
                    completedDate.toString(),
                    nextDue.toString(),
                    daysRemaining,
                    status,
                    intervalMonths,
                    appt.getAppointmentId()
                );
                reminders.add(reminder);
            }
        }

        // Sort: OVERDUE first, then DUE_SOON, then ON_TRACK (by days remaining asc)
        reminders.sort((a, b) -> Long.compare(a.getDaysRemaining(), b.getDaysRemaining()));

        model.addAttribute("serviceReminders", reminders);
        model.addAttribute("vehicles", myVehicles);
        return "reminders";
    }

    /**
     * Finds the interval for a service name using fuzzy matching.
     * Returns null if the service is one-off (no reminder needed).
     */
    private Integer findInterval(String serviceName) {
        // Exact match first
        if (SERVICE_INTERVALS.containsKey(serviceName)) {
            return SERVICE_INTERVALS.get(serviceName);
        }

        // Fuzzy/partial match — the appointment might store slightly different names
        String lower = serviceName.toLowerCase().trim();
        for (Map.Entry<String, Integer> entry : SERVICE_INTERVALS.entrySet()) {
            String key = entry.getKey().toLowerCase();
            if (lower.contains(key) || key.contains(lower)) {
                return entry.getValue();
            }
        }

        return null; // One-off service, no reminder
    }
}

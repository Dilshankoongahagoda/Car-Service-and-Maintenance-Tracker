package com.carservice.CarServiceTracker.servlets;

import com.carservice.CarServiceTracker.models.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.*;
import java.util.stream.Collectors;

@Controller
public class DashboardServlet {
    private VehicleDAO vehicleDAO = new VehicleDAO();
    private AppointmentDAO appointmentDAO = new AppointmentDAO();
    private ServiceRecordDAO serviceRecordDAO = new ServiceRecordDAO();
    private ServiceCategoryDAO serviceCategoryDAO = new ServiceCategoryDAO();
    private ServicePackageDAO servicePackageDAO = new ServicePackageDAO();
    private EstimateDAO estimateDAO = new EstimateDAO();
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
            model.addAttribute("totalEstimates", estimateDAO.findAll().size());
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

            long totalCars = allVehicles.stream().filter(v -> "Car".equals(v.getVehicleType())).count();
            model.addAttribute("totalCars", totalCars);

            // =============================================
            // INVOICE / ESTIMATE ANALYTICS
            // =============================================
            List<Estimate> allEstimates = estimateDAO.findAll();

            double totalRevenue = 0;
            double paidRevenue = 0;
            double outstandingRevenue = 0;
            double totalTaxCollected = 0;
            double totalServiceCharges = 0;
            double totalPartsRevenue = 0;
            int paidCount = 0;
            int invoicedCount = 0;

            // Service revenue map: serviceName -> total revenue
            Map<String, Double> serviceRevenueMap = new LinkedHashMap<>();

            for (Estimate est : allEstimates) {
                double total = parseDouble(est.getTotal());
                double tax = parseDouble(est.getTax());
                double serviceCharge = parseDouble(est.getServiceCharge());

                totalRevenue += total;
                totalTaxCollected += tax;
                totalServiceCharges += serviceCharge;

                if ("PAID".equalsIgnoreCase(est.getStatus())) {
                    paidRevenue += total;
                    paidCount++;
                } else {
                    outstandingRevenue += total;
                    invoicedCount++;
                }

                // Parts revenue
                if (est.getPartPrices() != null && !est.getPartPrices().trim().isEmpty()) {
                    for (String pp : est.getPartPrices().split(",")) {
                        totalPartsRevenue += parseDouble(pp.trim());
                    }
                }

                // Service revenue breakdown (original services)
                if (est.getServiceItems() != null && est.getServicePrices() != null
                        && !est.getServiceItems().trim().isEmpty()) {
                    String[] svcNames = est.getServiceItems().split(",");
                    String[] svcPrices = est.getServicePrices().split(",");
                    for (int i = 0; i < svcNames.length; i++) {
                        String svcName = svcNames[i].trim();
                        double svcPrice = i < svcPrices.length ? parseDouble(svcPrices[i].trim()) : 0;
                        serviceRevenueMap.merge(svcName, svcPrice, Double::sum);
                    }
                }

                // Additional services
                if (est.getAdditionalServices() != null && est.getAdditionalPrices() != null
                        && !est.getAdditionalServices().trim().isEmpty()) {
                    String[] addNames = est.getAdditionalServices().split(",");
                    String[] addPrices = est.getAdditionalPrices().split(",");
                    for (int i = 0; i < addNames.length; i++) {
                        String svcName = addNames[i].trim();
                        double svcPrice = i < addPrices.length ? parseDouble(addPrices[i].trim()) : 0;
                        serviceRevenueMap.merge(svcName, svcPrice, Double::sum);
                    }
                }
            }

            double avgInvoice = allEstimates.size() > 0 ? totalRevenue / allEstimates.size() : 0;

            // Top 5 services by revenue
            List<Map.Entry<String, Double>> topServices = serviceRevenueMap.entrySet().stream()
                .sorted((a, b) -> Double.compare(b.getValue(), a.getValue()))
                .limit(5)
                .collect(Collectors.toList());

            // Build lists for JSP
            List<String> topServiceNames = new ArrayList<>();
            List<String> topServiceRevenues = new ArrayList<>();
            double maxServiceRevenue = topServices.isEmpty() ? 1 : topServices.get(0).getValue();
            for (Map.Entry<String, Double> entry : topServices) {
                topServiceNames.add(entry.getKey());
                topServiceRevenues.add(String.format("%.2f", entry.getValue()));
            }

            // Recent invoices (last 5)
            List<Estimate> recentInvoices = allEstimates.stream()
                .sorted((a, b) -> b.getEstimateId().compareTo(a.getEstimateId()))
                .limit(5)
                .collect(Collectors.toList());

            // Pass to model
            model.addAttribute("invTotalRevenue", String.format("%.2f", totalRevenue));
            model.addAttribute("invPaidRevenue", String.format("%.2f", paidRevenue));
            model.addAttribute("invOutstanding", String.format("%.2f", outstandingRevenue));
            model.addAttribute("invAvgInvoice", String.format("%.2f", avgInvoice));
            model.addAttribute("invTaxCollected", String.format("%.2f", totalTaxCollected));
            model.addAttribute("invServiceCharges", String.format("%.2f", totalServiceCharges));
            model.addAttribute("invPartsRevenue", String.format("%.2f", totalPartsRevenue));
            model.addAttribute("invPaidCount", paidCount);
            model.addAttribute("invInvoicedCount", invoicedCount);
            model.addAttribute("invTotalCount", allEstimates.size());
            model.addAttribute("invPaidPercent", allEstimates.size() > 0 ? (paidCount * 100) / allEstimates.size() : 0);
            model.addAttribute("topServiceNames", topServiceNames);
            model.addAttribute("topServiceRevenues", topServiceRevenues);
            model.addAttribute("invMaxServiceRevenue", String.format("%.2f", maxServiceRevenue));
            model.addAttribute("recentInvoices", recentInvoices);

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

    private double parseDouble(String val) {
        if (val == null || val.trim().isEmpty()) return 0;
        try {
            return Double.parseDouble(val.replaceAll("[^0-9.]", ""));
        } catch (NumberFormatException e) {
            return 0;
        }
    }
}

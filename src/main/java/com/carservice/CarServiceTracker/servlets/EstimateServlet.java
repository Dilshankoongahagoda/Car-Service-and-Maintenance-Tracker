package com.carservice.CarServiceTracker.servlets;

import com.carservice.CarServiceTracker.models.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
public class EstimateServlet {
    private EstimateDAO estimateDao = new EstimateDAO();
    private AppointmentDAO appointmentDao = new AppointmentDAO();
    private ServiceCategoryDAO categoryDao = new ServiceCategoryDAO();
    private ServicePackageDAO packageDao = new ServicePackageDAO();

    @GetMapping("/estimate")
    public String handleGet(@RequestParam(value = "action", required = false) String action,
                            @RequestParam(value = "id", required = false) String id,
                            @RequestParam(value = "appointmentId", required = false) String appointmentId,
                            HttpSession session, Model model) {
        if (session == null || session.getAttribute("authUser") == null) {
            return "redirect:/user";
        }

        User authUser = (User) session.getAttribute("authUser");
        boolean isAdmin = authUser instanceof AdminUser;
        model.addAttribute("isAdmin", isAdmin);

        if ("create".equals(action) && appointmentId != null) {
            // Admin only — show create invoice form pre-filled from appointment
            if (!isAdmin) return "redirect:/estimate";

            Appointment appt = appointmentDao.findById(appointmentId);
            if (appt == null || !"COMPLETED".equals(appt.getStatus())) {
                return "redirect:/appointment?action=completed";
            }

            // Check if invoice already exists for this appointment
            Estimate existing = estimateDao.findByAppointmentId(appointmentId);
            if (existing != null) {
                return "redirect:/estimate?action=view&id=" + existing.getEstimateId();
            }

            model.addAttribute("appointment", appt);

            // Load all services for additional service selection
            List<ServiceCategory> allCategories = categoryDao.findAll();
            model.addAttribute("allCategories", allCategories);

            List<ServicePackage> allPackages = packageDao.findAll();
            Map<String, List<ServicePackage>> packagesByCategory = allPackages.stream()
                .collect(Collectors.groupingBy(ServicePackage::getCategory));
            model.addAttribute("packagesByCategory", packagesByCategory);

            return "create_estimate";

        } else if ("view".equals(action) && id != null) {
            Estimate est = estimateDao.findById(id);
            if (est == null) return "redirect:/estimate";
            if (!isAdmin && !est.getUserId().equals(authUser.getUserId())) {
                return "redirect:/estimate";
            }
            model.addAttribute("estimate", est);
            return "estimate_detail";

        } else if ("edit".equals(action) && id != null) {
            if (!isAdmin) return "redirect:/estimate";
            Estimate est = estimateDao.findById(id);
            if (est == null) return "redirect:/estimate";
            model.addAttribute("estimate", est);

            // Load all services for additional service selection
            List<ServiceCategory> allCategories = categoryDao.findAll();
            model.addAttribute("allCategories", allCategories);
            List<ServicePackage> allPackages = packageDao.findAll();
            Map<String, List<ServicePackage>> packagesByCategory = allPackages.stream()
                .collect(Collectors.groupingBy(ServicePackage::getCategory));
            model.addAttribute("packagesByCategory", packagesByCategory);

            return "edit_estimate";

        } else if ("delete".equals(action) && id != null) {
            if (isAdmin) estimateDao.delete(id);
            return "redirect:/estimate";

        } else {
            // List invoices
            if (isAdmin) {
                model.addAttribute("estimates", estimateDao.findAll());
            } else {
                model.addAttribute("estimates", estimateDao.findByUserId(authUser.getUserId()));
            }
            return "estimates";
        }
    }

    @PostMapping("/estimate")
    public String handlePost(@RequestParam("action") String action,
                             @RequestParam(value = "appointmentId", required = false) String appointmentId,
                             @RequestParam(value = "estimateId", required = false) String estimateId,
                             @RequestParam(value = "serviceItems", required = false) String serviceItems,
                             @RequestParam(value = "servicePrices", required = false) String servicePrices,
                             @RequestParam(value = "additionalServices", required = false) String additionalServices,
                             @RequestParam(value = "additionalPrices", required = false) String additionalPrices,
                             @RequestParam(value = "parts", required = false) String parts,
                             @RequestParam(value = "partPrices", required = false) String partPrices,
                             @RequestParam(value = "serviceCharge", required = false) String serviceCharge,
                             @RequestParam(value = "subtotal", required = false) String subtotal,
                             @RequestParam(value = "tax", required = false) String tax,
                             @RequestParam(value = "total", required = false) String total,
                             @RequestParam(value = "notes", required = false) String notes,
                             HttpSession session) {
        if (session == null || session.getAttribute("authUser") == null) {
            return "redirect:/user";
        }

        User authUser = (User) session.getAttribute("authUser");
        if (!(authUser instanceof AdminUser)) {
            return "redirect:/estimate";
        }

        if ("create".equals(action) && appointmentId != null) {
            Appointment appt = appointmentDao.findById(appointmentId);
            if (appt == null) return "redirect:/estimate";

            // Check if invoice already exists
            Estimate existing = estimateDao.findByAppointmentId(appointmentId);
            if (existing != null) {
                return "redirect:/estimate?action=view&id=" + existing.getEstimateId();
            }

            Estimate estimate = new Estimate(
                estimateDao.generateId(),
                appointmentId,
                appt.getUserId(),
                appt.getUserName(),
                appt.getVehicleId(),
                appt.getVehicleInfo(),
                serviceItems != null ? serviceItems : "",
                servicePrices != null ? servicePrices : "",
                additionalServices != null ? additionalServices : "",
                additionalPrices != null ? additionalPrices : "",
                parts != null ? parts : "",
                partPrices != null ? partPrices : "",
                serviceCharge != null ? serviceCharge : "0",
                subtotal != null ? subtotal : "0",
                tax != null ? tax : "0",
                total != null ? total : "0",
                notes != null ? notes : "",
                "INVOICED",
                LocalDate.now().toString()
            );

            estimateDao.save(estimate);
            return "redirect:/estimate?action=view&id=" + estimate.getEstimateId();

        } else if ("update".equals(action)) {
            if (estimateId == null) return "redirect:/estimate";

            Estimate existing = estimateDao.findById(estimateId);
            if (existing == null) return "redirect:/estimate";

            existing.setServiceItems(serviceItems != null ? serviceItems : "");
            existing.setServicePrices(servicePrices != null ? servicePrices : "");
            existing.setAdditionalServices(additionalServices != null ? additionalServices : "");
            existing.setAdditionalPrices(additionalPrices != null ? additionalPrices : "");
            existing.setParts(parts != null ? parts : "");
            existing.setPartPrices(partPrices != null ? partPrices : "");
            existing.setServiceCharge(serviceCharge != null ? serviceCharge : "0");
            existing.setSubtotal(subtotal != null ? subtotal : "0");
            existing.setTax(tax != null ? tax : "0");
            existing.setTotal(total != null ? total : "0");
            existing.setNotes(notes != null ? notes : "");

            estimateDao.update(existing);
            return "redirect:/estimate?action=view&id=" + estimateId;
        }
        return "redirect:/estimate";
    }
}

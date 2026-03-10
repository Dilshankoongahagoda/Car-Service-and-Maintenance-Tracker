package com.carservice.CarServiceTracker.servlets;

import com.carservice.CarServiceTracker.models.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;
import java.util.stream.Collectors;

@Controller
public class ServiceDetailServlet {
    private ServiceCategoryDAO categoryDao = new ServiceCategoryDAO();
    private ServicePackageDAO packageDao = new ServicePackageDAO();

    @GetMapping("/service_detail")
    public String showDetail(@RequestParam("category") String categoryName,
                             HttpSession session, Model model) {
        if (session == null || session.getAttribute("authUser") == null) {
            return "redirect:/user";
        }

        ServiceCategory category = categoryDao.findByName(categoryName);
        if (category == null) {
            return "redirect:/service";
        }

        List<ServicePackage> packages = packageDao.findAll().stream()
            .filter(p -> p.getCategory().equalsIgnoreCase(categoryName))
            .collect(Collectors.toList());

        model.addAttribute("category", category);
        model.addAttribute("packages", packages);
        return "service_detail";
    }
}

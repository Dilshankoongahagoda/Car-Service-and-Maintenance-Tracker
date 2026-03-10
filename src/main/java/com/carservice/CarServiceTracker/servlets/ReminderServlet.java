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
public class ReminderServlet {
    private ReminderDAO reminderDao = new ReminderDAO();
    private VehicleDAO vehicleDao = new VehicleDAO();
    private AppointmentDAO appointmentDao = new AppointmentDAO();

    @GetMapping("/reminder")
    public String handleGet(@RequestParam(value = "action", required = false) String action,
                            @RequestParam(value = "id", required = false) String id,
                            @RequestParam(value = "status", required = false) String statusStr,
                            HttpSession session, Model model) {
        if (session == null || session.getAttribute("authUser") == null) {
            return "redirect:/user";
        }

        User authUser = (User) session.getAttribute("authUser");

        if ("add".equals(action)) {
            model.addAttribute("myVehicles", vehicleDao.findByOwnerId(authUser.getUserId()));
            return "add_reminder";
        } else if ("delete".equals(action)) {
            reminderDao.delete(id);
            return "redirect:/reminder?success=true";
        } else if ("toggle".equals(action)) {
            boolean status = Boolean.parseBoolean(statusStr);
            reminderDao.updateStatus(id, status);
            return "redirect:/reminder?success=true";
        } else {
            List<Reminder> allMyReminders = new ArrayList<>();
            List<Vehicle> myVehicles = vehicleDao.findByOwnerId(authUser.getUserId());

            for (Vehicle v : myVehicles) {
                allMyReminders.addAll(reminderDao.findByVehicleId(v.getVehicleId()));
            }

            model.addAttribute("vehicles", myVehicles);
            model.addAttribute("reminders", allMyReminders);

            // Also add user's appointments
            List<Appointment> myAppointments = appointmentDao.findByUserId(authUser.getUserId());
            model.addAttribute("myAppointments", myAppointments);

            return "reminders";
        }
    }

    @PostMapping("/reminder")
    public String handlePost(@RequestParam("action") String action,
                             @RequestParam(value = "vehicleId", required = false) String vehicleId,
                             @RequestParam(value = "title", required = false) String title,
                             @RequestParam(value = "description", required = false) String description,
                             @RequestParam(value = "reminderType", required = false) String type,
                             @RequestParam(value = "dueDate", required = false) String dueDateStr,
                             @RequestParam(value = "advanceNoticeDays", required = false) String advanceDaysStr,
                             @RequestParam(value = "dueMileage", required = false) String dueMileageStr,
                             @RequestParam(value = "advanceNoticeKm", required = false) String advanceKmStr) {
        if ("create".equals(action)) {
            try {
                LocalDate createdDate = LocalDate.now();
                String reminderId = reminderDao.generateReminderId();
                Reminder reminder;

                if ("Date".equals(type)) {
                    LocalDate dueDate = LocalDate.parse(dueDateStr);
                    int advanceDays = Integer.parseInt(advanceDaysStr);
                    reminder = new DateBasedReminder(reminderId, vehicleId, title, description, true, createdDate, dueDate, advanceDays);
                } else {
                    int dueMileage = Integer.parseInt(dueMileageStr);
                    int advanceKm = Integer.parseInt(advanceKmStr);
                    reminder = new MileageBasedReminder(reminderId, vehicleId, title, description, true, createdDate, dueMileage, advanceKm);
                }

                reminderDao.save(reminder);
                return "redirect:/reminder?success=true";
            } catch (Exception e) {
                return "redirect:/reminder?action=add&error=true";
            }
        }
        return "redirect:/reminder";
    }
}

package com.carservice.CarServiceTracker.servlets;

import com.carservice.CarServiceTracker.models.CarOwner;
import com.carservice.CarServiceTracker.models.User;
import com.carservice.CarServiceTracker.models.UserDAO;
import jakarta.servlet.http.HttpSession;
import org.springframework.http.*;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;

import java.util.List;
import java.util.Map;

@Controller
public class UserServlet {

    private static final String FIREBASE_API_KEY = "AIzaSyAUcqUXDX0CkADatn4Hf3LQRCSMNcsCk8o";
    private static final String FIREBASE_VERIFY_URL =
            "https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=" + FIREBASE_API_KEY;

    private final UserDAO userDAO = new UserDAO();
    private final RestTemplate restTemplate = new RestTemplate();

    @GetMapping("/user")
    public String showPage(@RequestParam(value = "action", required = false) String action,
                           HttpSession session) {
        if ("logout".equals(action)) {
            session.invalidate();
            return "redirect:/";
        }
        if ("register".equals(action)) {
            return "register";
        }
        return "login";
    }

    @PostMapping("/user")
    public String handlePost(@RequestParam("action") String action,
                             @RequestParam(value = "idToken",   required = false) String idToken,
                             @RequestParam(value = "username",  required = false) String username,
                             @RequestParam(value = "password",  required = false) String password,
                             @RequestParam(value = "email",     required = false) String email,
                             @RequestParam(value = "fullName",  required = false) String fullName,
                             @RequestParam(value = "phone",     required = false) String phone,
                             HttpSession session) {

        if ("login".equals(action)) {
            // Username + password → direct login (admin path)
            if (idToken == null || idToken.isEmpty()) {
                return handleDirectLogin(username, password, session);
            }
            // Firebase idToken → Firebase login (regular user path)
            return handleFirebaseLogin(idToken, session);

        } else if ("register".equals(action)) {
            return handleRegister(idToken, username, email, fullName, phone);
        }
        return "redirect:/user";
    }

    // ── Direct username + password login (for admins) ───────────────────────
    private String handleDirectLogin(String username, String password, HttpSession session) {
        if (username == null || username.isEmpty() || password == null || password.isEmpty()) {
            return "redirect:/user?error=true";
        }

        User user = userDAO.authenticateUser(username, password);
        if (user != null) {
            session.setAttribute("authUser", user);
            return "redirect:/dashboard";
        }
        return "redirect:/user?error=true";
    }

    // ── Firebase token login (for regular users) ─────────────────────────────
    private String handleFirebaseLogin(String idToken, HttpSession session) {
        String[] tokenData = verifyFirebaseToken(idToken);
        if (tokenData == null) {
            return "redirect:/user?error=true";
        }

        String uid   = tokenData[0];
        String email = tokenData[1];

        // Look up by Firebase UID first, then fall back to email
        User user = userDAO.getUserByFirebaseUid(uid);
        if (user == null && !email.isEmpty()) {
            user = userDAO.getUserByEmail(email);
            if (user != null) {
                user.setFirebaseUid(uid);
            }
        }

        // Valid Firebase account but no local record → auto-create CarOwner
        if (user == null && !email.isEmpty()) {
            String id       = userDAO.generateUserId();
            String uname    = email.split("@")[0];
            user = new CarOwner(id, uname, email, "", uname, "", uid);
            userDAO.saveUser(user);
        }

        if (user != null) {
            session.setAttribute("authUser", user);
            return "redirect:/dashboard";
        }
        return "redirect:/user?error=true";
    }

    // ── Verifies Firebase idToken via REST API → [uid, email] or null ────────
    @SuppressWarnings("unchecked")
    private String[] verifyFirebaseToken(String idToken) {
        try {
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            String body = "{\"idToken\":\"" + idToken + "\"}";
            HttpEntity<String> request = new HttpEntity<>(body, headers);

            ResponseEntity<Map> response = restTemplate.postForEntity(
                    FIREBASE_VERIFY_URL, request, Map.class);

            Map<String, Object> responseBody = response.getBody();
            if (responseBody != null && responseBody.containsKey("users")) {
                List<Map<String, Object>> users =
                        (List<Map<String, Object>>) responseBody.get("users");
                if (!users.isEmpty()) {
                    Map<String, Object> u = users.get(0);
                    String uid   = (String) u.get("localId");
                    String email = u.containsKey("email") ? (String) u.get("email") : "";
                    return new String[]{uid, email};
                }
            }
        } catch (Exception e) {
            System.err.println("Firebase token verification error: " + e.getMessage());
        }
        return null;
    }

    // ── Register new CarOwner via Firebase ──────────────────────────────────
    private String handleRegister(String idToken, String username, String email,
                                  String fullName, String phone) {
        if (idToken == null || idToken.isEmpty()) {
            return "redirect:/user?action=register&error=true";
        }

        String[] tokenData = verifyFirebaseToken(idToken);
        if (tokenData == null) {
            return "redirect:/user?action=register&error=true";
        }

        String uid = tokenData[0];

        // Prevent duplicate registration
        if (userDAO.getUserByFirebaseUid(uid) != null) {
            return "redirect:/user?success=true";
        }

        // Always register as CarOwner — admins are created manually
        String id = userDAO.generateUserId();
        CarOwner newUser = new CarOwner(id, username, email, "", fullName, phone, uid);
        userDAO.saveUser(newUser);

        return "redirect:/user?success=true";
    }
}

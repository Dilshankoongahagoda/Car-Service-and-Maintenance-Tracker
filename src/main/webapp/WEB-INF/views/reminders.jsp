<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reminders - AutoCare Tracker</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
</head>
<body>
<nav class="navbar-custom">
    <div class="navbar-inner">
        <a href="dashboard" class="nav-brand">
            <div style="display: flex; align-items: center; gap: 15px;">
    <img src="${pageContext.request.contextPath}/images/shift_logo.png" alt="Shift Auto Dynamics" style="height: 55px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.1);" />
    <div style="display: flex; flex-direction: column; justify-content: center; line-height: 1.2;">
        <span style="font-family: 'Oswald', sans-serif; font-size: 1.6rem; font-weight: 700; letter-spacing: 1px; color: var(--dark);">SHIFT AUTO <span style="color: var(--primary);">DYNAMICS</span></span>
        <span style="font-size: 0.65rem; font-weight: 600; color: var(--text-muted); letter-spacing: 1px; text-transform: uppercase;">Precision in Motion | Engineered for Excellence</span>
    </div>
</div>
        </a>
        <ul class="nav-links">
            <c:if test="${authUser.userRole == 'AdminUser'}">
                <li><a href="dashboard">ADMIN PORTAL</a></li>
                <li><a href="all_vehicles">REGISTERED VEHICLES</a></li>
                <li><a href="service">MANAGE SERVICES</a></li>
                <li><a href="appointment">APPOINTMENTS</a></li>
            </c:if>
            <c:if test="${authUser.userRole != 'AdminUser'}">
                <li><a href="dashboard">VEHICLES</a></li>
                <li><a href="service">SERVICES</a></li>
                <li><a href="appointment">APPOINTMENTS</a></li>
                <li><a href="reminder" class="active">REMINDERS</a></li>
                <li><a href="fuel">FUEL LOGS</a></li>
            </c:if>
        </ul>
        <div class="nav-right">
            <span class="nav-user">Welcome, <strong>${authUser.fullName}</strong></span>
            <a href="#" onclick="firebaseSignOut()" class="btn-primary-custom" style="padding: 10px 20px;">SIGN OUT &gt;</a>
        </div>
    </div>
</nav>

<div class="page-container">
    <div class="page-header">
        <h1>MAINTENANCE ALERTS</h1>
        <a href="reminder?action=add" class="btn-primary-custom">ADD REMINDER &gt;</a>
    </div>

    <div class="card-grid">
        <c:forEach var="r" items="${reminders}">
            <div class="card" style="border-top-color: ${!r.active ? '#2E7D32' : 'var(--primary)'}">
                <span class="card-badge ${!r.active ? 'success' : 'red'}">${r.active ? 'ACTIVE ALERT' : 'COMPLETED'}</span>
                <h3>${r.title}</h3>
                
                <div class="card-stat">
                    <span class="label">Vehicle</span>
                    <span class="val">${r.vehicleId}</span>
                </div>
                <div class="card-stat">
                    <span class="label">Type</span>
                    <span class="val">${r.reminderType}</span>
                </div>
                
                <p style="font-size:0.9rem; color:var(--dark-secondary); margin:15px 0;">${r.description}</p>
                
                <div class="card-actions" style="border-top:1px solid var(--border); padding-top:15px;">
                    <c:if test="${r.active}">
                        <a href="reminder?action=toggle&id=${r.reminderId}&status=false" class="btn-sm-success">âœ“ MARK DONE</a>
                    </c:if>
                    <c:if test="${!r.active}">
                        <a href="reminder?action=toggle&id=${r.reminderId}&status=true" class="btn-sm-secondary">â†º RENEW</a>
                    </c:if>
                    <a href="reminder?action=delete&id=${r.reminderId}" class="btn-sm-danger" onclick="return confirm('Delete reminder?')">DELETE</a>
                </div>
            </div>
        </c:forEach>
    </div>

    <c:if test="${empty reminders}">
        <div class="empty-state">
            <h3>NO ALERTS CONFIGURED</h3>
            <p style="color:var(--text-muted);">Set up reminders for regular maintenance tasks.</p>
        </div>
    </c:if>

    <!-- BOOKED APPOINTMENTS SECTION -->
    <c:if test="${not empty myAppointments}">
        <div class="page-header" style="margin-top: 40px; border-top: 3px solid var(--primary); padding-top: 20px;">
            <h1>BOOKED APPOINTMENTS</h1>
        </div>

        <div class="card-grid">
            <c:forEach var="a" items="${myAppointments}">
                <div class="card" style="border-top: 4px solid ${a.status == 'PENDING' ? '#ff9800' : a.status == 'CONFIRMED' ? 'var(--primary)' : a.status == 'COMPLETED' ? '#2E7D32' : '#ccc'};">
                    <span class="card-badge" style="background: ${a.status == 'PENDING' ? '#fff3e0' : a.status == 'CONFIRMED' ? '#e3f2fd' : a.status == 'COMPLETED' ? '#e8f5e9' : '#f5f5f5'}; color: ${a.status == 'PENDING' ? '#e65100' : a.status == 'CONFIRMED' ? '#1565c0' : a.status == 'COMPLETED' ? '#2e7d32' : '#999'};">${a.status}</span>
                    <h3>${a.serviceName}</h3>
                    <div class="card-stat">
                        <span class="label">Vehicle</span>
                        <span class="val">${a.vehicleInfo}</span>
                    </div>
                    <div class="card-stat">
                        <span class="label">Date</span>
                        <span class="val">${a.preferredDate}</span>
                    </div>
                    <div class="card-stat">
                        <span class="label">Time</span>
                        <span class="val">${a.preferredTime}</span>
                    </div>
                    <div class="card-stat">
                        <span class="label">Price</span>
                        <span class="val" style="color: var(--primary); font-weight: 700;">${a.servicePrice}</span>
                    </div>
                    <div class="card-actions" style="border-top:1px solid var(--border); padding-top:15px; margin-top: 10px;">
                        <a href="appointment" class="btn-sm-secondary" style="text-decoration: none;">VIEW ALL →</a>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:if>
</div>
<script type="module">
    import { initializeApp } from "https://www.gstatic.com/firebasejs/11.1.0/firebase-app.js";
    import { getAuth, signOut } from "https://www.gstatic.com/firebasejs/11.1.0/firebase-auth.js";
    const firebaseConfig = {
        apiKey: "AIzaSyAUcqUXDX0CkADatn4Hf3LQRCSMNcsCk8o",
        authDomain: "car-service-84e75.firebaseapp.com",
        projectId: "car-service-84e75"
    };
    const app = initializeApp(firebaseConfig);
    const auth = getAuth(app);
    window.firebaseSignOut = function() {
        signOut(auth).then(() => {
            window.location.href = 'user?action=logout';
        }).catch(() => {
            window.location.href = 'user?action=logout';
        });
    };
</script>
</body>
</html>


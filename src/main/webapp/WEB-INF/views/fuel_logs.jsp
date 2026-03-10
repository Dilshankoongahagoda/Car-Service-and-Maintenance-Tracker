<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fuel Logs - AutoCare Tracker</title>
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
                <li><a href="reminder">REMINDERS</a></li>
                <li><a href="fuel" class="active">FUEL LOGS</a></li>
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
        <h1>FUEL CONSUMPTION</h1>
        <a href="fuel?action=add" class="btn-primary-custom">LOG FILL-UP &gt;</a>
    </div>

    <div class="data-table-container">
        <table class="data-table">
            <thead>
                <tr>
                    <th>DATE</th>
                    <th>VEHICLE ID</th>
                    <th>FUEL INFO</th>
                    <th>VOLUME</th>
                    <th>TOTAL COST</th>
                    <th>ODOMETER</th>
                    <th>ACTION</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="f" items="${fuelLogs}">
                    <tr>
                        <td><strong>${f.fillDate}</strong></td>
                        <td>${f.vehicleId}</td>
                        <td><span class="card-badge" style="margin:0">${f.fuelTypeDisplay}</span></td>
                        <td>${f.liters} L</td>
                        <td style="color:var(--primary); font-weight:700;">LKR ${f.totalCost}</td>
                        <td>${f.odometerReading} km</td>
                        <td>
                            <a href="fuel?action=delete&id=${f.logId}" class="btn-sm-danger" onclick="return confirm('Delete this record?')">DELETE</a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty fuelLogs}">
                    <tr>
                        <td colspan="7">
                            <div class="empty-state">
                                <h3>NO LOGS FOUND</h3>
                                <p style="color:var(--text-muted);">Start recording your fuel stops to analyze efficiency.</p>
                            </div>
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
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


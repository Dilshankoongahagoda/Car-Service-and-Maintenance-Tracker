<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Vehicles - AutoCare Tracker</title>
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
            <li><a href="dashboard">ADMIN PORTAL</a></li>
            <li><a href="all_vehicles" class="active">REGISTERED VEHICLES</a></li>
            <li><a href="service">MANAGE SERVICES</a></li>
            <li><a href="appointment">APPOINTMENTS</a></li>
        </ul>
        <div class="nav-right">
            <span class="nav-user">Admin: <strong>${authUser.fullName}</strong></span>
            <a href="#" onclick="firebaseSignOut()" class="btn-primary-custom" style="padding: 10px 20px;">SIGN OUT &gt;</a>
        </div>
    </div>
</nav>

<div class="page-container">
    <div class="page-header" style="margin-top: 20px;">
        <h1>ALL REGISTERED VEHICLES</h1>
    </div>

    <div class="data-table-container">
        <table class="data-table">
            <thead>
                <tr>
                    <th>VEHICLE ID</th>
                    <th>OWNER ID</th>
                    <th>MAKE & MODEL</th>
                    <th>YEAR</th>
                    <th>LICENSE PLATE</th>
                    <th>TYPE</th>
                    <th>FUEL</th>
                    <th>MILEAGE</th>
                    <th>EXTRA SPECIFICS</th>
                    <th>ACTION</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="v" items="${allVehiclesList}">
                    <tr>
                        <td><strong>${v.vehicleId}</strong></td>
                        <td>${v.ownerId}</td>
                        <td>${v.make} ${v.model}</td>
                        <td>${v.year}</td>
                        <td><span class="card-badge" style="margin:0">${v.licensePlate}</span></td>
                        <td>${v.vehicleType}</td>
                        <td>${v.fuelType}</td>
                        <td>${v.currentMileage} km</td>
                        <td style="font-size:0.85rem">${v.specificData}</td>
                        <td>
                            <a href="vehicle?action=delete&id=${v.vehicleId}&redirect=all_vehicles" class="btn-sm-danger" onclick="return confirm('Delete this vehicle?')">DELETE</a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty allVehiclesList}">
                    <tr>
                        <td colspan="10">
                            <div class="empty-state">
                                <h3>NO VEHICLES REGISTERED</h3>
                                <p style="color:var(--text-muted);">Users have not registered any vehicles yet.</p>
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

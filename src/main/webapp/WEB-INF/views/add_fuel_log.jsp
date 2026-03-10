<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Fuel Log - AutoCare Tracker</title>
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

<div class="page-container" style="padding-top: 40px; padding-bottom: 80px;">
    <div class="form-card">
        <h2 style="font-size:2.2rem; margin-bottom: 25px;">LOG FUEL STOP <span style="color:var(--primary)">///</span></h2>
        <form action="fuel" method="post">
            <input type="hidden" name="action" value="create"/>
            
            <div class="form-row">
                <div class="form-group">
                    <label>SELECT VEHICLE</label>
                    <select name="vehicleId" class="form-select" required>
                        <c:forEach var="v" items="${myVehicles}">
                            <option value="${v.vehicleId}">${v.make} ${v.model} (${v.licensePlate})</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label>DATE OF FILL-UP</label>
                    <input type="date" name="fillDate" class="form-input" required/>
                </div>
            </div>
            
            <div class="form-row three-col">
                <div class="form-group">
                    <label>VOLUME (LITERS)</label>
                    <input type="number" step="0.01" name="liters" class="form-input" required/>
                </div>
                <div class="form-group">
                    <label>UNIT PRICE (LKR/L)</label>
                    <input type="number" step="0.01" name="costPerLiter" class="form-input" required/>
                </div>
                <div class="form-group">
                    <label>CURRENT ODOMETER</label>
                    <input type="number" name="odometer" class="form-input" required/>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label>TANK STATUS</label>
                    <select name="isFullTank" class="form-select">
                        <option value="true">Filled to capacity</option>
                        <option value="false">Partial fill</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>FUEL GRADE/TYPE</label>
                    <select name="fuelType" id="fuelType" class="form-select" onchange="toggleType()">
                        <option value="Petrol">Petrol / Gasoline</option>
                        <option value="Diesel">Diesel</option>
                    </select>
                </div>
            </div>
            
            <div id="petrolFields" class="form-group" style="background:var(--light); padding:20px; border-radius:var(--radius);">
                <label>OCTANE RATING</label>
                <select name="octaneRating" class="form-select">
                    <option value="92">92 Octane</option>
                    <option value="95">95 Octane (Premium)</option>
                    <option value="100">100 Octane (Racing)</option>
                </select>
            </div>
            
            <div id="dieselFields" class="form-group" style="display:none; background:var(--light); padding:20px; border-radius:var(--radius);">
                <label>ADBLUE TOP-UP INCLUDED?</label>
                <select name="isAdBlueRequired" class="form-select">
                    <option value="false">No</option>
                    <option value="true">Yes</option>
                </select>
            </div>
            
            <div style="display:flex; justify-content:space-between; margin-top:30px; border-top:1px solid var(--border); padding-top:20px;">
                <a href="fuel" class="btn-secondary-custom">CANCEL</a>
                <button type="submit" class="btn-submit">SAVE ENTRY &gt;</button>
            </div>
        </form>
    </div>
</div>

<script>
function toggleType() {
    var t = document.getElementById("fuelType").value;
    document.getElementById("petrolFields").style.display = t==="Petrol"?"block":"none";
    document.getElementById("dieselFields").style.display = t==="Diesel"?"block":"none";
}
</script>
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


<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Vehicle - Shift Auto Dynamics</title>
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
                <li><a href="dashboard" class="active">ADMIN PORTAL</a></li>
                <li><a href="all_vehicles">REGISTERED VEHICLES</a></li>
                <li><a href="service">MANAGE SERVICES</a></li>
                <li><a href="appointment">APPOINTMENTS</a></li>
            </c:if>
            <c:if test="${authUser.userRole != 'AdminUser'}">
                <li><a href="dashboard" class="active">VEHICLES</a></li>
                <li><a href="service">SERVICES</a></li>
                <li><a href="appointment">APPOINTMENTS</a></li>
                <li><a href="reminder">REMINDERS</a></li>
                <li><a href="fuel">FUEL LOGS</a></li>
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
        <h2 style="font-size:2.2rem; margin-bottom: 25px;">ADD NEW VEHICLE <span style="color:var(--primary)">///</span></h2>
        <form action="vehicle" method="post">
            <input type="hidden" name="action" value="create"/>
            
            <div class="form-row">
                <div class="form-group">
                    <label>MAKE / BRAND</label>
                    <input type="text" name="make" class="form-input" list="carBrands" placeholder="e.g. Toyota" required autocomplete="off"/>
                    <datalist id="carBrands">
                        <option value="Toyota">
                        <option value="Honda">
                        <option value="Nissan">
                        <option value="Suzuki">
                        <option value="Mitsubishi">
                        <option value="Mazda">
                        <option value="Subaru">
                        <option value="Daihatsu">
                        <option value="Lexus">
                        <option value="Kia">
                        <option value="Hyundai">
                        <option value="BMW">
                        <option value="Mercedes-Benz">
                        <option value="Audi">
                        <option value="Volkswagen">
                        <option value="Peugeot">
                        <option value="Land Rover">
                        <option value="Jaguar">
                        <option value="Porsche">
                        <option value="Volvo">
                        <option value="Ford">
                        <option value="Chevrolet">
                        <option value="Jeep">
                        <option value="MG">
                        <option value="Geely">
                        <option value="Micro">
                        <option value="Tata">
                        <option value="Mahindra">
                        <option value="Maruti Suzuki">
                        <option value="Bajaj">
                        <option value="TVS">
                        <option value="Yamaha">
                        <option value="KTM">
                        <option value="Royal Enfield">
                        <option value="Hero">
                    </datalist>
                </div>
                <div class="form-group">
                    <label>MODEL</label>
                    <input type="text" name="model" class="form-input" placeholder="e.g. Corolla" required/>
                </div>
            </div>
            
            <div class="form-row three-col">
                <div class="form-group">
                    <label>YEAR</label>
                    <select name="year" class="form-select" required>
                        <option value="" disabled selected>Select Year</option>
                        <% 
                           int currentYear = java.util.Calendar.getInstance().get(java.util.Calendar.YEAR);
                           for(int y = currentYear; y >= 1990; y--) { 
                        %>
                            <option value="<%= y %>"><%= y %></option>
                        <% } %>
                    </select>
                </div>
                <div class="form-group">
                    <label>LICENSE PLATE</label>
                    <input type="text" name="licensePlate" class="form-input" placeholder="ABC-1234" required/>
                </div>
                <div class="form-group">
                    <label>CURRENT MILEAGE (KM)</label>
                    <input type="number" name="mileage" class="form-input" placeholder="50000" required/>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label>FUEL TYPE</label>
                    <select name="fuelType" class="form-select">
                        <option value="Petrol">Petrol</option>
                        <option value="Diesel">Diesel</option>
                        <option value="Electric">Electric</option>
                        <option value="Hybrid">Hybrid</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>VEHICLE CATEGORY</label>
                    <select name="vehicleType" id="vehicleType" class="form-select" onchange="toggleFields()">
                        <option value="Car">Car</option>
                        <option value="Motorcycle">Motorcycle</option>
                    </select>
                </div>
            </div>
            
            <div id="carFields" class="form-row" style="background:var(--light); padding:20px; border-radius:var(--radius); margin-bottom:20px;">
                <div class="form-group" style="margin-bottom:0">
                    <label>DOORS</label>
                    <input type="number" name="doors" class="form-input" value="4"/>
                </div>
                <div class="form-group" style="margin-bottom:0">
                    <label>TRANSMISSION</label>
                    <select name="transmission" class="form-select">
                        <option value="Automatic">Automatic</option>
                        <option value="Manual">Manual</option>
                    </select>
                </div>
            </div>
            
            <div id="motoFields" class="form-row" style="display: none; background:var(--light); padding:20px; border-radius:var(--radius); margin-bottom:20px;">
                <div class="form-group" style="margin-bottom:0">
                    <label>ENGINE CC</label>
                    <input type="number" name="engineCC" class="form-input" value="150"/>
                </div>
                <div class="form-group" style="margin-bottom:0">
                    <label>FAIRING</label>
                    <select name="hasFairing" class="form-select">
                        <option value="true">Yes</option>
                        <option value="false">No</option>
                    </select>
                </div>
            </div>
            
            <div style="display:flex; justify-content:space-between; margin-top:30px; border-top:1px solid var(--border); padding-top:20px;">
                <a href="dashboard" class="btn-secondary-custom">CANCEL</a>
                <button type="submit" class="btn-submit">CONFIRM &amp; ADD &gt;</button>
            </div>
        </form>
    </div>
</div>

<script>
function toggleFields() {
    var t = document.getElementById("vehicleType").value;
    document.getElementById("carFields").style.display = t==="Car"?"grid":"none";
    document.getElementById("motoFields").style.display = t==="Motorcycle"?"grid":"none";
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


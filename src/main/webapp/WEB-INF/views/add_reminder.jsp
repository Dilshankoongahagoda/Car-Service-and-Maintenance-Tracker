<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Reminder - AutoCare Tracker</title>
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
                <li><a href="estimate">ESTIMATES</a></li>
            </c:if>
            <c:if test="${authUser.userRole != 'AdminUser'}">
                <li><a href="dashboard">VEHICLES</a></li>
                <li><a href="service">SERVICES</a></li>
                <li><a href="appointment">APPOINTMENTS</a></li>
                <li><a href="reminder" class="active">REMINDERS</a></li>
                <li><a href="estimate">ESTIMATES</a></li>
                <li><a href="profile">PROFILE</a></li>
            </c:if>
        </ul>
        <div class="nav-right">
            <span class="nav-user">Welcome, <strong>${authUser.fullName}</strong></span>
            <a href="#" onclick="firebaseSignOut()" class="btn-primary-custom" style="padding: 10px 20px;">SIGN OUT &gt;</a>
        </div>
        <button class="nav-hamburger" id="navHamburger" aria-label="Toggle navigation">
            <span></span>
            <span></span>
            <span></span>
        </button>
    </div>
</nav>

<div class="page-container" style="padding-top: 40px; padding-bottom: 80px;">
    <div class="form-card">
        <h2 style="font-size:2.2rem; margin-bottom: 25px;">SET ALERT <span style="color:var(--primary)">///</span></h2>
        <form action="reminder" method="post">
            <input type="hidden" name="action" value="create"/>
            
            <div class="form-group">
                <label>SELECT VEHICLE</label>
                <select name="vehicleId" class="form-select" required>
                    <c:forEach var="v" items="${myVehicles}">
                        <option value="${v.vehicleId}">${v.make} ${v.model} (${v.licensePlate})</option>
                    </c:forEach>
                </select>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label>ALERT TITLE</label>
                    <input type="text" name="title" class="form-input" placeholder="e.g. 50,000km Major Service" required/>
                </div>
                <div class="form-group">
                    <label>TRACKING METHOD</label>
                    <select name="reminderType" id="reminderType" class="form-select" onchange="toggleType()">
                        <option value="Date">By Date</option>
                        <option value="Mileage">By Odometer / Mileage</option>
                    </select>
                </div>
            </div>
            
            <div class="form-group">
                <label>DESCRIPTION &amp; DETAILS</label>
                <textarea name="description" class="form-input" rows="2" placeholder="What needs to be done?"></textarea>
            </div>
            
            <div id="dateFields" class="form-row" style="background:var(--light); padding:20px; border-left:4px solid var(--primary); margin-bottom:20px;">
                <div class="form-group" style="margin-bottom:0">
                    <label>TARGET DATE</label>
                    <input type="date" name="dueDate" class="form-input"/>
                </div>
                <div class="form-group" style="margin-bottom:0">
                    <label>NOTIFY BEFORE (DAYS)</label>
                    <input type="number" name="advanceNoticeDays" class="form-input" value="7"/>
                </div>
            </div>
            
            <div id="mileageFields" class="form-row" style="display: none; background:var(--light); padding:20px; border-left:4px solid var(--primary); margin-bottom:20px;">
                <div class="form-group" style="margin-bottom:0">
                    <label>TARGET ODOMETER (KM)</label>
                    <input type="number" name="dueMileage" class="form-input"/>
                </div>
                <div class="form-group" style="margin-bottom:0">
                    <label>NOTIFY BEFORE (KM)</label>
                    <input type="number" name="advanceNoticeKm" class="form-input" value="500"/>
                </div>
            </div>
            
            <div style="display:flex; justify-content:space-between; margin-top:30px; border-top:1px solid var(--border); padding-top:20px;">
                <a href="reminder" class="btn-secondary-custom">CANCEL</a>
                <button type="submit" class="btn-submit">SAVE ALERT &gt;</button>
            </div>
        </form>
    </div>
</div>

<script>
function toggleType() {
    var t = document.getElementById("reminderType").value;
    document.getElementById("dateFields").style.display = t==="Date"?"grid":"none";
    document.getElementById("mileageFields").style.display = t==="Mileage"?"grid":"none";
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
<script>
document.addEventListener('DOMContentLoaded', function() {
    var btn = document.getElementById('navHamburger');
    if (!btn) return;
    btn.addEventListener('click', function() {
        document.querySelector('.navbar-custom').classList.toggle('nav-open');
    });
    document.addEventListener('click', function(e) {
        if (!e.target.closest('.navbar-custom')) {
            var nav = document.querySelector('.navbar-custom');
            if (nav) nav.classList.remove('nav-open');
        }
    });
});
</script>
</body>
</html>


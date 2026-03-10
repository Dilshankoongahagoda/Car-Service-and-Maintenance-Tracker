<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointments - Shift Auto Dynamics</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
    <style>
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        .appt-card {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.06);
            border: 1px solid var(--border);
            border-left: 5px solid var(--primary);
            animation: fadeIn 0.5s ease forwards;
            opacity: 0;
            margin-bottom: 20px;
        }
        .appt-card:nth-child(1) { animation-delay: 0.1s; }
        .appt-card:nth-child(2) { animation-delay: 0.2s; }
        .appt-card:nth-child(3) { animation-delay: 0.3s; }
        .appt-card:nth-child(4) { animation-delay: 0.4s; }
        .appt-card.status-PENDING { border-left-color: #ff9800; }
        .appt-card.status-CONFIRMED { border-left-color: var(--primary); }
        .appt-card.status-COMPLETED { border-left-color: #2E7D32; }
        .appt-card.status-CANCELLED { border-left-color: #ccc; opacity: 0.7; }

        .appt-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; }
        .appt-header h3 { margin: 0; font-family: 'Oswald', sans-serif; font-size: 1.3rem; color: var(--dark); }
        .status-badge {
            padding: 5px 14px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .status-PENDING { background: #fff3e0; color: #e65100; }
        .status-CONFIRMED { background: #e3f2fd; color: #1565c0; }
        .status-COMPLETED { background: #e8f5e9; color: #2e7d32; }
        .status-CANCELLED { background: #f5f5f5; color: #999; }

        .appt-details { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-bottom: 15px; }
        .appt-detail { font-size: 0.9rem; }
        .appt-detail .label { color: var(--text-muted); font-size: 0.75rem; text-transform: uppercase; font-weight: 600; letter-spacing: 0.5px; }
        .appt-detail .value { color: var(--dark); font-weight: 500; }

        .appt-actions { display: flex; gap: 10px; border-top: 1px solid var(--border); padding-top: 15px; flex-wrap: wrap; }
        .appt-actions a {
            padding: 6px 16px;
            border-radius: 4px;
            font-size: 0.8rem;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s;
        }
        .btn-confirm { background: #e3f2fd; color: #1565c0; border: 1px solid #1565c0; }
        .btn-confirm:hover { background: #1565c0; color: white; }
        .btn-complete { background: #e8f5e9; color: #2e7d32; border: 1px solid #2e7d32; }
        .btn-complete:hover { background: #2e7d32; color: white; }
        .btn-cancel-appt { background: #fff3e0; color: #e65100; border: 1px solid #e65100; }
        .btn-cancel-appt:hover { background: #e65100; color: white; }
    </style>
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
            <c:if test="${isAdmin}">
                <li><a href="dashboard">ADMIN PORTAL</a></li>
                <li><a href="all_vehicles">REGISTERED VEHICLES</a></li>
                <li><a href="service">MANAGE SERVICES</a></li>
                <li><a href="appointment" class="active">APPOINTMENTS</a></li>
            </c:if>
            <c:if test="${!isAdmin}">
                <li><a href="dashboard">VEHICLES</a></li>
                <li><a href="service">SERVICES</a></li>
                <li><a href="appointment" class="active">APPOINTMENTS</a></li>
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

<div class="page-container">
    <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; border-bottom: 3px solid var(--primary); padding-bottom: 15px; margin-bottom: 30px;">
        <h1 style="font-family: 'Oswald', sans-serif; font-size: 2.5rem; color: var(--dark);">
            <c:if test="${isAdmin}">ALL APPOINTMENTS</c:if>
            <c:if test="${!isAdmin}">MY APPOINTMENTS</c:if>
        </h1>
        <div style="display: flex; gap: 12px;">
            <c:if test="${isAdmin}">
                <a href="appointment?action=completed" style="padding: 12px 25px; font-size: 0.9rem; text-decoration: none; border-radius: 4px; font-weight: bold; background: #2E7D32; color: white; letter-spacing: 1px;">✓ COMPLETED SERVICES</a>
            </c:if>
            <c:if test="${!isAdmin}">
                <a href="appointment?action=book" class="btn-primary-custom" style="padding: 12px 25px; font-size: 1rem; text-decoration: none; border-radius: 4px; font-weight: bold;">BOOK APPOINTMENT &gt;</a>
            </c:if>
        </div>
    </div>

    <c:forEach var="a" items="${appointments}">
        <div class="appt-card status-${a.status}">
            <div class="appt-header">
                <h3>Service Appointment
                    <c:if test="${isAdmin}">
                        <span style="font-size: 0.8rem; color: var(--text-muted); font-weight: 400;"> — by ${a.userName}</span>
                    </c:if>
                </h3>
                <span class="status-badge status-${a.status}">${a.status}</span>
            </div>
            <div class="appt-details">
                <div class="appt-detail">
                    <div class="label">Vehicle</div>
                    <div class="value">${a.vehicleInfo}</div>
                </div>
                <div class="appt-detail">
                    <div class="label">Date & Time</div>
                    <div class="value">${a.preferredDate} at ${a.preferredTime}</div>
                </div>
                <div class="appt-detail" style="grid-column: 1 / -1;">
                    <div class="label">Selected Services</div>
                    <div class="value" style="margin-top: 5px;">
                        <c:forTokens var="svc" items="${a.serviceName}" delims=",">
                            <span style="display: inline-block; background: #e3f2fd; color: #1565c0; padding: 3px 10px; border-radius: 4px; font-size: 0.8rem; margin: 2px 4px 2px 0; font-weight: 600;">${svc}</span>
                        </c:forTokens>
                    </div>
                </div>
                <div class="appt-detail">
                    <div class="label">Categories</div>
                    <div class="value">${a.serviceCategory}</div>
                </div>
                <div class="appt-detail">
                    <div class="label">Total Price</div>
                    <div class="value" style="color: var(--primary); font-weight: 700; font-size: 1.1rem;">${a.servicePrice}</div>
                </div>
                <c:if test="${not empty a.notes}">
                    <div class="appt-detail" style="grid-column: 1 / -1;">
                        <div class="label">Notes</div>
                        <div class="value">${a.notes}</div>
                    </div>
                </c:if>
            </div>
            <div class="appt-actions">
                <c:if test="${isAdmin}">
                    <c:if test="${a.status == 'PENDING'}">
                        <a href="appointment?action=confirm&id=${a.appointmentId}" class="btn-confirm">✓ CONFIRM</a>
                    </c:if>
                    <c:if test="${a.status == 'CONFIRMED'}">
                        <a href="appointment?action=complete&id=${a.appointmentId}" class="btn-complete">✓ COMPLETE</a>
                    </c:if>
                    <a href="appointment?action=delete&id=${a.appointmentId}" class="btn-sm-danger" onclick="return confirm('Delete this appointment?')">DELETE</a>
                </c:if>
                <c:if test="${!isAdmin}">
                    <c:if test="${a.status == 'PENDING'}">
                        <a href="appointment?action=cancel&id=${a.appointmentId}" class="btn-cancel-appt" onclick="return confirm('Cancel this appointment?')">CANCEL</a>
                    </c:if>
                </c:if>
            </div>
        </div>
    </c:forEach>

    <c:if test="${empty appointments}">
        <div class="empty-state" style="text-align: center; padding: 60px;">
            <h3>NO APPOINTMENTS YET</h3>
            <p style="color: var(--text-muted); margin-bottom: 20px;">
                <c:if test="${!isAdmin}">Book your first service appointment to get started.</c:if>
                <c:if test="${isAdmin}">No appointments have been booked yet.</c:if>
            </p>
            <c:if test="${!isAdmin}">
                <a href="appointment?action=book" class="btn-primary-custom" style="padding: 12px 25px;">BOOK NOW &gt;</a>
            </c:if>
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

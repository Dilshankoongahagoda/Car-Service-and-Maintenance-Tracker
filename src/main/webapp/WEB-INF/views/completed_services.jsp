<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Completed Services - Shift Auto Dynamics</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
    <style>
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        .completed-card {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.06);
            border: 1px solid var(--border);
            border-left: 5px solid #2E7D32;
            animation: fadeIn 0.5s ease forwards;
            opacity: 0;
            margin-bottom: 20px;
        }
        .completed-card:nth-child(1) { animation-delay: 0.05s; }
        .completed-card:nth-child(2) { animation-delay: 0.1s; }
        .completed-card:nth-child(3) { animation-delay: 0.15s; }
        .completed-card:nth-child(4) { animation-delay: 0.2s; }
        .completed-card:nth-child(5) { animation-delay: 0.25s; }

        .cc-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 15px; }
        .cc-header h3 { margin: 0; font-family: 'Oswald', sans-serif; font-size: 1.3rem; color: var(--dark); }
        .cc-header .user-info { font-size: 0.85rem; color: var(--text-muted); margin-top: 3px; }

        .cc-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px; margin-bottom: 15px; }
        .cc-detail .label { font-size: 0.75rem; color: var(--text-muted); text-transform: uppercase; font-weight: 600; letter-spacing: 0.5px; }
        .cc-detail .value { font-weight: 500; color: var(--dark); margin-top: 2px; }

        .services-tags { margin-bottom: 10px; }
        .services-tags .label { font-size: 0.75rem; color: var(--text-muted); text-transform: uppercase; font-weight: 600; letter-spacing: 0.5px; margin-bottom: 5px; }

        .svc-tag {
            display: inline-block;
            background: #e8f5e9;
            color: #2e7d32;
            padding: 4px 12px;
            border-radius: 4px;
            font-size: 0.8rem;
            margin: 2px 4px 2px 0;
            font-weight: 600;
        }

        .status-badge-complete {
            background: #e8f5e9;
            color: #2e7d32;
            padding: 5px 14px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 700;
            letter-spacing: 1px;
        }

        .stats-bar {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: white;
            border-radius: 10px;
            padding: 20px 25px;
            text-align: center;
            box-shadow: 0 4px 20px rgba(0,0,0,0.06);
            border: 1px solid var(--border);
        }
        .stat-card .stat-value {
            font-family: 'Oswald', sans-serif;
            font-size: 2.5rem;
            color: #2E7D32;
            line-height: 1;
        }
        .stat-card .stat-label {
            font-size: 0.8rem;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 1px;
            font-weight: 600;
            margin-top: 5px;
        }
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
            <li><a href="dashboard">ADMIN PORTAL</a></li>
            <li><a href="all_vehicles">REGISTERED VEHICLES</a></li>
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
    <div class="page-header" style="border-bottom: 3px solid #2E7D32; padding-bottom: 15px; margin-bottom: 30px; display: flex; justify-content: space-between; align-items: center;">
        <h1 style="font-family: 'Oswald', sans-serif; font-size: 2.5rem; color: var(--dark);">COMPLETED SERVICES</h1>
        <a href="appointment" class="btn-primary-custom" style="padding: 12px 25px; font-size: 1rem; text-decoration: none; border-radius: 4px; font-weight: bold;">← BACK TO APPOINTMENTS</a>
    </div>

    <!-- STATS -->
    <div class="stats-bar">
        <div class="stat-card">
            <div class="stat-value">${completedAppointments.size()}</div>
            <div class="stat-label">Total Completed</div>
        </div>
        <div class="stat-card">
            <div class="stat-value" style="color: var(--primary);">${uniqueVehicles}</div>
            <div class="stat-label">Vehicles Serviced</div>
        </div>
        <div class="stat-card">
            <div class="stat-value" style="color: #e65100;">${uniqueUsers}</div>
            <div class="stat-label">Customers Served</div>
        </div>
    </div>

    <!-- COMPLETED APPOINTMENT CARDS -->
    <c:forEach var="ca" items="${completedAppointments}">
        <div class="completed-card">
            <div class="cc-header">
                <div>
                    <h3>${ca.vehicleInfo}</h3>
                    <div class="user-info">Customer: <strong>${ca.userName}</strong> | Appointment #${ca.appointmentId}</div>
                </div>
                <span class="status-badge-complete">✓ COMPLETED</span>
            </div>

            <div class="cc-grid">
                <div class="cc-detail">
                    <div class="label">Service Date</div>
                    <div class="value">${ca.preferredDate}</div>
                </div>
                <div class="cc-detail">
                    <div class="label">Time</div>
                    <div class="value">${ca.preferredTime}</div>
                </div>
                <div class="cc-detail">
                    <div class="label">Total Cost</div>
                    <div class="value" style="color: var(--primary); font-weight: 700; font-size: 1.1rem;">${ca.servicePrice}</div>
                </div>
            </div>

            <div class="services-tags">
                <div class="label">Services Performed</div>
                <div style="margin-top: 5px;">
                    <c:forTokens var="svc" items="${ca.serviceName}" delims=",">
                        <span class="svc-tag">${svc}</span>
                    </c:forTokens>
                </div>
            </div>

            <c:if test="${not empty ca.serviceCategory}">
                <div style="margin-top: 5px;">
                    <span style="font-size: 0.75rem; color: var(--text-muted); text-transform: uppercase; font-weight: 600;">Categories:</span>
                    <span style="font-size: 0.85rem; color: var(--dark);"> ${ca.serviceCategory}</span>
                </div>
            </c:if>

            <c:if test="${not empty ca.notes}">
                <div style="background: #f8f9fa; padding: 10px 15px; border-radius: 6px; margin-top: 10px;">
                    <span style="font-size: 0.75rem; color: var(--text-muted); text-transform: uppercase; font-weight: 600;">Notes:</span>
                    <span style="font-size: 0.85rem; color: var(--dark);"> ${ca.notes}</span>
                </div>
            </c:if>
        </div>
    </c:forEach>

    <c:if test="${empty completedAppointments}">
        <div class="empty-state" style="text-align: center; padding: 60px;">
            <h3>NO COMPLETED SERVICES YET</h3>
            <p style="color: var(--text-muted); margin-bottom: 20px;">Once appointments are marked as completed, they will appear here.</p>
            <a href="appointment" class="btn-primary-custom" style="padding: 12px 25px;">VIEW APPOINTMENTS &gt;</a>
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

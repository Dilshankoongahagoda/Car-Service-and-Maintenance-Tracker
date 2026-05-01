<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Service Reminders - Shift Auto Dynamics</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Oswald:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        @keyframes pulse { 0%,100% { opacity: 1; } 50% { opacity: 0.6; } }
        @keyframes slideRight { from { width: 0; } to { width: var(--progress); } }

        .reminder-grid {
            display: grid; grid-template-columns: repeat(auto-fill, minmax(380px, 1fr));
            gap: 22px; margin-top: 25px;
        }

        .reminder-card {
            background: white; border-radius: 14px; overflow: hidden;
            box-shadow: 0 4px 20px rgba(0,0,0,0.06); border: 1px solid #eaeaea;
            animation: fadeIn 0.5s ease forwards; opacity: 0;
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .reminder-card:hover { transform: translateY(-4px); box-shadow: 0 8px 30px rgba(0,0,0,0.1); }
        .reminder-card:nth-child(1) { animation-delay: 0.05s; }
        .reminder-card:nth-child(2) { animation-delay: 0.1s; }
        .reminder-card:nth-child(3) { animation-delay: 0.15s; }
        .reminder-card:nth-child(4) { animation-delay: 0.2s; }
        .reminder-card:nth-child(5) { animation-delay: 0.25s; }
        .reminder-card:nth-child(6) { animation-delay: 0.3s; }

        /* Status top bar */
        .reminder-card.ON_TRACK { border-top: 4px solid #2e7d32; }
        .reminder-card.DUE_SOON { border-top: 4px solid #f57c00; }
        .reminder-card.OVERDUE { border-top: 4px solid #c62828; }

        .rc-body { padding: 20px 22px; }

        /* Status badge */
        .rc-badge {
            display: inline-flex; align-items: center; gap: 5px;
            padding: 4px 12px; border-radius: 20px; font-size: 0.7rem;
            font-weight: 700; letter-spacing: 0.8px; text-transform: uppercase;
        }
        .rc-badge.ON_TRACK { background: #e8f5e9; color: #2e7d32; }
        .rc-badge.DUE_SOON { background: #fff3e0; color: #e65100; }
        .rc-badge.OVERDUE { background: #ffebee; color: #c62828; animation: pulse 1.5s infinite; }

        .rc-badge .dot {
            width: 7px; height: 7px; border-radius: 50%;
        }
        .rc-badge.ON_TRACK .dot { background: #2e7d32; }
        .rc-badge.DUE_SOON .dot { background: #f57c00; }
        .rc-badge.OVERDUE .dot { background: #c62828; }

        /* Service name */
        .rc-service {
            font-family: 'Oswald', sans-serif; font-size: 1.2rem; font-weight: 600;
            color: #1a1a2e; margin: 10px 0 12px; letter-spacing: 0.5px;
        }

        /* Info rows */
        .rc-info { display: flex; flex-direction: column; gap: 6px; margin-bottom: 14px; }
        .rc-row {
            display: flex; justify-content: space-between; align-items: center;
            font-size: 0.82rem;
        }
        .rc-label { color: #999; font-weight: 500; text-transform: uppercase; font-size: 0.68rem; letter-spacing: 0.5px; }
        .rc-val { color: #333; font-weight: 600; }

        /* Countdown */
        .rc-countdown {
            text-align: center; padding: 12px; border-radius: 10px;
            margin-bottom: 14px;
        }
        .rc-countdown.ON_TRACK { background: linear-gradient(135deg, #e8f5e9, #c8e6c9); }
        .rc-countdown.DUE_SOON { background: linear-gradient(135deg, #fff3e0, #ffe0b2); }
        .rc-countdown.OVERDUE { background: linear-gradient(135deg, #ffebee, #ffcdd2); }

        .rc-countdown .countdown-text {
            font-family: 'Oswald', sans-serif; font-size: 1.1rem; font-weight: 700;
            letter-spacing: 0.5px;
        }
        .rc-countdown.ON_TRACK .countdown-text { color: #1b5e20; }
        .rc-countdown.DUE_SOON .countdown-text { color: #e65100; }
        .rc-countdown.OVERDUE .countdown-text { color: #b71c1c; }

        /* Progress bar */
        .rc-progress-wrap {
            height: 6px; background: #eee; border-radius: 3px; overflow: hidden;
        }
        .rc-progress-bar {
            height: 100%; border-radius: 3px; transition: width 1s ease;
        }
        .rc-progress-bar.ON_TRACK { background: linear-gradient(90deg, #43a047, #66bb6a); }
        .rc-progress-bar.DUE_SOON { background: linear-gradient(90deg, #f57c00, #ffb74d); }
        .rc-progress-bar.OVERDUE { background: linear-gradient(90deg, #c62828, #ef5350); }

        .rc-progress-label {
            display: flex; justify-content: space-between; font-size: 0.65rem;
            color: #999; margin-top: 4px; font-weight: 500;
        }

        /* Interval badge */
        .rc-interval {
            display: inline-block; padding: 3px 10px; border-radius: 4px;
            font-size: 0.72rem; font-weight: 600; background: #f0f0f0;
            color: #666; margin-top: 8px;
        }

        /* Summary stats */
        .reminder-stats {
            display: flex; gap: 15px; margin-top: 20px; flex-wrap: wrap;
        }
        .stat-chip {
            display: flex; align-items: center; gap: 8px;
            padding: 10px 18px; border-radius: 10px; background: white;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05); border: 1px solid #eaeaea;
        }
        .stat-chip .stat-dot {
            width: 10px; height: 10px; border-radius: 50%;
        }
        .stat-chip .stat-count {
            font-family: 'Oswald', sans-serif; font-size: 1.3rem; font-weight: 700; color: #1a1a2e;
        }
        .stat-chip .stat-label {
            font-size: 0.75rem; color: #888; font-weight: 500;
        }

        /* Empty state */
        .empty-reminders {
            text-align: center; padding: 60px 20px; background: white;
            border-radius: 14px; box-shadow: 0 4px 20px rgba(0,0,0,0.04);
            border: 1px dashed #ddd; margin-top: 25px;
        }
        .empty-reminders .empty-icon { font-size: 3.5rem; margin-bottom: 15px; }
        .empty-reminders h3 {
            font-family: 'Oswald', sans-serif; font-size: 1.4rem; color: #1a1a2e;
            margin: 0 0 8px; letter-spacing: 1px;
        }
        .empty-reminders p { font-size: 0.9rem; color: #999; margin: 0; }

        @media (max-width: 576px) {
            .reminder-grid { grid-template-columns: 1fr; }
            .reminder-stats { flex-direction: column; }
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
            <span></span><span></span><span></span>
        </button>
    </div>
</nav>

<div class="page-container">
    <!-- PAGE HEADER -->
    <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; border-bottom: 3px solid var(--primary); padding-bottom: 15px; margin-bottom: 0;">
        <h1 style="font-family: 'Oswald', sans-serif; font-size: 2.2rem; color: var(--dark); letter-spacing: 1px;">
            🔔 SERVICE REMINDERS
        </h1>
    </div>

    <!-- SUMMARY STATS -->
    <c:if test="${not empty serviceReminders}">
        <div class="reminder-stats">
            <c:set var="overdueCount" value="0"/>
            <c:set var="dueSoonCount" value="0"/>
            <c:set var="onTrackCount" value="0"/>
            <c:forEach var="r" items="${serviceReminders}">
                <c:if test="${r.status == 'OVERDUE'}"><c:set var="overdueCount" value="${overdueCount + 1}"/></c:if>
                <c:if test="${r.status == 'DUE_SOON'}"><c:set var="dueSoonCount" value="${dueSoonCount + 1}"/></c:if>
                <c:if test="${r.status == 'ON_TRACK'}"><c:set var="onTrackCount" value="${onTrackCount + 1}"/></c:if>
            </c:forEach>
            <c:if test="${overdueCount > 0}">
                <div class="stat-chip">
                    <div class="stat-dot" style="background: #c62828;"></div>
                    <span class="stat-count">${overdueCount}</span>
                    <span class="stat-label">Overdue</span>
                </div>
            </c:if>
            <c:if test="${dueSoonCount > 0}">
                <div class="stat-chip">
                    <div class="stat-dot" style="background: #f57c00;"></div>
                    <span class="stat-count">${dueSoonCount}</span>
                    <span class="stat-label">Due Soon</span>
                </div>
            </c:if>
            <div class="stat-chip">
                <div class="stat-dot" style="background: #2e7d32;"></div>
                <span class="stat-count">${onTrackCount}</span>
                <span class="stat-label">On Track</span>
            </div>
            <div class="stat-chip">
                <div class="stat-dot" style="background: #1565c0;"></div>
                <span class="stat-count">${serviceReminders.size()}</span>
                <span class="stat-label">Total</span>
            </div>
        </div>
    </c:if>

    <!-- REMINDER CARDS -->
    <c:if test="${not empty serviceReminders}">
        <div class="reminder-grid">
            <c:forEach var="r" items="${serviceReminders}">
                <div class="reminder-card ${r.status}">
                    <div class="rc-body">
                        <!-- Badge -->
                        <span class="rc-badge ${r.status}">
                            <span class="dot"></span>
                            <c:if test="${r.status == 'ON_TRACK'}">On Track</c:if>
                            <c:if test="${r.status == 'DUE_SOON'}">Due Soon</c:if>
                            <c:if test="${r.status == 'OVERDUE'}">Overdue</c:if>
                        </span>

                        <!-- Service Name -->
                        <h3 class="rc-service">${r.serviceName}</h3>

                        <!-- Info -->
                        <div class="rc-info">
                            <div class="rc-row">
                                <span class="rc-label">Vehicle</span>
                                <span class="rc-val">${r.vehicleInfo}</span>
                            </div>
                            <div class="rc-row">
                                <span class="rc-label">Last Serviced</span>
                                <span class="rc-val">${r.completedDate}</span>
                            </div>
                            <div class="rc-row">
                                <span class="rc-label">Next Due</span>
                                <span class="rc-val" style="color: ${r.status == 'OVERDUE' ? '#c62828' : r.status == 'DUE_SOON' ? '#e65100' : '#2e7d32'}; font-weight: 700;">
                                    ${r.nextDueDate}
                                </span>
                            </div>
                        </div>

                        <!-- Countdown Box -->
                        <div class="rc-countdown ${r.status}">
                            <div class="countdown-text">
                                <c:if test="${r.status == 'OVERDUE'}">⚠️ </c:if>
                                <c:if test="${r.status == 'DUE_SOON'}">⏰ </c:if>
                                <c:if test="${r.status == 'ON_TRACK'}">✅ </c:if>
                                ${r.timeRemainingText}
                            </div>
                        </div>

                        <!-- Progress Bar -->
                        <div class="rc-progress-wrap">
                            <div class="rc-progress-bar ${r.status}" style="width: ${r.progressPercent}%;"></div>
                        </div>
                        <div class="rc-progress-label">
                            <span>Serviced</span>
                            <span>Due</span>
                        </div>

                        <!-- Interval label -->
                        <span class="rc-interval">🔄 Every ${r.intervalMonths} months</span>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:if>

    <!-- EMPTY STATE -->
    <c:if test="${empty serviceReminders}">
        <div class="empty-reminders">
            <div class="empty-icon">🔔</div>
            <h3>NO SERVICE REMINDERS YET</h3>
            <p>Reminders will appear automatically after you complete service appointments.</p>
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
        signOut(auth).then(() => { window.location.href = 'user?action=logout'; }).catch(() => { window.location.href = 'user?action=logout'; });
    };
</script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    var btn = document.getElementById('navHamburger');
    if (!btn) return;
    btn.addEventListener('click', function() { document.querySelector('.navbar-custom').classList.toggle('nav-open'); });
    document.addEventListener('click', function(e) {
        if (!e.target.closest('.navbar-custom')) { var nav = document.querySelector('.navbar-custom'); if (nav) nav.classList.remove('nav-open'); }
    });
});
</script>
</body>
</html>

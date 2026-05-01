<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Shift Auto Dynamics</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
    <style>
        @keyframes fadeIn { from { opacity: 0; transform: translateY(15px); } to { opacity: 1; transform: translateY(0); } }
        @keyframes countUp { from { opacity: 0; transform: scale(0.5); } to { opacity: 1; transform: scale(1); } }
        @keyframes slideRight { from { width: 0; } }
        @keyframes pulse { 0%,100%{ opacity:1; } 50%{ opacity:0.6; } }

        /* ===== OVERVIEW STATS ROW ===== */
        .stats-row {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-tile {
            background: white;
            border-radius: 12px;
            padding: 22px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.06);
            border: 1px solid var(--border);
            position: relative;
            overflow: hidden;
            animation: fadeIn 0.5s ease forwards;
            opacity: 0;
        }
        .stat-tile:nth-child(1) { animation-delay: 0.05s; }
        .stat-tile:nth-child(2) { animation-delay: 0.1s; }
        .stat-tile:nth-child(3) { animation-delay: 0.15s; }
        .stat-tile:nth-child(4) { animation-delay: 0.2s; }

        .stat-tile::before {
            content: '';
            position: absolute;
            top: 0; left: 0;
            width: 4px; height: 100%;
        }
        .stat-tile.blue::before { background: #1976D2; }
        .stat-tile.green::before { background: #2E7D32; }
        .stat-tile.orange::before { background: #E65100; }
        .stat-tile.purple::before { background: #7B1FA2; }

        .stat-tile .st-icon {
            width: 40px; height: 40px;
            border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.2rem;
            margin-bottom: 12px;
        }
        .stat-tile.blue .st-icon { background: #e3f2fd; color: #1976D2; }
        .stat-tile.green .st-icon { background: #e8f5e9; color: #2E7D32; }
        .stat-tile.orange .st-icon { background: #fff3e0; color: #E65100; }
        .stat-tile.purple .st-icon { background: #f3e5f5; color: #7B1FA2; }

        .stat-tile .st-value {
            font-family: 'Oswald', sans-serif;
            font-size: 2.5rem;
            line-height: 1;
            color: var(--dark);
            animation: countUp 0.6s ease forwards;
        }
        .stat-tile .st-label {
            font-size: 0.78rem;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 1px;
            font-weight: 600;
            margin-top: 4px;
        }
        .stat-tile .st-link {
            display: inline-block;
            margin-top: 10px;
            font-size: 0.8rem;
            color: var(--primary);
            text-decoration: none;
            font-weight: 600;
        }
        .stat-tile .st-link:hover { text-decoration: underline; }

        /* ===== ANALYTICS GRID ===== */
        .analytics-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 25px;
            margin-bottom: 30px;
        }
        .analytics-card {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.06);
            border: 1px solid var(--border);
            animation: fadeIn 0.6s ease forwards;
            opacity: 0;
        }
        .analytics-card:nth-child(1) { animation-delay: 0.2s; }
        .analytics-card:nth-child(2) { animation-delay: 0.3s; }

        .analytics-card h3 {
            font-family: 'Oswald', sans-serif;
            font-size: 1.1rem;
            color: var(--dark);
            margin: 0 0 20px 0;
            padding-bottom: 10px;
            border-bottom: 2px solid var(--border);
            letter-spacing: 1px;
        }

        /* ===== PROGRESS BAR CHART ===== */
        .bar-row {
            display: flex;
            align-items: center;
            margin-bottom: 14px;
        }
        .bar-label {
            width: 100px;
            font-size: 0.8rem;
            font-weight: 600;
            color: var(--dark);
            flex-shrink: 0;
        }
        .bar-track {
            flex: 1;
            height: 26px;
            background: #f5f5f5;
            border-radius: 6px;
            overflow: hidden;
            position: relative;
        }
        .bar-fill {
            height: 100%;
            border-radius: 6px;
            animation: slideRight 1s ease forwards;
            display: flex;
            align-items: center;
            padding-left: 10px;
        }
        .bar-fill span {
            font-size: 0.72rem;
            font-weight: 700;
            color: white;
            white-space: nowrap;
        }
        .bar-fill.pending { background: linear-gradient(90deg, #ff9800, #f57c00); }
        .bar-fill.confirmed { background: linear-gradient(90deg, #42a5f5, #1976D2); }
        .bar-fill.completed { background: linear-gradient(90deg, #66bb6a, #2E7D32); }
        .bar-fill.cancelled { background: linear-gradient(90deg, #bdbdbd, #9e9e9e); }
        .bar-count {
            width: 40px;
            text-align: right;
            font-size: 0.85rem;
            font-weight: 700;
            color: var(--dark);
            margin-left: 10px;
            flex-shrink: 0;
        }

        /* ===== DONUT / RING ===== */
        .ring-container {
            display: flex;
            align-items: center;
            gap: 30px;
        }
        .ring-chart {
            position: relative;
            width: 140px;
            height: 140px;
            flex-shrink: 0;
        }
        .ring-chart svg { transform: rotate(-90deg); }
        .ring-chart .ring-bg { fill: none; stroke: #f0f0f0; stroke-width: 10; }
        .ring-chart .ring-fg { fill: none; stroke-width: 10; stroke-linecap: round; transition: stroke-dashoffset 1.5s ease; }
        .ring-center {
            position: absolute;
            top: 50%; left: 50%;
            transform: translate(-50%, -50%);
            text-align: center;
        }
        .ring-center .ring-val {
            font-family: 'Oswald', sans-serif;
            font-size: 2.2rem;
            color: var(--dark);
            line-height: 1;
        }
        .ring-center .ring-lbl {
            font-size: 0.65rem;
            color: var(--text-muted);
            text-transform: uppercase;
            font-weight: 600;
            letter-spacing: 1px;
        }
        .ring-legend { flex: 1; }
        .ring-legend-item {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
            font-size: 0.85rem;
        }
        .ring-legend-dot {
            width: 10px; height: 10px;
            border-radius: 50%;
            margin-right: 8px;
            flex-shrink: 0;
        }
        .ring-legend-item .rl-label { color: var(--text-muted); flex: 1; }
        .ring-legend-item .rl-val { font-weight: 700; color: var(--dark); }

        /* ===== SECONDARY STATS ===== */
        .secondary-stats {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 15px;
            margin-bottom: 30px;
        }
        .ss-tile {
            background: white;
            border-radius: 10px;
            padding: 18px;
            text-align: center;
            box-shadow: 0 2px 12px rgba(0,0,0,0.05);
            border: 1px solid var(--border);
            animation: fadeIn 0.5s ease forwards;
            opacity: 0;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .ss-tile:hover { transform: translateY(-3px); box-shadow: 0 6px 20px rgba(0,0,0,0.1); }
        .ss-tile:nth-child(1) { animation-delay: 0.3s; }
        .ss-tile:nth-child(2) { animation-delay: 0.35s; }
        .ss-tile:nth-child(3) { animation-delay: 0.4s; }
        .ss-tile:nth-child(4) { animation-delay: 0.45s; }
        .ss-tile:nth-child(5) { animation-delay: 0.5s; }

        .ss-tile .ss-val {
            font-family: 'Oswald', sans-serif;
            font-size: 2rem;
            line-height: 1;
            margin-bottom: 4px;
        }
        .ss-tile .ss-lbl {
            font-size: 0.7rem;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.8px;
            font-weight: 600;
        }

        /* ===== RECENT TABLE ===== */
        .recent-card {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.06);
            border: 1px solid var(--border);
            margin-bottom: 30px;
            animation: fadeIn 0.6s ease forwards;
            animation-delay: 0.4s;
            opacity: 0;
        }
        .recent-card h3 {
            font-family: 'Oswald', sans-serif;
            font-size: 1.1rem;
            color: var(--dark);
            margin: 0 0 15px 0;
            padding-bottom: 10px;
            border-bottom: 2px solid var(--border);
            letter-spacing: 1px;
        }
        .recent-table {
            width: 100%;
            border-collapse: collapse;
        }
        .recent-table th {
            text-align: left;
            font-size: 0.7rem;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 1px;
            font-weight: 700;
            padding: 8px 12px;
            border-bottom: 1px solid var(--border);
        }
        .recent-table td {
            padding: 10px 12px;
            font-size: 0.85rem;
            border-bottom: 1px solid #f5f5f5;
        }
        .recent-table tr:hover { background: #fafafa; }
        .status-dot {
            display: inline-block;
            width: 8px; height: 8px;
            border-radius: 50%;
            margin-right: 6px;
        }
        .status-dot.pending { background: #ff9800; }
        .status-dot.confirmed { background: #1976D2; }
        .status-dot.completed { background: #2E7D32; }
        .status-dot.cancelled { background: #9e9e9e; }

        /* ===== QUICK ACTIONS ===== */
        .quick-actions {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 15px;
            margin-bottom: 30px;
        }
        .qa-btn {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 14px 18px;
            background: white;
            border: 1px solid var(--border);
            border-radius: 10px;
            text-decoration: none;
            font-weight: 600;
            font-size: 0.85rem;
            color: var(--dark);
            transition: all 0.3s;
            box-shadow: 0 2px 10px rgba(0,0,0,0.04);
        }
        .qa-btn:hover {
            border-color: var(--primary);
            color: var(--primary);
            box-shadow: 0 4px 15px rgba(25,118,210,0.15);
            transform: translateY(-2px);
        }
        .qa-btn .qa-icon {
            width: 36px; height: 36px;
            border-radius: 8px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.1rem;
            flex-shrink: 0;
        }
        @media (max-width: 992px) {
            .stats-row { grid-template-columns: repeat(2, 1fr); }
            .analytics-grid { grid-template-columns: 1fr; }
            .secondary-stats { grid-template-columns: repeat(3, 1fr); }
            .quick-actions { grid-template-columns: repeat(2, 1fr); }
        }
        @media (max-width: 576px) {
            .stats-row { grid-template-columns: 1fr; }
            .secondary-stats { grid-template-columns: repeat(2, 1fr); }
            .quick-actions { grid-template-columns: 1fr; }
            .ring-container { flex-direction: column; align-items: flex-start; }
            .recent-card { overflow-x: auto; }
            .recent-table { min-width: 580px; }
            .bar-label { width: 70px; font-size: 0.72rem; }
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
            <li><a href="dashboard" class="active">ADMIN PORTAL</a></li>
            <li><a href="all_vehicles">REGISTERED VEHICLES</a></li>
            <li><a href="service">MANAGE SERVICES</a></li>
            <li><a href="appointment">APPOINTMENTS</a></li>
            <li><a href="estimate">ESTIMATES</a></li>
        </ul>
        <div class="nav-right">
            <span class="nav-user">Admin: <strong>${authUser.fullName}</strong></span>
            <a href="#" onclick="firebaseSignOut()" class="btn-primary-custom" style="padding: 10px 20px; white-space: nowrap; display: inline-flex; align-items: center; gap: 5px;">SIGN OUT &gt;</a>
        </div>
        <button class="nav-hamburger" id="navHamburger" aria-label="Toggle navigation">
            <span></span>
            <span></span>
            <span></span>
        </button>
    </div>
</nav>

<section class="hero-section" style="height: 350px;">
    <div class="hero-left" style="clip-path: polygon(0 0, 100% 0, 90% 100%, 0% 100%); width: 50%;">
        <span class="hero-subtitle">COMMAND CENTER,</span>
        <h1 class="hero-title">ADMIN PORTAL</h1>
        <p class="hero-desc">Real-time analytics, appointment tracking, and fleet management — all in one place.</p>
    </div>
    <div class="hero-right" style="width: 60%;">
        <img src="${pageContext.request.contextPath}/images/autocare_hero.png" alt="Hero background" class="hero-bg-img" />
    </div>
</section>

<div class="page-container">

    <!-- ===== QUICK ACTIONS ===== -->
    <div style="margin-bottom: 25px;">
        <h2 style="font-family: 'Oswald', sans-serif; font-size: 1rem; color: var(--text-muted); letter-spacing: 2px; margin-bottom: 12px;">QUICK ACTIONS</h2>
    </div>
    <div class="quick-actions">
        <a href="all_vehicles" class="qa-btn">
            <div class="qa-icon" style="background: #e3f2fd; color: #1976D2;">🚗</div>
            View All Vehicles
        </a>
        <a href="appointment" class="qa-btn">
            <div class="qa-icon" style="background: #fff3e0; color: #E65100;">📋</div>
            Manage Appointments
        </a>
        <a href="appointment?action=completed" class="qa-btn">
            <div class="qa-icon" style="background: #e8f5e9; color: #2E7D32;">✓</div>
            Completed Services
        </a>
        <a href="estimate" class="qa-btn">
            <div class="qa-icon" style="background: #f3e5f5; color: #7B1FA2;">📑</div>
            Manage Estimates
        </a>
    </div>

    <!-- ===== PRIMARY METRICS ===== -->
    <div style="margin-bottom: 15px;">
        <h2 style="font-family: 'Oswald', sans-serif; font-size: 1rem; color: var(--text-muted); letter-spacing: 2px;">OVERVIEW</h2>
    </div>
    <div class="stats-row">
        <div class="stat-tile blue">
            <div class="st-icon">🚗</div>
            <div class="st-value">${totalVehicles}</div>
            <div class="st-label">Registered Vehicles</div>
            <a href="all_vehicles" class="st-link">View fleet →</a>
        </div>
        <div class="stat-tile orange">
            <div class="st-icon">📋</div>
            <div class="st-value">${totalAppointments}</div>
            <div class="st-label">Total Appointments</div>
            <a href="appointment" class="st-link">View all →</a>
        </div>
        <div class="stat-tile green">
            <div class="st-icon">✓</div>
            <div class="st-value">${completedAppointments}</div>
            <div class="st-label">Completed Services</div>
            <a href="appointment?action=completed" class="st-link">View completed →</a>
        </div>
        <div class="stat-tile purple">
            <div class="st-icon">⚙</div>
            <div class="st-value">${totalServiceRecords}</div>
            <div class="st-label">Service Records</div>
            <a href="service" class="st-link">View services →</a>
        </div>
    </div>

    <!-- ===== ANALYTICS CHARTS ===== -->
    <div class="analytics-grid">
        <!-- Appointment Status Breakdown -->
        <div class="analytics-card">
            <h3>APPOINTMENT STATUS BREAKDOWN</h3>
            <c:set var="maxAppt" value="${totalAppointments > 0 ? totalAppointments : 1}" />

            <div class="bar-row">
                <div class="bar-label">Pending</div>
                <div class="bar-track">
                    <div class="bar-fill pending" style="width: ${(pendingAppointments * 100) / maxAppt}%; min-width: ${pendingAppointments > 0 ? '30px' : '0'};">
                        <span>${pendingAppointments}</span>
                    </div>
                </div>
                <div class="bar-count">${pendingAppointments}</div>
            </div>
            <div class="bar-row">
                <div class="bar-label">Confirmed</div>
                <div class="bar-track">
                    <div class="bar-fill confirmed" style="width: ${(confirmedAppointments * 100) / maxAppt}%; min-width: ${confirmedAppointments > 0 ? '30px' : '0'};">
                        <span>${confirmedAppointments}</span>
                    </div>
                </div>
                <div class="bar-count">${confirmedAppointments}</div>
            </div>
            <div class="bar-row">
                <div class="bar-label">Completed</div>
                <div class="bar-track">
                    <div class="bar-fill completed" style="width: ${(completedAppointments * 100) / maxAppt}%; min-width: ${completedAppointments > 0 ? '30px' : '0'};">
                        <span>${completedAppointments}</span>
                    </div>
                </div>
                <div class="bar-count">${completedAppointments}</div>
            </div>
            <div class="bar-row">
                <div class="bar-label">Cancelled</div>
                <div class="bar-track">
                    <div class="bar-fill cancelled" style="width: ${(cancelledAppointments * 100) / maxAppt}%; min-width: ${cancelledAppointments > 0 ? '30px' : '0'};">
                        <span>${cancelledAppointments}</span>
                    </div>
                </div>
                <div class="bar-count">${cancelledAppointments}</div>
            </div>

            <div style="margin-top: 15px; padding-top: 12px; border-top: 1px solid var(--border); font-size: 0.8rem; color: var(--text-muted);">
                <strong style="color: var(--dark);">${pendingAppointments}</strong> appointments need your attention
            </div>
        </div>

        <!-- Completion Rate Ring -->
        <div class="analytics-card">
            <h3>SERVICE COMPLETION RATE</h3>
            <div class="ring-container">
                <div class="ring-chart">
                    <svg viewBox="0 0 140 140" width="140" height="140">
                        <circle class="ring-bg" cx="70" cy="70" r="55"/>
                        <circle class="ring-fg" cx="70" cy="70" r="55"
                            stroke="#2E7D32"
                            stroke-dasharray="345.6"
                            stroke-dashoffset="${345.6 - (345.6 * completionRate / 100)}"
                        />
                    </svg>
                    <div class="ring-center">
                        <div class="ring-val">${completionRate}%</div>
                        <div class="ring-lbl">Complete</div>
                    </div>
                </div>
                <div class="ring-legend">
                    <div class="ring-legend-item">
                        <div class="ring-legend-dot" style="background: #2E7D32;"></div>
                        <span class="rl-label">Completed</span>
                        <span class="rl-val">${completedAppointments}</span>
                    </div>
                    <div class="ring-legend-item">
                        <div class="ring-legend-dot" style="background: #1976D2;"></div>
                        <span class="rl-label">Confirmed</span>
                        <span class="rl-val">${confirmedAppointments}</span>
                    </div>
                    <div class="ring-legend-item">
                        <div class="ring-legend-dot" style="background: #ff9800;"></div>
                        <span class="rl-label">Pending</span>
                        <span class="rl-val">${pendingAppointments}</span>
                    </div>
                    <div class="ring-legend-item">
                        <div class="ring-legend-dot" style="background: #9e9e9e;"></div>
                        <span class="rl-label">Cancelled</span>
                        <span class="rl-val">${cancelledAppointments}</span>
                    </div>
                    <div style="margin-top: 12px; padding-top: 10px; border-top: 1px solid var(--border);">
                        <div class="ring-legend-item" style="margin-bottom: 0;">
                            <span class="rl-label" style="font-weight: 700; color: var(--dark);">Total</span>
                            <span class="rl-val" style="font-size: 1.1rem;">${totalAppointments}</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ===== SECONDARY METRICS ===== -->
    <div style="margin-bottom: 12px;">
        <h2 style="font-family: 'Oswald', sans-serif; font-size: 1rem; color: var(--text-muted); letter-spacing: 2px;">PLATFORM DATA</h2>
    </div>
    <div class="secondary-stats">
        <div class="ss-tile" style="animation-delay: 0.3s;">
            <div class="ss-val" style="color: #1976D2;">${totalCars}</div>
            <div class="ss-lbl">Cars</div>
        </div>

        <div class="ss-tile" style="animation-delay: 0.4s;">
            <div class="ss-val" style="color: #7B1FA2;">${totalCategories}</div>
            <div class="ss-lbl">Service Categories</div>
        </div>
        <div class="ss-tile" style="animation-delay: 0.45s;">
            <div class="ss-val" style="color: #2E7D32;">${totalPackages}</div>
            <div class="ss-lbl">Service Packages</div>
        </div>
        <div class="ss-tile" style="animation-delay: 0.5s;">
            <div class="ss-val" style="color: #C62828;">${totalEstimates}</div>
            <div class="ss-lbl">Estimates</div>
        </div>
    </div>

    <!-- ===== RECENT APPOINTMENTS TABLE ===== -->
    <div class="recent-card">
        <h3 style="display: flex; justify-content: space-between; align-items: center;">
            RECENT APPOINTMENTS
            <a href="appointment" style="font-size: 0.8rem; color: var(--primary); text-decoration: none; font-weight: 600; font-family: 'Roboto', sans-serif; text-transform: none; letter-spacing: 0;">View all →</a>
        </h3>
        <table class="recent-table">
            <thead>
                <tr>
                    <th>Customer</th>
                    <th>Vehicle</th>
                    <th>Services</th>
                    <th>Date</th>
                    <th>Price</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="ra" items="${recentAppointments}">
                    <tr>
                        <td><strong>${ra.userName}</strong></td>
                        <td>${ra.vehicleInfo}</td>
                        <td style="max-width: 200px;">
                            <c:forTokens var="svc" items="${ra.serviceName}" delims=",">
                                <span style="display: inline-block; background: #f5f5f5; padding: 2px 6px; border-radius: 3px; font-size: 0.72rem; margin: 1px 2px; font-weight: 500;">${svc}</span>
                            </c:forTokens>
                        </td>
                        <td>${ra.preferredDate}</td>
                        <td style="font-weight: 600; color: var(--primary);">${ra.servicePrice}</td>
                        <td>
                            <span class="status-dot ${ra.status == 'PENDING' ? 'pending' : ra.status == 'CONFIRMED' ? 'confirmed' : ra.status == 'COMPLETED' ? 'completed' : 'cancelled'}"></span>
                            <span style="font-weight: 600; font-size: 0.8rem;">${ra.status}</span>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty recentAppointments}">
                    <tr>
                        <td colspan="6" style="text-align: center; padding: 30px; color: var(--text-muted);">No appointments yet</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>

    <!-- ========== INVOICE ANALYTICS SECTION ========== -->
    <div style="margin-bottom: 15px; margin-top: 10px;">
        <h2 style="font-family: 'Oswald', sans-serif; font-size: 1rem; color: var(--text-muted); letter-spacing: 2px;">INVOICE ANALYTICS</h2>
    </div>

    <!-- Revenue Stats Row -->
    <div class="stats-row">
        <div class="stat-tile green" style="animation-delay: 0.55s;">
            <div class="st-icon" style="background: #e8f5e9; color: #2E7D32;">💰</div>
            <div class="st-value" style="font-size: 1.8rem;">Rs. ${invTotalRevenue}</div>
            <div class="st-label">Total Revenue</div>
            <a href="estimate" class="st-link">View invoices →</a>
        </div>
        <div class="stat-tile blue" style="animation-delay: 0.6s;">
            <div class="st-icon" style="background: #e3f2fd; color: #1976D2;">📊</div>
            <div class="st-value" style="font-size: 1.8rem;">Rs. ${invAvgInvoice}</div>
            <div class="st-label">Avg Invoice Value</div>
            <div style="margin-top: 8px; font-size: 0.75rem; color: var(--text-muted); font-weight: 600;">${invTotalCount} total invoices</div>
        </div>
        <div class="stat-tile orange" style="animation-delay: 0.65s;">
            <div class="st-icon" style="background: #fff3e0; color: #E65100;">🔧</div>
            <div class="st-value" style="font-size: 1.8rem;">Rs. ${invServiceCharges}</div>
            <div class="st-label">Service Charges</div>
            <div style="margin-top: 8px; font-size: 0.75rem; color: var(--text-muted); font-weight: 600;">Labour & service fees</div>
        </div>
        <div class="stat-tile purple" style="animation-delay: 0.7s;">
            <div class="st-icon" style="background: #f3e5f5; color: #7B1FA2;">⚙️</div>
            <div class="st-value" style="font-size: 1.8rem;">Rs. ${invPartsRevenue}</div>
            <div class="st-label">Parts Revenue</div>
            <div style="margin-top: 8px; font-size: 0.75rem; color: var(--text-muted); font-weight: 600;">Parts & materials</div>
        </div>
    </div>

    <!-- Analytics Charts Row -->
    <div class="analytics-grid">

        <!-- Invoice Summary -->
        <div class="analytics-card" style="animation-delay: 0.5s;">
            <h3>INVOICE SUMMARY</h3>
            <div class="ring-container">
                <div class="ring-chart">
                    <svg viewBox="0 0 140 140" width="140" height="140">
                        <circle class="ring-bg" cx="70" cy="70" r="55"/>
                        <circle class="ring-fg" cx="70" cy="70" r="55"
                            stroke="#1565c0"
                            stroke-dasharray="345.6"
                            stroke-dashoffset="0"
                        />
                    </svg>
                    <div class="ring-center">
                        <div class="ring-val">${invTotalCount}</div>
                        <div class="ring-lbl">Invoices</div>
                    </div>
                </div>
                <div class="ring-legend">
                    <div class="ring-legend-item">
                        <div class="ring-legend-dot" style="background: #1565c0;"></div>
                        <span class="rl-label">Total Invoices</span>
                        <span class="rl-val">${invTotalCount}</span>
                    </div>
                    <div style="margin-top: 14px; padding-top: 12px; border-top: 1px solid var(--border);">
                        <div class="ring-legend-item" style="margin-bottom: 6px;">
                            <span class="rl-label" style="font-weight: 700; color: var(--dark);">Total Revenue</span>
                            <span class="rl-val" style="font-size: 1rem; color: #2E7D32;">Rs. ${invTotalRevenue}</span>
                        </div>
                        <div class="ring-legend-item" style="margin-bottom: 0;">
                            <span class="rl-label" style="font-weight: 700; color: var(--dark);">Avg Invoice</span>
                            <span class="rl-val" style="font-size: 1rem; color: #1565c0;">Rs. ${invAvgInvoice}</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Top Services by Revenue -->
        <div class="analytics-card" style="animation-delay: 0.6s;">
            <h3>TOP SERVICES BY REVENUE</h3>
            <c:choose>
                <c:when test="${not empty topServiceNames}">
                    <c:forEach var="svcName" items="${topServiceNames}" varStatus="loop">
                        <div class="bar-row">
                            <div class="bar-label" style="width: 130px; font-size: 0.75rem; line-height: 1.3;">${svcName}</div>
                            <div class="bar-track">
                                <c:set var="svcRev" value="${topServiceRevenues[loop.index]}" />
                                <c:set var="barPercent" value="${(svcRev / invMaxServiceRevenue) * 100}" />
                                <div class="bar-fill" style="width: ${barPercent > 0 ? barPercent : 5}%; min-width: 50px; background: linear-gradient(90deg, ${loop.index == 0 ? '#1976D2, #42a5f5' : loop.index == 1 ? '#2E7D32, #66bb6a' : loop.index == 2 ? '#E65100, #ff9800' : loop.index == 3 ? '#7B1FA2, #ba68c8' : '#455a64, #78909c'});">
                                    <span>Rs. ${svcRev}</span>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div style="text-align: center; padding: 40px 20px; color: var(--text-muted);">
                        <div style="font-size: 2rem; margin-bottom: 10px;">📋</div>
                        <p>No invoice data yet</p>
                    </div>
                </c:otherwise>
            </c:choose>
            <div style="margin-top: 15px; padding-top: 12px; border-top: 1px solid var(--border); font-size: 0.78rem; color: var(--text-muted);">
                Showing top revenue-generating services across all invoices
            </div>
        </div>
    </div>

    <!-- Revenue Breakdown Tiles -->
    <div style="margin-bottom: 12px;">
        <h2 style="font-family: 'Oswald', sans-serif; font-size: 1rem; color: var(--text-muted); letter-spacing: 2px;">REVENUE BREAKDOWN</h2>
    </div>
    <div class="secondary-stats" style="grid-template-columns: repeat(3, 1fr);">
        <div class="ss-tile" style="animation-delay: 0.55s;">
            <div style="font-size: 1.5rem; margin-bottom: 8px;">🏷️</div>
            <div class="ss-val" style="color: #1976D2; font-size: 1.6rem;">Rs. ${invTaxCollected}</div>
            <div class="ss-lbl">Tax Collected</div>
        </div>
        <div class="ss-tile" style="animation-delay: 0.6s;">
            <div style="font-size: 1.5rem; margin-bottom: 8px;">🔧</div>
            <div class="ss-val" style="color: #E65100; font-size: 1.6rem;">Rs. ${invServiceCharges}</div>
            <div class="ss-lbl">Service / Labour Charges</div>
        </div>
        <div class="ss-tile" style="animation-delay: 0.65s;">
            <div style="font-size: 1.5rem; margin-bottom: 8px;">⚙️</div>
            <div class="ss-val" style="color: #2E7D32; font-size: 1.6rem;">Rs. ${invPartsRevenue}</div>
            <div class="ss-lbl">Parts Revenue</div>
        </div>
    </div>

    <!-- Recent Invoices Table -->
    <div class="recent-card" style="animation-delay: 0.7s;">
        <h3 style="display: flex; justify-content: space-between; align-items: center;">
            RECENT INVOICES
            <a href="estimate" style="font-size: 0.8rem; color: var(--primary); text-decoration: none; font-weight: 600; font-family: 'Roboto', sans-serif; text-transform: none; letter-spacing: 0;">View all →</a>
        </h3>
        <table class="recent-table">
            <thead>
                <tr>
                    <th>Invoice ID</th>
                    <th>Customer</th>
                    <th>Vehicle</th>
                    <th>Total</th>
                    <th>Tax</th>
                    <th>Date</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="inv" items="${recentInvoices}">
                    <tr>
                        <td><strong style="color: var(--primary);">${inv.estimateId}</strong></td>
                        <td>${inv.userName}</td>
                        <td style="max-width: 150px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">${inv.vehicleInfo}</td>
                        <td style="font-weight: 700; color: var(--dark);">Rs. ${inv.total}</td>
                        <td style="color: var(--text-muted);">Rs. ${inv.tax}</td>
                        <td>${inv.createdDate}</td>
                    </tr>
                </c:forEach>
                <c:if test="${empty recentInvoices}">
                    <tr>
                        <td colspan="6" style="text-align: center; padding: 30px; color: var(--text-muted);">No invoices yet</td>
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

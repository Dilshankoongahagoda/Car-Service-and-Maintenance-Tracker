<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Invoices - Shift Auto Dynamics</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
    <style>
        @keyframes fadeInUp { from { opacity: 0; transform: translateY(25px); } to { opacity: 1; transform: translateY(0); } }

        .stats-row { display: grid; grid-template-columns: repeat(3, 1fr); gap: 18px; margin-bottom: 30px; }
        .stat-card {
            background: white; border-radius: 12px; padding: 22px; text-align: center;
            box-shadow: 0 4px 20px rgba(0,0,0,0.06); border: 1px solid var(--border);
            animation: fadeInUp 0.4s ease forwards; opacity: 0;
        }
        .stat-card:nth-child(1) { animation-delay: 0.05s; }
        .stat-card:nth-child(2) { animation-delay: 0.1s; }
        .stat-card:nth-child(3) { animation-delay: 0.15s; }
        .stat-card .sc-val { font-family: 'Oswald', sans-serif; font-size: 2.5rem; line-height: 1; }
        .stat-card .sc-lbl { font-size: 0.75rem; color: var(--text-muted); text-transform: uppercase; letter-spacing: 1px; font-weight: 600; margin-top: 5px; }

        /* Invoice Cards */
        .invoice-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(360px, 1fr)); gap: 20px; }
        .inv-card {
            background: white; border-radius: 12px; padding: 0;
            box-shadow: 0 4px 20px rgba(0,0,0,0.06); border: 1px solid var(--border);
            animation: fadeInUp 0.5s ease forwards; opacity: 0;
            overflow: hidden; transition: transform 0.3s, box-shadow 0.3s;
        }
        .inv-card:hover { transform: translateY(-4px); box-shadow: 0 10px 30px rgba(0,0,0,0.1); }
        .inv-card:nth-child(1) { animation-delay: 0.1s; }
        .inv-card:nth-child(2) { animation-delay: 0.15s; }
        .inv-card:nth-child(3) { animation-delay: 0.2s; }
        .inv-card:nth-child(4) { animation-delay: 0.25s; }

        .inv-card-top {
            padding: 8px 20px; font-size: 0.72rem; font-weight: 700; letter-spacing: 1px;
            text-transform: uppercase; display: flex; justify-content: space-between; align-items: center;
            background: linear-gradient(90deg, #1a1a2e, #2d3748); color: white;
        }

        .inv-card-body { padding: 20px; }
        .inv-card-body h3 {
            font-family: 'Oswald', sans-serif; font-size: 1.15rem; color: var(--dark);
            margin: 0 0 10px 0; letter-spacing: 0.5px;
        }
        .inv-meta-row { display: flex; justify-content: space-between; margin-bottom: 6px; font-size: 0.85rem; }
        .inv-meta-row .label { color: var(--text-muted); }
        .inv-meta-row .value { font-weight: 500; color: var(--dark); }

        .inv-total {
            display: flex; justify-content: space-between; align-items: center;
            padding: 12px 0; margin-top: 10px; border-top: 1px solid var(--border);
        }
        .inv-total .label { font-weight: 600; color: var(--dark); font-size: 0.9rem; }
        .inv-total .amount { font-family: 'Oswald', sans-serif; font-size: 1.5rem; color: var(--primary); }

        .inv-card-actions { padding: 0 20px 15px; display: flex; gap: 8px; }
        .inv-btn {
            padding: 7px 16px; border-radius: 5px; font-weight: 600; font-size: 0.8rem;
            text-decoration: none; transition: all 0.3s; letter-spacing: 0.3px;
        }
        .inv-btn.view { background: #e3f2fd; color: #1565c0; }
        .inv-btn.view:hover { background: #1565c0; color: white; }
        .inv-btn.edit-btn { background: #fff3e0; color: #e65100; }
        .inv-btn.edit-btn:hover { background: #e65100; color: white; }
        .inv-btn.delete-btn { background: #ffebee; color: #c62828; }
        .inv-btn.delete-btn:hover { background: #c62828; color: white; }

        .empty-box {
            text-align: center; padding: 60px 20px; background: white; border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.06); border: 1px solid var(--border);
        }
        .empty-box h3 { font-family: 'Oswald', sans-serif; color: var(--dark); font-size: 1.5rem; margin-bottom: 10px; }
        .empty-box p { color: var(--text-muted); font-size: 0.95rem; }

        @media (max-width: 768px) {
            .stats-row { grid-template-columns: 1fr; }
            .invoice-grid { grid-template-columns: 1fr; }
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
            <c:if test="${isAdmin}">
                <li><a href="dashboard">ADMIN PORTAL</a></li>
                <li><a href="all_vehicles">REGISTERED VEHICLES</a></li>
                <li><a href="service">MANAGE SERVICES</a></li>
                <li><a href="appointment">APPOINTMENTS</a></li>
                <li><a href="estimate" class="active">ESTIMATES</a></li>
            </c:if>
            <c:if test="${!isAdmin}">
                <li><a href="dashboard">VEHICLES</a></li>
                <li><a href="service">SERVICES</a></li>
                <li><a href="appointment">APPOINTMENTS</a></li>
                <li><a href="reminder">REMINDERS</a></li>
                <li><a href="estimate" class="active">ESTIMATES</a></li>
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

<section class="hero-section" style="height: 300px;">
    <div class="hero-left" style="clip-path: polygon(0 0, 100% 0, 90% 100%, 0% 100%); width: 50%;">
        <span class="hero-subtitle">BILLING CENTER,</span>
        <h1 class="hero-title">
            <c:if test="${isAdmin}">ALL INVOICES</c:if>
            <c:if test="${!isAdmin}">MY INVOICES</c:if>
        </h1>
        <p class="hero-desc">
            <c:if test="${isAdmin}">Manage all customer invoices. Create invoices from completed appointments.</c:if>
            <c:if test="${!isAdmin}">View your service invoices and payment status.</c:if>
        </p>
    </div>
    <div class="hero-right" style="width: 60%;">
        <img src="${pageContext.request.contextPath}/images/autocare_hero.png" alt="Hero background" class="hero-bg-img" />
    </div>
</section>

<div class="page-container">

    <!-- STATS -->
    <div class="stats-row" style="grid-template-columns: 1fr;">
        <div class="stat-card">
            <div class="sc-val" style="color: var(--primary);">${fn:length(estimates)}</div>
            <div class="sc-lbl">Total Invoices</div>
        </div>
    </div>

    <c:if test="${isAdmin}">
        <div style="margin-bottom: 25px; display: flex; justify-content: flex-end;">
            <a href="appointment?action=completed" class="btn-primary-custom" style="padding: 10px 25px; text-decoration: none;">📋 VIEW COMPLETED SERVICES →</a>
        </div>
    </c:if>

    <!-- INVOICE CARDS -->
    <c:if test="${not empty estimates}">
        <div class="invoice-grid">
            <c:forEach var="est" items="${estimates}">
                <div class="inv-card">
                    <div class="inv-card-top">
                        <span>📑 INVOICE</span>
                        <span>${est.createdDate}</span>
                    </div>
                    <div class="inv-card-body">
                        <h3>${est.vehicleInfo}</h3>
                        <div class="inv-meta-row">
                            <span class="label">Invoice No</span>
                            <span class="value">${est.estimateId}</span>
                        </div>
                        <div class="inv-meta-row">
                            <span class="label">Customer</span>
                            <span class="value">${est.userName}</span>
                        </div>
                        <div class="inv-meta-row">
                            <span class="label">Appointment</span>
                            <span class="value">#${est.appointmentId}</span>
                        </div>
                        <div class="inv-total">
                            <span class="label">Total Amount</span>
                            <span class="amount">Rs. ${est.total}</span>
                        </div>
                    </div>
                    <div class="inv-card-actions">
                        <a href="estimate?action=view&id=${est.estimateId}" class="inv-btn view">VIEW INVOICE</a>
                        <c:if test="${isAdmin}">
                            <a href="estimate?action=edit&id=${est.estimateId}" class="inv-btn edit-btn">✏️ EDIT</a>
                            <a href="estimate?action=delete&id=${est.estimateId}" class="inv-btn delete-btn" onclick="return confirm('Delete this invoice?')">DELETE</a>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:if>

    <c:if test="${empty estimates}">
        <div class="empty-box">
            <h3>NO INVOICES YET</h3>
            <c:if test="${isAdmin}">
                <p>Invoices are generated from completed service appointments.</p>
                <a href="appointment?action=completed" style="display: inline-block; margin-top: 15px; padding: 10px 25px; background: var(--primary); color: white; text-decoration: none; border-radius: 6px; font-weight: 600;">VIEW COMPLETED SERVICES →</a>
            </c:if>
            <c:if test="${!isAdmin}">
                <p>Once your service is completed, an invoice will appear here.</p>
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

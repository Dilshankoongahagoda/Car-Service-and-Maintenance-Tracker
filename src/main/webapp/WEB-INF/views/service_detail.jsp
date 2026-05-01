<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${category.name} - Shift Auto Dynamics</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
    <style>
        @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
        @keyframes slideUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }
        @keyframes scaleIn { from { opacity: 0; transform: scale(0.9); } to { opacity: 1; transform: scale(1); } }

        .detail-hero {
            position: relative;
            width: 100%;
            height: 400px;
            overflow: hidden;
            animation: fadeIn 0.8s ease;
        }
        .detail-hero img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            filter: brightness(0.5);
        }
        .detail-hero-content {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            padding: 50px 60px 40px;
            background: linear-gradient(transparent, rgba(0,0,0,0.8));
            animation: slideUp 0.8s ease 0.2s forwards;
            opacity: 0;
        }
        .detail-hero-title {
            font-family: 'Oswald', sans-serif;
            font-size: 3.5rem;
            color: white;
            text-transform: uppercase;
            letter-spacing: 3px;
            margin-bottom: 10px;
        }
        .detail-hero-subtitle {
            font-size: 1.1rem;
            color: rgba(255,255,255,0.85);
            max-width: 600px;
            line-height: 1.6;
        }
        .detail-hero-price {
            display: inline-block;
            margin-top: 15px;
            background: var(--primary);
            color: white;
            padding: 8px 25px;
            border-radius: 25px;
            font-weight: 600;
            font-size: 0.95rem;
            letter-spacing: 1px;
        }

        .detail-content { max-width: 1200px; margin: 0 auto; padding: 50px 30px; }

        .pkg-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 28px;
            margin-top: 30px;
        }
        .pkg-card {
            background: white;
            border-radius: 16px;
            padding: 0;
            box-shadow: 0 4px 20px rgba(0,0,0,0.06);
            border: 1px solid #e8ecf1;
            transition: transform 0.35s ease, box-shadow 0.35s ease, border-color 0.3s;
            animation: scaleIn 0.5s ease forwards;
            opacity: 0;
            position: relative;
            overflow: hidden;
        }
        .pkg-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0;
            width: 5px;
            height: 100%;
            background: var(--primary);
            border-radius: 16px 0 0 16px;
            opacity: 0;
            transition: opacity 0.3s;
        }
        .pkg-card:nth-child(1) { animation-delay: 0.1s; }
        .pkg-card:nth-child(2) { animation-delay: 0.2s; }
        .pkg-card:nth-child(3) { animation-delay: 0.3s; }
        .pkg-card:nth-child(4) { animation-delay: 0.4s; }
        .pkg-card:nth-child(5) { animation-delay: 0.5s; }
        .pkg-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 16px 45px rgba(79,140,255,0.15);
            border-color: var(--primary);
        }
        .pkg-card:hover::before {
            opacity: 1;
        }

        .pkg-card-body {
            padding: 30px 28px;
        }

        .pkg-card-icon {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, var(--primary), #4da6ff);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
            font-weight: bold;
            margin-bottom: 18px;
            box-shadow: 0 4px 15px rgba(79,140,255,0.3);
        }
        .pkg-card h3 {
            font-family: 'Oswald', sans-serif;
            font-size: 1.25rem;
            color: var(--dark);
            margin: 0 0 10px 0;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .pkg-card p {
            font-size: 0.9rem;
            color: #888;
            line-height: 1.6;
            margin: 0 0 20px 0;
        }
        .pkg-price-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: linear-gradient(135deg, #f0f5ff 0%, #e8effc 100%);
            border: 1px solid rgba(79,140,255,0.15);
            padding: 10px 20px;
            border-radius: 12px;
            font-weight: 700;
            color: var(--primary);
            font-size: 0.95rem;
            letter-spacing: 0.3px;
        }
        .pkg-price-badge .price-emoji {
            font-size: 1.1rem;
        }

        .pkg-card .pkg-admin-delete {
            position: absolute;
            top: 10px;
            right: 10px;
            background: rgba(220,50,50,0.1);
            color: red;
            border: 1px solid rgba(220,50,50,0.3);
            padding: 3px 8px;
            border-radius: 4px;
            font-size: 0.7rem;
            text-decoration: none;
            font-weight: bold;
            transition: background 0.3s;
            z-index: 3;
        }
        .pkg-card .pkg-admin-delete:hover { background: rgba(220,50,50,0.2); }
        .pkg-card .pkg-admin-edit {
            position: absolute;
            top: 10px;
            right: 70px;
            background: rgba(0,100,200,0.1);
            color: var(--primary);
            border: 1px solid rgba(0,100,200,0.3);
            padding: 3px 8px;
            border-radius: 4px;
            font-size: 0.7rem;
            text-decoration: none;
            font-weight: bold;
            transition: background 0.3s;
            z-index: 3;
        }
        .pkg-card .pkg-admin-edit:hover { background: rgba(0,100,200,0.2); }

        .back-button {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 25px;
            background: var(--dark);
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-weight: 600;
            font-size: 0.9rem;
            letter-spacing: 1px;
            transition: background 0.3s, transform 0.3s;
            margin-bottom: 30px;
        }
        .back-button:hover { background: var(--primary); transform: translateX(-5px); }

        .detail-section-title {
            font-family: 'Oswald', sans-serif;
            font-size: 2rem;
            color: var(--dark);
            letter-spacing: 2px;
            margin-bottom: 5px;
        }
        .detail-section-line {
            width: 60px;
            height: 4px;
            background: var(--primary);
            border-radius: 2px;
            margin-bottom: 10px;
        }
        .detail-section-subtitle {
            color: #888;
            font-size: 0.95rem;
            margin-bottom: 25px;
        }

        @media (max-width: 768px) {
            .detail-hero { height: 300px; }
            .detail-hero-title { font-size: 2.2rem; }
            .detail-hero-content { padding: 30px 25px; }
            .pkg-grid { grid-template-columns: 1fr; }
            .detail-content { padding: 30px 15px; }
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
                <li><a href="service" class="active">MANAGE SERVICES</a></li>
                <li><a href="appointment">APPOINTMENTS</a></li>
                <li><a href="estimate">ESTIMATES</a></li>
            </c:if>
            <c:if test="${authUser.userRole != 'AdminUser'}">
                <li><a href="dashboard">VEHICLES</a></li>
                <li><a href="service" class="active">SERVICES</a></li>
                <li><a href="appointment">APPOINTMENTS</a></li>
                <li><a href="reminder">REMINDERS</a></li>
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

<!-- HERO BANNER -->
<div class="detail-hero">
    <c:choose>
        <c:when test="${category.name == 'Periodic Maintenance'}">
            <img src="${pageContext.request.contextPath}/images/periodic.png" alt="${category.name}"/>
        </c:when>
        <c:when test="${category.name == 'Mechanical & Engine'}">
            <img src="${pageContext.request.contextPath}/images/mechanical_engine.png" alt="${category.name}"/>
        </c:when>
        <c:when test="${category.name == 'Brakes & Suspension'}">
            <img src="${pageContext.request.contextPath}/images/brakes_suspension.png" alt="${category.name}"/>
        </c:when>
        <c:when test="${category.name == 'Electrical & Hybrid'}">
            <img src="${pageContext.request.contextPath}/images/electrical_hybrid.png" alt="${category.name}"/>
        </c:when>
        <c:when test="${category.name == 'Body & Collision Repair'}">
            <img src="${pageContext.request.contextPath}/images/body_collision.png" alt="${category.name}"/>
        </c:when>
        <c:when test="${category.name == 'Professional Auto Paint'}">
            <img src="${pageContext.request.contextPath}/images/auto_paint.png" alt="${category.name}"/>
        </c:when>
        <c:when test="${category.name == 'Accident Claims'}">
            <img src="${pageContext.request.contextPath}/images/accident_claims.png" alt="${category.name}"/>
        </c:when>
        <c:when test="${category.name == 'Detailing & Car Care'}">
            <img src="${pageContext.request.contextPath}/images/detailing_carcare.png" alt="${category.name}"/>
        </c:when>
        <c:otherwise>
            <img src="${pageContext.request.contextPath}/images/autocare_hero.png" alt="${category.name}"/>
        </c:otherwise>
    </c:choose>
    <div class="detail-hero-content">
        <div class="detail-hero-title">${category.name}</div>
        <div class="detail-hero-subtitle">${category.description}</div>
        <span class="detail-hero-price">Starting Price: ${category.startingPrice}</span>
    </div>
</div>

<!-- DETAIL CONTENT -->
<div class="detail-content">
    <a href="service" class="back-button">&larr; BACK TO SERVICES</a>

    <h2 class="detail-section-title">AVAILABLE PACKAGES</h2>
    <div class="detail-section-line"></div>
    <p class="detail-section-subtitle">Browse our ${category.name} packages below. All prices are in Sri Lankan Rupees (Rs.)</p>

    <c:if test="${not empty packages}">
        <div class="pkg-grid">
            <c:forEach var="pkg" items="${packages}" varStatus="i">
                <div class="pkg-card">
                    <c:if test="${authUser.userRole == 'AdminUser'}">
                        <a href="service?action=editPackage&id=${pkg.id}" class="pkg-admin-edit">EDIT</a>
                        <a href="service?action=deletePackage&id=${pkg.id}" class="pkg-admin-delete" onclick="return confirm('Delete this package?')">DELETE</a>
                    </c:if>
                    <div class="pkg-card-body">
                        <div class="pkg-card-icon">
                            <c:choose>
                                <c:when test="${i.index == 0}">&#9881;</c:when>
                                <c:when test="${i.index == 1}">&#9733;</c:when>
                                <c:when test="${i.index == 2}">&#9889;</c:when>
                                <c:when test="${i.index == 3}">&#10026;</c:when>
                                <c:otherwise>&#10004;</c:otherwise>
                            </c:choose>
                        </div>
                        <h3>${pkg.name}</h3>
                        <c:choose>
                            <c:when test="${not empty pkg.description}">
                                <p>${pkg.description}</p>
                            </c:when>
                            <c:otherwise>
                                <p style="font-style: italic;">Contact us for more details about this premium service.</p>
                            </c:otherwise>
                        </c:choose>
                        <c:if test="${not empty pkg.price}">
                            <div class="pkg-price-badge">
                                <span class="price-emoji">💰</span> ${pkg.price}
                            </div>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:if>
    <c:if test="${empty packages}">
        <div style="text-align: center; padding: 60px; color: var(--text-muted);">
            <h3>No packages available in this category yet.</h3>
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

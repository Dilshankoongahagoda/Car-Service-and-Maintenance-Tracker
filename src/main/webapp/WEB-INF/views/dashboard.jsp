<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>My Dashboard - AutoCare Tracker</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
        </head>

        <body>
            <!-- NAVBAR -->
            <nav class="navbar-custom">
                <div class="navbar-inner">
                    <a href="dashboard" class="nav-brand">
                        <div style="display: flex; align-items: center; gap: 15px;">
                            <img src="${pageContext.request.contextPath}/images/shift_logo.png"
                                alt="Shift Auto Dynamics"
                                style="height: 55px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.1);" />
                            <div
                                style="display: flex; flex-direction: column; justify-content: center; line-height: 1.2;">
                                <span
                                    style="font-family: 'Oswald', sans-serif; font-size: 1.6rem; font-weight: 700; letter-spacing: 1px; color: var(--dark);">SHIFT
                                    AUTO <span style="color: var(--primary);">DYNAMICS</span></span>
                                <span
                                    style="font-size: 0.65rem; font-weight: 600; color: var(--text-muted); letter-spacing: 1px; text-transform: uppercase;">Precision
                                    in Motion | Engineered for Excellence</span>
                            </div>
                        </div>
                    </a>
                    <ul class="nav-links">
                        <c:if test="${authUser.userRole == 'AdminUser'}">
                            <li><a href="dashboard" class="active">ADMIN PORTAL</a></li>
                            <li><a href="all_vehicles">REGISTERED VEHICLES</a></li>
                            <li><a href="service">MANAGE SERVICES</a></li>
                            <li><a href="appointment">APPOINTMENTS</a></li>
                            <li><a href="estimate">ESTIMATES</a></li>
                        </c:if>
                        <c:if test="${authUser.userRole != 'AdminUser'}">
                            <li><a href="dashboard" class="active">VEHICLES</a></li>
                            <li><a href="service">SERVICES</a></li>
                            <li><a href="appointment">APPOINTMENTS</a></li>
                            <li><a href="reminder">REMINDERS</a></li>
                            <li><a href="estimate">ESTIMATES</a></li>
                        </c:if>
                    </ul>
                    <div class="nav-right">
                        <span class="nav-user">Welcome, <strong>${authUser.fullName}</strong></span>
                        <a href="#" onclick="firebaseSignOut()" class="btn-primary-custom"
                            style="padding: 10px 20px;">SIGN OUT &gt;</a>
                    </div>
                    <button class="nav-hamburger" id="navHamburger" aria-label="Toggle navigation">
                        <span></span>
                        <span></span>
                        <span></span>
                    </button>
                </div>
            </nav>

            <!-- HERO SECTION -->
            <section class="hero-section">
                <div class="hero-left">
                    <span class="hero-subtitle animate-fade-in-up delay-100">YOUR VEHICLES,</span>
                    <h1 class="hero-title animate-fade-in-up delay-200">MANAGED<br>BETTER</h1>
                    <p class="hero-desc animate-fade-in-up delay-300">Keep track of your vehicle maintenance, set reminders, and view service history
                        seamlessly. Join the new standard of vehicle care.</p>
                    <a href="vehicle?action=add" class="btn-primary-custom animate-scale-up delay-500">ADD NEW VEHICLE &gt;</a>
                </div>
                <div class="hero-right animate-slide-right">
                    <img src="${pageContext.request.contextPath}/images/autocare_hero.png" alt="Hero background"
                        class="hero-bg-img" />
                    <div class="hero-stats-overlay animate-fade-in delay-600">
                        <div class="stat-box">
                            <div class="small-text">GUARANTEED</div>
                            <div class="big-text">100%</div>
                            <div class="desc-text">CLIENT SATISFACTION</div>
                        </div>
                        <div class="stat-box">
                            <div class="small-text">UNMATCHED EXCELLENCE OF</div>
                            <div class="big-text">10 YEARS</div>
                            <div class="desc-text">SINCE 2016</div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- PAGE CONTENT -->
            <div class="page-container">
                <c:if test="${param.success == 'true'}">
                    <div class="alert-box alert-success" style="margin-bottom: 20px;">
                        ✓ Vehicle added successfully! It is now visible below.
                    </div>
                </c:if>

                <div class="page-header animate-slide-left" style="display: flex; justify-content: space-between; align-items: center;">
                    <h1>MY VEHICLES</h1>
                    <a href="vehicle?action=add" class="btn-primary-custom"
                        style="padding: 10px 20px; text-decoration: none; border-radius: 4px; font-weight: bold;">+ ADD
                        VEHICLE</a>
                </div>

                <div class="card-grid reveal">
                    <c:forEach var="v" items="${myVehicles}">
                        <div class="card">
                            <span class="card-badge ${v.vehicleType == 'Car' ? 'red' : ''}">${v.vehicleType}</span>
                            <h3>${v.make} ${v.model} (${v.year})</h3>
                            <div
                                style="font-size: 1.1rem; font-weight: 700; color: var(--primary); margin-bottom: 20px; font-family:'Oswald',sans-serif; letter-spacing: 1px;">
                                ${v.licensePlate}
                            </div>

                            <div class="card-stat">
                                <span class="label">Current Mileage</span>
                                <span class="val">${v.currentMileage} km</span>
                            </div>
                            <div class="card-stat">
                                <span class="label">Fuel Type</span>
                                <span class="val">${v.fuelType}</span>
                            </div>
                            <div class="card-stat">
                                <span class="label">Details</span>
                                <span class="val"
                                    style="font-size: 0.85rem; max-width: 150px; text-align:right;">${v.specificData}</span>
                            </div>

                            <div class="card-actions">
                                <a href="vehicle?action=delete&id=${v.vehicleId}" class="btn-sm-danger"
                                    onclick="return confirm('Delete this vehicle?')">Delete</a>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <c:if test="${empty myVehicles}">
                    <div class="empty-state animate-scale-up">
                        <img src="${pageContext.request.contextPath}/images/autocare_hero.png"
                            style="width: 100px; height: 100px; border-radius:50%; object-fit:cover; margin-bottom:20px; border:3px solid var(--border);" />
                        <h3>No Vehicles Yet</h3>
                        <p style="color:var(--text-muted); margin-bottom:20px;">Add your first vehicle below.</p>
                        <a href="vehicle?action=add" class="btn-primary-custom">ADD NEW VEHICLE</a>
                    </div>
                </c:if>
            </div>

            <!-- ========== OUR SERVICES SECTION (PREMIUM 8-CATEGORY DESIGN) ========== -->
            <style>
                .services-wrapper {
                    background: linear-gradient(135deg, #fdfbfb 0%, #ebedee 100%);
                    padding: 100px 0;
                    margin-top: 40px;
                }

                .services-title {
                    font-family: 'Oswald', sans-serif;
                    font-size: 3rem;
                    text-transform: uppercase;
                    color: #111;
                    margin-bottom: 30px;
                    text-align: center;
                    letter-spacing: 1px;
                    font-weight: 700;
                    position: relative;
                }

                .services-title .highlight {
                    color: var(--primary);
                    position: relative;
                    display: inline-block;
                }

                .services-title .highlight::after {
                    content: '';
                    position: absolute;
                    bottom: -5px;
                    left: 0;
                    width: 100%;
                    height: 6px;
                    background: var(--primary);
                    opacity: 0.2;
                    border-radius: 3px;
                }

                .services-subtitle {
                    text-align: center;
                    font-family: 'Roboto', sans-serif;
                    color: #777;
                    font-size: 1.1rem;
                    margin-bottom: 60px;
                    max-width: 600px;
                    margin-left: auto;
                    margin-right: auto;
                    line-height: 1.6;
                }

                .services-grid {
                    display: grid;
                    grid-template-columns: repeat(4, 1fr);
                    gap: 28px;
                    text-align: left;
                }

                .service-card {
                    background: #fff;
                    border-radius: 18px;
                    overflow: hidden;
                    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.06);
                    transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
                    border: 1px solid rgba(0, 0, 0, 0.04);
                    position: relative;
                    top: 0;
                    text-decoration: none;
                    display: block;
                }

                .service-card:hover {
                    top: -12px;
                    box-shadow: 0 22px 45px rgba(0, 0, 0, 0.13);
                    border-color: var(--primary);
                }

                .service-img-wrapper {
                    overflow: hidden;
                    position: relative;
                    height: 190px;
                    width: 100%;
                }

                .service-img-wrapper img {
                    width: 100%;
                    height: 100%;
                    object-fit: cover;
                    transition: transform 0.7s ease;
                }

                .service-card:hover .service-img-wrapper img {
                    transform: scale(1.1);
                }

                .service-img-overlay {
                    position: absolute;
                    inset: 0;
                    background: linear-gradient(to top, rgba(0, 0, 0, 0.5) 0%, transparent 60%);
                    opacity: 0.6;
                    transition: opacity 0.3s;
                }

                .service-card:hover .service-img-overlay {
                    opacity: 0.3;
                }

                .service-number-badge {
                    position: absolute;
                    top: 14px;
                    left: 14px;
                    width: 38px;
                    height: 38px;
                    background: var(--primary);
                    color: white;
                    border-radius: 10px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-family: 'Oswald', sans-serif;
                    font-weight: 700;
                    font-size: 1.1rem;
                    z-index: 2;
                    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.25);
                }

                .service-category-icon {
                    position: absolute;
                    bottom: 14px;
                    right: 14px;
                    width: 42px;
                    height: 42px;
                    background: rgba(255, 255, 255, 0.95);
                    border-radius: 50%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 1.3rem;
                    z-index: 2;
                    box-shadow: 0 3px 10px rgba(0, 0, 0, 0.15);
                    transition: transform 0.3s;
                }

                .service-card:hover .service-category-icon {
                    transform: scale(1.15) rotate(5deg);
                }

                .service-content {
                    padding: 28px 24px;
                    background: #fff;
                    position: relative;
                }

                .service-card h3 {
                    color: var(--primary);
                    font-family: 'Oswald', sans-serif;
                    font-size: 1.3rem;
                    text-transform: uppercase;
                    margin-bottom: 18px;
                    letter-spacing: 0.5px;
                    display: flex;
                    align-items: center;
                    gap: 10px;
                }

                .service-card h3::before {
                    content: '';
                    display: block;
                    width: 4px;
                    height: 22px;
                    background: var(--primary);
                    border-radius: 4px;
                    flex-shrink: 0;
                }

                .service-list {
                    list-style: none;
                    padding: 0;
                    margin: 0;
                }

                .service-list li {
                    font-family: 'Roboto', sans-serif;
                    color: #555;
                    margin-bottom: 10px;
                    position: relative;
                    padding-left: 22px;
                    font-weight: 500;
                    font-size: 0.88rem;
                    line-height: 1.45;
                    transition: transform 0.3s, color 0.3s;
                }

                .service-card:hover .service-list li {
                    color: #333;
                }

                .service-list li::before {
                    content: '❖';
                    position: absolute;
                    left: 0;
                    top: 1px;
                    color: var(--primary);
                    font-size: 0.7rem;
                    opacity: 0.7;
                    transition: transform 0.3s;
                }

                .service-card:hover .service-list li {
                    transform: translateX(3px);
                }

                .highlight-text {
                    color: var(--primary);
                }

                @media (max-width: 1200px) {
                    .services-grid {
                        grid-template-columns: repeat(3, 1fr);
                        gap: 24px;
                    }
                }

                @media (max-width: 900px) {
                    .services-grid {
                        grid-template-columns: repeat(2, 1fr);
                        gap: 20px;
                    }
                }

                @media (max-width: 600px) {
                    .services-grid {
                        grid-template-columns: 1fr;
                        gap: 20px;
                    }

                    .services-title {
                        font-size: 2rem;
                    }

                    .service-img-wrapper {
                        height: 200px;
                    }
                }
            </style>

            <div id="services" class="services-wrapper">
                <div class="page-container" style="margin-top: 0; margin-bottom: 0;">
                    <h2 class="services-title reveal">
                        Committed to provide <span class="highlight">the best care</span><br /> with supervision and
                        trust
                    </h2>
                    <p class="services-subtitle reveal">From routine maintenance to major repairs — we offer a full spectrum of automotive services with certified expertise</p>

                    <div class="services-grid">

                        <!-- 01. Periodic Maintenance -->
                        <a href="service_detail?category=Periodic Maintenance" class="service-card reveal reveal-delay-1">
                            <div class="service-img-wrapper">
                                <span class="service-number-badge">01</span>
                                <img src="${pageContext.request.contextPath}/images/periodic.png"
                                    alt="Periodic Maintenance">
                                <div class="service-img-overlay"></div>
                                <span class="service-category-icon">🔧</span>
                            </div>
                            <div class="service-content">
                                <h3>Periodic Maintenance</h3>
                                <ul class="service-list">
                                    <li>Engine Oil Change</li>
                                    <li>Oil Filter Replacement</li>
                                    <li>Air & Cabin Filter Cleaning</li>
                                    <li>Full Lubrication Service</li>
                                    <li>Fluid Level Checks <span class="highlight-text">(Coolant, Brake, Power Steering)</span></li>
                                </ul>
                            </div>
                        </a>

                        <!-- 02. Mechanical & Engine -->
                        <a href="service_detail?category=Mechanical %26 Engine" class="service-card reveal reveal-delay-2">
                            <div class="service-img-wrapper">
                                <span class="service-number-badge">02</span>
                                <img src="${pageContext.request.contextPath}/images/mechanical_engine.png"
                                    alt="Mechanical & Engine">
                                <div class="service-img-overlay"></div>
                                <span class="service-category-icon">⚙️</span>
                            </div>
                            <div class="service-content">
                                <h3>Mechanical & Engine</h3>
                                <ul class="service-list">
                                    <li>Engine Tune-up</li>
                                    <li>Spark Plug Replacement</li>
                                    <li>Fuel Injector Cleaning</li>
                                    <li>Timing Belt/Chain Replacement</li>
                                    <li>Gearbox/Transmission Service</li>
                                    <li>Cooling System Repair</li>
                                </ul>
                            </div>
                        </a>

                        <!-- 03. Brakes & Suspension -->
                        <a href="service_detail?category=Brakes %26 Suspension" class="service-card reveal reveal-delay-3">
                            <div class="service-img-wrapper">
                                <span class="service-number-badge">03</span>
                                <img src="${pageContext.request.contextPath}/images/brakes_suspension.png"
                                    alt="Brakes & Suspension">
                                <div class="service-img-overlay"></div>
                                <span class="service-category-icon">🛞</span>
                            </div>
                            <div class="service-content">
                                <h3>Brakes & Suspension</h3>
                                <ul class="service-list">
                                    <li>Brake Pad & Disc Replacement</li>
                                    <li>Shock Absorber Repair</li>
                                    <li>Bushing Replacement</li>
                                    <li>Wheel Alignment & Balancing</li>
                                    <li>Steering Rack Repair</li>
                                    <li>Brake Fluid Flush</li>
                                </ul>
                            </div>
                        </a>

                        <!-- 04. Electrical & Hybrid -->
                        <a href="service_detail?category=Electrical %26 Hybrid" class="service-card reveal reveal-delay-4">
                            <div class="service-img-wrapper">
                                <span class="service-number-badge">04</span>
                                <img src="${pageContext.request.contextPath}/images/electrical_hybrid.png"
                                    alt="Electrical & Hybrid">
                                <div class="service-img-overlay"></div>
                                <span class="service-category-icon">⚡</span>
                            </div>
                            <div class="service-content">
                                <h3>Electrical & Hybrid</h3>
                                <ul class="service-list">
                                    <li>Computerized Scanning <span class="highlight-text">(OBD Diagnostics)</span></li>
                                    <li>Battery Health Test & Replacement</li>
                                    <li>Hybrid Battery Service</li>
                                    <li>Alternator & Starter Motor Repair</li>
                                    <li>AC Gas Refill</li>
                                </ul>
                            </div>
                        </a>

                        <!-- 05. Body & Collision Repair -->
                        <a href="service_detail?category=Body %26 Collision Repair" class="service-card reveal reveal-delay-1">
                            <div class="service-img-wrapper">
                                <span class="service-number-badge">05</span>
                                <img src="${pageContext.request.contextPath}/images/body_collision.png"
                                    alt="Body & Collision Repair">
                                <div class="service-img-overlay"></div>
                                <span class="service-category-icon">🛠️</span>
                            </div>
                            <div class="service-content">
                                <h3>Body & Collision Repair</h3>
                                <ul class="service-list">
                                    <li>Denting & Tinkering</li>
                                    <li>Chassis Straightening</li>
                                    <li>Plastic & Bumper Repair</li>
                                    <li>Windscreen & Glass Replacement</li>
                                    <li>Welding Services <span class="highlight-text">(MIG/Arc)</span></li>
                                </ul>
                            </div>
                        </a>

                        <!-- 06. Professional Auto Paint -->
                        <a href="service_detail?category=Professional Auto Paint" class="service-card reveal reveal-delay-2">
                            <div class="service-img-wrapper">
                                <span class="service-number-badge">06</span>
                                <img src="${pageContext.request.contextPath}/images/auto_paint.png"
                                    alt="Professional Auto Paint">
                                <div class="service-img-overlay"></div>
                                <span class="service-category-icon">🎨</span>
                            </div>
                            <div class="service-content">
                                <h3>Professional Auto Paint</h3>
                                <ul class="service-list">
                                    <li>Full Body Respray</li>
                                    <li>Panel Painting <span class="highlight-text">(Doors, Hood, Bumpers)</span></li>
                                    <li>Scratch & Scuff Touch-ups</li>
                                    <li>Oven Baked Painting</li>
                                    <li>Computerized Color Matching</li>
                                </ul>
                            </div>
                        </a>

                        <!-- 07. Accident Claims -->
                        <a href="service_detail?category=Accident Claims" class="service-card reveal reveal-delay-3">
                            <div class="service-img-wrapper">
                                <span class="service-number-badge">07</span>
                                <img src="${pageContext.request.contextPath}/images/accident_claims.png"
                                    alt="Accident Claims">
                                <div class="service-img-overlay"></div>
                                <span class="service-category-icon">📋</span>
                            </div>
                            <div class="service-content">
                                <h3>Accident Claims</h3>
                                <ul class="service-list">
                                    <li>Accident Damage Estimation</li>
                                    <li>Insurance Coordination</li>
                                    <li>Claim Documentation & Processing</li>
                                    <li>Post-Accident Safety Inspections</li>
                                </ul>
                            </div>
                        </a>

                        <!-- 08. Detailing & Car Care -->
                        <a href="service_detail?category=Detailing %26 Car Care" class="service-card reveal reveal-delay-4">
                            <div class="service-img-wrapper">
                                <span class="service-number-badge">08</span>
                                <img src="${pageContext.request.contextPath}/images/detailing_carcare.png"
                                    alt="Detailing & Car Care">
                                <div class="service-img-overlay"></div>
                                <span class="service-category-icon">✨</span>
                            </div>
                            <div class="service-content">
                                <h3>Detailing & Car Care</h3>
                                <ul class="service-list">
                                    <li>Exterior Body Wash & Vacuum</li>
                                    <li>Interior Deep Cleaning <span class="highlight-text">(Seats/Carpets)</span></li>
                                    <li>Engine Degreasing</li>
                                    <li>Cut & Polish</li>
                                    <li>Ceramic Coating</li>
                                    <li>Under-carriage Protection</li>
                                </ul>
                            </div>
                        </a>

                    </div>
                </div>
            </div>

            <!-- ========== PARTNERS SECTION ========== -->
            <style>
                .partners-section {
                    display: flex;
                    background: white;
                    border-top: 1px solid var(--border);
                    border-bottom: 1px solid var(--border);
                    overflow: hidden;
                }

                .partners-label {
                    background: var(--primary);
                    color: white;
                    padding: 30px;
                    width: 30%;
                    min-width: 280px;
                    display: flex;
                    align-items: center;
                    justify-content: flex-end;
                    clip-path: polygon(0 0, 100% 0, 90% 100%, 0% 100%);
                    z-index: 2;
                    flex-shrink: 0;
                }

                .partners-label h3 {
                    font-family: 'Oswald', sans-serif;
                    margin: 0;
                    font-size: 1.1rem;
                    letter-spacing: 1px;
                    margin-right: 30px;
                }

                .partners-track-wrapper {
                    width: 70%;
                    overflow: hidden;
                    position: relative;
                    display: flex;
                    align-items: center;
                }

                .partners-track-wrapper::before,
                .partners-track-wrapper::after {
                    content: '';
                    position: absolute;
                    top: 0;
                    bottom: 0;
                    width: 60px;
                    z-index: 2;
                    pointer-events: none;
                }

                .partners-track-wrapper::before {
                    left: 0;
                    background: linear-gradient(to right, white 0%, transparent 100%);
                }

                .partners-track-wrapper::after {
                    right: 0;
                    background: linear-gradient(to left, white 0%, transparent 100%);
                }

                .partners-track {
                    display: flex;
                    align-items: center;
                    gap: 60px;
                    animation: partnersScroll 25s linear infinite;
                    width: max-content;
                }

                .partners-track:hover {
                    animation-play-state: paused;
                }

                .partner-logo {
                    flex-shrink: 0;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    height: 45px;
                    opacity: 0.7;
                    transition: opacity 0.3s, transform 0.3s;
                    cursor: default;
                }

                .partner-logo:hover {
                    opacity: 1;
                    transform: scale(1.1);
                }

                .partner-logo svg {
                    height: 40px;
                    width: auto;
                }

                @keyframes partnersScroll {
                    0% {
                        transform: translateX(0);
                    }

                    100% {
                        transform: translateX(-50%);
                    }
                }

                .partners-dots {
                    display: flex;
                    justify-content: center;
                    gap: 6px;
                    padding: 10px 0 12px;
                    background: white;
                    border-bottom: 1px solid var(--border);
                }

                .partners-dots span {
                    width: 8px;
                    height: 8px;
                    border-radius: 50%;
                    background: #ddd;
                    display: inline-block;
                    transition: background 0.3s;
                }

                .partners-dots span.active {
                    background: var(--primary);
                }
                @media (max-width: 768px) {
                    .partners-section { flex-direction: column; }
                    .partners-label {
                        width: 100%;
                        min-width: 0;
                        clip-path: none;
                        justify-content: center;
                        padding: 16px 20px;
                    }
                    .partners-label h3 { margin-right: 0; text-align: center; }
                    .partners-track-wrapper { width: 100%; }
                }
            </style>
            <div class="partners-section reveal">
                <div class="partners-label">
                    <h3>PREMIUM AUTOCARE <span style="font-weight: 400;">SERVICE PROVIDER</span></h3>
                </div>
                <div class="partners-track-wrapper">
                    <div class="partners-track">
                        <!-- Set 1 -->
                        <div class="partner-logo">
                            <svg viewBox="0 0 160 50" xmlns="http://www.w3.org/2000/svg">
                                <circle cx="20" cy="25" r="18" fill="#C8102E" opacity="0.9" />
                                <path d="M12 25 L20 17 L28 25 L20 33Z" fill="white" />
                                <text x="44" y="32" font-family="'Oswald',sans-serif" font-size="18" font-weight="700"
                                    fill="#222">AUTO<tspan fill="#C8102E">SHIELD</tspan></text>
                            </svg>
                        </div>
                        <div class="partner-logo">
                            <svg viewBox="0 0 140 50" xmlns="http://www.w3.org/2000/svg">
                                <rect x="2" y="10" width="30" height="30" rx="4" fill="#006B3F" />
                                <text x="8" y="32" font-family="Arial" font-size="16" font-weight="900"
                                    fill="white">C</text>
                                <text x="38" y="33" font-family="'Oswald',sans-serif" font-size="17" font-weight="700"
                                    fill="#006B3F">Castrol</text>
                                <text x="38" y="44" font-family="Arial" font-size="8" fill="#C8102E"
                                    font-weight="700">LUBRICANTS</text>
                            </svg>
                        </div>
                        <div class="partner-logo">
                            <svg viewBox="0 0 180 50" xmlns="http://www.w3.org/2000/svg">
                                <text x="5" y="33" font-family="'Oswald',sans-serif" font-size="20" font-weight="700"
                                    fill="#1a1a1a" letter-spacing="3">CAUSEWAY</text>
                                <text x="5" y="45" font-family="Arial" font-size="10" fill="#C8102E" font-weight="700"
                                    letter-spacing="5">PAINTS</text>
                            </svg>
                        </div>
                        <div class="partner-logo">
                            <svg viewBox="0 0 160 50" xmlns="http://www.w3.org/2000/svg">
                                <path d="M5 15 Q15 5 25 15 Q35 5 45 15 L45 40 L5 40Z" fill="#2B5797" opacity="0.15" />
                                <text x="8" y="34" font-family="'Oswald',sans-serif" font-size="16" font-weight="700"
                                    fill="#2B5797">De</text>
                                <text x="30" y="34" font-family="'Oswald',sans-serif" font-size="16" font-weight="700"
                                    fill="#1a1a1a">Beer</text>
                                <text x="75" y="28" font-family="Arial" font-size="8" fill="#666"
                                    font-weight="600">REFINISH</text>
                            </svg>
                        </div>
                        <div class="partner-logo">
                            <svg viewBox="0 0 130 50" xmlns="http://www.w3.org/2000/svg">
                                <text x="5" y="35" font-family="'Oswald',sans-serif" font-size="24" font-weight="700"
                                    fill="#1a1a1a">GYEON</text>
                                <rect x="5" y="40" width="85" height="3" fill="#C8102E" />
                            </svg>
                        </div>
                        <div class="partner-logo">
                            <svg viewBox="0 0 130 50" xmlns="http://www.w3.org/2000/svg">
                                <text x="5" y="30" font-family="'Oswald',sans-serif" font-size="22" font-weight="700"
                                    fill="#C8102E">Mobil</text>
                                <text x="80" y="32" font-family="'Oswald',sans-serif" font-size="26" font-weight="700"
                                    fill="#1976D2">1</text>
                            </svg>
                        </div>
                        <div class="partner-logo">
                            <svg viewBox="0 0 160 50" xmlns="http://www.w3.org/2000/svg">
                                <rect x="2" y="8" width="8" height="35" fill="#1976D2" rx="2" />
                                <text x="16" y="32" font-family="'Oswald',sans-serif" font-size="17" font-weight="700"
                                    fill="#1976D2">NIPPON</text>
                                <text x="100" y="32" font-family="'Oswald',sans-serif" font-size="17" font-weight="700"
                                    fill="#C8102E">PAINT</text>
                            </svg>
                        </div>
                        <div class="partner-logo">
                            <svg viewBox="0 0 140 50" xmlns="http://www.w3.org/2000/svg">
                                <text x="5" y="32" font-family="Georgia,serif" font-size="22" font-style="italic"
                                    font-weight="700" fill="#333">Premier</text>
                                <line x1="5" y1="38" x2="120" y2="38" stroke="#C8102E" stroke-width="2" />
                            </svg>
                        </div>
                        <!-- Set 2 (duplicate for seamless loop) -->
                        <div class="partner-logo">
                            <svg viewBox="0 0 160 50" xmlns="http://www.w3.org/2000/svg">
                                <circle cx="20" cy="25" r="18" fill="#C8102E" opacity="0.9" />
                                <path d="M12 25 L20 17 L28 25 L20 33Z" fill="white" />
                                <text x="44" y="32" font-family="'Oswald',sans-serif" font-size="18" font-weight="700"
                                    fill="#222">AUTO<tspan fill="#C8102E">SHIELD</tspan></text>
                            </svg>
                        </div>
                        <div class="partner-logo">
                            <svg viewBox="0 0 140 50" xmlns="http://www.w3.org/2000/svg">
                                <rect x="2" y="10" width="30" height="30" rx="4" fill="#006B3F" />
                                <text x="8" y="32" font-family="Arial" font-size="16" font-weight="900"
                                    fill="white">C</text>
                                <text x="38" y="33" font-family="'Oswald',sans-serif" font-size="17" font-weight="700"
                                    fill="#006B3F">Castrol</text>
                                <text x="38" y="44" font-family="Arial" font-size="8" fill="#C8102E"
                                    font-weight="700">LUBRICANTS</text>
                            </svg>
                        </div>
                        <div class="partner-logo">
                            <svg viewBox="0 0 180 50" xmlns="http://www.w3.org/2000/svg">
                                <text x="5" y="33" font-family="'Oswald',sans-serif" font-size="20" font-weight="700"
                                    fill="#1a1a1a" letter-spacing="3">CAUSEWAY</text>
                                <text x="5" y="45" font-family="Arial" font-size="10" fill="#C8102E" font-weight="700"
                                    letter-spacing="5">PAINTS</text>
                            </svg>
                        </div>
                        <div class="partner-logo">
                            <svg viewBox="0 0 160 50" xmlns="http://www.w3.org/2000/svg">
                                <path d="M5 15 Q15 5 25 15 Q35 5 45 15 L45 40 L5 40Z" fill="#2B5797" opacity="0.15" />
                                <text x="8" y="34" font-family="'Oswald',sans-serif" font-size="16" font-weight="700"
                                    fill="#2B5797">De</text>
                                <text x="30" y="34" font-family="'Oswald',sans-serif" font-size="16" font-weight="700"
                                    fill="#1a1a1a">Beer</text>
                                <text x="75" y="28" font-family="Arial" font-size="8" fill="#666"
                                    font-weight="600">REFINISH</text>
                            </svg>
                        </div>
                        <div class="partner-logo">
                            <svg viewBox="0 0 130 50" xmlns="http://www.w3.org/2000/svg">
                                <text x="5" y="35" font-family="'Oswald',sans-serif" font-size="24" font-weight="700"
                                    fill="#1a1a1a">GYEON</text>
                                <rect x="5" y="40" width="85" height="3" fill="#C8102E" />
                            </svg>
                        </div>
                        <div class="partner-logo">
                            <svg viewBox="0 0 130 50" xmlns="http://www.w3.org/2000/svg">
                                <text x="5" y="30" font-family="'Oswald',sans-serif" font-size="22" font-weight="700"
                                    fill="#C8102E">Mobil</text>
                                <text x="80" y="32" font-family="'Oswald',sans-serif" font-size="26" font-weight="700"
                                    fill="#1976D2">1</text>
                            </svg>
                        </div>
                        <div class="partner-logo">
                            <svg viewBox="0 0 160 50" xmlns="http://www.w3.org/2000/svg">
                                <rect x="2" y="8" width="8" height="35" fill="#1976D2" rx="2" />
                                <text x="16" y="32" font-family="'Oswald',sans-serif" font-size="17" font-weight="700"
                                    fill="#1976D2">NIPPON</text>
                                <text x="100" y="32" font-family="'Oswald',sans-serif" font-size="17" font-weight="700"
                                    fill="#C8102E">PAINT</text>
                            </svg>
                        </div>
                        <div class="partner-logo">
                            <svg viewBox="0 0 140 50" xmlns="http://www.w3.org/2000/svg">
                                <text x="5" y="32" font-family="Georgia,serif" font-size="22" font-style="italic"
                                    font-weight="700" fill="#333">Premier</text>
                                <line x1="5" y1="38" x2="120" y2="38" stroke="#C8102E" stroke-width="2" />
                            </svg>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Partner Dots -->
            <div class="partners-dots">
                <span
                    class="active"></span><span></span><span></span><span></span><span></span><span></span><span></span><span></span><span></span><span></span><span></span><span></span>
            </div>


            <!-- ========== CERTIFIED SERVICE CENTER SECTION ========== -->
            <style>
                .certified-section {
                    background: linear-gradient(180deg, #f8f9fa 0%, #ffffff 100%);
                    padding: 80px 0 60px;
                }

                .certified-container {
                    max-width: 1400px;
                    margin: 0 auto;
                    padding: 0 40px;
                }

                .certified-top {
                    display: flex;
                    align-items: center;
                    gap: 60px;
                    margin-bottom: 60px;
                }

                .certified-badge {
                    flex-shrink: 0;
                    width: 260px;
                    height: 280px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    animation: certBadgePulse 3s ease-in-out infinite;
                }

                @keyframes certBadgePulse {

                    0%,
                    100% {
                        transform: scale(1);
                    }

                    50% {
                        transform: scale(1.03);
                    }
                }

                .certified-info {
                    flex: 1;
                }

                .certified-info h2 {
                    font-family: 'Oswald', sans-serif;
                    font-size: 2.2rem;
                    color: var(--primary);
                    text-transform: uppercase;
                    margin-bottom: 20px;
                    letter-spacing: 1px;
                }

                .certified-info p {
                    font-size: 1rem;
                    color: #555;
                    line-height: 1.8;
                    margin-bottom: 25px;
                    max-width: 650px;
                }

                .certified-tagline {
                    font-family: 'Oswald', sans-serif;
                    text-transform: uppercase;
                    letter-spacing: 1.5px;
                    line-height: 1.8;
                }

                .certified-tagline .line1 {
                    font-size: 1.3rem;
                    color: var(--primary);
                    font-weight: 600;
                }

                .certified-tagline .line2 {
                    font-size: 1.15rem;
                    color: var(--dark);
                    font-weight: 700;
                }

                .cert-logos-grid {
                    display: grid;
                    grid-template-columns: repeat(4, 1fr);
                    gap: 30px;
                }

                .cert-logo-card {
                    background: white;
                    border: 1px solid #e8e8e8;
                    border-radius: 8px;
                    padding: 30px 20px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    min-height: 130px;
                    transition: transform 0.3s, box-shadow 0.3s, border-color 0.3s;
                    cursor: default;
                }

                .cert-logo-card:hover {
                    transform: translateY(-5px);
                    box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
                    border-color: var(--primary);
                }

                .cert-logo-card svg {
                    max-height: 70px;
                    width: auto;
                }

                @media (max-width: 992px) {
                    .certified-top {
                        flex-direction: column;
                        text-align: center;
                        gap: 30px;
                    }

                    .certified-info p {
                        margin-left: auto;
                        margin-right: auto;
                    }

                    .cert-logos-grid {
                        grid-template-columns: repeat(2, 1fr);
                    }
                }

                @media (max-width: 576px) {
                    .cert-logos-grid {
                        grid-template-columns: 1fr 1fr;
                        gap: 15px;
                    }

                    .certified-badge {
                        width: 180px;
                        height: 200px;
                    }
                }
            </style>
            <div class="certified-section">
                <div class="certified-container">
                    <div class="certified-top">
                        <!-- Shield Badge -->
                        <div class="certified-badge">
                            <svg viewBox="0 0 220 250" xmlns="http://www.w3.org/2000/svg">
                                <defs>
                                    <linearGradient id="shieldGradD" x1="0%" y1="0%" x2="0%" y2="100%">
                                        <stop offset="0%" style="stop-color:#4FC3F7;stop-opacity:1" />
                                        <stop offset="100%" style="stop-color:#1976D2;stop-opacity:1" />
                                    </linearGradient>
                                    <linearGradient id="shieldInnerD" x1="0%" y1="0%" x2="0%" y2="100%">
                                        <stop offset="0%" style="stop-color:#E3F2FD;stop-opacity:1" />
                                        <stop offset="100%" style="stop-color:#BBDEFB;stop-opacity:1" />
                                    </linearGradient>
                                    <linearGradient id="bannerGradD" x1="0%" y1="0%" x2="100%" y2="0%">
                                        <stop offset="0%" style="stop-color:#E65100;stop-opacity:1" />
                                        <stop offset="100%" style="stop-color:#FF8F00;stop-opacity:1" />
                                    </linearGradient>
                                </defs>
                                <path d="M110 10 L200 50 L200 140 Q200 210 110 240 Q20 210 20 140 L20 50 Z"
                                    fill="url(#shieldGradD)" />
                                <path d="M110 25 L190 60 L190 140 Q190 200 110 228 Q30 200 30 140 L30 60 Z"
                                    fill="url(#shieldInnerD)" />
                                <text x="110" y="85" text-anchor="middle" font-family="'Oswald',sans-serif"
                                    font-size="28" font-weight="700" fill="#1565C0">SHIFT AUTO</text>
                                <text x="110" y="120" text-anchor="middle" font-family="'Oswald',sans-serif"
                                    font-size="38" font-weight="900" fill="#0D47A1">PAL</text>
                                <path d="M15 160 L205 160 L195 185 L205 210 L15 210 L25 185 Z"
                                    fill="url(#bannerGradD)" />
                                <text x="110" y="192" text-anchor="middle" font-family="'Oswald',sans-serif"
                                    font-size="20" font-weight="700" fill="white" letter-spacing="3">CERTIFIED</text>
                                <circle cx="110" cy="138" r="12" fill="#1976D2" opacity="0.2" />
                                <path d="M102 138 L108 144 L118 132" stroke="#0D47A1" stroke-width="3" fill="none"
                                    stroke-linecap="round" stroke-linejoin="round" />
                            </svg>
                        </div>
                        <div class="certified-info">
                            <h2>Shift Auto Pal Certified Service Center</h2>
                            <p>At Shift Auto Dynamics, we are an independent service and repair center with years of
                                trusted experience. As a certified shop, you can be sure you're getting high-quality
                                repairs and service at a fair price. We are committed to providing our clients with the
                                most professional repair service, so you can count on us for any car repairs you may
                                need. We undergo thorough assessments to ensure we meet the highest standards for
                                training, equipment, and expertise in auto repair.</p>
                            <div class="certified-tagline">
                                <div class="line1">We Provide Fast Quotes And Fair Pricing</div>
                                <div class="line2">Expert Service And Diagnostics From Certified Mechanics</div>
                            </div>
                        </div>
                    </div>
                    <div class="cert-logos-grid">
                        <div class="cert-logo-card">
                            <svg viewBox="0 0 180 80" xmlns="http://www.w3.org/2000/svg">
                                <circle cx="90" cy="35" r="28" fill="none" stroke="#1976D2" stroke-width="3" />
                                <circle cx="90" cy="35" r="22" fill="none" stroke="#C8102E" stroke-width="2" />
                                <text x="90" y="33" text-anchor="middle" font-family="'Oswald',sans-serif"
                                    font-size="10" font-weight="700" fill="#1976D2">TECH</text>
                                <text x="90" y="44" text-anchor="middle" font-family="'Oswald',sans-serif" font-size="9"
                                    font-weight="600" fill="#C8102E">NET</text>
                                <text x="90" y="72" text-anchor="middle" font-family="Arial" font-size="7"
                                    font-weight="600" fill="#666" letter-spacing="1">PROFESSIONAL</text>
                            </svg>
                        </div>
                        <div class="cert-logo-card">
                            <svg viewBox="0 0 180 80" xmlns="http://www.w3.org/2000/svg">
                                <rect x="50" y="8" width="80" height="50" rx="6" fill="#1976D2" />
                                <text x="90" y="30" text-anchor="middle" font-family="'Oswald',sans-serif"
                                    font-size="16" font-weight="700" fill="white">ASE</text>
                                <line x1="60" y1="36" x2="120" y2="36" stroke="rgba(255,255,255,0.4)"
                                    stroke-width="1" />
                                <text x="90" y="50" text-anchor="middle" font-family="Arial" font-size="8"
                                    font-weight="700" fill="#FFD600">CERTIFIED</text>
                                <text x="90" y="72" text-anchor="middle" font-family="Arial" font-size="6"
                                    font-weight="500" fill="#999">™</text>
                            </svg>
                        </div>
                        <div class="cert-logo-card">
                            <svg viewBox="0 0 180 80" xmlns="http://www.w3.org/2000/svg">
                                <ellipse cx="90" cy="32" rx="45" ry="25" fill="none" stroke="#1565C0"
                                    stroke-width="2.5" />
                                <text x="90" y="30" text-anchor="middle" font-family="'Oswald',sans-serif"
                                    font-size="14" font-weight="700" fill="#1565C0">NASTF</text>
                                <text x="90" y="42" text-anchor="middle" font-family="Arial" font-size="5"
                                    font-weight="600" fill="#C8102E" letter-spacing="0.5">NATIONAL AUTOMOTIVE
                                    SERVICE</text>
                                <text x="90" y="72" text-anchor="middle" font-family="Arial" font-size="7"
                                    font-weight="600" fill="#666">TASK FORCE</text>
                            </svg>
                        </div>
                        <div class="cert-logo-card">
                            <svg viewBox="0 0 180 80" xmlns="http://www.w3.org/2000/svg">
                                <text x="90" y="38" text-anchor="middle" font-family="'Oswald',sans-serif"
                                    font-size="26" font-weight="900" fill="#1976D2" letter-spacing="2">MACS</text>
                                <rect x="35" y="44" width="110" height="2" fill="#C8102E" />
                                <text x="90" y="58" text-anchor="middle" font-family="Arial" font-size="5.5"
                                    font-weight="600" fill="#666" letter-spacing="0.8">MOBILE AIR CONDITIONING</text>
                                <text x="90" y="68" text-anchor="middle" font-family="Arial" font-size="5.5"
                                    font-weight="600" fill="#666" letter-spacing="0.8">SOCIETY WORLDWIDE</text>
                            </svg>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ========== FAQ SECTION ========== -->
            <div class="faq-section reveal">
                <div class="faq-container">
                    <div class="faq-content">
                        <h2 class="faq-title">FREQUENTLY ASKED<br>QUESTIONS</h2>

                        <div class="accordion">
                            <!-- item 1 -->
                            <div class="faq-item">
                                <div class="faq-question highlight-bg active">
                                    I RECENTLY ACQUIRED A VEHICLE. MUST I HAVE IT SERVICED AT AN AUTHORIZED DEALER TO
                                    MAINTAIN THE VALIDITY OF MY WARRANTY?
                                    <span class="faq-toggle">▼</span>
                                </div>
                                <div class="faq-answer" style="max-height: 500px;">
                                    <div class="faq-answer-inner"
                                        style="padding: 20px 30px; color: white; background: var(--primary);">
                                        <p style="color: white; margin: 0;">Absolutely not! Disregard that outdated
                                            misconception. Provided you adhere to the guidelines provided by the vehicle
                                            producer (detailed within your user’s guide), your guarantee remains in
                                            effect. At Shift Auto Dynamics, we consistently adhere to the producer’s
                                            upkeep timetable. We ensure your guarantee stays active and your vehicle
                                            operates optimally – for a considerable distance!</p>
                                    </div>
                                </div>
                            </div>

                            <!-- item 2 -->
                            <div class="faq-item">
                                <div class="faq-question">
                                    WHAT ARE THE NECESSARY STEPS TO ENSURE MY AUTO WARRANTY REMAINS VALID?
                                    <span class="faq-toggle">▼</span>
                                </div>
                                <div class="faq-answer">
                                    <div class="faq-answer-inner" style="padding: 24px 0;">
                                        <p>To ensure your auto warranty remains valid, strictly follow the maintenance
                                            schedule outlined in your owner's manual. Keep detailed records and receipts
                                            of all services performed, including oil changes and inspections. Ensure
                                            that whoever performs the service uses parts and fluids that meet the
                                            manufacturer's specifications.</p>
                                    </div>
                                </div>
                            </div>

                            <!-- item 3 -->
                            <div class="faq-item">
                                <div class="faq-question">
                                    HOW DO I KEEP TRACK OF ROUTINE MAINTENANCE?
                                    <span class="faq-toggle">▼</span>
                                </div>
                                <div class="faq-answer">
                                    <div class="faq-answer-inner" style="padding: 24px 0;">
                                        <p>The easiest way is to use our Shift Auto Dynamics online portal where you can
                                            view your service history and upcoming reminders. We'll send you
                                            notifications when a service is due based on your mileage or time since the
                                            last visit.</p>
                                    </div>
                                </div>
                            </div>

                            <!-- item 4 -->
                            <div class="faq-item">
                                <div class="faq-question">
                                    REGARDING A VEHICLE OBTAINED VIA A LEASE, DOES THE MAINTENANCE FALL UNDER MY
                                    OBLIGATIONS?
                                    <span class="faq-toggle">▼</span>
                                </div>
                                <div class="faq-answer">
                                    <div class="faq-answer-inner" style="padding: 24px 0;">
                                        <p>Yes, typically the lessee is responsible for all routine maintenance and
                                            repairs during the lease term. Failure to maintain the vehicle according to
                                            the manufacturer's standards can result in penalties or "excess wear and
                                            tear" charges at the end of the lease. Check your specific lease agreement
                                            for details.</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="faq-image">
                        <img src="${pageContext.request.contextPath}/images/red_car_faq.jpg" alt="Luxury Car Service">
                    </div>
                </div>
            </div>

            <!-- ========== FOOTER ========== -->
            <footer id="contact"
                style="background: #1a1a1a; color: #e0e0e0; padding: 60px 0 20px 0; font-family: 'Roboto', sans-serif;">
                <div class="page-container" style="max-width: 1200px; margin: 0 auto; padding: 0 20px;">

                    <!-- Main Footer Content -->
                    <div style="display: grid; grid-template-columns: 1.5fr 1.5fr 2fr; gap: 40px; margin-bottom: 40px;">

                        <!-- Column 1: CITY NETWORK -->
                        <div>
                            <h4
                                style="color: white; font-family: inherit; font-weight: 700; font-size: 1.1rem; margin-bottom: 20px;">
                                Company Information / City Network</h4>
                            <ul style="list-style: none; padding: 0; margin: 0; line-height: 2.2;">
                                <li><a href="#"
                                        style="color: #e0e0e0; text-decoration: none; font-size: 0.9rem; transition: color 0.3s;"
                                        onmouseover="this.style.color='white'"
                                        onmouseout="this.style.color='#e0e0e0'">Colombo</a></li>
                                <li><a href="#"
                                        style="color: #e0e0e0; text-decoration: none; font-size: 0.9rem; transition: color 0.3s;"
                                        onmouseover="this.style.color='white'"
                                        onmouseout="this.style.color='#e0e0e0'">Kandy</a></li>
                                <li><a href="#"
                                        style="color: #e0e0e0; text-decoration: none; font-size: 0.9rem; transition: color 0.3s;"
                                        onmouseover="this.style.color='white'"
                                        onmouseout="this.style.color='#e0e0e0'">Kurunegala</a></li>
                                <li><a href="#"
                                        style="color: #e0e0e0; text-decoration: none; font-size: 0.9rem; transition: color 0.3s;"
                                        onmouseover="this.style.color='white'"
                                        onmouseout="this.style.color='#e0e0e0'">Mathara</a></li>
                            </ul>
                        </div>

                        <!-- Column 2: CITY OFFICE -->
                        <div>
                            <h4
                                style="color: white; font-family: inherit; font-weight: 700; font-size: 1.1rem; margin-bottom: 20px;">
                                Products & Services / Office</h4>
                            <ul style="list-style: none; padding: 0; margin: 0; line-height: 2.2;">
                                <li style="color: #e0e0e0; font-size: 0.9rem;">450/50, Koswatta, Talangama North</li>
                                <li style="color: #e0e0e0; font-size: 0.9rem;">Battaramulla</li>
                                <li style="color: #e0e0e0; font-size: 0.9rem;">10120</li>
                                <li style="color: #e0e0e0; font-size: 0.9rem;">Sri Lanka</li>
                            </ul>
                        </div>

                        <!-- Column 3: BORDERED BOX & SOCIALS -->
                        <div>
                            <div
                                style="border: 1px solid #444; border-radius: 8px; padding: 25px; margin-bottom: 25px;">
                                <h4
                                    style="color: white; font-family: inherit; font-weight: 700; font-size: 1.1rem; margin-bottom: 15px;">
                                    Opening Hours</h4>
                                <p style="color: #ccc; font-size: 0.9rem; line-height: 1.8; margin-bottom: 0;">
                                    Stay updated with our services and availability. Our mechanic network is ready for
                                    you during our standard hours: <br><br>
                                    <strong style="color: white;">Mon - Fri:</strong> 7 AM - 6 PM<br>
                                    <strong style="color: white;">Sat - Sun:</strong> 7 AM - 6 PM
                                </p>
                                <a href="appointment"
                                    style="display: inline-flex; align-items: center; justify-content: space-between; background: #d35400; color: white; padding: 12px 20px; border-radius: 6px; text-decoration: none; font-weight: 700; font-size: 1rem; margin-top: 20px; width: 140px; transition: background 0.3s;"
                                    onmouseover="this.style.background='#e67e22'"
                                    onmouseout="this.style.background='#d35400'">
                                    Book Now
                                    <span style="font-size: 1.2rem; font-weight: bold; margin-left: 10px;">›</span>
                                </a>
                            </div>

                            <h4
                                style="color: white; font-family: inherit; font-weight: 700; font-size: 1rem; margin-bottom: 15px;">
                                Follow Shift Auto Dynamics</h4>
                            <div style="display: flex; gap: 10px;">
                                <a href="#"
                                    style="background: #333; width: 42px; height: 42px; border-radius: 6px; display: flex; align-items: center; justify-content: center; transition: background 0.3s;"
                                    onmouseover="this.style.background='#444'"
                                    onmouseout="this.style.background='#333'">
                                    <img src="https://upload.wikimedia.org/wikipedia/commons/e/e7/Instagram_logo_2016.svg"
                                        alt="Instagram"
                                        style="width: 22px; height: 22px; filter: brightness(0) invert(1);">
                                </a>
                                <a href="#"
                                    style="background: #333; width: 42px; height: 42px; border-radius: 6px; display: flex; align-items: center; justify-content: center; transition: background 0.3s;"
                                    onmouseover="this.style.background='#444'"
                                    onmouseout="this.style.background='#333'">
                                    <svg style="width: 22px; height: 22px; fill: white;" viewBox="0 0 448 512">
                                        <path
                                            d="M448 209.9a210.1 210.1 0 0 1 -122.8-39.3V349.4A162.6 162.6 0 1 1 185 188.3V278.2a74.6 74.6 0 1 0 52.2 71.2V0l88 0a121.2 121.2 0 0 0 1.9 22.2h0A122.2 122.2 0 0 0 381 102.4a121.4 121.4 0 0 0 67 20.1z" />
                                    </svg>
                                </a>
                                <a href="#"
                                    style="background: #333; width: 42px; height: 42px; border-radius: 6px; display: flex; align-items: center; justify-content: center; transition: background 0.3s;"
                                    onmouseover="this.style.background='#444'"
                                    onmouseout="this.style.background='#333'">
                                    <img src="https://upload.wikimedia.org/wikipedia/commons/6/6b/WhatsApp.svg"
                                        alt="WhatsApp"
                                        style="width: 22px; height: 22px; filter: brightness(0) invert(1);">
                                </a>
                                <a href="#"
                                    style="background: #333; width: 42px; height: 42px; border-radius: 6px; display: flex; align-items: center; justify-content: center; transition: background 0.3s;"
                                    onmouseover="this.style.background='#444'"
                                    onmouseout="this.style.background='#333'">
                                    <img src="https://upload.wikimedia.org/wikipedia/commons/0/09/YouTube_full-color_icon_%282017%29.svg"
                                        alt="YouTube"
                                        style="width: 22px; height: 22px; filter: grayscale(1) invert(1) brightness(2);">
                                </a>
                            </div>
                        </div>

                    </div>

                    <!-- Bottom Small Text -->
                    <div style="border-top: 1px solid #333; padding-top: 25px; margin-bottom: 20px;">
                        <p style="color: #888; font-size: 0.75rem; line-height: 1.6; margin-bottom: 10px;">
                            &sup1;All servicing or repairs carried out by Shift Auto Dynamics Approved Mechanics will be
                            covered with a 12 month guarantee or 12,000 km (whichever comes first) unless explicitly
                            explained and documented, for which you will receive a copy.
                        </p>
                        <p style="color: #888; font-size: 0.75rem; line-height: 1.6; margin-bottom: 0;">
                            ^Pricing subject to change and varies by make and model. Example prices based on standard
                            sedans.
                        </p>
                    </div>

                    <!-- Footer Bottom Links -->
                    <div
                        style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; border-top: 1px solid #333; padding-top: 20px;">
                        <div style="display: flex; gap: 30px; margin-bottom: 10px;">
                            <a href="#"
                                style="color: #e0e0e0; font-weight: 600; text-decoration: none; font-size: 0.85rem;"
                                onmouseover="this.style.color='white'" onmouseout="this.style.color='#e0e0e0'">Privacy
                                Policy</a>
                            <a href="#"
                                style="color: #e0e0e0; font-weight: 600; text-decoration: none; font-size: 0.85rem;"
                                onmouseover="this.style.color='white'" onmouseout="this.style.color='#e0e0e0'">Terms of
                                use</a>
                            <a href="#"
                                style="color: #e0e0e0; font-weight: 600; text-decoration: none; font-size: 0.85rem;"
                                onmouseover="this.style.color='white'"
                                onmouseout="this.style.color='#e0e0e0'">Accessibility</a>
                            <a href="#"
                                style="color: #e0e0e0; font-weight: 600; text-decoration: none; font-size: 0.85rem;"
                                onmouseover="this.style.color='white'" onmouseout="this.style.color='#e0e0e0'">Cookie
                                policy</a>
                            <a href="#"
                                style="color: #e0e0e0; font-weight: 600; text-decoration: none; font-size: 0.85rem;"
                                onmouseover="this.style.color='white'"
                                onmouseout="this.style.color='#e0e0e0'">Sitemap</a>
                        </div>
                        <div style="color: #888; font-size: 0.85rem; padding-bottom: 10px;">
                            &copy; 2026 Shift Auto Dynamics Services. All rights reserved.
                        </div>
                    </div>

                </div>
            </footer>

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
                window.firebaseSignOut = function () {
                    signOut(auth).then(() => {
                        window.location.href = 'user?action=logout';
                    }).catch(() => {
                        window.location.href = 'user?action=logout';
                    });
                };
            </script>

            <!-- Scroll to Top Button -->
            <button id="scrollToTopBtn" class="scroll-to-top scroll-to-top-car" title="Go to top"
                aria-label="Scroll to top">
                <span class="scroll-to-top-smoke" aria-hidden="true"></span>
                <div class="scroll-to-top-vehicle">
                    <span class="scroll-to-top-lights" aria-hidden="true"></span>
                    <img src="${pageContext.request.contextPath}/images/scroll-top-headlight-car.png?v=20260310v3"
                        alt="" class="scroll-to-top-car-icon">
                </div>
            </button>


            <script>
                // FAQ Accordion
                (() => {
                    const faqQuestions = document.querySelectorAll('.faq-question');

                    faqQuestions.forEach(question => {
                        question.addEventListener('click', () => {
                            const answer = question.nextElementSibling;
                            const isActive = question.classList.contains('active');

                            // Close all others
                            document.querySelectorAll('.faq-question').forEach(q => {
                                q.classList.remove('active');
                                q.classList.remove('highlight-bg');
                                q.nextElementSibling.style.maxHeight = null;
                                const inner = q.nextElementSibling.querySelector('.faq-answer-inner');
                                if (inner) {
                                    inner.style.color = '';
                                    inner.style.background = '';
                                    const p = inner.querySelector('p');
                                    if (p) p.style.color = '';
                                }
                            });

                            if (!isActive) {
                                question.classList.add('active');
                                question.classList.add('highlight-bg');
                                answer.style.maxHeight = answer.scrollHeight + 100 + "px";

                                // Style active item specifically (blue background like screenshot)
                                const inner = answer.querySelector('.faq-answer-inner');
                                if (inner) {
                                    inner.style.color = 'white';
                                    inner.style.background = 'var(--primary)';
                                    const p = inner.querySelector('p');
                                    if (p) p.style.color = 'white';
                                }
                            }
                        });
                    });
                })();
            </script>

            <script>
                (() => {
                    const scrollToTopBtn = document.getElementById("scrollToTopBtn");
                    if (!scrollToTopBtn) {
                        return;
                    }

                    let drivingResetTimer;

                    const syncScrollToTopButton = () => {
                        if (scrollToTopBtn.classList.contains("is-driving")) {
                            scrollToTopBtn.classList.add("show");
                            return;
                        }

                        scrollToTopBtn.classList.toggle("show", window.scrollY > 300);
                    };

                    const stopDriving = () => {
                        scrollToTopBtn.classList.remove("is-driving");
                        syncScrollToTopButton();
                    };

                    window.addEventListener("scroll", () => {
                        if (scrollToTopBtn.classList.contains("is-driving") && window.scrollY <= 4) {
                            window.clearTimeout(drivingResetTimer);
                            stopDriving();
                            return;
                        }

                        syncScrollToTopButton();
                    }, { passive: true });

                    scrollToTopBtn.addEventListener("click", () => {
                        if (scrollToTopBtn.classList.contains("is-driving") || window.scrollY <= 0) {
                            return;
                        }

                        scrollToTopBtn.classList.add("show", "is-driving");
                        window.scrollTo({
                            top: 0,
                            behavior: "smooth"
                        });

                        window.clearTimeout(drivingResetTimer);
                        drivingResetTimer = window.setTimeout(stopDriving, 950);
                    });

                    syncScrollToTopButton();
                })();
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

<script>
// ===== SCROLL REVEAL =====
(function() {
    var revealEls = document.querySelectorAll('.reveal');
    if (!revealEls.length) return;
    var observer = new IntersectionObserver(function(entries) {
        entries.forEach(function(entry) {
            if (entry.isIntersecting) {
                entry.target.classList.add('reveal-visible');
                observer.unobserve(entry.target);
            }
        });
    }, { threshold: 0.12, rootMargin: '0px 0px -40px 0px' });
    revealEls.forEach(function(el) { observer.observe(el); });
})();
</script>

        </body>

        </html>
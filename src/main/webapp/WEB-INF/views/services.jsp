<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Services - AutoCare Tracker</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
    <style>
        /* === Service Cards Animation Styles === */
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(40px); }
            to { opacity: 1; transform: translateY(0); }
        }
        @keyframes shimmer {
            0% { background-position: -200% 0; }
            100% { background-position: 200% 0; }
        }
        .service-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
            margin-bottom: 50px;
        }
        .service-card {
            position: relative;
            border-radius: 12px;
            overflow: hidden;
            height: 320px;
            cursor: pointer;
            box-shadow: 0 8px 30px rgba(0,0,0,0.12);
            transition: transform 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94), box-shadow 0.4s ease;
            animation: fadeInUp 0.6s ease forwards;
            opacity: 0;
        }
        .service-card:nth-child(1) { animation-delay: 0.1s; }
        .service-card:nth-child(2) { animation-delay: 0.2s; }
        .service-card:nth-child(3) { animation-delay: 0.3s; }
        .service-card:nth-child(4) { animation-delay: 0.4s; }
        .service-card:nth-child(5) { animation-delay: 0.5s; }
        .service-card:hover {
            transform: translateY(-10px) scale(1.02);
            box-shadow: 0 20px 50px rgba(0,0,0,0.25);
        }
        .service-card img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.6s ease, filter 0.4s ease;
        }
        .service-card:hover img {
            transform: scale(1.1);
            filter: brightness(0.7);
        }
        .service-card-overlay {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            background: linear-gradient(transparent, rgba(0,0,0,0.85));
            padding: 25px 20px 20px;
            transition: all 0.4s ease;
        }
        .service-card:hover .service-card-overlay {
            background: linear-gradient(transparent 0%, rgba(0, 40, 90, 0.9) 50%);
            padding-bottom: 25px;
        }
        .service-card-title {
            font-family: 'Oswald', sans-serif;
            font-size: 1.4rem;
            color: white;
            text-transform: uppercase;
            letter-spacing: 2px;
            margin-bottom: 5px;
        }
        .service-card-desc {
            font-size: 0.8rem;
            color: rgba(255,255,255,0.7);
            line-height: 1.4;
            max-height: 0;
            overflow: hidden;
            transition: max-height 0.5s ease, opacity 0.4s ease;
            opacity: 0;
        }
        .service-card:hover .service-card-desc {
            max-height: 100px;
            opacity: 1;
        }
        .service-card-price {
            display: inline-block;
            background: var(--primary);
            color: white;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            margin-top: 8px;
            opacity: 0;
            transform: translateY(10px);
            transition: opacity 0.4s ease 0.1s, transform 0.4s ease 0.1s;
        }
        .service-card:hover .service-card-price {
            opacity: 1;
            transform: translateY(0);
        }
        .service-card-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            background: var(--primary);
            color: white;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 0.7rem;
            font-weight: 700;
            letter-spacing: 1px;
            text-transform: uppercase;
            box-shadow: 0 3px 10px rgba(0,0,0,0.2);
            animation: shimmer 3s infinite linear;
            background-size: 200% 100%;
            background-image: linear-gradient(90deg, var(--primary) 0%, #4da6ff 50%, var(--primary) 100%);
        }
        .service-card a.card-link {
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            z-index: 2;
        }
        /* Admin delete button on card */
        .card-admin-btn {
            position: absolute;
            top: 15px;
            left: 15px;
            z-index: 3;
            background: rgba(220,50,50,0.9);
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 4px;
            font-size: 0.7rem;
            cursor: pointer;
            text-decoration: none;
            font-weight: bold;
            transition: background 0.3s;
        }
        .card-admin-btn:hover { background: rgba(200,30,30,1); }

        .section-divider {
            width: 80px;
            height: 4px;
            background: var(--primary);
            margin: 0 auto 40px;
            border-radius: 2px;
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
            </c:if>
            <c:if test="${authUser.userRole != 'AdminUser'}">
                <li><a href="dashboard">VEHICLES</a></li>
                <li><a href="service" class="active">SERVICES</a></li>
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

<div class="page-container">
    <!-- ========== PREMIUM SERVICE MENU ========== -->
    <div style="text-align: center; margin-bottom: 10px; padding-top: 20px;">
        <h1 style="font-family: 'Oswald', sans-serif; font-size: 2.8rem; color: var(--dark); margin-bottom: 8px; letter-spacing: 2px;">PREMIUM AUTO SERVICE MENU</h1>
        <p style="color: var(--text-muted); font-size: 1rem; max-width: 600px; margin: 0 auto;">Click on any service category to explore detailed offerings and pricing</p>
    </div>
    <div class="section-divider"></div>

    <!-- ========== ANIMATED SERVICE CARDS ========== -->
    <div class="service-grid">
        <c:forEach var="cat" items="${allCategories}">
            <div class="service-card">
                <a href="service_detail?category=${cat.name}" class="card-link"></a>
                <c:choose>
                    <c:when test="${cat.name == 'Tyre Services'}">
                        <img src="${pageContext.request.contextPath}/images/tyre_services.png" alt="${cat.name}"/>
                    </c:when>
                    <c:when test="${cat.name == 'Mechanical Repair'}">
                        <img src="${pageContext.request.contextPath}/images/mechanical_repair.png" alt="${cat.name}"/>
                    </c:when>
                    <c:when test="${cat.name == 'Collision Repairs'}">
                        <img src="${pageContext.request.contextPath}/images/collision_repairs.png" alt="${cat.name}"/>
                    </c:when>
                    <c:when test="${cat.name == 'Nano Coating'}">
                        <img src="${pageContext.request.contextPath}/images/nano_coating.png" alt="${cat.name}"/>
                    </c:when>
                    <c:when test="${cat.name == 'Periodic Maintenance'}">
                        <img src="${pageContext.request.contextPath}/images/periodic_maintenance.png" alt="${cat.name}"/>
                    </c:when>
                    <c:otherwise>
                        <img src="${pageContext.request.contextPath}/images/autocare_hero.png" alt="${cat.name}"/>
                    </c:otherwise>
                </c:choose>
                <span class="service-card-badge">EXPLORE &rarr;</span>
                <div class="service-card-overlay">
                    <div class="service-card-title">${cat.name}</div>
                    <div class="service-card-desc">${cat.description}</div>
                    <span class="service-card-price">Starting: ${cat.startingPrice}</span>
                </div>
            </div>
        </c:forEach>
    </div>

    <!-- ========== ADMIN: ADD PACKAGE ========== -->
    <c:if test="${authUser.userRole == 'AdminUser'}">
        <div style="background: white; padding: 25px; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.06); margin-bottom: 50px; border: 1px solid var(--border);">
            <h3 style="margin-top: 0; color: var(--dark); font-family: 'Oswald', sans-serif; font-size: 1.3rem;">ADD NEW SERVICE PACKAGE</h3>
            <form action="service" method="post" style="display: flex; flex-wrap: wrap; gap: 15px; align-items: center;">
                <input type="hidden" name="action" value="createPackage"/>
                <select name="category" required style="flex: 1; min-width: 200px; padding: 10px; border: 1px solid var(--border); border-radius: 4px; background: white;">
                    <option value="">Select Category</option>
                    <c:forEach var="cat" items="${allCategories}">
                        <option value="${cat.name}">${cat.name}</option>
                    </c:forEach>
                </select>
                <input type="text" name="name" placeholder="Package Name" required style="flex: 1; min-width: 200px; padding: 10px; border: 1px solid var(--border); border-radius: 4px;"/>
                <input type="text" name="packageDescription" placeholder="Description" style="flex: 2; min-width: 250px; padding: 10px; border: 1px solid var(--border); border-radius: 4px;"/>
                <input type="text" name="packagePrice" placeholder="Price (e.g. LKR 5,000)" style="flex: 1; min-width: 180px; padding: 10px; border: 1px solid var(--border); border-radius: 4px;"/>
                <button type="submit" class="btn-primary-custom" style="padding: 10px 20px; border-radius: 4px; border: none; cursor: pointer; color: white; white-space: nowrap;">ADD PACKAGE +</button>
            </form>
        </div>
    </c:if>

    <!-- ========== SERVICE HISTORY LOGS ========== -->
    <div class="page-header" style="border-bottom: 3px solid var(--dark); padding-bottom: 15px; margin-bottom: 30px; display: flex; justify-content: space-between; align-items: center;">
        <h1 style="font-size: 2.2rem; color: var(--dark);">SERVICE HISTORY LOGS</h1>
        <c:if test="${authUser.userRole == 'AdminUser'}">
            <a href="service?action=add" class="btn-primary-custom" style="padding: 12px 25px; font-size: 1rem; text-transform: uppercase; border-radius: 4px; background: var(--primary); color: white; text-decoration: none; font-weight: bold;">ADD SERVICE &gt;</a>
        </c:if>
    </div>

    <div class="data-table-container">
        <table class="data-table">
            <thead>
                <tr>
                    <th>DATE</th>
                    <th>VEHICLE</th>
                    <th>TYPE</th>
                    <th>SERVICES / DETAILS</th>
                    <th>COST</th>
                    <th>STATUS</th>
                    <th>ACTION</th>
                </tr>
            </thead>
            <tbody>
                <%-- Completed Appointments as Service History Rows (User Only) --%>
                <c:if test="${authUser.userRole != 'AdminUser'}">
                    <c:forEach var="ca" items="${completedAppointments}">
                        <tr style="border-left: 4px solid #2E7D32;">
                            <td><strong>${ca.preferredDate}</strong></td>
                            <td>${ca.vehicleInfo}</td>
                            <td><span style="background: #e8f5e9; color: #2e7d32; padding: 3px 10px; border-radius: 4px; font-size: 0.8rem; font-weight: 600;">Appointment</span></td>
                            <td style="font-size: 0.85rem;">
                                <c:forTokens var="svc" items="${ca.serviceName}" delims=",">
                                    <span style="display: inline-block; background: #e8f5e9; color: #2e7d32; padding: 2px 8px; border-radius: 3px; font-size: 0.75rem; margin: 1px 3px 1px 0; font-weight: 600;">${svc}</span>
                                </c:forTokens>
                                <c:if test="${not empty ca.notes}">
                                    <div style="margin-top: 4px; color: var(--text-muted); font-size: 0.8rem;">Note: ${ca.notes}</div>
                                </c:if>
                            </td>
                            <td style="font-weight: 700; color: var(--primary);">${ca.servicePrice}</td>
                            <td><span style="background: #e8f5e9; color: #2e7d32; padding: 4px 10px; border-radius: 12px; font-size: 0.7rem; font-weight: 700; letter-spacing: 0.5px;">✓ COMPLETED</span></td>
                            <td>—</td>
                        </tr>
                    </c:forEach>
                </c:if>

                <%-- Regular Service Records --%>
                <c:forEach var="r" items="${serviceRecords}">
                    <tr>
                        <td><strong>${r.serviceDate}</strong></td>
                        <td>${r.vehicleId}</td>
                        <td><span class="card-badge" style="margin:0">${r.serviceType}</span></td>
                        <td style="font-size:0.85rem">${r.serviceSummary}<br/><span style="color: var(--text-muted); font-size: 0.8rem;">Mileage: ${r.mileageAtService} km</span></td>
                        <td>LKR ${r.cost}</td>
                        <td><span style="background: #e3f2fd; color: #1565c0; padding: 4px 10px; border-radius: 12px; font-size: 0.7rem; font-weight: 700; letter-spacing: 0.5px;">LOGGED</span></td>
                        <td>
                            <c:if test="${authUser.userRole == 'AdminUser'}">
                                <a href="service?action=delete&id=${r.recordId}" class="btn-sm-danger" onclick="return confirm('Delete record?')">DELETE</a>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty serviceRecords && (authUser.userRole == 'AdminUser' || empty completedAppointments)}">
                    <tr>
                        <td colspan="7">
                            <div class="empty-state">
                                <h3>NO SERVICES LOGGED</h3>
                                <p style="color:var(--text-muted);">Keep track of maintenance here.</p>
                            </div>
                        </td>
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
</body>
</html>


<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Appointment - Shift Auto Dynamics</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
    <style>
        @keyframes fadeInUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }

        .booking-container { max-width: 900px; margin: 0 auto; padding: 40px 20px; }

        .step-indicator { display: flex; justify-content: center; align-items: center; gap: 0; margin-bottom: 40px; animation: fadeInUp 0.5s ease; }
        .step { display: flex; flex-direction: column; align-items: center; gap: 8px; position: relative; min-width: 100px; }
        .step-circle { width: 40px; height: 40px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 0.9rem; color: white; background: #ccc; transition: all 0.3s; }
        .step.active .step-circle { background: var(--primary); box-shadow: 0 4px 15px rgba(0,100,200,0.3); }
        .step-label { font-size: 0.75rem; font-weight: 600; color: var(--text-muted); text-transform: uppercase; letter-spacing: 1px; }
        .step.active .step-label { color: var(--primary); }
        .step-line { width: 80px; height: 3px; background: #ddd; margin-bottom: 25px; }
        .step-line.done { background: var(--primary); }

        .booking-card { background: white; padding: 40px; border-radius: 12px; box-shadow: 0 8px 30px rgba(0,0,0,0.08); border: 1px solid var(--border); animation: fadeInUp 0.6s ease; }
        .booking-card h2 { font-family: 'Oswald', sans-serif; font-size: 1.8rem; color: var(--dark); margin: 0 0 5px 0; letter-spacing: 1px; }
        .booking-subtitle { color: var(--text-muted); font-size: 0.9rem; margin-bottom: 30px; border-bottom: 3px solid var(--primary); padding-bottom: 15px; display: inline-block; }

        .form-group { margin-bottom: 25px; }
        .form-group label { display: block; font-weight: 600; margin-bottom: 8px; color: var(--dark); font-size: 0.85rem; text-transform: uppercase; letter-spacing: 1px; }
        .form-group select, .form-group input, .form-group textarea { width: 100%; padding: 12px 15px; border: 1px solid var(--border); border-radius: 6px; font-size: 1rem; transition: border-color 0.3s, box-shadow 0.3s; background: white; }
        .form-group select:focus, .form-group input:focus, .form-group textarea:focus { border-color: var(--primary); box-shadow: 0 0 0 3px rgba(0,100,200,0.1); outline: none; }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }

        /* Service Category Sections */
        .svc-category-block { margin-bottom: 20px; border: 1px solid var(--border); border-radius: 10px; overflow: hidden; }
        .svc-category-header { background: linear-gradient(135deg, var(--dark), #1a2332); color: white; padding: 12px 20px; font-family: 'Oswald', sans-serif; font-size: 1.05rem; letter-spacing: 1px; cursor: pointer; display: flex; justify-content: space-between; align-items: center; transition: background 0.3s; }
        .svc-category-header:hover { background: linear-gradient(135deg, var(--primary), #0056b3); }
        .svc-category-header .toggle-icon { font-size: 1.2rem; transition: transform 0.3s; }
        .svc-category-header.open .toggle-icon { transform: rotate(180deg); }
        .svc-category-body { padding: 0; max-height: 0; overflow: hidden; transition: max-height 0.4s ease, padding 0.3s; }
        .svc-category-body.open { max-height: 1000px; padding: 10px 0; }

        /* Service Item Checkbox */
        .svc-item { display: flex; align-items: center; padding: 12px 20px; border-bottom: 1px solid #f0f0f0; transition: background 0.2s; cursor: pointer; }
        .svc-item:last-child { border-bottom: none; }
        .svc-item:hover { background: #f7fbff; }
        .svc-item.checked { background: #eef5ff; }
        .svc-item input[type="checkbox"] { width: 20px; height: 20px; margin-right: 15px; accent-color: var(--primary); cursor: pointer; flex-shrink: 0; }
        .svc-item-info { flex: 1; }
        .svc-item-name { font-weight: 600; color: var(--dark); font-size: 0.95rem; }
        .svc-item-desc { font-size: 0.8rem; color: var(--text-muted); margin-top: 2px; }
        .svc-item-price { font-weight: 700; color: var(--primary); font-size: 0.95rem; white-space: nowrap; margin-left: 15px; min-width: 100px; text-align: right; }

        /* Total Price Bar */
        .total-bar { background: linear-gradient(135deg, var(--dark), #1a2332); color: white; padding: 20px 25px; border-radius: 10px; display: flex; justify-content: space-between; align-items: center; margin: 25px 0; position: sticky; bottom: 20px; box-shadow: 0 8px 25px rgba(0,0,0,0.2); }
        .total-bar .total-label { font-family: 'Oswald', sans-serif; font-size: 1.1rem; letter-spacing: 1px; }
        .total-bar .total-count { font-size: 0.85rem; color: rgba(255,255,255,0.7); margin-top: 3px; }
        .total-bar .total-amount { font-family: 'Oswald', sans-serif; font-size: 2rem; color: #4da6ff; }

        .btn-book { background: var(--primary); color: white; padding: 14px 40px; border: none; border-radius: 6px; font-size: 1.1rem; font-weight: 700; cursor: pointer; letter-spacing: 1px; transition: background 0.3s, transform 0.3s; width: 100%; margin-top: 10px; }
        .btn-book:hover { background: #0056b3; transform: translateY(-2px); }
        .btn-book:disabled { background: #ccc; cursor: not-allowed; transform: none; }
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
                <li><a href="appointment" class="active">APPOINTMENTS</a></li>
                <li><a href="estimate">ESTIMATES</a></li>
            </c:if>
            <c:if test="${authUser.userRole != 'AdminUser'}">
                <li><a href="dashboard">VEHICLES</a></li>
                <li><a href="service">SERVICES</a></li>
                <li><a href="appointment" class="active">APPOINTMENTS</a></li>
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

<div class="booking-container">
    <!-- STEP INDICATOR -->
    <div class="step-indicator">
        <div class="step active"><div class="step-circle">1</div><div class="step-label">Vehicle</div></div>
        <div class="step-line done"></div>
        <div class="step active"><div class="step-circle">2</div><div class="step-label">Services</div></div>
        <div class="step-line done"></div>
        <div class="step active"><div class="step-circle">3</div><div class="step-label">Schedule</div></div>
        <div class="step-line done"></div>
        <div class="step active"><div class="step-circle">4</div><div class="step-label">Confirm</div></div>
    </div>

    <!-- BOOKING FORM -->
    <div class="booking-card">
        <h2>BOOK A SERVICE APPOINTMENT</h2>
        <span class="booking-subtitle">Select your vehicle, tick the services you need, and pick a date</span>

        <form action="appointment" method="post" id="bookingForm">
            <input type="hidden" name="action" value="create"/>
            <input type="hidden" name="selectedServices" id="hiddenServices" value=""/>
            <input type="hidden" name="selectedCategories" id="hiddenCategories" value=""/>
            <input type="hidden" name="totalPrice" id="hiddenTotalPrice" value=""/>

            <!-- STEP 1: Vehicle Selection -->
            <div class="form-group">
                <label>SELECT YOUR VEHICLE</label>
                <select name="vehicleId" id="vehicleSelect" required>
                    <option value="">— Choose a Vehicle —</option>
                    <c:forEach var="v" items="${myVehicles}">
                        <option value="${v.vehicleId}">${v.make} ${v.model} (${v.year}) — ${v.licensePlate}</option>
                    </c:forEach>
                </select>
                <c:if test="${empty myVehicles}">
                    <p style="color: red; margin-top: 8px; font-size: 0.85rem;">You have no registered vehicles. <a href="vehicle?action=add" style="color: var(--primary);">Register one first.</a></p>
                </c:if>
            </div>

            <!-- STEP 2: Multi-Service Selection with Checkboxes -->
            <div class="form-group">
                <label>SELECT SERVICES (tick all you need)</label>

                <c:forEach var="cat" items="${allCategories}">
                    <div class="svc-category-block">
                        <div class="svc-category-header" onclick="toggleCategory(this)">
                            <span>${cat.name}</span>
                            <span class="toggle-icon">▼</span>
                        </div>
                        <div class="svc-category-body">
                            <c:forEach var="pkg" items="${packagesByCategory[cat.name]}">
                                <label class="svc-item" onclick="event.stopPropagation()">
                                    <input type="checkbox" class="svc-checkbox"
                                           data-name="${pkg.name}"
                                           data-category="${cat.name}"
                                           data-price="${pkg.price}"
                                           data-desc="${pkg.description}"
                                           onchange="updateTotal()"/>
                                    <div class="svc-item-info">
                                        <div class="svc-item-name">${pkg.name}</div>
                                        <c:if test="${not empty pkg.description}">
                                            <div class="svc-item-desc">${pkg.description}</div>
                                        </c:if>
                                    </div>
                                    <div class="svc-item-price">${not empty pkg.price ? pkg.price : 'Contact Us'}</div>
                                </label>
                            </c:forEach>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- TOTAL PRICE BAR -->
            <div class="total-bar" id="totalBar" style="display: none;">
                <div>
                    <div class="total-label">ESTIMATED TOTAL</div>
                    <div class="total-count" id="selectedCount">0 services selected</div>
                </div>
                <div class="total-amount" id="totalAmount">LKR 0</div>
            </div>

            <!-- STEP 3: Schedule -->
            <div class="form-row">
                <div class="form-group">
                    <label>PREFERRED DATE</label>
                    <input type="date" name="preferredDate" required/>
                </div>
                <div class="form-group">
                    <label>PREFERRED TIME</label>
                    <select name="preferredTime" required>
                        <option value="">— Select Time —</option>
                        <option value="08:00 AM">08:00 AM</option>
                        <option value="09:00 AM">09:00 AM</option>
                        <option value="10:00 AM">10:00 AM</option>
                        <option value="11:00 AM">11:00 AM</option>
                        <option value="12:00 PM">12:00 PM</option>
                        <option value="01:00 PM">01:00 PM</option>
                        <option value="02:00 PM">02:00 PM</option>
                        <option value="03:00 PM">03:00 PM</option>
                        <option value="04:00 PM">04:00 PM</option>
                        <option value="05:00 PM">05:00 PM</option>
                    </select>
                </div>
            </div>

            <!-- STEP 4: Notes -->
            <div class="form-group">
                <label>ADDITIONAL NOTES (OPTIONAL)</label>
                <textarea name="notes" rows="3" placeholder="Any special requests or information..."></textarea>
            </div>

            <button type="submit" class="btn-book" id="submitBtn" onclick="return prepareSubmit()">CONFIRM APPOINTMENT &rarr;</button>
        </form>
    </div>
</div>

<script>
    function toggleCategory(header) {
        header.classList.toggle('open');
        var body = header.nextElementSibling;
        body.classList.toggle('open');
    }

    // Open first category by default
    document.addEventListener('DOMContentLoaded', function() {
        var firstHeader = document.querySelector('.svc-category-header');
        if (firstHeader) {
            firstHeader.classList.add('open');
            firstHeader.nextElementSibling.classList.add('open');
        }
    });

    function parsePrice(priceStr) {
        if (!priceStr) return 0;
        // Extract numbers from price string like "LKR 5,000" or "LKR 45,000"
        var cleaned = priceStr.replace(/[^0-9]/g, '');
        return cleaned ? parseInt(cleaned) : 0;
    }

    function formatPrice(num) {
        return 'LKR ' + num.toLocaleString();
    }

    function updateTotal() {
        var checkboxes = document.querySelectorAll('.svc-checkbox');
        var totalPrice = 0;
        var count = 0;
        var hasUnpriced = false;

        checkboxes.forEach(function(cb) {
            var item = cb.closest('.svc-item');
            if (cb.checked) {
                item.classList.add('checked');
                count++;
                var price = parsePrice(cb.dataset.price);
                if (price > 0) {
                    totalPrice += price;
                } else {
                    hasUnpriced = true;
                }
            } else {
                item.classList.remove('checked');
            }
        });

        var totalBar = document.getElementById('totalBar');
        var totalAmount = document.getElementById('totalAmount');
        var selectedCount = document.getElementById('selectedCount');

        if (count > 0) {
            totalBar.style.display = 'flex';
            selectedCount.textContent = count + ' service' + (count > 1 ? 's' : '') + ' selected';
            var priceText = formatPrice(totalPrice);
            if (hasUnpriced) priceText += ' +';
            totalAmount.textContent = priceText;
        } else {
            totalBar.style.display = 'none';
        }
    }

    function prepareSubmit() {
        var checkboxes = document.querySelectorAll('.svc-checkbox:checked');
        if (checkboxes.length === 0) {
            alert('Please select at least one service.');
            return false;
        }

        var services = [];
        var categories = [];
        var totalPrice = 0;
        var hasUnpriced = false;

        checkboxes.forEach(function(cb) {
            services.push(cb.dataset.name);
            if (categories.indexOf(cb.dataset.category) === -1) {
                categories.push(cb.dataset.category);
            }
            var price = parsePrice(cb.dataset.price);
            if (price > 0) {
                totalPrice += price;
            } else {
                hasUnpriced = true;
            }
        });

        document.getElementById('hiddenServices').value = services.join(', ');
        document.getElementById('hiddenCategories').value = categories.join(', ');
        var priceText = formatPrice(totalPrice);
        if (hasUnpriced) priceText += ' +';
        document.getElementById('hiddenTotalPrice').value = priceText;

        return true;
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

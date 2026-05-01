<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Invoice #${estimate.estimateId} - Shift Auto Dynamics</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
    <style>
        .form-container {
            background: white; border-radius: 16px; padding: 40px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.08); border: 1px solid var(--border);
            max-width: 950px; margin: 0 auto;
        }
        .form-section { margin-bottom: 30px; }
        .form-section h3 {
            font-family: 'Oswald', sans-serif; font-size: 1.2rem; color: var(--primary);
            text-transform: uppercase; letter-spacing: 1px; margin-bottom: 15px;
            padding-bottom: 8px; border-bottom: 2px solid var(--border);
        }
        .form-group { margin-bottom: 15px; }
        .form-group label {
            display: block; font-size: 0.8rem; font-weight: 600; color: var(--text-muted);
            text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 6px;
        }
        .form-group select, .form-group input, .form-group textarea {
            width: 100%; padding: 10px 14px; border: 1px solid var(--border);
            border-radius: 6px; font-size: 0.95rem; transition: border-color 0.3s;
            background: #fafafa; font-family: inherit;
        }
        .form-group select:focus, .form-group input:focus, .form-group textarea:focus {
            outline: none; border-color: var(--primary); background: white;
        }

        .appt-info-card {
            background: linear-gradient(135deg, #f8f9fa, #e8ecf1); border-radius: 12px;
            padding: 20px 25px; border-left: 5px solid #e65100; margin-bottom: 25px;
        }
        .appt-info-card h4 { font-family: 'Oswald', sans-serif; font-size: 1rem; color: var(--dark); margin: 0 0 12px 0; }
        .appt-info-row { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 15px; }
        .appt-info-item .lbl { font-size: 0.7rem; color: var(--text-muted); text-transform: uppercase; font-weight: 600; letter-spacing: 0.5px; }
        .appt-info-item .val { font-size: 0.95rem; color: var(--dark); font-weight: 500; margin-top: 2px; }

        .readonly-svc-item {
            display: flex; justify-content: space-between; align-items: center;
            padding: 12px 18px; background: #f0f5ff; border-radius: 8px;
            margin-bottom: 6px; border: 1px solid #e0eaff;
        }
        .readonly-svc-item .name { font-weight: 600; color: var(--dark); font-size: 0.9rem; }
        .readonly-svc-item .price { font-weight: 700; color: var(--primary); font-size: 0.9rem; }

        .svc-category-block { margin-bottom: 8px; border: 1px solid var(--border); border-radius: 8px; overflow: hidden; }
        .svc-category-header {
            background: linear-gradient(135deg, var(--dark), #1a2332); color: white;
            padding: 10px 18px; font-family: 'Oswald', sans-serif; font-size: 0.95rem;
            letter-spacing: 1px; cursor: pointer; display: flex; justify-content: space-between;
            align-items: center; transition: background 0.3s;
        }
        .svc-category-header:hover { background: linear-gradient(135deg, var(--primary), #0056b3); }
        .svc-category-header .toggle-icon { font-size: 1rem; transition: transform 0.3s; }
        .svc-category-header.open .toggle-icon { transform: rotate(180deg); }
        .svc-category-body { max-height: 0; overflow: hidden; transition: max-height 0.4s ease; }
        .svc-category-body.open { max-height: 1000px; }
        .svc-item {
            display: flex; align-items: center; padding: 10px 18px; border-bottom: 1px solid #f0f0f0;
            cursor: pointer; transition: background 0.2s;
        }
        .svc-item:last-child { border-bottom: none; }
        .svc-item:hover { background: #f7fbff; }
        .svc-item.checked { background: #eef5ff; }
        .svc-item input[type="checkbox"] { width: 18px; height: 18px; margin-right: 12px; accent-color: var(--primary); cursor: pointer; flex-shrink: 0; }
        .svc-item-info { flex: 1; }
        .svc-item-name { font-weight: 600; color: var(--dark); font-size: 0.88rem; }
        .svc-item-price { font-weight: 700; color: var(--primary); font-size: 0.88rem; white-space: nowrap; margin-left: 12px; min-width: 90px; text-align: right; }

        .item-row {
            display: grid; grid-template-columns: 1fr 150px 40px; gap: 10px;
            margin-bottom: 8px; align-items: center;
        }
        .item-row input { padding: 8px 12px; border: 1px solid var(--border); border-radius: 6px; font-size: 0.9rem; }
        .item-row input:focus { outline: none; border-color: var(--primary); }
        .btn-remove {
            width: 34px; height: 34px; border-radius: 50%; border: 1px solid #f44336;
            background: #ffebee; color: #f44336; cursor: pointer; font-size: 1.1rem;
            display: flex; align-items: center; justify-content: center; transition: all 0.3s;
        }
        .btn-remove:hover { background: #f44336; color: white; }
        .btn-add {
            background: #e3f2fd; color: #1565c0; border: 1px dashed #1565c0;
            padding: 8px 20px; border-radius: 6px; cursor: pointer; font-weight: 600;
            font-size: 0.85rem; transition: all 0.3s; display: inline-block; margin-top: 5px;
        }
        .btn-add:hover { background: #1565c0; color: white; border-style: solid; }

        .charge-row {
            display: flex; justify-content: space-between; align-items: center;
            padding: 15px 18px; background: #fff3e0; border-radius: 8px;
            border: 1px solid #ffe0b2; margin-bottom: 8px;
        }
        .charge-row label { font-weight: 600; color: #e65100; font-size: 0.9rem; margin: 0; }
        .charge-row input { width: 160px; padding: 8px 12px; border: 1px solid #ffe0b2; border-radius: 6px; font-size: 0.95rem; text-align: right; font-weight: 600; }

        .totals-section {
            background: #f8f9fa; border-radius: 10px; padding: 20px;
            border: 1px solid var(--border); margin-top: 20px;
        }
        .total-row { display: flex; justify-content: space-between; padding: 8px 0; font-size: 0.95rem; }
        .total-row.subtotal { font-weight: 600; border-top: 1px dashed var(--border); padding-top: 10px; margin-top: 4px; }
        .total-row.grand { font-size: 1.4rem; font-weight: 700; color: var(--primary); border-top: 2px solid var(--primary); padding-top: 12px; margin-top: 8px; }
        .status-badge { display: inline-block; padding: 3px 10px; border-radius: 20px; font-size: 0.72rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; margin-left: 8px; }
        .status-badge.pending { background: #fff3e0; color: #e65100; border: 1px solid #ffcc80; }
        .status-badge.completed { background: #e8f5e9; color: #2e7d32; border: 1px solid #a5d6a7; }
        .status-badge.cancelled { background: #ffebee; color: #c62828; border: 1px solid #ef9a9a; }

        @media (max-width: 768px) {
            .appt-info-row { grid-template-columns: 1fr; }
            .item-row { grid-template-columns: 1fr 100px 40px; }
            .form-container { padding: 20px; }
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
            <li><a href="estimate" class="active">ESTIMATES</a></li>
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
    <div class="page-header" style="border-bottom: 3px solid #e65100; padding-bottom: 15px; margin-bottom: 30px;">
        <h1 style="font-family: 'Oswald', sans-serif; font-size: 2.5rem; color: var(--dark);">✏️ EDIT INVOICE</h1>
        <p style="color: var(--text-muted); margin-top: 5px;">Editing Invoice #${estimate.estimateId}</p>
    </div>

    <div class="form-container">
        <!-- Invoice Info Card -->
        <div class="appt-info-card">
            <h4>📑 Invoice #${estimate.estimateId}
                <span class="status-badge ${fn:toLowerCase(estimate.status)}">${estimate.status}</span>
            </h4>
            <div class="appt-info-row">
                <div class="appt-info-item">
                    <div class="lbl">Customer</div>
                    <div class="val">${estimate.userName}</div>
                </div>
                <div class="appt-info-item">
                    <div class="lbl">Vehicle</div>
                    <div class="val">${estimate.vehicleInfo}</div>
                </div>
                <div class="appt-info-item">
                    <div class="lbl">Created Date</div>
                    <div class="val">${estimate.createdDate}</div>
                </div>
            </div>
        </div>

        <form action="estimate" method="post" id="invoiceForm">
            <input type="hidden" name="action" value="update" />
            <input type="hidden" name="estimateId" value="${estimate.estimateId}" />

            <!-- SECTION 1: Original Services (read-only) -->
            <div class="form-section">
                <h3>🔧 Booked Services</h3>
                <div id="originalServicesList">
                    <c:forTokens var="svc" items="${estimate.serviceItems}" delims="," varStatus="loop">
                        <div class="readonly-svc-item">
                            <span class="name">${svc}</span>
                            <span class="price">—</span>
                        </div>
                    </c:forTokens>
                </div>
                <p style="font-size: 0.8rem; color: var(--text-muted); margin: 8px 0 0 0;">
                    Service Price: <strong style="color: var(--primary);">Rs. ${estimate.servicePrices}</strong>
                </p>
            </div>

            <!-- SECTION 2: Additional Services -->
            <div class="form-section">
                <h3>➕ Additional Services</h3>
                <p style="font-size: 0.8rem; color: var(--text-muted); margin-bottom: 12px;">Select/deselect additional services.</p>
                
                <c:set var="currentAddSvcs" value=",${estimate.additionalServices}," />
                <c:forEach var="cat" items="${allCategories}">
                    <div class="svc-category-block">
                        <div class="svc-category-header" onclick="toggleCategory(this)">
                            <span>${cat.name}</span>
                            <span class="toggle-icon">▼</span>
                        </div>
                        <div class="svc-category-body">
                            <c:forEach var="pkg" items="${packagesByCategory[cat.name]}">
                                <c:set var="numericPrice" value="${fn:replace(fn:replace(fn:replace(fn:replace(pkg.price, 'Rs.', ''), 'Rs', ''), 'LKR', ''), ',', '')}" />
                                <c:set var="isChecked" value="${fn:contains(currentAddSvcs, fn:trim(pkg.name))}" />
                                <label class="svc-item ${isChecked ? 'checked' : ''}" onclick="event.stopPropagation()">
                                    <input type="checkbox" class="add-svc-checkbox"
                                           data-name="${pkg.name}"
                                           data-price="${fn:trim(numericPrice)}"
                                           ${isChecked ? 'checked' : ''}
                                           onchange="toggleSvcItem(this); recalcTotals()" />
                                    <div class="svc-item-info">
                                        <div class="svc-item-name">${pkg.name}</div>
                                    </div>
                                    <div class="svc-item-price">${not empty pkg.price ? pkg.price : 'Contact Us'}</div>
                                </label>
                            </c:forEach>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- SECTION 3: Parts Used -->
            <div class="form-section">
                <h3>🔩 Parts & Materials Used</h3>
                <div class="item-row" style="margin-bottom: 5px;">
                    <span style="font-size: 0.72rem; font-weight: 600; color: var(--text-muted); text-transform: uppercase;">Part Name</span>
                    <span style="font-size: 0.72rem; font-weight: 600; color: var(--text-muted); text-transform: uppercase;">Price (Rs.)</span>
                    <span></span>
                </div>
                <div id="partsList">
                    <!-- Pre-filled from existing data -->
                </div>
                <button type="button" class="btn-add" onclick="addPart()">+ Add Part</button>
            </div>

            <!-- SECTION 4: Service Charge -->
            <div class="form-section">
                <h3>💰 Service / Labour Charge</h3>
                <div class="charge-row">
                    <label>Service Charge (Rs.)</label>
                    <input type="number" id="serviceChargeInput" placeholder="0" min="0" step="0.01" oninput="recalcTotals()" />
                </div>
            </div>

            <!-- SECTION 5: Notes -->
            <div class="form-section">
                <h3>📝 Invoice Notes</h3>
                <div class="form-group">
                    <textarea name="notes" rows="3" placeholder="e.g. Customer requested synthetic oil, battery checked, next service due in 5,000 km...">${estimate.notes}</textarea>
                </div>
            </div>

            <!-- TOTALS -->
            <div class="totals-section">
                <div class="total-row">
                    <span>Original Services</span>
                    <span id="originalTotal">Rs. 0.00</span>
                </div>
                <div class="total-row">
                    <span>Additional Services</span>
                    <span id="additionalTotal">Rs. 0.00</span>
                </div>
                <div class="total-row">
                    <span>Parts & Materials</span>
                    <span id="partsTotal">Rs. 0.00</span>
                </div>
                <div class="total-row">
                    <span>Service Charge</span>
                    <span id="serviceChargeTotal">Rs. 0.00</span>
                </div>
                <div class="total-row grand">
                    <span>GRAND TOTAL</span>
                    <span id="grandTotal">Rs. 0.00</span>
                </div>
            </div>

            <!-- Hidden fields -->
            <input type="hidden" name="serviceItems" id="hServiceItems" />
            <input type="hidden" name="servicePrices" id="hServicePrices" />
            <input type="hidden" name="additionalServices" id="hAdditionalServices" />
            <input type="hidden" name="additionalPrices" id="hAdditionalPrices" />
            <input type="hidden" name="parts" id="hParts" />
            <input type="hidden" name="partPrices" id="hPartPrices" />
            <input type="hidden" name="serviceCharge" id="hServiceCharge" />
            <input type="hidden" name="subtotal" id="hSubtotal" />
            <input type="hidden" name="tax" id="hTax" />
            <input type="hidden" name="total" id="hTotal" />

            <div style="display: flex; gap: 15px; justify-content: flex-end; margin-top: 25px;">
                <a href="estimate?action=view&id=${estimate.estimateId}" style="padding: 12px 30px; border: 1px solid var(--border); border-radius: 6px; text-decoration: none; color: var(--dark); font-weight: 600;">CANCEL</a>
                <button type="submit" class="btn-primary-custom" style="padding: 12px 30px; font-size: 1rem; border: none; cursor: pointer; font-weight: 700; background: #e65100;">💾 UPDATE INVOICE &gt;</button>
            </div>
        </form>
    </div>
</div>

<script>
function parsePrice(priceStr) {
    if (!priceStr) return 0;
    var str = String(priceStr).trim();
    var direct = parseFloat(str);
    if (!isNaN(direct) && str.match(/^[0-9.]+$/)) return direct;
    str = str.replace(/Rs\.?/gi, '').replace(/LKR/gi, '').replace(/[,\s]/g, '').trim();
    var num = parseFloat(str);
    return isNaN(num) ? 0 : num;
}

// Original service price from existing invoice
var originalPriceStr = '${estimate.servicePrices}';
var originalPriceNum = parsePrice(originalPriceStr);

// Original service names
var originalServiceNames = [];
<c:forTokens var="svc" items="${estimate.serviceItems}" delims=",">
originalServiceNames.push('${svc}'.trim());
</c:forTokens>

function toggleCategory(header) {
    header.classList.toggle('open');
    header.nextElementSibling.classList.toggle('open');
}

function toggleSvcItem(cb) {
    var item = cb.closest('.svc-item');
    if (cb.checked) { item.classList.add('checked'); } else { item.classList.remove('checked'); }
}

function addPart(name, price) {
    var list = document.getElementById('partsList');
    var row = document.createElement('div');
    row.className = 'item-row';
    row.innerHTML = '<input type="text" class="part-name" placeholder="e.g. Brake Pads" value="' + (name || '') + '" />' +
                    '<input type="number" class="part-price" placeholder="0" min="0" step="0.01" value="' + (price || '') + '" oninput="recalcTotals()" />' +
                    '<button type="button" class="btn-remove" onclick="removeRow(this)">×</button>';
    list.appendChild(row);
}

function removeRow(btn) { btn.parentElement.remove(); recalcTotals(); }

function sumInputs(className) {
    var total = 0;
    document.querySelectorAll('.' + className).forEach(function(el) {
        var v = parseFloat(el.value); if (!isNaN(v)) total += v;
    });
    return total;
}

function recalcTotals() {
    var additionalTotal = 0;
    document.querySelectorAll('.add-svc-checkbox:checked').forEach(function(cb) {
        additionalTotal += parsePrice(cb.dataset.price);
    });
    var partsTotal = sumInputs('part-price');
    var serviceCharge = parseFloat(document.getElementById('serviceChargeInput').value) || 0;
    var subtotal = originalPriceNum + additionalTotal + partsTotal + serviceCharge;
    var grandTotal = subtotal;

    document.getElementById('originalTotal').textContent = 'Rs. ' + originalPriceNum.toFixed(2);
    document.getElementById('additionalTotal').textContent = 'Rs. ' + additionalTotal.toFixed(2);
    document.getElementById('partsTotal').textContent = 'Rs. ' + partsTotal.toFixed(2);
    document.getElementById('serviceChargeTotal').textContent = 'Rs. ' + serviceCharge.toFixed(2);
    document.getElementById('subtotalDisplay').textContent = 'Rs. ' + subtotal.toFixed(2);
    document.getElementById('grandTotal').textContent = 'Rs. ' + grandTotal.toFixed(2);
}

// Pre-fill existing parts
<c:if test="${not empty estimate.parts}">
    <c:set var="partNamesArr" value="${fn:split(estimate.parts, ',')}" />
    <c:set var="partPricesArr" value="${fn:split(estimate.partPrices, ',')}" />
    <c:forEach var="i" begin="0" end="${fn:length(partNamesArr) - 1}">
        addPart('${fn:trim(partNamesArr[i])}', '${fn:trim(partPricesArr[i])}');
    </c:forEach>
</c:if>

// Pre-fill service charge
<c:if test="${not empty estimate.serviceCharge && estimate.serviceCharge != '0' && estimate.serviceCharge != '0.00'}">
    document.getElementById('serviceChargeInput').value = '${estimate.serviceCharge}';
</c:if>

// Initial calculation
recalcTotals();

// Form submit handler
document.getElementById('invoiceForm').addEventListener('submit', function(e) {
    // Validate: remove empty part rows before submit
    document.querySelectorAll('.part-name').forEach(function(n) {
        if (!n.value.trim()) { n.closest('.item-row').remove(); }
    });
    document.getElementById('hServiceItems').value = originalServiceNames.join(',');
    document.getElementById('hServicePrices').value = originalPriceNum.toFixed(2);

    var addNames = [], addPrices = [];
    document.querySelectorAll('.add-svc-checkbox:checked').forEach(function(cb) {
        addNames.push(cb.dataset.name);
        addPrices.push(parsePrice(cb.dataset.price).toFixed(2));
    });
    document.getElementById('hAdditionalServices').value = addNames.join(',');
    document.getElementById('hAdditionalPrices').value = addPrices.join(',');

    var partNames = [], partPricesArr = [];
    document.querySelectorAll('.part-name').forEach(function(n, i) {
        if (n.value.trim()) {
            partNames.push(n.value.trim());
            var p = document.querySelectorAll('.part-price')[i];
            partPricesArr.push(p ? (parseFloat(p.value) || 0).toFixed(2) : '0.00');
        }
    });
    document.getElementById('hParts').value = partNames.join(',');
    document.getElementById('hPartPrices').value = partPricesArr.join(',');

    var sc = parseFloat(document.getElementById('serviceChargeInput').value) || 0;
    document.getElementById('hServiceCharge').value = sc.toFixed(2);

    var additionalTotal = 0;
    document.querySelectorAll('.add-svc-checkbox:checked').forEach(function(cb) {
        additionalTotal += parsePrice(cb.dataset.price);
    });
    var partsTotal = sumInputs('part-price');
    var subtotal = originalPriceNum + additionalTotal + partsTotal + sc;
    document.getElementById('hSubtotal').value = subtotal.toFixed(2);
    document.getElementById('hTax').value = '0.00';
    document.getElementById('hTotal').value = subtotal.toFixed(2);
});
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

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Invoice #${estimate.estimateId} - Shift Auto Dynamics</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&family=Oswald:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        @keyframes fadeIn { from { opacity: 0; transform: translateY(15px); } to { opacity: 1; transform: translateY(0); } }

        /* ===== SCREEN STYLES ===== */
        .invoice-wrapper {
            max-width: 900px; margin: 30px auto; background: white; border-radius: 16px;
            box-shadow: 0 8px 35px rgba(0,0,0,0.08); border: 1px solid var(--border);
            overflow: hidden; animation: fadeIn 0.5s ease;
        }

        /* Status Ribbon - removed, replaced with neutral */
        .invoice-status-ribbon {
            padding: 12px 30px; text-align: center; font-weight: 700; font-size: 0.85rem;
            letter-spacing: 2px; text-transform: uppercase;
            background: linear-gradient(90deg, #1a1a2e, #2d3748); color: white;
        }

        /* ===== PREMIUM HEADER WITH LOGO ===== */
        .inv-header {
            padding: 28px 35px 22px;
            display: flex; justify-content: space-between; align-items: flex-start;
            border-bottom: 3px solid #1565c0;
        }
        .inv-brand { display: flex; align-items: center; gap: 16px; }
        .inv-logo {
            width: 72px; height: 72px; border-radius: 10px; object-fit: cover;
            box-shadow: 0 4px 12px rgba(0,0,0,0.12); border: 2px solid #e3f2fd;
        }
        .inv-company h1 {
            font-family: 'Oswald', sans-serif; font-size: 1.65rem; font-weight: 700;
            letter-spacing: 2px; color: #1a1a2e; margin: 0; line-height: 1.15;
        }
        .inv-company h1 span { color: #1565c0; }
        .inv-company .tagline {
            font-size: 0.66rem; font-weight: 600; color: #999; letter-spacing: 1.5px;
            text-transform: uppercase; margin-top: 2px;
        }
        .inv-company .contact {
            font-size: 0.75rem; color: #777; margin-top: 4px;
        }

        .inv-meta { text-align: right; }
        .inv-meta h2 {
            font-family: 'Oswald', sans-serif; font-size: 1.7rem; color: #1565c0;
            margin: 0 0 8px 0; letter-spacing: 3px; font-weight: 700;
        }
        .inv-meta-line { font-size: 0.82rem; color: #555; margin-top: 3px; line-height: 1.5; }
        .inv-meta-line strong { color: #333; }

        /* ===== BILL TO & VEHICLE ===== */
        .inv-parties {
            display: grid; grid-template-columns: 1fr 1fr;
            border-bottom: 1px solid #eaeaea;
        }
        .inv-party {
            padding: 16px 35px;
        }
        .inv-party:first-child { border-right: 1px solid #eaeaea; }
        .inv-party-label {
            font-family: 'Oswald', sans-serif; font-size: 0.7rem; font-weight: 700;
            color: #1565c0; text-transform: uppercase; letter-spacing: 2px;
            margin: 0 0 6px 0; padding-bottom: 4px; border-bottom: 2px solid #e3f2fd;
            display: inline-block;
        }
        .inv-party-name { font-size: 0.92rem; font-weight: 700; color: #1a1a2e; margin: 0; }
        .inv-party-sub { font-size: 0.8rem; color: #777; margin: 2px 0 0 0; }

        /* ===== LINE ITEMS TABLE ===== */
        .inv-body { padding: 18px 35px 12px; }
        .inv-tbl { width: 100%; border-collapse: collapse; }
        .inv-tbl thead th {
            text-align: left; font-family: 'Oswald', sans-serif; font-size: 0.68rem;
            font-weight: 700; color: #fff; text-transform: uppercase;
            letter-spacing: 1.5px; padding: 9px 14px; background: #1a1a2e;
        }
        .inv-tbl thead th:first-child { border-radius: 6px 0 0 6px; }
        .inv-tbl thead th:last-child { text-align: right; border-radius: 0 6px 6px 0; }
        .inv-tbl td {
            padding: 10px 14px; font-size: 0.88rem; color: #333;
            border-bottom: 1px solid #f0f0f0;
        }
        .inv-tbl td:first-child { font-weight: 500; color: #999; width: 5%; }
        .inv-tbl td:last-child { text-align: right; font-weight: 700; color: #1a1a2e; }
        .inv-tbl tr:hover { background: #fafbfc; }
        .inv-section td {
            padding: 7px 14px !important; font-family: 'Oswald', sans-serif;
            font-size: 0.7rem !important; font-weight: 700 !important; color: #1565c0 !important;
            text-transform: uppercase; letter-spacing: 1.5px;
            background: #f0f5ff !important; border-bottom: 1px solid #dce7f7 !important;
        }

        /* ===== TOTALS ===== */
        .inv-totals { padding: 0 35px 18px; display: flex; justify-content: flex-end; }
        .inv-totals-inner { min-width: 300px; }
        .inv-total-line {
            display: flex; justify-content: space-between; padding: 7px 0;
            font-size: 0.88rem; color: #555;
        }
        .inv-total-line.grand {
            font-size: 1.2rem; font-weight: 800; color: #1565c0;
            border-top: 2px solid #1565c0; padding-top: 10px; margin-top: 6px;
        }

        /* ===== NOTES ===== */
        .inv-notes-box {
            padding: 14px 35px; background: #fafbfc; border-top: 1px solid #eaeaea;
        }
        .inv-notes-box h4 { font-family: 'Oswald', sans-serif; font-size: 0.78rem; color: #333; margin: 0 0 3px 0; text-transform: uppercase; letter-spacing: 1px; }
        .inv-notes-box p { font-size: 0.82rem; color: #666; margin: 0; }

        /* ===== PRINT FOOTER (hidden on screen) ===== */
        .inv-print-footer { display: none; }

        /* ===== ACTION BAR ===== */
        .inv-actions {
            display: flex; justify-content: center; gap: 12px; padding: 18px;
            background: #f8f9fa; border-top: 1px solid var(--border);
        }
        .act-btn {
            padding: 10px 25px; border-radius: 6px; font-weight: 700; font-size: 0.85rem;
            text-decoration: none; text-transform: uppercase; letter-spacing: 0.5px;
            transition: all 0.3s; cursor: pointer; border: none;
        }
        .act-print { background: #1565c0; color: white; }
        .act-print:hover { background: #0d47a1; }
        .act-edit { background: #e65100; color: white; }
        .act-edit:hover { background: #bf360c; }
        .act-back { background: #f5f5f5; color: var(--dark); border: 1px solid #ddd; }
        .act-back:hover { background: #e0e0e0; }

        @media (max-width: 768px) {
            .inv-header { flex-direction: column; gap: 15px; padding: 20px; }
            .inv-meta { text-align: left; }
            .inv-parties { grid-template-columns: 1fr; }
            .inv-party:first-child { border-right: none; border-bottom: 1px solid #eaeaea; }
            .invoice-wrapper { margin: 10px; border-radius: 10px; }
            .inv-body, .inv-totals, .inv-notes-box { padding-left: 20px; padding-right: 20px; }
        }

        /* ============================================================
           PRINT STYLES — CLEAN PROFESSIONAL A4 BILL
           ============================================================ */
        @media print {
            @page {
                size: A4 portrait;
                margin: 8mm 12mm 8mm 12mm;
            }

            *, *::before, *::after {
                -webkit-print-color-adjust: exact !important;
                print-color-adjust: exact !important;
            }

            html, body {
                margin: 0 !important; padding: 0 !important;
                background: #fff !important; font-size: 14px !important;
                -webkit-print-color-adjust: exact !important;
            }

            /* ── HIDE everything that should NOT print ── */
            .navbar-custom       { display: none !important; visibility: hidden !important; height: 0 !important; overflow: hidden !important; }
            .invoice-status-ribbon { display: none !important; visibility: hidden !important; height: 0 !important; overflow: hidden !important; }
            .inv-actions         { display: none !important; visibility: hidden !important; height: 0 !important; overflow: hidden !important; }
            .no-print            { display: none !important; }
            .nav-hamburger       { display: none !important; }

            /* ── Reset page container ── */
            .page-container {
                display: block !important; margin: 0 !important; padding: 0 !important;
                max-width: 100% !important; width: 100% !important;
            }

            .invoice-wrapper {
                box-shadow: none !important; border: none !important;
                margin: 0 !important; padding: 0 !important;
                border-radius: 0 !important; max-width: 100% !important;
                width: 100% !important; page-break-inside: avoid;
            }

            /* ── Header — tight ── */
            .inv-header {
                padding: 0 0 8px 0 !important;
                border-bottom: 2px solid #1565c0 !important;
            }
            .inv-logo {
                width: 70px !important; height: 70px !important;
                border-radius: 10px !important;
                box-shadow: none !important; border: 1px solid #ddd !important;
            }
            .inv-brand { gap: 14px !important; }
            .inv-company h1 { font-size: 1.6rem !important; }
            .inv-company .tagline { font-size: 0.72rem !important; }
            .inv-company .contact { font-size: 0.82rem !important; }
            .inv-meta h2 { font-size: 1.7rem !important; }
            .inv-meta-line { font-size: 0.92rem !important; }

            /* ── Parties — tight ── */
            .inv-parties { border-bottom: 1px solid #ddd !important; }
            .inv-party { padding: 6px 0 !important; }
            .inv-party:first-child { padding-right: 20px !important; border-right: 1px solid #ddd !important; }
            .inv-party:last-child { padding-left: 20px !important; }
            .inv-party-label { font-size: 0.82rem !important; margin-bottom: 2px !important; }
            .inv-party-name { font-size: 1.05rem !important; }
            .inv-party-sub { font-size: 0.9rem !important; }

            /* ── Table — tight ── */
            .inv-body { padding: 4px 0 2px !important; }
            .inv-tbl thead th { font-size: 0.78rem !important; padding: 6px 14px !important; }
            .inv-tbl td { font-size: 0.95rem !important; padding: 5px 14px !important; }
            .inv-section td { font-size: 0.75rem !important; padding: 4px 14px !important; }
            .inv-tbl tr:hover { background: transparent !important; }

            /* ── Totals — tight ── */
            .inv-totals { padding: 0 0 4px !important; }
            .inv-total-line { font-size: 1rem !important; padding: 3px 0 !important; }
            .inv-total-line.grand { font-size: 1.25rem !important; padding-top: 5px !important; margin-top: 3px !important; }

            /* ── Notes — tight ── */
            .inv-notes-box { padding: 4px 0 !important; background: transparent !important; border-top: 1px solid #ddd !important; }
            .inv-notes-box h4 { font-size: 0.88rem !important; margin: 0 0 1px 0 !important; }
            .inv-notes-box p { font-size: 0.88rem !important; margin: 0 !important; }

            /* ── SHOW print footer ── */
            .inv-print-footer {
                display: block !important;
                visibility: visible !important;
            }
        }
    </style>
</head>
<body>

<!-- ══════════════ NAVBAR (hidden in print) ══════════════ -->
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

<!-- ══════════════ INVOICE CONTENT ══════════════ -->
<div class="page-container">
    <div class="invoice-wrapper">

        <!-- HEADER RIBBON -->
        <div class="invoice-status-ribbon">📑 INVOICE</div>

        <!-- ═══ HEADER: LOGO + COMPANY + INVOICE META ═══ -->
        <div class="inv-header">
            <div class="inv-brand">
                <img src="${pageContext.request.contextPath}/images/shift_logo.png" alt="Shift Auto Dynamics" class="inv-logo" />
                <div class="inv-company">
                    <h1>SHIFT AUTO <span>DYNAMICS</span></h1>
                    <div class="tagline">Precision in Motion | Engineered for Excellence</div>
                    <div class="contact">Contact: info@shiftautodynamics.lk</div>
                </div>
            </div>
            <div class="inv-meta">
                <h2>INVOICE</h2>
                <div class="inv-meta-line"><strong>Invoice No:</strong> ${estimate.estimateId}</div>
                <div class="inv-meta-line"><strong>Date:</strong> ${estimate.createdDate}</div>
                <div class="inv-meta-line"><strong>Appointment:</strong> #${estimate.appointmentId}</div>
            </div>
        </div>

        <!-- ═══ BILL TO & VEHICLE ═══ -->
        <div class="inv-parties">
            <div class="inv-party">
                <div class="inv-party-label">Bill To</div>
                <p class="inv-party-name">${estimate.userName}</p>
                <p class="inv-party-sub">Customer ID: ${estimate.userId}</p>
            </div>
            <div class="inv-party">
                <div class="inv-party-label">Vehicle</div>
                <p class="inv-party-name">${estimate.vehicleInfo}</p>
                <p class="inv-party-sub">Vehicle ID: ${estimate.vehicleId}</p>
            </div>
        </div>

        <!-- ═══ LINE ITEMS TABLE ═══ -->
        <div class="inv-body">
            <table class="inv-tbl">
                <thead>
                    <tr>
                        <th style="width: 5%;">#</th>
                        <th>Description</th>
                        <th style="width: 22%;">Amount (Rs.)</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- BOOKED SERVICES -->
                    <tr class="inv-section">
                        <td colspan="3">🔧 Booked Services</td>
                    </tr>
                    <c:set var="rowNum" value="1"/>
                    <c:forTokens var="svc" items="${estimate.serviceItems}" delims="," varStatus="loop">
                        <tr>
                            <td>${rowNum}</td>
                            <td>${svc}</td>
                            <td><c:if test="${loop.first}">${estimate.servicePrices}</c:if></td>
                        </tr>
                        <c:set var="rowNum" value="${rowNum + 1}"/>
                    </c:forTokens>

                    <!-- ADDITIONAL SERVICES -->
                    <c:if test="${not empty estimate.additionalServices}">
                        <tr class="inv-section">
                            <td colspan="3">➕ Additional Services</td>
                        </tr>
                        <c:set var="addSvcs" value="${fn:split(estimate.additionalServices, ',')}"/>
                        <c:set var="addPrices" value="${fn:split(estimate.additionalPrices, ',')}"/>
                        <c:forEach var="i" begin="0" end="${fn:length(addSvcs) - 1}">
                            <tr>
                                <td>${rowNum}</td>
                                <td>${addSvcs[i]}</td>
                                <td>Rs. ${addPrices[i]}</td>
                            </tr>
                            <c:set var="rowNum" value="${rowNum + 1}"/>
                        </c:forEach>
                    </c:if>

                    <!-- PARTS -->
                    <c:if test="${not empty estimate.parts}">
                        <tr class="inv-section">
                            <td colspan="3">🔩 Parts & Materials</td>
                        </tr>
                        <c:set var="partNames" value="${fn:split(estimate.parts, ',')}"/>
                        <c:set var="partPricesArr" value="${fn:split(estimate.partPrices, ',')}"/>
                        <c:forEach var="i" begin="0" end="${fn:length(partNames) - 1}">
                            <tr>
                                <td>${rowNum}</td>
                                <td>${partNames[i]}</td>
                                <td>Rs. ${partPricesArr[i]}</td>
                            </tr>
                            <c:set var="rowNum" value="${rowNum + 1}"/>
                        </c:forEach>
                    </c:if>

                    <!-- SERVICE CHARGE -->
                    <c:if test="${not empty estimate.serviceCharge && estimate.serviceCharge != '0' && estimate.serviceCharge != '0.00'}">
                        <tr class="inv-section">
                            <td colspan="3">💰 Service Charge</td>
                        </tr>
                        <tr>
                            <td>${rowNum}</td>
                            <td>Service / Labour Charge</td>
                            <td>Rs. ${estimate.serviceCharge}</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <!-- ═══ TOTALS ═══ -->
        <div class="inv-totals">
            <div class="inv-totals-inner">
                <div class="inv-total-line">
                    <span>Subtotal</span>
                    <span>Rs. ${estimate.subtotal}</span>
                </div>
                <c:if test="${estimate.tax != '0' && estimate.tax != '0.00'}">
                    <div class="inv-total-line">
                        <span>Tax</span>
                        <span>Rs. ${estimate.tax}</span>
                    </div>
                </c:if>
                <div class="inv-total-line grand">
                    <span>TOTAL</span>
                    <span>Rs. ${estimate.total}</span>
                </div>
            </div>
        </div>

        <!-- NOTES -->
        <c:if test="${not empty estimate.notes}">
            <div class="inv-notes-box">
                <h4>Notes</h4>
                <p>${estimate.notes}</p>
            </div>
        </c:if>

        <!-- ═══ PRINT-ONLY: SIGNATURES + FOOTER ═══ -->
        <div class="inv-print-footer">
            <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 30px; margin-top: 15px;">
                <div style="text-align: center;">
                    <div style="border-top: 1.5px solid #333; padding-top: 5px; margin-top: 35px; font-size: 0.88rem; font-weight: 600; color: #555; letter-spacing: 0.5px;">Customer Signature</div>
                </div>
                <div style="text-align: center;">
                    <div style="border-top: 1.5px solid #333; padding-top: 5px; margin-top: 35px; font-size: 0.88rem; font-weight: 600; color: #555; letter-spacing: 0.5px;">Company Stamp</div>
                </div>
                <div style="text-align: center;">
                    <div style="border-top: 1.5px solid #333; padding-top: 5px; margin-top: 35px; font-size: 0.88rem; font-weight: 600; color: #555; letter-spacing: 0.5px;">Authorized Signature</div>
                </div>
            </div>
            <div style="text-align: center; margin-top: 10px; padding-top: 8px; border-top: 2px solid #1565c0;">
                <p style="font-size: 0.82rem; color: #999; margin: 0;">This is a computer-generated invoice. | Payment terms: Due upon receipt.</p>
                <p style="font-size: 0.95rem; color: #1565c0; font-weight: 700; margin: 4px 0 0 0; letter-spacing: 0.5px;">Thank you for choosing Shift Auto Dynamics!</p>
            </div>
        </div>

        <!-- ═══ ACTION BUTTONS (hidden in print) ═══ -->
        <div class="inv-actions">
            <a href="estimate" class="act-btn act-back">← BACK</a>
            <button onclick="printInvoice()" class="act-btn act-print">🖨️ PRINT</button>
            <c:if test="${isAdmin}">
                <a href="estimate?action=edit&id=${estimate.estimateId}" class="act-btn act-edit">✏️ EDIT</a>
            </c:if>
        </div>
    </div>
</div>

<script>
function printInvoice() {
    var logoUrl = '${pageContext.request.contextPath}/images/shift_logo.png';
    var fullLogoUrl = window.location.origin + logoUrl;

    var printContent = document.querySelector('.invoice-wrapper');
    
    // Clone and clean the content
    var clone = printContent.cloneNode(true);
    
    // Remove status ribbon
    var ribbon = clone.querySelector('.invoice-status-ribbon');
    if (ribbon) ribbon.remove();
    
    // Remove action buttons
    var actions = clone.querySelector('.inv-actions');
    if (actions) actions.remove();
    
    // Show print footer
    var footer = clone.querySelector('.inv-print-footer');
    if (footer) footer.style.display = 'block';

    // Fix logo src to absolute URL
    var logo = clone.querySelector('.inv-logo');
    if (logo) logo.src = fullLogoUrl;

    var printWindow = window.open('', '_blank', 'width=900,height=700');
    printWindow.document.write('<!DOCTYPE html><html><head><meta charset="UTF-8">');
    printWindow.document.write('<title>Invoice Print</title>');
    printWindow.document.write('<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&family=Oswald:wght@400;500;600;700&display=swap" rel="stylesheet">');
    printWindow.document.write('<style>');
    printWindow.document.write('\
        @page { size: A4 portrait; margin: 10mm 14mm; }\
        * { margin: 0; padding: 0; box-sizing: border-box; -webkit-print-color-adjust: exact !important; print-color-adjust: exact !important; }\
        body { font-family: "Inter", Arial, sans-serif; font-size: 13px; color: #333; background: #fff; }\
        \
        .inv-header { padding: 0 0 10px; display: flex; justify-content: space-between; align-items: flex-start; border-bottom: 3px solid #1565c0; margin-bottom: 0; }\
        .inv-brand { display: flex; align-items: center; gap: 14px; }\
        .inv-logo { width: 65px; height: 65px; border-radius: 10px; object-fit: cover; border: 1px solid #ddd; }\
        .inv-company h1 { font-family: "Oswald", sans-serif; font-size: 1.5rem; font-weight: 700; letter-spacing: 2px; color: #1a1a2e; margin: 0; line-height: 1.15; }\
        .inv-company h1 span { color: #1565c0; }\
        .inv-company .tagline { font-size: 0.65rem; font-weight: 600; color: #999; letter-spacing: 1.5px; text-transform: uppercase; margin-top: 2px; }\
        .inv-company .contact { font-size: 0.72rem; color: #777; margin-top: 3px; }\
        .inv-meta { text-align: right; }\
        .inv-meta h2 { font-family: "Oswald", sans-serif; font-size: 1.6rem; color: #1565c0; margin: 0 0 6px; letter-spacing: 3px; font-weight: 700; }\
        .inv-meta-line { font-size: 0.85rem; color: #555; margin-top: 2px; line-height: 1.4; }\
        .inv-meta-line strong { color: #333; }\
        \
        .inv-parties { display: grid; grid-template-columns: 1fr 1fr; border-bottom: 1px solid #e0e0e0; }\
        .inv-party { padding: 8px 0; }\
        .inv-party:first-child { border-right: 1px solid #e0e0e0; padding-right: 18px; }\
        .inv-party:last-child { padding-left: 18px; }\
        .inv-party-label { font-family: "Oswald", sans-serif; font-size: 0.72rem; font-weight: 700; color: #1565c0; text-transform: uppercase; letter-spacing: 2px; margin: 0 0 3px; padding-bottom: 3px; border-bottom: 2px solid #e3f2fd; display: inline-block; }\
        .inv-party-name { font-size: 0.95rem; font-weight: 700; color: #1a1a2e; margin: 0; }\
        .inv-party-sub { font-size: 0.82rem; color: #777; margin: 1px 0 0; }\
        \
        .inv-body { padding: 6px 0 4px; }\
        .inv-tbl { width: 100%; border-collapse: collapse; }\
        .inv-tbl thead th { text-align: left; font-family: "Oswald", sans-serif; font-size: 0.7rem; font-weight: 700; color: #fff; text-transform: uppercase; letter-spacing: 1.5px; padding: 7px 12px; background: #1a1a2e; }\
        .inv-tbl thead th:first-child { border-radius: 5px 0 0 5px; }\
        .inv-tbl thead th:last-child { text-align: right; border-radius: 0 5px 5px 0; }\
        .inv-tbl td { padding: 6px 12px; font-size: 0.88rem; color: #333; border-bottom: 1px solid #f0f0f0; }\
        .inv-tbl td:first-child { font-weight: 500; color: #999; width: 5%; }\
        .inv-tbl td:last-child { text-align: right; font-weight: 700; color: #1a1a2e; }\
        .inv-section td { padding: 5px 12px !important; font-family: "Oswald", sans-serif; font-size: 0.68rem !important; font-weight: 700 !important; color: #1565c0 !important; text-transform: uppercase; letter-spacing: 1.5px; background: #f0f5ff !important; border-bottom: 1px solid #dce7f7 !important; }\
        \
        .inv-totals { padding: 0 0 6px; display: flex; justify-content: flex-end; }\
        .inv-totals-inner { min-width: 280px; }\
        .inv-total-line { display: flex; justify-content: space-between; padding: 4px 0; font-size: 0.92rem; color: #555; }\
        .inv-total-line.grand { font-size: 1.15rem; font-weight: 800; color: #1565c0; border-top: 2px solid #1565c0; padding-top: 6px; margin-top: 4px; }\
        \
        .inv-notes-box { padding: 5px 0; border-top: 1px solid #e0e0e0; }\
        .inv-notes-box h4 { font-family: "Oswald", sans-serif; font-size: 0.78rem; color: #333; margin: 0 0 2px; text-transform: uppercase; letter-spacing: 1px; }\
        .inv-notes-box p { font-size: 0.82rem; color: #666; margin: 0; }\
        \
        .inv-print-footer { display: block; margin-top: 10px; }\
    ');
    printWindow.document.write('</style></head><body>');
    printWindow.document.write(clone.innerHTML);
    printWindow.document.write('</body></html>');
    printWindow.document.close();

    // Wait for fonts + images to load, then print
    var img = printWindow.document.querySelector('.inv-logo');
    function doPrint() {
        setTimeout(function() {
            printWindow.focus();
            printWindow.print();
            printWindow.close();
        }, 400);
    }
    if (img && !img.complete) {
        img.onload = doPrint;
        img.onerror = doPrint;
    } else {
        doPrint();
    }
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

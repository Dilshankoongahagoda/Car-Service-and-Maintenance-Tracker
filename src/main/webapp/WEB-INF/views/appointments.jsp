<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointments - Shift Auto Dynamics</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
    <style>
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        .appt-card {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.06);
            border: 1px solid var(--border);
            border-left: 5px solid var(--primary);
            animation: fadeIn 0.5s ease forwards;
            opacity: 0;
            margin-bottom: 20px;
        }
        .appt-card:nth-child(1) { animation-delay: 0.1s; }
        .appt-card:nth-child(2) { animation-delay: 0.2s; }
        .appt-card:nth-child(3) { animation-delay: 0.3s; }
        .appt-card:nth-child(4) { animation-delay: 0.4s; }
        .appt-card.status-PENDING { border-left-color: #ff9800; }
        .appt-card.status-CONFIRMED { border-left-color: var(--primary); }
        .appt-card.status-COMPLETED { border-left-color: #2E7D32; }
        .appt-card.status-CANCELLED { border-left-color: #ccc; opacity: 0.7; }

        .appt-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; }
        .appt-header h3 { margin: 0; font-family: 'Oswald', sans-serif; font-size: 1.3rem; color: var(--dark); }
        .status-badge {
            padding: 5px 14px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .status-PENDING { background: #fff3e0; color: #e65100; }
        .status-CONFIRMED { background: #e3f2fd; color: #1565c0; }
        .status-COMPLETED { background: #e8f5e9; color: #2e7d32; }
        .status-CANCELLED { background: #f5f5f5; color: #999; }

        .appt-details { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-bottom: 15px; }
        .appt-detail { font-size: 0.9rem; }
        .appt-detail .label { color: var(--text-muted); font-size: 0.75rem; text-transform: uppercase; font-weight: 600; letter-spacing: 0.5px; }
        .appt-detail .value { color: var(--dark); font-weight: 500; }

        .appt-actions { display: flex; gap: 10px; border-top: 1px solid var(--border); padding-top: 15px; flex-wrap: wrap; }
        .appt-actions a {
            padding: 6px 16px;
            border-radius: 4px;
            font-size: 0.8rem;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s;
        }
        .btn-confirm { background: #e3f2fd; color: #1565c0; border: 1px solid #1565c0; }
        .btn-confirm:hover { background: #1565c0; color: white; }
        .btn-complete { background: #e8f5e9; color: #2e7d32; border: 1px solid #2e7d32; }
        .btn-complete:hover { background: #2e7d32; color: white; }
        .btn-cancel-appt { background: #fff3e0; color: #e65100; border: 1px solid #e65100; }
        .btn-cancel-appt:hover { background: #e65100; color: white; }
        @media (max-width: 576px) {
            .appt-details { grid-template-columns: 1fr; }
            .appt-header { flex-direction: column; align-items: flex-start; gap: 8px; }
            .appt-actions { gap: 8px; }
            .appt-card { padding: 18px; }
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
                <li><a href="appointment" class="active">APPOINTMENTS</a></li>
                <li><a href="estimate">ESTIMATES</a></li>
            </c:if>
            <c:if test="${!isAdmin}">
                <li><a href="dashboard">VEHICLES</a></li>
                <li><a href="service">SERVICES</a></li>
                <li><a href="appointment" class="active">APPOINTMENTS</a></li>
                <li><a href="reminder">REMINDERS</a></li>
                <li><a href="estimate">ESTIMATES</a></li>
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

<div class="page-container">
    <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; border-bottom: 3px solid var(--primary); padding-bottom: 15px; margin-bottom: 30px;">
        <h1 style="font-family: 'Oswald', sans-serif; font-size: 2.5rem; color: var(--dark);">
            <c:if test="${isAdmin}">ALL APPOINTMENTS</c:if>
            <c:if test="${!isAdmin}">MY APPOINTMENTS</c:if>
        </h1>
        <div style="display: flex; gap: 12px;">
            <c:if test="${isAdmin}">
                <a href="appointment?action=completed" style="padding: 12px 25px; font-size: 0.9rem; text-decoration: none; border-radius: 4px; font-weight: bold; background: #2E7D32; color: white; letter-spacing: 1px;">✓ COMPLETED SERVICES</a>
            </c:if>
            <c:if test="${!isAdmin}">
                <a href="appointment?action=book" class="btn-primary-custom" style="padding: 12px 25px; font-size: 1rem; text-decoration: none; border-radius: 4px; font-weight: bold;">BOOK APPOINTMENT &gt;</a>
            </c:if>
        </div>
    </div>

    <!-- ============ ADMIN VIEW: 3 SECTIONS ============ -->
    <c:if test="${isAdmin}">

        <!-- ═══ APPOINTMENT CALENDAR ═══ -->
        <div id="calendarWidget" style="margin-bottom: 40px; background: white; border-radius: 14px; box-shadow: 0 4px 24px rgba(0,0,0,0.07); border: 1px solid var(--border); overflow: hidden;">
            <!-- Calendar Header -->
            <div style="background: linear-gradient(135deg, #1a1a2e, #16213e); padding: 18px 24px; display: flex; justify-content: space-between; align-items: center;">
                <button onclick="changeMonth(-1)" style="background: rgba(255,255,255,0.12); border: none; color: white; width: 36px; height: 36px; border-radius: 50%; cursor: pointer; font-size: 1.1rem; display: flex; align-items: center; justify-content: center; transition: background 0.3s;">◀</button>
                <h2 id="calMonthYear" style="font-family: 'Oswald', sans-serif; font-size: 1.5rem; color: white; margin: 0; letter-spacing: 2px;"></h2>
                <button onclick="changeMonth(1)" style="background: rgba(255,255,255,0.12); border: none; color: white; width: 36px; height: 36px; border-radius: 50%; cursor: pointer; font-size: 1.1rem; display: flex; align-items: center; justify-content: center; transition: background 0.3s;">▶</button>
            </div>
            <!-- Legend -->
            <div style="display: flex; gap: 20px; padding: 10px 24px; background: #f8f9fa; border-bottom: 1px solid #eee; flex-wrap: wrap;">
                <span style="display: flex; align-items: center; gap: 5px; font-size: 0.75rem; font-weight: 600; color: #666;">
                    <span style="width: 10px; height: 10px; border-radius: 50%; background: #ff9800; display: inline-block;"></span> Pending
                </span>
                <span style="display: flex; align-items: center; gap: 5px; font-size: 0.75rem; font-weight: 600; color: #666;">
                    <span style="width: 10px; height: 10px; border-radius: 50%; background: #1565c0; display: inline-block;"></span> Confirmed
                </span>
                <span style="display: flex; align-items: center; gap: 5px; font-size: 0.75rem; font-weight: 600; color: #666;">
                    <span style="width: 10px; height: 10px; border-radius: 50%; background: #2E7D32; display: inline-block;"></span> Completed
                </span>
            </div>
            <!-- Weekday Headers -->
            <div style="display: grid; grid-template-columns: repeat(7, 1fr); background: #f8f9fa; border-bottom: 1px solid #eee;">
                <div style="text-align: center; padding: 8px; font-family: 'Oswald', sans-serif; font-size: 0.75rem; font-weight: 700; color: #e53935; letter-spacing: 1px;">SUN</div>
                <div style="text-align: center; padding: 8px; font-family: 'Oswald', sans-serif; font-size: 0.75rem; font-weight: 700; color: #999; letter-spacing: 1px;">MON</div>
                <div style="text-align: center; padding: 8px; font-family: 'Oswald', sans-serif; font-size: 0.75rem; font-weight: 700; color: #999; letter-spacing: 1px;">TUE</div>
                <div style="text-align: center; padding: 8px; font-family: 'Oswald', sans-serif; font-size: 0.75rem; font-weight: 700; color: #999; letter-spacing: 1px;">WED</div>
                <div style="text-align: center; padding: 8px; font-family: 'Oswald', sans-serif; font-size: 0.75rem; font-weight: 700; color: #999; letter-spacing: 1px;">THU</div>
                <div style="text-align: center; padding: 8px; font-family: 'Oswald', sans-serif; font-size: 0.75rem; font-weight: 700; color: #999; letter-spacing: 1px;">FRI</div>
                <div style="text-align: center; padding: 8px; font-family: 'Oswald', sans-serif; font-size: 0.75rem; font-weight: 700; color: #4CAF50; letter-spacing: 1px;">SAT</div>
            </div>
            <!-- Calendar Grid -->
            <div id="calGrid" style="display: grid; grid-template-columns: repeat(7, 1fr);"></div>
            <!-- Selected Day Detail -->
            <div id="calDetail" style="display: none; padding: 18px 24px; border-top: 2px solid var(--primary); background: #f8fbff;">
                <h3 id="calDetailTitle" style="font-family: 'Oswald', sans-serif; font-size: 1.1rem; color: #1565c0; margin: 0 0 12px 0; letter-spacing: 1px;"></h3>
                <div id="calDetailList"></div>
            </div>
        </div>

        <style>
            .cal-day {
                text-align: center; padding: 8px 4px; min-height: 70px; border: 1px solid #f0f0f0;
                cursor: pointer; transition: all 0.2s; position: relative; display: flex; flex-direction: column; align-items: center;
            }
            .cal-day:hover { background: #f0f5ff; }
            .cal-day.today { background: #e3f2fd; }
            .cal-day.selected { background: #1565c0; }
            .cal-day.selected .cal-num { color: white !important; }
            .cal-day.empty { cursor: default; background: #fafafa; }
            .cal-day.empty:hover { background: #fafafa; }
            .cal-num { font-size: 0.95rem; font-weight: 700; color: #333; margin-bottom: 4px; }
            .cal-day.today .cal-num { color: #1565c0; }
            .cal-dots { display: flex; gap: 3px; justify-content: center; flex-wrap: wrap; margin-top: 2px; }
            .cal-dot { width: 7px; height: 7px; border-radius: 50%; }
            .cal-count { font-size: 0.65rem; font-weight: 700; color: #1565c0; margin-top: 2px; }
            .cal-detail-item {
                background: white; border-radius: 8px; padding: 12px 16px; margin-bottom: 8px;
                border-left: 4px solid #1565c0; box-shadow: 0 1px 4px rgba(0,0,0,0.06);
                display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 8px;
            }
            .cal-detail-item.st-PENDING { border-left-color: #ff9800; }
            .cal-detail-item.st-CONFIRMED { border-left-color: #1565c0; }
            .cal-detail-item.st-COMPLETED { border-left-color: #2E7D32; }
            @media (max-width: 576px) {
                .cal-day { min-height: 50px; padding: 4px 2px; }
                .cal-num { font-size: 0.8rem; }
                .cal-dot { width: 5px; height: 5px; }
                #calendarWidget { border-radius: 10px; }
            }
        </style>

        <script>
        (function() {
            // Build appointment data from server
            var appointments = [];
            <c:forEach var="a" items="${appointments}">
                appointments.push({
                    id: '${a.appointmentId}',
                    date: '${a.preferredDate}',
                    time: '${a.preferredTime}',
                    user: '${a.userName}',
                    vehicle: '${a.vehicleInfo}',
                    status: '${a.status}',
                    services: '${a.serviceName}',
                    price: '${a.servicePrice}'
                });
            </c:forEach>

            var currentDate = new Date();
            var selectedDate = null;

            var statusColors = { PENDING: '#ff9800', CONFIRMED: '#1565c0', COMPLETED: '#2E7D32' };
            var statusLabels = { PENDING: '⏳ PENDING', CONFIRMED: '🔧 CONFIRMED', COMPLETED: '✓ COMPLETED' };
            var monthNames = ['JANUARY','FEBRUARY','MARCH','APRIL','MAY','JUNE','JULY','AUGUST','SEPTEMBER','OCTOBER','NOVEMBER','DECEMBER'];

            function getApptsByDate(dateStr) {
                return appointments.filter(function(a) { return a.date === dateStr; });
            }

            function formatDate(y, m, d) {
                return y + '-' + String(m + 1).padStart(2, '0') + '-' + String(d).padStart(2, '0');
            }

            function renderCalendar() {
                var year = currentDate.getFullYear();
                var month = currentDate.getMonth();
                document.getElementById('calMonthYear').textContent = monthNames[month] + ' ' + year;

                var firstDay = new Date(year, month, 1).getDay();
                var daysInMonth = new Date(year, month + 1, 0).getDate();
                var today = new Date();
                var todayStr = formatDate(today.getFullYear(), today.getMonth(), today.getDate());

                var grid = document.getElementById('calGrid');
                grid.innerHTML = '';

                // Empty cells before first day
                for (var i = 0; i < firstDay; i++) {
                    var empty = document.createElement('div');
                    empty.className = 'cal-day empty';
                    grid.appendChild(empty);
                }

                // Day cells
                for (var d = 1; d <= daysInMonth; d++) {
                    var dateStr = formatDate(year, month, d);
                    var dayAppts = getApptsByDate(dateStr);
                    var cell = document.createElement('div');
                    cell.className = 'cal-day';
                    if (dateStr === todayStr) cell.className += ' today';
                    if (selectedDate === dateStr) cell.className += ' selected';

                    var num = document.createElement('div');
                    num.className = 'cal-num';
                    num.textContent = d;
                    cell.appendChild(num);

                    if (dayAppts.length > 0) {
                        var dots = document.createElement('div');
                        dots.className = 'cal-dots';
                        var shown = {};
                        dayAppts.forEach(function(a) {
                            if (!shown[a.status]) {
                                var dot = document.createElement('span');
                                dot.className = 'cal-dot';
                                dot.style.background = statusColors[a.status] || '#999';
                                dots.appendChild(dot);
                                shown[a.status] = true;
                            }
                        });
                        cell.appendChild(dots);
                        var count = document.createElement('div');
                        count.className = 'cal-count';
                        count.textContent = dayAppts.length + ' appt' + (dayAppts.length > 1 ? 's' : '');
                        cell.appendChild(count);
                    }

                    cell.setAttribute('data-date', dateStr);
                    cell.addEventListener('click', function() {
                        var dt = this.getAttribute('data-date');
                        selectDate(dt);
                    });
                    grid.appendChild(cell);
                }
            }

            function selectDate(dateStr) {
                selectedDate = dateStr;
                renderCalendar();
                var dayAppts = getApptsByDate(dateStr);
                var detail = document.getElementById('calDetail');
                var title = document.getElementById('calDetailTitle');
                var list = document.getElementById('calDetailList');

                if (dayAppts.length === 0) {
                    detail.style.display = 'block';
                    title.textContent = '📅 ' + dateStr;
                    list.innerHTML = '<p style="color: #999; font-size: 0.9rem; margin: 0;">No appointments on this date.</p>';
                    return;
                }

                detail.style.display = 'block';
                title.textContent = '📅 ' + dateStr + ' — ' + dayAppts.length + ' Appointment' + (dayAppts.length > 1 ? 's' : '');
                list.innerHTML = '';

                dayAppts.forEach(function(a) {
                    var item = document.createElement('div');
                    item.className = 'cal-detail-item st-' + a.status;
                    item.innerHTML =
                        '<div>' +
                            '<div style="font-weight: 700; color: #1a1a2e; font-size: 0.95rem;">' + a.user + '</div>' +
                            '<div style="font-size: 0.82rem; color: #666; margin-top: 2px;">' + a.vehicle + '</div>' +
                            '<div style="font-size: 0.78rem; color: #999; margin-top: 3px;">' + a.services + '</div>' +
                        '</div>' +
                        '<div style="text-align: right;">' +
                            '<div style="font-size: 0.75rem; font-weight: 700; color: ' + (statusColors[a.status] || '#999') + '; padding: 3px 10px; border-radius: 12px; background: ' + (a.status === 'PENDING' ? '#fff3e0' : a.status === 'CONFIRMED' ? '#e3f2fd' : '#e8f5e9') + ';">' + (statusLabels[a.status] || a.status) + '</div>' +
                            '<div style="font-size: 0.82rem; font-weight: 600; color: #1565c0; margin-top: 4px;">🕐 ' + a.time + '</div>' +
                            '<div style="font-size: 0.85rem; font-weight: 700; color: #1a1a2e; margin-top: 2px;">' + a.price + '</div>' +
                        '</div>';
                    list.appendChild(item);
                });
            }

            window.changeMonth = function(dir) {
                currentDate.setMonth(currentDate.getMonth() + dir);
                selectedDate = null;
                document.getElementById('calDetail').style.display = 'none';
                renderCalendar();
            };

            renderCalendar();
        })();
        </script>
        <!-- SECTION 1: PENDING — Needs Confirmation -->
        <div style="margin-bottom: 40px;">
            <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 18px; padding-bottom: 10px; border-bottom: 3px solid #ff9800;">
                <h2 style="font-family: 'Oswald', sans-serif; font-size: 1.6rem; color: #e65100; margin: 0; letter-spacing: 1px;">⏳ PENDING — NEEDS CONFIRMATION</h2>
                <span style="background: #fff3e0; color: #e65100; padding: 4px 14px; border-radius: 20px; font-size: 0.8rem; font-weight: 700;">${pendingAppointments.size()}</span>
            </div>
            <c:if test="${not empty pendingAppointments}">
                <c:forEach var="a" items="${pendingAppointments}">
                    <div class="appt-card status-PENDING">
                        <div class="appt-header">
                            <h3>Service Appointment <span style="font-size: 0.8rem; color: var(--text-muted); font-weight: 400;"> — by ${a.userName}</span></h3>
                            <span class="status-badge status-PENDING">PENDING</span>
                        </div>
                        <div class="appt-details">
                            <div class="appt-detail"><div class="label">Vehicle</div><div class="value">${a.vehicleInfo}</div></div>
                            <div class="appt-detail"><div class="label">Date & Time</div><div class="value">${a.preferredDate} at ${a.preferredTime}</div></div>
                            <div class="appt-detail" style="grid-column: 1 / -1;">
                                <div class="label">Selected Services</div>
                                <div class="value" style="margin-top: 5px;">
                                    <c:forTokens var="svc" items="${a.serviceName}" delims=",">
                                        <span style="display: inline-block; background: #e3f2fd; color: #1565c0; padding: 3px 10px; border-radius: 4px; font-size: 0.8rem; margin: 2px 4px 2px 0; font-weight: 600;">${svc}</span>
                                    </c:forTokens>
                                </div>
                            </div>
                            <div class="appt-detail"><div class="label">Categories</div><div class="value">${a.serviceCategory}</div></div>
                            <div class="appt-detail"><div class="label">Total Price</div><div class="value" style="color: var(--primary); font-weight: 700; font-size: 1.1rem;">${a.servicePrice}</div></div>
                            <c:if test="${not empty a.notes}">
                                <div class="appt-detail" style="grid-column: 1 / -1;"><div class="label">Notes</div><div class="value">${a.notes}</div></div>
                            </c:if>
                        </div>
                        <div class="appt-actions">
                            <a href="appointment?action=confirm&id=${a.appointmentId}" class="btn-confirm">✓ CONFIRM</a>
                            <a href="appointment?action=delete&id=${a.appointmentId}" class="btn-sm-danger" onclick="return confirm('Delete this appointment?')">DELETE</a>
                        </div>
                    </div>
                </c:forEach>
            </c:if>
            <c:if test="${empty pendingAppointments}">
                <div style="text-align: center; padding: 30px; background: #fffde7; border-radius: 10px; border: 1px dashed #ff9800;">
                    <p style="color: #e65100; margin: 0; font-weight: 500;">No pending appointments at the moment.</p>
                </div>
            </c:if>
        </div>

        <!-- SECTION 2: CONFIRMED — In Progress -->
        <div style="margin-bottom: 40px;">
            <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 18px; padding-bottom: 10px; border-bottom: 3px solid var(--primary);">
                <h2 style="font-family: 'Oswald', sans-serif; font-size: 1.6rem; color: #1565c0; margin: 0; letter-spacing: 1px;">🔧 CONFIRMED — IN PROGRESS</h2>
                <span style="background: #e3f2fd; color: #1565c0; padding: 4px 14px; border-radius: 20px; font-size: 0.8rem; font-weight: 700;">${confirmedAppointments.size()}</span>
            </div>
            <c:if test="${not empty confirmedAppointments}">
                <c:forEach var="a" items="${confirmedAppointments}">
                    <div class="appt-card status-CONFIRMED">
                        <div class="appt-header">
                            <h3>Service Appointment <span style="font-size: 0.8rem; color: var(--text-muted); font-weight: 400;"> — by ${a.userName}</span></h3>
                            <span class="status-badge status-CONFIRMED">CONFIRMED</span>
                        </div>
                        <div class="appt-details">
                            <div class="appt-detail"><div class="label">Vehicle</div><div class="value">${a.vehicleInfo}</div></div>
                            <div class="appt-detail"><div class="label">Date & Time</div><div class="value">${a.preferredDate} at ${a.preferredTime}</div></div>
                            <div class="appt-detail" style="grid-column: 1 / -1;">
                                <div class="label">Selected Services</div>
                                <div class="value" style="margin-top: 5px;">
                                    <c:forTokens var="svc" items="${a.serviceName}" delims=",">
                                        <span style="display: inline-block; background: #e3f2fd; color: #1565c0; padding: 3px 10px; border-radius: 4px; font-size: 0.8rem; margin: 2px 4px 2px 0; font-weight: 600;">${svc}</span>
                                    </c:forTokens>
                                </div>
                            </div>
                            <div class="appt-detail"><div class="label">Categories</div><div class="value">${a.serviceCategory}</div></div>
                            <div class="appt-detail"><div class="label">Total Price</div><div class="value" style="color: var(--primary); font-weight: 700; font-size: 1.1rem;">${a.servicePrice}</div></div>
                            <c:if test="${not empty a.notes}">
                                <div class="appt-detail" style="grid-column: 1 / -1;"><div class="label">Notes</div><div class="value">${a.notes}</div></div>
                            </c:if>
                        </div>
                        <div class="appt-actions">
                            <a href="appointment?action=complete&id=${a.appointmentId}" class="btn-complete">✓ MARK COMPLETE</a>
                            <a href="appointment?action=delete&id=${a.appointmentId}" class="btn-sm-danger" onclick="return confirm('Delete this appointment?')">DELETE</a>
                        </div>
                    </div>
                </c:forEach>
            </c:if>
            <c:if test="${empty confirmedAppointments}">
                <div style="text-align: center; padding: 30px; background: #e8f4fd; border-radius: 10px; border: 1px dashed var(--primary);">
                    <p style="color: #1565c0; margin: 0; font-weight: 500;">No confirmed appointments currently in progress.</p>
                </div>
            </c:if>
        </div>

        <!-- SECTION 3: COMPLETED -->
        <div style="margin-bottom: 40px;">
            <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 18px; padding-bottom: 10px; border-bottom: 3px solid #2E7D32;">
                <h2 style="font-family: 'Oswald', sans-serif; font-size: 1.6rem; color: #2E7D32; margin: 0; letter-spacing: 1px;">✓ COMPLETED</h2>
                <span style="background: #e8f5e9; color: #2e7d32; padding: 4px 14px; border-radius: 20px; font-size: 0.8rem; font-weight: 700;">${completedAppointments.size()}</span>
            </div>
            <c:if test="${not empty completedAppointments}">
                <c:forEach var="a" items="${completedAppointments}">
                    <div class="appt-card status-COMPLETED">
                        <div class="appt-header">
                            <h3>Service Appointment <span style="font-size: 0.8rem; color: var(--text-muted); font-weight: 400;"> — by ${a.userName}</span></h3>
                            <span class="status-badge status-COMPLETED">COMPLETED</span>
                        </div>
                        <div class="appt-details">
                            <div class="appt-detail"><div class="label">Vehicle</div><div class="value">${a.vehicleInfo}</div></div>
                            <div class="appt-detail"><div class="label">Date & Time</div><div class="value">${a.preferredDate} at ${a.preferredTime}</div></div>
                            <div class="appt-detail" style="grid-column: 1 / -1;">
                                <div class="label">Selected Services</div>
                                <div class="value" style="margin-top: 5px;">
                                    <c:forTokens var="svc" items="${a.serviceName}" delims=",">
                                        <span style="display: inline-block; background: #e3f2fd; color: #1565c0; padding: 3px 10px; border-radius: 4px; font-size: 0.8rem; margin: 2px 4px 2px 0; font-weight: 600;">${svc}</span>
                                    </c:forTokens>
                                </div>
                            </div>
                            <div class="appt-detail"><div class="label">Categories</div><div class="value">${a.serviceCategory}</div></div>
                            <div class="appt-detail"><div class="label">Total Price</div><div class="value" style="color: var(--primary); font-weight: 700; font-size: 1.1rem;">${a.servicePrice}</div></div>
                            <c:if test="${not empty a.notes}">
                                <div class="appt-detail" style="grid-column: 1 / -1;"><div class="label">Notes</div><div class="value">${a.notes}</div></div>
                            </c:if>
                        </div>
                        <div class="appt-actions">
                            <a href="estimate?action=create&appointmentId=${a.appointmentId}" style="padding: 6px 16px; border-radius: 4px; font-size: 0.8rem; text-decoration: none; font-weight: 600; background: #f3e5f5; color: #7b1fa2; border: 1px solid #7b1fa2; transition: all 0.3s;">📑 CREATE INVOICE</a>
                            <a href="appointment?action=delete&id=${a.appointmentId}" class="btn-sm-danger" onclick="return confirm('Delete this appointment?')">DELETE</a>
                        </div>
                    </div>
                </c:forEach>
            </c:if>
            <c:if test="${empty completedAppointments}">
                <div style="text-align: center; padding: 30px; background: #e8f5e9; border-radius: 10px; border: 1px dashed #2E7D32;">
                    <p style="color: #2e7d32; margin: 0; font-weight: 500;">No completed appointments yet.</p>
                </div>
            </c:if>
        </div>

        <c:if test="${empty appointments}">
            <div class="empty-state" style="text-align: center; padding: 60px;">
                <h3>NO APPOINTMENTS YET</h3>
                <p style="color: var(--text-muted);">No appointments have been booked yet.</p>
            </div>
        </c:if>
    </c:if>

    <!-- ============ USER VIEW: 3 STATUS SECTIONS ============ -->
    <c:if test="${!isAdmin}">

        <!-- SECTION 1: PENDING -->
        <div style="margin-bottom: 40px;">
            <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 18px; padding-bottom: 10px; border-bottom: 3px solid #ff9800;">
                <h2 style="font-family: 'Oswald', sans-serif; font-size: 1.5rem; color: #e65100; margin: 0; letter-spacing: 1px;">⏳ PENDING APPOINTMENTS</h2>
                <span style="background: #fff3e0; color: #e65100; padding: 4px 14px; border-radius: 20px; font-size: 0.8rem; font-weight: 700;">${pendingAppointments.size()}</span>
            </div>
            <c:if test="${not empty pendingAppointments}">
                <c:forEach var="a" items="${pendingAppointments}">
                    <div class="appt-card status-PENDING">
                        <div class="appt-header">
                            <h3>Service Appointment</h3>
                            <span class="status-badge status-PENDING">⏳ PENDING</span>
                        </div>
                        <div class="appt-details">
                            <div class="appt-detail"><div class="label">Vehicle</div><div class="value">${a.vehicleInfo}</div></div>
                            <div class="appt-detail"><div class="label">Date & Time</div><div class="value">${a.preferredDate} at ${a.preferredTime}</div></div>
                            <div class="appt-detail" style="grid-column: 1 / -1;">
                                <div class="label">Selected Services</div>
                                <div class="value" style="margin-top: 5px;">
                                    <c:forTokens var="svc" items="${a.serviceName}" delims=",">
                                        <span style="display: inline-block; background: #fff3e0; color: #e65100; padding: 3px 10px; border-radius: 4px; font-size: 0.8rem; margin: 2px 4px 2px 0; font-weight: 600;">${svc}</span>
                                    </c:forTokens>
                                </div>
                            </div>
                            <div class="appt-detail"><div class="label">Categories</div><div class="value">${a.serviceCategory}</div></div>
                            <div class="appt-detail"><div class="label">Total Price</div><div class="value" style="color: var(--primary); font-weight: 700; font-size: 1.1rem;">${a.servicePrice}</div></div>
                            <c:if test="${not empty a.notes}">
                                <div class="appt-detail" style="grid-column: 1 / -1;"><div class="label">Notes</div><div class="value">${a.notes}</div></div>
                            </c:if>
                        </div>
                        <div class="appt-actions">
                            <a href="appointment?action=cancel&id=${a.appointmentId}" class="btn-cancel-appt" onclick="return confirm('Cancel this appointment?')">✕ CANCEL</a>
                        </div>
                    </div>
                </c:forEach>
            </c:if>
            <c:if test="${empty pendingAppointments}">
                <div style="text-align: center; padding: 30px; background: #fffde7; border-radius: 10px; border: 1px dashed #ff9800;">
                    <p style="color: #e65100; margin: 0; font-weight: 500;">No pending appointments.</p>
                </div>
            </c:if>
        </div>

        <!-- SECTION 2: CONFIRMED -->
        <div style="margin-bottom: 40px;">
            <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 18px; padding-bottom: 10px; border-bottom: 3px solid var(--primary);">
                <h2 style="font-family: 'Oswald', sans-serif; font-size: 1.5rem; color: #1565c0; margin: 0; letter-spacing: 1px;">🔧 CONFIRMED — IN PROGRESS</h2>
                <span style="background: #e3f2fd; color: #1565c0; padding: 4px 14px; border-radius: 20px; font-size: 0.8rem; font-weight: 700;">${confirmedAppointments.size()}</span>
            </div>
            <c:if test="${not empty confirmedAppointments}">
                <c:forEach var="a" items="${confirmedAppointments}">
                    <div class="appt-card status-CONFIRMED">
                        <div class="appt-header">
                            <h3>Service Appointment</h3>
                            <span class="status-badge status-CONFIRMED">🔧 CONFIRMED</span>
                        </div>
                        <div class="appt-details">
                            <div class="appt-detail"><div class="label">Vehicle</div><div class="value">${a.vehicleInfo}</div></div>
                            <div class="appt-detail"><div class="label">Date & Time</div><div class="value">${a.preferredDate} at ${a.preferredTime}</div></div>
                            <div class="appt-detail" style="grid-column: 1 / -1;">
                                <div class="label">Selected Services</div>
                                <div class="value" style="margin-top: 5px;">
                                    <c:forTokens var="svc" items="${a.serviceName}" delims=",">
                                        <span style="display: inline-block; background: #e3f2fd; color: #1565c0; padding: 3px 10px; border-radius: 4px; font-size: 0.8rem; margin: 2px 4px 2px 0; font-weight: 600;">${svc}</span>
                                    </c:forTokens>
                                </div>
                            </div>
                            <div class="appt-detail"><div class="label">Categories</div><div class="value">${a.serviceCategory}</div></div>
                            <div class="appt-detail"><div class="label">Total Price</div><div class="value" style="color: var(--primary); font-weight: 700; font-size: 1.1rem;">${a.servicePrice}</div></div>
                            <c:if test="${not empty a.notes}">
                                <div class="appt-detail" style="grid-column: 1 / -1;"><div class="label">Notes</div><div class="value">${a.notes}</div></div>
                            </c:if>
                        </div>
                        <div class="appt-actions">
                            <span style="font-size: 0.82rem; color: #1565c0; font-weight: 600;">🔄 Your vehicle is being serviced</span>
                        </div>
                    </div>
                </c:forEach>
            </c:if>
            <c:if test="${empty confirmedAppointments}">
                <div style="text-align: center; padding: 30px; background: #e8f4fd; border-radius: 10px; border: 1px dashed var(--primary);">
                    <p style="color: #1565c0; margin: 0; font-weight: 500;">No confirmed appointments in progress.</p>
                </div>
            </c:if>
        </div>

        <!-- SECTION 3: COMPLETED -->
        <div style="margin-bottom: 40px;">
            <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 18px; padding-bottom: 10px; border-bottom: 3px solid #2E7D32;">
                <h2 style="font-family: 'Oswald', sans-serif; font-size: 1.5rem; color: #2E7D32; margin: 0; letter-spacing: 1px;">✓ COMPLETED</h2>
                <span style="background: #e8f5e9; color: #2e7d32; padding: 4px 14px; border-radius: 20px; font-size: 0.8rem; font-weight: 700;">${completedAppointments.size()}</span>
            </div>
            <c:if test="${not empty completedAppointments}">
                <c:forEach var="a" items="${completedAppointments}">
                    <div class="appt-card status-COMPLETED">
                        <div class="appt-header">
                            <h3>Service Appointment</h3>
                            <span class="status-badge status-COMPLETED">✓ COMPLETED</span>
                        </div>
                        <div class="appt-details">
                            <div class="appt-detail"><div class="label">Vehicle</div><div class="value">${a.vehicleInfo}</div></div>
                            <div class="appt-detail"><div class="label">Date & Time</div><div class="value">${a.preferredDate} at ${a.preferredTime}</div></div>
                            <div class="appt-detail" style="grid-column: 1 / -1;">
                                <div class="label">Selected Services</div>
                                <div class="value" style="margin-top: 5px;">
                                    <c:forTokens var="svc" items="${a.serviceName}" delims=",">
                                        <span style="display: inline-block; background: #e8f5e9; color: #2e7d32; padding: 3px 10px; border-radius: 4px; font-size: 0.8rem; margin: 2px 4px 2px 0; font-weight: 600;">${svc}</span>
                                    </c:forTokens>
                                </div>
                            </div>
                            <div class="appt-detail"><div class="label">Categories</div><div class="value">${a.serviceCategory}</div></div>
                            <div class="appt-detail"><div class="label">Total Price</div><div class="value" style="color: var(--primary); font-weight: 700; font-size: 1.1rem;">${a.servicePrice}</div></div>
                            <c:if test="${not empty a.notes}">
                                <div class="appt-detail" style="grid-column: 1 / -1;"><div class="label">Notes</div><div class="value">${a.notes}</div></div>
                            </c:if>
                        </div>
                        <div class="appt-actions">
                            <span style="font-size: 0.82rem; color: #2e7d32; font-weight: 600;">✓ Service completed successfully</span>
                        </div>
                    </div>
                </c:forEach>
            </c:if>
            <c:if test="${empty completedAppointments}">
                <div style="text-align: center; padding: 30px; background: #e8f5e9; border-radius: 10px; border: 1px dashed #2E7D32;">
                    <p style="color: #2e7d32; margin: 0; font-weight: 500;">No completed appointments yet.</p>
                </div>
            </c:if>
        </div>

        <c:if test="${empty appointments}">
            <div class="empty-state" style="text-align: center; padding: 60px;">
                <h3>NO APPOINTMENTS YET</h3>
                <p style="color: var(--text-muted); margin-bottom: 20px;">Book your first service appointment to get started.</p>
                <a href="appointment?action=book" class="btn-primary-custom" style="padding: 12px 25px;">BOOK NOW &gt;</a>
            </div>
        </c:if>
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

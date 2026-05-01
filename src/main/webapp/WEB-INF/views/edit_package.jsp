<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Package - AutoCare Tracker</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
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
            <li><a href="service" class="active">MANAGE SERVICES</a></li>
            <li><a href="appointment">APPOINTMENTS</a></li>
            <li><a href="estimate">ESTIMATES</a></li>
        </ul>
        <div class="nav-right">
            <span class="nav-user">Admin: <strong>${authUser.fullName}</strong></span>
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
    <div class="page-header" style="margin-bottom: 30px;">
        <h1>EDIT SERVICE PACKAGE</h1>
    </div>

    <div style="max-width: 700px; margin: 0 auto;">
        <div style="background: white; padding: 40px; border-radius: 12px; box-shadow: 0 6px 25px rgba(0,0,0,0.08); border: 1px solid var(--border);">
            <form action="service" method="post">
                <input type="hidden" name="action" value="updatePackage"/>
                <input type="hidden" name="packageId" value="${editPackage.id}"/>

                <div style="margin-bottom: 20px;">
                    <label style="display: block; font-weight: 600; margin-bottom: 6px; color: var(--dark); font-size: 0.85rem; text-transform: uppercase; letter-spacing: 1px;">CATEGORY</label>
                    <select name="category" required style="width: 100%; padding: 12px; border: 1px solid var(--border); border-radius: 6px; background: white; font-size: 1rem;">
                        <c:forEach var="cat" items="${allCategories}">
                            <option value="${cat.name}" ${cat.name == editPackage.category ? 'selected' : ''}>${cat.name}</option>
                        </c:forEach>
                    </select>
                </div>

                <div style="margin-bottom: 20px;">
                    <label style="display: block; font-weight: 600; margin-bottom: 6px; color: var(--dark); font-size: 0.85rem; text-transform: uppercase; letter-spacing: 1px;">PACKAGE NAME</label>
                    <input type="text" name="name" value="${editPackage.name}" required style="width: 100%; padding: 12px; border: 1px solid var(--border); border-radius: 6px; font-size: 1rem;"/>
                </div>

                <div style="margin-bottom: 20px;">
                    <label style="display: block; font-weight: 600; margin-bottom: 6px; color: var(--dark); font-size: 0.85rem; text-transform: uppercase; letter-spacing: 1px;">DESCRIPTION</label>
                    <textarea name="packageDescription" rows="3" style="width: 100%; padding: 12px; border: 1px solid var(--border); border-radius: 6px; font-size: 1rem; resize: vertical;">${editPackage.description}</textarea>
                </div>

                <div style="margin-bottom: 30px;">
                    <label style="display: block; font-weight: 600; margin-bottom: 6px; color: var(--dark); font-size: 0.85rem; text-transform: uppercase; letter-spacing: 1px;">PRICE (LKR)</label>
                    <input type="text" name="packagePrice" value="${editPackage.price}" placeholder="e.g. LKR 5,000" style="width: 100%; padding: 12px; border: 1px solid var(--border); border-radius: 6px; font-size: 1rem;"/>
                </div>

                <div style="display: flex; gap: 15px;">
                    <button type="submit" class="btn-primary-custom" style="padding: 14px 30px; border: none; cursor: pointer; color: white; border-radius: 6px; font-size: 1rem; font-weight: bold; letter-spacing: 1px;">UPDATE PACKAGE</button>
                    <a href="service" style="padding: 14px 30px; background: var(--text-muted); color: white; text-decoration: none; border-radius: 6px; font-size: 1rem; font-weight: bold; letter-spacing: 1px;">CANCEL</a>
                </div>
            </form>
        </div>
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

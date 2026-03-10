<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Shift Auto Dynamics</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
</head>
<body>
<div class="auth-page">
    <div class="auth-left">
        <div class="auth-form-container" style="max-width: 550px;">
            <div class="logo-area nav-brand">
                <div style="display: flex; align-items: center; gap: 15px;">
                    <img src="${pageContext.request.contextPath}/images/shift_logo.png" alt="Shift Auto Dynamics" style="height: 55px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.1);" />
                    <div style="display: flex; flex-direction: column; justify-content: center; line-height: 1.2;">
                        <span style="font-family: 'Oswald', sans-serif; font-size: 1.6rem; font-weight: 700; letter-spacing: 1px; color: var(--dark);">SHIFT AUTO <span style="color: var(--primary);">DYNAMICS</span></span>
                        <span style="font-size: 0.65rem; font-weight: 600; color: var(--text-muted); letter-spacing: 1px; text-transform: uppercase;">Precision in Motion | Engineered for Excellence</span>
                    </div>
                </div>
            </div>

            <h2 style="font-size: 2rem;">CREATE ACCOUNT</h2>

            <div id="error-box" class="alert-box alert-error" style="display: none;"></div>
            <c:if test="${param.error == 'true'}">
                <div class="alert-box alert-error">
                    Registration failed. Please check your details and try again.
                </div>
            </c:if>

            <form id="registerForm" onsubmit="return handleRegister(event)">
                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" id="fullName" name="fullName" class="form-input" placeholder="Enter your full name" required/>
                </div>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                    <div class="form-group">
                        <label>Username</label>
                        <input type="text" id="username" name="username" class="form-input" placeholder="Choose a username" required/>
                    </div>
                    <div class="form-group">
                        <label>Email</label>
                        <input type="email" id="email" name="email" class="form-input" placeholder="your@email.com" required/>
                    </div>
                </div>
                <div class="form-group">
                    <label>Phone</label>
                    <input type="text" id="phone" name="phone" class="form-input" placeholder="07X XXXX XXX" required/>
                </div>
                <div class="form-group">
                    <label>Password</label>
                    <input type="password" id="password" name="password" class="form-input" placeholder="Minimum 6 characters" required minlength="6"/>
                </div>
                <button type="submit" id="submitBtn" class="btn-primary-custom" style="width: 100%; margin-top: 10px;">Complete Registration</button>
            </form>

            <div style="margin-top: 25px; font-weight: 500; font-size: 0.95rem; color: var(--dark-secondary);">
                Already registered? <a href="user" style="color: var(--primary); text-decoration: none; font-weight: 600;">Sign In</a>
            </div>
        </div>
    </div>
    <div class="auth-right"></div>
</div>

<!-- Firebase JS SDK (Modular CDN) -->
<script type="module">
    import { initializeApp } from "https://www.gstatic.com/firebasejs/11.1.0/firebase-app.js";
    import { getAuth, createUserWithEmailAndPassword } from "https://www.gstatic.com/firebasejs/11.1.0/firebase-auth.js";

    const firebaseConfig = {
        apiKey: "AIzaSyAUcqUXDX0CkADatn4Hf3LQRCSMNcsCk8o",
        authDomain: "car-service-84e75.firebaseapp.com",
        databaseURL: "https://car-service-84e75-default-rtdb.asia-southeast1.firebasedatabase.app",
        projectId: "car-service-84e75",
        storageBucket: "car-service-84e75.firebasestorage.app",
        messagingSenderId: "599347402002",
        appId: "1:599347402002:web:8cfe3416e9d8df3adacfcb",
        measurementId: "G-CTPHQXRTBL"
    };

    const app = initializeApp(firebaseConfig);
    const auth = getAuth(app);

    window.handleRegister = async function(e) {
        e.preventDefault();

        const errorBox = document.getElementById('error-box');
        const submitBtn = document.getElementById('submitBtn');
        errorBox.style.display = 'none';

        const email = document.getElementById('email').value;
        const password = document.getElementById('password').value;
        const fullName = document.getElementById('fullName').value;
        const username = document.getElementById('username').value;
        const phone = document.getElementById('phone').value;

        submitBtn.disabled = true;
        submitBtn.textContent = 'Creating Account...';

        try {
            const userCredential = await createUserWithEmailAndPassword(auth, email, password);
            const idToken = await userCredential.user.getIdToken();

            // Send to backend to create local user record
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = 'user';

            const fields = {
                action: 'register',
                idToken: idToken,
                fullName: fullName,
                username: username,
                email: email,
                phone: phone
            };

            for (const [key, value] of Object.entries(fields)) {
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = key;
                input.value = value;
                form.appendChild(input);
            }

            document.body.appendChild(form);
            form.submit();

        } catch (error) {
            submitBtn.disabled = false;
            submitBtn.textContent = 'Complete Registration';

            let message = 'Registration failed. Please try again.';
            if (error.code === 'auth/email-already-in-use') {
                message = 'This email is already registered. Please sign in instead.';
            } else if (error.code === 'auth/weak-password') {
                message = 'Password is too weak. Please use at least 6 characters.';
            } else if (error.code === 'auth/invalid-email') {
                message = 'Invalid email address format.';
            }
            errorBox.textContent = message;
            errorBox.style.display = 'block';
        }

        return false;
    };
</script>
</body>
</html>

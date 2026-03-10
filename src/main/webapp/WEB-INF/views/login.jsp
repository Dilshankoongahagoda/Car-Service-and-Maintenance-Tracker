<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Shift Auto Dynamics</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
</head>
<body>
<div class="auth-page">
    <div class="auth-left">
        <div class="auth-form-container">
            <div class="logo-area nav-brand">
                <div style="display: flex; align-items: center; gap: 15px;">
                    <img src="${pageContext.request.contextPath}/images/shift_logo.png" alt="Shift Auto Dynamics" style="height: 55px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.1);" />
                    <div style="display: flex; flex-direction: column; justify-content: center; line-height: 1.2;">
                        <span style="font-family: 'Oswald', sans-serif; font-size: 1.6rem; font-weight: 700; letter-spacing: 1px; color: var(--dark);">SHIFT AUTO <span style="color: var(--primary);">DYNAMICS</span></span>
                        <span style="font-size: 0.65rem; font-weight: 600; color: var(--text-muted); letter-spacing: 1px; text-transform: uppercase;">Precision in Motion | Engineered for Excellence</span>
                    </div>
                </div>
            </div>

            <h2>SIGN IN</h2>

            <div id="error-box" class="alert-box alert-error" style="display: none;"></div>
            <c:if test="${param.error == 'true'}">
                <div class="alert-box alert-error">Invalid username/email or password. Please try again.</div>
            </c:if>
            <c:if test="${param.success == 'true'}">
                <div class="alert-box alert-success">Registration successful! Please sign in.</div>
            </c:if>

            <form id="loginForm" onsubmit="return handleLogin(event)">
                <div class="form-group">
                    <label>Username or Email</label>
                    <input type="text" id="loginId" name="loginId" class="form-input"
                           placeholder="Username or email address" required autocomplete="username"/>
                </div>
                <div class="form-group">
                    <label>Password</label>
                    <input type="password" id="password" name="password" class="form-input"
                           placeholder="Enter your password" required autocomplete="current-password"/>
                </div>
                <button type="submit" id="submitBtn" class="btn-primary-custom" style="width: 100%; margin-top: 10px;">Login securely</button>
            </form>

            <div style="margin-top: 25px; font-weight: 500; font-size: 0.95rem; color: var(--dark-secondary);">
                Don't have an account? <a href="user?action=register" style="color: var(--primary); text-decoration: none; font-weight: 600;">Register Now</a>
            </div>
        </div>
    </div>
    <div class="auth-right"></div>
</div>

<!-- Firebase JS SDK -->
<script type="module">
    import { initializeApp } from "https://www.gstatic.com/firebasejs/11.1.0/firebase-app.js";
    import { getAuth, signInWithEmailAndPassword } from "https://www.gstatic.com/firebasejs/11.1.0/firebase-auth.js";

    const firebaseConfig = {
        apiKey: "AIzaSyAUcqUXDX0CkADatn4Hf3LQRCSMNcsCk8o",
        authDomain: "car-service-84e75.firebaseapp.com",
        projectId: "car-service-84e75",
        storageBucket: "car-service-84e75.firebasestorage.app",
        messagingSenderId: "599347402002",
        appId: "1:599347402002:web:8cfe3416e9d8df3adacfcb"
    };

    const app = initializeApp(firebaseConfig);
    const auth = getAuth(app);

    function submitToBackend(fields) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = 'user';
        for (const [name, value] of Object.entries(fields)) {
            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = name;
            input.value = value;
            form.appendChild(input);
        }
        document.body.appendChild(form);
        form.submit();
    }

    window.handleLogin = async function(e) {
        e.preventDefault();
        const errorBox = document.getElementById('error-box');
        const submitBtn = document.getElementById('submitBtn');
        errorBox.style.display = 'none';

        const loginId = document.getElementById('loginId').value.trim();
        const password = document.getElementById('password').value;

        submitBtn.disabled = true;
        submitBtn.textContent = 'Signing In...';

        const isEmail = loginId.includes('@');

        if (!isEmail) {
            // Username + password → direct backend login (admin flow)
            submitToBackend({ action: 'login', username: loginId, password: password });
            return false;
        }

        // Email + password → Firebase Auth login
        try {
            const userCredential = await signInWithEmailAndPassword(auth, loginId, password);
            const idToken = await userCredential.user.getIdToken();
            submitToBackend({ action: 'login', idToken: idToken });
        } catch (error) {
            submitBtn.disabled = false;
            submitBtn.textContent = 'Login securely';

            let message = 'Login failed. Please try again.';
            if (error.code === 'auth/invalid-credential' || error.code === 'auth/wrong-password' || error.code === 'auth/user-not-found') {
                message = 'Invalid email or password.';
            } else if (error.code === 'auth/too-many-requests') {
                message = 'Too many failed attempts. Please try again later.';
            }
            errorBox.textContent = message;
            errorBox.style.display = 'block';
        }
        return false;
    };
</script>
</body>
</html>

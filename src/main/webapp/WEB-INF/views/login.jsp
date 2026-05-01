<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Login - Shift Auto Dynamics</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
        </head>

        <body>
            <div class="auth-page">
                <div class="auth-left">
                    <div class="auth-form-container">
                        <div class="logo-area nav-brand">
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
                        </div>

                        <h2>SIGN IN</h2>

                        <div id="error-box" class="alert-box alert-error" style="display: none;"></div>
                        <c:if test="${param.error == 'true'}">
                            <div class="alert-box alert-error">Invalid username/email or password. Please try again.
                            </div>
                        </c:if>
                        <c:if test="${param.success == 'true'}">
                            <div class="alert-box alert-success">Registration successful! Please sign in.</div>
                        </c:if>

                        <form id="loginForm" onsubmit="return handleLogin(event)">
                            <div class="form-group">
                                <label>Username or Email</label>
                                <input type="text" id="loginId" name="loginId" class="form-input"
                                    placeholder="Username or email address" required autocomplete="username" />
                            </div>
                            <div class="form-group">
                                <label>Password</label>
                                <input type="password" id="password" name="password" class="form-input"
                                    placeholder="Enter your password" required autocomplete="current-password" />
                            </div>
                            <button type="submit" id="submitBtn" class="btn-primary-custom"
                                style="width: 100%; margin-top: 10px;">Login securely</button>
                        </form>

                        <div
                            style="margin-top: 25px; font-weight: 500; font-size: 0.95rem; color: var(--dark-secondary);">
                            Don't have an account? <a href="user?action=register"
                                style="color: var(--primary); text-decoration: none; font-weight: 600;">Register Now</a>
                        </div>
                    </div>
                </div>
                <div class="auth-right"></div>
            </div>

            <!-- ========== PARTNERS SECTION ========== -->
            <style>
                .partners-section-login {
                    display: flex;
                    background: white;
                    border-top: 1px solid var(--border);
                    border-bottom: 1px solid var(--border);
                    overflow: hidden;
                }

                .partners-label-login {
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

                .partners-label-login h3 {
                    font-family: 'Oswald', sans-serif;
                    margin: 0;
                    font-size: 1.1rem;
                    letter-spacing: 1px;
                    margin-right: 30px;
                }

                .partners-track-wrapper-login {
                    width: 70%;
                    overflow: hidden;
                    position: relative;
                    display: flex;
                    align-items: center;
                }

                .partners-track-wrapper-login::before,
                .partners-track-wrapper-login::after {
                    content: '';
                    position: absolute;
                    top: 0;
                    bottom: 0;
                    width: 60px;
                    z-index: 2;
                    pointer-events: none;
                }

                .partners-track-wrapper-login::before {
                    left: 0;
                    background: linear-gradient(to right, white 0%, transparent 100%);
                }

                .partners-track-wrapper-login::after {
                    right: 0;
                    background: linear-gradient(to left, white 0%, transparent 100%);
                }

                .partners-track-login {
                    display: flex;
                    align-items: center;
                    gap: 60px;
                    animation: partnersScrollLogin 25s linear infinite;
                    width: max-content;
                }

                .partners-track-login:hover {
                    animation-play-state: paused;
                }

                .partner-logo-login {
                    flex-shrink: 0;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    height: 45px;
                    opacity: 0.7;
                    transition: opacity 0.3s, transform 0.3s;
                    cursor: default;
                }

                .partner-logo-login:hover {
                    opacity: 1;
                    transform: scale(1.1);
                }

                .partner-logo-login svg {
                    height: 40px;
                    width: auto;
                }

                @keyframes partnersScrollLogin {
                    0% {
                        transform: translateX(0);
                    }

                    100% {
                        transform: translateX(-50%);
                    }
                }

                .partners-dots-login {
                    display: flex;
                    justify-content: center;
                    gap: 6px;
                    padding: 10px 0 12px;
                    background: white;
                    border-bottom: 1px solid var(--border);
                }

                .partners-dots-login span {
                    width: 8px;
                    height: 8px;
                    border-radius: 50%;
                    background: #ddd;
                    display: inline-block;
                    transition: background 0.3s;
                }

                .partners-dots-login span.active {
                    background: var(--primary);
                }
            </style>
            <div class="partners-section-login">
                <div class="partners-label-login">
                    <h3>PREMIUM AUTOCARE <span style="font-weight: 400;">SERVICE PROVIDER</span></h3>
                </div>
                <div class="partners-track-wrapper-login">
                    <div class="partners-track-login">
                        <!-- Set 1 -->
                        <div class="partner-logo-login">
                            <svg viewBox="0 0 160 50" xmlns="http://www.w3.org/2000/svg">
                                <circle cx="20" cy="25" r="18" fill="#C8102E" opacity="0.9" />
                                <path d="M12 25 L20 17 L28 25 L20 33Z" fill="white" />
                                <text x="44" y="32" font-family="'Oswald',sans-serif" font-size="18" font-weight="700"
                                    fill="#222">AUTO<tspan fill="#C8102E">SHIELD</tspan></text>
                            </svg>
                        </div>
                        <div class="partner-logo-login">
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
                        <div class="partner-logo-login">
                            <svg viewBox="0 0 180 50" xmlns="http://www.w3.org/2000/svg">
                                <text x="5" y="33" font-family="'Oswald',sans-serif" font-size="20" font-weight="700"
                                    fill="#1a1a1a" letter-spacing="3">CAUSEWAY</text>
                                <text x="5" y="45" font-family="Arial" font-size="10" fill="#C8102E" font-weight="700"
                                    letter-spacing="5">PAINTS</text>
                            </svg>
                        </div>
                        <div class="partner-logo-login">
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
                        <div class="partner-logo-login">
                            <svg viewBox="0 0 130 50" xmlns="http://www.w3.org/2000/svg">
                                <text x="5" y="35" font-family="'Oswald',sans-serif" font-size="24" font-weight="700"
                                    fill="#1a1a1a">GYEON</text>
                                <rect x="5" y="40" width="85" height="3" fill="#C8102E" />
                            </svg>
                        </div>
                        <div class="partner-logo-login">
                            <svg viewBox="0 0 130 50" xmlns="http://www.w3.org/2000/svg">
                                <text x="5" y="30" font-family="'Oswald',sans-serif" font-size="22" font-weight="700"
                                    fill="#C8102E">Mobil</text>
                                <text x="80" y="32" font-family="'Oswald',sans-serif" font-size="26" font-weight="700"
                                    fill="#1976D2">1</text>
                            </svg>
                        </div>
                        <div class="partner-logo-login">
                            <svg viewBox="0 0 160 50" xmlns="http://www.w3.org/2000/svg">
                                <rect x="2" y="8" width="8" height="35" fill="#1976D2" rx="2" />
                                <text x="16" y="32" font-family="'Oswald',sans-serif" font-size="17" font-weight="700"
                                    fill="#1976D2">NIPPON</text>
                                <text x="100" y="32" font-family="'Oswald',sans-serif" font-size="17" font-weight="700"
                                    fill="#C8102E">PAINT</text>
                            </svg>
                        </div>
                        <div class="partner-logo-login">
                            <svg viewBox="0 0 140 50" xmlns="http://www.w3.org/2000/svg">
                                <text x="5" y="32" font-family="Georgia,serif" font-size="22" font-style="italic"
                                    font-weight="700" fill="#333">Premier</text>
                                <line x1="5" y1="38" x2="120" y2="38" stroke="#C8102E" stroke-width="2" />
                            </svg>
                        </div>
                        <!-- Set 2 (duplicate for seamless loop) -->
                        <div class="partner-logo-login">
                            <svg viewBox="0 0 160 50" xmlns="http://www.w3.org/2000/svg">
                                <circle cx="20" cy="25" r="18" fill="#C8102E" opacity="0.9" />
                                <path d="M12 25 L20 17 L28 25 L20 33Z" fill="white" />
                                <text x="44" y="32" font-family="'Oswald',sans-serif" font-size="18" font-weight="700"
                                    fill="#222">AUTO<tspan fill="#C8102E">SHIELD</tspan></text>
                            </svg>
                        </div>
                        <div class="partner-logo-login">
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
                        <div class="partner-logo-login">
                            <svg viewBox="0 0 180 50" xmlns="http://www.w3.org/2000/svg">
                                <text x="5" y="33" font-family="'Oswald',sans-serif" font-size="20" font-weight="700"
                                    fill="#1a1a1a" letter-spacing="3">CAUSEWAY</text>
                                <text x="5" y="45" font-family="Arial" font-size="10" fill="#C8102E" font-weight="700"
                                    letter-spacing="5">PAINTS</text>
                            </svg>
                        </div>
                        <div class="partner-logo-login">
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
                        <div class="partner-logo-login">
                            <svg viewBox="0 0 130 50" xmlns="http://www.w3.org/2000/svg">
                                <text x="5" y="35" font-family="'Oswald',sans-serif" font-size="24" font-weight="700"
                                    fill="#1a1a1a">GYEON</text>
                                <rect x="5" y="40" width="85" height="3" fill="#C8102E" />
                            </svg>
                        </div>
                        <div class="partner-logo-login">
                            <svg viewBox="0 0 130 50" xmlns="http://www.w3.org/2000/svg">
                                <text x="5" y="30" font-family="'Oswald',sans-serif" font-size="22" font-weight="700"
                                    fill="#C8102E">Mobil</text>
                                <text x="80" y="32" font-family="'Oswald',sans-serif" font-size="26" font-weight="700"
                                    fill="#1976D2">1</text>
                            </svg>
                        </div>
                        <div class="partner-logo-login">
                            <svg viewBox="0 0 160 50" xmlns="http://www.w3.org/2000/svg">
                                <rect x="2" y="8" width="8" height="35" fill="#1976D2" rx="2" />
                                <text x="16" y="32" font-family="'Oswald',sans-serif" font-size="17" font-weight="700"
                                    fill="#1976D2">NIPPON</text>
                                <text x="100" y="32" font-family="'Oswald',sans-serif" font-size="17" font-weight="700"
                                    fill="#C8102E">PAINT</text>
                            </svg>
                        </div>
                        <div class="partner-logo-login">
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
            <div class="partners-dots-login">
                <span
                    class="active"></span><span></span><span></span><span></span><span></span><span></span><span></span><span></span><span></span><span></span><span></span><span></span>
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

                window.handleLogin = async function (e) {
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
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shift Auto Dynamics - Premium Auto Care</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
</head>
<body>
<!-- NAVBAR -->
<nav class="navbar-custom">
    <div class="navbar-inner">
        <a href="/" class="nav-brand">
            <div style="display: flex; align-items: center; gap: 15px;">
                <img src="${pageContext.request.contextPath}/images/shift_logo.png" alt="Shift Auto Dynamics" style="height: 55px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.1);" />
                <div style="display: flex; flex-direction: column; justify-content: center; line-height: 1.2;">
                    <span style="font-family: 'Oswald', sans-serif; font-size: 1.6rem; font-weight: 700; letter-spacing: 1px; color: var(--dark);">SHIFT AUTO <span style="color: var(--primary);">DYNAMICS</span></span>
                    <span style="font-size: 0.65rem; font-weight: 600; color: var(--text-muted); letter-spacing: 1px; text-transform: uppercase;">Precision in Motion | Engineered for Excellence</span>
                </div>
            </div>
        </a>
        <ul class="nav-links">
            <li><a href="/" class="active">HOME</a></li>
            <li><a href="#services">SERVICES</a></li>
            <li><a href="#contact">CONTACT</a></li>
        </ul>
        <div class="nav-right">
            <a href="user" class="btn-primary-custom" style="padding: 10px 20px; margin-right: 10px; background: transparent; color: var(--primary); border: 2px solid var(--primary);">SIGN IN</a>
            <a href="user?action=register" class="btn-primary-custom" style="padding: 10px 20px;">REGISTER</a>
        </div>
    </div>
</nav>

<!-- HERO SECTION -->
<section class="hero-section">
    <div class="hero-left">
        <span class="hero-subtitle">YOUR VEHICLES,</span>
        <h1 class="hero-title">MANAGED<br>BETTER</h1>
        <p class="hero-desc">Keep track of your vehicle maintenance, set reminders, and view service history seamlessly. Join the new standard of vehicle care.</p>
        <a href="user?action=register" class="btn-primary-custom">GET STARTED &gt;</a>
    </div>
    <div class="hero-right">
        <img src="${pageContext.request.contextPath}/images/autocare_hero.png" alt="Hero background" class="hero-bg-img" />
        <div class="hero-stats-overlay">
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

<!-- ========== OUR SERVICES SECTION (PREMIUM DESIGN) ========== -->
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
        margin-bottom: 70px;
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
    .services-grid {
        display: grid; 
        grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); 
        gap: 40px; 
        text-align: left;
    }
    .service-card {
        background: #fff;
        border-radius: 20px;
        overflow: hidden;
        box-shadow: 0 15px 35px rgba(0,0,0,0.06);
        transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        border: 1px solid rgba(0,0,0,0.04);
        position: relative;
        top: 0;
    }
    .service-card:hover {
        top: -15px;
        box-shadow: 0 25px 50px rgba(0,0,0,0.12);
    }
    .service-img-wrapper {
        overflow: hidden;
        position: relative;
        height: 240px;
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
        background: linear-gradient(to top, rgba(0,0,0,0.4) 0%, transparent 50%);
        opacity: 0.5;
        transition: opacity 0.3s;
    }
    .service-card:hover .service-img-overlay {
        opacity: 0.2;
    }
    .service-content {
        padding: 40px 35px;
        background: #fff;
        position: relative;
    }
    .service-card h3 {
        color: var(--primary);
        font-family: 'Oswald', sans-serif;
        font-size: 1.7rem;
        text-transform: uppercase;
        margin-bottom: 25px;
        letter-spacing: 0.5px;
        display: flex;
        align-items: center;
        gap: 12px;
    }
    .service-card h3::before {
        content: '';
        display: block;
        width: 4px;
        height: 24px;
        background: var(--primary);
        border-radius: 4px;
    }
    .service-list {
        list-style: none;
        padding: 0;
        margin: 0;
    }
    .service-list li {
        font-family: 'Roboto', sans-serif;
        color: #555;
        margin-bottom: 14px;
        position: relative;
        padding-left: 28px;
        font-weight: 500;
        font-size: 1rem;
        line-height: 1.5;
        transition: transform 0.3s, color 0.3s;
    }
    .service-card:hover .service-list li {
        color: #333;
    }
    .service-list li::before {
        content: '❖';
        position: absolute;
        left: 0;
        top: 2px;
        color: var(--primary);
        font-size: 0.85rem;
        opacity: 0.7;
        transition: transform 0.3s;
    }
    .service-list li.highlight {
        font-size: 1.25rem;
        font-weight: 800;
        color: #1a1a1a;
        margin: 20px 0;
        letter-spacing: -0.2px;
    }
    .service-list li.highlight::before {
        top: 6px;
        font-size: 1rem;
        color: var(--primary);
        opacity: 1;
    }
    .service-card:hover .service-list li.highlight {
        transform: translateX(5px);
    }
    .highlight-text {
        color: var(--primary);
    }
</style>

<div id="services" class="services-wrapper">
    <div class="page-container" style="margin-top: 0; margin-bottom: 0;">
        <h2 class="services-title">
            Committed to provide <span class="highlight">the best care</span><br/> with supervision and trust
        </h2>
        
        <div class="services-grid">
            <!-- Column 1 -->
            <div class="service-card">
                <div class="service-img-wrapper">
                    <img src="${pageContext.request.contextPath}/images/periodic.png" alt="Periodic Maintenance">
                    <div class="service-img-overlay"></div>
                </div>
                <div class="service-content">
                    <h3>Periodic Maintenance</h3>
                    <ul class="service-list">
                        <li>Inspection Reports</li>
                        <li class="highlight">Wash <span class="highlight-text">& Grooming</span></li>
                        <li>Waxing</li>
                        <li>Undercarriage Degreasing</li>
                        <li>Lube Services</li>
                        <li class="highlight">Interior/Exterior<br/><span class="highlight-text">Detailing</span></li>
                    </ul>
                </div>
            </div>
            
            <!-- Column 2 -->
            <div class="service-card">
                <div class="service-img-wrapper">
                    <img src="${pageContext.request.contextPath}/images/paints.png" alt="Paints & Repairs">
                    <div class="service-img-overlay"></div>
                </div>
                <div class="service-content">
                    <h3>Paints & Repairs</h3>
                    <ul class="service-list">
                        <li>Insurance Claims</li>
                        <li class="highlight">Nano <span class="highlight-text">Coating</span></li>
                        <li>Spare Parts Replacement</li>
                        <li>Mechanical Repair</li>
                        <li>Full Paints</li>
                        <li class="highlight">Hybrid <span class="highlight-text">Services</span></li>
                        <li>4X4 Maintenances</li>
                    </ul>
                </div>
            </div>
            
            <!-- Column 3 -->
            <div class="service-card">
                <div class="service-img-wrapper">
                    <img src="${pageContext.request.contextPath}/images/terminal.png" alt="Terminal Services">
                    <div class="service-img-overlay"></div>
                </div>
                <div class="service-content">
                    <h3>Terminal Services</h3>
                    <ul class="service-list">
                        <li>Battery Services</li>
                        <li class="highlight">Engine <span class="highlight-text">Tune-up</span></li>
                        <li>Lube Services</li>
                        <li>Windscreen Treatments</li>
                        <li>Tyre Replacements</li>
                        <li class="highlight">Wheel <span class="highlight-text">Alignment</span></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- ========== PARTNERS SECTION ========== -->
<div style="display: flex; background: white; border-top: 1px solid var(--border); border-bottom: 1px solid var(--border);">
    <div style="background: var(--primary); color: white; padding: 30px; width: 30%; display: flex; align-items: center; justify-content: flex-end; clip-path: polygon(0 0, 100% 0, 90% 100%, 0% 100%);">
        <h3 style="font-family: 'Oswald', sans-serif; margin: 0; font-size: 1.1rem; letter-spacing: 1px; margin-right: 30px;">PREMIUM AUTOCARE <span style="font-weight: 400;">SERVICE PROVIDER</span></h3>
    </div>
    <div style="width: 70%; padding: 15px 30px; display: flex; align-items: center; justify-content: center;">
        <img src="${pageContext.request.contextPath}/images/partners.png" alt="Partner Logos" style="max-height: 50px; width: auto; object-fit: contain;">
    </div>
</div>

<!-- ========== CTA SECTION ========== -->
<div style="background: var(--dark); padding: 60px 0; text-align: center;">
    <div class="page-container">
        <h2 style="font-family: 'Oswald', sans-serif; font-size: 2.5rem; color: white; margin-bottom: 15px;">Ready to manage your vehicle <span style="color: var(--primary);">smarter?</span></h2>
        <p style="color: #999; font-size: 1.1rem; margin-bottom: 30px; max-width: 500px; margin-left: auto; margin-right: auto;">Create a free account to track maintenance, book appointments, and keep your vehicle in top condition.</p>
        <a href="user?action=register" class="btn-primary-custom" style="padding: 15px 40px; font-size: 1.1rem;">CREATE FREE ACCOUNT &gt;</a>
    </div>
</div>

<!-- ========== FOOTER ========== -->
<footer id="contact" style="background: #1a1a1a; color: #e0e0e0; padding: 60px 0 20px 0; font-family: 'Roboto', sans-serif;">
    <div class="page-container" style="max-width: 1200px; margin: 0 auto; padding: 0 20px;">
        
        <!-- Main Footer Content -->
        <div style="display: grid; grid-template-columns: 1.5fr 1.5fr 2fr; gap: 40px; margin-bottom: 40px;">
            
            <!-- Column 1: CITY NETWORK -->
            <div>
                <h4 style="color: white; font-family: inherit; font-weight: 700; font-size: 1.1rem; margin-bottom: 20px;">Company Information / City Network</h4>
                <ul style="list-style: none; padding: 0; margin: 0; line-height: 2.2;">
                    <li><a href="#" style="color: #e0e0e0; text-decoration: none; font-size: 0.9rem; transition: color 0.3s;" onmouseover="this.style.color='white'" onmouseout="this.style.color='#e0e0e0'">Colombo</a></li>
                    <li><a href="#" style="color: #e0e0e0; text-decoration: none; font-size: 0.9rem; transition: color 0.3s;" onmouseover="this.style.color='white'" onmouseout="this.style.color='#e0e0e0'">Kandy</a></li>
                    <li><a href="#" style="color: #e0e0e0; text-decoration: none; font-size: 0.9rem; transition: color 0.3s;" onmouseover="this.style.color='white'" onmouseout="this.style.color='#e0e0e0'">Kurunegala</a></li>
                    <li><a href="#" style="color: #e0e0e0; text-decoration: none; font-size: 0.9rem; transition: color 0.3s;" onmouseover="this.style.color='white'" onmouseout="this.style.color='#e0e0e0'">Mathara</a></li>
                </ul>
            </div>
            
            <!-- Column 2: CITY OFFICE -->
            <div>
                <h4 style="color: white; font-family: inherit; font-weight: 700; font-size: 1.1rem; margin-bottom: 20px;">Products & Services / Office</h4>
                <ul style="list-style: none; padding: 0; margin: 0; line-height: 2.2;">
                    <li style="color: #e0e0e0; font-size: 0.9rem;">450/50, Koswatta, Talangama North</li>
                    <li style="color: #e0e0e0; font-size: 0.9rem;">Battaramulla</li>
                    <li style="color: #e0e0e0; font-size: 0.9rem;">10120</li>
                    <li style="color: #e0e0e0; font-size: 0.9rem;">Sri Lanka</li>
                </ul>
            </div>
            
            <!-- Column 3: BORDERED BOX & SOCIALS -->
            <div>
                <div style="border: 1px solid #444; border-radius: 8px; padding: 25px; margin-bottom: 25px;">
                    <h4 style="color: white; font-family: inherit; font-weight: 700; font-size: 1.1rem; margin-bottom: 15px;">Opening Hours</h4>
                    <p style="color: #ccc; font-size: 0.9rem; line-height: 1.8; margin-bottom: 0;">
                        Stay updated with our services and availability. Our mechanic network is ready for you during our standard hours: <br><br>
                        <strong style="color: white;">Mon - Fri:</strong> 7 AM - 6 PM<br>
                        <strong style="color: white;">Sat - Sun:</strong> 7 AM - 6 PM
                    </p>
                    <a href="appointment" style="display: inline-flex; align-items: center; justify-content: space-between; background: #d35400; color: white; padding: 12px 20px; border-radius: 6px; text-decoration: none; font-weight: 700; font-size: 1rem; margin-top: 20px; width: 140px; transition: background 0.3s;" onmouseover="this.style.background='#e67e22'" onmouseout="this.style.background='#d35400'">
                        Book Now
                        <span style="font-size: 1.2rem; font-weight: bold; margin-left: 10px;">›</span>
                    </a>
                </div>
                
                <h4 style="color: white; font-family: inherit; font-weight: 700; font-size: 1rem; margin-bottom: 15px;">Follow Shift Auto Dynamics</h4>
                <div style="display: flex; gap: 10px;">
                    <a href="#" style="background: #333; width: 42px; height: 42px; border-radius: 6px; display: flex; align-items: center; justify-content: center; transition: background 0.3s;" onmouseover="this.style.background='#444'" onmouseout="this.style.background='#333'">
                        <img src="https://upload.wikimedia.org/wikipedia/commons/e/e7/Instagram_logo_2016.svg" alt="Instagram" style="width: 22px; height: 22px; filter: brightness(0) invert(1);">
                    </a>
                    <a href="#" style="background: #333; width: 42px; height: 42px; border-radius: 6px; display: flex; align-items: center; justify-content: center; transition: background 0.3s;" onmouseover="this.style.background='#444'" onmouseout="this.style.background='#333'">
                        <svg style="width: 22px; height: 22px; fill: white;" viewBox="0 0 448 512"><path d="M448 209.9a210.1 210.1 0 0 1 -122.8-39.3V349.4A162.6 162.6 0 1 1 185 188.3V278.2a74.6 74.6 0 1 0 52.2 71.2V0l88 0a121.2 121.2 0 0 0 1.9 22.2h0A122.2 122.2 0 0 0 381 102.4a121.4 121.4 0 0 0 67 20.1z"/></svg>
                    </a>
                    <a href="#" style="background: #333; width: 42px; height: 42px; border-radius: 6px; display: flex; align-items: center; justify-content: center; transition: background 0.3s;" onmouseover="this.style.background='#444'" onmouseout="this.style.background='#333'">
                        <img src="https://upload.wikimedia.org/wikipedia/commons/6/6b/WhatsApp.svg" alt="WhatsApp" style="width: 22px; height: 22px; filter: brightness(0) invert(1);">
                    </a>
                    <a href="#" style="background: #333; width: 42px; height: 42px; border-radius: 6px; display: flex; align-items: center; justify-content: center; transition: background 0.3s;" onmouseover="this.style.background='#444'" onmouseout="this.style.background='#333'">
                        <img src="https://upload.wikimedia.org/wikipedia/commons/0/09/YouTube_full-color_icon_%282017%29.svg" alt="YouTube" style="width: 22px; height: 22px; filter: grayscale(1) invert(1) brightness(2);">
                    </a>
                </div>
            </div>
            
        </div>
        
        <!-- Bottom Small Text -->
        <div style="border-top: 1px solid #333; padding-top: 25px; margin-bottom: 20px;">
            <p style="color: #888; font-size: 0.75rem; line-height: 1.6; margin-bottom: 10px;">
                &sup1;All servicing or repairs carried out by Shift Auto Dynamics Approved Mechanics will be covered with a 12 month guarantee or 12,000 km (whichever comes first) unless explicitly explained and documented, for which you will receive a copy.
            </p>
            <p style="color: #888; font-size: 0.75rem; line-height: 1.6; margin-bottom: 0;">
                ^Pricing subject to change and varies by make and model. Example prices based on standard sedans.
            </p>
        </div>
        
        <!-- Footer Bottom Links -->
        <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; border-top: 1px solid #333; padding-top: 20px;">
            <div style="display: flex; gap: 30px; margin-bottom: 10px;">
                <a href="#" style="color: #e0e0e0; font-weight: 600; text-decoration: none; font-size: 0.85rem;" onmouseover="this.style.color='white'" onmouseout="this.style.color='#e0e0e0'">Privacy Policy</a>
                <a href="#" style="color: #e0e0e0; font-weight: 600; text-decoration: none; font-size: 0.85rem;" onmouseover="this.style.color='white'" onmouseout="this.style.color='#e0e0e0'">Terms of use</a>
                <a href="#" style="color: #e0e0e0; font-weight: 600; text-decoration: none; font-size: 0.85rem;" onmouseover="this.style.color='white'" onmouseout="this.style.color='#e0e0e0'">Accessibility</a>
                <a href="#" style="color: #e0e0e0; font-weight: 600; text-decoration: none; font-size: 0.85rem;" onmouseover="this.style.color='white'" onmouseout="this.style.color='#e0e0e0'">Cookie policy</a>
                <a href="#" style="color: #e0e0e0; font-weight: 600; text-decoration: none; font-size: 0.85rem;" onmouseover="this.style.color='white'" onmouseout="this.style.color='#e0e0e0'">Sitemap</a>
            </div>
            <div style="color: #888; font-size: 0.85rem; padding-bottom: 10px;">
                &copy; 2026 Shift Auto Dynamics Services. All rights reserved.
            </div>
        </div>
        
    </div>
</footer>


<!-- Scroll to Top Button -->
<button id="scrollToTopBtn" class="scroll-to-top" title="Go to top">
    <svg viewBox="0 0 320 512" width="16" height="16" fill="white"><path d="M177 159.7l136 136c9.4 9.4 9.4 24.6 0 33.9l-22.6 22.6c-9.4 9.4-24.6 9.4-33.9 0L160 255.9l-96.4 96.4c-9.4 9.4-24.6 9.4-33.9 0L7 329.7c-9.4-9.4-9.4-24.6 0-33.9l136-136c9.4-9.5 24.6-9.5 34-.1z"/></svg>
</button>

<script>
    const scrollToTopBtn = document.getElementById("scrollToTopBtn");
    window.addEventListener("scroll", () => {
        if (window.scrollY > 300) {
            scrollToTopBtn.classList.add("show");
        } else {
            scrollToTopBtn.classList.remove("show");
        }
    });
    scrollToTopBtn.addEventListener("click", () => {
        window.scrollTo({
            top: 0,
            behavior: "smooth"
        });
    });
</script>

</body>
</html>

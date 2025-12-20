// --- Variables ---
const pageTitle = " LAjim | Money Money Money | ";
const bioText = ["LAjim", "Money Money Money", "Rich", "Wealth", "Power"];
let titleIndex = 0;

const enterOverlay = document.getElementById('enter-overlay');
const cardContainer = document.getElementById('card-container');
const profileCard = document.getElementById('profile-card');
const volSlider = document.getElementById('vol-slider');
const typewriterSpan = document.getElementById('typewriter');
const onlineCountSpan = document.getElementById('online-count');
const totalCountSpan = document.getElementById('total-count');
const aboutCard = document.querySelector('.about-card');

// --- YouTube API Setup ---
let player;
function onYouTubeIframeAPIReady() {
    console.log("YouTube API Ready");
    player = new YT.Player('youtube-player', {
        height: '1',
        width: '1',
        videoId: 'ApNebxhv0ZI',
        playerVars: {
            'autoplay': 0,
            'controls': 0,
            'loop': 1,
            'playlist': 'ApNebxhv0ZI',
            'origin': window.location.origin
        },
        events: {
            'onReady': onPlayerReady,
            'onError': (e) => console.error("YouTube Player Error:", e.data)
        }
    });
}

function onPlayerReady(event) {
    console.log("YouTube Player Ready");
    if (volSlider) event.target.setVolume(volSlider.value);
    event.target.unMute();
}

// Load YouTube API
var tag = document.createElement('script');
tag.src = "https://www.youtube.com/iframe_api";
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

// --- 1. Click to Enter ---
if (enterOverlay) {
    enterOverlay.addEventListener('click', () => {
        enterOverlay.style.opacity = '0';
        enterOverlay.style.visibility = 'hidden';

        if (cardContainer) {
            cardContainer.style.visibility = 'visible';
            cardContainer.style.opacity = '1';
        }

        // Try to play YouTube first
        if (player && player.playVideo) {
            console.log("Attempting to play YouTube music...");
            player.playVideo();
            player.unMute();
        }

        // Always attempt to play local fallback
        const localAudio = document.getElementById('bg-music');
        if (localAudio) {
            localAudio.volume = (volSlider ? volSlider.value : 40) / 100;
            localAudio.play().catch(err => {
                console.log("Local audio fallback failed (likely needs interaction or file missing):", err);
            });
        }

        initTypewriter();
        setInterval(scrollTitle, 200);
        startStarFall();

        // Fake stats
        if (onlineCountSpan) onlineCountSpan.innerText = "1,337 Online";
        if (totalCountSpan) totalCountSpan.innerText = "9,999 Members";
    });
}

function startStarFall() {
    const container = document.getElementById('star-container');
    if (!container) return;

    function createStar() {
        const star = document.createElement('div');
        star.className = 'falling-star';

        const size = Math.random() * 3 + 1; // 1px to 4px
        const left = Math.random() * 100; // 0% to 100%
        const duration = Math.random() * 4 + 3; // 3s to 7s for elegance
        const delay = Math.random() * 5;

        star.style.width = `${size}px`;
        star.style.height = `${size}px`;
        star.style.left = `${left}%`;
        star.style.animation = `starFall ${duration}s linear ${delay}s infinite, starTwinkle 2s ease-in-out infinite`;

        if (Math.random() > 0.8) {
            star.style.background = '#ffd700'; // Gold
            star.style.filter = 'drop-shadow(0 0 5px #ffd700)';
        }

        container.appendChild(star);

        if (container.children.length > 100) {
            container.removeChild(container.firstChild);
        }
    }

    // Initial burst
    for (let i = 0; i < 40; i++) {
        createStar();
    }
    // Continuous spawning
    setInterval(createStar, 200);
}

// --- 3. 3D Parallax ---
document.addEventListener('mousemove', (e) => {
    if (window.innerWidth < 768) return;

    const x = (window.innerWidth / 2 - e.pageX) / 25; // Slightly gentler tilt
    const y = (window.innerHeight / 2 - e.pageY) / 25;

    const rotateX = Math.max(-10, Math.min(10, y));
    const rotateY = Math.max(-10, Math.min(10, -x));

    if (currentPage === 'main' && profileCard) {
        profileCard.style.transform = `rotateX(${rotateX}deg) rotateY(${rotateY}deg)`;
    } else if (currentPage === 'about' && aboutCard) {
        // Combined tilt for the whole tri-mirror assembly
        aboutCard.style.transform = `rotateX(${rotateX}deg) rotateY(${rotateY}deg)`;
    }
});

if (profileCard || aboutCard) {
    document.addEventListener('mouseleave', () => {
        if (profileCard) profileCard.style.transform = `rotateX(0deg) rotateY(0deg)`;
        if (aboutCard) aboutCard.style.transform = `rotateX(0deg) rotateY(0deg)`;
    });
}

// --- 4. Title Scroll ---
function scrollTitle() {
    document.title = pageTitle.substring(titleIndex) + pageTitle.substring(0, titleIndex);
    titleIndex = (titleIndex + 1) % pageTitle.length;
}

// --- 5. Volume & Visualizer ---
if (volSlider) {
    volSlider.addEventListener('input', (e) => {
        if (player && player.setVolume) {
            player.setVolume(e.target.value);
        }
        // Update local audio volume
        const localAudio = document.getElementById('bg-music');
        if (localAudio) {
            localAudio.volume = e.target.value / 100;
        }
        updateVisualizer(e.target.value);
    });
}

function updateVisualizer(volume) {
    const bars = document.querySelectorAll('.volume-visualizer .bar');
    if (!bars.length) return;

    // Base height mapping: 0 -> 20% height, 100 -> full activity range
    // We'll update the "amplitude" variable which affects the randomizer loop
    visualizerAmplitude = volume / 100;
}

let visualizerAmplitude = 0.4; // Default start

function animateVisualizer() {
    const bars = document.querySelectorAll('.volume-visualizer .bar');
    bars.forEach(bar => {
        // Random height based on amplitude
        if (visualizerAmplitude > 0.05) {
            const h = Math.random() * 100 * visualizerAmplitude;
            bar.style.height = `${Math.max(10, h)}%`;
        } else {
            bar.style.height = '4px'; // Almost flat if volume is 0
        }
    });

    setTimeout(animateVisualizer, 100);
}
// Start animation
animateVisualizer();

// --- 6. Typewriter ---
let textIndex = 0;
let charIndex = 0;
let isDeleting = false;
const typingSpeed = 100;
const deleteSpeed = 50;
const pauseTime = 1500;

function initTypewriter() {
    if (!typewriterSpan) return;
    const currentText = bioText[textIndex];

    if (isDeleting) {
        typewriterSpan.textContent = currentText.substring(0, charIndex - 1);
        charIndex--;
    } else {
        typewriterSpan.textContent = currentText.substring(0, charIndex + 1);
        charIndex++;
    }

    let typeSpeedCurrent = isDeleting ? deleteSpeed : typingSpeed;

    if (!isDeleting && charIndex === currentText.length) {
        typeSpeedCurrent = pauseTime;
        isDeleting = true;
    } else if (isDeleting && charIndex === 0) {
        isDeleting = false;
        textIndex = (textIndex + 1) % bioText.length;
        typeSpeedCurrent = 500;
    }

    setTimeout(initTypewriter, typeSpeedCurrent);
}

// --- 7. Dynamic Stock Chart (High Volatility) ---
const canvas = document.getElementById('canvas-overlay');
if (canvas) {
    const ctx = canvas.getContext('2d');
    let chartPoints = [];
    let speed = 4; // Faster

    function resizeCanvas() {
        canvas.width = window.innerWidth;
        canvas.height = window.innerHeight;
        initChart();
    }
    window.addEventListener('resize', resizeCanvas);

    function initChart() {
        chartPoints = [];
        let y = canvas.height * 0.8;
        // Fill screen with initial data
        for (let x = 0; x <= canvas.width + speed; x += speed) {
            y += (Math.random() - 0.5) * 30;
            if (y < canvas.height * 0.2) y = canvas.height * 0.5;
            if (y > canvas.height * 0.9) y = canvas.height * 0.5;
            chartPoints.push(y);
        }
    }
    resizeCanvas();

    function updateChart() {
        chartPoints.shift();

        let lastY = chartPoints[chartPoints.length - 1];
        let change = (Math.random() - 0.5) * 45;
        if (lastY < canvas.height * 0.3) change += 2;
        if (lastY > canvas.height * 0.7) change -= 2;

        let newY = lastY + change;
        chartPoints.push(newY);
    }

    function drawChart() {
        ctx.clearRect(0, 0, canvas.width, canvas.height);

        ctx.lineWidth = 2.5;
        ctx.lineJoin = 'miter';
        ctx.strokeStyle = 'rgba(255, 255, 255, 0.6)';
        ctx.shadowBlur = 15;
        ctx.shadowColor = 'rgba(255, 105, 180, 0.8)';

        ctx.beginPath();
        let x = 0;
        ctx.moveTo(0, chartPoints[0]);

        for (let i = 1; i < chartPoints.length; i++) {
            x += speed;
            ctx.lineTo(x, chartPoints[i]);
        }
        ctx.stroke();

        let lastY = chartPoints[chartPoints.length - 1];
        let endX = x;
        ctx.beginPath();
        ctx.fillStyle = "#fff";
        ctx.arc(endX, lastY, 4, 0, Math.PI * 2);
        ctx.fill();

        ctx.beginPath();
        ctx.strokeStyle = `rgba(255, 255, 255, ${0.3 + Math.sin(Date.now() / 200) * 0.2})`;
        ctx.arc(endX, lastY, 12, 0, Math.PI * 2);
        ctx.stroke();
    }

    function animate() {
        updateChart();
        drawChart();
        requestAnimationFrame(animate);
    }

    animate();
}

// --- 8. Click Effect ---
document.addEventListener('click', (e) => {
    // Create multiple ripples for a techy feel
    for (let i = 0; i < 3; i++) {
        setTimeout(() => {
            const ripple = document.createElement('div');
            ripple.classList.add('click-effect');
            ripple.style.left = `${e.clientX}px`;
            ripple.style.top = `${e.clientY}px`;
            ripple.style.borderColor = i === 1 ? 'rgba(0, 243, 255, 0.8)' : 'rgba(255, 255, 255, 0.8)';
            ripple.style.animationDelay = `${i * 0.1}s`;
            document.body.appendChild(ripple);

            ripple.addEventListener('animationend', () => {
                ripple.remove();
            });
        }, i * 50);
    }
});

// --- 9. Cursor Trail ---
document.addEventListener('mousemove', (e) => {
    const trail = document.createElement('div');
    trail.classList.add('cursor-trail');
    trail.style.left = `${e.clientX}px`;
    trail.style.top = `${e.clientY}px`;
    document.body.appendChild(trail);

    setTimeout(() => {
        trail.remove();
    }, 500);
});

// --- 10. UI Sound Effects ---
const audioCtx = new (window.AudioContext || window.webkitAudioContext)();

function playHoverSound() {
    if (audioCtx.state === 'suspended') audioCtx.resume();
    const oscillator = audioCtx.createOscillator();
    const gainNode = audioCtx.createGain();

    oscillator.type = 'sine';
    oscillator.frequency.setValueAtTime(400, audioCtx.currentTime);
    oscillator.frequency.exponentialRampToValueAtTime(600, audioCtx.currentTime + 0.05);

    gainNode.gain.setValueAtTime(0.05, audioCtx.currentTime);
    gainNode.gain.exponentialRampToValueAtTime(0.001, audioCtx.currentTime + 0.05);

    oscillator.connect(gainNode);
    gainNode.connect(audioCtx.destination);

    oscillator.start();
    oscillator.stop(audioCtx.currentTime + 0.05);
}

function playClickSound() {
    if (audioCtx.state === 'suspended') audioCtx.resume();
    const oscillator = audioCtx.createOscillator();
    const gainNode = audioCtx.createGain();

    oscillator.type = 'triangle';
    oscillator.frequency.setValueAtTime(300, audioCtx.currentTime);
    oscillator.frequency.exponentialRampToValueAtTime(100, audioCtx.currentTime + 0.1);

    gainNode.gain.setValueAtTime(0.1, audioCtx.currentTime);
    gainNode.gain.exponentialRampToValueAtTime(0.001, audioCtx.currentTime + 0.1);

    oscillator.connect(gainNode);
    gainNode.connect(audioCtx.destination);
    oscillator.start();
    oscillator.stop(audioCtx.currentTime + 0.1);
}

// --- 12. About Section Logic (Typewriter & Matrix) ---
let moneyRainInterval;

function typeAboutText() {
    const contentContainer = document.querySelector('.about-content');
    if (!contentContainer) return;

    // Matrix Rain Initialization
    initMatrixRain();
    // Money Rain Trigger
    startMoneyRain();

    // Local definition to ensure data availability
    const lines = [
        { text: "我的 16 歲，不只是夢想，是千萬級別的戰場。", highlight: "16 歲" },
        { text: "單槍匹馬，在商海中斬獲人生第一個一百萬。", highlight: "一百萬" },
        { text: "勞斯萊斯的格柵，是我與世界交談的底色。", highlight: "勞斯萊斯" },
        { text: "財富對我而言，是分享的喜悅。", highlight: "分享" },
        { text: "我是 LAjim，這就是我的 Money Game。", highlight: "LAjim" }
    ];

    contentContainer.innerHTML = ''; // Clear existing content

    let lineIndex = 0;

    function processNextLine() {
        if (lineIndex >= lines.length) return;

        const lineData = lines[lineIndex];
        const p = document.createElement('p');
        p.style.minHeight = '1.5em'; // Ensure height even when empty
        p.style.color = '#fff';      // Force white color
        contentContainer.appendChild(p);

        let charIdx = 0;
        const textStr = lineData.text;

        function addChar() {
            if (charIdx < textStr.length) {
                p.textContent += textStr.charAt(charIdx);
                charIdx++;
                setTimeout(addChar, 25); // Faster typing speed (was 50ms)
            } else {
                // Line complete, highlight logic
                if (lineData.highlight) {
                    p.innerHTML = p.innerHTML.replace(
                        lineData.highlight,
                        `<span class="highlight">${lineData.highlight}</span>`
                    );
                }
                lineIndex++;
                setTimeout(processNextLine, 300);
            }
        }

        // Start typing this line
        addChar();
    }

    // Start the process
    setTimeout(processNextLine, 100);
}

// --- 11. Navigation Logic ---
const nextPageBtn = document.getElementById('next-page-btn');
const bgImage = document.getElementById('bg-video');
const aboutSection = document.getElementById('about-section');
const backBtn = document.getElementById('back-btn');
const canvasOverlay = document.getElementById('canvas-overlay');

let isAnimating = false;
let currentPage = 'main'; // 'main' or 'about'

function goToNextPage() {
    if (isAnimating || currentPage === 'about') return;
    isAnimating = true;
    currentPage = 'about';

    playTransitionSound();

    // 1. Hide Main Panel & Button
    if (cardContainer) {
        cardContainer.style.transition = "transform 0.8s cubic-bezier(0.68, -0.55, 0.265, 1.55), opacity 0.8s";
        cardContainer.style.transform = "translate(-50%, -150%) rotateX(20deg)";
        cardContainer.style.opacity = "0";
    }

    if (nextPageBtn) {
        nextPageBtn.style.opacity = "0";
        setTimeout(() => nextPageBtn.style.display = 'none', 800);
    }

    // Hide Stock Chart
    if (canvasOverlay) canvasOverlay.style.transition = 'opacity 0.5s';
    if (canvasOverlay) canvasOverlay.style.opacity = '0';

    // 2. Show About Section (No BG Change)
    setTimeout(() => {
        // --- Glitch Flash Effect ---
        const flash = document.createElement('div');
        flash.className = 'glitch-flash'; // Style this in CSS or inline
        Object.assign(flash.style, {
            position: 'fixed', top: '0', left: '0', width: '100vw', height: '100vh',
            background: 'white', zIndex: '9999', opacity: '0.8', pointerEvents: 'none'
        });
        document.body.appendChild(flash);

        // Flash sequence
        setTimeout(() => flash.style.opacity = '0', 50);
        setTimeout(() => flash.style.opacity = '0.4', 100);
        setTimeout(() => {
            flash.remove();
            // Change BG to the computer screen image
            if (bgImage) bgImage.src = "second_bg.jpg";

            // Show About Section with Simple Fade-In
            if (aboutSection) {
                aboutSection.classList.remove('hidden');
                const aboutContainer = aboutSection.querySelector('.about-container');
                const aboutContent = aboutSection.querySelector('.about-content');
                const aboutH2 = aboutSection.querySelector('.about-card h2');

                if (aboutContainer) {
                    const aboutCard = aboutSection.querySelector('.about-card');

                    // Simple fade-in
                    aboutContainer.style.opacity = '0';
                    setTimeout(() => {
                        aboutContainer.style.transition = 'opacity 0.8s ease';
                        aboutContainer.style.opacity = '1';

                        // Start Tri-Mirror Unfolding
                        if (aboutCard) {
                            aboutCard.classList.remove('tri-mirror-stay');
                            aboutCard.classList.add('tri-mirror-active');
                            setTimeout(() => {
                                aboutCard.classList.remove('tri-mirror-active');
                                aboutCard.classList.add('tri-mirror-stay');
                            }, 1200); // Match CSS animation duration
                        }

                        // Show text
                        setTimeout(() => {
                            if (aboutH2) {
                                aboutH2.style.transition = 'opacity 0.5s ease';
                                aboutH2.style.opacity = '1';
                            }
                            if (aboutContent) {
                                aboutContent.style.transition = 'opacity 0.5s ease';
                                aboutContent.style.opacity = '1';
                            }
                            typeAboutText();
                        }, 500);
                    }, 50);

                    isAnimating = false;
                } else {
                    isAnimating = false;
                }
            } else {
                isAnimating = false;
            }


        }, 150);
    }, 600);
}

function goToMainPage() {
    if (isAnimating || currentPage === 'main') return;
    isAnimating = true;
    currentPage = 'main';

    playTransitionSound();

    // Hide About
    if (aboutSection) {
        const aboutContainer = aboutSection.querySelector('.about-container');
        if (aboutContainer) aboutContainer.style.opacity = '0';
        setTimeout(() => aboutSection.classList.add('hidden'), 500);
    }

    // Show Main Panel & Stock Chart
    setTimeout(() => {
        // Reset BG to original
        if (bgImage) bgImage.src = "tech_dark_background.jpg";

        if (canvasOverlay) canvasOverlay.style.opacity = '1';

        if (nextPageBtn) {
            nextPageBtn.style.display = 'block';
            setTimeout(() => nextPageBtn.style.opacity = '1', 50);
        }

        if (cardContainer) {
            cardContainer.style.transform = "translate(-50%, -50%)";
            cardContainer.style.opacity = "1";
        }
        isAnimating = false;
    }, 500);
}

// Event Listeners
if (nextPageBtn) nextPageBtn.addEventListener('click', goToNextPage);
if (backBtn) backBtn.addEventListener('click', goToMainPage);

// Scroll Navigation (Wheel)
window.addEventListener('wheel', (e) => {
    if (isAnimating) return;

    if (e.deltaY > 50) {
        // Scroll Down -> Next Page
        if (currentPage === 'main') goToNextPage();
    } else if (e.deltaY < -50) {
        // Scroll Up -> Main Page
        if (currentPage === 'about') goToMainPage();
    }
}, { passive: true });

// Add listeners to interactive elements
const interactiveElements = document.querySelectorAll('a, button, .badge, .enter-text, input[type="range"], #next-page-btn, #back-btn');

// --- 13. Scroll Reveal & Parallax ---
const observerOptions = {
    threshold: 0.1
};

const revealObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.classList.add('revealed');
        }
    });
}, observerOptions);

document.querySelectorAll('.scroll-reveal').forEach(el => revealObserver.observe(el));

// Parallax Background Effect
window.addEventListener('scroll', () => {
    const scrolled = window.pageYOffset;
    const bg = document.getElementById('bg-video');
    if (bg) {
        bg.style.transform = `translateY(${scrolled * 0.3}px)`;
    }
});

interactiveElements.forEach(el => {
    el.addEventListener('mouseenter', playHoverSound);
    el.addEventListener('mousedown', playClickSound);
});

// --- 14. MC Hearts Interaction & Death Sequence ---
const hearts = document.querySelectorAll('.heart');
if (hearts.length > 0) {
    const healthBar = document.querySelector('.mc-health-bar');
    healthBar.addEventListener('click', () => {
        // Find the last full heart and empty it
        const fullHearts = document.querySelectorAll('.heart.full');
        if (fullHearts.length > 0) {
            const lastHeart = fullHearts[fullHearts.length - 1];
            lastHeart.classList.remove('full');
            lastHeart.classList.add('empty');
            playDamageSound();

            if (document.querySelectorAll('.heart.full').length === 0) {
                triggerDeathSequence();
            }
        } else {
            // Refill all if all are empty
            resetHealth();
        }
    });
}

function resetHealth() {
    const card = document.querySelector('.card-container');
    const about = document.querySelector('.about-card');
    card.classList.remove('death-glitch');
    about.classList.remove('death-glitch');
    hearts.forEach(h => {
        h.classList.remove('empty');
        h.classList.add('full');
    });
}

function triggerDeathSequence() {
    const card = document.querySelector('.card-container');
    const about = document.querySelector('.about-card');
    card.classList.add('death-glitch');
    about.classList.add('death-glitch');

    // Death Sound (Glitch distortion)
    if (audioCtx.state === 'suspended') audioCtx.resume();
    const osc = audioCtx.createOscillator();
    const gn = audioCtx.createGain();
    osc.type = 'sawtooth';
    osc.frequency.setValueAtTime(40, audioCtx.currentTime);
    osc.frequency.linearRampToValueAtTime(1, audioCtx.currentTime + 1);
    gn.gain.setValueAtTime(0.2, audioCtx.currentTime);
    gn.gain.linearRampToValueAtTime(0, audioCtx.currentTime + 1);
    osc.connect(gn);
    gn.connect(audioCtx.destination);
    osc.start();
    osc.stop(audioCtx.currentTime + 1);

    setTimeout(resetHealth, 3000);
}


// Matrix Rain Logic

// Matrix Rain Logic
function initMatrixRain() {
    const canvas = document.getElementById('matrix-canvas');
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    canvas.width = canvas.parentElement.offsetWidth;
    canvas.height = canvas.parentElement.offsetHeight;

    const chars = "01$WealthLAjimMoneyWealthMillionaire".split("");
    const fontSize = 14;
    const columns = canvas.width / fontSize;
    const drops = [];

    for (let i = 0; i < columns; i++) drops[i] = 1;

    function draw() {
        ctx.fillStyle = "rgba(0, 0, 0, 0.05)";
        ctx.fillRect(0, 0, canvas.width, canvas.height);
        ctx.fillStyle = "#00f3ff";
        ctx.font = fontSize + "px monospace";

        for (let i = 0; i < drops.length; i++) {
            const text = chars[Math.floor(Math.random() * chars.length)];
            ctx.fillText(text, i * fontSize, drops[i] * fontSize);
            if (drops[i] * fontSize > canvas.height && Math.random() > 0.975) drops[i] = 0;
            drops[i]++;
        }
    }
    setInterval(draw, 33);
}

// Money Rain Logic
function startMoneyRain() {
    const container = document.getElementById('money-rain-container');
    if (!container) return;
    if (moneyRainInterval) clearInterval(moneyRainInterval);

    moneyRainInterval = setInterval(() => {
        const money = document.createElement('div');
        money.className = 'money-particle';
        money.innerHTML = '$';
        money.style.left = Math.random() * 100 + '%';
        money.style.animationDuration = (Math.random() * 3 + 2) + 's';
        money.style.opacity = Math.random();
        container.appendChild(money);
        setTimeout(() => money.remove(), 5000);
    }, 300);
}

function playDamageSound() {
    if (audioCtx.state === 'suspended') audioCtx.resume();
    const oscillator = audioCtx.createOscillator();
    const gainNode = audioCtx.createGain();
    oscillator.type = 'square';
    oscillator.frequency.setValueAtTime(150, audioCtx.currentTime);
    oscillator.frequency.exponentialRampToValueAtTime(50, audioCtx.currentTime + 0.1);
    gainNode.gain.setValueAtTime(0.1, audioCtx.currentTime);
    gainNode.gain.exponentialRampToValueAtTime(0.01, audioCtx.currentTime + 0.1);
    oscillator.connect(gainNode);
    gainNode.connect(audioCtx.destination);
    oscillator.start();
    oscillator.stop(audioCtx.currentTime + 0.1);
}

function playTransitionSound() {
    if (audioCtx.state === 'suspended') audioCtx.resume();

    const now = audioCtx.currentTime;

    // 1. Digital "Unlock" Zap
    const zap = audioCtx.createOscillator();
    const zapGain = audioCtx.createGain();
    zap.type = 'square';
    zap.frequency.setValueAtTime(1200, now);
    zap.frequency.exponentialRampToValueAtTime(100, now + 0.1);
    zapGain.gain.setValueAtTime(0.05, now);
    zapGain.gain.exponentialRampToValueAtTime(0.001, now + 0.1);
    zap.connect(zapGain);
    zapGain.connect(audioCtx.destination);
    zap.start();
    zap.stop(now + 0.1);

    // 2. Heavy Mechanical THUD
    const thud = audioCtx.createOscillator();
    const thudGain = audioCtx.createGain();
    thud.type = 'sine';
    thud.frequency.setValueAtTime(150, now + 0.05);
    thud.frequency.linearRampToValueAtTime(10, now + 0.5);
    thudGain.gain.setValueAtTime(0.3, now + 0.05);
    thudGain.gain.exponentialRampToValueAtTime(0.001, now + 0.5);
    thud.connect(thudGain);
    thudGain.connect(audioCtx.destination);
    thud.start(now + 0.05);
    thud.stop(now + 0.5);

    // 3. Servo WHIRR
    const whirr = audioCtx.createOscillator();
    const whirrGain = audioCtx.createGain();
    whirr.type = 'triangle';
    whirr.frequency.setValueAtTime(400, now + 0.1);
    whirr.frequency.exponentialRampToValueAtTime(800, now + 0.3);
    whirrGain.gain.setValueAtTime(0.1, now + 0.1);
    whirrGain.gain.exponentialRampToValueAtTime(0.001, now + 0.3);
    whirr.connect(whirrGain);
    whirrGain.connect(audioCtx.destination);
    whirr.start(now + 0.1);
    whirr.stop(now + 0.3);
}

// --- Variables ---
const pageTitle = " Rolls Royce | Money Money Money | ";
const bioText = ["Rolls Royce", "Money Money Money", "Rich", "Wealth", "Power"];
let titleIndex = 0;

const enterOverlay = document.getElementById('enter-overlay');
const cardContainer = document.getElementById('card-container');
const profileCard = document.getElementById('profile-card');
const volSlider = document.getElementById('vol-slider');
const typewriterSpan = document.getElementById('typewriter');
const onlineCountSpan = document.getElementById('online-count');
const totalCountSpan = document.getElementById('total-count');
const aboutCard = document.querySelector('.about-card');

// --- 1. Click to Enter ---
if (enterOverlay) {
    enterOverlay.addEventListener('click', () => {
        // 1. Immediate Actions (Audio Unlock)
        if (typeof audioCtx !== 'undefined' && audioCtx.state === 'suspended') {
            audioCtx.resume();
        }

        // 2. Start Visual Sequence
        enterOverlay.classList.add('sequence-active');
        playTransitionSound();

        // Spawn Code Rain (Matrix Effect)
        createCodeRain();

        // 3. Delayed Entry (5 Seconds)
        setTimeout(() => {
            enterOverlay.style.opacity = '0';
            enterOverlay.style.visibility = 'hidden';

            if (cardContainer) {
                cardContainer.style.visibility = 'visible';
                cardContainer.style.opacity = '1';
            }

            if (playlistPanel) {
                playlistPanel.style.visibility = 'visible';
                playlistPanel.style.opacity = '1';
            }

            // Always attempt to play local fallback
            const localAudio = document.getElementById('bg-music');
            if (localAudio) {
                localAudio.volume = (volSlider ? volSlider.value : 40) / 100;
                localAudio.play().catch(err => {
                    console.log("Audio playback failed:", err);
                });
            }

            initTypewriter();
            setInterval(scrollTitle, 200);
            startStarFall();

            // Fake stats
            if (onlineCountSpan) onlineCountSpan.innerText = "1,337 Online";
            if (totalCountSpan) totalCountSpan.innerText = "9,999 Members";
        }, 5000); // 5 Second Delay
    });
}

function createCodeRain() {
    const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%^&*";
    const container = document.getElementById('enter-overlay');

    // Spawn 50 drops
    for (let i = 0; i < 50; i++) {
        const span = document.createElement('span');
        span.className = 'falling-code';
        span.innerText = chars.charAt(Math.floor(Math.random() * chars.length));
        span.style.left = Math.random() * 100 + 'vw';
        span.style.fontSize = (Math.random() * 20 + 10) + 'px';
        span.style.animationDuration = (Math.random() * 1 + 1.5) + 's'; // 1.5s - 2.5s fall
        span.style.animationDelay = Math.random() * 1 + 's';

        container.appendChild(span);

        // Cleanup after animation
        setTimeout(() => { span.remove(); }, 3000);
    }
}

function startStarFall() {
    const container = document.getElementById('star-container');
    if (!container) return;

    function createStar() {
        const star = document.createElement('div');
        star.className = 'falling-star';

        const isStreak = Math.random() > 0.8;
        if (isStreak) star.classList.add('streak');

        const size = Math.random() * (isStreak ? 2 : 3) + 1; // 1px to 4px
        const left = Math.random() * 100; // 0% to 100%

        // Faster duration for "falling" sensation
        const duration = Math.random() * 2 + 1.5; // 1.5s to 3.5s
        const delay = Math.random() * 2;

        star.style.width = `${size}px`;
        star.style.height = `${size}px`;
        star.style.left = `${left}%`;

        // Enhanced animation string
        star.style.animation = `starFall ${duration}s linear ${delay}s infinite`;
        if (!isStreak) {
            star.style.animation += `, starTwinkle 2s ease-in-out infinite`;
        }

        if (Math.random() > 0.9) {
            star.style.background = '#ffd700'; // Gold
            star.style.filter = 'drop-shadow(0 0 5px #ffd700)';
            star.style.boxShadow = '0 0 10px #ffd700';
        }

        container.appendChild(star);

        // Keep a reasonable number of stars for performance
        if (container.children.length > 150) {
            container.removeChild(container.firstChild);
        }
    }

    // Larger initial burst for instant impact
    for (let i = 0; i < 60; i++) {
        createStar();
    }
    // Faster spawning for higher density
    setInterval(createStar, 100);
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



    // --- Music Pulse Effect for Buttons ---
    if (visualizerAmplitude > 0.1) {
        const beatPower = Math.random() * visualizerAmplitude * 0.3; // 0.0 to ~0.3 scale
        const scale = 1 + beatPower;
        const shadowOp = beatPower * 2; // Stronger shadow opacity

        // 1. Play Button Pulse
        const playBtn = document.getElementById('master-play');
        if (playBtn) {
            playBtn.classList.add('music-beat');
            playBtn.style.transform = `scale(${scale})`;
            playBtn.style.boxShadow = `0 0 ${10 + beatPower * 50}px rgba(0, 170, 255, ${0.4 + shadowOp})`;
        }

        // 2. Premium Button Pulse
        const premBtn = document.getElementById('premium-toggle-btn');
        if (premBtn) {
            premBtn.classList.add('music-beat');
            premBtn.style.transform = `scale(${scale})`;
            // Let the gold color handle itself, just boost shadow size
            // premBtn.style.boxShadow = ... (Best leave specific shadow to its own CSS or override carefully)
        }

        // 3. Active Social Button Pulse
        const activeSocial = document.querySelector('.social-btn.sequential-active');
        if (activeSocial && activeSocial !== premBtn) {
            activeSocial.classList.add('music-beat');
            activeSocial.style.transform = `scale(${1 + beatPower * 0.8})`; // Milder pulse
            activeSocial.style.boxShadow = `0 0 ${10 + beatPower * 30}px rgba(255, 255, 255, ${0.3 + shadowOp})`;
        }

    } else {
        // Reset if quiet
        ['master-play', 'premium-toggle-btn'].forEach(id => {
            const el = document.getElementById(id);
            if (el) {
                el.style.transform = 'scale(1)';
                el.style.boxShadow = '';
            }
        });
        const activeSocial = document.querySelector('.social-btn.sequential-active');
        if (activeSocial) {
            activeSocial.style.transform = 'scale(1)';
            activeSocial.style.boxShadow = '';
        }
    }

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
let currentLang = 'cn';
let typingTimeout = null;
let typingActive = false;
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

    // Stop existing typing if any
    if (typingTimeout) clearTimeout(typingTimeout);
    typingActive = true;

    // Matrix Rain Initialization (only once)
    initMatrixRain();
    startMoneyRain();

    const allLines = [
        {
            cn: "16歲，這不僅僅是夢想，這是百萬美元的戰場。",
            en: "At 16, it's not just a dream, it's a multi-million-dollar battlefield.",
            highlight: { cn: "16歲", en: "At 16" }
        },
        {
            cn: "獨自一人，我在商界奪取了我的第一桶金。",
            en: "Alone, I've seized my first million in the business world.",
            highlight: { cn: "第一桶金", en: "first million" }
        },
        {
            cn: "勞斯萊斯的水箱護罩，是我與世界對話的標誌。",
            en: "The Rolls Royce grille is the signature of my dialogue with the world.",
            highlight: { cn: "勞斯萊斯", en: "Rolls Royce" }
        },
        {
            cn: "對我來說，財富是分享的喜悅。",
            en: "To me, wealth is the joy of sharing.",
            highlight: { cn: "財富", en: "wealth" }
        },
        {
            cn: "我是 Rolls Royce，這就是我的金錢遊戲。",
            en: "I am Rolls Royce, and this is my Money Game.",
            highlight: { cn: "Rolls Royce", en: "Rolls Royce" }
        }
    ];

    contentContainer.innerHTML = '';
    let lineIndex = 0;

    function processNextLine() {
        if (!typingActive || lineIndex >= allLines.length) return;

        const lineData = allLines[lineIndex];
        const textStr = currentLang === 'cn' ? lineData.cn : lineData.en;
        const highlightText = currentLang === 'cn' ? lineData.highlight.cn : lineData.highlight.en;

        const p = document.createElement('p');
        p.className = currentLang === 'en' ? 'en-text' : '';
        contentContainer.appendChild(p);

        let charIdx = 0;
        function addChar() {
            if (!typingActive) return;

            if (charIdx < textStr.length) {
                p.textContent += textStr.charAt(charIdx);
                charIdx++;
                typingTimeout = setTimeout(addChar, currentLang === 'en' ? 15 : 30);
            } else {
                if (highlightText) {
                    p.innerHTML = p.innerHTML.replace(highlightText, `<span class="highlight">${highlightText}</span>`);
                }
                lineIndex++;
                typingTimeout = setTimeout(processNextLine, 300);
            }
        }
        addChar();
    }
    processNextLine();
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
            if (bgImage) bgImage.src = "https://zynuke.lol/second_bg.jpg";

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
        if (bgImage) bgImage.src = "https://zynuke.lol/tech_dark_background.jpg";

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
    const card = document.getElementById('card-container');
    const about = document.querySelector('.about-card');
    if (card) card.classList.remove('death-glitch');
    if (about) about.classList.remove('death-glitch');
    hearts.forEach(h => {
        h.classList.remove('empty');
        h.classList.add('full');
    });
}

function triggerDeathSequence() {
    const card = document.getElementById('card-container');
    const about = document.querySelector('.about-card');
    if (card) card.classList.add('death-glitch');
    if (about) about.classList.add('death-glitch');

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
// Matrix Rain Logic
let matrixInterval;
let matrixChars = "01$WealthRollsRoyceMoneyWealthMillionaire".split("");
let matrixFontSize = 14;

function initMatrixRain() {
    const canvas = document.getElementById('matrix-canvas');
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    canvas.width = canvas.parentElement.offsetWidth;
    canvas.height = canvas.parentElement.offsetHeight;

    const columns = canvas.width / matrixFontSize;
    const drops = [];

    for (let i = 0; i < columns; i++) drops[i] = 1;

    function draw() {
        ctx.fillStyle = "rgba(0, 0, 0, 0.05)";
        ctx.fillRect(0, 0, canvas.width, canvas.height);

        // Check if Premium Mode is active
        if (document.body.classList.contains('premium-mode')) {
            ctx.fillStyle = "#ffd700"; // Gold
        } else {
            ctx.fillStyle = "#00f3ff"; // Cyan
        }

        ctx.font = matrixFontSize + "px monospace";

        for (let i = 0; i < drops.length; i++) {
            const text = matrixChars[Math.floor(Math.random() * matrixChars.length)];
            ctx.fillText(text, i * matrixFontSize, drops[i] * matrixFontSize);
            if (drops[i] * matrixFontSize > canvas.height && Math.random() > 0.975) drops[i] = 0;
            drops[i]++;
        }
    }

    // Default start
    if (matrixInterval) clearInterval(matrixInterval);
    matrixInterval = setInterval(draw, 33);

    // Attach draw function to window so we can restart it with different speeds if needed, 
    // or just exposing a "setSpeed" function would be cleaner.
    window.updateMatrixSpeed = (speed) => {
        if (matrixInterval) clearInterval(matrixInterval);
        matrixInterval = setInterval(draw, speed);
    };
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

// --- 15. Music Playlist Logic & Premium Player ---
const playlistPanel = document.getElementById('playlist-panel');
const playlistToggle = document.getElementById('playlist-toggle');
const playlistItems = document.querySelectorAll('.playlist-item');
const bgMusic = document.getElementById('bg-music');

// Player UI Elements
const playerImg = document.getElementById('player-img');
const playerTitle = document.getElementById('player-title');
const playerArtist = document.getElementById('player-artist');
const masterPlayBtn = document.getElementById('master-play');
const masterPlayIcon = masterPlayBtn ? masterPlayBtn.querySelector('i') : null;
const prevBtn = document.getElementById('prev-track');
const nextBtn = document.getElementById('next-track');
const playerSeekSlider = document.getElementById('player-seek-slider');
const currentTimeDisplay = document.getElementById('current-time');
const totalTimeDisplay = document.getElementById('total-time');

let currentTrackIndex = 0;

if (playlistToggle && playlistPanel) {
    playlistToggle.addEventListener('click', (e) => {
        e.stopPropagation();
        playlistPanel.classList.toggle('open');
        playClickSound();

        // Rotate icon
        const icon = playlistToggle.querySelector('i');
        if (icon) {
            icon.style.transform = playlistPanel.classList.contains('open') ? 'rotate(180deg)' : 'rotate(0deg)';
        }
    });

    // Close when clicking outside
    document.addEventListener('click', (e) => {
        if (playlistPanel.classList.contains('open') &&
            !playlistPanel.contains(e.target) &&
            !playlistToggle.contains(e.target)) {
            playlistPanel.classList.remove('open');
            const icon = playlistToggle.querySelector('i');
            if (icon) icon.style.transform = 'rotate(0deg)';
        }
    });
}

function updatePlayerUI(item) {
    if (!item) return;
    const title = item.getAttribute('data-title') || "Unknown Track";
    const artist = item.getAttribute('data-artist') || "Unknown Artist";
    const img = item.getAttribute('data-img');

    if (playerTitle) playerTitle.textContent = title;
    if (playerArtist) playerArtist.textContent = artist;
    if (playerImg && img) playerImg.src = img;

    if (playerSeekSlider) {
        playerSeekSlider.value = 0;
        playerSeekSlider.max = 100; // Reset
    }
}

function playTrack(index) {
    if (index < 0 || index >= playlistItems.length) return;
    const item = playlistItems[index];
    const newSrc = item.getAttribute('data-src');

    if (bgMusic && newSrc) {
        playlistItems.forEach(i => i.classList.remove('active'));
        item.classList.add('active');
        currentTrackIndex = index;

        updatePlayerUI(item);

        bgMusic.src = newSrc;
        bgMusic.play().then(() => {
            if (masterPlayIcon) {
                masterPlayIcon.classList.remove('fa-play');
                masterPlayIcon.classList.add('fa-pause');
            }
            if (volSlider) updateVisualizer(volSlider.value);
        }).catch(err => {
            console.log("Playback failed:", err);
            // Try next track if fail
            // playTrack((index + 1) % playlistItems.length); // Optional: Auto skip
        });
    }
}

playlistItems.forEach((item, index) => {
    item.addEventListener('click', () => {
        playTrack(index);
        playClickSound();
    });
});

if (masterPlayBtn) {
    masterPlayBtn.addEventListener('click', () => {
        if (!bgMusic) return;
        if (bgMusic.paused) {
            bgMusic.play();
            if (masterPlayIcon) {
                masterPlayIcon.classList.remove('fa-play');
                masterPlayIcon.classList.add('fa-pause');
            }
        } else {
            bgMusic.pause();
            if (masterPlayIcon) {
                masterPlayIcon.classList.remove('fa-pause');
                masterPlayIcon.classList.add('fa-play');
            }
        }
        playClickSound();
    });
}

if (prevBtn) {
    prevBtn.addEventListener('click', () => {
        let index = currentTrackIndex - 1;
        if (index < 0) index = playlistItems.length - 1;
        playTrack(index);
        playClickSound();
    });
}

if (nextBtn) {
    nextBtn.addEventListener('click', () => {
        let index = currentTrackIndex + 1;
        if (index >= playlistItems.length) index = 0;
        playTrack(index);
        playClickSound();
    });
}

// Initial UI setup
const initialActive = document.querySelector('.playlist-item.active');
if (initialActive) {
    updatePlayerUI(initialActive);
    currentTrackIndex = Array.from(playlistItems).indexOf(initialActive);
}

if (bgMusic) {
    let isScrubbing = false;

    const updateSeekSliderFill = () => {
        if (playerSeekSlider && bgMusic.duration) {
            const percent = (playerSeekSlider.value / bgMusic.duration) * 100;
            playerSeekSlider.style.setProperty('--seek-percent', percent + '%');
        }
    };

    bgMusic.addEventListener('timeupdate', () => {
        if (bgMusic.duration && !isScrubbing) {
            if (playerSeekSlider) {
                playerSeekSlider.max = bgMusic.duration;
                playerSeekSlider.value = bgMusic.currentTime;
                updateSeekSliderFill();
            }

            const formatTime = (time) => {
                const mins = Math.floor(time / 60);
                const secs = Math.floor(time % 60);
                return `${mins}:${secs.toString().padStart(2, '0')}`;
            };

            if (currentTimeDisplay) currentTimeDisplay.textContent = formatTime(bgMusic.currentTime);
            if (totalTimeDisplay) totalTimeDisplay.textContent = '-' + formatTime(bgMusic.duration - bgMusic.currentTime);
        }
    });

    if (playerSeekSlider) {
        playerSeekSlider.addEventListener('input', () => {
            isScrubbing = true;
            updateSeekSliderFill();
            const formatTime = (time) => {
                const mins = Math.floor(time / 60);
                const secs = Math.floor(time % 60);
                return `${mins}:${secs.toString().padStart(2, '0')}`;
            };
            if (currentTimeDisplay) currentTimeDisplay.textContent = formatTime(playerSeekSlider.value);
        });

        playerSeekSlider.addEventListener('change', () => {
            bgMusic.currentTime = playerSeekSlider.value;
            isScrubbing = false;
        });
    }
}

// --- 17. Interactive Badge Effects ---
function playBadgeSound(type) {
    try {
        if (!audioCtx) return;
        if (audioCtx.state === 'suspended') audioCtx.resume();

        const osc = audioCtx.createOscillator();
        const gain = audioCtx.createGain();
        osc.connect(gain);
        gain.connect(audioCtx.destination);

        const now = audioCtx.currentTime;

        switch (type) {
            case 'King': // Majestic chime
                osc.type = 'triangle';
                osc.frequency.setValueAtTime(440, now);
                osc.frequency.exponentialRampToValueAtTime(880, now + 0.1);
                gain.gain.setValueAtTime(0.2, now);
                gain.gain.exponentialRampToValueAtTime(0.01, now + 0.5);
                osc.start(); osc.stop(now + 0.5);
                break;
            case 'Developer': // Digital blip
                osc.type = 'square';
                osc.frequency.setValueAtTime(880, now);
                osc.frequency.setValueAtTime(1760, now + 0.05);
                gain.gain.setValueAtTime(0.1, now);
                gain.gain.exponentialRampToValueAtTime(0.01, now + 0.15);
                osc.start(); osc.stop(now + 0.15);
                break;
            case 'Staff': // Tech scan
                osc.type = 'sawtooth';
                osc.frequency.setValueAtTime(100, now);
                osc.frequency.linearRampToValueAtTime(1000, now + 0.4);
                gain.gain.setValueAtTime(0.1, now);
                gain.gain.linearRampToValueAtTime(0, now + 0.4);
                osc.start(); osc.stop(now + 0.4);
                break;
            case 'Fighter': // Sword swish
                osc.type = 'sine';
                osc.frequency.setValueAtTime(1200, now);
                osc.frequency.exponentialRampToValueAtTime(100, now + 0.2);
                gain.gain.setValueAtTime(0.2, now);
                gain.gain.exponentialRampToValueAtTime(0.01, now + 0.2);
                osc.start(); osc.stop(now + 0.2);
                break;
            case 'Protection': // Shield hum
                osc.type = 'sine';
                osc.frequency.setValueAtTime(150, now);
                gain.gain.setValueAtTime(0, now);
                gain.gain.linearRampToValueAtTime(0.3, now + 0.1);
                gain.gain.linearRampToValueAtTime(0, now + 0.4);
                osc.start(); osc.stop(now + 0.4);
                break;
            case 'Wealth':
            case 'Coin':
            case 'Cash': // Money jingle
                osc.type = 'triangle';
                const f = type === 'Coin' ? 1000 : (type === 'Cash' ? 500 : 800);
                osc.frequency.setValueAtTime(f, now);
                gain.gain.setValueAtTime(0.1, now);
                gain.gain.exponentialRampToValueAtTime(0.01, now + 0.2);
                osc.start(); osc.stop(now + 0.2);
                break;
            case 'Star': // Cosmic burst
                osc.type = 'sine';
                osc.frequency.setValueAtTime(2000, now);
                osc.frequency.exponentialRampToValueAtTime(400, now + 0.5);
                gain.gain.setValueAtTime(0.1, now);
                gain.gain.exponentialRampToValueAtTime(0.01, now + 0.5);
                osc.start(); osc.stop(now + 0.5);
                break;
            case 'Hazard': // Warning buzzer
                osc.type = 'sawtooth';
                osc.frequency.setValueAtTime(80, now);
                gain.gain.setValueAtTime(0.2, now);
                gain.gain.setValueAtTime(0, now + 0.1);
                gain.gain.setValueAtTime(0.2, now + 0.2);
                gain.gain.setValueAtTime(0, now + 0.3);
                osc.start(); osc.stop(now + 0.3);
                break;
            default: // Default soft pop
                osc.type = 'sine';
                osc.frequency.setValueAtTime(600, now);
                gain.gain.setValueAtTime(0.1, now);
                gain.gain.exponentialRampToValueAtTime(0.01, now + 0.1);
                osc.start(); osc.stop(now + 0.1);
        }
    } catch (e) { }
}

function triggerBadgeEffect(badgeType, element) {
    playBadgeSound(badgeType);

    const rect = element.getBoundingClientRect();
    const centerX = rect.left + rect.width / 2;
    const centerY = rect.top + rect.height / 2;

    switch (badgeType) {
        case 'Developer':
            // Green Matrix Rain locally around badge
            createParticles(centerX, centerY, ['0', '1', '{', '}', ';', '=>'], 25, 'binary-particle');
            const devGlitch = document.createElement('div');
            devGlitch.className = 'glitch-overlay';
            devGlitch.style.background = 'rgba(0, 255, 0, 0.05)';
            document.body.appendChild(devGlitch);
            setTimeout(() => devGlitch.remove(), 400);
            break;

        case 'Staff':
            // Red Scanner sweep
            const scanner = document.createElement('div');
            scanner.className = 'staff-scanner';
            document.body.appendChild(scanner);
            setTimeout(() => scanner.remove(), 800);
            break;

        case 'OG':
            // Neon Flicker
            element.classList.add('og-pulse');
            createParticles(centerX, centerY, ['🔥', '✨', '⚡'], 10);
            setTimeout(() => element.classList.remove('og-pulse'), 1500);
            break;

        case 'Premium':
            // Platinum Shine
            element.classList.add('platinum-shine');
            createParticles(centerX, centerY, ['💎', '✨', '💿'], 15);
            setTimeout(() => element.classList.remove('platinum-shine'), 600);
            break;

        case 'King':
            element.classList.add('king-active');
            createParticles(centerX, centerY, ['👑', '⚜️', '🦁'], 15);
            setTimeout(() => element.classList.remove('king-active'), 2000);
            break;

        case 'Wealth':
            // Rain of Diamonds & Gold
            createParticles(centerX, centerY, ['💎', '💰', '💵'], 25);
            break;

        case 'Protection':
            const ripple = document.createElement('div');
            ripple.className = 'shield-ripple';
            ripple.style.left = centerX + 'px';
            ripple.style.top = centerY + 'px';
            document.body.appendChild(ripple);
            setTimeout(() => ripple.remove(), 600);
            break;

        case 'Alert':
            element.classList.add('badge-bell-ring');
            createParticles(centerX, centerY, ['⚠️', '❗'], 8);
            setTimeout(() => element.classList.remove('badge-bell-ring'), 400);
            break;

        case 'Builder':
            createParticles(centerX, centerY, ['🔨', '🏗️', '🔧'], 12);
            break;

        case 'Fighter':
            createSlash(centerX, centerY);
            break;

        case 'History':
            createParticles(centerX, centerY, ['📜', '⏳', '🏺'], 10);
            break;

        case 'Coin':
            // Spinning coins
            createParticles(centerX, centerY, ['🪙', '🟡', '💰'], 15);
            break;

        case 'Cash':
            // Dollar shower
            createParticles(centerX, centerY, ['💵', '💸', '🤑'], 20);
            break;

        case 'Star':
            createParticles(centerX, centerY, ['⭐', '🌟', '✨', '💫'], 20);
            break;

        case 'Hazard':
            const wave = document.createElement('div');
            wave.className = 'toxic-wave';
            wave.style.left = centerX + 'px';
            wave.style.top = centerY + 'px';
            document.body.appendChild(wave);
            setTimeout(() => wave.remove(), 800);
            createParticles(centerX, centerY, ['☣️', '☢️', '☠️'], 10);
            break;

        case 'Rookie':
            createParticles(centerX, centerY, ['🌱', '👶', '🐣'], 12);
            break;
    }

}

function createParticles(x, y, emojis, count, customClass) {
    for (let i = 0; i < count; i++) {
        const p = document.createElement('div');
        p.className = 'badge-particle' + (customClass ? ' ' + customClass : '');
        p.textContent = emojis[Math.floor(Math.random() * emojis.length)];
        p.style.left = x + 'px';
        p.style.top = y + 'px';

        const tx = (Math.random() - 0.5) * 400;
        const ty = (Math.random() - 0.5) * 400;
        p.style.setProperty('--tx', tx + 'px');
        p.style.setProperty('--ty', ty + 'px');

        document.body.appendChild(p);
        setTimeout(() => p.remove(), 1000);
    }
}

function createSlash(x, y) {
    for (let i = 0; i < 2; i++) {
        const slash = document.createElement('div');
        slash.className = 'fighter-slash';
        slash.style.left = x + 'px';
        slash.style.top = y + 'px';
        slash.style.setProperty('--rot', (i === 0 ? 45 : -45) + 'deg');
        document.body.appendChild(slash);
        setTimeout(() => slash.remove(), 400);
    }
}

// Bind events to all badges
document.querySelectorAll('.badge').forEach(badge => {
    badge.addEventListener('click', () => {
        const type = badge.getAttribute('data-tooltip');
        triggerBadgeEffect(type, badge);
    });
});


// --- 16. Mini Player Extra Volume ---
const miniVolSlider = document.getElementById('mini-vol-slider');
if (miniVolSlider && bgMusic) {
    miniVolSlider.addEventListener('input', (e) => {
        bgMusic.volume = e.target.value / 100;
        // Sync with main volume slider if it exists
        if (volSlider) volSlider.value = e.target.value;
    });
}


const langToggle = document.getElementById('lang-toggle');
if (langToggle) {
    langToggle.addEventListener('click', () => {
        playClickSound();
        currentLang = currentLang === 'cn' ? 'en' : 'cn';
        typeAboutText();
    });
}

// --- 18. Premium Crown Mode Toggle ---
const premiumBtn = document.getElementById('premium-toggle-btn');
if (premiumBtn) {
    premiumBtn.addEventListener('click', () => {
        playClickSound();
        document.body.classList.toggle('premium-mode');

        // Optional: Play a special sound for premium mode
        if (document.body.classList.contains('premium-mode')) {
            playBadgeSound('King'); // Use King/Gold sound

            // Sequence: Speed Up and STAY Fast (Extreme Speed)
            if (window.updateMatrixSpeed) {
                window.updateMatrixSpeed(5); // Maximum speed (browser limit approx 4ms)
            }
        } else {
            // Revert to normal
            if (window.updateMatrixSpeed) {
                window.updateMatrixSpeed(33); // Normal
            }
        }
    });
}

// --- 19. Social Button Sequencing ---
function startSocialSequence() {
    // Select all social buttons EXCEPT the Crown Button
    const buttons = document.querySelectorAll('.social-btn:not(#premium-toggle-btn)');
    if (buttons.length === 0) return;

    let currentIndex = 0;

    function activateButton(index) {
        // Remove active class from all
        buttons.forEach(btn => btn.classList.remove('sequential-active'));

        // Add to current
        if (buttons[index]) {
            buttons[index].classList.add('sequential-active');
        }
    }

    // Initial activation
    activateButton(currentIndex);

    // Cycle every 5 seconds
    setInterval(() => {
        currentIndex = (currentIndex + 1) % buttons.length;
        activateButton(currentIndex);
    }, 5000);
}

// Start sequence on load
startSocialSequence();

if (bgMusic) {
    bgMusic.addEventListener('ended', () => {
        if (isLooping) {
            bgMusic.currentTime = 0;
            bgMusic.play();
        } else if (isAutoNext) {
            // Directly trigger next track logic
            let index = currentTrackIndex + 1;
            if (typeof playlistItems !== 'undefined' && index >= playlistItems.length) index = 0;
            if (typeof playTrack === 'function') playTrack(index);
        } else {
            if (masterPlayIcon) {
                masterPlayIcon.classList.remove('fa-pause');
                masterPlayIcon.classList.add('fa-play');
            }
        }
    });
}






// --- 21. Music Style Mode Toggle (Rubber Disc) ---
const styleModeToggle = document.getElementById('style-mode-toggle');
// Find the album art container (it's inside player-container)
// Structure: .player-container -> .album-art
const albumArtContainer = document.querySelector('.player-container .album-art');

if (styleModeToggle) {
    styleModeToggle.addEventListener('click', (e) => {
        e.stopPropagation();
        const panel = document.getElementById('playlist-panel');
        if (panel) {
            panel.classList.toggle('rubber-disc-mode');
            playClickSound();

            // Check play state immediately
            if (bgMusic && !bgMusic.paused && panel.classList.contains('rubber-disc-mode')) {
                panel.classList.add('playing');
            } else {
                panel.classList.remove('playing');
            }
        }
    });
}

// Sync Rotation with Music State
if (bgMusic) {
    // When music plays, set a class to run animation
    bgMusic.addEventListener('play', () => {
        const panel = document.getElementById('playlist-panel');
        if (panel && panel.classList.contains('rubber-disc-mode')) {
            panel.classList.add('playing');
        }
    });

    bgMusic.addEventListener('pause', () => {
        const panel = document.getElementById('playlist-panel');
        if (panel) {
            panel.classList.remove('playing');
        }
    });
}

// --- 22. Sidebar Loop & Auto-Next Logic ---
let isLooping = false;
let isAutoNext = false; // Default off, or could be true if user wants continuous

const loopBtn = document.getElementById('loop-btn');
const autoNextBtn = document.getElementById('auto-next-btn');

if (loopBtn) {
    loopBtn.addEventListener('click', () => {
        isLooping = !isLooping;
        loopBtn.classList.toggle('active');
        playClickSound();

        // Loop and Auto-Next are usually mutually exclusive logic (Loop takes precedence)
        // If Loop is ON, Auto-Next visual can stay, but Loop logic runs first.
    });
}

if (autoNextBtn) {
    autoNextBtn.addEventListener('click', () => {
        isAutoNext = !isAutoNext;
        autoNextBtn.classList.toggle('active');
        playClickSound();
    });
}

// --- 17. View Laptop Button (Panel Switch) ---
const viewLaptopBtn = document.getElementById('view-laptop-btn');
const laptopSection = document.getElementById('laptop-section');
const laptopBackBtn = document.getElementById('laptop-back-btn');
// aboutSection is already defined at line 527, reuse it or fetch it again without const if scope allows. 
// Just using getElementById again without const to be safe or just use the global one if available.
const aboutSec = document.getElementById('about-section');

let laptopInitialized = false;

if (viewLaptopBtn && laptopSection && aboutSec) {
    viewLaptopBtn.addEventListener('click', () => {
        playClickSound();
        aboutSec.classList.add('hidden');
        laptopSection.classList.remove('hidden');

        if (!laptopInitialized) {
            initLaptop3D();
            laptopInitialized = true;
        }
    });
}

if (laptopBackBtn && laptopSection && aboutSec) {
    laptopBackBtn.addEventListener('click', () => {
        playClickSound();
        laptopSection.classList.add('hidden');
        aboutSec.classList.remove('hidden');
    });
}

// --- 3D Laptop Logic (Three.js) ---
let scene3D, camera3D, renderer3D, controls3D, laptopGroup3D;
let raycaster, mouse;
let keyboardKeys = []; // Array to store key meshes
// Control Variables
let targetLidAngle = 230; // Default
let autoRotationSpeed = 0.002;
let kbLightColor = new THREE.Color(0x00aaff);
let kbGlows = []; // Store glow meshes
let hoveredKey = null;

let isExploded = false;
let isHackerMode = false;
let hackerInterval = null;
let isLevitating = false;

function initLaptop3D() {
    if (typeof THREE === 'undefined') {
        console.error("Three.js not loaded");
        return;
    }

    scene3D = new THREE.Scene();

    // Raycaster Init
    raycaster = new THREE.Raycaster();
    mouse = new THREE.Vector2();

    // Camera
    camera3D = new THREE.PerspectiveCamera(24, window.innerWidth / window.innerHeight, 0.1, 1000);
    camera3D.position.set(12, 8, 12);

    // Renderer
    renderer3D = new THREE.WebGLRenderer({ antialias: true, alpha: true });
    renderer3D.setSize(window.innerWidth, window.innerHeight);
    renderer3D.setPixelRatio(Math.min(window.devicePixelRatio, 2));
    renderer3D.outputEncoding = THREE.sRGBEncoding;
    renderer3D.toneMapping = THREE.ACESFilmicToneMapping;
    renderer3D.toneMappingExposure = 1.4;

    const container = document.getElementById('laptop-canvas-container');
    if (container) {
        container.innerHTML = ''; // Clear previous if any
        container.appendChild(renderer3D.domElement);

        // Event Listeners for Interaction
        container.addEventListener('mousemove', onMouseMove3D, false);
        container.addEventListener('click', onClick3D, false);
    }

    controls3D = new THREE.OrbitControls(camera3D, renderer3D.domElement);
    controls3D.enableDamping = true;
    controls3D.dampingFactor = 0.05;
    controls3D.target.set(0, 0.5, 0);

    // Lighting
    const ambientLight = new THREE.AmbientLight(0xffffff, 0.4);
    scene3D.add(ambientLight);

    const rectLight = new THREE.RectAreaLight(0xffffff, 6, 15, 15);
    rectLight.position.set(5, 12, 5);
    rectLight.lookAt(0, 0, 0);
    scene3D.add(rectLight);

    const rimLight = new THREE.PointLight(0x77aaff, 2, 25);
    rimLight.position.set(-10, 8, -5);
    scene3D.add(rimLight);

    // Environment
    const pmremGenerator = new THREE.PMREMGenerator(renderer3D);
    const envScene = new THREE.Scene();
    const lightPlane = new THREE.Mesh(new THREE.PlaneGeometry(50, 50), new THREE.MeshBasicMaterial({ color: 0xffffff }));
    lightPlane.position.set(0, 20, -15);
    envScene.add(lightPlane);
    const envMap = pmremGenerator.fromScene(envScene).texture;
    scene3D.environment = envMap;

    // Model
    laptopGroup3D = new THREE.Group();
    createPremiumLaptop(envMap);
    scene3D.add(laptopGroup3D);

    // Shadow
    const shadowTex = createShadowTexture();
    const shadowPlane = new THREE.Mesh(
        new THREE.PlaneGeometry(15, 15),
        new THREE.MeshBasicMaterial({ map: shadowTex, transparent: true, opacity: 0.4 })
    );
    shadowPlane.rotation.x = -Math.PI / 2;
    shadowPlane.position.y = -0.4;
    scene3D.add(shadowPlane);

    window.addEventListener('resize', onWindowResize3D, false);

    // Bind Controls
    bindLaptopControls();

    animate3D();
}

// --- 30-Function Cyber Command Logic ---
function bindLaptopControls() {
    const lidSlider = document.getElementById('lid-angle-slider');
    const rotSlider = document.getElementById('rotate-speed-slider');

    if (lidSlider) {
        lidSlider.addEventListener('input', (e) => {
            targetLidAngle = parseFloat(e.target.value);
        });
        lidSlider.addEventListener('mousedown', playClickSound);
    }

    if (rotSlider) {
        rotSlider.addEventListener('input', (e) => {
            autoRotationSpeed = parseFloat(e.target.value) / 1000;
        });
        rotSlider.addEventListener('mousedown', playClickSound);
    }
}

// Global Cyber Function Handler
window.cyberFunc = function (action) {
    playClickSound(); // Sound feedback

    // Find button to add active state visual
    const btn = event.currentTarget;
    if (btn) {
        btn.classList.add('active-cyber');
        setTimeout(() => btn.classList.remove('active-cyber'), 200);
    }

    switch (action) {
        // --- Group 1: Power & System ---
        case 'power':
            const lid = laptopGroup3D.children[2];
            const screen = lid.children[3];
            screen.visible = !screen.visible;
            break;
        case 'reboot':
            let flickers = 0;
            const bootInt = setInterval(() => {
                const s = laptopGroup3D.children[2].children[3];
                s.visible = !s.visible;
                flickers++;
                if (flickers > 10) { clearInterval(bootInt); s.visible = true; }
            }, 100);
            break;
        case 'turbo': autoRotationSpeed = 0.05; document.getElementById('rotate-speed-slider').value = 50; break;
        case 'eco': autoRotationSpeed = 0.0005; kbLightColor.setHex(0x003300); updateKbColors(); break;
        case 'freeze': autoRotationSpeed = 0; break;

        // --- Group 2: Display Modes ---
        case 'matrix': changeScreenTexture(createMatrixTexture()); break;
        case 'glitch': changeScreenTexture(createGlitchTexture()); break;
        case 'term': changeScreenTexture(createTerminalTexture()); break;
        case 'bsod': changeScreenTexture(createBSODTexture()); break;
        case 'cyber': changeScreenTexture(createScreenTexture()); break;

        // --- Group 3: Chassis/Material ---
        case 'gold': changeMaterial(0xffd700, 0.8, 0.2); break;
        case 'silver': changeMaterial(0xc0c0c0, 0.9, 0.1); break;
        case 'carbon': changeMaterial(0x111111, 0.5, 0.5); break;
        case 'glass': changeMaterial(0xffffff, 0.1, 0, 0.1); break;
        case 'wire':
            laptopGroup3D.traverse(child => { if (child.isMesh) child.material.wireframe = !child.material.wireframe; });
            break;

        // --- Group 7: Camera Views ---
        case 'cam_top': gsapToCamera(0, 15, 0); break;
        case 'cam_front': gsapToCamera(0, 2, 12); break;
        case 'cam_side': gsapToCamera(15, 2, 0); break;
        case 'cam_iso': gsapToCamera(10, 10, 10); break;
        case 'cam_auto':
            if (window.autoCamInt) clearInterval(window.autoCamInt);
            else window.autoCamInt = setInterval(() => {
                const t = Date.now() * 0.0005;
                camera3D.position.x = Math.sin(t) * 15;
                camera3D.position.z = Math.cos(t) * 15;
                camera3D.lookAt(0, 0, 0);
            }, 16);
            break;

        // --- Group 8: Environment ---
        case 'env_day': scene3D.background = new THREE.Color(0xddeeff); break;
        case 'env_night': scene3D.background = null; break; // Transparent/CSS bg
        case 'env_fog': scene3D.fog = scene3D.fog ? null : new THREE.FogExp2(0x000000, 0.05); break;
        case 'env_grid': toggleGridHelper(); break;
        case 'env_stars': toggleStars(); break;

        // --- Group 9: Extra Screen ---
        case 'scr_code': changeScreenTexture(createCodeTexture()); break;
        case 'scr_game': changeScreenTexture(createGameTexture()); break;
        case 'scr_lock': changeScreenTexture(createLockTexture()); break;
        case 'scr_404': changeScreenTexture(create404Texture()); break;
        case 'scr_off': changeScreenTexture(createOffTexture()); break;


        // --- Group 4: RGB & Keyboard ---
        case 'neon': kbLightColor.setHex(Math.random() * 0xffffff); updateKbColors(); break;
        case 'wave': toggleInterval('wave', () => { kbLightColor.setHSL(Date.now() * 0.0005 % 1, 1, 0.5); updateKbColors(); }, 50); break;
        case 'breathe': toggleInterval('breathe', () => { const i = (Math.sin(Date.now() * 0.002) + 1) * 0.5; kbGlows.forEach(g => g.material.opacity = i * 0.8); }, 30); break;
        case 'strobe': toggleInterval('strobe', () => { const on = Date.now() % 200 < 100; kbGlows.forEach(g => g.visible = on); }, 50); break;
        case 'kboff': clearAllIntervals(); kbGlows.forEach(g => g.visible = false); break;

        // --- Group 5: Physics & Motion ---
        case 'levitate': isLevitating = !isLevitating; break;
        case 'ground': laptopGroup3D.position.y = -2; break;
        case 'spin_up': autoRotationSpeed += 0.005; break;
        case 'spin_down': autoRotationSpeed -= 0.005; break;
        case 'lid_toggle': targetLidAngle = targetLidAngle > 100 ? 0 : 230; break;

        // --- Group 6: Special FX ---
        case 'explode': isExploded = !isExploded; break;
        case 'hacker': isHackerMode = !isHackerMode; if (isHackerMode) startHackerEffect(); else stopHackerEffect(); break;
        case 'shield': toggleShield(); break;
        case 'scan': triggerScanEffect(); break;
        case 'nuke': location.reload(); break;

        // --- Group 10: Particles ---
        case 'part_rain': toggleParticles('rain'); break;
        case 'part_snow': toggleParticles('snow'); break;
        case 'part_fire': toggleParticles('fire'); break;
        case 'part_conf': toggleParticles('confetti'); break;
        case 'part_void': toggleParticles('void'); break;

        // --- Group 11: Render FX ---
        case 'fx_shake': document.body.style.animation = "shake 0.5s"; setTimeout(() => document.body.style.animation = "", 500); break;
        case 'fx_bloom': renderer3D.toneMappingExposure = 3.0; setTimeout(() => renderer3D.toneMappingExposure = 1.4, 2000); break;
        case 'fx_bw': document.body.style.filter = "grayscale(100%)"; break;
        case 'fx_inv': document.body.style.filter = "invert(100%)"; break;
        case 'fx_pix': document.body.style.filter = "none"; break; // Reset filters

        // --- Group 12: Debug/System ---
        case 'dbg_fps': alert("FPS: 60 (Simulated)"); break;
        case 'dbg_axis': toggleAxes(); break;
        case 'sys_clean': alert("System Cleaned. Memory Freed."); break;
        case 'sys_boost': document.body.style.animation = "pulse 0.2s infinite"; setTimeout(() => document.body.style.animation = "", 2000); break;
        case 'sys_destruct':
            let cnt = 5;
            const destInt = setInterval(() => {
                alert(`Self Destruct in ${cnt}...`);
                cnt--;
                if (cnt < 0) { clearInterval(destInt); location.reload(); }
            }, 1000);
            break;
    }
};

let axesHelper;
function toggleAxes() {
    if (!axesHelper) {
        axesHelper = new THREE.AxesHelper(10);
        scene3D.add(axesHelper);
    } else {
        axesHelper.visible = !axesHelper.visible;
    }
}

// Helper Functions
function updateKbColors() {
    kbGlows.forEach(glow => {
        glow.material.color.copy(kbLightColor);
        glow.material.emissive.copy(kbLightColor);
        glow.visible = true; // Ensure visible
    });
}

function changeMaterial(color, metalness, roughness, transmission) {
    laptopGroup3D.traverse(child => {
        if (child.isMesh && child.geometry.type === 'BoxGeometry') {
            // Heuristic to find body parts vs screen
            child.material.color.setHex(color);
            child.material.metalness = metalness;
            child.material.roughness = roughness;
            if (transmission !== undefined) child.material.transmission = transmission;
            child.material.wireframe = false; // Reset wireframe
        }
    });
}

function changeScreenTexture(texture) {
    const lid = laptopGroup3D.children[2];
    const screen = lid.children[3];
    screen.material.map = texture;
    screen.material.needsUpdate = true;
}

// Texture Generators
function createMatrixTexture() {
    const canvas = document.createElement('canvas');
    canvas.width = 512; canvas.height = 512;
    const ctx = canvas.getContext('2d');
    ctx.fillStyle = 'black'; ctx.fillRect(0, 0, 512, 512);
    ctx.fillStyle = '#0f0'; ctx.font = '20px monospace';
    for (let i = 0; i < 30; i++) ctx.fillText(Math.random().toString(2).substring(2), 10, i * 20 + 20);
    return new THREE.CanvasTexture(canvas);
}

function createBSODTexture() {
    const canvas = document.createElement('canvas');
    canvas.width = 512; canvas.height = 300;
    const ctx = canvas.getContext('2d');
    ctx.fillStyle = '#0000aa'; ctx.fillRect(0, 0, 512, 300);
    ctx.fillStyle = 'white'; ctx.font = '20px monospace';
    ctx.fillText(':(', 50, 80);
    ctx.fillText('Your PC ran into a problem.', 50, 120);
    return new THREE.CanvasTexture(canvas);
}

function createTerminalTexture() {
    const canvas = document.createElement('canvas');
    canvas.width = 512; canvas.height = 300;
    const ctx = canvas.getContext('2d');
    ctx.fillStyle = 'black'; ctx.fillRect(0, 0, 512, 300);
    ctx.fillStyle = '#0f0'; ctx.font = '16px monospace';
    ctx.fillText('> SYSTEM_ROOT access granted', 20, 40);
    ctx.fillText('> init_protocol: OMEGA', 20, 70);
    ctx.fillText('> _', 20, 100);
    return new THREE.CanvasTexture(canvas);
}

function createGlitchTexture() {
    const canvas = document.createElement('canvas');
    canvas.width = 512; canvas.height = 300;
    const ctx = canvas.getContext('2d');
    ctx.fillStyle = '#111'; ctx.fillRect(0, 0, 512, 300);
    for (let i = 0; i < 50; i++) {
        ctx.fillStyle = `hsl(${Math.random() * 360}, 100%, 50%)`;
        ctx.fillRect(Math.random() * 512, Math.random() * 300, Math.random() * 100, 5);
    }
    return new THREE.CanvasTexture(canvas);
}

// FX Helpers
let shieldMesh = null;
function toggleShield() {
    if (shieldMesh) {
        scene3D.remove(shieldMesh);
        shieldMesh = null;
    } else {
        const geo = new THREE.SphereGeometry(6, 32, 32);
        const mat = new THREE.MeshBasicMaterial({ color: 0x00aaff, transparent: true, opacity: 0.2, wireframe: true });
        shieldMesh = new THREE.Mesh(geo, mat);
        scene3D.add(shieldMesh);
    }
}

function startHackerEffect() {
    if (hackerInterval) clearInterval(hackerInterval);
    hackerInterval = setInterval(() => {
        if (keyboardKeys.length > 0) {
            const randKey = keyboardKeys[Math.floor(Math.random() * keyboardKeys.length)];
            animateKeyPress(randKey);
        }
    }, 50);
}
function stopHackerEffect() {
    clearInterval(hackerInterval);
}

function triggerScanEffect() {
    const scanner = new THREE.Mesh(new THREE.RingGeometry(0.1, 7, 32), new THREE.MeshBasicMaterial({ color: 0xff0000, side: THREE.DoubleSide, transparent: true, opacity: 0.5 }));
    scanner.rotation.x = -Math.PI / 2;
    scanner.position.y = -2;
    scene3D.add(scanner);

    // Animate up
    let scanY = -2;
    const int = setInterval(() => {
        scanY += 0.2;
        scanner.position.y = scanY;
        if (scanY > 10) {
            clearInterval(int);
            scene3D.remove(scanner);
        }
    }, 30);
}


// Mouse Event Handlers
function onMouseMove3D(event) {
    if (!renderer3D) return;
    const rect = renderer3D.domElement.getBoundingClientRect();
    mouse.x = ((event.clientX - rect.left) / rect.width) * 2 - 1;
    mouse.y = -((event.clientY - rect.top) / rect.height) * 2 + 1;
}

function onClick3D(event) {
    // Raycasting for Click
    if (!raycaster || !camera3D) return;
    raycaster.setFromCamera(mouse, camera3D);

    const intersects = raycaster.intersectObjects(keyboardKeys);
    if (intersects.length > 0) {
        const key = intersects[0].object;
        playClickSound(); // Keyboard click sound
        animateKeyPress(key);
    }
}

function animateKeyPress(key) {
    // Simple visual feedback: move down
    const originalY = key.position.y;
    key.position.y -= 0.02;
    key.material.color.setHex(0x00f3ff); // Flash Cyan

    setTimeout(() => {
        key.position.y = originalY;
        key.material.color.setHex(0xffffff); // Reset
    }, 150);
}

function createScreenTexture() {
    const canvas = document.createElement('canvas');
    canvas.width = 2048;
    canvas.height = 1440;
    const ctx = canvas.getContext('2d');

    // Background Gradient
    const grad = ctx.createLinearGradient(0, 0, 2048, 1440);
    grad.addColorStop(0, '#020a2f');
    grad.addColorStop(0.5, '#0a2a5a');
    grad.addColorStop(1, '#020a2f');
    ctx.fillStyle = grad;
    ctx.fillRect(0, 0, 2048, 1440);

    // Center Glow
    ctx.globalAlpha = 0.4;
    ctx.fillStyle = '#0066ff';
    ctx.beginPath(); ctx.ellipse(1024, 720, 1200, 600, 0, 0, Math.PI * 2); ctx.fill();

    // Deco Lines
    ctx.globalAlpha = 1.0;
    ctx.strokeStyle = 'rgba(255, 255, 255, 0.25)';
    ctx.lineWidth = 4;
    ctx.strokeRect(80, 80, 1888, 1280);

    // Text
    ctx.fillStyle = '#ffffff';
    ctx.font = 'bold 90px sans-serif';
    ctx.fillText('REVERSE FOLD', 180, 300);
    ctx.font = 'bold 120px sans-serif';
    ctx.fillText('230° BACKWARD', 180, 450);

    ctx.font = '40px sans-serif';
    ctx.fillStyle = 'rgba(255, 255, 255, 0.6)';
    ctx.fillText('CONVERTIBLE MODE ACTIVE', 180, 580);
    ctx.fillText('DISPLAY ORIENTATION: REVERSED', 180, 640);


    return new THREE.CanvasTexture(canvas);
}

function createPremiumLaptop(envMap) {
    // Reset keys array
    keyboardKeys = [];

    const glassMat = new THREE.MeshPhysicalMaterial({
        color: 0xffffff,
        metalness: 0.05,
        roughness: 0.02,
        transmission: 0.98,
        thickness: 0.8,
        ior: 1.55,
        transparent: true,
        clearcoat: 1.0,
        clearcoatRoughness: 0.01,
        envMapIntensity: 2.5
    });

    const bezelMat = new THREE.MeshPhysicalMaterial({
        color: 0x000000,
        roughness: 0.05,
        transparent: true,
        opacity: 0.96
    });

    // 1. Base
    const body = new THREE.Mesh(new THREE.BoxGeometry(4.8, 0.1, 3.2), glassMat);
    laptopGroup3D.add(body);

    // 2. Keyboard with Interaction
    const kbGroup = new THREE.Group();
    for (let i = -6; i <= 6; i++) {
        for (let j = -2; j <= 2; j++) {
            let kw = 0.24, kh = 0.24;
            let xOff = i * 0.32;
            if (j === 2 && i >= -1 && i <= 1) {
                if (i !== 0) continue;
                kw = 1.4; xOff = 0;
            }

            // Clone material for each key to handle individual color changes
            const keyMat = glassMat.clone();
            const key = new THREE.Mesh(new THREE.BoxGeometry(kw, 0.05, kh), keyMat);
            key.position.set(xOff, 0.08, j * 0.35 - 0.4);

            // Add to tracking array
            keyboardKeys.push(key);

            const glow = new THREE.Mesh(new THREE.BoxGeometry(kw * 0.8, 0.01, kh * 0.8), new THREE.MeshStandardMaterial({
                color: kbLightColor,
                transparent: true,
                opacity: 0.6,
                emissive: kbLightColor,
                emissiveIntensity: 0.5
            }));
            glow.position.set(xOff, 0.06, j * 0.35 - 0.4);
            kbGroup.add(glow, key);
            kbGlows.push(glow); // Store for color changing
        }
    }
    laptopGroup3D.add(kbGroup);

    // 3. Lid
    const lidGroup = new THREE.Group();
    lidGroup.position.set(0, 0.05, -1.6);

    const hinge = new THREE.Mesh(new THREE.CylinderGeometry(0.04, 0.04, 4.8, 32), bezelMat);
    hinge.rotation.z = Math.PI / 2;
    lidGroup.add(hinge);

    const lidBack = new THREE.Mesh(new THREE.BoxGeometry(4.8, 0.06, 3.2), glassMat);
    lidBack.position.set(0, 0, 1.6);
    lidGroup.add(lidBack);

    const bezel = new THREE.Mesh(new THREE.PlaneGeometry(4.6, 3.1), bezelMat);
    bezel.rotation.x = Math.PI / 2;
    bezel.position.set(0, -0.031, 1.6);
    lidGroup.add(bezel);

    const screenTex = createScreenTexture();
    const panel = new THREE.Mesh(new THREE.PlaneGeometry(4.4, 2.9), new THREE.MeshBasicMaterial({
        map: screenTex, transparent: true, opacity: 0.98, side: THREE.DoubleSide
    }));
    panel.rotation.x = Math.PI / 2;
    panel.position.set(0, -0.035, 1.6);
    lidGroup.add(panel);

    const topGlass = new THREE.Mesh(new THREE.PlaneGeometry(4.4, 2.9), new THREE.MeshPhysicalMaterial({
        color: 0xffffff, transmission: 0.1, roughness: 0.01, transparent: true, opacity: 0.4, ior: 1.5
    }));
    topGlass.rotation.x = Math.PI / 2;
    topGlass.position.set(0, -0.036, 1.6);
    lidGroup.add(topGlass);

    // Angle: 230 degrees
    lidGroup.rotation.x = Math.PI * (230 / 180);

    laptopGroup3D.add(lidGroup);
}

function createShadowTexture() {
    const canvas = document.createElement('canvas');
    canvas.width = 128; canvas.height = 128;
    const ctx = canvas.getContext('2d');
    const grad = ctx.createRadialGradient(64, 64, 0, 64, 64, 64);
    grad.addColorStop(0, 'rgba(0, 100, 255, 0.9)');
    grad.addColorStop(0.3, 'rgba(0, 0, 0, 1)');
    grad.addColorStop(1, 'rgba(0,0,0,0)');
    ctx.fillStyle = grad;
    ctx.fillRect(0, 0, 128, 128);
    return new THREE.CanvasTexture(canvas);
}

function onWindowResize3D() {
    if (!camera3D || !renderer3D) return;
    camera3D.aspect = window.innerWidth / window.innerHeight;
    camera3D.updateProjectionMatrix();
    renderer3D.setSize(window.innerWidth, window.innerHeight);
}

function animate3D() {
    requestAnimationFrame(animate3D);
    // Only render if visible
    if (document.getElementById('laptop-section').classList.contains('hidden')) return;

    // Raycasting for Hover
    if (raycaster && camera3D && mouse) {
        raycaster.setFromCamera(mouse, camera3D);
        const intersects = raycaster.intersectObjects(keyboardKeys);

        if (intersects.length > 0) {
            const intersectedObject = intersects[0].object;
            if (hoveredKey !== intersectedObject) {
                // Restore previous
                if (hoveredKey) hoveredKey.material.color.setHex(0xffffff);

                // Highlight new
                hoveredKey = intersectedObject;
                hoveredKey.material.color.setHex(0x00ccff); // Light Blue Hover
                document.body.style.cursor = 'pointer';
            }
        } else {
            if (hoveredKey) {
                hoveredKey.material.color.setHex(0xffffff);
                hoveredKey = null;
                document.body.style.cursor = 'default';
            }
        }
    }

    if (laptopGroup3D) {
        // Rotation
        laptopGroup3D.rotation.y += autoRotationSpeed;

        // Floating
        if (isLevitating) {
            // High amplitude, slow float
            laptopGroup3D.position.y = Math.sin(Date.now() * 0.001) * 0.5 + 0.5;
        } else {
            // Normal subtle float
            laptopGroup3D.position.y = Math.sin(Date.now() * 0.0008) * 0.05 + 0.1;
        }

        // Parts Access
        const body = laptopGroup3D.children[0];
        const kb = laptopGroup3D.children[1];
        const lid = laptopGroup3D.children[2];

        // Explode Animation Logic
        let bodyTargetY = isExploded ? -0.5 : 0;
        let kbTargetY = isExploded ? 0.3 : 0;
        let lidTargetY = isExploded ? 0.8 : 0.05;
        let lidTargetZ = isExploded ? -2.0 : -1.6;

        if (body) body.position.y += (bodyTargetY - body.position.y) * 0.1;
        if (kb) kb.position.y += (kbTargetY - kb.position.y) * 0.1;

        if (lid) {
            // Lid Position
            lid.position.y += (lidTargetY - lid.position.y) * 0.1;
            lid.position.z += (lidTargetZ - lid.position.z) * 0.1;

            // Lid Rotation
            const targetRad = Math.PI * (targetLidAngle / 180);
            lid.rotation.x += (targetRad - lid.rotation.x) * 0.05;
        }
    }
    controls3D.update();
    renderer3D.render(scene3D, camera3D);
}

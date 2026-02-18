# Storyteller Instructions

Detailed guidance for creating presentation decks.

## Research Phase

Before creating a deck, gather:

### ⚠️ CRITICAL: Source Verification (Avoid Anthropic Repos)

**The risk**: GitHub may surface `anthropics/amplifier*` repos when searching for Amplifier features. These are NOT the repos you're looking for.

**Default to the Microsoft Amplifier ecosystem** unless explicitly told otherwise:

- ✅ **Core Amplifier**: `microsoft/amplifier*` (e.g., `microsoft/amplifier-core`, `microsoft/amplifier-foundation`)
- ✅ **Team members**: `ramparte/*`, `momuno/*`, `payneio/*`, etc. (when researching team projects)
- ✅ **Personal forks**: When user specifies their own work
- ❌ **AVOID**: `anthropics/amplifier*` - different project, causes hallucinations

**Verification steps BEFORE researching:**
1. **Be explicit about org** in `gh` commands: `gh repo view microsoft/amplifier-core` (not just `amplifier-core`)
2. **Cross-reference core features** against `microsoft/amplifier` MODULES.md
3. **When in doubt**, ask the user which org/repo they mean

**Red flags that you grabbed the wrong repo:**
- References to Anthropic-internal tools or systems
- Features that conflict with what's in Microsoft Amplifier docs
- Repository URLs containing `/anthropics/` when user asked about "Amplifier"

**When user says "Amplifier feature"** → Default to `microsoft/amplifier*`  
**When user says "my project"** → Look at their repos (`ramparte/*` for this user)  
**When user names an org** → Use that org explicitly

### 1. **GitHub activity** - Use `gh` CLI to find:
   - Recent commits and PRs related to the feature
   - Timeline (when did development start/end?)
   - Number of repos touched
   - Key contributors
   
   **Example (note the explicit org scope):**
   ```bash
   gh repo view microsoft/amplifier-core
   gh pr list --repo microsoft/amplifier-core --search "feature-name"
   ```

### 2. **Feature details** - Understand:
   - What problem does it solve?
   - How does it work?
   - What's the user-facing impact?
   - Any metrics or numbers?

### 3. **Narrative angle** - Decide the story:
   - "Built with Amplifier" (showcase projects like Cortex)
   - "Amplifier Feature" (platform capabilities)
   - "Developer Experience" (tooling improvements)
   - "Enterprise Value" (compliance, cost, scale)

## Creating the Deck

### HTML Template

**IMPORTANT**: All presentations must be responsive and work across devices. See `context/responsive-design.md` for complete guidelines.

**CRITICAL - Slide Overflow Pattern**: Do NOT use `justify-content: center` on all slides. This causes content clipping on mobile. Instead:
- Slides flow from top by default (with generous top padding)
- Use `.center` class only for title slides that need vertical centering
- Always include `overflow-y: auto` on slides

Start with this structure:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
    <title>Deck Title</title>
    <style>
        /* Core slide CSS - CRITICAL for preventing content clipping */
        .slide {
            display: none;
            width: 100vw;
            min-height: 100vh;
            min-height: 100dvh;
            padding: clamp(60px, 10vw, 120px) clamp(20px, 5vw, 80px) clamp(80px, 12vw, 100px);
            flex-direction: column;
            overflow-y: auto;      /* Enable scrolling for tall content */
            overflow-x: hidden;    /* Prevent horizontal scroll */
            /* NO justify-content: center here! */
        }

        .slide.active {
            display: flex;
        }

        /* Centering is OPT-IN for title/short slides only */
        .center {
            text-align: center;
            align-items: center;
            justify-content: center;
        }

        /* Landscape mobile: reduce vertical padding */
        @media (max-height: 500px) and (orientation: landscape) {
            .slide {
                padding: 16px clamp(20px, 5vw, 80px) 60px;
            }
            .slide.center {
                justify-content: flex-start;
            }
        }

        /* Accessibility: respect reduced motion preference */
        @media (prefers-reduced-motion: reduce) {
            .slide, .slide * {
                animation: none !important;
                transition: none !important;
            }
        }

        /* More stories link - REQUIRED on all decks */
        .more-stories {
            position: fixed;
            bottom: 10px;
            left: 50%;
            transform: translateX(-50%);
            font-size: clamp(11px, 1.5vw, 12px);
            color: rgba(255,255,255,0.3);
            text-decoration: none;
            z-index: 100;
        }
        .more-stories:hover {
            color: rgba(255,255,255,0.5);
        }
    </style>
</head>
<body>
    <!-- Slides -->
    <div class="slide active">...</div>
    <div class="slide">...</div>
    
    <!-- Navigation -->
    <div class="nav" id="nav"></div>
    <div class="slide-counter" id="counter"></div>
    
    <!-- More stories link - REQUIRED -->
    <a href="index.html" class="more-stories">More Amplifier Stories</a>
    
    <script>
        /* Navigation JS - arrow keys, click, dots */
    </script>
</body>
</html>
```

### Navigation JavaScript

Always include this exact pattern for animated slide transitions with keyboard/click/dot/**touch** navigation.

**CRITICAL — Do NOT improvise a different transition approach.** This pattern
handles the inline-style vs CSS-class specificity interaction correctly.
Variations (adding `.exiting`/`.prev` classes, skipping the reflow force,
or forgetting to clean up inline styles) cause broken back-and-forth
navigation.

```javascript
const slides = document.querySelectorAll('.slide');
const total = slides.length;
let current = 0;
let transitioning = false;

function goTo(n) {
    n = ((n % total) + total) % total;
    if (transitioning || n === current) return;
    transitioning = true;
    var direction = n > current ? 1 : -1;
    var prev = slides[current];
    var next = slides[n];

    // 1. Animate previous slide out
    prev.classList.remove('active');
    prev.style.transform = direction > 0 ? 'translateX(-40px)' : 'translateX(40px)';
    prev.style.opacity = '0';

    // 2. Position next slide at entry point (disable transition first)
    next.style.transition = 'none';
    next.style.transform = direction > 0 ? 'translateX(40px)' : 'translateX(-40px)';
    next.style.opacity = '0';

    // 3. Force reflow so browser registers the starting position
    void next.offsetWidth;

    // 4. Re-enable transitions and animate to final position
    next.style.transition = '';
    next.style.transform = 'translateX(0)';
    next.style.opacity = '1';
    next.classList.add('active');

    current = n;
    updateNav();

    // 5. Clean up ALL inline styles from BOTH slides after animation
    setTimeout(function() {
        prev.style.transform = '';
        prev.style.opacity = '';
        next.style.transform = '';
        next.style.opacity = '';
        transitioning = false;
    }, 500);
}

function updateNav() {
    const nav = document.getElementById('nav');
    const counter = document.getElementById('counter');
    nav.innerHTML = '';
    slides.forEach((_, i) => {
        const dot = document.createElement('div');
        dot.className = 'nav-dot' + (i === current ? ' active' : '');
        dot.onclick = () => goTo(i);
        nav.appendChild(dot);
    });
    counter.textContent = `${current + 1} / ${total}`;
}

// Keyboard navigation
document.addEventListener('keydown', (e) => {
    if (e.key === 'ArrowRight' || e.key === ' ') goTo(current + 1);
    if (e.key === 'ArrowLeft') goTo(current - 1);
});

// Click navigation (left half = back, right half = forward)
document.addEventListener('click', (e) => {
    if (e.target.closest('.nav')) return;
    if (e.clientX > window.innerWidth / 2) goTo(current + 1);
    else goTo(current - 1);
});

// Touch/swipe navigation (REQUIRED for mobile)
let touchStartX = 0;

const SWIPE_THRESHOLD = 50;

document.addEventListener('touchstart', (e) => {
    touchStartX = e.changedTouches[0].screenX;
}, { passive: true });

document.addEventListener('touchend', (e) => {
    const diff = touchStartX - e.changedTouches[0].screenX;
    if (Math.abs(diff) > SWIPE_THRESHOLD) {
        if (diff > 0) goTo(current + 1);
        else goTo(current - 1);
    }
}, { passive: true });

updateNav();
```

### Slide Types

**Title Slide:**
```html
<div class="slide active center">
    <div class="section-label">Category</div>
    <h1 class="headline">Feature Name</h1>
    <p class="subhead">One-line description</p>
    <div class="small-text">January 2026</div>
</div>
```

**Problem Slide:**
```html
<div class="slide">
    <div class="section-label">The Problem</div>
    <h2 class="headline">Pain point headline</h2>
    <div class="thirds">
        <div class="card">...</div>
        <div class="card">...</div>
        <div class="card">...</div>
    </div>
</div>
```

**Code Example Slide:**
```html
<div class="slide">
    <div class="section-label">Usage</div>
    <h2 class="medium-headline">How to use it</h2>
    <div class="code-block">
<span class="code-comment"># Comment</span>
command --flag value
    </div>
</div>
```

**Velocity Slide:**
```html
<div class="slide center">
    <h2 class="medium-headline">Development velocity</h2>
    <div class="velocity-grid">
        <div class="velocity-stat">
            <div class="velocity-number">3</div>
            <div class="velocity-label">Repositories</div>
        </div>
        <!-- More stats -->
    </div>
</div>
```

## Quality Checklist

Before presenting to user:

- [ ] Navigation works (arrows, click, dots, **swipe on mobile**)
- [ ] Slide counter updates correctly
- [ ] No horizontal scrolling on any slide
- [ ] **No content clipping on mobile (test at 320px viewport)**
- [ ] **Slides use `overflow-y: auto` (not clipping tall content)**
- [ ] **`justify-content: center` only on `.slide.center` classes**
- [ ] Code blocks don't overflow (use `pre-wrap`)
- [ ] Consistent color scheme throughout
- [ ] Velocity slide has accurate numbers
- [ ] All links are correct
- [ ] "More Amplifier Stories" link present (links to index.html)
- [ ] **Responsive: Text readable on mobile without zooming**
- [ ] **Responsive: Grids collapse to single column on narrow screens**
- [ ] **Responsive: Touch targets ≥44px for tappable elements**

## Deployment Workflow

1. Create deck, save to `docs/`
2. Present to user for review
3. Iterate based on feedback
4. When approved: `./deploy.sh filename.html`
5. Commit changes to git

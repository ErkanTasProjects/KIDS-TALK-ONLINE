# Kids Talk Online 🦒✨

A gamified English learning mobile application designed specifically for young learners (ages 4–10), modeled after Duolingo's pedagogical and engagement principles.

---

## 🌟 Key Features

### 1. 3 Progressive Worlds & 11 Interactive Curriculum Activities
- **World 1: Starter (Ages 4–6)**
  - `Starter 1–2`: Greetings & Farewells Matching
  - `Starter 3–4`: Daily Activities Tap & Match
  - `Starter 5–6`: Letter Tracing (M, F, B, S, G)
  - `Starter 7–8`: Listen & Choose (School Objects & Actions)
- **World 2: Movers (Ages 6–8)**
  - `Movers 1–2`: Balloon Pop (Everyday Greetings)
  - `Movers 3–4`: Sentence Builder (Daily Routines)
  - `Movers 5–6`: Memory Cards (Family & Friends)
  - `Movers 7–8`: Subject Sorter (School Life & Subjects)
- **World 3: Flyers (Ages 8–10)**
  - `Flyers 1–2`: Hidden Object Adventure (Self-Introduction)
  - `Flyers 3–4`: Fill in the Blank (Habits & Hobbies)
  - `Flyers 5–6`: Speak & Record (Microphone Voice Recognition)

### 2. EdTech Retention & Engagement Layers
- **Feed & Care for Gigi:** Spend earned stars to treat Gigi to leaves, apples, ice cream, and golden cookies with cheerful chewing animations and speech.
- **Mystery Surprise Eggs:** Crack open a 3-tap wobbling egg at the end of each lesson to collect rare stickers.
- **Word Parade:** Review newly learned vocabulary through bouncing animated cards and Gigi's speech before the final celebration.
- **Zero-Frustration Scaffolding:** Smart visual cues and pulsing hints after 2 consecutive wrong attempts ensure kids stay motivated.
- **Multi-Child Profiles:** Sibling support for up to 3 individual player profiles with custom animal avatars and independent progress tracking.
- **Parent Zone & Screen-Time Limiter:** Screen-time limits (15m, 30m, Unlimited), bedtime mode with Gigi, voice clip portfolio, and printable weekly A4 worksheets (`window.print()`).

---

## 🚀 Getting Started

### Development
```bash
# Install dependencies
npm install

# Start development server
npm run dev
```

### Build for Production
```bash
# Build web distribution
npm run build

# Sync assets with native Android wrapper
npx cap sync android
```

### Android APK Build
```bash
cd android
./gradlew assembleDebug
```
The resulting APK is generated at `android/app/build/outputs/apk/debug/app-debug.apk`.

---

## 📱 Tech Stack
- **Framework:** React 18 + Vite
- **Styling:** Tailwind CSS (Duolingo 3D Chunky UI theme)
- **Native Bridge:** Capacitor Android
- **Audio & Speech:** Web Speech API + HTML5 Audio SFX
- **Animations & Effects:** Canvas Confetti + Custom Keyframe Animations

# VendorOS — Original Architectural Blueprint & Production Strategy

This is the **verbatim source brief** for VendorOS, kept in the repository so
every future change can be checked against the original intent. The
conformance table at the end records where the shipped implementation matches
the blueprint and where it deliberately deviates (and why).

---

## 1. High-Performance Mobile & Microservices Architecture

```text
                                  [ Flutter Client (Offline-First) ]
                                                   │
               ┌───────────────────────────────────┼───────────────────────────────────┐
               ▼                                   ▼                                   ▼
      [Native Platform Channels]         [State & Persistence]               [UI & Motion Core]
      ├── Android NotificationListener   ├── Riverpod State Notifiers        ├── Smooth Vector Transitions
      ├── Android Foreground Soundbox    ├── Isar Embedded NoSQL             ├── Canvas Path Micro-charts
      └── iOS Background Policy Guard    └── Background Sync Engine          └── Haptic Sensory Pipeline
                                                   │
                                                   ▼
                                       [ Live Backend & Data ]
                                       ├── Supabase Auth (SMS OTP)
                                       ├── Supabase Postgres + PostGIS
                                       ├── Realtime WebSockets
                                       └── Edge Functions (Data Pipelines)
                                                   │
                  ┌────────────────────────────────┴────────────────────────────────┐
                  ▼                                                                 ▼
      [Government & Open Data APIs]                                    [Voice & Linguistic APIs]
      ├── data.gov.in (Real Agmarknet Mandi Feeds)                      ├── Bhashini ASR/TTS Engine
      └── NPCI UPI Dynamic Link Formats                                 └── Device Hardware Neural TTS
```

### Client Stack & System Guarantees

- **Framework:** Flutter (Android SDK 34+, iOS 17+) using the Impeller
  rendering engine for 60/120 FPS transitions without shader jank.
- **State Management:** `flutter_riverpod` (code-generated `@riverpod` syntax)
  for compile-time safe, testable dependency injection and unidirectional data
  flow.
- **Offline-First Storage Engine:** `isar` (v3+ or latest stable community
  fork) for zero-cost NoSQL querying in memory, with transactional ACID
  guarantees.
- **Network & Replication:** `dio` with retry/offline interceptors coupled with
  Supabase Realtime WebSockets for bidirectional live-state synchronization.
- **Code Modularity:** Strict feature-first architecture
  (`lib/src/features/[feature_name]/{data,domain,presentation,application}`).

---

## 2. Live Data Integrations (Zero-Mock Strategy)

```text
[ Real-Time Data Pipeline Strategy ]

1. Wholesale Mandi Pricing:
   data.gov.in (OGD India API) ──> Supabase Edge Function (Cron) ──> PostGIS Cluster Cache ──> App

2. Digital Payment Capture:
   Android NotificationListener ──> Regex Verification Engine ──> Isar DB (Local) ──> Realtime Sync

3. Colloquial Voice Intake:
   Microphone Stream (PCM 16kHz) ──> AI4Bharat / Bhashini API ──> JSON Entity Extractor ──> Local Ledger

4. Micro-Credit Proof Generation:
   Isar Transaction Aggregator ──> PDF Canvas Renderer ──> SHA-256 Checksum Signature ──> Signed A4 PDF
```

- **Wholesale Commodity Feeds:** live APMC market rates from the official
  data.gov.in OGD Platform API (Tamil Nadu: Koyambedu, Madurai Mattuthavani,
  Trichy Gandhi Market). A 4:00 AM IST Supabase Edge Function parses and
  normalizes modal prices per kilogram.
- **Payment Readout Pipeline:** intercept OS-level notification streams via
  Android `NotificationListenerService` from certified NPCI handles:
  - PhonePe (`com.phonepe.app`)
  - Paytm (`net.one97.paytm`)
  - Google Pay (`com.google.android.apps.nbu.paisa.user`)
  - BHIM (`in.org.npci.upiapp`)
- **Voice Speech-to-Text:** AI4Bharat / Bhashini ASR pipeline
  (`bhashini.gov.in`), models tuned for colloquial Tamil and Indian English.
- **Customer Udhaar Ledger Links:** UPI deep links
  (`upi://pay?pa={vpa}&pn={name}&am={amount}&cu=INR`) delivered via WhatsApp
  URL schemes.

---

## 3. UI/UX, Motion Design & Accessibility Standards

### Motion Choreography Specs

- **Micro-Interactions:** physics-based springs (stiffness 180, damping 20)
  via `AnimationController` and `Curve`. Avoid linear interpolation.
- **Hero Page Transitions:** shared-axis and container-transform animations
  (Material Motion) between stall dashboards and ledger lists.
- **Dynamic Auditory & Sensory Feedback:** coordinated haptic pulses
  (`HapticFeedback.mediumImpact()`) on every voice log confirmation and
  soundbox trigger.
- **Data Visualization Transitions:** animated counting numbers
  (`Tween<double>` driving animated text counters) for balances and gauges.

### Accessibility & Field Readability

- **High-Ambient Outdoor Visibility:** contrast ratios surpassing WCAG AAA
  (7:1) for direct midday sunlight.
- **Oversized Tactile Tap Targets:** minimum 56×56 dp on all primary actions.
- **Vernacular Typography Hierarchy:** variable-weight Tamil fonts (Noto Sans
  Tamil or Tiro Tamil) with open counters to prevent letter blending.
- **Dynamic Audio State Readout:** `Semantics` annotations wrapping all
  transactional summaries for visually impaired and low-literacy operators.

---

## 4. Enterprise Quality, Reliability & Maintainability Matrix

| Aspect | Engineering Standard | Implementation Method |
| --- | --- | --- |
| Code Architecture | Feature-First Clean Architecture | Data Sources ➔ Repositories ➔ Use Cases ➔ Riverpod Notifiers ➔ UI Components |
| Type Safety & Reliability | Zero-Dynamic Typing Policy | `freezed` and `json_serializable` immutable, validated models |
| Performance Overhead | Sub-16ms Frame Budgets | Localized rebuilds via `ref.watch(provider.select(...))`; zero heap allocation in `build()` |
| Battery Life Optimization | Native Power-Aware Geo | Geofencing, GPS throttled to 45 s / 30 m; sleep location services when stationary |
| Automated Testing | 3-Tier Verification | Unit tests for financial calculations, golden UI tests for vernacular rendering, integration tests for sync |

---

## 5. Consolidated Master AI Prompt

```markdown
Role: Lead Mobile Systems Architect & Flutter Core Engineer
Target Environment: Production-Ready Flutter Application (Targeting Android 14+ & iOS 17+)
Project Name: VendorOS (Street Vendor & Local Stall Operating System)

Objective:
Architect and generate a production-ready, highly animated, modular, offline-first mobile application tailored for Indian street vendors (specifically Tamil Nadu local stalls and pushcarts), ready for Pan-India scaling. Do NOT generate mock or placeholder data; wire real data pipelines and native service channels from day one.

1. Technical Stack & Architecture:
- Architecture: Feature-first Clean Architecture (lib/src/features/{auth,ledger,soundbox,discovery,reports}/{data,domain,presentation,application}).
- State Management: Riverpod with code generation (@riverpod) and immutable states using Freezed.
- Persistence: Isar NoSQL (offline-first local-first architecture with transactional rollback capability).
- Backend: Supabase (Auth via phone OTP, PostgreSQL + PostGIS for spatial queries, and Edge Functions).
- Native Interop: Android Native Kotlin NotificationListenerService communicating via EventChannels.

2. Motion & Design System Requirements:
- Physics-driven spring animations (stiffness: 180, damping: 20) for all interactions, cards, and state shifts.
- Dynamic animated digit counters on financial balances using TweenAnimationBuilder.
- High-contrast outdoor-optimized theme complying with WCAG AAA (7:1 contrast) utilizing Noto Sans Tamil typography.
- Oversized minimum 56x56 dp tap targets across all interactive elements with sensory haptic feedback.

3. Core Feature Requirements (Real Data Only):
- Live Soft Soundbox: Implement the Android NotificationListenerService parsing incoming UPI transactions (PhonePe, Paytm, Google Pay, BHIM). Expose an EventChannel to Flutter that triggers native Tamil speech output via flutter_tts ("ரூபாய் [Amount] பெறப்பட்டது"). Provide an iOS-specific runtime check with a graceful restriction banner explaining Apple's background sandbox limitation.
- Zero-Typing Voice Ledger: Microphone input processing colloquial Tanglish/Tamil commands into structured records (Amount, Mode [Cash/UPI/Credit], Items) using an offline-resilient architecture.
- Live Cart GPS Broadcaster: Low-power background geolocation tracker throttling updates every 45 seconds/30 meters to Supabase PostGIS, with a single tap to generate a valid WhatsApp broadcast message containing a web-viewable location URL.
- Business Loan Sales Proof ("வியாபாரக் கடன் அறிக்கை"): Production PDF generation module using the `pdf` package, consolidating historical daily turnover, digital/cash collection ratios, and generating a tamper-proof SHA-256 verification hash on the footer. No central scheme names.
- Wholesale Mandi Pricing Feed: Direct API pipeline schema pulling commodities from data.gov.in (OGD India API) with a local Isar cache falling back to the most recent synchronization timestamp.

4. Coding Standards:
- Zero use of `dynamic` or `var` types without static bounds.
- All network and platform errors must map to strongly-typed DomainFailures.
- Ensure 60/120 FPS performance with zero dropped frames on low-tier Android devices (Impeller-optimized).
```

---

## 6. Recommended Skills, Repositories & Reference Implementations

### Core Technical Competencies

- **Dart & Flutter Systems:** isolate memory sharing, `MethodChannel`,
  `EventChannel`, custom `RenderObject`s for complex animation.
- **Android Native OS Interfacing:** `NotificationListenerService`,
  `WakeLockProvider`, audio stream priority switching (`STREAM_MUSIC`).
- **Spatial SQL & Performance:** efficient PostGIS queries (`ST_DWithin`,
  `ST_Point`) for high-volume geofencing at low compute cost.

### Benchmark Repositories & References

- Notification parsing & native channels — MaikuB/flutter_local_notifications
- Local-first database & sync — isar/isar, powersync-ja/powersync-dart
- Government open data — data.gov.in Developer APIs portal (APMC mandi schemas)
- Vernacular voice AI — AI4Bharat Indic models, Bhashini API specifications

---

## 7. Neumorphic Depth & Lighting Physics

```text
                  Light Vector: [-4, -4] @ 135° (Soft Sunlight)
                              ╲
    ┌──────────────────────────╲──────────────────────────┐  <-- Canvas: #E3E7EE
    │                           ▼                         │
    │      ╭───────────────────────────────────────╮      │
    │      │ Highlight: #FFFFFF (0.90)             │      │  <-- Extruded Surface: #EDF1F7
    │      │                                       │      │      (Slightly elevated, lighter tint)
    │      │         [ ₹ 1,450.00 ]                │      │
    │      │                                       │      │
    │      │ Shadow: #BAC5D5 (0.65)                │      │
    │      ╰───────────────────────────────────────╯      │
    │                           ▲                         │
    │      ╭────────────────────│──────────────────╮      │
    │      │ Shadow: #BAC5D5 (Inner, Top-Left)     │      │  <-- Inset/Recessed Well: #DDE2EC
    │      │                                       │      │      (Pressed state / Input fields)
    │      │      [ 🎙 பேசி பதியவும் ]              │      │
    │      │ Highlight: #FFFFFF (Inner, Btm-Right) │      │
    │      ╰───────────────────────────────────────╯      │
    └─────────────────────────────────────────────────────┘
```

### Palette Tiers (Dynamic Contrast Separation)

- **Base Canvas** `#E3E7EE` — cool, low-saturation slate grey, atmospheric depth.
- **Extruded Surface** `#EDF1F7` — lifted cards and primary stats, 1.5 tones lighter.
- **Inset Well** `#DDE2EC` — inputs, depressed toggles, listening states, 1 tone deeper.
- **Ambient Light Flare** — top-left vector (−4px, −4px), 8–12px blur.
- **Ambient Occlusion Shadow** — bottom-right vector (4px, 4px), 10–14px blur.
- **Accent High-Contrast Ink** — deep navy-charcoal for WCAG AAA clarity.
- **Feedback Primary** — sparing illuminated internal glow / LED dot for active
  recording and connectivity states.

### Neumorphic Motion & State Transitions

- **Extruded → Inset:** animate drop shadows to inner shadows over 150 ms with
  `Curves.easeOutQuad` on tap.
- **Tactile Spring Deflection:** compress to 0.98× on depress with immediate
  `HapticFeedback.selectionClick()`.
- **Soft Breathing Glows:** the active listening state breathes via an animated
  pulse on the inner highlight radius, not a colour shift.

---

## 8. Conformance & Deviations (shipped implementation)

| Blueprint item | Status | Notes |
| --- | --- | --- |
| Flutter, Impeller, Android 14+ target | Implemented | Real Flutter app; release APK built |
| Feature-first modules | Implemented | `lib/features/<feature>/{domain,application,presentation}` (flat `lib/features`, not `lib/src/features`) |
| Riverpod state | Implemented | Hand-written `Notifier`s — **no `@riverpod` codegen / Freezed**, to keep builds hermetic in this environment |
| Isar persistence | **Deviation** | `shared_preferences` JSON store (`core/storage/local_store.dart`) — Isar has no web target and needs native codegen; storage is behind one interface so Isar can replace it |
| Supabase auth / PostGIS / Realtime / Edge cron | **Not in this pass** | App is fully offline-first local; cloud sync is a planned later phase |
| `dio` + interceptors | Deviation | `http` with explicit error mapping; no retry interceptor layer yet |
| data.gov.in mandi feed | Implemented | Direct client call to resource `9ef84268-…`, TN market filter, quintal→kg normalisation, local cache + last-synced timestamp, honest "API key required" state (no Edge cron) |
| Android NotificationListenerService soundbox | Implemented | Kotlin service + `EventChannel`, UPI package filter, Tamil TTS via `flutter_tts` |
| iOS / web restriction banner | Implemented | Graceful unavailable panel instead of fake behaviour |
| Voice ledger (Tanglish/Tamil) | Implemented via device ASR | `speech_to_text` + local entity parser; **Bhashini API not wired** (needs credentials) |
| GPS broadcast 45 s / 30 m | Implemented | `geolocator` distance filter 30 m, 45 s emission throttle, WhatsApp maps link |
| Loan-proof PDF + SHA-256 | Implemented | A4 report, cash/UPI/credit split, checksum footer, no scheme names |
| UPI deep links + WhatsApp | Implemented | NPCI format, unit-tested |
| Neumorphic palette & motion | Implemented | Tokens in `core/theme/neu_theme.dart`, extruded/inset press transition, breathing listening glow |
| Animated financial counters | Implemented | Tween-driven counters on balances |
| 56dp targets, Noto Sans Tamil, AAA ink | Implemented | Bundled font asset; formal contrast audit still open |
| `Semantics` on all summaries | **Open** | Tracked in `roadmap.md` |
| Golden + integration tests | **Open** | 22 unit tests today (parsing, routing, links, report maths) |
| Zero `dynamic`/`var` unbounded, typed failures | Partial | Analyzer clean; a typed `DomainFailure` hierarchy is not yet universal |

Open items above are tracked in [PRODUCTION_CHECKLIST.md](./PRODUCTION_CHECKLIST.md)
and [../roadmap.md](../roadmap.md).

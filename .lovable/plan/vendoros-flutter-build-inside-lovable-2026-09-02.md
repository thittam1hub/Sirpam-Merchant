# VendorOS — Flutter build inside Lovable

## What we're building

VendorOS as a **real Flutter app** (not a React web app), following the exact pattern already proven in your "Lovable Inventory AI" project: the Lovable project's preview/build is driven by custom Node scripts that compile the Flutter web bundle and serve it on the preview port, while `bash scripts/build-apk.sh` produces a real Android APK with the native features (UPI soundbox via NotificationListenerService, Tamil TTS).

## Phase 1 — Scaffold (copied from Lovable Inventory AI)

- Copy the whole working toolchain scaffold from the reference project, adapted for VendorOS:
  - `scripts/` — `toolchain.sh` (nix/vendor-tarball JDK 17 + Flutter SDK provisioning), `dev-server.mjs`, `build-web.sh`, `build.mjs`, `publish-web.mjs`, `watch-web.mjs`, `source-hash.mjs`, `preview-overlay.mjs`, `page.mjs`, `smoke_web.py`, `setup-android-sdk.sh`, `build-apk.sh`
  - `package.json` scripts wired the same way (`dev` → Flutter web dev host, `build` → dist publish), renamed to vendoros
  - `analysis_options.yaml`, `web/` (index.html, manifest, icons), `android/` shell skeleton
- Replace the current TanStack template content (routes, styles) that would conflict; keep `.lovable/project.json` untouched.
- `pubspec.yaml` for VendorOS with: flutter_riverpod (no codegen, same as reference for hermetic builds), go_router, google_fonts (Noto Sans Tamil), intl, http, shared_preferences, connectivity_plus, geolocator, url_launcher, flutter_tts, speech_to_text, pdf + crypto (SHA-256), share_plus.

## Phase 2 — Feature-first app structure

```
lib/
  main.dart
  app/            router.dart, shell.dart
  core/           theme (neumorphic system), widgets, storage, network, errors
  features/
    ledger/       zero-typing sales ledger (voice + quick-tap entry)
    udhaar/       customer credit tracking + UPI deep links + WhatsApp share
    soundbox/     UPI payment announcements
    mandi/        live APMC wholesale prices
    report/       "வியாபாரக் கடன் அறிக்கை" PDF loan-proof generator
    location/     cart GPS broadcast + shareable link
```

Each feature follows data → domain → application (Riverpod notifiers) → presentation, matching the reference project's layout.

## Phase 3 — Core features (real data, no mocks)

1. **Sales ledger** — Tamil/Tanglish voice entry via `speech_to_text` with a numeric/entity parser (amount, mode: Cash/UPI/Credit, item) plus a large-button manual fallback. Persisted locally (shared_preferences JSON store with transactional append), animated ₹ counters.
2. **Udhaar ledger** — per-customer credit balances, one-tap UPI deep link (`upi://pay?pa=…&am=…`) and WhatsApp reminder message via `url_launcher`.
3. **Soundbox** — Android APK only: Kotlin `NotificationListenerService` parsing PhonePe/Paytm/GPay/BHIM notifications, EventChannel to Flutter, Tamil TTS announcement ("ரூபாய் X பெறப்பட்டது"). Web preview shows a graceful "install the Android app" panel (iOS gets the same restriction notice).
4. **Mandi prices** — `http` fetch of data.gov.in OGD APMC feed for TN markets (Koyambedu, Mattuthavani, Gandhi Market), cached locally with last-synced timestamp. Note: the data.gov.in API needs a free API key — I'll wire the pipeline and you'll paste the key into settings; until then it shows an honest "key required" state, never fake prices.
5. **Loan-proof PDF** — `pdf` package generating an A4 turnover report (daily totals, cash/digital split) with a SHA-256 checksum footer, downloadable/shareable.
6. **GPS broadcast** — geolocator position (throttled), one tap builds a WhatsApp message with a maps link.

## Phase 4 — Design system

Neumorphic per your spec: canvas `#E3E7EE`, extruded surfaces `#EDF1F7`, inset wells `#DDE2EC`, dual light/shadow vectors (highlight top-left, shadow bottom-right), extruded→inset press transitions at 150ms, breathing glow on the listening state, deep navy-charcoal AAA-contrast ink, Noto Sans Tamil typography, 56dp+ tap targets, haptics on confirmations.

## Phase 5 — Build & verify

- Provision toolchain, `flutter pub get`, build the web bundle, publish into `web_build/`, smoke-test with Playwright/screenshots.
- Attempt the Android APK build (`scripts/build-apk.sh`) so the soundbox/TTS features land in a real installable file.

## Notes / constraints

- The browser preview cannot listen to payment notifications or do native TTS — those are APK-only by OS design; the web build gets clear fallback UI.
- Lovable Cloud (auth/sync backend) is **not** included in this pass — the app is offline-first local storage, with the architecture ready to add cloud sync later if you want it.

# Production checklist

The release gate. `[x]` only when verified by a command or a screenshot, not
by reading code. Update on every change.

## A. Architecture & code quality
- [x] Feature-first modules with `domain / application / presentation` layers
- [x] Routing centralised in `lib/app/routes.dart`; no hand-built URLs
- [x] Money handled as integer paise end to end
- [x] Persistence isolated behind `LocalStore`
- [x] Design tokens centralised; no ad-hoc colours in feature widgets
- [x] `flutter analyze` reports zero issues (lints + deprecations cleared)

## B. Features (see IMPLEMENTATION.md for criteria)
- [x] Sales ledger: voice + quick entry, persistence, delete
- [x] Udhaar: balances, UPI request, WhatsApp reminder, repayment
- [x] Soundbox: Android listener, Tamil TTS, permission flow, honest fallbacks
- [x] Mandi: real data.gov.in feed, key-required state, cache + age label
- [x] Report: 30/60/90 window, PDF, SHA-256 checksum, share
- [x] Location: permission handling, throttled updates, maps share
- [x] Settings: stall, VPA, phone, API key, market, soundbox toggle

## C. Navigation
- [x] `/` redirects to `/home`; not-found page with a home action
- [x] Query params drive report window, udhaar customer, mandi market/search, location share
- [x] Detail routes pushed (real back stack); state changes use `replace`
- [x] `AppBackButton.popOrGo` + `PopScope` handle cold deep-link entry
- [x] Android intent filters: `vendoros://app/...` and `https://vendoros.app`
- [ ] `assetlinks.json` hosted on the production domain (App Links verification)

## D. Reliability & offline
- [x] All reads work offline from local storage
- [x] Mandi cache renders with a last-synced age when the network is down
- [x] Tolerant JSON readers verified against a truncated/legacy document
- [x] Storage write failure surfaces a user-visible error instead of silent loss

## E. Accessibility & UX
- [x] Tamil-first copy, Noto Sans Tamil bundled
- [x] 56dp+ tap targets, haptics on confirmation
- [x] Semantics labels on icon-only controls (screen-reader pass)
- [ ] Contrast audit of ink/inkSoft on canvas and well surfaces (AAA)
- [ ] Layout verified at 320 dp width and at 2.0 text scale

## F. Testing
- [x] Unit tests: voice parser, routes/query parsing, share links, report aggregation, tolerant storage reads (30 tests green)
- [x] Widget tests: soundbox unavailable, mandi key-required, empty ledger
- [x] Headless smoke test of the built web bundle

## G. Build & release
- [x] Reproducible web build + publish pipeline
- [x] Release APK builds with native soundbox, mic, GPS
- [ ] APK signed with a real upload keystore (currently the debug key)
- [ ] Version bumped in `pubspec.yaml` for the release
- [ ] Release notes / install instructions for vendors

## H. Privacy & security
- [x] No third-party analytics; ledger data never leaves the device
- [x] Mandi API key stored locally, never bundled, never logged
- [ ] Privacy policy page (required by Play for notification-listener access)
- [ ] Play Data-safety declaration covering location, microphone, notifications

## I. Documentation
- [x] Architecture, implementation spec, reference, runbook
- [x] This checklist kept in sync with reality

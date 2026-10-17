# Architecture

## Stack

| Concern | Choice |
| --- | --- |
| UI | Flutter (Material 3 base, custom neumorphic system) |
| State | Riverpod 2 (`Notifier` / `AsyncNotifier`, no codegen — keeps builds hermetic) |
| Routing | go_router with a `StatefulShellRoute.indexedStack` |
| Persistence | `shared_preferences` JSON document store (`LocalStore`) |
| Native | Kotlin `NotificationListenerService` + Method/Event channels |
| Targets | Android APK (full feature set), Flutter web (preview + fallback UI) |

## Module layout

```
lib/
  main.dart                     bootstrap: LocalStore.init -> ProviderScope -> MaterialApp.router
  app/
    routes.dart                 AppPaths / AppQuery / AppRoutes / AppQueryParsing
    router.dart                 GoRouter table, redirects, not-found page
    shell.dart                  bottom navigation + "More" sheet
  core/
    theme/neu_theme.dart        palette, elevation vectors, typography
    widgets/neu.dart            NeuBox, NeuButton, primitives
    widgets/app_back_button.dart AppBackButton.popOrGo, DetailScaffold
    storage/local_store.dart    the only place that touches shared_preferences
    settings/settings_controller.dart
    network/share_links.dart    UPI + WhatsApp deep-link builders
  features/<feature>/
    domain/                     pure Dart models + parsers (no Flutter imports)
    application/                Riverpod controllers, side effects, platform channels
    presentation/               widgets only; no business rules
```

### Dependency direction

`presentation -> application -> domain`, and everything may use `core`.
Nothing in `domain` imports Flutter; that is what makes it unit-testable
without a widget binding. A feature never imports another feature's
`presentation`; cross-feature reads go through the shared providers
(`ledgerProvider`, `settingsProvider`).

## State

- `ledgerProvider` (`NotifierProvider<LedgerController, LedgerState>`) owns
  sales and repayments; derived values (`todayPaise`, `udhaarBalances`,
  `totalUdhaarPaise`) are computed getters, never duplicated state.
- `settingsProvider` owns stall identity, VPA, phone, mandi API key, default
  market and soundbox toggle.
- `mandiProvider` is an `AsyncNotifier` — loading / data / error are modelled,
  not faked with booleans.
- `localStoreProvider` is deliberately `throw UnimplementedError` and is
  overridden in `main()`; that keeps tests able to inject a fake store.

**Money is stored as integer paise everywhere.** Doubles are only produced at
the render edge (`Sale.rupees`). Never persist or sum floating point currency.

## Data flow (write path)

```
voice / quick-tap  ->  VoiceParser (domain, pure)
                   ->  LedgerController.addSale (application)
                   ->  state update (optimistic, synchronous)
                   ->  LocalStore.writeSales (await, JSON)
```

The UI reads the new state immediately; persistence is awaited afterwards so a
slow disk never blocks the counter animation. `LocalStore` rewrites the whole
document per mutation — acceptable at street-vendor volumes (thousands of rows)
and far simpler to reason about than partial appends.

## Platform boundaries

| Capability | Android APK | Web preview | iOS |
| --- | --- | --- | --- |
| Ledger, udhaar, report, settings | yes | yes | yes |
| Mandi prices | yes | yes | yes |
| Voice entry | yes (`speech_to_text`) | browser SpeechRecognition | yes |
| GPS broadcast | yes | browser geolocation | yes |
| UPI soundbox | yes | **not possible** | **not possible** |

The soundbox is OS-gated: only Android exposes `NotificationListenerService`.
Web and iOS render an explicit "install the Android app" panel — never a
simulated announcement.

## Navigation

Four shell branches keep their own navigator stacks: Home, Udhaar, Soundbox,
Mandi. Report, Location and Settings are root-level routes pushed above the
shell, so they get a real back stack and a full-width `DetailScaffold`.

- `context.push` for entering a detail screen (adds history).
- `context.replace` for URL-state changes such as the report window or mandi
  market (shareable URL, no history pollution).
- `AppBackButton.popOrGo()` pops when `router.canPop()`, otherwise goes home —
  which is what a cold deep-link start needs.

## Testing strategy

- **Unit** — everything in `domain/` and the pure helpers (`voice_parser`,
  `routes`, `share_links`, `loan_report` aggregation). These carry the money
  and parsing rules, so they carry the tests.
- **Widget** — screens that own conditional states (soundbox availability,
  mandi key-required, empty ledger).
- **Smoke** — `scripts/smoke_web.py` boots the built bundle in headless
  Chromium and fails on console errors.

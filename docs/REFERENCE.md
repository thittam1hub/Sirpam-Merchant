# Reference

## Routes and deep links

Single source of truth: `lib/app/routes.dart`. Never hand-concatenate a URL.

| Path | Query | Builder |
| --- | --- | --- |
| `/home` | — | `AppRoutes.home()` |
| `/udhaar` | `customer` | `AppRoutes.udhaar(customer: 'Ravi')` |
| `/soundbox` | — | `AppRoutes.soundbox()` |
| `/mandi` | `market`, `q` | `AppRoutes.mandi(market: 'Koyambedu', search: 'தக்காளி')` |
| `/report` | `window` ∈ 30/60/90 | `AppRoutes.report(windowDays: 30)` |
| `/location` | `share=1` | `AppRoutes.location(share: true)` |
| `/settings` | — | `AppRoutes.settings()` |

`/` redirects to `/home`. Unknown paths render the Tamil not-found page with a
home action.

External forms (Android manifest intent filters):
- `vendoros://app/mandi?market=Koyambedu`
- `https://vendoros.app/udhaar?customer=Ravi` (App Links, `autoVerify=true` —
  requires `/.well-known/assetlinks.json` on the domain before verification
  succeeds in production)

Query parsing is defensive: `AppQueryParsing.reportWindow` whitelists, `.text`
caps length at 64 chars, `.flag` accepts only `1`/`true`.

## Platform channels

| Channel | Type | Methods / payload |
| --- | --- | --- |
| `vendoros/soundbox` | Method | `isPermissionGranted() -> bool`, `openSettings() -> void` |
| `vendoros/soundbox/events` | Event | `{package: String, title: String, text: String}` |

Kotlin sources: `android/app/src/main/kotlin/com/vendoros/app/MainActivity.kt`,
`UpiNotificationListener.kt`. Application id / namespace: `com.vendoros.app`.

## External APIs

**data.gov.in — Variety-wise Daily Market Prices**
```
GET https://api.data.gov.in/resource/9ef84268-d588-465a-a308-a864a43d0070
    ?api-key=<vendor key>&format=json&limit=200
    &filters[state]=Tamil%20Nadu&filters[market]=<market>
```
Key is user-supplied (free at data.gov.in), stored locally, never bundled and
never logged. Prices are per quintal → divide by 100 for ₹/kg.

**UPI (NPCI deep link)** `upi://pay?pa=&pn=&am=&cu=INR&tn=` — amount in rupees
with two decimals; all components URL-encoded.

**WhatsApp** `https://wa.me/<91 + 10-digit>?text=<encoded>`.

## Storage keys (`LocalStore`)

| Key | Shape |
| --- | --- |
| `vendoros.sales` | JSON array of `{id, ts, paise, mode, item, customer}` |
| `vendoros.repayments` | JSON array of `{id, ts, customer, paise}` |
| `vendoros.settings` | JSON object (stall, owner, vpa, phone, apiKey, market, soundbox) |
| `vendoros.mandi.cache` | `{fetchedAt, market, rows[]}` |

Schema changes must be additive with a tolerant reader (`?? default`), because
there is no migration runner.

## Android permissions

`INTERNET`, `ACCESS_FINE_LOCATION`, `ACCESS_COARSE_LOCATION`, `RECORD_AUDIO`,
`BIND_NOTIFICATION_LISTENER_SERVICE` (service), plus `<queries>` package
visibility for the UPI apps and WhatsApp.

## Design tokens (`core/theme/neu_theme.dart`)

| Token | Value |
| --- | --- |
| canvas | `#E3E7EE` |
| surface (extruded) | `#EDF1F7` |
| well (inset) | `#DDE2EC` |
| ink | deep navy-charcoal |
| inkSoft | secondary text |
| accent / warn | action + alert |
| press transition | 150 ms extruded → inset |
| min tap target | 56 dp |

## Commands

| Command | Effect |
| --- | --- |
| `npm run dev` | serves `web_build/` on :8080 (the Lovable preview) |
| `npm run build:web` | pub get → analyze → release web build → smoke → publish |
| `BUILD_MODE=fast npm run build:web` | incremental, skips analyze + smoke |
| `npm run build:apk` | provisions Android SDK and builds the release APK |
| `flutter test` | unit + widget suite |

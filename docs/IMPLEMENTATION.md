# Implementation specification

Every feature below lists its rules, its states and the acceptance criteria a
build must satisfy. "Honest state" means: real data, or a labelled empty /
error / unavailable state. Never a placeholder number.

---

## 1. Sales ledger (`features/ledger`)

**Goal:** a sale is recorded in under three seconds without typing.

Rules
- Amount is stored as `amountPaise` (int). Rupee display is `paise / 100`.
- `SaleMode` ∈ `cash | upi | credit`. Credit sales require a customer name;
  absent names fall back to `Walk-in`.
- `todaySales` compares calendar day in local time, not a 24-hour window.
- New sales are prepended; the list is kept sorted by `ts` descending.

Voice entry (`domain/voice_parser.dart`)
- Accepts Tamil, Tanglish and English utterances.
- Extracts: amount (digits, decimals, thousands separators, and spoken
  multipliers), mode keywords (`ரொக்கம்/cash`, `யுபிஐ/upi/gpay/phonepe`,
  `கடன்/udhaar/credit`), optional item and customer.
- Ambiguous or amount-less input returns a failure the UI surfaces as a
  retry prompt — it must never guess an amount.

States: empty ledger, listening (breathing glow), parsed-confirm, saved
(haptic + animated counter), mic-permission-denied, unsupported-browser.

Acceptance
- [ ] Recording, confirming and deleting a sale survives an app restart.
- [ ] Totals recompute from the store, never from a cached number.
- [ ] Parser unit tests cover amount, mode, customer and failure cases.

---

## 2. Udhaar / credit (`features/udhaar`)

Rules
- `balance(customer) = Σ credit sales − Σ repayments`; non-positive balances
  are dropped from the list.
- Repayments are their own record type; a repayment never mutates a sale.
- Payment request opens `upi://pay?pa=<vpa>&pn=<name>&am=<rupees>&cu=INR&tn=…`
  built only by `core/network/share_links.dart`.
- Reminder opens `https://wa.me/<91XXXXXXXXXX>?text=<encoded>`; Indian numbers
  are normalised (strip spaces/`+`/leading 0, prefix `91`).
- Settling a customer requires a confirmation step; partial repayment allowed.

States: no credit outstanding, list, single-customer filter (`?customer=`),
missing-VPA (prompts Settings instead of opening a broken UPI link).

Acceptance
- [ ] `?customer=Ravi` opens filtered with a removable chip.
- [ ] With no VPA configured the UPI button routes to Settings, not a dead link.

---

## 3. UPI soundbox (`features/soundbox`, Android only)

Pipeline
```
UpiNotificationListener (Kotlin)  -- EventChannel vendoros/soundbox/events -->
SoundboxService (Dart): filter package -> parse credited amount -> flutter_tts
```
Rules
- Only these packages are considered: PhonePe, Paytm, Google Pay, BHIM, and the
  major bank UPI apps listed in `soundbox_service.dart`.
- Debit / request / reminder notifications are ignored; only credits announce.
- Duplicate suppression: identical (package, amount) within 60 s speaks once.
- Announcement is Tamil: "ரூபாய் <amount> பெறப்பட்டது".
- Permission is checked through `MethodChannel('vendoros/soundbox')
  .isPermissionGranted`; `openSettings` deep-links to Android notification
  access.

States: granted+listening, permission-required, disabled-in-settings,
web-unavailable, ios-unavailable, recent-credits list, test-announcement.

Acceptance
- [ ] Web build shows the unavailable panel and never claims to listen.
- [ ] Revoking notification access flips the UI back to permission-required.

---

## 4. Mandi prices (`features/mandi`)

Rules
- Source: data.gov.in OGD resource `9ef84268-d588-465a-a308-a864a43d0070`.
- Requires the vendor's own free API key, entered in Settings. Without it the
  screen shows a key-required state with a link — **never sample prices**.
- Filter: state = Tamil Nadu, market = selected (Koyambedu, Mattuthavani,
  Gandhi Market, …).
- Prices arrive per quintal and are normalised to ₹/kg (`÷ 100`).
- Successful responses are cached with a fetched-at timestamp; offline loads
  render the cache with a "last synced" line.

States: key-required, loading, data (+cache age), empty-for-market, network
error with retry.

Acceptance
- [ ] Airplane-mode load renders cached rows with an accurate age label.
- [ ] Market and search are reflected in the URL (`?market=&q=`).

---

## 5. Loan-proof report (`features/report`)

Rules
- Window ∈ {30, 60, 90} days, validated by `AppQueryParsing.reportWindow`.
- Aggregates per-day totals plus cash / UPI / credit splits from the ledger.
- A4 PDF via `pdf`; Tamil heading with a Latin fallback if the font is absent.
- Footer carries a SHA-256 checksum computed over exactly the printed figures,
  so a lender can verify the document was not edited.
- Share / print through `printing` + `share_plus`.

Acceptance
- [ ] Empty ledger produces a valid zero-total PDF, not a crash.
- [ ] Changing the window uses `replace` and keeps the URL shareable.

---

## 6. Cart location broadcast (`features/location`)

Rules
- Requests permission explicitly; denial is a state, not an exception.
- 30 m distance filter and a 45 s minimum emission interval (battery).
- Share builds a WhatsApp message with a `https://maps.google.com/?q=lat,lng`
  link.
- `/location?share=1` starts broadcasting after the first frame.

Acceptance
- [ ] Permanently-denied permission shows the settings path, no silent failure.

---

## 7. Settings (`core/settings`)

Stall name, owner name, UPI VPA (validated `name@handle`), phone, mandi API
key (never logged), default market, soundbox toggle. All persisted through
`LocalStore`; changes are visible to dependent screens immediately.

---

## 8. Design system

Canvas `#E3E7EE`, extruded surface `#EDF1F7`, inset well `#DDE2EC`; highlight
top-left, shadow bottom-right; press transition extruded→inset at 150 ms;
breathing glow while listening; deep navy-charcoal ink for AAA contrast;
Noto Sans Tamil; 56dp minimum tap target; haptics on every confirmation.

Non-negotiable: no hardcoded one-off colours in feature widgets — read
`NeuColors` / `NeuTheme`.

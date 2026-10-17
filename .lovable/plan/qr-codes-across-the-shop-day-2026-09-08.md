# QR codes across the shop day

A single, consistent QR system for a Tamil Nadu shop — every code stays on the page it belongs to (no new hub), works offline, and can be printed on A4 or on the thermal bill roll.

## The business scenario

Morning: owner opens, tapes table cards and the counter payment poster (printed once). Staff arrive and a new waiter phone is paired by scanning the pairing QR on the owner's screen instead of typing a code.

Rush: customer at table 4 scans the table card, orders from the menu; counter customer scans the payment QR; a packed item is scanned from its printed product label to add it to the bill.

Evening: bill prints with a small QR at the bottom — pay-by-UPI for the exact amount, and a feedback QR. Loyalty/offer cards handed out carry an offer QR the customer scans to claim.

## Where QR codes appear

| Where | Code holds | Printed as |
|---|---|---|
| Payments settings / counter | UPI collect (static or amount) | A4 poster (exists) |
| Ordering settings | Menu link per table + counter | A4 table card sheet (exists) |
| Bill / receipt | UPI pay for exact bill amount + feedback link | Thermal slip QR (new) |
| Feedback page | Feedback link | A4 counter card (new) |
| Products / labels | Product code | Label sheet (exists) + scan-to-bill (new) |
| Offers page | Offer claim link | A4 card sheet (new) |
| Phones & devices | Pairing code | On-screen only (new) |

## What gets built

1. **One shared QR helper** — `lib/core/qr/qr_payloads.dart`: builds every payload in one place (UPI pay/collect, menu URL, feedback URL, offer claim URL `…/m/offer.html?s={slug}&o={code}`, product code, pairing payload `vendoros://pair?c=123456`). Pure Dart, unit tested.

2. **QR on the thermal bill** — add ESC/POS QR support (`GS ( k` model 2) to `escpos.dart`, plus a plain-text fallback URL for printers that reject it. Receipt gains an optional feedback URL alongside the existing `upiUri`; both render as QRs sized for 58 mm and 80 mm rolls.

3. **Device pairing by scan** — owner's Phones & devices screen shows the existing 6-digit code as a QR; the joining phone uses the existing camera scanner to read it and fill the pairing form. Same 15-minute expiry, no new backend.

4. **Product label scan-to-bill** — printed product labels already carry the code; the bill and quick-sale screens gain a scan button that looks the code up in inventory and adds the line. Unknown code shows a plain "Item not found" message.

5. **Offer QR** — each offer gets a short claim code and a printable A4 card sheet (offer name, validity, Tamil line, QR). Scanning opens a static `web/m/offer.html` page that shows the offer and a "Show this at the counter" screen; staff redeem it through the existing offer redemption flow on the bill.

6. **Feedback + payment counter card** — one A4 sheet combining shop name, payment QR and feedback QR, so the counter needs a single print.

7. **Print & share polish** — every QR screen gets the same three actions: Print/Save PDF, Share, Copy link. Consistent wording, EN + TA strings.

## Deliberately not included

- No scan tracking or counts; codes work fully offline.
- No new QR hub screen; each code stays on its own page.
- No dynamic/rotating QR codes.

## Technical notes

- QR rendering already exists (`BarcodeView`, `barcode` package for PDFs); nothing new to install.
- New/changed files: `lib/core/qr/qr_payloads.dart`; `lib/features/printing/domain/escpos.dart` (QR command); `lib/features/printing/domain/receipt.dart` (+`feedbackUrl`); receipt renderers; `lib/features/products/application/label_sheet.dart` (counter card, offer cards); `lib/features/offers/domain/offer.dart` (+claim code) and offers page; devices page; bill/quick-sale scan action; `web/m/offer.html`; EN/TA ARB + regenerated localization.
- Tests: payload builders, ESC/POS QR byte framing, offer claim-code stability, product-code lookup.
- Verify with `flutter analyze`, full test suite, then rebuild and publish the web bundle.

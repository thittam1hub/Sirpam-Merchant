# VendorOS roadmap

Gate: `docs/PRODUCTION_CHECKLIST.md`. Keep this list lean — done items get
deleted, not archived.

## Now
- [x] Vendor taxonomy + business profile (`docs/VENDOR_TAXONOMY.md`)
  - [x] Category model (cart / stall / hotel / service), niche suggestions, 38 TN districts
  - [x] Settings profile section; home prompt + category-gated shortcuts
  - [ ] First-run onboarding wizard (replaces home prompt card)
  - [ ] Device-key scoped profile sync to Lovable Cloud
- [ ] Inventory / product management (see `docs/PRODUCT_CHECKLIST.md`)
  - [x] Catalogue, FIFO stock, batches/expiry, suppliers, low-stock alerts
  - [x] Barcode + QR scanning (camera / HID / manual), labels (PDF, ZPL, TSPL)
  - [x] Payment QR from the vendor's own UPI ID
  - [ ] Device-key scoped inventory sync to Lovable Cloud
  - [ ] Widget tests + 320 dp / 2.0 text-scale layout pass
- [ ] Server-confirmed soundbox (PSP webhook -> Supabase -> device, never misses)
  - [x] Connect Supabase project `Sirpam Vendor App`
  - [x] Schema: merchants / devices / upi_payments / payment_acks (+ realtime, RLS)
  - [x] Webhook + device RPCs (PhonePe signature verify, Paytm token, pair / feed / ack / heartbeat)
  - [x] Flutter: pairing UI, durable announcement queue, dedupe by provider txn id, replay on reconnect
  - [x] Self-service merchant onboarding in-app (`/merchant`) + help guide (`/help`)
  - [ ] Onboard a real PSP merchant (merchant ref + salt key) — see `docs/SOUNDBOX.md`
  - [ ] FCM high-priority push delivery (needs Firebase project + google-services.json)
- [x] Layout pass at 320 dp width and 2.0 text scale (`test/small_screen_test.dart`
      guards 9 core screens; app bar + tab labels cap at 1.3x, quick sale scrolls)
- [x] Contrast audit: ink / inkSoft now clear AAA (7:1) on canvas, surface and
      well in both themes; accent, link, warning and danger clear AA (4.5:1).
      `test/contrast_test.dart` guards the palette.

## GST tax invoice (Phase B — in progress)
- Per-item GST rate (permille) and HSN/SAC on products and order lines.
- Shop settings: GST-registered switch and price-includes-tax switch.
- Bill screen and printed/PDF/thermal bill show the CGST/SGST (or IGST) slab
  table with taxable value per rate.
- Still to do: month-wise tax summary report (sales/purchases by rate).

## Backup & export (Phase A — done)
- `/settings/backup`: one checksummed JSON file with every book, shared via the phone's share sheet; restore picks the file back, validates format/version/checksum and refuses damaged files with plain-language messages.
- CSV exports (UTF-8 BOM so Excel shows Tamil): sales, bills, credit balances, stock.
- Automatic online backup is live: a daily copy goes to the shop's own cloud space, with manual backup and restore beside the file backup.

## Next
- [x] Owner can point any paired phone at a staff role from `/devices`
- [ ] Release keystore + `android/key.properties`, signed upload build
- [ ] Privacy policy page + Play data-safety notes (notification access)
- [ ] Host `assetlinks.json` for HTTPS App Links verification

## Later
- [ ] Lovable Cloud sync for multi-device backup (architecture is ready)

## Localization hardening (done)
- All user-facing strings live in `lib/l10n/app_en.arb` / `app_ta.arb` (PDF heading and TTS included).
- ICU plurals: `customerCount`, `daysWindow`; parameterized messages keep placeholders in metadata.
- `test/l10n_keys_test.dart` fails the build on locale drift, missing/unused keys, missing placeholders, or hardcoded Tamil outside the catalogs.
- `.github/workflows/ci.yml` runs gen-l10n drift check + analyze + tests; `npm run check` does the same locally.
- Language switches instantly from Settings (no restart) and reloads the TTS voice.
- Terminology: "Udhaar" replaced with Tamil "கடன்" / English "Credit" (routes unchanged).

## Ordering & billing (see `docs/ORDERING_BILLING.md`)
- [x] Customer-facing QR menu page (`web/m/`), no app install, offline-safe copy.
- [x] Vendor order board (`/orders`): counter orders, tokens, status flow, cancel reasons.
- [x] Kitchen ticket view (`/kot`) and menu publishing + table QR sheet (`/menu`).
- [x] Billing (`/bill/:orderId`): discounts, GST, rounding, split cash/UPI/credit, bill numbers.
- [x] Receipts: 58/80 mm ESC/POS bytes + PDF / share fallback, printer settings (`/printers`).
- [x] Orders feed ledger, FIFO stock and the day-close orders section.
- [x] Apply the ordering database migration (SQL + prompt in `docs/ORDERING_BILLING.md`).
- [x] Native Bluetooth (SPP) ESC/POS transport; USB OTG still falls back to PDF.
- [x] Cloud board sync (8 s polling) + offline replay of counter orders and status moves.
- [x] Soundbox auto-settlement: a confirmed UPI amount that matches exactly one open order closes it as a paid UPI bill (ambiguous amounts stay manual).

## Requested 2026-09-04
- [x] Migrate the codebase SQL (`docs/sql/ordering_cloud.sql`) into the connected database.
- [x] Real shop details (name, address, phone, GSTIN, FSSAI) editable on `/menu`, sent to the cloud shop and printed on receipts.
- [ ] Real QR menu URLs per shop/table, verified opening on a phone.
- [x] Order board backed by the cloud so orders persist and update live (offline-safe replay; a physical end-to-end walk still needs the vendor's phone).
- [ ] Pair a real Bluetooth thermal printer and print a real receipt (needs the physical printer).
- [x] Credit settlement screen (`/settle?customer=…`): cash / UPI / new loan, auto-posted to the ledger with history.


## Navigation standard (2026-09-05)
- [x] `push` for every child screen, `go` only for the four tabs and for "finish and return" endings; back gesture and top-bar arrow now behave alike.
- [x] Every screen has a URL: `/products/new?code=…` and `/products/:id/edit` replaced raw page pushes.
- [x] Deep-link entry never dead-ends — `DetailScaffold` falls back to the owning list or Home when there is nothing to pop.
- [x] View state in the URL: product search / low filter, insights window, order board `?status=history`.
- [x] Unsaved-changes confirmation (with Android predictive back) on the product form.
- [x] `web/.well-known/assetlinks.json` published — replace the placeholder with the release signing SHA-256 to make `https://vendoros.app` links open the app directly.
- [x] Route builder / query-parsing tests extended (85 tests green).
- Note: Flutter web serves deep links in hash form (`/#/orders?status=history`); Android custom-scheme and app links use the plain paths.
- [x] Unsaved-change confirmation extended to merchant onboarding and credit settlement.

## Vendor-type playbooks (2026-09-05)

- [x] Recipe book with scaling, cost per plate and stock deduction
- [x] Custom orders / advance bookings with advance + balance posting
- [x] Regulars, acquisition source and loyalty rewards
- [x] Events & exhibitions P&L
- [x] Workers: attendance, advances, wages
- [x] Growth kit links, share messages and post ideas
- [x] Opening / closing checklist
- [x] Typed routes, EN/TA strings, 99 tests passing
- [x] Vendor-type starter presets seeding menu, supplies, recipes and checklists per category
- [x] Recipe prep uses its own stock movement kind and refuses to cook when raw material is short

## Dashboard / shop types / subscription (2026-09-05)
- [x] Supabase: shop_subscriptions + plan checks on cloud RPCs; helper functions locked down
- [x] /dashboard with day/week/month filters and shareable section links
- [x] /shop business-type workflows (restaurant, hotel, street stall, DIY, magnet, tea shop)
- [x] /plan subscription screen reading server status with offline grace
- [ ] Payment provider + webhook to actually sell Pro
- [ ] Per-shop cloud account auto-provisioning from the app

## Dine-in ordering (2026-09-05)
- [x] Customer QR menu: token screen, order summary, "Pay by UPI" intent to the
      shop's own VPA, pay-at-counter fallback, "order something else". No
      customer-side tracking by design (dine-in: the counter calls the token).
- [x] Order board rush actions: accept all new / serve all ready.

- Merchant ordering rules (table/self/takeaway, pay before/after, call staff, ask for bill) are live: settings page /settings/ordering, cloud shop columns + service_requests, customer menu branches, counter board shows requests and awaiting-payment orders.

## Multi-device sync (2026-09-06)
- [x] Supabase: shop_pairing_codes + shop_devices (hashed keys, single-use
      6-digit codes, 15-minute expiry, max 5 active devices, Pro-gated) and
      device-key RPCs for board feed, status, payment, service requests and
      counter orders; owner RPCs for code/list/revoke.
- [x] `/devices` hub: owner generates pairing codes and revokes phones; staff
      phones pair with slug + code and pick waiter / kitchen / counter.
- [x] Paired phones sync the board with their own device key and land on their
      role's screen (`/menu`, `/kot`, `/orders`); revoked phones stop syncing.
- [x] `/devices?pair=1` deep link, EN/TA strings, device model/route tests.
- [x] Security pass: orders/order_items given service-role-only policies, trigger function locked to the database. Remaining linter warnings are the shop-key / device-key protected RPCs, which must stay callable with the publishable key by design.
- [x] Business-type aware roles: per-shop-type role templates (waiter/kitchen/cashier, counter helper, stock keeper, ...) with pre-ticked permissions and money limits; the role editor hides permissions the trade never uses (no kitchen for tea shops, no stock for service vendors). EN/TA strings, template tests.
- [x] Permissions enforced in the UI: shared `ref.guard(...)` + `PermissionGate` on quick sale, counter orders, order status/bulk moves, order item edits, billing (bill, discount, credit, void, reprint), credit settlement, expenses and day close; owner-PIN approval sheet for blocked or over-limit actions, every one audited. Recurring costs can now be removed (long press + confirm).
- Pending: physical printer/QR verification, PSP + FCM production wiring, realtime push channel (polling fallback is live).

## Wiring pass (2026-09-06)
- [x] Printer: connected-device status, disconnect/forget, Bluetooth permission prompt
- [x] Bill: share as plain text (WhatsApp/SMS) beside PDF share
- [x] Devices: "Test connection" using the device ping RPC
- [x] Soundbox: periodic device heartbeat so online/last-seen is accurate
- [x] Stock: record and show last-updated sync state
- [x] Sync custom roles to Supabase so paired waiter/kitchen/counter phones are
      enforced server-side, not only on the owner's phone
- [ ] Owner screen to point each paired phone at a published role (server API
      `shop_device_set_role` exists, no UI yet)
- [ ] Supabase security linter: 65 SECURITY DEFINER execute-grant warnings to
      review before going live

## Languages (2026-09-11, done)
- [x] Hindi, Telugu, Kannada and Malayalam translations of every screen
      (`tool/translate_arb.py` regenerates them from `app_en.arb`)
- [x] Language picker lists all six languages in their own script; English
      stays the default; voice ledger and spoken payment alerts follow it
- [ ] Native-speaker proof-read of the four new catalogs

## Trending-shop plan — Phase 1 (done)
- Morning prep sheet at `/prep`: planned vs made per item, resets daily, starter sheet per trade.
- Sold-out on quick sale tiles, shared with the order board and QR menu (pushes availability to cloud).
- Rush-hour view on the day window of Insights, with a counter-staffing hint.
- Opening cash on Day close: pre-filled from yesterday's count and included in expected drawer cash.

## Trending-shop plan — Phase 2 (done)
- [x] Hero items on the day window of Insights: sold today, stock left, estimated run-out hour.
- [x] "Not seen lately" regulars on Customers, with a one-tap WhatsApp nudge.
- [x] Offers with a code / combo price, redemption count and profit after discount; one-tap chips on the bill.
- [x] Rewards-due list at the top of Customers.
- [x] Bill feedback QR (3-tap rating, review link for happy customers, private note otherwise).
- [x] Enquiry-to-sale log with follow-up filters, WhatsApp and won/lost tracking.

Next: Phase 3 — weekday patterns, item profitability, cost-rise alerts, festival calendar,
year view, renewal reminders.

## QR across the shop day (done)

- [x] Shared payload builders (`lib/core/qr/qr_payloads.dart`): UPI, menu, offer, product, pairing — static, no tracking.
- [x] Thermal QR on bills: ESC/POS `GS ( k` payment QR + feedback QR, with the links still printed as text fallback.
- [x] Roll-width PDF receipt shows both QRs too.
- [x] A4 counter card (pay QR + feedback QR) from the Feedback page.
- [x] Offer / loyalty cards: printable A4 QR cards + copyable claim link, static claim page `web/m/offer.html`.
- [x] Device pairing QR on the owner's phone; staff phone pairs by scanning it.
- [x] Scan-to-sell on Quick sale (printed product labels), friendly unknown-code message.
- Deliberately out of scope: scan counts/tracking, a central QR hub, rotating codes.

## GST reports + theme (done)

- [x] Month-wise GST summary (`/reports/gst`): sales, taxable value, CGST/SGST/IGST per slab, CSV share for the accountant.
- [x] Dark + light neumorphic palettes with a Settings > Appearance picker (system / light / dark), persisted.
- [x] Colours now resolve at runtime, so every screen follows the chosen theme.

## Purchases + supplier dues (done)

- [x] Purchase bills at `/purchases`: supplier, bill number, items (catalog or
      free text), per-item cost and GST, paid-now vs due.
- [x] Catalog lines restock inventory as a received lot, so purchase spend and
      stock value stay in step with the dashboard.
- [x] Supplier dues list mirroring the credit book; payments settle oldest
      bills first, single-bill "Paid" from the bill sheet.
- [x] New permissions: record purchase bills, pay suppliers (in stock-keeper
      role templates), guarded with owner-PIN override + audit.
- [x] EN/TA strings, purchase math tests (204 tests green), web rebuilt.

Next: Phase D — in-app Pro purchase, Hindi and Telugu.

## Requested 2026-09-11
- [x] Automatic online backup to the cloud (daily on open + last-backed-up line, manual backup and restore on /settings/backup)
- [x] Staff permissions enforced server-side for paired phones (roles published to Supabase; paired phones pull their role on pair and ping)
- [x] One-tap WhatsApp bill from the bill screen
- [x] Side nav (desktop) / bottom tabs (mobile) now stay on every page (`test/shell_chrome_test.dart`)

- [x] Owner admin pack: cash book, exceptions, staff report, item gaps, daily summary, report permissions, all-shops view

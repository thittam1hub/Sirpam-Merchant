# Ordering, Billing & Printing for Sirpam Merchant (replce where VendorOS is used)

Turn the app into a complete counter system: a customer scans a QR, sees the shop's
menu on their phone browser, places an order; the order lands live on the vendor's
order board; the vendor bills it, prints a thermal receipt, collects cash/UPI/credit,
and everything flows into the existing ledger, inventory (FIFO), credit book, day
close and insights.  
if you need database connection make it to TODO list with instruction and prompt, so when i connect later you can start to build the database from the todo, until don't ask for dtabase connection.

## Where each part lives

- **Customer menu: a lightweight hosted web page, not the Flutter app.** A customer
must not download an app or wait for a heavy bundle. It is a small static
HTML/CSS/JS page served from the project's web output at
`/m/<shop-slug>?t=<table>`, reading and writing Cloud directly with public,  
narrowly-scoped access. Works on a cheap phone over 3G.
- **Vendor side: the existing Flutter app.** New order board, billing sheet and
printer settings screens, offline-tolerant, live-updating.
- **Shared state: Lovable Cloud**, which the project is already connected to.

## Feature set

### 1. Shop menu and QR

- Publish selected inventory products as menu items (name, price, category,
veg/non-veg mark, photo optional, available toggle).
- Per-shop slug plus per-table/counter QR codes, printable as a sheet through the
existing label/PDF pipeline.
- Availability toggle from the app instantly greys the item on the web menu.

### 2. Customer ordering (web)

- Browse by category, add to cart, quantity steppers, notes per line.
- Optional name/phone, table number from the QR.
- Place order -> token number shown, live status (New / Preparing / Served / Paid).
- Pay-now option opens the vendor's existing UPI collect link; otherwise pay at counter.

### 3. Vendor order board

- Live columns New / Preparing / Served / Paid with token numbers and elapsed timers.
- Sound + vibration on a new order; unmissable banner if the device was offline.
- Accept / reject with reason, edit lines, merge orders on the same table.
- Manual counter order entry reusing the quick-sale tiles (walk-ins without QR).

### 4. KOT (kitchen ticket)

- Kitchen view listing only items to prepare, grouped by token, with a done tick.
- Optional separate KOT print at order accept.

### 5. Billing

- Bill built from order lines: discounts (flat/percent), optional GST/FSSAI details
from the vendor profile, rounding to the rupee, service charge off by default.
- Split payment across cash / UPI / credit in one bill; credit portion posts to the
existing credit (கடன்) book against the named customer.
- Sequential bill numbers per day, reprint and void with a reason, both audited.
- Soundbox UPI confirmation auto-settles a matching open bill.

### 6. Printing

- ESC/POS 58 mm and 80 mm thermal receipts over Bluetooth and USB, with a printer
picker and test print in Settings.
- Fallback path always available: PDF share / WhatsApp / plain text receipt, so a
vendor with no printer is never blocked.
- Receipt layout: shop header, GSTIN/FSSAI when set, token, lines, totals, payment
split, UPI QR, Tamil text via the bundled Tamil font (image-rendered when the
printer lacks Tamil glyphs).

### 7. Downstream integration

- Every paid bill writes: ledger sale (per payment mode), FIFO stock movement,
credit entry when applicable, and feeds day close and week/month/year insights.
- Day close gains an orders section: orders taken, cancelled, average ticket,
unpaid bills still open.

## Build order

1. Cloud schema + public menu read/order write policies.
2. Menu publishing from inventory + QR sheet printing.
3. Customer web menu and order placing.
4. Vendor order board (live + offline queue) and KOT.
5. Billing sheet with discounts, split payment, bill numbering.
6. ESC/POS printing + PDF fallback + printer settings.
7. Ledger / inventory / credit / day-close / insights wiring.
8. Localization, tests, docs, checklist.

## Technical notes

- **Schema** (all public-schema tables get explicit GRANTs, then RLS, then policies):
`shops` (slug, name, vpa, gstin, fssai, open flag), `menu_items` (shop, product
ref, name_en/name_ta, price_paise, available, sort), `tables`, `orders` (shop,
table, token, status, customer name/phone, totals, created_at), `order_items`,
`bills` (order ref, number, discount, tax, total, splits), `bill_payments`.
Anon gets `SELECT` only on `shops`/`menu_items`/`tables` for open shops and
`INSERT` on `orders`/`order_items` through a `SECURITY DEFINER` RPC that validates
the shop slug, recomputes prices server-side from `menu_items`, and returns the
token — the client never sets its own prices or statuses. Order status reads for
the customer go through a token-scoped RPC, not a table policy.
- **Device scoping:** the vendor app is device-key paired (as the soundbox already
is); order board reads/writes are scoped by that key, matching current patterns.
- **Realtime:** Cloud realtime subscription on `orders`, with a polling fallback and
a durable local queue so status changes made offline replay on reconnect —
mirrors the existing soundbox delivery design.
- **Flutter structure:** new feature folders `lib/features/orders/`,
`lib/features/billing/`, `lib/features/printing/` with the established
domain / data / application / presentation split; money stays integer paise;
bill math and ESC/POS byte building are pure functions in `domain/` so they unit-test
without widgets or hardware.
- **Routes:** `/orders`, `/orders/:id`, `/kot`, `/bill/:orderId`, `/menu` (publishing),
`/printers`, all added to `AppPaths`/`AppRoutes` with validated query params and
deep-link-safe back handling.
- **Web menu:** plain HTML/CSS/JS under `web/m/`, no framework, inline critical CSS,
Tamil font subset, served by the existing web build/publish scripts; it calls the
Cloud REST endpoint with the publishable key only.
- **Printing packages** must be Bluetooth/USB ESC/POS capable on Android; the byte
encoder is written in-project so a package swap never rewrites receipt logic.
- **Strings:** every label into `app_en.arb` / `app_ta.arb` (including the web menu's
own small string table), enforced by `test/l10n_keys_test.dart`.
- **Tests:** bill totals with discount/tax/rounding, split-payment reconciliation,
ESC/POS byte snapshots for 58/80 mm, order state machine transitions, offline
replay dedupe, RPC price-tamper rejection, order -> ledger/stock/credit writes.
- **Docs:** `docs/ORDERING_BILLING.md` plus checklist entries in
`docs/PRODUCT_CHECKLIST.md` and `roadmap.md`.

## Out of scope for this pass

Multi-branch chains, delivery partners/aggregators, waiter-per-table accounts,
customer loyalty, and full GST return filing.
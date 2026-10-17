# VendorOS — Product & Inventory Management (with QR / barcode)

A new `products` domain for VendorOS: a vendor-grade catalogue with batch and
expiry tracking, camera scanning, printable QR/barcode labels, a UPI payment QR,
and local-first storage that syncs to Cloud. Code is ported from the
"Remix of Lovable Inventory AI ref" project where it fits, simplified from
warehouse scale to stall scale.

## What the vendor gets

1. **Product catalogue** — name (Tamil + English), unit (kg / piece / litre / bundle),
   category, purchase price, selling price, live margin %, barcode/QR code,
   optional photo, active/archived.
2. **Stock ledger** — every movement is a typed record: purchase (restock),
   sale, wastage/spoilage, return, manual correction. Stock on hand is always
   derived from movements, never a stored counter that can drift.
3. **Batches & expiry** — each restock creates a batch (quantity, cost, received
   date, expiry). FIFO consumption on sale gives real cost of goods and true
   profit. Expiry dashboard: expired / expiring in 3 days / 7 days.
4. **Suppliers** — name, phone, notes; each purchase links to a supplier;
   one-tap WhatsApp reorder message with the low-stock list.
5. **Low-stock alerts** — per-product reorder level, a single alert surface,
   ordered by urgency.
6. **Sell by scan** — scan a product code, confirm quantity, and the sale posts
   into the existing ledger and decrements stock in one action.
7. **Reports** — stock valuation (FIFO), profit per product, wastage, dead stock.
   Feeds into the existing loan-proof PDF as an inventory annexe.

## QR and barcode

- **Scanning** — `mobile_scanner` engine ported from the reference project
  (`core/hardware/barcode_camera_scanner.dart`), trimmed to camera + keyboard-wedge
  input, with the same de-duplication window. Supports EAN-13/8, UPC-A/E, Code128,
  Code39, QR and DataMatrix. Web falls back to the browser `BarcodeDetector`, and
  shows an honest unsupported state where absent.
- **Own-product codes** — products without a printed barcode get a generated
  VendorOS code (`VOS-` + short id) rendered as a QR.
- **Label sheets** — on-device label rendering (QR/Code128 + name + price + date)
  laid out on A4 as a printable/shareable PDF using the `pdf` + `printing`
  packages already in the project. The reference project's ZPL/TSPL thermal-printer
  dialects are ported behind the same interface for vendors who own a label printer.
- **Payment QR** — a stall UPI QR built from the standard NPCI `upi://pay` string
  (existing `ShareLinks.upiPay`), with an optional amount so a specific bill can be
  shown as a QR; it is savable and shareable. Confirmation of the payment still
  comes only from the PSP soundbox pipeline, never from showing the QR.

## Data: local-first, then Cloud sync

- Local is the source of truth (`LocalStore`), so everything works offline.
- Cloud tables mirror the local model: `products`, `product_batches`,
  `stock_movements`, `suppliers` — all owner-scoped by `auth.uid()` with RLS and
  explicit grants.
- Sync is last-write-wins per row with `updated_at` plus a soft-delete flag, run
  on app resume and after each write when online. Conflicts never delete history:
  stock movements are append-only and idempotent by client id.
- Requires sign-in for sync only; the app stays fully usable signed out.

## Technical notes

- New module `lib/features/products/` with `domain / data / application /
  presentation` layers, matching existing conventions.
- Reused from the reference project: barcode engine, typed JSON readers
  (`_s/_i/_d` pattern with `PayloadFormatException`), label template engine,
  repository/provider shape.
- New dependencies: `mobile_scanner`; `barcode` (already resolved transitively
  through `pdf`) is used directly for symbol rendering.
- Routes added to `lib/app/routes.dart` / `router.dart`, all deep-linkable:
  `/products`, `/products/:code`, `/scan`, `/stock`, `/batches`, `/suppliers`,
  `/labels`, `/payment-qr`.
- All strings go into `lib/l10n/app_en.arb` and `app_ta.arb`; the existing
  `l10n_keys_test` gate keeps both catalogues in sync.
- All surfaces use the existing neumorphic tokens and chrome widgets — no new
  colours.
- Money stays integer paise; quantities are stored as integer milli-units so
  0.25 kg is exact.

## Files created for tracking

- `docs/PRODUCT_MANAGEMENT.md` — the feature specification: rules, formulas,
  states and acceptance criteria per feature (same format as `IMPLEMENTATION.md`).
- `docs/PRODUCT_CHECKLIST.md` — the implementation checklist, grouped by
  catalogue / stock / batches / scanning / labels / payment QR / sync / tests /
  release, each item verifiable by a command or a screenshot.

## Build order

1. Docs: specification + checklist files.
2. Domain models, local store schema, repository, providers.
3. Catalogue and product detail UI.
4. Stock movements, batches, expiry and low-stock surfaces.
5. Scanner engine + sell-by-scan and scan-to-restock flows.
6. Label studio (PDF sheet + thermal dialects) and payment QR.
7. Cloud tables, RLS, sync service.
8. Tests (FIFO costing, stock math, scan dedupe, sync merge, l10n parity),
   analyzer, web build, checklist sign-off.

## Out of scope

Warehouse bins, AI forecasting agents and spatial/AR mapping from the reference
project — they do not fit a single-stall workflow.

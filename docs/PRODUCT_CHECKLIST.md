# Product & inventory release checklist

Gate for the inventory module. `[x]` only when a command, a test or a
screenshot proves it — never by reading code. Spec:
[PRODUCT_MANAGEMENT.md](./PRODUCT_MANAGEMENT.md).

## A. Domain & data
- [x] Money in integer paise, quantity in integer milli-units, end to end
- [x] Pure `StockMath` (FIFO, valuation, expiry, low stock, parsing) with no I/O
- [x] Append-only `StockMovement`; corrections add, never edit
- [x] Products archived rather than deleted
- [x] Tolerant JSON readers on every inventory model
- [ ] Atomic multi-list writes (product + batch + movement) with rollback

## B. Catalogue
- [x] Create / edit product: name, Tamil name, code, category, unit, cost, price, reorder level
- [x] Auto-generated `VOS-…` code when none is supplied
- [x] Search by name or code, low-stock filter, both reflected in the URL
- [x] Archive with confirmation
- [ ] Duplicate-code guard on save

## C. Stock operations
- [x] Restock creates a batch at its own cost, with optional expiry
- [x] Sell draws FIFO, records COGS, optionally posts a cash sale to the ledger
- [x] Shortfall surfaced to the vendor instead of being absorbed silently
- [x] Wastage recorded at FIFO cost
- [x] Stock count correction reconciles on-hand
- [x] Stock screen: valuation, 30-day profit, 30-day wastage, low list, expiry list
- [ ] Expiry entered as a date, not a number of days

## D. Scanning
- [x] Camera scanning (EAN-13/8, UPC-A/E, Code128/39, ITF, QR)
- [x] HID / USB wedge scanner intake
- [x] Manual code entry always available
- [x] 900 ms duplicate suppression
- [x] Unknown code offers "create product with this code"
- [x] Android `CAMERA` permission declared; camera feature not required
- [ ] iOS `NSCameraUsageDescription` (no iOS target in this build)
- [ ] Verified on a physical Android device with a real barcode

## E. Barcode & labels
- [x] On-screen QR and Code128 rendering
- [x] A4 PDF label sheet (50×25, 40×30, 100×50 mm; QR or barcode; copies)
- [x] ZPL and TSPL payloads with escaping and copy counts (unit-tested)
- [ ] Confirmed on a physical thermal label printer

## F. Payment QR
- [x] Static and dynamic UPI QR from the vendor's own VPA
- [x] Built only through `ShareLinks.upiCollect()` (unit-tested)
- [x] Missing VPA routes to Settings instead of a broken QR
- [x] Printable / shareable A4 poster
- [x] Honest note: a scan is not a confirmed payment

## G. Navigation & localization
- [x] `/products`, `/products/:id`, `/scan`, `/stock`, `/batches`, `/suppliers`, `/labels`, `/collect`
- [x] Validated query params; deep-link-safe back behaviour
- [x] Inventory shortcuts on the home screen
- [x] All strings in the ARB catalogs, English + Tamil, plurals where counts appear
- [x] `test/l10n_keys_test.dart` green (parity, placeholders, unused, hardcoded Tamil)

## H. Sync
- [x] Local-first: every read works offline
- [ ] Device-key scoped push/pull to Lovable Cloud
- [ ] Last-write-wins conflict handling verified with two devices
- [ ] Sync status and last-synced age visible in the UI

## I. Quality
- [x] `flutter analyze` — zero issues
- [x] Unit tests: FIFO, valuation, expiry buckets, low stock, quantity parsing, tolerant JSON, UPI collect, ZPL/TSPL
- [ ] Widget tests: empty catalogue, unknown scan, missing-VPA payment QR
- [ ] Layout verified at 320 dp width and 2.0 text scale
- [x] Neumorphic tokens only; no ad-hoc colours in inventory widgets

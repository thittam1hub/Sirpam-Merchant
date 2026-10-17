# Product & inventory management — specification

The inventory module turns VendorOS from a ledger into a stock system: what the
vendor owns, what it cost, what it is worth, what is running out and what is
about to expire — all offline-first, all in integer units, no mock data.

Related: [ARCHITECTURE.md](./ARCHITECTURE.md) ·
[IMPLEMENTATION.md](./IMPLEMENTATION.md) ·
[PRODUCT_CHECKLIST.md](./PRODUCT_CHECKLIST.md)

---

## 1. Units of measure and money

| Concept | Storage | Display |
| --- | --- | --- |
| Money | `int` paise | `paise / 100`, two decimals |
| Quantity | `int` milli-units (`qtyMilli`) | `StockMath.formatQty` (trailing zeros dropped) |
| Unit | `StockUnit` ∈ `kg · gram · piece · litre · bundle` | localized (`unitKg`, …) |
| Time | epoch milliseconds | local calendar day for grouping |

Never store money or quantity as `double`. All arithmetic that a rupee value
depends on lives in `lib/features/products/domain/stock_math.dart`, which is
pure and unit-tested.

## 2. Domain model (`domain/inventory_models.dart`)

```
Product      id, code, name, localName, category, unit, costPaise,
             pricePaise, reorderMilli, archived, updatedAt
StockBatch   id, productId, receivedMilli, remainingMilli, costPaise,
             receivedAt, expiryAt?, supplierId, deleted
StockMovement id, productId, kind, qtyMilli (positive magnitude), ts,
             costPaise, note, batchId
Supplier     id, name, phone, note
```

Rules
- `code` is unique and doubles as the barcode/QR payload. Auto-generated codes
  use the `VOS-XXXXXX` form; scanned EAN/UPC codes are stored verbatim.
- Products are **archived**, never hard-deleted, so history stays readable.
- Batches are the only place a cost lives after purchase — the product's
  `costPaise` is just the default for the next intake.
- `StockMovement` is **append-only**. Corrections add a movement; they never
  edit or delete an earlier one.
- Every JSON reader is tolerant (`tryFromJson` returns `null` on junk rows)
  so one corrupt record cannot wipe the catalogue.

## 3. Stock arithmetic

| Formula | Definition |
| --- | --- |
| On hand | `Σ remainingMilli` of live batches for the product |
| Valuation | `Σ remainingMilli × costPaise / 1000` over live batches |
| FIFO draw | oldest `receivedAt` first, until the requested quantity is met |
| COGS | `Σ draw.qtyMilli × draw.costPaise / 1000` |
| Gross profit | `Σ sale revenue − Σ COGS` over the window |
| Wastage cost | `Σ COGS` of `wastage` movements over the window |
| Low stock | `reorderMilli > 0 && onHand ≤ reorderMilli` |
| Margin | `(price − cost) / price × 100`, hidden when price is 0 |

`consumeFifo` never mutates its input and returns `shortfallMilli` when the
batches cannot cover the request. Selling more than the recorded stock is
allowed (a street stall's book is never perfect) but the shortfall is surfaced
to the vendor in the confirmation — it is never silently absorbed.

Expiry buckets are calendar-day based: `expired`, `today`, `soon` (≤ 7 days),
`later`, `none`.

## 4. Operations (`application/inventory_controller.dart`)

| Operation | Effect |
| --- | --- |
| `upsertProduct` | create/edit catalogue entry |
| `archiveProduct` | hides from lists, keeps history |
| `receiveStock` | new batch + `purchase` movement |
| `sellStock` | FIFO draw + `sale` movement (+ optional cash sale in the ledger) |
| `recordWastage` | FIFO draw + `wastage` movement |
| `correctStock` | reconciles on-hand to a counted figure via a `correction` movement (surplus creates a batch at the product's cost) |
| `upsertSupplier` / `removeSupplier` | reorder contacts |
| `replaceAll` | bulk restore used by sync/import |

Each operation writes through `InventoryRepository` → `LocalStore`. A write
failure raises `StorageFailure`, which the global listener shows to the vendor
— a failed save is never reported as success.

## 5. Scanning (`core/hardware/barcode_scanner.dart`)

Three intake paths, one code stream:
1. **Camera** — `mobile_scanner`; EAN-13/8, UPC-A/E, Code128/39, ITF, QR.
2. **HID wedge** — cheap USB/Bluetooth "keyboard" scanners; keystrokes are
   buffered until Enter.
3. **Manual** — typed code, always available so a broken camera never blocks a sale.

Identical codes inside 900 ms are treated as one scan (guns fire repeats).
A known code opens the product; an unknown code offers "create with this code".
Camera scanning is claimed only where it exists (Android, iOS, and browsers
exposing a camera) — elsewhere the UI says so and shows the manual field.

## 6. Barcode and label output

- On-screen rendering: `core/widgets/barcode_view.dart` (QR + Code128).
- Thermal printers: `LabelRenderer.zpl()` (Zebra) and `.tspl()` (TSC/Godex and
  the common Indian clones) at 203 dpi / 8 dots per mm, sizes 50×25, 40×30 and
  100×50 mm, with copy counts and quote/caret escaping.
- Normal printers: `application/label_sheet.dart` lays the same specs out as an
  A4 PDF via the `pdf`/`printing` packages.

## 7. Payment QR (`presentation/payment_qr_page.dart`)

Built from the vendor's own UPI ID in Settings through
`ShareLinks.upiCollect()` — the single place a `upi://pay` URI is constructed.
Static (no amount) or dynamic (amount + note). The screen states plainly that a
scan only opens the customer's UPI app; a payment counts when the
server-confirmed soundbox announces it, never because a QR was displayed.

## 8. Storage and sync

Local keys in `LocalStore`: `products`, `stock_batches`, `stock_movements`,
`suppliers`, `inventory_sync`. All reads work offline.

Cloud sync is device-key scoped, matching the soundbox pairing model — the
Flutter app has no Supabase user session, so a device key issued at pairing is
the identity. Push/pull is last-write-wins on `updatedAt` per record, with
tombstones (`archived` / `deleted`) rather than deletes. PSP secrets are never
sent to or stored in the app.

## 9. Navigation

`/products`, `/products/:id`, `/scan`, `/stock`, `/batches`, `/suppliers`,
`/labels`, `/collect` — all defined in `lib/app/routes.dart` with validated
query parameters (`q`, `low`, `product`, `amount`) so any view is deep-linkable
and every screen survives cold entry via `AppBackButton.popOrGo`.

## 10. Localization and design

Every string lives in `lib/l10n/app_en.arb` / `app_ta.arb`; `test/l10n_keys_test.dart`
fails the build on drift, unused keys, missing placeholders or hardcoded Tamil.
All surfaces use `NeuColors` / the shared neumorphic chrome — no one-off colours.

## 11. Out of scope (deliberately)

Multi-warehouse transfers, purchase-order approvals, serial-number tracking,
AI demand forecasting and geo-fenced stock. The reference inventory project
covers those; a street stall does not need them and they would add screens a
vendor must learn.

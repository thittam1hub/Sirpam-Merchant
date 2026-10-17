# Matching the industry standard: gap study and build plan

I studied what the leading apps in three groups actually ship, then compared
each one against VendorOS.

- India shop billing/khata: Vyapar, myBillBook, Khatabook, OkCredit
- India restaurant POS: Petpooja, Restroworks (Posist), DotPe/Rista, Gofrugal
- Global small-shop POS: Square, Loyverse, Shopify POS

## What every one of them has

Fast billing, item list with low-stock alerts, customer records, sales
reports, staff logins with permissions, works-offline billing, multi-device
or multi-shop sync, payment collection, supplier/purchase records, loyalty,
and paid plans with a free entry tier.

## Where VendorOS already matches or leads

Billing with split payment and printing, order board and kitchen tickets,
table QR menu, stock with batches and expiry, barcode and label printing,
credit book with WhatsApp reminders, staff roles with money limits, day
close, prep sheet, offers, feedback, device pairing, UPI QR, soundbox
payment announcements, Tamil-first screens. Several of these (soundbox,
prep sheet, feedback QR) are ahead of the smaller Indian apps.

## The real gaps, in the order they hurt a shop

1. **Tax is one flat rate for the whole bill.** Vyapar, myBillBook and
   Gofrugal put a tax rate and an HSN code on each item, split the tax into
   CGST/SGST on the bill, and can print a proper tax invoice. A registered
   shop cannot legally use VendorOS today.
2. **No tax reports.** Those apps produce month-wise sale/purchase tax
   summaries the shop's accountant asks for. VendorOS has none.
3. **No backup or data export.** Everything lives on one phone. If that
   phone is lost, the shop loses its books. Every competitor has cloud
   backup or export; this is the single biggest risk in the app.
4. **No purchase bills.** Suppliers exist, but there is no "I bought stock
   for ₹4,000 from Kumar" record, so payables and true purchase cost are
   guesswork. Vyapar, Gofrugal and Petpooja all have it.
5. **Supplier dues are not tracked** the way OkCredit does (two-sided
   ledger: customers owe me, I owe suppliers).
6. **No online-order channel.** Petpooja and DotPe pull Swiggy/Zomato
   orders onto the same board. We only take counter and table QR orders.
7. **No way to actually buy Pro** — the plan screen reads status but there
   is no payment step.
8. **Only two languages.** Khatabook and OkCredit ship 11-12; Hindi and
   Telugu are the obvious next two.

## Build plan

### Phase A — Don't lose the shop's data (first)
- Backup and restore: one-tap encrypted backup of all local books to the
  shop's cloud account, automatic daily when online, restore on a new phone
  during setup.
- Export: sales, bills, credit and stock as CSV/Excel files the owner can
  share to their accountant, plus the existing PDF reports.

### Phase B — Be a legal invoice
- Per-item tax rate and HSN/SAC code on products, carried into bills.
- Bill shows CGST/SGST split (IGST when the buyer's state differs), taxable
  value and tax per rate slab; the printed and PDF bill becomes a compliant
  tax invoice with the shop's GSTIN.
- Tax summary report by month: sales by rate, purchases by rate, tax
  payable — shareable as PDF/CSV.
- Registered/unregistered switch so an unregistered stall never sees any of
  it.

### Phase C — The money going out
- Purchase bill entry (supplier, items, quantities, cost, tax, paid or
  due), which also restocks inventory.
- Supplier dues screen mirroring the credit book, with payment recording
  and reminders.
- Purchase totals folded into day close and profit figures.

### Phase D — Sell Pro and grow reach
- Payment step on the plan screen so a shop can subscribe in-app, with the
  server confirming and unlocking cloud features.
- Hindi and Telugu translations of the whole app.

### Deferred (worth doing, not now)
Swiggy/Zomato order pull (needs partner accounts and approval), central
kitchen and multi-outlet rollups, e-invoice IRN and e-way bill generation
(needs a government API provider account and only applies above the
turnover threshold — I'd add these once a real registered shop asks).

## Technical notes

- Tax: keep money in integer paise; add `taxRatePermille` and `hsn` to the
  product/menu item, compute per-slab totals in a pure function under
  `lib/features/billing/domain/`, unit-tested against known invoices.
  `ShopConfig.gstRate` becomes the fallback for items with no own rate.
- Receipts: extend `ReceiptData` with a slab breakdown list; text, ESC/POS
  and PDF renderers all read the same struct.
- Backup: serialise every `LocalStore` document into one JSON bundle,
  compress, encrypt with a key derived from the shop key, store in Cloud
  storage per shop; restore rehydrates before the first frame.
- Purchases: new `lib/features/purchases/` feature folder following the
  existing domain/application/presentation split with tolerant JSON.
- All new strings in `app_en.arb`/`app_ta.arb`; `l10n_keys_test` keeps the
  catalogs honest. Analyzer clean, tests green, web rebuilt and published
  at the end of each phase.

## Sources

Vyapar [features](https://vyaparapp.in/blog/vyapar-app-features/) ·
myBillBook [e-invoicing](https://mybillbook.in/s/best-e-invoicing-software/),
[inventory](https://mybillbook.in/s/best-inventory-management-software/) ·
[Khatabook](https://khatabook.com/en/) ·
OkCredit [reminders](https://okcredit.in/payment-reminder-app),
[ledger](https://okcredit.in/business-ledger-app) ·
Petpooja [POS](https://www.petpooja.com/poss),
[pricing](https://www.petpooja.com/poss/pricing) ·
Restroworks [POS](https://www.restroworks.com/restaurant-pos-system/) ·
DotPe [Rista](https://dotpe.in/rista-restaurant-management-software.html) ·
Gofrugal [retail](https://www.gofrugal.com/retail/features/),
[GST](https://www.gofrugal.com/gst/cloud.html) ·
Square [inventory](https://squareup.com/us/en/point-of-sale/features/inventory-management) ·
[Loyverse](https://loyverse.com/features) ·
Shopify POS [features](https://www.shopify.com/pos/features)

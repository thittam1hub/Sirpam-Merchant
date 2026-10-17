# VendorOS Vendor Taxonomy & Feature Catalog

Reference for who VendorOS serves, which features matter per vendor type, and
the data captured to be Tamil Nadu native with a pan-India expansion path.
See `ARCHITECTURE.md` for the technical design and `PRODUCT_MANAGEMENT.md`
for inventory specifics.

## Core features (every vendor, any type)

- Voice ledger (Tamil speech -> sale entry)
- Credit / கடன் tracking with WhatsApp reminders
- Server-confirmed soundbox (PSP webhook -> announce; never-miss design)
- Payment QR + UPI collect links from the vendor's own VPA
- Daily / 30 / 60 / 90-day PDF business report (loan documentation)
- GPS location sharing
- Market prices from data.gov.in
- Product catalogue, FIFO stock, batches/expiry, suppliers
- Barcode/QR scanning, label printing (PDF, ZPL, TSPL)
- Tamil + English UI with instant switching

## Category A — Street cart / தள்ளுவண்டி (mobile)

Niches: tea/coffee cart, snacks (bajji/bonda), tender coconut, sugarcane
juice, fruit/veg cart, flower seller, fish cart, ice cream, cobbler/key
maker, mobile ironing.

Primary features: GPS live location broadcast, voice ledger, soundbox
announcements, printed UPI QR poster, credit for street regulars.

Data captured: market/area, perishable flag, FSSAI (food carts), working
hours. No barcodes or batches for most carts.

## Category B — Fixed stall / கடை (street-side or market stall)

Niches: vegetable/fruit stall, flower stall, tea shop, pan shop, tiffin
stall, fish/meat stall, newspaper stand, tailoring, mobile recharge, petty
shop, bakery counter.

Primary features: credit ledger, stock + low-stock alerts + wastage, market
prices (buy vs sell margin), suppliers + reorder, expiry for packaged goods,
barcode scanning for packaged-goods sellers.

Data captured: district/taluk, market name, suppliers, wastage, opening
hours.

## Category C — Hotel / eatery / உணவகம்

Niches: mess, tiffin center, tea shop with seating, small hotel, canteen,
biryani shop, juice shop, bakery.

Primary features: item-wise daily totals, credit for regulars and nearby
offices, batches/expiry for milk and vegetables, payment QR at the counter,
PDF report for UDYAM/mudra loan documentation.

Data captured: FSSAI number, UDYAM registration, working hours (meal-time
peaks), perishable flag.

## Category D — Service vendor

Niches: barber, tailor, cobbler, cycle repair, mobile repair, ironing,
electrician, plumber.

Primary features: credit ledger (services are mostly on credit), voice entry
of service + amount, GPS broadcast for visiting services, payment QR.

Data captured: niche (service offered), working hours. No stock screens —
the home screen hides inventory shortcuts for this category
(`VendorProfile.usesInventory`).

## Tamil Nadu native data (vendor profile)

`lib/features/profile/domain/vendor_profile.dart` — stored locally under
`vendoros.profile.v1`, device-key sync later:

- category (cart / stall / hotel / service) — drives feature gating
- niche — free text with per-category suggestions
- district — one of the 38 TN districts (`tamilNaduDistricts`)
- taluk, market/area
- FSSAI number (shown for food categories), UDYAM registration (optional)
- working hours, perishable-goods flag

## Pan-India expansion readiness

- All UI strings are ARB-based; a new state adds `app_<locale>.arb` files
  (hi/te/kn/ml/mr) — the l10n CI test enforces key parity per locale.
- District/taluk lists are per-state data files; TN ships first.
- Market prices are already national (data.gov.in).
- Voice recognition locales extend beyond ta-IN per state.
- Reminder templates and TTS follow the UI locale.
- Currency/formatting stays INR — no structural change.
- FSSAI/UDYAM are central schemes — no per-state compliance fields needed.

## Implementation checklist

- [x] VendorProfile model + LocalStore key + Riverpod controller
- [x] Category/niche picker in Settings with TN districts dropdown
- [x] Home screen: one-time profile prompt; shortcuts adapt to category
- [x] ARB keys for categories and profile fields (en + ta)
- [x] Tests: profile model/persistence/gating; l10n parity enforced in CI
- [ ] Device-key scoped profile sync to Lovable Cloud
- [ ] Onboarding wizard (first-run) instead of home prompt card
- [ ] Per-state district data files + additional locales

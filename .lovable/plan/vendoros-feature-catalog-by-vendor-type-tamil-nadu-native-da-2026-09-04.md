# VendorOS Feature Catalog by Vendor Type + Tamil Nadu Native Data Model

## Goal

Create a complete feature catalog of VendorOS organized by the type of vendor
(what they sell, what stall they run, their niche), and define the data the app
must capture to be truly native to Tamil Nadu first, then expandable to pan-India.
Deliverable is a new `docs/VENDOR_TAXONOMY.md` (the catalog + checklist), plus a
`vendor_profile` data layer in the app that stores the vendor's category and
drives feature visibility.

## Part 1 — Full feature catalog, categorized by vendor type

### Core features (every vendor, any type)

- Voice ledger (Tamil speech → sale entry)
- Credit / கடன் tracking (udhaar) with reminders
- Server-confirmed soundbox (PSP webhook → announce, never-miss)
- Payment QR + UPI collect links from own VPA
- Daily / 30-day PDF business report (for loans)
- GPS location sharing (for moving carts)
- Mandi/market prices (data.gov.in)
- Product catalogue, stock, batches/expiry, suppliers
- Barcode/QR scanning, label printing
- Tamil + English UI, instant language switch

### Category A — Street cart / தள்ளுவண்டி (thalluvandi, mobile)

Niches: tea/coffee cart, snacks (bajji/bonda), tender coconut, sugarcane juice,
fruit/veg cart, flower seller, fish cart, ice cream, cobbler/key maker, mobile
iron/press.

Features that matter most:
- GPS live location broadcast (customers find the moving cart) — PRIMARY
- Voice ledger (hands busy, no time to type) — PRIMARY
- Soundbox announcements (no time to check phone) — PRIMARY
- UPI QR poster (printed, hangs on the cart)
- Simple product list, no barcodes, no batches
- Credit tracking for regulars (same street customers)

Data to capture: cart route/stops, usual parking spots + time slots,
perishable flag (sell-by end of day), cash vs UPI split.

### Category B — Fixed stall / கடை (street-side fixed, market stall)

Niches: vegetable/fruit stall, flower stall, tea shop, pan shop, tiffin stall,
fish/meat stall, newspaper stand, tailoring, mobile recharge, petty shop
(petty kadai), bakery counter.

Features that matter most:
- Credit ledger (large regular-customer base on credit) — PRIMARY
- Stock + low-stock alerts, wastage tracking — PRIMARY
- Mandi prices (daily buy-price vs sell-price margin) — PRIMARY
- Suppliers list + reorder
- Expiry dates (bakery, dairy resellers)
- Barcode scanning (only for packaged goods sellers)

Data to capture: market name (e.g. Koyambedu), stall number, wholesale
supplier mandi, wastage %, opening hours.

### Category C — Hotel / eatery / உணவகம்

Niches: mess, tiffin center, tea shop with seating, small hotel, canteen,
biryani shop, juice shop, bakery.

Features that matter most:
- Item-wise daily sales totals (idli/dosa/tea counters) — PRIMARY
- Credit for regulars and nearby offices — PRIMARY
- Expiry/batches for milk, vegetables (FSSAI awareness)
- Payment QR per table or counter
- Report for loans (UDYAM / mudra loan documentation)

Data to capture: FSSAI registration number, seating vs takeaway, meal-time
peaks (breakfast/lunch/dinner), UDYAM registration.

### Category D — Service vendor

Niches: barber, tailor, cobbler, cycle repair, mobile repair, ironing,
electrician/plumber visiting service.

Features that matter most:
- Credit ledger (services almost always on credit) — PRIMARY
- Voice entry of service + amount — PRIMARY
- GPS broadcast (for visiting services)
- No stock; optional parts inventory (mobile repair, cycle parts)

Data to capture: service list with prices instead of products, home-visit flag.

## Part 2 — Tamil Nadu native data fields (vendor profile)

New `vendor_profile` stored locally (device-key synced later):

- Business name (Tamil + romanized)
- Vendor category: cart / stall / hotel / service (drives which features show)
- Niche (free text + suggested list per category)
- Address with Tamil Nadu specifics: district (38 TN districts list),
  taluk, town/village, market name, ward/zone
- Language preference: ta / en
- Business identifiers: UDYAM registration, FSSAI number (food vendors),
  GSTIN (optional, most are unregistered)
- Mobile number (for customer WhatsApp reminders)
- Working hours + weekly off
- Perishable inventory flag

Feature gating: category picked at onboarding decides which home shortcuts and
inventory fields appear (e.g. service vendor sees no stock screens).

## Part 3 — Pan-India expansion readiness (design now, build later)

- Locale framework already ARB-based: add hi/te/kn/ml/mr ARB files per state
- District/taluk lists become a per-state data file, TN shipped first
- Mandi prices already national (data.gov.in covers all states)
- Voice recognition: add hi-IN, te-IN etc. locales to speech config
- SMS/WhatsApp reminder templates per language
- Currency/number formatting stays INR; no structural change
- Compliance fields per state stay optional (FSSAI/UDYAM are central)

## Implementation checklist (new work this plan adds)

- [ ] `docs/VENDOR_TAXONOMY.md` — full catalog above as the reference doc
- [ ] `VendorProfile` model + LocalStore key + Riverpod controller
- [ ] Category/niche picker screen (TN districts dropdown, 38 districts)
- [ ] Onboarding asks category once; home screen shortcuts adapt to category
- [ ] ARB keys for all categories, niches, districts (en + ta)
- [ ] Tests: profile persistence, category gating, l10n parity
- [ ] Docs cross-links from ARCHITECTURE.md and roadmap.md

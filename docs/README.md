# VendorOS — Engineering Documentation

VendorOS is an offline-first Flutter application for Indian street vendors:
a zero-typing sales ledger, udhaar (credit) tracking, a UPI soundbox, live
mandi prices, a bank-ready loan-proof report and a cart GPS broadcast.

This folder is the source of truth for how the app is designed, built,
verified and shipped. Read the documents in this order.

| Document | Purpose |
| --- | --- |
| [BLUEPRINT.md](./BLUEPRINT.md) | The original architectural blueprint, verbatim, plus a conformance/deviation table against the shipped app |
| [ARCHITECTURE.md](./ARCHITECTURE.md) | Layers, module boundaries, state management, data flow, platform boundaries |
| [IMPLEMENTATION.md](./IMPLEMENTATION.md) | Feature-by-feature specification: rules, formulas, states, acceptance criteria |
| [PRODUCT_MANAGEMENT.md](./PRODUCT_MANAGEMENT.md) | Inventory and product-management specification: units, FIFO, scanning, labels, payment QR, sync |
| [VENDOR_TAXONOMY.md](./VENDOR_TAXONOMY.md) | Feature catalog by vendor type (cart / stall / hotel / service), TN-native profile data, pan-India expansion path |
| [PRODUCT_CHECKLIST.md](./PRODUCT_CHECKLIST.md) | Release gate for the inventory module |
| [REFERENCE.md](./REFERENCE.md) | Deep links, query params, platform channels, external APIs, storage keys, design tokens |
| [SKILLS.md](./SKILLS.md) | Operational runbook: toolchain, build, test, APK, preview verification, troubleshooting |
| [PRODUCTION_CHECKLIST.md](./PRODUCTION_CHECKLIST.md) | The gate. Every item must be checked before a release is called production-ready |
| [../roadmap.md](../roadmap.md) | Open work, ordered |

## Ground rules

1. **No mock data, ever.** A feature either shows real data or an honest empty
   / unavailable / key-required state. Never fabricate prices, balances or
   payments.
2. **Offline-first.** Every read path must work with the aeroplane mode on;
   network is an enhancement that fills caches.
3. **Deep-linkable UI state.** Anything a vendor might share or return to
   lives in the URL (see REFERENCE.md), never only in widget state.
4. **One source of truth per concern.** Routes in `lib/app/routes.dart`,
   colours in `lib/core/theme/neu_theme.dart`, persistence in
   `lib/core/storage/local_store.dart`.
5. **Tamil-first copy** with 56dp+ tap targets and AAA-contrast ink.

# Trending local shop: day / week / month / year, and what to add

Modelled on how popular small Tamil Nadu shops actually run today — a crowd that arrives in waves, one or two hero items, regulars who come back weekly, and festival/season peaks. No Instagram account is connected; this is only about matching how such shops work.

## The four archetypes

1. Cafe / tea bar (coffee, shakes, small bites)
2. Bakery / cake studio (counter sales + booked cakes)
3. Boutique / accessories (walk-ins + enquiry-to-sale)
4. Street food stall (evening rush, queue, one hero item)

## The cycle

**Day**
- Open with a prep list and opening cash; note milk/batter/stock received.
- Quiet morning, sharp rush window (evening for stall/cafe, weekend noon for bakery).
- Hero item sells out; staff keep saying "over".
- Orders, tokens, waiting customers; some pay UPI, some take credit.
- Close: cash vs UPI vs credit, wastage, tomorrow's prep note.

**Week**
- Weekend is 2–3x a weekday; supplier payments and bulk buying.
- Regulars settle credit; booked orders for the coming weekend.
- One weekly off / low day worth planning around.

**Month**
- Rent, EB, gas, salary, packaging; monthly profit and per-item margin.
- Menu/price revision when input cost moves; slow items to drop.
- Monthly credit accounts and reminders.

**Year**
- Pongal, Aadi, Deepavali, wedding season, exam season, monsoon slumps.
- Yearly turnover for loan/UDYAM, licence and gas renewals, price history.

## Already in the app

Quick-sale tiles, orders board, KOT, billing and printing, credit (கடன்), expenses, day close, inventory with batches/expiry, insights for day/week/month/year, regulars with loyalty and source, events, custom orders (jobs), recipes, staff and roles, soundbox UPI.

## What to add — phased

**Phase 1 — save time daily**
1. Morning prep sheet: per-shop-type opening checklist with quantities, one tap done, carried over from yesterday's close note.
2. Rush-hour view: sales by hour so the owner sees the real peak, plus a "staff needed" hint for those hours.
3. Sold-out toggle on any item, visible on quick sale, order board and the QR menu, auto-clears at day open.
4. Opening cash + closing count folded into the existing day close, with a plain "short / extra by ₹x" line.

**Phase 2 — grow sales**
5. Hero item tracker: top 3 items by day with a "runs out by" estimate so they prep enough.
6. Offers: named offer with a code or a simple combo price, redemption count, and profit after discount.
7. Regulars nudges: who has not come in 30 days, a one-tap WhatsApp message, and reward-due list from the existing loyalty card.
8. Feedback QR on the bill: 3-tap rating with an optional note; happy customers get the review link, unhappy ones reach the owner privately.
9. Enquiry-to-sale log for boutique/bakery: enquiry, quoted price, follow-up date, won/lost — so DMs and calls stop getting lost.

**Phase 3 — understand and manage**
10. Weekday pattern view: average by day of week, best/worst day, weekend lift.
11. Item profitability: margin per item after recipe cost, with slow-and-thin items flagged for menu cleanup.
12. Cost-rise alert: when a purchase price rises, show the new per-plate cost and a suggested new selling price, with price history kept.
13. Festival & season calendar for Tamil Nadu: upcoming peak with last year's number for the same period, and a prep reminder a week before.
14. Year view: 12-month turnover, profit, peak months, added to the existing loan PDF.
15. Renewal reminders: gas, licence, FSSAI, rent agreement, with due-date alerts.

## Technical notes

- New feature folders `lib/features/prep/`, `lib/features/offers/`, `lib/features/feedback/`, `lib/features/enquiries/`, `lib/features/calendar/`; existing folders extended for hourly, weekday, item-margin and cost-history analytics as pure functions in `lib/features/analytics/domain/`.
- Storage keys follow the existing tolerant-read pattern: `vendoros.prep.v1`, `vendoros.offers.v1`, `vendoros.feedback.v1`, `vendoros.enquiries.v1`, `vendoros.renewals.v1`, `vendoros.pricehistory.v1`.
- Money stays integer paise; hourly buckets derive from existing `Sale.ts` and stock movements — no parallel data model.
- Sold-out is a flag on `Product`, honoured by quick sale, order board and the published QR menu payload.
- New routes `/prep`, `/offers`, `/feedback`, `/enquiries`, `/calendar` registered in `AppPaths`, `AppRoutes` and the navigation registry, gated by shop category and permissions like existing pages.
- All strings added to `app_en.arb` / `app_ta.arb`; `test/l10n_keys_test.dart` enforces parity.
- Tests: hourly and weekday aggregation, offer profit maths, sell-out estimate, item margin, cash short/extra, prep carry-over, festival lookup.
- Docs: extend `docs/VENDOR_TAXONOMY.md` with the four archetypes and add items to `docs/PRODUCT_CHECKLIST.md`.

Phase 1 first; each phase ships and is verified before the next.

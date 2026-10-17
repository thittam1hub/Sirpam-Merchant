# Vendor-type playbooks: day / week / month / year, plus growth features

Extend Sirpam Merchant beyond the tea-shop mode already built, so a restaurant,  
small hotel, street stall, DIY/craft stall, fridge-magnet stall and tea shop each  
get a preset that matches how their day, week, month and year actually runs — and  
add the growth tools trending sellers now depend on (reels, maps, reviews,  
regulars, events). for Restaurant / small hotel (உணவகம்) include an recipie where they save the unique recipie with all details with measurement with plan for incremental and decrease the quantiy with requirement with this features a restaraunt can run without master when they take leave.

## The real cycles

**Restaurant / small hotel (உணவகம்)**

- Day: prep list, recipie, meal-time peaks (breakfast/lunch/dinner), table + token orders, KOT, bills with GST, staff shift, closing cash vs UPI vs credit, leftover food.
- Week: supplier payments, weekly menu plan, best-selling dish, weekly off, staff attendance.
- Month: rent, EB, gas, salaries, FSSAI/GST filing dates, food-cost %, price revision.
- Year: festival/season peaks, yearly turnover for loan, licence renewals.

**Street stall / cart (தள்ளுவண்டி)**

- Day: opening float, spot + timing, fast tiny sales, credit regulars, evening wastage, cash count.
- Week: bulk buying day, market price swings, weekly off.
- Month: pitch/hafta cost, small profit check, festival stock.
- Year: monsoon dip, festival spike, savings/loan record.

**DIY / craft / fridge-magnet stall**

- Day: made-to-order requests, custom name orders, per-piece material cost, Instagram DM orders, packing.
- Week: exhibition/pop-up weekends, stall rent vs sales, restock of raw material.
- Month: event calendar, top designs, courier/shipping costs, wholesale enquiries.
- Year: festival/wedding season, exhibition circuit, price/design refresh.

## Features to add

1. **Vendor presets** — picking category + niche seeds the right menu/items, expense heads, units and home shortcuts (restaurant, hotel, street stall, tea shop, DIY/craft, magnet stall). Extends the existing starter pack.
2. **Recipe / material cost (BOM)** — each dish or craft item lists its ingredients or materials, so cost per plate / per magnet, margin and true profit are automatic, and stock deducts raw material, not just finished goods.
3. **Custom / made-to-order jobs** — order with customer name, design notes, photo, advance paid, promised date, status (taken → making → ready → delivered), with reminders. Essential for DIY, magnet, tailoring, cake, gift stalls.
4. **Event / exhibition mode** — a pop-up or market day as its own book: stall rent, travel, footfall, sales, per-event profit, and a comparison of which events are worth repeating.
5. **Regulars & loyalty** — customer list with visit count and spend, "every 10th tea free" style card, and monthly passes (meal pass, chai pass) that deduct automatically.
6. **Growth kit** — one screen holding the QR menu link, Google Maps/business link, review-request link, WhatsApp catalogue text, and a weekly content prompt (what to post today: top seller, behind-the-counter, new item), with share buttons. Includes a printable price/offer poster.
7. **Reviews & reach tracker** — log where new customers came from (Instagram, Maps, walk-in, referral) at billing in one tap, then show which channel actually brings money.
8. **Staff & shifts** — worker list, daily attendance, shift open/close, salary/advance tracking, and staff-wise sales for eateries.
9. **Prep / opening checklist** — per-category morning list (milk, gas, batter, change float, printer paper) ticked in seconds; misses show at day close.
10. **Season & festival planner** — calendar of Pongal, Diwali, wedding season, exam season, monsoon, with last year's numbers for the same window and a stock-up suggestion.
11. **Week / month / year playbook views** — extend the existing insights screen with a per-category scorecard: best day, best item, average bill, repeat-customer %, food/material cost %, month-over-month growth and a yearly summary for loan or UDYAM.
12. **Advance bookings / pre-orders** — take tomorrow's tiffin, party order or craft order with advance, and see a "to make today" list each morning.

## Build order

1. Vendor presets + prep checklist (fast, makes every other feature land in context).
2. Recipe/material cost, wired into existing FIFO stock and billing margins.
3. Custom/made-to-order jobs + advance bookings.
4. Regulars, loyalty and passes, on top of the existing credit customer list.
5. Growth kit + source-of-customer tracking.
6. Event/exhibition mode.
7. Staff & shifts.
8. Season planner + extended week/month/year playbook views.

## Technical notes

- New feature folders `lib/features/recipes/`, `lib/features/jobs/`, `lib/features/events/`, `lib/features/crm/`, `lib/features/staff/`, `lib/features/growth/`, each following the existing domain / application / presentation split with integer-paise money.
- Presets extend `lib/features/profile/application/starter_pack.dart` and `nicheSuggestions`; new niches added for DIY/craft, magnet, gifting, cloud kitchen.
- BOM stored per `Product` as component lines referencing other products; sale of a finished item deducts components through the existing `InventoryController` FIFO path — no parallel stock model.
- Jobs, events, customers, staff, checklists persist under new tolerant `LocalStore` keys (`vendoros.jobs.v1`, `.events.v1`, `.customers.v1`, `.staff.v1`, `.checklist.v1`), same pattern as expenses, and reuse the existing cloud-sync approach where a shop key exists.
- Analytics stay pure functions under `lib/features/analytics/domain/` so scorecards are unit-testable.
- New routes `/jobs`, `/jobs/:id`, `/events`, `/customers`, `/staff`, `/growth`, `/checklist` added to `AppPaths`/`AppRoutes` with validated query params and deep-link-safe back handling, matching the navigation rules already in place.
- All strings go into `app_en.arb` / `app_ta.arb`; `test/l10n_keys_test.dart` enforces parity.
- Tests: BOM cost math, job lifecycle, event P&L, loyalty accrual, preset seeding, scorecard aggregation.
- Docs: extend `docs/VENDOR_TAXONOMY.md` with these cycles and add items to `docs/PRODUCT_CHECKLIST.md` and `roadmap.md`.

## Not included

Instagram/Maps APIs are not connected — the growth kit prepares links, captions
and posters to share manually; no auto-posting or follower analytics.
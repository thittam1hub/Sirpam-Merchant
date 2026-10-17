# Tea Shop Mode: Day / Week / Month / Year Features

A Tamil Nadu tea shop (டீ கடை) runs on tiny repeated transactions, fixed daily supplies, monthly credit customers, and seasonal peaks. This plan walks through their real cycle, then adds only the missing features to VendorOS(rename to " Sirpam Merchant").

## The real cycle

**Day**

- 5:30am open: boil milk, note milk cans, sugar, tea dust, gas received.
- All day: 8-15 rupee sales, hundreds of entries. Nobody types each one.
- Regulars ("office 4 tea") take on credit, settle weekly/monthly.
- Snacks (bun, bajji, biscuits) from a supplier arrive morning and evening.
- Evening close: cash in drawer vs UPI received vs credit given; leftover snacks wasted.

**Week**

- Weekly supplier payment (milk, snacks), weekly off day, weekly credit settlement, buying tea dust/sugar in bulk.

**Month**

- Rent, EB bill, gas cylinders, worker salary, monthly credit accounts, milk agency bill, profit check, price revision when milk rate changes.

**Year**

- Festival/season peaks (Pongal, monsoon, exam season), yearly turnover for loan/UDYAM, gas + license renewals, price history.

## What the app already covers

Voice ledger, credit (கடன்) tracking with per-customer balance, soundbox UPI confirmation, payment QR, FIFO inventory with batches/expiry/suppliers, market prices, GPS, loan PDF report with daily turnover, Tamil/English localization, vendor profile with category + niche.

## What is missing — features to add

1. **Quick-sale menu tiles (tea shop mode)** — a grid of the shop's own items (Tea 10, Coffee 15, Bun 10, Bajji 5). One tap = one sale; long-press = quantity. This is the single biggest need; voice cannot handle 400 tiny sales.
2. **Daily expenses** — currently only income exists. Add typed expense entries (milk, gas, snacks, wages, rent, EB, transport, other) so profit is real, not just turnover.
3. **Day close / shift summary** — end-of-day card: cash sales, UPI sales, credit given, credit collected, expenses, net cash expected in drawer, plus a cash-count mismatch note.
4. **Recurring daily supplies** — milk cans / snack trays as a repeating daily item with a default quantity, so morning intake is two taps.
5. **Weekly and monthly dashboards** — day-wise bar view, best day, best-selling item, average per day, month-over-month change, expense split. Currently only the loan report window exists.
6. **Monthly credit accounts** — mark a credit customer as "monthly account", auto-statement per month, one-tap WhatsApp reminder with the UPI collect link.
7. **Yearly summary** — 12-month turnover, profit, peak months, exportable in the existing loan PDF for UDYAM/mudra.
8. **Price change history + margin alert** — when milk or gas cost rises, show the new per-cup cost and suggest a selling price.
9. **Wastage at close** — leftover snacks recorded as wastage against inventory, so profit and reorder quantities stay honest.
10. **Tea-shop starter pack** — picking category `hotel` with niche "Tea shop" seeds a default menu (tea, coffee, bun, biscuit, bajji), default supply items, and shows tea-shop shortcuts on Home.

## Build order

1. Expense domain + storage + entry UI (foundation for profit everywhere).
2. Quick-sale menu tiles wired to existing sale + inventory movement flow.
3. Day close summary screen.
4. Recurring daily supplies + wastage at close.
5. Week / month / year dashboards.
6. Monthly credit accounts + statement reminder.
7. Price history + margin suggestion.
8. Tea-shop starter pack + Home gating by niche.

## Technical notes

- New feature folder `lib/features/expenses/` (domain `Expense`, controller, page) following the ledger pattern; money stays integer paise.
- Quick-sale tiles reuse `Product` + `InventoryController.recordSale` and `LedgerController` so one tap writes both ledger and stock — no parallel data model.
- New `LocalStore` keys `vendoros.expenses.v1`, `vendoros.menu.v1`, `vendoros.dayclose.v1`, `vendoros.recurring.v1`, tolerant reads like existing keys.
- Analytics computed as pure functions in `lib/features/analytics/domain/` so they are unit-testable without widgets.
- New routes `/quick`, `/expenses`, `/close`, `/insights` with validated query params (`?window=day|week|month|year`), deep-link-safe back handling, added to `AppRoutes`.
- All strings go into `app_en.arb` / `app_ta.arb` with ICU plurals; `test/l10n_keys_test.dart` enforces parity.
- Tests: expense math, day-close reconciliation, week/month/year aggregation, quick-sale writes both ledger and stock, starter-pack seeding.
- Docs: extend `docs/VENDOR_TAXONOMY.md` with the tea-shop cycle and add the new items to `docs/PRODUCT_CHECKLIST.md`.
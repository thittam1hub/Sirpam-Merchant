# Vendor dashboard, real shop accounts, and business-type shop pages

Three connected pieces: one dashboard that answers "how is the shop doing",
a real per-shop account in the cloud so the numbers belong to that shop
alone, and a shop page per Tamil Nadu business type that arranges the
features the way that trade actually works.

## 1. Vendor dashboard

New page at `/dashboard` (also the first shortcut on Home).

Four cards, each summarising one part of the business for the chosen period:

- Orders — count, tokens served, billed total, average bill, top items
- Pending payments — unbilled/unsettled orders and unpaid UPI expectations
- Credit balances — total outstanding, oldest debt, top customers by balance
- Inventory — stock value, low-stock count, expiring batches, wastage

Period filter is a pill row: Day / Week / Month, held in the URL as
`/dashboard?window=day|week|month`, so a chosen view is bookmarkable and the
back button works. Each card also opens a focused view:
`/dashboard/orders?window=week`, `/dashboard/payments`, `/dashboard/credit`,
`/dashboard/inventory` — every one a real route with its own share button.

Shareable link per card: the share button copies/sends the deep link plus a
plain-text summary of that card for the chosen period (the same channel the
app already uses for reminders and reports). When the shop has a cloud
account (part 2), the link is an https link to a read-only snapshot page;
without an account it is the in-app deep link.

Aggregation reuses `insights.dart` — the window logic already exists; the
dashboard adds order, credit and inventory roll-ups next to it, all in pure
functions that can be unit tested.

## 2. Real vendor accounts in Sirpam's cloud

Today `shops` is keyed by slug + shop key and only ordering data syncs.
This part makes the shop row the account:

- `shops` gains business type, owner name, phone, district and the profile
  fields the shop pages need.
- New `shop_snapshots` table: one row per shop per day holding the dashboard
  numbers (orders, pending, credit, inventory) as JSON, written by the app
  after each day-close or on demand.
- RPCs: `shop_account_upsert` (key-protected write of profile + snapshot),
  `shop_snapshot_public` (read-only fetch by share token), and a share token
  column so a dashboard link can be opened by someone without the shop key.
- Every RPC stays key-protected exactly like the existing ordering RPCs; the
  public read returns only the summary numbers, never customer names,
  phone numbers or line-item detail.
- The app writes through a `VendorAccountApi` and keeps working offline —
  local storage stays the source of truth, the cloud row is the shared copy.
- A static share page at `web/d/index.html` renders a snapshot from the
  public RPC, so a shared dashboard link opens on any phone with no install.

Migration is applied to the connected database in the same step, with grants
and row-level security on every new table.

## 3. Shop pages by business type

Six types: TN restaurant, hotel, street stall, DIY stall, fridge magnet
stall, tea shop. The existing profile has four broad categories; this adds a
`ShopType` alongside it (the category still drives feature gating, the type
drives the shop page and preset).

Each type gets `/shop/:type` with:

- a dashboard header tuned to what that trade watches daily
- a starter menu and supply list for that trade (extends `vendor_presets`)
- the workflow shortcuts that trade uses, in order
- an opening/closing checklist for that trade

Per type:

| Type | Dashboard focus | Menu | Workflow |
| --- | --- | --- | --- |
| TN restaurant | Table turns, meal-time peaks, KOT queue | Meals, tiffin, biryani | Orders → KOT → bill → day close |
| Hotel | Room + counter sales, credit for offices | Tiffin, meals, tea | Counter order → bill → credit |
| Street stall | Cash vs UPI, day sales, perishables | Snacks, fruit, juice | Quick sale → soundbox → day close |
| DIY stall | Made-to-order jobs, advances, materials | Craft items, custom work | Job → advance → delivery |
| Fridge magnet stall | Stock by design, event sales, restock | Magnet designs, bundles | Quick sale → stock → events |
| Tea shop | Cups/day, milk & gas cost, regulars | Tea, coffee, snacks | Quick sale → credit → day close |

Type is chosen in Settings → Business profile and at first run; the Home
screen and the dashboard adapt to it.

## 4. Subscription gating for cloud features

Everything that runs on the shop's own device stays free forever — sales,
credit, stock, billing, printing, checklists. What costs money to run for
the shop is what needs a paid plan:

| Plan | What the shop gets |
| --- | --- |
| Free | Full offline app on one device, QR menu preview, PDF reports |
| Pro (monthly) | Cloud shop account, live order board sync, shareable dashboard links, customer QR ordering, multi-device backup, soundbox cloud confirmations |

How it works:

- A `subscriptions` row per shop in the cloud (plan, status, current period
  end), written only by the payment provider webhook — never by the app.
- The app reads its plan through the shop-key RPC and caches it locally with
  a grace period, so a shop that is briefly offline is not locked out.
- A single `PlanGate` in the app: gated buttons stay visible but open a plain
  "This needs the Pro plan" sheet with the price and an upgrade button,
  instead of disappearing. Local features never pass through the gate.
- Server side is the real boundary: the cloud RPCs (menu publish, board
  feed, order placement, snapshot write/share) check the shop's active
  subscription and refuse when it has lapsed, so the gate cannot be bypassed.
- Lapsed shops keep read access to their existing data and keep working
  offline; only new cloud writes stop.
- Payments are handled by Lovable's built-in payments; the provider and
  price are confirmed with you before anything is enabled.

## Technical notes

- Routes: `/dashboard`, `/dashboard/orders|payments|credit|inventory`,
  `/shop/:type`, `/plan`, all typed in `AppPaths`/`AppRoutes` with validated
  `window` and `type` query/path parsing.
- New feature folders `lib/features/dashboard/`, `lib/features/account/`
  (cloud account API) and `lib/features/plan/` (subscription state + gate).
- All strings go into `app_en.arb` / `app_ta.arb`; the l10n parity test
  keeps both locales complete.
- Money stays in integer paise; all roll-ups are pure functions with tests.
- Neumorphic tokens and `ResponsiveContent` as everywhere else.

## Out of scope for this pass

- Per-vendor email/password login (the shop key remains the credential)
- Editing dashboard data from the shared web page (read-only)
- Multi-branch chains under one account
- In-app purchase billing through the Play Store (web checkout first)


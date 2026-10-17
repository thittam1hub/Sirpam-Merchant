# Owner/Admin upgrade: match what the big shop apps give an owner

Sourced from what leading Indian shop and restaurant apps put on the owner's
screen — Petpooja's owner dashboard, reports and user-rights module
(petpooja.com/poss/reports-and-analytics), its head-office multi-outlet view
(petpooja.com/poss/large-chain-restaurant-pos-software), plus the owner
patterns in Vyapar, myBillBook, Loyverse and Square: exception reports,
cash-drawer variance, staff performance, auto-sent day summaries, and
report-level access rights.

VendorOS already has a dashboard, day close, GST reports, audit trail, roles
and device pairing. What an owner in those apps gets and we do not:

## What gets added

### 1. Owner exception report (the "what happened behind my back" screen)
One screen listing, for any day/week/month: discounts given, cancelled and
voided orders, bill reprints, deleted items, credit given, and owner-PIN
overrides — each with staff name, amount, time and reason. Filter by staff.
This is built on the audit records and bill data already stored.

### 2. Cash drawer and variance
Opening cash, expected cash (cash sales + settlements − expenses − payouts),
counted cash at close, and the difference — recorded per day-close with who
counted it. A short-cash trend line on the dashboard and a per-staff variance
count in the exception report.

### 3. Staff performance card
Per staff, per period: bills made, sales value, average bill, discounts given,
voids, short cash, orders served. Ranked list the owner can share.

### 4. Daily auto-summary to the owner
At day close (and a set time), a one-tap WhatsApp/share summary: sales, cash vs
UPI vs credit, top items, spend, dues collected, short cash. Optional daily
reminder so it goes out even if the phone was busy.

### 5. Item and wastage insight
Item-wise sold quantity and consumption against recipe/stock movement, with a
"sold vs stock moved" gap flagged as possible wastage or unbilled use.

### 6. Report rights per role
Roles get report-level permissions (view sales totals, view profit/cost, view
staff report, export data), so a manager can see sales but not margins.

### 7. Multi-shop owner view (owner with more than one shop)
A shop switcher plus a combined "all shops" totals view for owners running two
or more cloud shops on the same owner key, with per-shop breakdown.

## Not included
- Aggregator (Swiggy/Zomato) integrations, ERP/Tally push, central kitchen
  purchase routing — out of scope for a single-vendor app.
- Scheduled email reports (no mail service configured); the share/WhatsApp
  summary covers it.

## Technical notes
- New `lib/features/admin/` grouping owner-only screens: `/admin/exceptions`,
  `/admin/staff`, `/admin/cash`, reusing the existing audit, bill, sale,
  day-close and expense stores — no new local schema beyond a cash-count field
  on day close and a `reportScope` permission set in the roles model.
- Exception and staff aggregation runs locally over existing records; cloud
  shops reuse the current owner-key RPCs, with one new read-only RPC for the
  all-shops rollup.
- Report permissions extend the existing 29-permission model and are enforced
  by `ref.guard(...)` and `PermissionGate`, and synced to `shop_roles` so
  paired phones obey them too.
- Six-language strings for every new label; new tests for variance maths,
  exception aggregation and report-permission gating.

## Order of work
1. Cash drawer + variance (feeds everything else)
2. Exception report
3. Staff performance
4. Daily auto-summary
5. Report rights per role
6. Item/wastage insight
7. Multi-shop owner view

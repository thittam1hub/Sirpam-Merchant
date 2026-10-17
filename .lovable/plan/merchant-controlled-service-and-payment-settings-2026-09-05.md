# Merchant-controlled service and payment settings

No — none of the three are built yet. Today the customer menu always shows the order first, then offers a UPI pay button only if a payment ID is saved, and there is no waiter/bill button and no service-mode choice. This plan adds all of it, with the merchant deciding on their own screen.

## What the merchant chooses

A new "Ordering rules" screen in the app, reachable from Settings, with:

1. **Service style**
  - Table service — staff bring the order to the table.
  - Self service — customer collects at the counter when their token is called.
  - Takeaway only — order packed and picked up.
2. **Payment timing**
  - Pay first — the order is only confirmed after the customer pay the bill.
  - Pay after — order goes to the kitchen straight away, pay at the counter.
3. **Customer buttons** (each on/off)
  - Call staff
  - Ask for the bill
   (Both hidden automatically when self service or takeaway is chosen, since there is no table to come to.)

These settings are saved with the shop, so every table QR follows them instantly with no reprinting.

## What the customer sees

- **Pay first:** basket → "Pay ₹X" button opening their own UPI app → returning shows the token and a "I have paid" confirm step; the order reaches the counter marked *awaiting payment* until the merchant marks it paid.
- **Pay after:** unchanged from today — order lands immediately, token shown, "Pay at the counter".
- **Self service:** the token screen says "We'll call your token at the counter", no waiter button.
- **Table service:** token screen shows the table number plus the enabled Call staff / Ask for the bill buttons.
- **Takeaway:** token screen says "Collect at the counter", pickup note field.

## What the merchant sees

- Order cards show the service style and payment state (Paid / Awaiting payment / Pay at counter).
- Call-staff and bill requests appear as a highlighted alert row on the order board with a "Seen" action, and are cleared when handled.

## Technical notes

- Database: add `service_mode` (table/self/takeaway), `pay_mode` (before/after), `allow_call_staff`, `allow_request_bill` to `public.shops`; add `payment_state` to `public.orders`; add a `service_requests` table (shop, table, type, created/handled) with service-role-only RLS. Extend `menu_for_shop` to return the four shop flags, extend `place_menu_order` with a payment-state argument, and add key-protected RPCs `service_request_push` (anon, rate-limited per table) and `order_set_paid`. Include the new rows in `board_feed`.
- `docs/sql/ordering_cloud.sql` updated to match, applied via a migration.
- Flutter: extend `ShopConfig` with the four fields plus JSON round-trip, add `/settings/ordering` with query focus params following the existing settings pattern, push flags on shop register/sync, surface requests and payment state on the order board, and add the ARB strings in English and Tamil.
- Customer menu (`web/m/index.html`): branch on the returned flags for the pay-first step, token wording per service style, and the two request buttons; rebuild `web_build/m`.
- Tests: shop-config round-trip, settings route parsing, payment-state and service-request order flow.
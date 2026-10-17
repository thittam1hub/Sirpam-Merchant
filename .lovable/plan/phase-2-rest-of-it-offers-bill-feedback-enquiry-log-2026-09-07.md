# Phase 2, rest of it: offers, bill feedback, enquiry log

Hero items and the 30-day "not seen lately" nudges already ship. This finishes the remaining
grow-sales items from the approved plan.

## What the shop owner gets

**Offers (`/offers`)**
- Create a named offer: flat rupees off, percent off, or a combo price, with an optional short code.
- Mark an offer live or paused, with an optional end date.
- Each redemption is counted; the card shows how many times used, money discounted, and profit
  left after the discount (using existing item cost where known).
- Live offers appear on quick sale and on the bill screen as one-tap "apply offer" chips, which
  is what records the redemption.

**Rewards due list (Customers page)**
- A short list at the top of Customers of regulars whose loyalty card is complete, with the
  existing "give reward" action, so it is not hidden inside the long list.

**Bill feedback QR (`/feedback`)**
- A printable/shareable QR that opens a tiny 3-tap rating page (happy / okay / unhappy) with an
  optional note.
- Happy ratings offer the shop's review link (set in shop settings); unhappy ones send the note
  privately to the owner and show up on the feedback screen.
- The feedback screen lists recent ratings with today's/this week's average, and the QR can be
  printed on the bill footer.

**Enquiry log (`/enquiries`, boutique/bakery/service shops)**
- Log an enquiry: customer name, phone, what they asked for, quoted price, follow-up date.
- Filters: to follow up today, open, won, lost. One tap to WhatsApp the customer, one tap to mark
  won (which can post the sale) or lost with a reason.
- A small "enquiries won" figure feeds the Growth screen.

## Technical notes

- New folders `lib/features/offers/`, `lib/features/feedback/`, `lib/features/enquiries/`, each
  with `domain/` model, `application/` Riverpod controller over `LocalStore`, and `presentation/`
  page, matching the prep feature's shape.
- Storage keys `vendoros.offers.v1`, `vendoros.feedback.v1`, `vendoros.enquiries.v1`, tolerant read.
- Money stays integer paise. Offer maths (discount amount, profit after discount) lives as pure
  functions in the offer domain file so it is unit-testable.
- Routes `/offers`, `/feedback`, `/enquiries` added to `AppPaths`/`AppRoutes`, the router and the
  navigation registry (More hub), gated by category/permission like existing pages.
- Feedback capture page is served from the existing customer web surface (`web/m/`) with the shop
  key in the URL, matching the QR menu pattern; ratings sync through the existing ordering cloud
  API when a cloud shop exists, otherwise stay local to the owner's device.
- Bill screen gains an offer chip row and a feedback QR block in the receipt footer options.
- All strings in `app_en.arb` / `app_ta.arb`; `test/l10n_keys_test.dart` enforces parity.
- Tests: offer discount/profit maths, redemption counting, feedback averages and routing of
  happy vs unhappy, enquiry follow-up filtering and won/lost transitions.
- Verify with `flutter gen-l10n`, `flutter analyze --no-pub`, `flutter test --no-pub`, then
  `scripts/build-web.sh`; update `roadmap.md`.

Phase 3 (weekday patterns, item profitability, cost-rise alerts, festival calendar, year view,
renewal reminders) stays untouched until this ships.

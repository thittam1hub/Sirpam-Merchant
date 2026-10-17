# Navigation audit and fixes

Short answer: the foundation is good (one route table, typed link builders, safe query parsing, deep links registered), but four real problems break industry-standard behaviour today.

## What is already right

- One source of truth for paths (`AppPaths`), typed builders (`AppRoutes`), and validated query parsing (`AppQueryParsing`) — no hand-written URLs.
- Tab shell keeps per-tab state; unknown URLs land on a proper "not found" screen with a Home action.
- Android registers both `vendoros://app/...` and `https://vendoros.app/...`.

## What is broken

1. **Back navigation is destroyed on most screens.** Around 25 places call `context.go(...)` to open a child screen (orders → bill, product list → product, home → every shortcut). `go` replaces the stack, so the phone back gesture leaves the screen instead of returning to where the user came from.
2. **Some screens have no URL at all.** Add/edit product and a few pickers are opened with raw `MaterialPageRoute` pushes, so they can't be deep-linked, shared, or restored, and they bypass the route table.
3. **Deep links dead-end.** Opening `/bill/<id>` or `/settle?customer=...` from a QR, notification or browser starts with an empty history — back exits the app instead of going to a sensible parent.
4. **Screen state is not in the URL.** Product search/low-stock filter, insights window, order board filter and market search live only in widget state, so a shared or reopened link loses context.

Smaller items: two hardcoded `'/settings'` strings, inconsistent back buttons in the top bar, no unsaved-changes guard on forms, and `assetlinks.json` is not hosted yet so `https://vendoros.app` links still show the browser chooser.

## The fix

**Navigation semantics**
- Use `push` for every child/detail screen, `go` only for switching the four main tabs and for "finish and return to list" endings.
- Every non-tab screen gets the standard back control in the top bar, plus correct gesture/hardware back.
- Deep-linked child screens get a parent entry synthesised so back always reaches the owning list or Home, never an exit.

**Real routes for every screen**
- Add `/products/new`, `/products/:id/edit`, and route the remaining raw pushes through the route table so each screen has a shareable URL.
- Replace the hardcoded settings strings with the typed builder.

**URL-driven state**
- Reflect list search, low-stock filter, insights window, order-board filter and market search into query parameters, and read them back on open so a link restores the exact view.

**Forms and data safety**
- Unsaved-changes confirmation on product, merchant onboarding and settle forms before back or tab switch, with predictive-back support on Android.

**Link ownership**
- Host `.well-known/assetlinks.json` for the web domain so Android verifies app links and opens them directly; document the same for the customer menu domain and iOS universal links.

**Verification**
- Extend `routes_test.dart` to cover every builder round-trip, malformed query fallbacks, and a back-stack test per deep-linked screen; run the analyzer and full test suite.

## Technical notes

- `push` vs `go` distinction enforced through `StatefulShellRoute` branch rules; child routes stay on `rootNavigatorKey`.
- Deep-link parent synthesis via a router-level initial-stack helper keyed off the matched route, avoiding per-page `canPop` checks like the one in `settle_page.dart`.
- Query state uses `context.replace` on filter change so filters don't pile up in history.
- `AppQuery` gains keys for the new parameters; all reads keep going through `AppQueryParsing`.

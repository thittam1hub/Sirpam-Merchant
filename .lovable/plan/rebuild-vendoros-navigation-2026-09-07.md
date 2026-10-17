# Rebuild VendorOS navigation

## Goal

Replace the current four utility-focused tabs and ungrouped rail with a work-focused navigation system that makes daily operations easy to reach, keeps all existing links working, and gives paired staff phones only the areas relevant to their role and permissions.

## Owner navigation

### Phone bottom tabs

Use five stable destinations:

1. **Home** — current voice ledger, today’s collection, and a reduced set of contextual shortcuts.
2. **Orders** — live order board.
3. **Sales** — a focused sales hub for quick sale, payment collection, credit, and soundbox status.
4. **Stock** — stock overview with direct access to products, scanning, batches, suppliers, and labels; hidden/replaced with the most relevant work area for businesses that do not use inventory.
5. **More** — grouped access to reports, customers, staff, growth tools, business tools, and settings.

Each tab keeps its own navigation history. Switching tabs returns to the last screen used in that tab; selecting the active tab returns to that tab’s root.

### Tablet and desktop sidebar

Replace the current four-item rail and footer actions with a collapsible, scrollable sidebar:

- **Overview:** Home, Dashboard
- **Sell:** Orders, Sales, Credit, Soundbox
- **Inventory:** Stock, Products, Scan, Batches, Suppliers, Labels
- **Customers & operations:** Customers, Menu, Recipes, Jobs, Events
- **Business:** Expenses, Day close, Insights, Loan report, Market, Cart location
- **Team:** Staff, Roles & access, Audit, Devices
- **Grow:** Growth, Checklist, Shop type, Plan
- **System:** Settings and Help

Tablet uses an icon rail with tooltips and a visible expand control. Desktop uses grouped labels, supports collapse to the icon rail, highlights the active route (including child/detail screens), and keeps the active group open. Business-type rules hide irrelevant groups and destinations.

## Role-specific staff navigation

Build navigation from the paired device’s server-synced permissions rather than showing the owner structure and merely blocking taps:

- **Waiter:** Menu/order entry first, then only permitted order/customer actions.
- **Kitchen:** KOT first, with permitted order status and recipe/preparation views.
- **Counter:** Orders first, with permitted sales, billing, credit, and payment views.

On phones, show up to four allowed work tabs plus **More** only when additional permitted destinations exist. On larger screens, show the same allowed destinations in a compact sidebar. Owner-only areas such as settings, roles, devices, profit reports, and stock changes never appear unless the synced permission set explicitly allows them. A safe single-work-screen fallback remains when a role has only one destination.

## Navigation behavior

- Create one navigation registry containing labels, icons, route families, business eligibility, device-role eligibility, and required permissions; generate bottom tabs, sidebar groups, and More from it to prevent drift.
- Preserve every existing public/deep-link URL. Reorganize route ownership without renaming links.
- Keep detail and task flows contextual: bills, product editing, settlement, role editing, and similar screens open from their owning section with correct back behavior.
- Keep bottom navigation visible on section roots and normal work screens; hide it for focused forms, scanners, confirmation flows, and full-screen tasks. The wide sidebar remains available where safe.
- Replace the floating “More” button and its duplicate shortcuts with the fifth tab/grouped menu.
- Reduce the oversized shortcut grid on Home so it shows status and high-priority actions rather than duplicating the entire app menu.
- Maintain English/Tamil labels, minimum touch targets, semantic selected states, keyboard navigation, tooltips in collapsed mode, haptics, text scaling, and reduced-motion compatibility.

## Technical implementation

- Refactor `AppShell`, the router shell branches, bottom navigation, and side navigation around the shared registry.
- Add small Sales and More hub screens where a tab needs a stable root; compose them from existing features without changing business logic or data storage.
- Derive the active section from the current matched route so nested screens highlight the correct tab/sidebar item.
- Read paired-device role and effective permissions through the existing device/access controllers; no client-only privilege assumptions.
- Add any new English and Tamil localization keys and regenerate localization output.
- Do not change current backend schemas or feature logic as part of this navigation rebuild.

## Verification

- Add widget tests for the five owner tabs, tab history, active-tab reset, More groups, collapsed/expanded sidebar, and active-route highlighting.
- Add role/permission matrix tests proving waiter, kitchen, and counter devices see only allowed destinations.
- Test inventory and non-inventory business profiles.
- Test deep links and back behavior for Orders/Bill, Stock/Product, Credit/Settlement, Settings, and staff entry routes.
- Run localization parity checks, route tests, analyzer, full Flutter tests, and responsive checks at phone, tablet, and desktop widths including 320 dp and 2.0 text scale.

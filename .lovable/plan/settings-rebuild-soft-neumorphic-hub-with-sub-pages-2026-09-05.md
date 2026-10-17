# Settings rebuild: soft neumorphic hub with sub-pages

## Does the app match the reference?

Partly. The app already uses the same soft-UI recipe: one light canvas (#E3E7EE), raised surfaces with a white top-left light and a soft blue-grey bottom-right shadow, recessed input wells, and no hard borders. What the reference does better, and what this rebuild adopts:

- Larger corner radii and more breathing room between cards (the current settings screen is one long stack of near-identical boxes).
- Fewer, bigger elements per screen instead of 12+ fields on one page.
- A single warm accent used sparingly (one CTA / one live indicator per screen) rather than accent text on many controls.
- Softer, wider shadow spread with lower contrast, plus a subtle top highlight on raised cards.
- Pill-shaped toggles and segmented selectors as physical, pressable objects.

## What changes

Today everything (language, business profile, shop identity, UPI, market source, API key, soundbox) lives on one scrolling form with a single Save at the bottom. It becomes a compact hub of tappable rows, each opening its own focused page.

### Settings hub (`/settings`)
Grouped cards, each row showing an icon, a title, and its current value as a subtitle:

- Language & display — current language
- Business profile — category, niche, district
- Shop details — stall name, owner, phone
- Payments & UPI — VPA, soundbox on/off
- Market prices — chosen market, key set / not set
- Connected devices & cloud — links to existing printers, merchant onboarding, help pages

No Save button on the hub; each sub-page saves its own section.

### Sub-pages, deep links and query URLs

| Page | Path | Query params |
| --- | --- | --- |
| Language | `/settings/language` | — |
| Business profile | `/settings/profile` | `?focus=niche\|district\|fssai\|udyam` |
| Shop details | `/settings/shop` | `?focus=stall\|owner\|phone` |
| Payments & UPI | `/settings/payments` | `?focus=vpa`, `?soundbox=on\|off` |
| Market prices | `/settings/market` | `?market=<name>`, `?focus=key` |

Each is a typed route with a name, reachable cold from a URL, with correct back navigation to the hub (and hub back to where the user came from). Unknown or invalid query values fall back to current settings instead of erroring. Unsaved edits prompt before leaving, matching the existing dirty-form behaviour used on product forms.

## Technical notes

- Add `AppPaths` entries and `GoRoute` children under the existing settings route in `lib/app/router.dart`; parse query params in the route builder and pass them as typed constructor args (no `context.query` reads inside widgets).
- Split `settings_page.dart` into `settings_hub_page.dart` plus `language_page.dart`, `profile_page.dart`, `shop_page.dart`, `payments_page.dart`, `market_page.dart` under `lib/features/settings/presentation/`. Shared row/section widgets go in `settings_widgets.dart`.
- Extend `lib/core/theme/neu_theme.dart` with softer shadow presets (wider blur, lower alpha, larger radius token) and add a `NeuTile` row component to `neu_chrome.dart` so the new look is token-driven and reusable elsewhere. No hardcoded colours in pages.
- Reuse `settingsProvider` and `profileProvider`; each sub-page saves only its own fields via `copyWith`, so no cross-section overwrites.
- All new labels go into the English and Tamil ARB catalogs; localization parity check must stay green.
- Respect responsive window classes: single column on phone, two-column card grid on tablet/desktop, content width capped.
- Tests: route/query parsing for every new path (including invalid values), a save-isolation test per section, and hub navigation. Run `npm run check`.

## Out of scope

Redesigning other screens to the refreshed shadow scale; that can follow once the tokens are proven here.

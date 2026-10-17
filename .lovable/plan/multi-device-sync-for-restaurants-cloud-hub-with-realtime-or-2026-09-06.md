# Multi-Device Sync for Restaurants — Cloud Hub with Realtime Orders

Turn 3+ phones (waiter / cook / counter) into one coordinated restaurant system using the industry-standard cloud-hub pattern on Supabase.

## Why cloud hub (not local WiFi sync)

- Local-only sync (one phone as hub) breaks when the hub phone locks, dies, or the router blocks device-to-device traffic — events get lost. Not industry standard.
- Cloud hub = single source of truth in Supabase; every device writes to it, all devices get live updates. Durable offline queues on each phone mean nothing is lost without internet — events replay on reconnect. This is how Square, Toast, Petpooja and Posist do it.

## What already exists (build on it)

- `docs/sql/ordering_cloud.sql` applied: orders, status RPCs, shop keys, realtime publication
- `OrderSyncController` with 8s polling, offline replay of counter orders and status pushes
- Role-based access (waiter/cook/cashier roles, PIN sign-in, audit trail)

## Stage A — Realtime order sync (replaces polling on the board)

1. Supabase: verify `orders` and `service_requests` are in the realtime publication; add `ALTER PUBLICATION` if missing; confirm RLS allows shop-key-scoped reads needed by realtime subscriptions (realtime respects RLS — use the existing shop-scoped policies).
2. `OrderingApi`: add `subscribeBoard(slug, shopKey)` returning a Supabase Realtime stream of order inserts/updates + service requests for the shop.
3. `OrderSyncController`: replace the 8-second board `Timer` with the realtime stream; keep a slow 60s fallback poll for resilience; keep offline replay logic unchanged. Connection state (connected/reconnecting/offline) shown on the board with a stale warning.

## Stage B — Multi-device pairing to one shop

1. Owner flow: in `/settings/ordering` (or a new `/devices` page), the owner generates a **6-digit device-pairing code** per extra phone.
2. Supabase: `devices` table (shop_id, device name, role hint, key hash, active, last_seen_at) + `device_pair(code)` RPC that exchanges a valid code for a device credential scoped to the same shop. Codes expire after 15 minutes, single-use.
3. Device flow on the new phone: enter shop slug + pairing code → app stores the device credential in `LocalStore` → device syncs to the same shop board.
4. Owner can see paired devices (name, role, last seen) and revoke any device; revoked devices stop syncing immediately (RLS denies their key).

## Stage C — Role-aware device defaults

1. During pairing (or first launch after pairing), the device picks its primary role: **Waiter** (opens on menu/order-taking), **Kitchen** (opens on KOT board), **Counter** (opens on orders board + billing).
2. Device home is stored locally; worker PIN sign-in still gates actions per the existing access-control system.
3. Audit entries record the device id alongside the worker identity so the owner can see which phone did what.

## Stage D — Pro gating and limits

1. Multi-device sync is a Pro feature: Free = single device + local orders; Pro = up to N devices (start with 5 per shop, enforced in `device_pair` RPC by checking `shop_plan_active`).
2. Plan page copy updated; `PlanGate` wraps device pairing and realtime sync activation.

## Stage E — UX, localization, docs, tests

1. Tamil + English ARB strings for pairing, device list, connection status, role defaults.
2. Neumorphic UI consistent with the settings redesign; responsive on phones and tablets.
3. Docs: update `docs/ORDERING_BILLING.md` with the multi-device model.
4. Tests: pairing-code expiry/single-use (SQL logic reviewed + unit coverage of controller), realtime merge dedup (existing `ingestRemote` tests extended), offline replay across reconnect, PlanGate enforcement, route tests for `/devices`, l10n key parity.

## Out of scope (later)

- Local WiFi hub sync, cross-shop chains, per-device offline-first full catalog caching, push notifications (FCM) to ring the kitchen phone.

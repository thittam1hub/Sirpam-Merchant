# Roles, responsibilities and access control

Owner creates every role from scratch and decides, permission by permission, what each role can see and do. Everything works offline on the shop device.

## Sign-in: my recommendation

You asked for other ideas. Best fit for a stall or hotel counter is a **shift-based PIN lock on the shop device**, because the phone is shared and there is no time to log in and out all day:

- The owner adds a worker (reuses the existing worker list) and gives them a 4-digit PIN.
- Opening the app shows "Who is working?" — tap a face/name, enter PIN, the shift starts.
- The app stays unlocked for that worker until the shift is ended, the app is idle for a set time (owner picks: 5 / 15 / 60 minutes / never), or someone taps "Switch worker".
- **Owner override**: any blocked action offers "Ask owner" — the owner types their PIN once, the action goes through, and it is recorded as owner-approved. No need to end the worker's shift.
- **Panic recovery**: the owner's PIN can always reset any worker PIN. If the owner forgets theirs, a recovery phrase set at first setup unlocks it.
- Own-phone accounts (each worker logging in on their own phone over the internet) stay a later step; the same role definitions will carry over unchanged.

## Roles: fully custom

- Start empty with a "New role" button. Name it in Tamil or English, pick a colour, write a short responsibility line ("Takes counter orders, no discounts").
- A permission sheet groups every action by area: Sales, Orders & kitchen, Billing, Credit, Stock, Purchases & expenses, Money & reports, Customers, Staff, Settings & cloud.
- Each permission is off by default; the owner ticks what that role may do. Sensitive ones read plainly: "Give discount", "Cancel a bill", "See day takings", "See profit and cost price", "Give credit", "Settle credit", "Change prices", "Reprint bill", "Close the day", "Pay wages", "Edit shop settings".
- Money limits per role: max discount per bill, max credit per customer, max cash refund. Above the limit the action still works but needs the owner PIN.
- Duplicate a role to make a variant; deactivate a role without deleting history.
- The Owner role always exists, holds every permission, and cannot be edited or deleted — otherwise the shop can lock itself out.

## What changes around the app

- Every screen and shortcut the role cannot use is hidden, not greyed out, so the counter stays simple. Direct links to a blocked screen show "Ask the owner for access".
- Blocked buttons inside a screen (discount, void, settle) show the "Ask owner" prompt instead of disappearing.
- The current worker's name shows in the top bar; tapping it switches worker or ends the shift.
- Every sale, bill, void, discount, credit entry, stock change and settlement records who did it and, if approved, who approved it.
- New "Who did what" log under Staff: filter by worker, day, and action type; day close shows takings by worker so cash handovers match.
- Attendance can start automatically from the shift sign-in, so a worker signing in marks themselves present.

## Technical notes

- New feature folder `lib/features/access/`: `domain/permission.dart` (a flat enum of permissions grouped by area, tolerant JSON like the existing models), `domain/role.dart` (id, name, colour, note, permission set, limit fields, active), `domain/shift_session.dart`, and `application/access_controller.dart` (Riverpod `Notifier`).
- `Worker` gains `roleId`, `pinHash`, `pinSalt`; PINs stored as a salted SHA-256 hash, never plain. Existing worker rows without these fields keep working (tolerant parsing, treated as no access until the owner assigns a role).
- `LocalStore` gains `vendoros.roles.v1`, `vendoros.access.v1` (owner PIN hash, idle timeout, recovery phrase hash) and `vendoros.audit.v1`, following the existing `_readList` / `_writeList` pattern.
- Gate helpers: `ref.watch(canProvider(Permission.voidBill))` plus a `PermissionGate` widget and a `requirePermission(context, ref, perm)` call that returns true, or opens the owner-PIN sheet and returns its result.
- Router: a `redirect` on protected routes sends a blocked worker to an "Ask for access" page rather than a blank screen; `/roles`, `/roles/new`, `/roles/:id`, `/access` (PIN and lock settings), `/audit?worker=…&day=…` as typed routes with query parsing, matching the existing navigation standard.
- Audit entries are append-only records `{id, ts, workerId, approvedByWorkerId, action, refType, refId, amountPaise, note}` written from the existing controllers (ledger, orders, bills, credit, stock, expenses) through one `audit.record(...)` call.
- All new strings go into `lib/l10n/app_en.arb` and `app_ta.arb` with the existing plural/placeholder conventions; neumorphic tokens and responsive layout reused, no hardcoded colours or text.
- Tests: permission-set JSON round-trip, PIN hash/verify, owner role immutability, limit-triggered approval path, gate hides/shows, audit append and filtering, and blocked-route redirect.

## Not in this step

Own-phone worker accounts over the internet, cloud sync of roles across devices, biometric unlock, and per-worker sales commission.

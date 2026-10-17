# Benchmark against the apps shops actually use — and close the last gaps

I checked the apps Indian shops and restaurants are compared against today:

- Billing / khata phone apps: Vyapar, myBillBook (mobile-first billing, GST, WhatsApp bill sharing, barcode stock) — [1](https://aidukan.in/vyapar-vs-mybillbook-india/), [2](https://stackpicker.in/compare/mybillbook-vs-vyapar), [3](https://aidukan.in/billing-software-retail-shop-india/)
- Restaurant systems: Petpooja, Restroworks (3-click billing, dynamic payment QR on the bill, raw-material and central-kitchen stock) — [4](https://www.petpooja.com/billing-pos), [5](https://www.petpooja.com/poss/restaurant-inventory-management-software), [6](https://reelo.io/blog/petpooja-and-posist-two-top-rated-pos-systems-in-india/)

## Where we already match them

Quick billing, GST with HSN and slab-wise reports, inventory with batches and expiry, purchase bills and supplier dues, credit book, order board and kitchen tickets, QR menu, receipts on thermal printers, staff roles with PIN approval, offers, feedback, day close, six languages, backup and CSV export.

## The remaining gaps worth closing

1. **Automatic online backup.** Today backup is a file the owner shares by hand. Competitors back up to the cloud on their own. Add a daily automatic backup of the same checksummed bundle to Lovable Cloud, with a "last backed up" line and one-tap restore.
2. **Staff permissions enforced by the server.** Right now the owner's phone enforces roles; a paired waiter or kitchen phone is only limited by its role name. Publish the owner's roles to the cloud and have every paired-phone request check them.
3. **Send the bill on WhatsApp in one tap from the bill screen** (we share text/PDF, but not as a single named action with the customer's number pre-filled).
4. **Pro purchase inside the app.** Still needs a payment account; blocked until you provide one.

## Proposed order

Automatic cloud backup first (owners lose data on lost phones), then server-side permissions, then one-tap WhatsApp bill. Pro purchase stays parked.

## Technical notes

- Backup: new `shop_backups` table keyed by shop slug + device key, storing the existing `BackupBundle` JSON with its checksum; a scheduled local task uploads once a day and on day close. Restore reuses the current validator, so damaged files still fail safely.
- Permissions: `shop_roles` table + owner publish RPC + device profile RPC; paired-device RPCs re-check permission before acting, falling back to today's `role_hint` when a shop has not published roles. This needs a database migration applied to the connected project.
- No change to local-first behaviour: everything keeps working offline and syncs when the phone is back online.

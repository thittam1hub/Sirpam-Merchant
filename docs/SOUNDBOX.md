# VendorOS soundbox — architecture and setup

Two independent paths announce a payment. The first is authoritative; the
second is a best-effort fallback for vendors on a personal VPA.

## 1. Business UPI soundbox (server-confirmed, never misses)

```text
customer pays  ->  NPCI  ->  payer PSP  ->  merchant PSP (PhonePe / Paytm)
                                              |
                                   signed webhook (HTTPS)
                                              v
                          Supabase: verify signature -> upi_payments
                                              |
                          phone polls payment_feed (8 s + on open)
                                              v
                          speak (TTS) -> write to ledger -> payment_ack
```

Why it cannot miss: the server is the source of truth. A payment stays in the
device's feed until that device explicitly acknowledges it, so a dead battery,
an app kill, a week offline, or a failed TTS call only delays the
announcement — it never drops it. `upi_payments` is unique on
`(provider, provider_txn_id)`, so a PSP retrying its webhook cannot double-count,
and `payment_acks` is unique per `(device, payment)`, so a payment is never
spoken twice. Announce → ledger → ack happens in that order and the queue is
persisted on device before each ack.

### Database surface

| Object | Purpose |
| --- | --- |
| `public.merchants` | one business: provider, merchant ref, VPA, pairing code |
| `public.devices` | each paired phone: hashed device key, push token, last seen |
| `public.upi_payments` | confirmed payments, idempotent per provider txn id |
| `public.payment_acks` | which device has already announced which payment |
| `private.psp_credentials` | PhonePe salt key / Paytm webhook token (no app access) |

All tables are RLS-locked to `service_role`. The app never reads them
directly; it calls six `SECURITY DEFINER` RPCs that each enforce their own
credential:

| RPC | Caller | Credential checked |
| --- | --- | --- |
| `phonepe_webhook(response)` | PhonePe | `X-VERIFY` = `sha256(body + saltKey)###saltIndex` |
| `paytm_webhook(head, body)` | Paytm | `X-Webhook-Token` header per merchant |
| `device_pair(pairing_code, ...)` | phone | one-time pairing code |
| `payment_feed(device_key)` | phone | device key (sha256-hashed at rest) |
| `payment_ack(device_key, ids)` | phone | device key |
| `device_heartbeat(device_key)` | phone | device key |

The database linter flags these six as "anon can execute". That is by design:
a payment provider can only send its own signature, and an unpaired phone can
only send a pairing code. The anon key alone grants nothing.

### Onboarding a merchant

1. Get a business UPI account (PhonePe for Business / Paytm for Business) and
   note the **merchant ID** and, for PhonePe, the **salt key + salt index**.
2. Insert the merchant and its credentials (SQL editor):

   ```sql
   with m as (
     insert into public.merchants (name, provider, merchant_ref, vpa, pairing_code)
     values ('Sirpam Vendor', 'phonepe', 'M22XXXXXXXX', 'sirpam@ybl', 'SIRPAM-4821')
     returning id
   )
   insert into private.psp_credentials (merchant_id, phonepe_salt_key, phonepe_salt_index)
   select id, '<salt key>', '1' from m;
   ```

3. Configure the callback URL in the PSP dashboard:

   ```text
   PhonePe: https://wweqscxogeybgbybvapn.supabase.co/rest/v1/rpc/phonepe_webhook?apikey=<anon key>
   Paytm:   https://wweqscxogeybgbybvapn.supabase.co/rest/v1/rpc/paytm_webhook?apikey=<anon key>
            (plus header X-Webhook-Token: <paytm_webhook_token>)
   ```

4. In the app: Soundbox → enter the pairing code → **Link phone**. The phone
   receives a device key stored only on that device (the server keeps only its
   SHA-256 hash).

### Health

The card shows the last successful server contact and the queue depth, and
warns after 10 minutes without contact instead of pretending to be healthy.

### Still open

- **FCM push** — delivery is currently poll-based (8 s while the app is open,
  plus on open). High-priority FCM data messages will make announcements
  instant and wake the app in the background; this needs a Firebase project
  and `google-services.json`.
- **Paytm signature** — Paytm's checksum must be computed over the exact raw
  request body, which a PostgREST RPC never sees. Paytm is therefore
  authenticated with a per-merchant webhook token over TLS. PhonePe is fully
  signature-verified.

## 2. Notification soundbox (fallback, Android only)

`UpiNotificationListener` (Kotlin `NotificationListenerService`) forwards the
package name, title and text of every notification over the
`vendoros/soundbox/events` EventChannel. Dart keeps PhonePe / Paytm / Google
Pay / BHIM, rejects debit wording, extracts `₹ / Rs / INR` amounts and speaks
them.

This path is best-effort by nature: OEM battery managers kill the listener,
Do-Not-Disturb suppresses the event, and payment apps change their wording.
Use it only when the vendor collects on a personal VPA. It is unavailable on
iOS and on the web.

## Self-service merchant onboarding (in app)

- Route `/merchant` (`MerchantOnboardingPage`): the vendor picks the provider,
  types the business name, business UPI address, merchant id (MID) and the
  provider secret (PhonePe salt key + index, or a Paytm webhook token).
- `public.merchant_register(...)` (SECURITY DEFINER, anon-executable) validates
  the input, creates the `public.merchants` row, writes the secret to
  `private.psp_credentials` (never readable by the app) and returns a freshly
  generated pairing code.
- The app immediately calls `device_pair` with that code, so the phone is
  linked in one step; the code is shown so a second phone can be paired later.
- The page also prints the callback URL to paste into the provider dashboard.
- Route `/help` (`HelpPage`) is the in-app guide: why a business UPI account is
  needed, KYC documents, how to register with PhonePe/Paytm for Business, where
  the MID and salt key live, and how to link phones. All copy is in the ARB
  catalogs (English + Tamil) — the guide lives in the codebase, not the DB.

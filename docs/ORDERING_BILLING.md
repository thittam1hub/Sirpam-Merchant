# Ordering, billing & printing

QR menu -> customer order -> vendor board -> bill -> print -> ledger / stock /
day close. Money is integer paise everywhere; all bill and ESC/POS logic is pure
and unit tested (`test/ordering_billing_test.dart`).

## Where each part runs

| Part | Lives in |
| --- | --- |
| Customer menu (no app install) | static page `web/m/index.html`, served at `/m/<slug>?t=<table>` |
| Vendor order board, KOT, billing, printers | Flutter app (`/orders`, `/kot`, `/bill/:orderId`, `/menu`, `/printers`) |
| Shared order state | local JSON today; Lovable Cloud when the database TODO below is applied |

## Flutter modules

- `features/orders/domain/order.dart` — order/line model, status machine
  (`kOrderTransitions`), daily token series (`nextToken`).
- `features/orders/application/order_controller.dart` — place / edit / merge /
  cancel / settle, bill numbering, day summary, FIFO stock + ledger writes.
- `features/orders/domain/shop_config.dart` — slug, menu base URL, table count,
  published & sold-out ids, tax percent, GSTIN, `menuUrl(table)`.
- `features/billing/domain/bill.dart` — `BillMath` (discount, tax, 50-paise
  rounding, split-tender balance) and `Bill`.
- `features/printing/domain/receipt.dart` / `escpos.dart` — receipt layout for
  58 mm / 80 mm, plain-text render, ESC/POS byte builder.
- `features/printing/application/receipt_printer.dart` — send to printer, or
  fall back to PDF / share.

## Printing status

ESC/POS bytes are built for both roll widths and unit-snapshot tested. Bluetooth
and USB transports are configured in `/printers` but the native channel is not
wired yet, so a send returns `PrintOutcome.fellBackToPdf` and the vendor gets the
PDF/share sheet. No vendor is ever blocked from handing over a receipt.

## Day close & insights

`OrderController.summaryFor(day)` feeds the day-close screen: orders taken,
cancelled, still open, billed total and average ticket.

## Database TODO (apply when the ordering backend is connected)

Not applied yet — deliberately. When the cloud database is switched on, run this
migration, then fill `web/m/config.js` with the project URL and the publishable
(anon) key. Never put a secret key in that file.

```sql
create table public.shops (
  id uuid primary key default gen_random_uuid(),
  slug text unique not null,
  name text not null,
  vpa text, gstin text, fssai text,
  is_open boolean not null default true,
  device_key text not null,
  created_at timestamptz not null default now()
);
grant select on public.shops to anon, authenticated;
grant all on public.shops to service_role;
alter table public.shops enable row level security;
create policy "open shops are public" on public.shops
  for select to anon using (is_open);

create table public.menu_items (
  id uuid primary key default gen_random_uuid(),
  shop_id uuid not null references public.shops(id) on delete cascade,
  product_ref text,
  name text not null,
  name_ta text,
  category text,
  price_paise integer not null check (price_paise >= 0),
  available boolean not null default true,
  sort integer not null default 0
);
grant select on public.menu_items to anon, authenticated;
grant all on public.menu_items to service_role;
alter table public.menu_items enable row level security;
create policy "menu of open shops is public" on public.menu_items
  for select to anon using (
    exists (select 1 from public.shops s where s.id = shop_id and s.is_open)
  );

create table public.orders (
  id uuid primary key default gen_random_uuid(),
  shop_id uuid not null references public.shops(id) on delete cascade,
  token integer not null,
  table_label text not null default '',
  status text not null default 'placed',
  source text not null default 'qr',
  customer_name text not null default '',
  customer_phone text not null default '',
  subtotal_paise integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create table public.order_items (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references public.orders(id) on delete cascade,
  menu_item_id uuid not null references public.menu_items(id),
  name text not null,
  price_paise integer not null,
  qty integer not null check (qty > 0 and qty <= 99),
  note text not null default ''
);
grant select, insert, update on public.orders, public.order_items to authenticated;
grant all on public.orders, public.order_items to service_role;
alter table public.orders enable row level security;
alter table public.order_items enable row level security;
-- No anon table policies: customers write only through the RPC below.

-- Customer read: menu for a slug.
create or replace function public.menu_for_shop(p_slug text)
returns jsonb language sql stable security definer set search_path = public as $$
  select jsonb_build_object(
    'shop', jsonb_build_object('name', s.name, 'open', s.is_open, 'slug', s.slug),
    'items', coalesce((
      select jsonb_agg(jsonb_build_object(
        'id', m.id, 'name', m.name, 'category', m.category,
        'price_paise', m.price_paise, 'available', m.available)
        order by m.sort, m.name)
      from public.menu_items m where m.shop_id = s.id), '[]'::jsonb))
  from public.shops s where s.slug = p_slug and s.is_open;
$$;
grant execute on function public.menu_for_shop(text) to anon, authenticated;

-- Customer write: prices are recomputed here, never trusted from the client.
create or replace function public.place_menu_order(
  p_slug text, p_table text, p_name text, p_phone text, p_items jsonb)
returns jsonb language plpgsql security definer set search_path = public as $$
declare v_shop uuid; v_order uuid; v_token int;
begin
  select id into v_shop from public.shops where slug = p_slug and is_open;
  if v_shop is null then raise exception 'shop closed'; end if;
  if jsonb_array_length(p_items) not between 1 and 40 then
    raise exception 'bad basket'; end if;

  select coalesce(max(token), 0) + 1 into v_token from public.orders
   where shop_id = v_shop and created_at::date = current_date;

  insert into public.orders (shop_id, token, table_label, source,
                             customer_name, customer_phone)
  values (v_shop, v_token, left(coalesce(p_table, ''), 8), 'qr',
          left(coalesce(p_name, ''), 40), left(coalesce(p_phone, ''), 15))
  returning id into v_order;

  insert into public.order_items (order_id, menu_item_id, name, price_paise, qty, note)
  select v_order, m.id, m.name, m.price_paise,
         least(greatest((i->>'qty')::int, 1), 99), ''
    from jsonb_array_elements(p_items) i
    join public.menu_items m
      on m.id = (i->>'id')::uuid and m.shop_id = v_shop and m.available;

  update public.orders o set subtotal_paise = (
    select coalesce(sum(price_paise * qty), 0) from public.order_items
     where order_id = v_order) where o.id = v_order;

  return jsonb_build_object('token', v_token, 'order_id', v_order);
end $$;
grant execute on function public.place_menu_order(text, text, text, text, jsonb)
  to anon, authenticated;
```

Prompt to use later: "Apply the ordering migration in docs/ORDERING_BILLING.md,
then wire OrderController to sync orders through Cloud realtime with the existing
device-key scoping and the offline replay queue."

## Remaining

- Native Bluetooth / USB ESC/POS transport.
- Cloud sync + realtime board (after the migration above).
- Soundbox auto-settlement of a matching open bill.

## Multi-device (waiter / kitchen / counter phones)

The owner's phone holds the shop key. Each extra phone pairs once from
`/devices` (owner side: generate a 6-digit code, 15-minute expiry, single use,
max five phones, Pro plan; staff side: enter shop slug + code and pick the
role). The phone receives its own device key — the shop key never leaves the
owner's phone, and revoking a phone from `/devices` cuts it off instantly.

After pairing, a phone opens on its role's working screen: waiter → `/menu`
(takes orders), kitchen → `/kot` (sees tickets, marks preparing/served),
counter → `/orders` (billing, mark paid). All phones share one cloud board:
every device polls with its own credential and replays offline work when the
network returns, so no order or status change is lost.

Deep links: `/devices` (hub), `/devices?pair=1` (staff pairing form).

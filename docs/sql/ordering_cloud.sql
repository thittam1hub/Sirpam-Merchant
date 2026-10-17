-- Ordering backend for the QR menu and the live order board.
-- Apply with the database migration tool (or paste into the SQL editor).
--
-- Trust model: the customer menu is anonymous and read-only; the vendor phone
-- authenticates every write with a shop key that only travels as an RPC
-- argument. Only its digest is stored and no table is writable through the
-- Data API -- all mutations go through SECURITY DEFINER functions.

create extension if not exists pgcrypto;

create table if not exists public.shops (
  id            uuid primary key default gen_random_uuid(),
  slug          text not null unique check (slug ~ '^[a-z0-9][a-z0-9-]{1,38}$'),
  name          text not null default '',
  key_hash      text not null,
  is_open       boolean not null default true,
  tax_percent   numeric(5,2) not null default 0,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);

create table if not exists public.menu_items (
  id            uuid primary key default gen_random_uuid(),
  shop_id       uuid not null references public.shops(id) on delete cascade,
  ext_id        text not null,
  name          text not null,
  category      text not null default '',
  price_paise   integer not null check (price_paise >= 0),
  available     boolean not null default true,
  published     boolean not null default true,
  sort          integer not null default 0,
  updated_at    timestamptz not null default now(),
  unique (shop_id, ext_id)
);

create table if not exists public.orders (
  id             uuid primary key default gen_random_uuid(),
  shop_id        uuid not null references public.shops(id) on delete cascade,
  token          integer not null,
  table_label    text not null default '',
  source         text not null default 'qr' check (source in ('qr', 'counter')),
  status         text not null default 'placed'
                 check (status in ('placed','preparing','served','paid','cancelled')),
  customer_name  text not null default '',
  customer_phone text not null default '',
  cancel_reason  text not null default '',
  subtotal_paise integer not null default 0,
  created_at     timestamptz not null default now(),
  updated_at     timestamptz not null default now()
);
create index if not exists orders_shop_updated_idx
  on public.orders (shop_id, updated_at desc);

create table if not exists public.order_items (
  id            uuid primary key default gen_random_uuid(),
  order_id      uuid not null references public.orders(id) on delete cascade,
  menu_item_id  uuid references public.menu_items(id) on delete set null,
  ext_id        text not null default '',
  name          text not null,
  price_paise   integer not null check (price_paise >= 0),
  qty           integer not null check (qty between 1 and 99),
  note          text not null default ''
);
create index if not exists order_items_order_idx on public.order_items (order_id);

grant select on public.shops to anon, authenticated;
grant select on public.menu_items to anon, authenticated;
grant all on public.shops, public.menu_items, public.orders, public.order_items
  to service_role;

alter table public.shops enable row level security;
alter table public.menu_items enable row level security;
alter table public.orders enable row level security;
alter table public.order_items enable row level security;

drop policy if exists "public shops are readable" on public.shops;
create policy "public shops are readable" on public.shops
  for select to anon, authenticated using (true);

drop policy if exists "published menu is readable" on public.menu_items;
create policy "published menu is readable" on public.menu_items
  for select to anon, authenticated using (published);

-- orders / order_items carry customer phone numbers: no anon policy at all.

alter table public.menu_items replica identity full;
alter table public.orders replica identity full;
do $$
begin
  begin alter publication supabase_realtime add table public.menu_items;
  exception when duplicate_object then null; end;
  begin alter publication supabase_realtime add table public.orders;
  exception when duplicate_object then null; end;
end $$;

create or replace function public.shop_from_key(p_slug text, p_key text)
returns uuid language sql stable security definer set search_path = public as $$
  select id from public.shops
   where slug = p_slug and key_hash = encode(digest(p_key, 'sha256'), 'hex')
$$;

create or replace function public.shop_register(
  p_slug text, p_key text, p_name text default '', p_tax numeric default 0)
returns jsonb language plpgsql security definer set search_path = public as $$
declare v_id uuid;
begin
  if length(coalesce(p_key, '')) < 16 then raise exception 'weak shop key'; end if;
  select id into v_id from public.shops where slug = p_slug;
  if v_id is null then
    insert into public.shops (slug, name, key_hash, tax_percent)
    values (p_slug, left(coalesce(p_name, ''), 60),
            encode(digest(p_key, 'sha256'), 'hex'), coalesce(p_tax, 0))
    returning id into v_id;
  else
    if public.shop_from_key(p_slug, p_key) is null then
      raise exception 'slug already taken';
    end if;
    update public.shops
       set name = left(coalesce(p_name, name), 60),
           tax_percent = coalesce(p_tax, tax_percent),
           updated_at = now()
     where id = v_id;
  end if;
  return jsonb_build_object('shop_id', v_id, 'slug', p_slug);
end $$;

create or replace function public.menu_publish(
  p_slug text, p_key text, p_items jsonb)
returns integer language plpgsql security definer set search_path = public as $$
declare v_shop uuid; v_count integer;
begin
  v_shop := public.shop_from_key(p_slug, p_key);
  if v_shop is null then raise exception 'unauthorised'; end if;

  insert into public.menu_items
    (shop_id, ext_id, name, category, price_paise, available, published, sort, updated_at)
  select v_shop, i->>'ext_id', left(coalesce(i->>'name', ''), 80),
         left(coalesce(i->>'category', ''), 40),
         greatest((i->>'price_paise')::int, 0),
         coalesce((i->>'available')::boolean, true), true,
         coalesce((i->>'sort')::int, 0), now()
    from jsonb_array_elements(p_items) i
   where coalesce(i->>'ext_id', '') <> ''
  on conflict (shop_id, ext_id) do update
     set name = excluded.name, category = excluded.category,
         price_paise = excluded.price_paise, available = excluded.available,
         published = true, sort = excluded.sort, updated_at = now();

  update public.menu_items set published = false, updated_at = now()
   where shop_id = v_shop
     and ext_id not in (select i->>'ext_id' from jsonb_array_elements(p_items) i);

  select count(*) into v_count from public.menu_items
   where shop_id = v_shop and published;
  return v_count;
end $$;

create or replace function public.menu_set_available(
  p_slug text, p_key text, p_ext_id text, p_available boolean)
returns boolean language plpgsql security definer set search_path = public as $$
declare v_shop uuid;
begin
  v_shop := public.shop_from_key(p_slug, p_key);
  if v_shop is null then raise exception 'unauthorised'; end if;
  update public.menu_items
     set available = coalesce(p_available, true), updated_at = now()
   where shop_id = v_shop and ext_id = p_ext_id;
  return found;
end $$;

create or replace function public.menu_for_shop(p_slug text)
returns jsonb language sql stable security definer set search_path = public as $$
  select jsonb_build_object(
    'shop', jsonb_build_object('name', s.name, 'open', s.is_open, 'slug', s.slug),
    'items', coalesce((
      select jsonb_agg(jsonb_build_object(
               'id', m.id, 'name', m.name, 'category', m.category,
               'price_paise', m.price_paise, 'available', m.available)
               order by m.sort, m.name)
        from public.menu_items m
       where m.shop_id = s.id and m.published), '[]'::jsonb))
  from public.shops s where s.slug = p_slug
$$;

create or replace function public.place_menu_order(
  p_slug text, p_table text, p_name text, p_phone text, p_items jsonb)
returns jsonb language plpgsql security definer set search_path = public as $$
declare v_shop uuid; v_order uuid; v_token integer;
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

  insert into public.order_items
    (order_id, menu_item_id, ext_id, name, price_paise, qty, note)
  select v_order, m.id, m.ext_id, m.name, m.price_paise,
         least(greatest((i->>'qty')::int, 1), 99), ''
    from jsonb_array_elements(p_items) i
    join public.menu_items m
      on m.id = (i->>'id')::uuid and m.shop_id = v_shop
     and m.available and m.published;

  if not exists (select 1 from public.order_items where order_id = v_order) then
    raise exception 'nothing available';
  end if;

  update public.orders o set subtotal_paise = (
    select coalesce(sum(price_paise * qty), 0) from public.order_items
     where order_id = v_order) where o.id = v_order;

  return jsonb_build_object('token', v_token, 'order_id', v_order);
end $$;

create or replace function public.board_feed(
  p_slug text, p_key text, p_since timestamptz default null)
returns jsonb language plpgsql security definer set search_path = public as $$
declare v_shop uuid;
begin
  v_shop := public.shop_from_key(p_slug, p_key);
  if v_shop is null then raise exception 'unauthorised'; end if;
  return coalesce((
    select jsonb_agg(jsonb_build_object(
      'id', o.id, 'token', o.token, 'table', o.table_label,
      'status', o.status, 'source', o.source,
      'name', o.customer_name, 'phone', o.customer_phone,
      'subtotal_paise', o.subtotal_paise,
      'created_at', o.created_at, 'updated_at', o.updated_at,
      'items', coalesce((
        select jsonb_agg(jsonb_build_object(
                 'ext_id', it.ext_id, 'name', it.name,
                 'price_paise', it.price_paise, 'qty', it.qty, 'note', it.note))
          from public.order_items it where it.order_id = o.id), '[]'::jsonb))
      order by o.created_at)
    from public.orders o
   where o.shop_id = v_shop
     and o.created_at > now() - interval '2 days'
     and (p_since is null or o.updated_at > p_since)), '[]'::jsonb);
end $$;

create or replace function public.order_set_status(
  p_slug text, p_key text, p_order uuid, p_status text, p_reason text default '')
returns boolean language plpgsql security definer set search_path = public as $$
declare v_shop uuid;
begin
  v_shop := public.shop_from_key(p_slug, p_key);
  if v_shop is null then raise exception 'unauthorised'; end if;
  update public.orders
     set status = p_status,
         cancel_reason = left(coalesce(p_reason, ''), 120),
         updated_at = now()
   where id = p_order and shop_id = v_shop
     and p_status in ('placed','preparing','served','paid','cancelled');
  return found;
end $$;

create or replace function public.counter_order_push(
  p_slug text, p_key text, p_token integer, p_table text, p_items jsonb)
returns uuid language plpgsql security definer set search_path = public as $$
declare v_shop uuid; v_order uuid;
begin
  v_shop := public.shop_from_key(p_slug, p_key);
  if v_shop is null then raise exception 'unauthorised'; end if;
  insert into public.orders (shop_id, token, table_label, source)
  values (v_shop, p_token, left(coalesce(p_table, ''), 8), 'counter')
  returning id into v_order;
  insert into public.order_items (order_id, ext_id, name, price_paise, qty, note)
  select v_order, coalesce(i->>'ext_id', ''), left(coalesce(i->>'name', ''), 80),
         greatest((i->>'price_paise')::int, 0),
         least(greatest((i->>'qty')::int, 1), 99), left(coalesce(i->>'note', ''), 80)
    from jsonb_array_elements(p_items) i;
  update public.orders o set subtotal_paise = (
    select coalesce(sum(price_paise * qty), 0) from public.order_items
     where order_id = v_order) where o.id = v_order;
  return v_order;
end $$;

revoke all on function public.shop_from_key(text, text) from anon, authenticated;
grant execute on function public.menu_for_shop(text) to anon, authenticated;
grant execute on function public.place_menu_order(text, text, text, text, jsonb) to anon, authenticated;
grant execute on function public.shop_register(text, text, text, numeric) to anon, authenticated;
grant execute on function public.menu_publish(text, text, jsonb) to anon, authenticated;
grant execute on function public.menu_set_available(text, text, text, boolean) to anon, authenticated;
grant execute on function public.board_feed(text, text, timestamptz) to anon, authenticated;
grant execute on function public.order_set_status(text, text, uuid, text, text) to anon, authenticated;
grant execute on function public.counter_order_push(text, text, integer, text, jsonb) to anon, authenticated;


-- ---------------------------------------------------------------------------
-- Merchant-controlled ordering rules (service style, payment timing, table
-- buttons). Applied as a migration on 2026-09-05; kept here as the reference
-- copy of the deployed schema.
-- ---------------------------------------------------------------------------
alter table public.shops
  add column if not exists service_mode text not null default 'table',
  add column if not exists pay_mode text not null default 'after',
  add column if not exists allow_call_staff boolean not null default true,
  add column if not exists allow_request_bill boolean not null default true;

alter table public.orders
  add column if not exists payment_state text not null default 'due';

create table if not exists public.service_requests (
  id uuid primary key default gen_random_uuid(),
  shop_id uuid not null references public.shops(id) on delete cascade,
  table_label text not null default '',
  kind text not null,
  handled_at timestamptz,
  created_at timestamptz not null default now()
);
grant all on public.service_requests to service_role;
alter table public.service_requests enable row level security;

-- menu_for_shop now returns service_mode / pay_mode / allow_call_staff /
-- allow_request_bill; place_menu_order stamps payment_state from pay_mode;
-- board_feed returns payment_state. New RPCs: service_request_push (anon,
-- rate limited per table), service_feed, service_request_seen, order_set_paid
-- (all shop-key protected), and shop_register takes the four rule arguments.

-- ---------------------------------------------------------------------------
-- Multi-device pairing (applied 2026-09-06)
--
-- shop_pairing_codes: single-use 6-digit codes, 15-minute expiry (Pro only).
-- shop_devices: one row per paired phone; device_key stored as SHA-256 hash,
-- role_hint in waiter/kitchen/counter, revocable without touching the shop key.
--
-- Owner RPCs (shop-key protected): shop_device_code_create, shop_devices_list,
-- shop_device_revoke. Staff RPCs (device-key protected): shop_device_pair,
-- shop_device_ping, device_board_feed, device_order_set_status,
-- device_order_set_paid, device_service_feed, device_service_request_seen,
-- device_counter_order_push. Pairing enforces the Pro plan and the five-phone
-- limit server-side. A shop_board_notify trigger broadcasts data-free board
-- change nudges; the app currently polls every 8 s as the durable fallback.

-- Security pass (2026-09-06)
-- orders / order_items now carry explicit service-role-only policies (they had
-- RLS on with no policy, which denied everything but tripped the linter), and
-- the shop_board_notify trigger function is no longer executable by anon or
-- authenticated. The remaining linter warnings are the ordering RPCs
-- themselves: the app ships only the publishable anon key, so every RPC is
-- reachable and each one authenticates the caller by shop key or device key
-- inside the function body. That is the intended design.

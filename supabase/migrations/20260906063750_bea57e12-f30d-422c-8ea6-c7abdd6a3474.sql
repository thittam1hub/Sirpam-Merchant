-- Multi-device sync: shop-scoped pairing codes, paired devices, device RPCs,
-- and a realtime nudge so every phone's board refreshes instantly.

-- 1) Pairing codes (owner-generated, single-use, 15-minute expiry) -------------
create table public.shop_pairing_codes (
  id uuid primary key default gen_random_uuid(),
  shop_id uuid not null references public.shops(id) on delete cascade,
  code text not null,
  role_hint text not null default 'counter',
  expires_at timestamptz not null,
  used_at timestamptz,
  created_at timestamptz not null default now()
);
create unique index shop_pairing_codes_open_code
  on public.shop_pairing_codes (code) where used_at is null;

grant select, insert, update, delete on public.shop_pairing_codes to authenticated;
grant all on public.shop_pairing_codes to service_role;
alter table public.shop_pairing_codes enable row level security;
create policy "service role manages pairing codes"
  on public.shop_pairing_codes for all to service_role using (true) with check (true);

-- 2) Paired devices -------------------------------------------------------------
create table public.shop_devices (
  id uuid primary key default gen_random_uuid(),
  shop_id uuid not null references public.shops(id) on delete cascade,
  device_key_hash text not null,
  label text not null default 'Staff phone',
  role_hint text not null default 'counter',
  active boolean not null default true,
  last_seen_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create unique index shop_devices_unique_key on public.shop_devices (device_key_hash);

grant select, insert, update, delete on public.shop_devices to authenticated;
grant all on public.shop_devices to service_role;
alter table public.shop_devices enable row level security;
create policy "service role manages shop devices"
  on public.shop_devices for all to service_role using (true) with check (true);
create trigger update_shop_devices_updated_at
  before update on public.shop_devices
  for each row execute function public.update_updated_at_column();

-- 3) Resolve a shop from a device key (active devices only) ----------------------
create or replace function public.shop_from_device(p_slug text, p_device_key text)
returns uuid
language sql
stable
security definer
set search_path = public, extensions
as $$
  select d.shop_id from public.shop_devices d
   join public.shops s on s.id = d.shop_id
  where s.slug = p_slug
    and d.device_key_hash = encode(digest(p_device_key, 'sha256'), 'hex')
    and d.active
$$;
revoke execute on function public.shop_from_device(text, text) from public, anon, authenticated;

-- 4) Owner: create a pairing code (Pro-gated, max 5 phones per shop) ------------
create or replace function public.shop_device_code_create(
  p_slug text, p_key text, p_label text default 'Staff phone',
  p_role_hint text default 'counter')
returns jsonb
language plpgsql
security definer
set search_path = public, extensions
as $$
declare
  v_shop uuid;
  v_code text;
begin
  v_shop := public.shop_from_key(p_slug, p_key);
  if v_shop is null then raise exception 'unauthorised'; end if;
  if not public.shop_plan_active(v_shop) then
    raise exception 'subscription required';
  end if;
  if p_role_hint not in ('waiter', 'kitchen', 'counter') then
    raise exception 'bad role hint';
  end if;
  if (select count(*) from public.shop_devices d
       where d.shop_id = v_shop and d.active) >= 5 then
    raise exception 'device limit reached';
  end if;

  -- One open code at a time: retire earlier unused codes.
  update public.shop_pairing_codes
     set used_at = now()
   where shop_id = v_shop and used_at is null;

  v_code := lpad(floor(random() * 1000000)::bigint::text, 6, '0');
  insert into public.shop_pairing_codes (shop_id, code, role_hint, expires_at)
  values (v_shop, v_code, p_role_hint, now() + interval '15 minutes');

  return jsonb_build_object(
    'code', v_code,
    'role_hint', p_role_hint,
    'label', left(coalesce(p_label, ''), 40),
    'expires_at', now() + interval '15 minutes');
end
$$;

-- 5) New phone: exchange a code for its own device key ---------------------------
create or replace function public.shop_device_pair(
  p_slug text, p_code text, p_label text default 'Staff phone',
  p_role_hint text default 'counter')
returns jsonb
language plpgsql
security definer
set search_path = public, extensions
as $$
declare
  v_row public.shop_pairing_codes%ROWTYPE;
  v_key text;
  v_id uuid;
begin
  select * into v_row from public.shop_pairing_codes c
   join public.shops s on s.id = c.shop_id
  where s.slug = p_slug
    and c.code = trim(coalesce(p_code, ''))
    and c.used_at is null
    and c.expires_at > now()
  order by c.created_at desc
  limit 1;
  if v_row.id is null then raise exception 'invalid or expired code'; end if;

  update public.shop_pairing_codes set used_at = now() where id = v_row.id;

  v_key := encode(gen_random_bytes(24), 'hex');
  insert into public.shop_devices
    (shop_id, device_key_hash, label, role_hint, last_seen_at)
  values (
    v_row.shop_id,
    encode(digest(v_key, 'sha256'), 'hex'),
    left(coalesce(nullif(p_label, ''), 'Staff phone'), 40),
    case when p_role_hint in ('waiter', 'kitchen', 'counter')
         then p_role_hint else v_row.role_hint end,
    now())
  returning id into v_id;

  return jsonb_build_object(
    'device_key', v_key,
    'device_id', v_id,
    'role_hint', case when p_role_hint in ('waiter', 'kitchen', 'counter')
                      then p_role_hint else v_row.role_hint end,
    'shop', (select jsonb_build_object('slug', s.slug, 'name', s.name)
               from public.shops s where s.id = v_row.shop_id));
end
$$;

-- 6) Owner: list and revoke phones ------------------------------------------------
create or replace function public.shop_devices_list(p_slug text, p_key text)
returns jsonb
language plpgsql
security definer
set search_path = public, extensions
as $$
declare v_shop uuid;
begin
  v_shop := public.shop_from_key(p_slug, p_key);
  if v_shop is null then raise exception 'unauthorised'; end if;
  return coalesce((
    select jsonb_agg(jsonb_build_object(
             'id', d.id, 'label', d.label, 'role_hint', d.role_hint,
             'active', d.active, 'last_seen_at', d.last_seen_at,
             'created_at', d.created_at) order by d.created_at)
      from public.shop_devices d where d.shop_id = v_shop), '[]'::jsonb);
end
$$;

create or replace function public.shop_device_revoke(
  p_slug text, p_key text, p_device uuid)
returns boolean
language plpgsql
security definer
set search_path = public, extensions
as $$
declare v_shop uuid;
begin
  v_shop := public.shop_from_key(p_slug, p_key);
  if v_shop is null then raise exception 'unauthorised'; end if;
  update public.shop_devices set active = false
   where id = p_device and shop_id = v_shop;
  return found;
end
$$;

-- 7) Device heartbeat: proves the key is still valid, returns shop context -------
create or replace function public.shop_device_ping(
  p_slug text, p_device_key text)
returns jsonb
language plpgsql
security definer
set search_path = public, extensions
as $$
declare v_shop uuid;
begin
  v_shop := public.shop_from_device(p_slug, p_device_key);
  if v_shop is null then raise exception 'device revoked'; end if;
  update public.shop_devices d
     set last_seen_at = now()
   where d.shop_id = v_shop
     and d.device_key_hash = encode(digest(p_device_key, 'sha256'), 'hex');
  return jsonb_build_object(
    'ok', true,
    'shop', (select jsonb_build_object('slug', s.slug, 'name', s.name)
               from public.shops s where s.id = v_shop));
end
$$;

-- 8) Device-key variants of the board RPCs (same bodies, device auth) ------------
create or replace function public.device_board_feed(
  p_slug text, p_device_key text, p_since timestamptz default null)
returns jsonb
language plpgsql
security definer
set search_path = public, extensions
as $$
declare v_shop uuid;
begin
  v_shop := public.shop_from_device(p_slug, p_device_key);
  if v_shop is null then raise exception 'device revoked'; end if;
  return coalesce((
    select jsonb_agg(jsonb_build_object(
      'id', o.id, 'token', o.token, 'table', o.table_label,
      'status', o.status, 'source', o.source,
      'payment_state', o.payment_state,
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
end
$$;

create or replace function public.device_order_set_status(
  p_slug text, p_device_key text, p_order uuid, p_status text,
  p_reason text default '')
returns boolean
language plpgsql
security definer
set search_path = public, extensions
as $$
declare v_shop uuid;
begin
  v_shop := public.shop_from_device(p_slug, p_device_key);
  if v_shop is null then raise exception 'device revoked'; end if;
  update public.orders
     set status = p_status,
         cancel_reason = left(coalesce(p_reason, ''), 120),
         updated_at = now()
   where id = p_order and shop_id = v_shop
     and p_status in ('placed','preparing','served','paid','cancelled');
  return found;
end
$$;

create or replace function public.device_order_set_paid(
  p_slug text, p_device_key text, p_order uuid, p_paid boolean default true)
returns boolean
language plpgsql
security definer
set search_path = public, extensions
as $$
declare v_shop uuid;
begin
  v_shop := public.shop_from_device(p_slug, p_device_key);
  if v_shop is null then raise exception 'device revoked'; end if;
  update public.orders
     set payment_state = case when p_paid then 'paid' else 'due' end,
         updated_at = now()
   where id = p_order and shop_id = v_shop;
  return found;
end
$$;

create or replace function public.device_service_feed(p_slug text, p_device_key text)
returns jsonb
language plpgsql
security definer
set search_path = public, extensions
as $$
declare v_shop uuid;
begin
  v_shop := public.shop_from_device(p_slug, p_device_key);
  if v_shop is null then raise exception 'device revoked'; end if;
  return coalesce((
    select jsonb_agg(jsonb_build_object(
             'id', r.id, 'table', r.table_label, 'kind', r.kind,
             'created_at', r.created_at) order by r.created_at)
      from public.service_requests r
     where r.shop_id = v_shop and r.handled_at is null
       and r.created_at > now() - interval '1 day'), '[]'::jsonb);
end
$$;

create or replace function public.device_service_request_seen(
  p_slug text, p_device_key text, p_request uuid)
returns boolean
language plpgsql
security definer
set search_path = public, extensions
as $$
declare v_shop uuid;
begin
  v_shop := public.shop_from_device(p_slug, p_device_key);
  if v_shop is null then raise exception 'device revoked'; end if;
  update public.service_requests set handled_at = now()
   where id = p_request and shop_id = v_shop and handled_at is null;
  return found;
end
$$;

create or replace function public.device_counter_order_push(
  p_slug text, p_device_key text, p_token integer, p_table text, p_items jsonb)
returns uuid
language plpgsql
security definer
set search_path = public, extensions
as $$
declare v_shop uuid; v_order uuid;
begin
  v_shop := public.shop_from_device(p_slug, p_device_key);
  if v_shop is null then raise exception 'device revoked'; end if;
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
end
$$;

-- 9) Realtime nudge: a data-free ping per shop so paired phones refresh at once.
--    Topic is derived from the shop key hash, so only key holders can subscribe.
--    The payload carries no order data; phones pull details via the secure RPCs.
--    Guarded so the trigger never breaks a write, even if realtime is upgraded.
create or replace function public.shop_board_notify()
returns trigger
language plpgsql
security definer
set search_path = public, extensions
as $$
declare v_topic text;
begin
  select 'shop-board-' || left(s.key_hash, 24) into v_topic
    from public.shops s
   where s.id = coalesce(new.shop_id, old.shop_id);
  if v_topic is not null then
    begin
      perform realtime.broadcast_changes(
        v_topic, 'board', tg_op,
        jsonb_build_object('at', extract(epoch from now())), false);
    exception when others then
      null; -- realtime unavailable: devices fall back to the periodic poll
    end;
  end if;
  return coalesce(new, old);
end
$$;

create trigger orders_board_notify
  after insert or update on public.orders
  for each row execute function public.shop_board_notify();
create trigger service_requests_board_notify
  after insert or update on public.service_requests
  for each row execute function public.shop_board_notify();
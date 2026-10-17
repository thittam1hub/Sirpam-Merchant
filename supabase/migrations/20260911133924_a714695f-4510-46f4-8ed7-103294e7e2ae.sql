-- 1) Automatic online backup ---------------------------------------------------
create table if not exists public.shop_backups (
  id uuid primary key default gen_random_uuid(),
  shop_id uuid not null references public.shops(id) on delete cascade,
  payload text not null,
  checksum text not null default '',
  size_bytes integer not null default 0,
  device_label text not null default '',
  created_at timestamptz not null default now()
);
create index if not exists shop_backups_shop_created
  on public.shop_backups (shop_id, created_at desc);

grant all on public.shop_backups to service_role;
alter table public.shop_backups enable row level security;
drop policy if exists "service role manages shop backups" on public.shop_backups;
create policy "service role manages shop backups"
  on public.shop_backups for all to service_role using (true) with check (true);

create or replace function public.shop_backup_put(
  p_slug text, p_key text, p_payload text, p_checksum text default '',
  p_label text default '')
returns jsonb
language plpgsql
security definer
set search_path = public, extensions
as $$
declare v_shop uuid; v_id uuid;
begin
  v_shop := public.shop_from_key(p_slug, p_key);
  if v_shop is null then raise exception 'unauthorised'; end if;
  if p_payload is null or length(p_payload) = 0 then
    raise exception 'empty backup';
  end if;
  if length(p_payload) > 8 * 1024 * 1024 then
    raise exception 'backup too large';
  end if;

  insert into public.shop_backups (shop_id, payload, checksum, size_bytes, device_label)
  values (v_shop, p_payload, left(coalesce(p_checksum, ''), 128),
          length(p_payload), left(coalesce(p_label, ''), 60))
  returning id into v_id;

  delete from public.shop_backups b
   where b.shop_id = v_shop
     and b.id not in (
       select id from public.shop_backups
        where shop_id = v_shop order by created_at desc limit 7);

  return jsonb_build_object('id', v_id, 'created_at', now());
end
$$;

create or replace function public.shop_backup_latest(
  p_slug text, p_key text, p_with_payload boolean default false)
returns jsonb
language plpgsql
security definer
set search_path = public, extensions
as $$
declare v_shop uuid; v_row public.shop_backups;
begin
  v_shop := public.shop_from_key(p_slug, p_key);
  if v_shop is null then raise exception 'unauthorised'; end if;
  select * into v_row from public.shop_backups
   where shop_id = v_shop order by created_at desc limit 1;
  if v_row.id is null then return jsonb_build_object('found', false); end if;
  return jsonb_build_object(
    'found', true,
    'created_at', v_row.created_at,
    'size_bytes', v_row.size_bytes,
    'checksum', v_row.checksum,
    'payload', case when p_with_payload then v_row.payload else null end);
end
$$;

grant execute on function public.shop_backup_put(text, text, text, text, text)
  to anon, authenticated;
grant execute on function public.shop_backup_latest(text, text, boolean)
  to anon, authenticated;

-- 2) Staff roles published by the owner ---------------------------------------
create table if not exists public.shop_roles (
  id uuid primary key default gen_random_uuid(),
  shop_id uuid not null references public.shops(id) on delete cascade,
  role_id text not null,
  name text not null default '',
  permissions text[] not null default '{}',
  max_discount_paise integer not null default 0,
  max_credit_paise integer not null default 0,
  max_refund_paise integer not null default 0,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create unique index if not exists shop_roles_unique
  on public.shop_roles (shop_id, role_id);

grant all on public.shop_roles to service_role;
alter table public.shop_roles enable row level security;
drop policy if exists "service role manages shop roles" on public.shop_roles;
create policy "service role manages shop roles"
  on public.shop_roles for all to service_role using (true) with check (true);

alter table public.shop_devices add column if not exists role_id text;

create or replace function public.shop_roles_publish(
  p_slug text, p_key text, p_roles jsonb)
returns integer
language plpgsql
security definer
set search_path = public, extensions
as $$
declare v_shop uuid; v_count integer;
begin
  v_shop := public.shop_from_key(p_slug, p_key);
  if v_shop is null then raise exception 'unauthorised'; end if;

  delete from public.shop_roles
   where shop_id = v_shop
     and role_id not in (
       select coalesce(r->>'id', '')
         from jsonb_array_elements(coalesce(p_roles, '[]'::jsonb)) r);

  insert into public.shop_roles (shop_id, role_id, name, permissions,
      max_discount_paise, max_credit_paise, max_refund_paise, active, updated_at)
  select v_shop,
         left(coalesce(r->>'id', ''), 40),
         left(coalesce(r->>'name', ''), 60),
         coalesce((select array_agg(p::text) from jsonb_array_elements_text(
                     coalesce(r->'permissions', '[]'::jsonb)) p), '{}'),
         greatest(coalesce((r->>'maxDiscountPaise')::int, 0), 0),
         greatest(coalesce((r->>'maxCreditPaise')::int, 0), 0),
         greatest(coalesce((r->>'maxRefundPaise')::int, 0), 0),
         coalesce((r->>'active')::boolean, true),
         now()
    from jsonb_array_elements(coalesce(p_roles, '[]'::jsonb)) r
   where coalesce(r->>'id', '') <> ''
  on conflict (shop_id, role_id) do update
     set name = excluded.name,
         permissions = excluded.permissions,
         max_discount_paise = excluded.max_discount_paise,
         max_credit_paise = excluded.max_credit_paise,
         max_refund_paise = excluded.max_refund_paise,
         active = excluded.active,
         updated_at = now();

  select count(*) into v_count from public.shop_roles where shop_id = v_shop;
  return v_count;
end
$$;

create or replace function public.shop_device_set_role(
  p_slug text, p_key text, p_device uuid, p_role_id text)
returns boolean
language plpgsql
security definer
set search_path = public, extensions
as $$
declare v_shop uuid;
begin
  v_shop := public.shop_from_key(p_slug, p_key);
  if v_shop is null then raise exception 'unauthorised'; end if;
  update public.shop_devices
     set role_id = nullif(left(coalesce(p_role_id, ''), 40), ''), updated_at = now()
   where id = p_device and shop_id = v_shop;
  return found;
end
$$;

create or replace function public.device_profile(p_slug text, p_device_key text)
returns jsonb
language plpgsql
security definer
set search_path = public, extensions
as $$
declare v_shop uuid; v_dev public.shop_devices; v_role public.shop_roles;
begin
  v_shop := public.shop_from_device(p_slug, p_device_key);
  if v_shop is null then raise exception 'device revoked'; end if;
  select * into v_dev from public.shop_devices
   where shop_id = v_shop
     and device_key_hash = encode(digest(p_device_key, 'sha256'), 'hex');
  select * into v_role from public.shop_roles
   where shop_id = v_shop and role_id = v_dev.role_id and active;
  return jsonb_build_object(
    'label', v_dev.label,
    'role_hint', v_dev.role_hint,
    'role_id', coalesce(v_role.role_id, ''),
    'role_name', coalesce(v_role.name, ''),
    'permissions', coalesce(to_jsonb(v_role.permissions), '[]'::jsonb),
    'max_discount_paise', coalesce(v_role.max_discount_paise, 0),
    'max_credit_paise', coalesce(v_role.max_credit_paise, 0),
    'max_refund_paise', coalesce(v_role.max_refund_paise, 0));
end
$$;

create or replace function public.device_permits(
  p_shop uuid, p_device_key text, p_permission text, p_hints text[])
returns boolean
language plpgsql
stable
security definer
set search_path = public, extensions
as $$
declare v_dev public.shop_devices; v_role public.shop_roles;
begin
  select * into v_dev from public.shop_devices
   where shop_id = p_shop
     and device_key_hash = encode(digest(p_device_key, 'sha256'), 'hex')
     and active;
  if v_dev.id is null then return false; end if;

  select * into v_role from public.shop_roles
   where shop_id = p_shop and role_id = v_dev.role_id and active;
  if v_role.id is null then
    return v_dev.role_hint = any(p_hints);
  end if;
  return p_permission = any(v_role.permissions);
end
$$;

revoke execute on function public.device_permits(uuid, text, text, text[])
  from public, anon, authenticated;

grant execute on function public.shop_roles_publish(text, text, jsonb) to anon, authenticated;
grant execute on function public.shop_device_set_role(text, text, uuid, text) to anon, authenticated;
grant execute on function public.device_profile(text, text) to anon, authenticated;

-- 3) Device write RPCs now check the published permissions --------------------
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
  if not public.device_permits(v_shop, p_device_key, 'changeOrderStatus',
        array['waiter','kitchen','counter']) then
    raise exception 'not allowed';
  end if;
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
  if not public.device_permits(v_shop, p_device_key, 'makeBill',
        array['counter']) then
    raise exception 'not allowed';
  end if;
  update public.orders
     set payment_state = case when p_paid then 'paid' else 'due' end,
         updated_at = now()
   where id = p_order and shop_id = v_shop;
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
  if not public.device_permits(v_shop, p_device_key, 'takeOrder',
        array['waiter','counter']) then
    raise exception 'not allowed';
  end if;
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
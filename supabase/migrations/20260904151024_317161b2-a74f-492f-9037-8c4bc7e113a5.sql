create extension if not exists pgcrypto with schema extensions;

create table if not exists public.shops (
  id            uuid primary key default gen_random_uuid(),
  slug          text not null unique check (slug ~ '^[a-z0-9][a-z0-9-]{1,38}$'),
  name          text not null default '',
  key_hash      text not null,
  is_open       boolean not null default true,
  tax_percent   numeric(5,2) not null default 0,
  address       text not null default '',
  phone         text not null default '',
  gstin         text not null default '',
  fssai         text not null default '',
  vpa           text not null default '',
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
grant all on public.shops to service_role;
grant all on public.menu_items to service_role;
grant all on public.orders to service_role;
grant all on public.order_items to service_role;

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

alter table public.menu_items replica identity full;
alter table public.orders replica identity full;
do $$
begin
  begin alter publication supabase_realtime add table public.menu_items;
  exception when duplicate_object then null; end;
  begin alter publication supabase_realtime add table public.orders;
  exception when duplicate_object then null; end;
end $$;

create or replace function public.update_updated_at_column()
returns trigger language plpgsql set search_path = public as $$
begin
  new.updated_at = now();
  return new;
end $$;

drop trigger if exists update_shops_updated_at on public.shops;
create trigger update_shops_updated_at before update on public.shops
  for each row execute function public.update_updated_at_column();

create or replace function public.shop_from_key(p_slug text, p_key text)
returns uuid language sql stable security definer
set search_path = public, extensions as $$
  select id from public.shops
   where slug = p_slug and key_hash = encode(digest(p_key, 'sha256'), 'hex')
$$;

create or replace function public.shop_register(
  p_slug text, p_key text, p_name text default '', p_tax numeric default 0,
  p_address text default null, p_phone text default null,
  p_gstin text default null, p_fssai text default null, p_vpa text default null)
returns jsonb language plpgsql security definer
set search_path = public, extensions as $$
declare v_id uuid;
begin
  if length(coalesce(p_key, '')) < 16 then raise exception 'weak shop key'; end if;
  select id into v_id from public.shops where slug = p_slug;
  if v_id is null then
    insert into public.shops (slug, name, key_hash, tax_percent,
                              address, phone, gstin, fssai, vpa)
    values (p_slug, left(coalesce(p_name, ''), 60),
            encode(digest(p_key, 'sha256'), 'hex'), coalesce(p_tax, 0),
            left(coalesce(p_address, ''), 160), left(coalesce(p_phone, ''), 15),
            left(coalesce(p_gstin, ''), 20), left(coalesce(p_fssai, ''), 20),
            left(coalesce(p_vpa, ''), 80))
    returning id into v_id;
  else
    if public.shop_from_key(p_slug, p_key) is null then
      raise exception 'slug already taken';
    end if;
    update public.shops
       set name = left(coalesce(p_name, name), 60),
           tax_percent = coalesce(p_tax, tax_percent),
           address = left(coalesce(p_address, address), 160),
           phone = left(coalesce(p_phone, phone), 15),
           gstin = left(coalesce(p_gstin, gstin), 20),
           fssai = left(coalesce(p_fssai, fssai), 20),
           vpa = left(coalesce(p_vpa, vpa), 80),
           updated_at = now()
     where id = v_id;
  end if;
  return jsonb_build_object('shop_id', v_id, 'slug', p_slug);
end $$;

create or replace function public.menu_publish(
  p_slug text, p_key text, p_items jsonb)
returns integer language plpgsql security definer
set search_path = public, extensions as $$
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
returns boolean language plpgsql security definer
set search_path = public, extensions as $$
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
returns jsonb language sql stable security definer
set search_path = public, extensions as $$
  select jsonb_build_object(
    'shop', jsonb_build_object('name', s.name, 'open', s.is_open, 'slug', s.slug,
             'address', s.address, 'phone', s.phone, 'gstin', s.gstin,
             'fssai', s.fssai, 'vpa', s.vpa, 'tax_percent', s.tax_percent),
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
returns jsonb language plpgsql security definer
set search_path = public, extensions as $$
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
returns jsonb language plpgsql security definer
set search_path = public, extensions as $$
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
returns boolean language plpgsql security definer
set search_path = public, extensions as $$
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
returns uuid language plpgsql security definer
set search_path = public, extensions as $$
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
grant execute on function public.shop_register(text, text, text, numeric, text, text, text, text, text) to anon, authenticated;
grant execute on function public.menu_publish(text, text, jsonb) to anon, authenticated;
grant execute on function public.menu_set_available(text, text, text, boolean) to anon, authenticated;
grant execute on function public.board_feed(text, text, timestamptz) to anon, authenticated;
grant execute on function public.order_set_status(text, text, uuid, text, text) to anon, authenticated;
grant execute on function public.counter_order_push(text, text, integer, text, jsonb) to anon, authenticated;
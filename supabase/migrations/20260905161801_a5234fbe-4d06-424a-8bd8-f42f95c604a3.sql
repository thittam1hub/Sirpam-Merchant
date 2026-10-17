-- 1. Shop-level ordering rules
ALTER TABLE public.shops
  ADD COLUMN IF NOT EXISTS service_mode text NOT NULL DEFAULT 'table',
  ADD COLUMN IF NOT EXISTS pay_mode text NOT NULL DEFAULT 'after',
  ADD COLUMN IF NOT EXISTS allow_call_staff boolean NOT NULL DEFAULT true,
  ADD COLUMN IF NOT EXISTS allow_request_bill boolean NOT NULL DEFAULT true;

ALTER TABLE public.orders
  ADD COLUMN IF NOT EXISTS payment_state text NOT NULL DEFAULT 'due';

-- 2. Service requests (call staff / bill please)
CREATE TABLE IF NOT EXISTS public.service_requests (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  shop_id uuid NOT NULL REFERENCES public.shops(id) ON DELETE CASCADE,
  table_label text NOT NULL DEFAULT '',
  kind text NOT NULL,
  handled_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS service_requests_open_idx
  ON public.service_requests (shop_id, created_at DESC) WHERE handled_at IS NULL;

GRANT ALL ON public.service_requests TO service_role;
ALTER TABLE public.service_requests ENABLE ROW LEVEL SECURITY;
CREATE POLICY "service role manages service requests"
  ON public.service_requests FOR ALL TO service_role USING (true) WITH CHECK (true);

-- 3. Menu payload carries the rules
CREATE OR REPLACE FUNCTION public.menu_for_shop(p_slug text)
 RETURNS jsonb LANGUAGE sql STABLE SECURITY DEFINER
 SET search_path TO 'public', 'extensions'
AS $function$
  select jsonb_build_object(
    'shop', jsonb_build_object('name', s.name, 'open', s.is_open, 'slug', s.slug,
             'address', s.address, 'phone', s.phone, 'gstin', s.gstin,
             'fssai', s.fssai, 'vpa', s.vpa, 'tax_percent', s.tax_percent,
             'service_mode', s.service_mode, 'pay_mode', s.pay_mode,
             'allow_call_staff', s.allow_call_staff,
             'allow_request_bill', s.allow_request_bill),
    'items', coalesce((
      select jsonb_agg(jsonb_build_object(
               'id', m.id, 'name', m.name, 'category', m.category,
               'price_paise', m.price_paise, 'available', m.available)
               order by m.sort, m.name)
        from public.menu_items m
       where m.shop_id = s.id and m.published), '[]'::jsonb))
  from public.shops s where s.slug = p_slug
$function$;

-- 4. Orders inherit the shop payment timing
CREATE OR REPLACE FUNCTION public.place_menu_order(p_slug text, p_table text, p_name text, p_phone text, p_items jsonb)
 RETURNS jsonb LANGUAGE plpgsql SECURITY DEFINER
 SET search_path TO 'public', 'extensions'
AS $function$
declare v_shop uuid; v_order uuid; v_token integer; v_pay text;
begin
  select id, case when pay_mode = 'before' then 'awaiting' else 'due' end
    into v_shop, v_pay
    from public.shops where slug = p_slug and is_open;
  if v_shop is null then raise exception 'shop closed'; end if;
  if jsonb_array_length(p_items) not between 1 and 40 then
    raise exception 'bad basket'; end if;

  select coalesce(max(token), 0) + 1 into v_token from public.orders
   where shop_id = v_shop and created_at::date = current_date;

  insert into public.orders (shop_id, token, table_label, source,
                             customer_name, customer_phone, payment_state)
  values (v_shop, v_token, left(coalesce(p_table, ''), 8), 'qr',
          left(coalesce(p_name, ''), 40), left(coalesce(p_phone, ''), 15), v_pay)
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

  return jsonb_build_object('token', v_token, 'order_id', v_order,
                            'payment_state', v_pay);
end $function$;

-- 5. Board feed exposes the payment state
CREATE OR REPLACE FUNCTION public.board_feed(p_slug text, p_key text, p_since timestamp with time zone DEFAULT NULL::timestamp with time zone)
 RETURNS jsonb LANGUAGE plpgsql SECURITY DEFINER
 SET search_path TO 'public', 'extensions'
AS $function$
declare v_shop uuid;
begin
  v_shop := public.shop_from_key(p_slug, p_key);
  if v_shop is null then raise exception 'unauthorised'; end if;
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
end $function$;

-- 6. Customer raises a request from the table
CREATE OR REPLACE FUNCTION public.service_request_push(p_slug text, p_table text, p_kind text)
 RETURNS boolean LANGUAGE plpgsql SECURITY DEFINER
 SET search_path TO 'public', 'extensions'
AS $function$
declare v_shop public.shops%ROWTYPE;
begin
  select * into v_shop from public.shops where slug = p_slug and is_open;
  if v_shop.id is null then raise exception 'shop closed'; end if;
  if p_kind not in ('call_staff', 'request_bill') then
    raise exception 'bad request'; end if;
  if (p_kind = 'call_staff' and not v_shop.allow_call_staff)
     or (p_kind = 'request_bill' and not v_shop.allow_request_bill) then
    raise exception 'not available'; end if;
  if exists (select 1 from public.service_requests r
              where r.shop_id = v_shop.id
                and r.table_label = left(coalesce(p_table, ''), 8)
                and r.created_at > now() - interval '20 seconds') then
    return false;
  end if;
  insert into public.service_requests (shop_id, table_label, kind)
  values (v_shop.id, left(coalesce(p_table, ''), 8), p_kind);
  return true;
end $function$;

-- 7. Counter reads and clears requests
CREATE OR REPLACE FUNCTION public.service_feed(p_slug text, p_key text)
 RETURNS jsonb LANGUAGE plpgsql SECURITY DEFINER
 SET search_path TO 'public', 'extensions'
AS $function$
declare v_shop uuid;
begin
  v_shop := public.shop_from_key(p_slug, p_key);
  if v_shop is null then raise exception 'unauthorised'; end if;
  return coalesce((
    select jsonb_agg(jsonb_build_object(
             'id', r.id, 'table', r.table_label, 'kind', r.kind,
             'created_at', r.created_at) order by r.created_at)
      from public.service_requests r
     where r.shop_id = v_shop and r.handled_at is null
       and r.created_at > now() - interval '1 day'), '[]'::jsonb);
end $function$;

CREATE OR REPLACE FUNCTION public.service_request_seen(p_slug text, p_key text, p_request uuid)
 RETURNS boolean LANGUAGE plpgsql SECURITY DEFINER
 SET search_path TO 'public', 'extensions'
AS $function$
declare v_shop uuid;
begin
  v_shop := public.shop_from_key(p_slug, p_key);
  if v_shop is null then raise exception 'unauthorised'; end if;
  update public.service_requests set handled_at = now()
   where id = p_request and shop_id = v_shop and handled_at is null;
  return found;
end $function$;

-- 8. Counter marks an order paid / unpaid
CREATE OR REPLACE FUNCTION public.order_set_paid(p_slug text, p_key text, p_order uuid, p_paid boolean DEFAULT true)
 RETURNS boolean LANGUAGE plpgsql SECURITY DEFINER
 SET search_path TO 'public', 'extensions'
AS $function$
declare v_shop uuid;
begin
  v_shop := public.shop_from_key(p_slug, p_key);
  if v_shop is null then raise exception 'unauthorised'; end if;
  update public.orders
     set payment_state = case when p_paid then 'paid' else 'due' end,
         updated_at = now()
   where id = p_order and shop_id = v_shop;
  return found;
end $function$;

-- 9. Shop registration carries the rules
DROP FUNCTION IF EXISTS public.shop_register(text, text, text, numeric, text, text, text, text, text);

CREATE OR REPLACE FUNCTION public.shop_register(
  p_slug text, p_key text, p_name text DEFAULT ''::text, p_tax numeric DEFAULT 0,
  p_address text DEFAULT NULL::text, p_phone text DEFAULT NULL::text,
  p_gstin text DEFAULT NULL::text, p_fssai text DEFAULT NULL::text,
  p_vpa text DEFAULT NULL::text, p_service_mode text DEFAULT NULL::text,
  p_pay_mode text DEFAULT NULL::text, p_call_staff boolean DEFAULT NULL::boolean,
  p_request_bill boolean DEFAULT NULL::boolean)
 RETURNS jsonb LANGUAGE plpgsql SECURITY DEFINER
 SET search_path TO 'public', 'extensions'
AS $function$
declare v_id uuid;
        v_service text := case when p_service_mode in ('table','self','takeaway')
                               then p_service_mode else null end;
        v_pay text := case when p_pay_mode in ('before','after')
                           then p_pay_mode else null end;
begin
  if length(coalesce(p_key, '')) < 16 then raise exception 'weak shop key'; end if;
  select id into v_id from public.shops where slug = p_slug;
  if v_id is null then
    insert into public.shops (slug, name, key_hash, tax_percent,
                              address, phone, gstin, fssai, vpa,
                              service_mode, pay_mode, allow_call_staff, allow_request_bill)
    values (p_slug, left(coalesce(p_name, ''), 60),
            encode(digest(p_key, 'sha256'), 'hex'), coalesce(p_tax, 0),
            left(coalesce(p_address, ''), 160), left(coalesce(p_phone, ''), 15),
            left(coalesce(p_gstin, ''), 20), left(coalesce(p_fssai, ''), 20),
            left(coalesce(p_vpa, ''), 80),
            coalesce(v_service, 'table'), coalesce(v_pay, 'after'),
            coalesce(p_call_staff, true), coalesce(p_request_bill, true))
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
           service_mode = coalesce(v_service, service_mode),
           pay_mode = coalesce(v_pay, pay_mode),
           allow_call_staff = coalesce(p_call_staff, allow_call_staff),
           allow_request_bill = coalesce(p_request_bill, allow_request_bill),
           updated_at = now()
     where id = v_id;
  end if;
  return jsonb_build_object('shop_id', v_id, 'slug', p_slug);
end $function$;

REVOKE ALL ON FUNCTION public.shop_register(text, text, text, numeric, text, text, text, text, text, text, text, boolean, boolean) FROM public;
GRANT EXECUTE ON FUNCTION public.shop_register(text, text, text, numeric, text, text, text, text, text, text, text, boolean, boolean) TO anon, authenticated;
GRANT EXECUTE ON FUNCTION public.service_request_push(text, text, text) TO anon, authenticated;
GRANT EXECUTE ON FUNCTION public.service_feed(text, text) TO anon, authenticated;
GRANT EXECUTE ON FUNCTION public.service_request_seen(text, text, uuid) TO anon, authenticated;
GRANT EXECUTE ON FUNCTION public.order_set_paid(text, text, uuid, boolean) TO anon, authenticated;
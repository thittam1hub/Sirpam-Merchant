CREATE TABLE public.shop_subscriptions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  shop_id uuid NOT NULL UNIQUE REFERENCES public.shops(id) ON DELETE CASCADE,
  plan text NOT NULL DEFAULT 'free',
  status text NOT NULL DEFAULT 'inactive',
  current_period_end timestamptz,
  provider text NOT NULL DEFAULT '',
  provider_ref text NOT NULL DEFAULT '',
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

GRANT ALL ON public.shop_subscriptions TO service_role;

ALTER TABLE public.shop_subscriptions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "service role manages subscriptions"
  ON public.shop_subscriptions FOR ALL
  TO service_role USING (true) WITH CHECK (true);

CREATE TRIGGER update_shop_subscriptions_updated_at
  BEFORE UPDATE ON public.shop_subscriptions
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- Existing shops keep working: a 30 day Pro trial.
INSERT INTO public.shop_subscriptions (shop_id, plan, status, current_period_end, provider)
SELECT s.id, 'pro', 'trialing', now() + interval '30 days', 'trial'
FROM public.shops s
ON CONFLICT (shop_id) DO NOTHING;

CREATE OR REPLACE FUNCTION public.shop_plan_active(p_shop uuid)
RETURNS boolean
LANGUAGE sql
STABLE SECURITY DEFINER
SET search_path TO 'public', 'extensions'
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.shop_subscriptions x
    WHERE x.shop_id = p_shop
      AND x.plan = 'pro'
      AND x.status IN ('active', 'trialing')
      AND (x.current_period_end IS NULL OR x.current_period_end > now())
  )
$$;

CREATE OR REPLACE FUNCTION public.shop_plan(p_slug text, p_key text)
RETURNS jsonb
LANGUAGE plpgsql
STABLE SECURITY DEFINER
SET search_path TO 'public', 'extensions'
AS $$
DECLARE v_shop uuid; v_row public.shop_subscriptions%ROWTYPE;
BEGIN
  v_shop := public.shop_from_key(p_slug, p_key);
  IF v_shop IS NULL THEN RAISE EXCEPTION 'unauthorised'; END IF;
  SELECT * INTO v_row FROM public.shop_subscriptions WHERE shop_id = v_shop;
  RETURN jsonb_build_object(
    'plan', COALESCE(v_row.plan, 'free'),
    'status', COALESCE(v_row.status, 'inactive'),
    'period_end', v_row.current_period_end,
    'active', public.shop_plan_active(v_shop)
  );
END $$;

-- Cloud features now require an active plan.
CREATE OR REPLACE FUNCTION public.menu_publish(p_slug text, p_key text, p_items jsonb)
 RETURNS integer
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public', 'extensions'
AS $function$
declare v_shop uuid; v_count integer;
begin
  v_shop := public.shop_from_key(p_slug, p_key);
  if v_shop is null then raise exception 'unauthorised'; end if;
  if not public.shop_plan_active(v_shop) then raise exception 'subscription required'; end if;

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
end $function$;

CREATE OR REPLACE FUNCTION public.menu_set_available(p_slug text, p_key text, p_ext_id text, p_available boolean)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public', 'extensions'
AS $function$
declare v_shop uuid;
begin
  v_shop := public.shop_from_key(p_slug, p_key);
  if v_shop is null then raise exception 'unauthorised'; end if;
  if not public.shop_plan_active(v_shop) then raise exception 'subscription required'; end if;
  update public.menu_items
     set available = coalesce(p_available, true), updated_at = now()
   where shop_id = v_shop and ext_id = p_ext_id;
  return found;
end $function$;

CREATE OR REPLACE FUNCTION public.counter_order_push(p_slug text, p_key text, p_token integer, p_table text, p_items jsonb)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public', 'extensions'
AS $function$
declare v_shop uuid; v_order uuid;
begin
  v_shop := public.shop_from_key(p_slug, p_key);
  if v_shop is null then raise exception 'unauthorised'; end if;
  if not public.shop_plan_active(v_shop) then raise exception 'subscription required'; end if;
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
end $function$;
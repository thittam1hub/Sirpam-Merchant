create or replace function public.shop_sales_rollup(
  p_slug text, p_key text, p_days integer default 7)
returns jsonb
language plpgsql
security definer
set search_path = public, extensions
as $$
declare
  v_shop uuid;
  v_days integer := greatest(1, least(coalesce(p_days, 7), 90));
  v_since timestamptz;
  v_name text;
  v_orders integer;
  v_cancelled integer;
  v_billed bigint;
  v_by_day jsonb;
begin
  v_shop := public.shop_from_key(p_slug, p_key);
  if v_shop is null then raise exception 'unauthorised'; end if;
  v_since := date_trunc('day', now()) - ((v_days - 1) || ' days')::interval;

  select s.name into v_name from public.shops s where s.id = v_shop;

  select count(*) filter (where o.status <> 'cancelled'),
         count(*) filter (where o.status = 'cancelled'),
         coalesce(sum(o.subtotal_paise) filter (where o.status <> 'cancelled'), 0)
    into v_orders, v_cancelled, v_billed
    from public.orders o
   where o.shop_id = v_shop
     and o.created_at >= v_since;

  select coalesce(jsonb_agg(d order by d->>'day' desc), '[]'::jsonb)
    into v_by_day
    from (
      select jsonb_build_object(
               'day', to_char(date_trunc('day', o.created_at), 'YYYY-MM-DD'),
               'orders', count(*) filter (where o.status <> 'cancelled'),
               'billed_paise',
               coalesce(sum(o.subtotal_paise) filter (where o.status <> 'cancelled'), 0)
             ) as d
        from public.orders o
       where o.shop_id = v_shop
         and o.created_at >= v_since
       group by date_trunc('day', o.created_at)
    ) rows;

  return jsonb_build_object(
    'slug', p_slug,
    'name', coalesce(v_name, ''),
    'days', v_days,
    'orders', coalesce(v_orders, 0),
    'cancelled', coalesce(v_cancelled, 0),
    'billed_paise', coalesce(v_billed, 0),
    'by_day', v_by_day
  );
end;
$$;

revoke all on function public.shop_sales_rollup(text, text, integer) from public;
grant execute on function public.shop_sales_rollup(text, text, integer) to anon, authenticated;
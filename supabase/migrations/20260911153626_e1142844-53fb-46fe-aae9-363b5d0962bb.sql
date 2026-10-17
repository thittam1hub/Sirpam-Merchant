CREATE OR REPLACE FUNCTION public.shop_devices_list(p_slug text, p_key text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public', 'extensions'
AS $function$
declare v_shop uuid;
begin
  v_shop := public.shop_from_key(p_slug, p_key);
  if v_shop is null then raise exception 'unauthorised'; end if;
  return coalesce((
    select jsonb_agg(jsonb_build_object(
             'id', d.id, 'label', d.label, 'role_hint', d.role_hint,
             'role_id', d.role_id,
             'role_name', (select r.name from public.shop_roles r
                            where r.shop_id = v_shop and r.role_id = d.role_id),
             'active', d.active, 'last_seen_at', d.last_seen_at,
             'created_at', d.created_at) order by d.created_at)
      from public.shop_devices d where d.shop_id = v_shop), '[]'::jsonb);
end
$function$;
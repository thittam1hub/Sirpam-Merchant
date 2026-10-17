CREATE OR REPLACE FUNCTION public.merchant_register(
  business_name text,
  provider text,
  merchant_ref text,
  vpa text DEFAULT NULL,
  phonepe_salt_key text DEFAULT NULL,
  phonepe_salt_index text DEFAULT '1',
  paytm_webhook_token text DEFAULT NULL
) RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, extensions
AS $$
DECLARE
  _name text := nullif(btrim(business_name), '');
  _provider text := lower(btrim(coalesce(provider, '')));
  _ref text := nullif(btrim(merchant_ref), '');
  _vpa text := nullif(btrim(coalesce(vpa, '')), '');
  _code text;
  _merchant public.merchants%ROWTYPE;
BEGIN
  IF _name IS NULL OR length(_name) > 80 THEN
    RAISE EXCEPTION 'business name is required';
  END IF;
  IF _provider NOT IN ('phonepe', 'paytm') THEN
    RAISE EXCEPTION 'provider must be phonepe or paytm';
  END IF;
  IF _ref IS NULL OR length(_ref) > 80 THEN
    RAISE EXCEPTION 'merchant id is required';
  END IF;
  IF _vpa IS NOT NULL AND _vpa !~ '^[A-Za-z0-9._-]{2,64}@[A-Za-z][A-Za-z0-9.]{1,32}$' THEN
    RAISE EXCEPTION 'business UPI id is not valid';
  END IF;
  IF _provider = 'phonepe' AND nullif(btrim(coalesce(phonepe_salt_key, '')), '') IS NULL THEN
    RAISE EXCEPTION 'salt key is required';
  END IF;
  IF _provider = 'paytm' AND nullif(btrim(coalesce(paytm_webhook_token, '')), '') IS NULL THEN
    RAISE EXCEPTION 'webhook token is required';
  END IF;

  IF EXISTS (SELECT 1 FROM public.merchants m
             WHERE m.provider = _provider AND m.merchant_ref = _ref) THEN
    RAISE EXCEPTION 'this merchant id is already registered';
  END IF;

  LOOP
    _code := upper(substr(encode(extensions.gen_random_bytes(8), 'hex'), 1, 8));
    EXIT WHEN NOT EXISTS (SELECT 1 FROM public.merchants m WHERE m.pairing_code = _code);
  END LOOP;

  INSERT INTO public.merchants (name, provider, merchant_ref, vpa, pairing_code)
  VALUES (_name, _provider, _ref, _vpa, _code)
  RETURNING * INTO _merchant;

  INSERT INTO private.psp_credentials (
    merchant_id, phonepe_salt_key, phonepe_salt_index, paytm_webhook_token
  ) VALUES (
    _merchant.id,
    nullif(btrim(coalesce(phonepe_salt_key, '')), ''),
    coalesce(nullif(btrim(coalesce(phonepe_salt_index, '')), ''), '1'),
    nullif(btrim(coalesce(paytm_webhook_token, '')), '')
  );

  RETURN jsonb_build_object(
    'merchant_id', _merchant.id,
    'name', _merchant.name,
    'provider', _merchant.provider,
    'vpa', _merchant.vpa,
    'pairing_code', _merchant.pairing_code
  );
END;
$$;

REVOKE ALL ON FUNCTION public.merchant_register(text, text, text, text, text, text, text) FROM PUBLIC, authenticated;
GRANT EXECUTE ON FUNCTION public.merchant_register(text, text, text, text, text, text, text) TO anon, service_role;
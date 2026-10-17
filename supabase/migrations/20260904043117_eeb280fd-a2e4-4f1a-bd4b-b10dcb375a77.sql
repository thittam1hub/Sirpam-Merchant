CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;

CREATE SCHEMA IF NOT EXISTS private;
REVOKE ALL ON SCHEMA private FROM PUBLIC, anon, authenticated;

CREATE TABLE private.psp_credentials (
  merchant_id uuid PRIMARY KEY REFERENCES public.merchants(id) ON DELETE CASCADE,
  phonepe_salt_key text,
  phonepe_salt_index text NOT NULL DEFAULT '1',
  paytm_webhook_token text,
  created_at timestamptz NOT NULL DEFAULT now()
);
REVOKE ALL ON private.psp_credentials FROM PUBLIC, anon, authenticated;
GRANT ALL ON private.psp_credentials TO service_role;

-- ---------------------------------------------------------------- helpers

CREATE OR REPLACE FUNCTION private.record_payment(
  _merchant_id uuid,
  _provider text,
  _txn_id text,
  _utr text,
  _amount_paise bigint,
  _payer_vpa text,
  _payer_name text,
  _order_tag text,
  _note text,
  _occurred_at timestamptz,
  _raw jsonb
) RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, extensions
AS $$
DECLARE
  _id uuid;
BEGIN
  INSERT INTO public.upi_payments (
    merchant_id, provider, provider_txn_id, utr, amount_paise,
    payer_vpa, payer_name, order_tag, note, status, occurred_at, raw
  ) VALUES (
    _merchant_id, _provider, _txn_id, _utr, _amount_paise,
    _payer_vpa, _payer_name, _order_tag, _note, 'success',
    COALESCE(_occurred_at, now()), COALESCE(_raw, '{}'::jsonb)
  )
  ON CONFLICT (provider, provider_txn_id) DO NOTHING
  RETURNING id INTO _id;

  IF _id IS NULL THEN
    SELECT id INTO _id FROM public.upi_payments
    WHERE provider = _provider AND provider_txn_id = _txn_id;
  END IF;

  RETURN _id;
END;
$$;

CREATE OR REPLACE FUNCTION private.device_from_key(_device_key text)
RETURNS uuid
LANGUAGE sql
SECURITY DEFINER
SET search_path = public, extensions
AS $$
  SELECT id FROM public.devices
  WHERE device_key_hash = encode(digest(_device_key, 'sha256'), 'hex')
$$;

-- ------------------------------------------------------- PhonePe callback

CREATE OR REPLACE FUNCTION public.phonepe_webhook(response text)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, extensions
AS $$
DECLARE
  _hdr text;
  _hash text;
  _index text;
  _payload jsonb;
  _data jsonb;
  _merchant public.merchants%ROWTYPE;
  _cred private.psp_credentials%ROWTYPE;
  _payment_id uuid;
BEGIN
  _hdr := current_setting('request.headers', true)::jsonb ->> 'x-verify';
  IF _hdr IS NULL THEN
    RAISE EXCEPTION 'missing X-VERIFY';
  END IF;
  _hash := lower(split_part(_hdr, '###', 1));
  _index := COALESCE(NULLIF(split_part(_hdr, '###', 2), ''), '1');

  _payload := convert_from(decode(response, 'base64'), 'utf8')::jsonb;
  _data := COALESCE(_payload -> 'data', '{}'::jsonb);

  SELECT * INTO _merchant FROM public.merchants
  WHERE provider = 'phonepe' AND merchant_ref = (_data ->> 'merchantId');
  IF _merchant.id IS NULL THEN
    RAISE EXCEPTION 'unknown merchant';
  END IF;

  SELECT * INTO _cred FROM private.psp_credentials WHERE merchant_id = _merchant.id;
  IF _cred.phonepe_salt_key IS NULL THEN
    RAISE EXCEPTION 'merchant not configured';
  END IF;

  IF _cred.phonepe_salt_index <> _index
     OR encode(digest(response || _cred.phonepe_salt_key, 'sha256'), 'hex') <> _hash THEN
    RAISE EXCEPTION 'invalid signature';
  END IF;

  IF COALESCE(_payload ->> 'code', _data ->> 'state') NOT IN ('PAYMENT_SUCCESS', 'COMPLETED') THEN
    RETURN jsonb_build_object('ok', true, 'ignored', true);
  END IF;

  _payment_id := private.record_payment(
    _merchant.id, 'phonepe',
    COALESCE(_data ->> 'transactionId', _data ->> 'merchantTransactionId'),
    _data #>> '{paymentInstrument,utr}',
    (_data ->> 'amount')::bigint,
    _data #>> '{paymentInstrument,payerVpa}',
    _data #>> '{paymentInstrument,payerName}',
    _data ->> 'merchantTransactionId',
    NULL, now(), _payload
  );

  RETURN jsonb_build_object('ok', true, 'payment_id', _payment_id);
END;
$$;

-- --------------------------------------------------------- Paytm callback

CREATE OR REPLACE FUNCTION public.paytm_webhook(head jsonb, body jsonb)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, extensions
AS $$
DECLARE
  _token text;
  _merchant public.merchants%ROWTYPE;
  _cred private.psp_credentials%ROWTYPE;
  _payment_id uuid;
BEGIN
  _token := current_setting('request.headers', true)::jsonb ->> 'x-webhook-token';

  SELECT * INTO _merchant FROM public.merchants
  WHERE provider = 'paytm' AND merchant_ref = (body ->> 'mid');
  IF _merchant.id IS NULL THEN
    SELECT * INTO _merchant FROM public.merchants
    WHERE provider = 'paytm' AND merchant_ref = (body ->> 'MID');
  END IF;
  IF _merchant.id IS NULL THEN
    RAISE EXCEPTION 'unknown merchant';
  END IF;

  SELECT * INTO _cred FROM private.psp_credentials WHERE merchant_id = _merchant.id;
  IF _cred.paytm_webhook_token IS NULL OR _token IS NULL
     OR _cred.paytm_webhook_token <> _token THEN
    RAISE EXCEPTION 'invalid webhook token';
  END IF;

  IF upper(COALESCE(body ->> 'STATUS', body ->> 'status', '')) <> 'TXN_SUCCESS' THEN
    RETURN jsonb_build_object('ok', true, 'ignored', true);
  END IF;

  _payment_id := private.record_payment(
    _merchant.id, 'paytm',
    COALESCE(body ->> 'TXNID', body ->> 'txnId'),
    COALESCE(body ->> 'BANKTXNID', body ->> 'bankTxnId'),
    round(COALESCE(body ->> 'TXNAMOUNT', body ->> 'txnAmount')::numeric * 100)::bigint,
    COALESCE(body ->> 'PAYERVA', body ->> 'payerVa'),
    NULL,
    COALESCE(body ->> 'ORDERID', body ->> 'orderId'),
    NULL,
    now(),
    jsonb_build_object('head', head, 'body', body)
  );

  RETURN jsonb_build_object('ok', true, 'payment_id', _payment_id);
END;
$$;

-- ------------------------------------------------------- device endpoints

CREATE OR REPLACE FUNCTION public.device_pair(
  pairing_code text,
  label text DEFAULT 'Vendor phone',
  platform text DEFAULT NULL,
  fcm_token text DEFAULT NULL
) RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, extensions
AS $$
DECLARE
  _merchant public.merchants%ROWTYPE;
  _key text;
  _device_id uuid;
BEGIN
  SELECT * INTO _merchant FROM public.merchants m
  WHERE upper(m.pairing_code) = upper(trim(pairing_code));
  IF _merchant.id IS NULL THEN
    RAISE EXCEPTION 'invalid pairing code';
  END IF;

  _key := encode(gen_random_bytes(32), 'hex');

  INSERT INTO public.devices (merchant_id, device_key_hash, label, platform, fcm_token, last_seen_at)
  VALUES (_merchant.id, encode(digest(_key, 'sha256'), 'hex'),
          COALESCE(NULLIF(label, ''), 'Vendor phone'), platform, fcm_token, now())
  RETURNING id INTO _device_id;

  RETURN jsonb_build_object(
    'device_key', _key,
    'device_id', _device_id,
    'merchant', jsonb_build_object(
      'id', _merchant.id, 'name', _merchant.name,
      'provider', _merchant.provider, 'vpa', _merchant.vpa)
  );
END;
$$;

CREATE OR REPLACE FUNCTION public.payment_feed(device_key text, max_rows int DEFAULT 50)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, extensions
AS $$
DECLARE
  _device_id uuid := private.device_from_key(device_key);
  _rows jsonb;
BEGIN
  IF _device_id IS NULL THEN
    RAISE EXCEPTION 'unknown device';
  END IF;

  UPDATE public.devices SET last_seen_at = now() WHERE id = _device_id;

  SELECT COALESCE(jsonb_agg(t ORDER BY t.occurred_at), '[]'::jsonb) INTO _rows
  FROM (
    SELECT p.id, p.provider, p.provider_txn_id, p.utr, p.amount_paise,
           p.payer_vpa, p.payer_name, p.order_tag, p.occurred_at
    FROM public.upi_payments p
    JOIN public.devices d ON d.id = _device_id AND d.merchant_id = p.merchant_id
    WHERE NOT EXISTS (
      SELECT 1 FROM public.payment_acks a
      WHERE a.device_id = _device_id AND a.payment_id = p.id
    )
      AND p.occurred_at > now() - interval '3 days'
    ORDER BY p.occurred_at
    LIMIT LEAST(GREATEST(max_rows, 1), 200)
  ) t;

  RETURN jsonb_build_object('server_time', now(), 'payments', _rows);
END;
$$;

CREATE OR REPLACE FUNCTION public.payment_ack(device_key text, payment_ids uuid[])
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, extensions
AS $$
DECLARE
  _device_id uuid := private.device_from_key(device_key);
BEGIN
  IF _device_id IS NULL THEN
    RAISE EXCEPTION 'unknown device';
  END IF;

  INSERT INTO public.payment_acks (device_id, payment_id)
  SELECT _device_id, unnest(payment_ids)
  ON CONFLICT DO NOTHING;

  RETURN jsonb_build_object('ok', true);
END;
$$;

CREATE OR REPLACE FUNCTION public.device_heartbeat(device_key text, fcm_token text DEFAULT NULL)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, extensions
AS $$
DECLARE
  _device_id uuid := private.device_from_key(device_key);
BEGIN
  IF _device_id IS NULL THEN
    RAISE EXCEPTION 'unknown device';
  END IF;
  UPDATE public.devices
  SET last_seen_at = now(),
      fcm_token = COALESCE(NULLIF(fcm_token, ''), devices.fcm_token)
  WHERE id = _device_id;
  RETURN jsonb_build_object('ok', true);
END;
$$;

REVOKE ALL ON FUNCTION private.record_payment(uuid, text, text, text, bigint, text, text, text, text, timestamptz, jsonb) FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION private.device_from_key(text) FROM PUBLIC, anon, authenticated;

GRANT EXECUTE ON FUNCTION public.phonepe_webhook(text) TO anon, authenticated, service_role;
GRANT EXECUTE ON FUNCTION public.paytm_webhook(jsonb, jsonb) TO anon, authenticated, service_role;
GRANT EXECUTE ON FUNCTION public.device_pair(text, text, text, text) TO anon, authenticated, service_role;
GRANT EXECUTE ON FUNCTION public.payment_feed(text, int) TO anon, authenticated, service_role;
GRANT EXECUTE ON FUNCTION public.payment_ack(text, uuid[]) TO anon, authenticated, service_role;
GRANT EXECUTE ON FUNCTION public.device_heartbeat(text, text) TO anon, authenticated, service_role;
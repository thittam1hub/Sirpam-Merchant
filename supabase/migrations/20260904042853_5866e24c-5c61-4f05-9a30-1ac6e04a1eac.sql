CREATE TABLE public.merchants (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  provider text NOT NULL CHECK (provider IN ('phonepe','paytm','other')),
  merchant_ref text NOT NULL,
  vpa text,
  pairing_code text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (provider, merchant_ref),
  UNIQUE (pairing_code)
);

CREATE TABLE public.devices (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  merchant_id uuid NOT NULL REFERENCES public.merchants(id) ON DELETE CASCADE,
  device_key_hash text NOT NULL UNIQUE,
  label text NOT NULL DEFAULT 'Vendor phone',
  fcm_token text,
  platform text,
  last_seen_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX devices_merchant_idx ON public.devices (merchant_id);

CREATE TABLE public.upi_payments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  merchant_id uuid NOT NULL REFERENCES public.merchants(id) ON DELETE CASCADE,
  provider text NOT NULL,
  provider_txn_id text NOT NULL,
  utr text,
  amount_paise bigint NOT NULL CHECK (amount_paise > 0),
  currency text NOT NULL DEFAULT 'INR',
  payer_vpa text,
  payer_name text,
  order_tag text,
  note text,
  status text NOT NULL DEFAULT 'success',
  occurred_at timestamptz NOT NULL DEFAULT now(),
  raw jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (provider, provider_txn_id)
);
CREATE INDEX upi_payments_merchant_time_idx ON public.upi_payments (merchant_id, occurred_at DESC);

CREATE TABLE public.payment_acks (
  device_id uuid NOT NULL REFERENCES public.devices(id) ON DELETE CASCADE,
  payment_id uuid NOT NULL REFERENCES public.upi_payments(id) ON DELETE CASCADE,
  announced_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (device_id, payment_id)
);

GRANT ALL ON public.merchants TO service_role;
GRANT ALL ON public.devices TO service_role;
GRANT ALL ON public.upi_payments TO service_role;
GRANT ALL ON public.payment_acks TO service_role;

ALTER TABLE public.merchants ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.devices ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.upi_payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.payment_acks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "service role manages merchants" ON public.merchants FOR ALL TO service_role USING (true) WITH CHECK (true);
CREATE POLICY "service role manages devices" ON public.devices FOR ALL TO service_role USING (true) WITH CHECK (true);
CREATE POLICY "service role manages payments" ON public.upi_payments FOR ALL TO service_role USING (true) WITH CHECK (true);
CREATE POLICY "service role manages acks" ON public.payment_acks FOR ALL TO service_role USING (true) WITH CHECK (true);

CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER
LANGUAGE plpgsql
SET search_path = public
AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

CREATE TRIGGER update_merchants_updated_at BEFORE UPDATE ON public.merchants
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_devices_updated_at BEFORE UPDATE ON public.devices
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

ALTER TABLE public.upi_payments REPLICA IDENTITY FULL;
ALTER PUBLICATION supabase_realtime ADD TABLE public.upi_payments;
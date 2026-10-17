REVOKE EXECUTE ON FUNCTION public.phonepe_webhook(text) FROM authenticated;
REVOKE EXECUTE ON FUNCTION public.paytm_webhook(jsonb, jsonb) FROM authenticated;
REVOKE EXECUTE ON FUNCTION public.device_pair(text, text, text, text) FROM authenticated;
REVOKE EXECUTE ON FUNCTION public.payment_feed(text, int) FROM authenticated;
REVOKE EXECUTE ON FUNCTION public.payment_ack(text, uuid[]) FROM authenticated;
REVOKE EXECUTE ON FUNCTION public.device_heartbeat(text, text) FROM authenticated;
REVOKE EXECUTE ON FUNCTION public.phonepe_webhook(text) FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION public.paytm_webhook(jsonb, jsonb) FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION public.device_pair(text, text, text, text) FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION public.payment_feed(text, int) FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION public.payment_ack(text, uuid[]) FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION public.device_heartbeat(text, text) FROM PUBLIC;

GRANT EXECUTE ON FUNCTION public.phonepe_webhook(text) TO anon, service_role;
GRANT EXECUTE ON FUNCTION public.paytm_webhook(jsonb, jsonb) TO anon, service_role;
GRANT EXECUTE ON FUNCTION public.device_pair(text, text, text, text) TO anon, service_role;
GRANT EXECUTE ON FUNCTION public.payment_feed(text, int) TO anon, service_role;
GRANT EXECUTE ON FUNCTION public.payment_ack(text, uuid[]) TO anon, service_role;
GRANT EXECUTE ON FUNCTION public.device_heartbeat(text, text) TO anon, service_role;
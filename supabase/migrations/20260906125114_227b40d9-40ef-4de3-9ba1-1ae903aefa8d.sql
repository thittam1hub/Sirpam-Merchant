CREATE POLICY "service role manages orders" ON public.orders FOR ALL TO service_role USING (true) WITH CHECK (true);
CREATE POLICY "service role manages order items" ON public.order_items FOR ALL TO service_role USING (true) WITH CHECK (true);
GRANT ALL ON public.orders TO service_role;
GRANT ALL ON public.order_items TO service_role;
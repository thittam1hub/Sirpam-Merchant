import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu.dart';
import '../../../core/widgets/neu_chrome.dart';
import '../../../core/widgets/qr_scan_sheet.dart';
import '../../access/domain/permission.dart';
import '../../access/presentation/permission_guard.dart';
import '../../ledger/application/ledger_controller.dart';
import '../../ledger/domain/sale.dart';
import '../../orders/application/order_controller.dart';
import '../../orders/application/order_sync_controller.dart';
import '../../products/application/inventory_controller.dart';
import '../../products/domain/inventory_models.dart';
import '../../products/presentation/inventory_widgets.dart';
import '../../profile/application/profile_controller.dart';
import '../../profile/application/vendor_presets.dart';

import '../../soundbox/application/soundbox_service.dart';

/// Menu tiles for shops that sell the same few items hundreds of times a day.
/// One tap = one sale in the ledger AND one FIFO stock movement.
class QuickSalePage extends ConsumerStatefulWidget {
  const QuickSalePage({super.key});

  @override
  ConsumerState<QuickSalePage> createState() => _QuickSalePageState();
}

class _QuickSalePageState extends ConsumerState<QuickSalePage> {
  SaleMode _mode = SaleMode.cash;
  String? _feedback;

  /// Sold out is one shared flag: the tile, the order board and the QR menu
  /// all read the same shop config, so the kitchen never has to say no twice.
  Future<void> _toggleSoldOut(Product product) async {
    final soldOut = !ref.read(shopConfigProvider).isSoldOut(product.id);
    await ref.read(shopConfigProvider.notifier).toggleSoldOut(product.id, soldOut);
    await ref.read(orderSyncProvider.notifier)
        .pushAvailability(product.id, !soldOut);
    if (!mounted) return;
    setState(() => _feedback = soldOut
        ? context.l10n.quickSaleSoldOutOn(product.displayName)
        : context.l10n.quickSaleSoldOutOff(product.displayName));
  }

  Future<void> _sell(Product product, int qty) async {
    final revenue = product.pricePaise * qty;
    if (revenue <= 0) return;
    if (ref.read(shopConfigProvider).isSoldOut(product.id)) {
      setState(() =>
          _feedback = context.l10n.quickSaleSoldOutOn(product.displayName));
      return;
    }
    final allowed = await ref.guard(context, Permission.quickSale,
        amountPaise: revenue, action: 'sale.quick', note: product.displayName);
    if (!allowed.ok || !mounted) return;
    // Credit is money leaving the till on trust, so it carries its own limit.
    if (_mode == SaleMode.credit) {
      final creditOk = await ref.guard(context, Permission.giveCredit,
          amountPaise: revenue, action: 'sale.credit');
      if (!creditOk.ok || !mounted) return;
    }
    unawaited(HapticFeedback.selectionClick());

    await ref.read(ledgerProvider.notifier).addSale(
          amountPaise: revenue,
          mode: _mode,
          item: product.displayName,
          customer: _mode == SaleMode.credit ? 'Walk-in' : null,
        );
    await ref.read(inventoryProvider.notifier).sellStock(
          productId: product.id,
          qtyMilli: qty * 1000,
          revenuePaise: revenue,
        );
    if (_mode == SaleMode.upi) {
      await ref.read(soundboxProvider.notifier).announce(revenue / 100);
    }
    if (!mounted) return;
    setState(() => _feedback =
        context.l10n.quickSaleDone(product.displayName, money(revenue)));
  }

  /// Scan a printed product label and put that item straight on the bill.
  Future<void> _scanToSell() async {
    final l10n = context.l10n;
    final code = await scanCode(context, title: l10n.quickSaleScanTitle);
    if (code == null || !mounted) return;
    final product = ref.read(inventoryProvider).byCode(code.trim());
    if (product == null) {
      setState(() => _feedback = l10n.quickSaleScanUnknown(code.trim()));
      return;
    }
    await _sell(product, 1);
  }

  Future<void> _sellMany(Product product) async {
    final controller = TextEditingController(text: '2');
    final qty = await showDialog<int>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: NeuColors.canvas,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            SectionTitle(ctx.l10n.quickSaleQtyTitle(product.displayName)),
            LabeledField(
                label: ctx.l10n.quickSaleQty,
                controller: controller,
                autofocus: true,
                keyboard: TextInputType.number),
            ActionRow(children: [
              NeuTextButton(
                  label: ctx.l10n.cancel,
                  onPressed: () => Navigator.of(ctx).pop()),
              NeuTextButton(
                  label: ctx.l10n.save,
                  color: NeuColors.accentDark,
                  onPressed: () => Navigator.of(ctx)
                      .pop(int.tryParse(controller.text.trim()) ?? 0)),
            ]),
          ]),
        ),
      ),
    );
    controller.dispose();
    if (qty != null && qty > 0) await _sell(product, qty);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final inv = ref.watch(inventoryProvider);
    final ledger = ref.watch(ledgerProvider);
    final shop = ref.watch(shopConfigProvider);
    final menu =
        inv.activeProducts.where((p) => p.pricePaise > 0).toList();

    return DetailScaffold(
      title: l10n.quickSaleTitle,
      subtitle: l10n.quickSaleSubtitle,
      fallbackLocation: AppPaths.home,
      // One scroll view for the whole page: at large text settings the
      // header card alone can be taller than a 320 x 640 screen.
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
            child: NeuBox(
              child: Column(children: [
                Row(children: [
                  Expanded(
                    child: Text(l10n.todayCollection,
                        style: TextStyle(
                            fontSize: 14, color: NeuColors.inkSoft)),
                  ),
                  AnimatedMoney(ledger.todayPaise / 100,
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: NeuColors.ink)),
                ]),
                const SizedBox(height: 12),
                NeuButton(
                  onPressed: _scanToSell,
                  minHeight: 46,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.qr_code_scanner_rounded,
                          size: 20, color: NeuColors.accentDark),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(l10n.quickSaleScan,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: NeuColors.accentDark)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(children: [
                  for (final m in SaleMode.values) ...[
                    Expanded(
                      child: NeuButton(
                        selected: _mode == m,
                        minHeight: 44,
                        onPressed: () => setState(() => _mode = m),
                        child: Text(
                            switch (m) {
                              SaleMode.cash => l10n.modeCash,
                              SaleMode.upi => l10n.modeUpi,
                              SaleMode.credit => l10n.modeCredit,
                            },
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: _mode == m
                                    ? NeuColors.accentDark
                                    : NeuColors.inkSoft)),
                      ),
                    ),
                    if (m != SaleMode.credit) const SizedBox(width: 10),
                  ],
                ]),
              ]),
            ),
          ),
          if (_feedback != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
              child: NeuBox(
                inset: true,
                child: Row(children: [
                  Icon(Icons.check_circle_outline,
                      color: NeuColors.accentDark),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Text(_feedback!,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: NeuColors.ink))),
                ]),
              ),
            ),
          Builder(
            builder: (context) => menu.isEmpty
                ? SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: NeuBox(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(l10n.quickSaleEmpty,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: NeuColors.inkSoft)),
                            const SizedBox(height: 14),
                            NeuButton(
                              onPressed: () => applyVendorPreset(
                                ref,
                                vendorPreset(
                                    l10n, ref.read(profileProvider).category),
                              ),
                              child: Text(l10n.starterPackAction,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: NeuColors.accentDark)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )

                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 32),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 190,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.25,
                    ),
                    itemCount: menu.length,
                    itemBuilder: (_, i) {
                      final p = menu[i];
                      final onHand = inv.onHand(p.id);
                      final soldOut = shop.isSoldOut(p.id);
                      return Semantics(
                        button: true,
                        label: l10n.quickSaleSemantic(
                            p.displayName, money(p.pricePaise)),
                        child: GestureDetector(
                          onLongPress: () => _sellMany(p),
                          child: NeuBox(
                            onTap: () => _sell(p, 1),
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(p.displayName,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: NeuColors.ink)),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(money(p.pricePaise),
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
                                              color: soldOut
                                                  ? NeuColors.inkSoft
                                                  : NeuColors.accentDark)),
                                    ),
                                    if (soldOut)
                                      StatusPill(l10n.menuSoldOut,
                                          color: NeuColors.warn)
                                    else if (onHand <= 0)
                                      StatusPill(l10n.stockOut,
                                          color: NeuColors.warn),
                                    const SizedBox(width: 4),
                                    NeuIconButton(
                                      icon: soldOut
                                          ? Icons.restart_alt_rounded
                                          : Icons.block_rounded,
                                      label: l10n.menuSoldOut,
                                      onPressed: () => _toggleSoldOut(p),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

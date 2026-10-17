import 'package:barcode/barcode.dart' as bc;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/settings/settings_controller.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/barcode_view.dart';
import '../../../core/widgets/neu.dart';
import '../../../core/widgets/neu_chrome.dart';
import '../../products/application/inventory_controller.dart';
import '../../products/presentation/inventory_widgets.dart';
import '../application/order_controller.dart';
import '../application/order_sync_controller.dart';
import '../application/table_qr_sheet.dart';
import '../data/ordering_api.dart';

/// Publishes the customer-facing QR menu: which items show, which are sold
/// out, and the printable table QR sheet.
class MenuPage extends ConsumerStatefulWidget {
  const MenuPage({super.key});

  @override
  ConsumerState<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends ConsumerState<MenuPage> {
  late final TextEditingController _slug;
  late final TextEditingController _base;
  late final TextEditingController _tables;
  late final TextEditingController _tax;
  late final TextEditingController _gstin;
  late final TextEditingController _address;
  late final TextEditingController _phone;
  late final TextEditingController _fssai;
  late final TextEditingController _key;

  @override
  void initState() {
    super.initState();
    final shop = ref.read(shopConfigProvider);
    _slug = TextEditingController(text: shop.slug);
    _base = TextEditingController(text: shop.menuBaseUrl);
    _tables = TextEditingController(text: '${shop.tableCount}');
    _tax = TextEditingController(
        text: shop.taxPercent == 0 ? '' : '${shop.taxPercent}');
    _gstin = TextEditingController(text: shop.gstin);
    _address = TextEditingController(text: shop.address);
    _phone = TextEditingController(text: shop.phone);
    _fssai = TextEditingController(text: shop.fssai);
    _key = TextEditingController(text: shop.shopKey);
  }

  @override
  void dispose() {
    _slug.dispose();
    _base.dispose();
    _tables.dispose();
    _tax.dispose();
    _gstin.dispose();
    _address.dispose();
    _phone.dispose();
    _fssai.dispose();
    _key.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final shop = ref.read(shopConfigProvider);
    await ref.read(shopConfigProvider.notifier).save(shop.copyWith(
          slug: _slug.text.trim(),
          menuBaseUrl: _base.text.trim(),
          tableCount: int.tryParse(_tables.text.trim())?.clamp(0, 99) ?? 0,
          taxPercent: double.tryParse(_tax.text.trim()) ?? 0,
          gstin: _gstin.text.trim(),
          address: _address.text.trim(),
          phone: _phone.text.trim(),
          fssai: _fssai.text.trim(),
          shopKey: _key.text.trim(),
        ));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(context.l10n.menuSaved)));
  }

  Future<void> _printQrSheet() async {
    final l10n = context.l10n;
    final shop = ref.read(shopConfigProvider);
    final name = ref.read(settingsProvider).stallName;
    final bytes = await TableQrSheet.build(
      shop: shop,
      shopName: name.isEmpty ? l10n.appTitle : name,
      tableLabel: l10n.orderTable,
      counterLabel: l10n.menuCounterQr,
      scanHint: l10n.menuScanHint,
    );
    await Printing.layoutPdf(
        onLayout: (_) async => bytes, name: l10n.menuQrSheet);
  }

  /// Registers the shop and pushes the published menu to the cloud so the QR
  /// menu and the board share one source of truth.
  Future<void> _publishCloud() async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    await _save();
    final shop = ref.read(shopConfigProvider);
    final products = ref
        .read(inventoryProvider)
        .activeProducts
        .where((p) => p.pricePaise > 0 && shop.isPublished(p.id))
        .toList();
    try {
      final count = await ref.read(orderSyncProvider.notifier).publish([
        for (var i = 0; i < products.length; i++)
          {
            'ext_id': products[i].id,
            'name': products[i].displayName,
            'category': products[i].category,
            'price_paise': products[i].pricePaise,
            'available': !shop.isSoldOut(products[i].id),
            'sort': i,
          },
      ]);
      messenger.showSnackBar(
          SnackBar(content: Text(l10n.menuCloudPublished(count))));
    } on OrderingApiFailure catch (e) {
      messenger
          .showSnackBar(SnackBar(content: Text(l10n.menuCloudFailed(e.message))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final shop = ref.watch(shopConfigProvider);
    final shopCtl = ref.read(shopConfigProvider.notifier);
    final sync = ref.watch(orderSyncProvider);
    final products = ref
        .watch(inventoryProvider)
        .activeProducts
        .where((p) => p.pricePaise > 0)
        .toList();

    return DetailScaffold(
      title: l10n.menuTitle,
      subtitle: l10n.menuSubtitle,
      fallbackLocation: AppPaths.orders,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 32),
        children: [
          SectionTitle(l10n.menuShopSection),
          LabeledField(label: l10n.menuSlug, controller: _slug),
          LabeledField(
              label: l10n.menuBaseUrl,
              controller: _base,
              keyboard: TextInputType.url),
          Row(children: [
            Expanded(
              child: LabeledField(
                  label: l10n.menuTableCount,
                  controller: _tables,
                  keyboard: TextInputType.number),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: LabeledField(
                label: l10n.menuTaxPercent,
                controller: _tax,
                keyboard: const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
          ]),
          Row(children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.shopGstRegistered,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: NeuColors.inkSoft)),
                  Text(l10n.shopGstRegisteredHint,
                      style: TextStyle(
                          fontSize: 12, color: NeuColors.inkSoft)),
                ],
              ),
            ),
            NeuSwitch(
              value: shop.gstRegistered,
              label: l10n.shopGstRegistered,
              onChanged: (v) => shopCtl.save(shop.copyWith(gstRegistered: v)),
            ),
          ]),
          if (shop.gstRegistered)
            Row(children: [
              Expanded(
                child: Text(l10n.shopPriceIncludesTax,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: NeuColors.inkSoft)),
              ),
              NeuSwitch(
                value: shop.priceIncludesTax,
                label: l10n.shopPriceIncludesTax,
                onChanged: (v) =>
                    shopCtl.save(shop.copyWith(priceIncludesTax: v)),
              ),
            ]),
          const SizedBox(height: 8),
          LabeledField(label: l10n.menuGstin, controller: _gstin),
          LabeledField(label: l10n.menuAddress, controller: _address),
          Row(children: [
            Expanded(
              child: LabeledField(
                  label: l10n.menuPhone,
                  controller: _phone,
                  keyboard: TextInputType.phone),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: LabeledField(label: l10n.menuFssai, controller: _fssai),
            ),
          ]),
          Row(children: [
            Expanded(
              child: Text(l10n.menuAcceptOrders,
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: NeuColors.inkSoft)),
            ),
            NeuSwitch(
              value: shop.acceptOnlineOrders,
              label: l10n.menuAcceptOrders,
              onChanged: (v) =>
                  shopCtl.save(shop.copyWith(acceptOnlineOrders: v)),
            ),
          ]),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(
              child: NeuButton(
                onPressed: _save,
                child: Text(l10n.save,
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: NeuColors.accentDark)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: NeuButton(
                onPressed: _printQrSheet,
                child: Text(l10n.menuQrSheet,
                    style: TextStyle(
                        fontWeight: FontWeight.w700, color: NeuColors.inkSoft)),
              ),
            ),
          ]),
          const SizedBox(height: 18),
          SectionTitle(l10n.menuCloudSection),
          LabeledField(label: l10n.menuShopKey, controller: _key),
          Row(children: [
            Expanded(
              child: Text(l10n.menuCloudSync,
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: NeuColors.inkSoft)),
            ),
            NeuSwitch(
              value: shop.cloudSync,
              label: l10n.menuCloudSync,
              onChanged: (v) => shopCtl.save(
                  shop.copyWith(cloudSync: v, shopKey: _key.text.trim())),
            ),
          ]),
          const SizedBox(height: 10),
          NeuButton(
            onPressed: _publishCloud,
            child: Text(l10n.menuCloudPublish,
                style: TextStyle(
                    fontWeight: FontWeight.w800, color: NeuColors.accentDark)),
          ),
          const SizedBox(height: 10),
          NeuBox(
            child: Text(
              sync.error.isNotEmpty
                  ? l10n.menuCloudFailed(sync.error)
                  : sync.enabled
                      ? l10n.menuCloudLive
                      : l10n.menuCloudOffline,
              style: TextStyle(
                  fontSize: 12,
                  color: sync.error.isNotEmpty
                      ? NeuColors.danger
                      : NeuColors.inkSoft),
            ),
          ),
          const SizedBox(height: 18),
          SectionTitle(l10n.menuLinkSection),
          NeuBox(
            child: Column(children: [
              BarcodeView(
                  data: shop.menuUrl(0),
                  symbology: bc.Barcode.qrCode(),
                  width: 170,
                  height: 170),
              const SizedBox(height: 10),
              SelectableText(shop.menuUrl(0),
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontSize: 12, color: NeuColors.inkSoft)),
            ]),
          ),
          const SizedBox(height: 18),
          SectionTitle(l10n.menuItemsSection),
          if (products.isEmpty)
            NeuBox(
              child: Text(l10n.quickSaleEmpty,
                  style: TextStyle(color: NeuColors.inkSoft)),
            ),
          for (final p in products)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: NeuBox(
                child: Row(children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.displayName,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: NeuColors.ink)),
                        Text(money(p.pricePaise),
                            style: TextStyle(
                                fontSize: 12, color: NeuColors.inkSoft)),
                      ],
                    ),
                  ),
                  if (shop.isSoldOut(p.id))
                    StatusPill(l10n.menuSoldOut, color: NeuColors.warn),
                  NeuIconButton(
                    icon: shop.isSoldOut(p.id)
                        ? Icons.restart_alt_rounded
                        : Icons.block_rounded,
                    label: l10n.menuSoldOut,
                    onPressed: () async {
                      final soldOut = !shop.isSoldOut(p.id);
                      await shopCtl.toggleSoldOut(p.id, soldOut);
                      await ref
                          .read(orderSyncProvider.notifier)
                          .pushAvailability(p.id, !soldOut);
                    },
                  ),
                  const SizedBox(width: 6),
                  NeuSwitch(
                    value: shop.isPublished(p.id),
                    label: l10n.menuPublished,
                    onChanged: (v) => shopCtl.togglePublished(p.id, v),
                  ),
                ]),
              ),
            ),
        ],
      ),
    );
  }
}

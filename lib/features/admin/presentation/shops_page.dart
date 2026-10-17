import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu.dart';
import '../../orders/application/order_controller.dart';
import '../../orders/data/ordering_api.dart';
import '../../orders/domain/shop_config.dart';
import '../../products/presentation/inventory_widgets.dart';
import 'admin_widgets.dart';

class _ShopTotals {
  final String slug;
  final String name;
  final int orders;
  final int cancelled;
  final int billedPaise;
  final String error;

  const _ShopTotals({
    required this.slug,
    this.name = '',
    this.orders = 0,
    this.cancelled = 0,
    this.billedPaise = 0,
    this.error = '',
  });
}

/// One screen for an owner running more than one shop: last seven days of
/// orders and value per shop, read with each shop's own owner key.
class ShopsPage extends ConsumerStatefulWidget {
  const ShopsPage({super.key});

  @override
  ConsumerState<ShopsPage> createState() => _ShopsPageState();
}

class _ShopsPageState extends ConsumerState<ShopsPage> {
  final _slug = TextEditingController();
  final _key = TextEditingController();
  List<_ShopTotals> _rows = const [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void dispose() {
    _slug.dispose();
    _key.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final shop = ref.read(shopConfigProvider);
    final targets = <LinkedShop>[
      if (shop.cloudReady)
        LinkedShop(slug: shop.slug, shopKey: shop.shopKey, label: shop.shopName),
      ...shop.otherShops,
    ];
    if (targets.isEmpty) {
      setState(() => _rows = const []);
      return;
    }
    setState(() => _loading = true);
    final errorLabel = context.l10n.adminShopsError;
    final api = OrderingApi();
    final out = <_ShopTotals>[];
    for (final t in targets) {
      try {
        final data =
            await api.salesRollup(slug: t.slug, shopKey: t.shopKey, days: 7);
        out.add(_ShopTotals(
          slug: t.slug,
          name: (data['name'] as String?)?.isNotEmpty == true
              ? data['name'] as String
              : t.label,
          orders: (data['orders'] as num?)?.toInt() ?? 0,
          cancelled: (data['cancelled'] as num?)?.toInt() ?? 0,
          billedPaise: (data['billed_paise'] as num?)?.toInt() ?? 0,
        ));
      } catch (_) {
        out.add(_ShopTotals(slug: t.slug, name: t.label, error: errorLabel));
      }
    }
    if (!mounted) return;
    setState(() {
      _rows = out;
      _loading = false;
    });
  }

  Future<void> _add() async {
    final slug = _slug.text.trim().toLowerCase();
    final key = _key.text.trim();
    if (slug.isEmpty || key.length < 16) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.adminShopsInvalid)));
      return;
    }
    final shop = ref.read(shopConfigProvider);
    if (slug == shop.slug || shop.otherShops.any((s) => s.slug == slug)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.adminShopsExists)));
      return;
    }
    await ref.read(shopConfigProvider.notifier).save(shop.copyWith(
        otherShops: [...shop.otherShops, LinkedShop(slug: slug, shopKey: key)]));
    _slug.clear();
    _key.clear();
    await _load();
  }

  Future<void> _remove(String slug) async {
    final shop = ref.read(shopConfigProvider);
    await ref.read(shopConfigProvider.notifier).save(shop.copyWith(
        otherShops: [for (final s in shop.otherShops) if (s.slug != slug) s]));
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final shop = ref.watch(shopConfigProvider);
    final totalOrders = _rows.fold(0, (a, r) => a + r.orders);
    final totalBilled = _rows.fold(0, (a, r) => a + r.billedPaise);

    return DetailScaffold(
      title: l10n.adminShopsTitle,
      subtitle: l10n.adminShopsSubtitle,
      fallbackLocation: AppPaths.admin,
      actions: [
        IconButton(
          tooltip: l10n.adminShopsRefresh,
          onPressed: _loading ? null : _load,
          icon: const Icon(Icons.refresh_rounded),
        ),
      ],
      body: ResponsiveContent(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
          children: [
            if (_loading) const LinearProgressIndicator(minHeight: 2),
            if (_rows.isNotEmpty) ...[
              NeuBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SectionTitle(l10n.adminShopsAllTotal),
                    AdminStatRow(l10n.adminShopsOrders, '$totalOrders'),
                    AdminStatRow(l10n.adminShopsValue, money(totalBilled)),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],
            if (_rows.isEmpty && !_loading) const AdminEmpty(),
            for (final r in _rows)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: NeuBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(children: [
                        Expanded(
                          child: Text(
                              r.name.isEmpty ? r.slug : '${r.name} · ${r.slug}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: NeuColors.ink)),
                        ),
                        if (r.slug != shop.slug)
                          IconButton(
                            tooltip: l10n.adminShopsRemove,
                            icon: const Icon(Icons.delete_outline_rounded,
                                size: 20),
                            onPressed: () => _remove(r.slug),
                          ),
                      ]),
                      if (r.error.isNotEmpty)
                        Text(r.error,
                            style: TextStyle(
                                fontSize: 12, color: NeuColors.danger))
                      else ...[
                        AdminStatRow(l10n.adminShopsOrders, '${r.orders}'),
                        AdminStatRow(
                            l10n.adminShopsValue, money(r.billedPaise)),
                        AdminStatRow(
                            l10n.dashboardCancelled, '${r.cancelled}'),
                      ],
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 8),
            NeuBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SectionTitle(l10n.adminShopsAdd),
                  Text(l10n.adminShopsAddHelp,
                      style:
                          TextStyle(fontSize: 12, color: NeuColors.inkSoft)),
                  const SizedBox(height: 12),
                  LabeledField(label: l10n.adminShopsSlug, controller: _slug),
                  LabeledField(
                      label: l10n.adminShopsKey,
                      controller: _key,
                      obscure: true),
                  NeuTextButton(
                      label: l10n.adminShopsAddAction,
                      color: NeuColors.accentDark,
                      onPressed: _add),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

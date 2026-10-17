import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../orders/application/order_controller.dart';
import '../../orders/application/order_sync_controller.dart';
import '../../orders/data/ordering_api.dart';
import '../../orders/domain/shop_config.dart';
import 'settings_widgets.dart';

/// Merchant-chosen ordering rules the customer QR menu obeys.
/// `?focus=service|pay|buttons` scrolls the merchant to one decision.
class OrderingSettingsPage extends ConsumerStatefulWidget {
  final String? focus;
  const OrderingSettingsPage({super.key, this.focus});
  @override
  ConsumerState<OrderingSettingsPage> createState() =>
      _OrderingSettingsPageState();
}

class _OrderingSettingsPageState extends ConsumerState<OrderingSettingsPage> {
  late final ShopConfig _initial = ref.read(shopConfigProvider);
  late String _service = _initial.serviceMode;
  late String _pay = _initial.payMode;
  late bool _callStaff = _initial.allowCallStaff;
  late bool _requestBill = _initial.allowRequestBill;
  late final TextEditingController _slug =
      TextEditingController(text: _initial.slug);
  late final TextEditingController _shopKey =
      TextEditingController(text: _initial.shopKey);
  bool _creating = false;

  @override
  void dispose() {
    _slug.dispose();
    _shopKey.dispose();
    super.dispose();
  }

  void _generateKey() {
    const chars = 'abcdefghijkmnpqrstuvwxyz23456789';
    final r = Random.secure();
    setState(() => _shopKey.text =
        List.generate(24, (_) => chars[r.nextInt(chars.length)]).join());
  }

  /// Turns whatever the merchant typed into a safe web address part.
  static String normalizeSlug(String raw) => raw
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-+|-+$'), '');

  static final _slugOk = RegExp(r'^[a-z0-9][a-z0-9-]{2,38}$');

  /// Plain-language version of a server or network failure.
  String _friendly(AppLocalizations l10n, Object error, String slug) {
    final text = error is OrderingApiFailure
        ? error.message.toLowerCase()
        : '$error'.toLowerCase();
    if (text.contains('already taken') || text.contains('duplicate')) {
      return l10n.cloudShopSlugTaken('$slug-2');
    }
    if (text.contains('socket') ||
        text.contains('failed host') ||
        text.contains('network') ||
        text.contains('timeout') ||
        text.contains('clientexception')) {
      return l10n.cloudShopOffline;
    }
    return l10n.cloudShopTryAgain;
  }

  Future<void> _createCloudShop() async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final slug = normalizeSlug(_slug.text);
    final key = _shopKey.text.trim();
    if (!_slugOk.hasMatch(slug)) {
      messenger
          .showSnackBar(SnackBar(content: Text(l10n.cloudShopSlugInvalid)));
      return;
    }
    if (key.length < 16) {
      messenger
          .showSnackBar(SnackBar(content: Text(l10n.cloudShopKeyShort)));
      return;
    }
    _slug.text = slug;
    setState(() => _creating = true);
    try {
      await ref
          .read(orderSyncProvider.notifier)
          .createCloudShop(slug: slug, shopKey: key);
      messenger.showSnackBar(SnackBar(content: Text(l10n.cloudShopCreated)));
    } catch (e) {
      messenger
          .showSnackBar(SnackBar(content: Text(_friendly(l10n, e, slug))));
    } finally {
      if (mounted) setState(() => _creating = false);
    }
  }

  bool get _dirty =>
      _service != _initial.serviceMode ||
      _pay != _initial.payMode ||
      _callStaff != _initial.allowCallStaff ||
      _requestBill != _initial.allowRequestBill;

  Future<void> _save() async {
    await ref.read(shopConfigProvider.notifier).save(
          ref.read(shopConfigProvider).copyWith(
                serviceMode: _service,
                payMode: _pay,
                allowCallStaff: _callStaff,
                allowRequestBill: _requestBill,
              ),
        );
    // Every table QR follows the new rules on its next menu poll.
    await ref.read(orderSyncProvider.notifier).pushShopRules();
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(context.l10n.settingsSaved)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tableService = _service == 'table';
    final shop = ref.watch(shopConfigProvider);
    return DetailScaffold(
      title: l10n.settingsOrderingTitle,
      fallbackLocation: AppPaths.settings,
      isDirty: () => _dirty,
      body: SettingsFormBody(
        saveLabel: l10n.save,
        onSave: _save,
        children: [
          SettingsCard(
            children: [
              Text(l10n.cloudShopSection,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w800)),
              Text(
                shop.cloudReady
                    ? l10n.cloudShopLive(shop.slug)
                    : l10n.cloudShopNone,
                style: const TextStyle(fontSize: 12.5),
              ),
              SettingsField(label: l10n.cloudShopSlug, controller: _slug),
              SettingsField(
                label: l10n.cloudShopKey,
                controller: _shopKey,
                helper: l10n.cloudShopHint,
              ),
              Row(children: [
                Expanded(
                  child: TextButton(
                    onPressed: _generateKey,
                    child: Text(l10n.cloudShopGenerate),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      await Clipboard.setData(
                          ClipboardData(text: _shopKey.text.trim()));
                      messenger.showSnackBar(
                          SnackBar(content: Text(l10n.cloudShopKeyCopied)));
                    },
                    child: Text(l10n.cloudShopCopyKey),
                  ),
                ),
              ]),
              FilledButton(
                onPressed: _creating ? null : _createCloudShop,
                child: Text(shop.cloudReady
                    ? l10n.cloudShopUpdate
                    : l10n.cloudShopCreate),
              ),
              if (shop.cloudReady) ...[
                Text(l10n.cloudShopLinkTitle,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w800)),
                SelectableText(shop.menuUrl(0),
                    style: const TextStyle(fontSize: 12.5)),
                Row(children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        final messenger = ScaffoldMessenger.of(context);
                        await Clipboard.setData(
                            ClipboardData(text: shop.menuUrl(0)));
                        messenger.showSnackBar(
                            SnackBar(content: Text(l10n.cloudShopLinkCopied)));
                      },
                      child: Text(l10n.cloudShopCopyLink),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () => context.push(AppRoutes.menu()),
                      child: Text(l10n.cloudShopShowQr),
                    ),
                  ),
                ]),
              ],
            ],
          ),
          const SizedBox(height: 14),
          SettingsCard(
            children: [
              Text(l10n.serviceStyle,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w800)),
              SettingsSegmented<String>(
                options: [
                  ('table', l10n.serviceTable),
                  ('self', l10n.serviceSelf),
                  ('takeaway', l10n.serviceTakeaway),
                ],
                value: _service,
                onChanged: (v) => setState(() => _service = v),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SettingsCard(
            children: [
              Text(l10n.paymentTiming,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w800)),
              SettingsSegmented<String>(
                options: [
                  ('before', l10n.payBefore),
                  ('after', l10n.payAfter),
                ],
                value: _pay,
                onChanged: (v) => setState(() => _pay = v),
              ),
              Text(l10n.payTimingHelp,
                  style: const TextStyle(fontSize: 12.5)),
            ],
          ),
          const SizedBox(height: 14),
          SettingsCard(
            children: [
              Text(l10n.customerButtons,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w800)),
              SettingsToggleRow(
                label: l10n.allowCallStaff,
                value: _callStaff && tableService,
                onChanged: tableService
                    ? (v) => setState(() => _callStaff = v)
                    : (_) {},
              ),
              SettingsToggleRow(
                label: l10n.allowRequestBill,
                value: _requestBill && tableService,
                onChanged: tableService
                    ? (v) => setState(() => _requestBill = v)
                    : (_) {},
              ),
              Text(l10n.customerButtonsHelp,
                  style: const TextStyle(fontSize: 12.5)),
            ],
          ),
        ],
      ),
    );
  }
}

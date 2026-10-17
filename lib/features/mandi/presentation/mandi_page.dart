import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/settings/settings_controller.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/neu.dart';
import '../../../core/widgets/neu_chrome.dart';
import '../application/mandi_controller.dart';

class MandiPage extends ConsumerStatefulWidget {
  /// `/mandi?market=Koyambedu&q=<vegetable>` (query is URL-encoded Tamil or English)
  final String marketParam;
  final String searchParam;
  const MandiPage({super.key, this.marketParam = '', this.searchParam = ''});
  @override
  ConsumerState<MandiPage> createState() => _MandiPageState();
}

class _MandiPageState extends ConsumerState<MandiPage> {
  late String _query = widget.searchParam.toLowerCase();
  late final TextEditingController _searchCtrl =
      TextEditingController(text: widget.searchParam);

  @override
  void initState() {
    super.initState();
    // A deep link may carry a market the vendor has not selected yet.
    final m = widget.marketParam;
    if (m.isNotEmpty && MandiController.markets.contains(m)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final s = ref.read(settingsProvider);
        if (s.market != m) {
          ref.read(settingsProvider.notifier).save(s.copyWith(market: m));
        }
      });
    }
  }

  @override
  void didUpdateWidget(covariant MandiPage old) {
    super.didUpdateWidget(old);
    if (old.searchParam != widget.searchParam &&
        widget.searchParam.toLowerCase() != _query) {
      _query = widget.searchParam.toLowerCase();
      _searchCtrl.text = widget.searchParam;
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearch(String v) {
    final trimmed = v.trim();
    setState(() => _query = trimmed.toLowerCase());
    // Reflect the search in the URL so it can be shared/bookmarked.
    context.replace(AppRoutes.mandi(
        market: ref.read(settingsProvider).market, search: trimmed));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final async = ref.watch(mandiProvider);
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: NeuColors.canvas,
      appBar: NeuAppBar(
        title: l10n.mandiTitle,
        subtitle: settings.market,
        actions: [
          NeuIconButton(
            icon: Icons.refresh_rounded,
            label: l10n.refresh,
            onPressed: () => ref.read(mandiProvider.notifier).refresh(),
          ),
        ],
      ),
      body: async.when(
        loading: () => NeuLoader(label: l10n.mandiLoading),
        error: (e, _) => _Message(
            icon: Icons.cloud_off,
            title: l10n.fetchFailed,
            body: '$e'),
        data: (state) {
          final rows = state.prices
              .where((p) =>
                  _query.isEmpty ||
                  p.commodity.toLowerCase().contains(_query) ||
                  p.variety.toLowerCase().contains(_query))
              .toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 32),
            children: [
              _MarketPicker(current: settings.market),
              const SizedBox(height: 14),
              if (state.status == MandiStatus.needsKey)
                _Message(
                  icon: Icons.key_outlined,
                  title: l10n.apiKeyNeeded,
                  body: l10n.apiKeyNeededBody,
                ),
              if (state.status == MandiStatus.error && state.error != null)
                _Message(
                    icon: Icons.error_outline,
                    title: l10n.refreshFailed,
                    body: state.error!.resolve(l10n)),
              if (state.syncedAt != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 4),
                  child: Text(
                    l10n.lastUpdated(DateFormat('d MMM, h:mm a').format(
                        DateTime.fromMillisecondsSinceEpoch(state.syncedAt!))),
                    style: TextStyle(
                        fontSize: 13, color: NeuColors.inkSoft),
                  ),
                ),
              if (state.prices.isNotEmpty) ...[
                const SizedBox(height: 10),
                NeuField(
                  controller: _searchCtrl,
                  action: TextInputAction.search,
                  onSubmitted: _onSearch,
                  onChanged: (v) =>
                      setState(() => _query = v.trim().toLowerCase()),
                  hint: l10n.searchVegetable,
                  leading: Icon(Icons.search, color: NeuColors.inkSoft),
                ),

                const SizedBox(height: 14),
                ...rows.map((p) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: NeuBox(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(p.commodity,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: NeuColors.ink)),
                                  Text(
                                    [p.variety, p.market, p.arrivalDate]
                                        .where((s) => s.isNotEmpty)
                                        .join(' · '),
                                    style: TextStyle(
                                        fontSize: 12.5,
                                        color: NeuColors.inkSoft),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('₹${p.modalPerKg.toStringAsFixed(2)}/kg',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: NeuColors.accentDark)),
                                Text(
                                    '₹${p.minPerKg.toStringAsFixed(2)} – ₹${p.maxPerKg.toStringAsFixed(2)}',
                                    style: TextStyle(
                                        fontSize: 12.5,
                                        color: NeuColors.inkSoft)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _MarketPicker extends ConsumerWidget {
  final String current;
  const _MarketPicker({required this.current});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NeuBox(
      child: Row(
        children: [
          Icon(Icons.store_mall_directory_outlined,
              color: NeuColors.inkSoft),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: MandiController.markets.contains(current)
                    ? current
                    : MandiController.markets.first,
                isExpanded: true,
                borderRadius: BorderRadius.circular(16),
                items: [
                  for (final m in MandiController.markets)
                    DropdownMenuItem(
                        value: m,
                        child: Text(m,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: NeuColors.ink))),
                ],
                onChanged: (v) {
                  if (v == null) return;
                  final s = ref.read(settingsProvider);
                  ref
                      .read(settingsProvider.notifier)
                      .save(s.copyWith(market: v));
                  context.replace(AppRoutes.mandi(market: v));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Message extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  const _Message(
      {required this.icon, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return NeuBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, color: NeuColors.warn),
            const SizedBox(width: 10),
            Expanded(
              child: Text(title,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: NeuColors.ink)),
            ),
          ]),
          const SizedBox(height: 8),
          Text(body,
              style: TextStyle(fontSize: 14, color: NeuColors.inkSoft)),
        ],
      ),
    );
  }
}

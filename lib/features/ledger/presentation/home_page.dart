import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/settings/settings_controller.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/neu.dart';
import '../../../core/widgets/neu_chrome.dart';
import '../../profile/application/profile_controller.dart';
import '../../soundbox/application/soundbox_service.dart';
import '../application/ledger_controller.dart';
import '../application/voice_controller.dart';
import '../domain/sale.dart';
import '../domain/voice_parser.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String? _feedback;
  bool _feedbackIsError = false;

  Future<void> _commit(ParsedSale p) async {
    await ref.read(ledgerProvider.notifier).addSale(
          amountPaise: p.amountPaise,
          mode: p.mode,
          item: p.item,
          customer: p.customer,
        );
    unawaited(HapticFeedback.mediumImpact());
    if (p.mode == SaleMode.upi) {
      await ref.read(soundboxProvider.notifier).announce(p.amountPaise / 100);
    }
    if (!mounted) return;
    final l10n = context.l10n;
    setState(() {
      _feedbackIsError = false;
      _feedback = l10n.saleRecorded(_modeLabel(l10n, p.mode),
          (p.amountPaise / 100).toStringAsFixed(2));
    });
    ref.read(voiceProvider.notifier).reset();
  }

  Future<void> _onVoiceTap() async {
    final voice = ref.read(voiceProvider);
    final ctrl = ref.read(voiceProvider.notifier);
    if (voice.status == VoiceStatus.listening) {
      await ctrl.stop();
      return;
    }
    setState(() => _feedback = null);
    unawaited(HapticFeedback.mediumImpact());
    await ctrl.listen();
  }

  void _tryParse(List<String> candidates) {
    try {
      final parsed = VoiceParser.parseBest(candidates);
      _commit(parsed);
    } on VoiceParseException catch (e) {
      final message = e.message.resolve(context.l10n);
      setState(() {
        _feedbackIsError = true;
        _feedback = message;
      });
      ref.read(voiceProvider.notifier).reset();
    }
  }

  static String _modeLabel(AppLocalizations l10n, SaleMode m) => switch (m) {
        SaleMode.cash => l10n.modeCash,
        SaleMode.upi => l10n.modeUpi,
        SaleMode.credit => l10n.modeCredit,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final ledger = ref.watch(ledgerProvider);
    final settings = ref.watch(settingsProvider);
    final profile = ref.watch(profileProvider);
    final voice = ref.watch(voiceProvider);

    ref.listen<VoiceState>(voiceProvider, (prev, next) {
      if (next.status == VoiceStatus.done && next.transcript.isNotEmpty) {
        _tryParse(next.alternates.isEmpty ? [next.transcript] : next.alternates);
      }
    });

    final listening = voice.status == VoiceStatus.listening;

    return Scaffold(
      backgroundColor: NeuColors.canvas,
      appBar: NeuAppBar(
        title: settings.stallName.isEmpty ? 'VendorOS' : settings.stallName,
        subtitle: DateFormat('EEEE, d MMMM y').format(DateTime.now()),
        actions: [
          NeuIconButton(
            icon: Icons.settings_outlined,
            label: l10n.menuSettings,
            onPressed: () => context.push(AppRoutes.settings()),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 4, 18, 32),
          children: [

            // --- one-time business profile prompt ---
            if (!profile.isConfigured) ...[
              NeuBox(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.profilePromptTitle,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: NeuColors.ink)),
                    const SizedBox(height: 6),
                    Text(l10n.profilePromptBody,
                        style: TextStyle(
                            fontSize: 14, color: NeuColors.inkSoft)),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: NeuButton(
                        minHeight: 48,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        onPressed: () => context.push(AppRoutes.settings()),
                        child: Text(l10n.profilePromptAction,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: NeuColors.accentDark)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // --- today's total ---
            Semantics(
              label: l10n.todayTotalSemantic(
                  (ledger.todayPaise / 100).toStringAsFixed(2)),
              child: NeuBox(
                padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 20),
                child: Column(
                  children: [
                    Text(l10n.todayCollection,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: NeuColors.inkSoft)),
                    const SizedBox(height: 6),
                    AnimatedMoney(
                      ledger.todayPaise / 100,
                      style: TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.w800,
                          color: NeuColors.ink,
                          letterSpacing: -1),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        _Stat(
                            label: l10n.modeCash,
                            paise: ledger.paiseForMode(SaleMode.cash,
                                todayOnly: true)),
                        _Stat(
                            label: 'UPI',
                            color: NeuColors.upi,
                            paise: ledger.paiseForMode(SaleMode.upi,
                                todayOnly: true)),
                        _Stat(
                            label: l10n.modeCredit,
                            color: NeuColors.warn,
                            paise: ledger.paiseForMode(SaleMode.credit,
                                todayOnly: true)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- voice capture ---
            _VoicePad(
              listening: listening,
              level: voice.level,
              transcript: voice.transcript,
              onTap: _onVoiceTap,
            ),

            if (voice.status == VoiceStatus.unavailable && voice.error != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(voice.error!.resolve(l10n),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 13, color: NeuColors.warn)),
              ),

            if (_feedback != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: NeuBox(
                  inset: true,
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Icon(
                          _feedbackIsError
                              ? Icons.error_outline
                              : Icons.check_circle_outline,
                          color: _feedbackIsError
                              ? NeuColors.danger
                              : NeuColors.accentDark),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(_feedback!,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: NeuColors.ink)),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 22),
            _SectionTitle(l10n.menuDailyWork),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(
                child: _ShortcutTile(
                    icon: Icons.dashboard_rounded,
                    label: l10n.dashboardTitle,
                    onTap: () => context.push(AppRoutes.dashboard())),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ShortcutTile(
                    icon: Icons.storefront_rounded,
                    label: l10n.shopTitle,
                    onTap: () => context.push(AppRoutes.shop())),
              ),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: _ShortcutTile(
                    icon: Icons.local_cafe_rounded,
                    label: l10n.quickSaleTitle,
                    onTap: () => context.push(AppRoutes.quickSale())),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ShortcutTile(
                    icon: Icons.receipt_long_rounded,
                    label: l10n.expensesTitle,
                    onTap: () => context.push(AppRoutes.expenses())),
              ),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: _ShortcutTile(
                    icon: Icons.nightlight_round,
                    label: l10n.dayCloseTitle,
                    onTap: () => context.push(AppRoutes.dayClose())),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ShortcutTile(
                    icon: Icons.insights_rounded,
                    label: l10n.insightsTitle,
                    onTap: () => context.push(AppRoutes.insights())),
              ),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: _ShortcutTile(
                    icon: Icons.receipt_rounded,
                    label: l10n.ordersTitle,
                    onTap: () => context.push(AppRoutes.orders())),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ShortcutTile(
                    icon: Icons.qr_code_2_rounded,
                    label: l10n.menuTitle,
                    onTap: () => context.push(AppRoutes.menu())),
              ),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: _ShortcutTile(
                    icon: Icons.soup_kitchen_rounded,
                    label: l10n.kotTitle,
                    onTap: () => context.push(AppRoutes.kot())),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ShortcutTile(
                    icon: Icons.print_rounded,
                    label: l10n.printersTitle,
                    onTap: () => context.push(AppRoutes.printers())),
              ),
            ]),

            const SizedBox(height: 22),
            _SectionTitle(l10n.menuGrowSection),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(
                child: _ShortcutTile(
                    icon: Icons.menu_book_rounded,
                    label: l10n.recipesTitle,
                    onTap: () => context.push(AppRoutes.recipes())),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ShortcutTile(
                    icon: Icons.card_giftcard_rounded,
                    label: l10n.jobsTitle,
                    onTap: () => context.push(AppRoutes.jobs())),
              ),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: _ShortcutTile(
                    icon: Icons.groups_rounded,
                    label: l10n.customersTitle,
                    onTap: () => context.push(AppRoutes.customers())),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ShortcutTile(
                    icon: Icons.storefront_rounded,
                    label: l10n.eventsTitle,
                    onTap: () => context.push(AppRoutes.events())),
              ),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: _ShortcutTile(
                    icon: Icons.badge_rounded,
                    label: l10n.staffTitle,
                    onTap: () => context.push(AppRoutes.staff())),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ShortcutTile(
                    icon: Icons.campaign_rounded,
                    label: l10n.growthTitle,
                    onTap: () => context.push(AppRoutes.growth())),
              ),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: _ShortcutTile(
                    icon: Icons.checklist_rounded,
                    label: l10n.checklistTitle,
                    onTap: () => context.push(AppRoutes.checklist())),
              ),
              const SizedBox(width: 12),
              const Expanded(child: SizedBox()),
            ]),

            const SizedBox(height: 22),
            _SectionTitle(l10n.menuInventory),
            const SizedBox(height: 10),

            // Service vendors keep no stock — only the payment QR applies.
            if (profile.usesInventory) ...[
              Row(children: [
                Expanded(
                  child: _ShortcutTile(
                      icon: Icons.qr_code_scanner_rounded,
                      label: l10n.scanTitle,
                      onTap: () => context.push(AppRoutes.scan())),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ShortcutTile(
                      icon: Icons.inventory_2_rounded,
                      label: l10n.productsTitle,
                      onTap: () => context.push(AppRoutes.products())),
                ),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(
                  child: _ShortcutTile(
                      icon: Icons.stacked_bar_chart_rounded,
                      label: l10n.stockTitle,
                      onTap: () => context.push(AppRoutes.stock())),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ShortcutTile(
                      icon: Icons.qr_code_2_rounded,
                      label: l10n.paymentQrTitle,
                      onTap: () => context.push(AppRoutes.paymentQr())),
                ),
              ]),
            ] else
              Row(children: [
                Expanded(
                  child: _ShortcutTile(
                      icon: Icons.qr_code_2_rounded,
                      label: l10n.paymentQrTitle,
                      onTap: () => context.push(AppRoutes.paymentQr())),
                ),
              ]),

            const SizedBox(height: 22),
            _SectionTitle(l10n.quickEntry),
            const SizedBox(height: 10),
            _QuickEntry(onAdd: (paise, mode) => _commit(ParsedSale(
                  amountPaise: paise,
                  mode: mode,
                  item: 'Quick entry',
                  customer: mode == SaleMode.credit ? 'Walk-in' : null,
                ))),

            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SectionTitle(l10n.todayEntries),
                Text('${ledger.todaySales.length}',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: NeuColors.inkSoft)),
              ],
            ),
            const SizedBox(height: 10),
            if (ledger.todaySales.isEmpty)
              NeuBox(
                inset: true,
                padding: const EdgeInsets.symmetric(vertical: 28),
                child: Center(
                  child: Text(l10n.noEntriesYet,
                      style: TextStyle(
                          color: NeuColors.inkSoft, fontSize: 15)),
                ),
              )
            else
              ...ledger.todaySales.map((s) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _SaleTile(
                      sale: s,
                      onDelete: () => ref
                          .read(ledgerProvider.notifier)
                          .deleteSale(s.id),
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: TextStyle(
          fontSize: 17, fontWeight: FontWeight.w800, color: NeuColors.ink));
}

class _Stat extends StatelessWidget {
  final String label;
  final int paise;
  final Color? color;
  const _Stat(
      {required this.label, required this.paise, this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(label,
              style: TextStyle(fontSize: 13, color: NeuColors.inkSoft)),
          const SizedBox(height: 2),
          AnimatedMoney(paise / 100,
              style: TextStyle(
                  fontSize: 17, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }
}

class _VoicePad extends StatelessWidget {
  final bool listening;
  final double level;
  final String transcript;
  final VoidCallback onTap;
  const _VoicePad({
    required this.listening,
    required this.level,
    required this.transcript,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Semantics(
      button: true,
      label: listening ? l10n.listeningTapToStop : l10n.tapToSpeak,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutQuad,
          padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 20),
          decoration: BoxDecoration(
            color: listening ? NeuColors.inset : NeuColors.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow:
                listening ? NeuTheme.recessed(blur: 14) : NeuTheme.raised(blur: 14),
          ),
          child: Column(
            children: [
              AnimatedScale(
                scale: listening ? 1 + level * 0.12 : 1,
                duration: const Duration(milliseconds: 180),
                child: Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: listening ? NeuColors.inset : NeuColors.surface,
                    boxShadow: listening
                        ? [
                            BoxShadow(
                                color: NeuColors.accent
                                    .withValues(alpha: 0.25 + level * 0.35),
                                blurRadius: 18 + level * 18,
                                spreadRadius: 2),
                          ]
                        : NeuTheme.raised(),
                  ),
                  child: Icon(listening ? Icons.stop_rounded : Icons.mic_rounded,
                      size: 40,
                      color: listening
                          ? NeuColors.accentDark
                          : NeuColors.ink),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                listening ? l10n.listening : l10n.speakToRecord,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: NeuColors.ink),
              ),
              const SizedBox(height: 4),
              Text(
                transcript.isEmpty
                    ? l10n.voiceHint
                    : transcript,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    color: transcript.isEmpty
                        ? NeuColors.inkSoft
                        : NeuColors.accentDark,
                    fontWeight:
                        transcript.isEmpty ? FontWeight.w400 : FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickEntry extends StatefulWidget {
  final void Function(int paise, SaleMode mode) onAdd;
  const _QuickEntry({required this.onAdd});
  @override
  State<_QuickEntry> createState() => _QuickEntryState();
}

class _QuickEntryState extends State<_QuickEntry> {
  final _controller = TextEditingController();
  SaleMode _mode = SaleMode.cash;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final v = double.tryParse(_controller.text.trim());
    if (v == null || v <= 0) return;
    widget.onAdd((v * 100).round(), _mode);
    _controller.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return NeuBox(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: NeuField(
                  controller: _controller,
                  keyboard:
                      const TextInputType.numberWithOptions(decimal: true),
                  hint: '0',
                  prefixText: '₹ ',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: NeuColors.ink),
                  prefixStyle: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: NeuColors.inkSoft),
                  onSubmitted: (_) => _submit(),
                ),
              ),

              const SizedBox(width: 12),
              SizedBox(
                width: 72,
                child: Semantics(
                  button: true,
                  label: l10n.addSale,
                  child: NeuButton(
                    onPressed: _submit,
                    padding: const EdgeInsets.all(12),
                    child: Icon(Icons.add_rounded,
                        size: 30, color: NeuColors.accentDark),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (final m in SaleMode.values) ...[
                Expanded(
                  child: NeuButton(
                    minHeight: 56,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    color: _mode == m ? NeuColors.inset : null,
                    onPressed: () => setState(() => _mode = m),
                    child: Text(
                      switch (m) {
                        SaleMode.cash => l10n.modeCash,
                        SaleMode.upi => 'UPI',
                        SaleMode.credit => l10n.modeCredit,
                      },
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            _mode == m ? FontWeight.w800 : FontWeight.w500,
                        color: _mode == m
                            ? NeuColors.accentDark
                            : NeuColors.inkSoft,
                      ),
                    ),
                  ),
                ),
                if (m != SaleMode.values.last) const SizedBox(width: 10),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _SaleTile extends StatelessWidget {
  final Sale sale;
  final VoidCallback onDelete;
  const _SaleTile({required this.sale, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (label, color) = switch (sale.mode) {
      SaleMode.cash => (l10n.modeCash, NeuColors.ink),
      SaleMode.upi => (l10n.modeUpi, NeuColors.upi),
      SaleMode.credit => (l10n.modeCredit, NeuColors.warn),
    };
    return Semantics(
      label: l10n.saleSemantic(
          label, (sale.amountPaise / 100).toStringAsFixed(2), sale.item),
      child: NeuBox(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: NeuColors.inset,
                borderRadius: BorderRadius.circular(14),
                boxShadow: NeuTheme.recessed(blur: 6, dist: 2),
              ),
              child: Icon(
                switch (sale.mode) {
                  SaleMode.cash => Icons.payments_outlined,
                  SaleMode.upi => Icons.qr_code_rounded,
                  SaleMode.credit => Icons.schedule_rounded,
                },
                color: color,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sale.customer != null && sale.customer!.isNotEmpty
                        ? '${sale.item} · ${sale.customer}'
                        : sale.item,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: NeuColors.ink),
                  ),
                  Text(
                    '$label · ${DateFormat('h:mm a').format(DateTime.fromMillisecondsSinceEpoch(sale.ts))}',
                    style: TextStyle(
                        fontSize: 13, color: NeuColors.inkSoft),
                  ),
                ],
              ),
            ),
            Text('₹${(sale.amountPaise / 100).toStringAsFixed(2)}',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w800, color: color)),
            const SizedBox(width: 4),
            NeuIconButton(
              icon: Icons.close_rounded,
              label: l10n.delete,
              size: 44,
              iconSize: 20,
              iconColor: NeuColors.inkSoft,
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

/// Square neumorphic shortcut into the inventory module.
class _ShortcutTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ShortcutTile(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => NeuBox(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
        child: Column(
          children: [
            Icon(icon, size: 26, color: NeuColors.accentDark),
            const SizedBox(height: 8),
            Text(label,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: NeuColors.ink)),
          ],
        ),
      );
}

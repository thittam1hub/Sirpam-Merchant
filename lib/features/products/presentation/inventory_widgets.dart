import 'package:flutter/material.dart';

import '../../../core/l10n/l10n_extension.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/neu.dart';
import '../../../core/widgets/neu_chrome.dart';
import '../domain/inventory_models.dart';
import '../domain/stock_math.dart';

String unitLabel(BuildContext context, StockUnit unit) => switch (unit) {
      StockUnit.kg => context.l10n.unitKg,
      StockUnit.gram => context.l10n.unitGram,
      StockUnit.piece => context.l10n.unitPiece,
      StockUnit.litre => context.l10n.unitLitre,
      StockUnit.bundle => context.l10n.unitBundle,
    };

String money(int paise) => '₹${(paise / 100).toStringAsFixed(2)}';

String qtyWithUnit(BuildContext context, int milli, StockUnit unit) =>
    '${StockMath.formatQty(milli)} ${unitLabel(context, unit)}';

String movementLabel(BuildContext context, MovementKind kind) =>
    switch (kind) {
      MovementKind.purchase => context.l10n.movementPurchase,
      MovementKind.sale => context.l10n.movementSale,
      MovementKind.wastage => context.l10n.movementWastage,
      MovementKind.returnIn => context.l10n.movementReturn,
      MovementKind.correction => context.l10n.movementCorrection,
      MovementKind.prepared => context.l10n.movementPrepared,
    };

/// A labelled recessed input used by every inventory form.
class LabeledField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboard;
  final String? prefixText;
  final String? hint;
  final bool autofocus;
  final ValueChanged<String>? onChanged;

  /// Hides typed characters — used for PIN entry.
  final bool obscure;

  const LabeledField({
    super.key,
    required this.label,
    required this.controller,
    this.keyboard = TextInputType.text,
    this.prefixText,
    this.hint,
    this.autofocus = false,
    this.onChanged,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: NeuColors.inkSoft)),
          const SizedBox(height: 6),
          NeuField(
            controller: controller,
            keyboard: keyboard,
            prefixText: prefixText,
            hint: hint,
            autofocus: autofocus,
            onChanged: onChanged,
            obscure: obscure,
          ),

          const SizedBox(height: 14),
        ],
      );
}

/// Section header used across the inventory screens.
class SectionTitle extends StatelessWidget {
  final String text;
  final Widget? trailing;
  const SectionTitle(this.text, {super.key, this.trailing});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 18, 4, 10),
        child: Row(
          children: [
            Expanded(
              child: Text(text,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: NeuColors.ink)),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      );
}

/// Small inset pill used for stock / expiry status.
class StatusPill extends StatelessWidget {
  final String text;
  final Color? color;
  const StatusPill(this.text, {super.key, this.color});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: NeuColors.inset,
          borderRadius: BorderRadius.circular(10),
          boxShadow: NeuTheme.recessed(blur: 5, dist: 2),
        ),
        child: Text(text,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color ?? NeuColors.inkSoft)),
      );
}

/// Full-width neumorphic action row used in dialogs and detail sheets.
class ActionRow extends StatelessWidget {
  final List<Widget> children;
  const ActionRow({super.key, required this.children});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(width: 10),
            Expanded(child: children[i]),
          ],
        ],
      );
}

/// A neumorphic button with plain label text — the common case.
class NeuTextButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? color;
  const NeuTextButton(
      {super.key,
      required this.label,
      required this.onPressed,
      this.color});

  @override
  Widget build(BuildContext context) => NeuButton(
        onPressed: onPressed,
        child: Text(label,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w700, color: color)),
      );
}

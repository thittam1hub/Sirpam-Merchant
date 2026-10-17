import 'package:flutter/material.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/neu.dart';
import '../../../core/widgets/neu_chrome.dart';

/// Grouped soft card holding a section label plus its tiles.
class SettingsGroup extends StatelessWidget {
  final String label;
  final List<Widget> children;
  const SettingsGroup({super.key, required this.label, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(6, 2, 6, 10),
          child: Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              letterSpacing: 1.1,
              fontWeight: FontWeight.w800,
              color: NeuColors.inkSoft,
            ),
          ),
        ),
        for (var i = 0; i < children.length; i++)
          Padding(
            padding: EdgeInsets.only(bottom: i == children.length - 1 ? 0 : 12),
            child: children[i],
          ),
      ],
    );
  }
}

/// Label + recessed input well used by every settings sub-page.
class SettingsField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboard;
  final String? helper;
  final bool autofocus;
  final ValueChanged<String>? onChanged;
  const SettingsField({
    super.key,
    required this.label,
    required this.controller,
    this.keyboard = TextInputType.text,
    this.helper,
    this.autofocus = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: NeuColors.inkSoft)),
        const SizedBox(height: 8),
        NeuField(
          controller: controller,
          keyboard: keyboard,
          autofocus: autofocus,
          onChanged: onChanged,
          height: 54,
        ),
        if (helper != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(helper!,
                style:
                    TextStyle(fontSize: 12.5, color: NeuColors.inkSoft)),
          ),
      ],
    );
  }
}

/// One soft card per settings sub-page, with generous spacing between rows.
class SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const SettingsCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: NeuColors.surface,
        borderRadius: BorderRadius.circular(NeuTheme.radiusCard),
        boxShadow: NeuTheme.soft(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(height: 18),
            children[i],
          ],
        ],
      ),
    );
  }
}

/// Scroll body shared by the settings sub-pages: capped width, one CTA.
class SettingsFormBody extends StatelessWidget {
  final List<Widget> children;
  final String saveLabel;
  final VoidCallback onSave;
  const SettingsFormBody({
    super.key,
    required this.children,
    required this.saveLabel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(context.pageGutter, 4, context.pageGutter, 36),
      children: [
        ResponsiveContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...children,
              const SizedBox(height: 22),
              NeuButton(
                onPressed: onSave,
                radius: NeuTheme.radiusWell,
                child: Text(saveLabel,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: NeuColors.accentDark)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Pill-shaped segmented selector (physical, pressable soft-UI objects).
class SettingsSegmented<T> extends StatelessWidget {
  final List<(T, String)> options;
  final T? value;
  final ValueChanged<T> onChanged;
  const SettingsSegmented({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final option in options)
          Semantics(
            selected: value == option.$1,
            button: true,
            child: NeuButton(
              selected: value == option.$1,
              minHeight: 48,
              radius: 24,
              padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              onPressed: () => onChanged(option.$1),
              child: Text(option.$2,
                  style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: value == option.$1
                          ? NeuColors.accentDark
                          : NeuColors.inkSoft)),
            ),
          ),
      ],
    );
  }
}

/// Recessed dropdown well so pickers match the soft-UI language.
class SettingsPicker extends StatelessWidget {
  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;
  const SettingsPicker({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final safe = options.contains(value) ? value : options.first;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: NeuColors.inkSoft)),
        const SizedBox(height: 8),
        Container(
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: NeuColors.inset,
            borderRadius: BorderRadius.circular(16),
            boxShadow: NeuTheme.recessed(blur: 8, dist: 3),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: safe,
              isExpanded: true,
              borderRadius: BorderRadius.circular(16),
              items: [
                for (final o in options)
                  DropdownMenuItem(value: o, child: Text(o)),
              ],
              onChanged: (v) => onChanged(v ?? safe),
            ),
          ),
        ),
      ],
    );
  }
}

/// Row with a title and a soft switch.
class SettingsToggleRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  const SettingsToggleRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: NeuColors.ink)),
        ),
        NeuSwitch(label: label, value: value, onChanged: onChanged),
      ],
    );
  }
}

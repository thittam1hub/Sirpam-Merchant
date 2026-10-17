import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/neu_theme.dart';
import 'neu_chrome.dart';

class NeuSideNavSection {
  final String label;
  final List<NeuSideNavEntry> entries;
  const NeuSideNavSection({required this.label, required this.entries});
}

class NeuSideNavEntry {
  final NeuNavItem item;
  final bool selected;
  final VoidCallback onTap;
  const NeuSideNavEntry({
    required this.item,
    required this.selected,
    required this.onTap,
  });
}

/// Neumorphic side navigation used on tablet (icon rail) and desktop
/// (extended rail with labels). Mirrors [NeuBottomNav] semantics.
class NeuSideNav extends StatelessWidget {
  final List<NeuSideNavSection> sections;

  /// Extended shows labels beside icons (desktop).
  final bool extended;

  /// Optional actions rendered under the primary destinations.
  final List<Widget> footer;

  /// Optional header (brand / FAB style action).
  final Widget? header;

  final VoidCallback? onToggle;

  const NeuSideNav({
    super.key,
    required this.sections,
    this.extended = false,
    this.footer = const [],
    this.header,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final width = extended ? 232.0 : 96.0;
    return Container(
      width: width,
      color: NeuColors.canvas,
      padding: const EdgeInsets.fromLTRB(12, 12, 6, 12),
      child: SafeArea(
        right: false,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            color: NeuColors.surface,
            borderRadius: BorderRadius.circular(26),
            boxShadow: NeuTheme.raised(blur: 16, dist: 6),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (header != null) ...[header!, const SizedBox(height: 14)],
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final section in sections) ...[
                        if (extended)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
                            child: Text(
                              section.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: NeuColors.inkSoft,
                              ),
                            ),
                          ),
                        for (final entry in section.entries)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: _RailCell(
                              item: entry.item,
                              selected: entry.selected,
                              extended: extended,
                              onTap: entry.onTap,
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
              ),
              if (onToggle != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: _RailCell(
                    item: NeuNavItem(
                      icon: extended
                          ? Icons.chevron_left_rounded
                          : Icons.chevron_right_rounded,
                      selectedIcon: extended
                          ? Icons.chevron_left_rounded
                          : Icons.chevron_right_rounded,
                      label: extended
                          ? MaterialLocalizations.of(context).closeButtonTooltip
                          : MaterialLocalizations.of(
                              context,
                            ).openAppDrawerTooltip,
                    ),
                    selected: false,
                    extended: extended,
                    onTap: onToggle!,
                  ),
                ),
              if (footer.isNotEmpty) ...[
                const SizedBox(height: 8),
                for (final w in footer)
                  Padding(padding: const EdgeInsets.only(top: 10), child: w),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _RailCell extends StatefulWidget {
  final NeuNavItem item;
  final bool selected;
  final bool extended;
  final VoidCallback onTap;

  const _RailCell({
    required this.item,
    required this.selected,
    required this.extended,
    required this.onTap,
  });

  @override
  State<_RailCell> createState() => _RailCellState();
}

class _RailCellState extends State<_RailCell> {
  bool _down = false;

  void _set(bool v) {
    setState(() => _down = v);
    if (v) HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    final active = widget.selected || _down;
    final color = widget.selected ? NeuColors.accentDark : NeuColors.inkSoft;
    return Semantics(
      button: true,
      selected: widget.selected,
      label: widget.item.label,
      child: GestureDetector(
        onTapDown: (_) => _set(true),
        onTapUp: (_) => _set(false),
        onTapCancel: () => _set(false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: EdgeInsets.symmetric(
            horizontal: widget.extended ? 14 : 8,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: active ? NeuColors.inset : NeuColors.surface,
            borderRadius: BorderRadius.circular(18),
            boxShadow: active
                ? NeuTheme.recessed(blur: 8, dist: 3)
                : NeuTheme.raised(blur: 8, dist: 3),
          ),
          child: widget.extended
              ? Row(
                  children: [
                    Icon(
                      widget.selected
                          ? widget.item.selectedIcon
                          : widget.item.icon,
                      size: 26,
                      color: color,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: widget.selected
                              ? FontWeight.w800
                              : FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      widget.selected
                          ? widget.item.selectedIcon
                          : widget.item.icon,
                      size: 26,
                      color: color,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.item.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: widget.selected
                            ? FontWeight.w800
                            : FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

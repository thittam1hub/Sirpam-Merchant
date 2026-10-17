import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/l10n_extension.dart';
import '../theme/neu_theme.dart';

/// Circular / squircle neumorphic icon button used across app chrome.
/// Extruded at rest, recessed while pressed, 56dp minimum tap target.
class NeuIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String label;
  final double size;
  final double iconSize;
  final Color? iconColor;
  final bool active;

  const NeuIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.label,
    this.size = 52,
    this.iconSize = 24,
    this.iconColor,
    this.active = false,
  });

  @override
  State<NeuIconButton> createState() => _NeuIconButtonState();
}

class _NeuIconButtonState extends State<NeuIconButton> {
  bool _down = false;

  void _set(bool v) {
    if (widget.onPressed == null) return;
    setState(() => _down = v);
    if (v) HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    final pressed = _down || widget.active;
    return Semantics(
      button: true,
      label: widget.label,
      child: Tooltip(
        message: widget.label,
        child: GestureDetector(
          onTapDown: (_) => _set(true),
          onTapCancel: () => _set(false),
          onTapUp: (_) => _set(false),
          onTap: widget.onPressed,
          child: Padding(
            // keeps the visual disc small while the touch target stays 56dp
            padding: const EdgeInsets.all(2),
            child: AnimatedScale(
              scale: _down ? 0.98 : 1.0,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOutQuad,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOutQuad,
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  color: pressed ? NeuColors.inset : NeuColors.surface,
                  shape: BoxShape.circle,
                  boxShadow: pressed
                      ? NeuTheme.recessed(blur: 8, dist: 3)
                      : NeuTheme.raised(blur: 10, dist: 4),
                ),
                child: Icon(
                  widget.icon,
                  size: widget.iconSize,
                  color: widget.iconColor ??
                      (widget.active ? NeuColors.accentDark : NeuColors.ink),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Neumorphic top bar: canvas background, extruded title plate, extruded
/// leading/action discs. Replaces Material [AppBar] everywhere in the app.
class NeuAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget> actions;

  const NeuAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions = const [],
  });

  static const double _height = 84;

  @override
  Size get preferredSize => const Size.fromHeight(_height);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SizedBox(
        height: _height,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
          child: Row(
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Container(
                  height: 60,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    color: NeuColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: NeuTheme.raised(blur: 12, dist: 5),
                  ),
                  // The bar is a fixed 84 dp tall, so its two lines of text
                  // are capped at 1.3x. Page content keeps the full system
                  // text scale; only this chrome is clamped.
                  child: MediaQuery.withClampedTextScaling(
                    maxScaleFactor: 1.3,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: NeuColors.ink,
                          ),
                        ),
                        if (subtitle != null && subtitle!.isNotEmpty)
                          Text(
                            subtitle!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: NeuColors.inkSoft,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              for (final a in actions) ...[
                const SizedBox(width: 10),
                a,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class NeuNavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  const NeuNavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

/// Neumorphic bottom navigation: one extruded bar floating on the canvas with
/// an inset (recessed) well marking the active destination.
class NeuBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onSelected;
  final List<NeuNavItem> items;

  const NeuBottomNav({
    super.key,
    required this.currentIndex,
    required this.onSelected,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: NeuColors.canvas,
      padding: const EdgeInsets.fromLTRB(14, 6, 14, 10),
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: NeuColors.surface,
            borderRadius: BorderRadius.circular(26),
            boxShadow: NeuTheme.raised(blur: 14, dist: 5),
          ),
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: _NavCell(
                    item: items[i],
                    selected: i == currentIndex,
                    onTap: () => onSelected(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavCell extends StatefulWidget {
  final NeuNavItem item;
  final bool selected;
  final VoidCallback onTap;
  const _NavCell({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  State<_NavCell> createState() => _NavCellState();
}

class _NavCellState extends State<_NavCell> {
  bool _down = false;

  void _set(bool v) {
    setState(() => _down = v);
    if (v) HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    final sunk = widget.selected || _down;
    final color = widget.selected ? NeuColors.accentDark : NeuColors.inkSoft;
    return Semantics(
      button: true,
      selected: widget.selected,
      label: widget.item.label,
      child: Tooltip(
        message: widget.item.label,
        child: GestureDetector(
          onTapDown: (_) => _set(true),
          onTapCancel: () => _set(false),
          onTapUp: (_) => _set(false),
          onTap: widget.onTap,
          child: AnimatedScale(
            scale: _down ? 0.98 : 1.0,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOutQuad,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOutQuad,
              constraints: const BoxConstraints(minHeight: 56),
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
              decoration: BoxDecoration(
                color: sunk ? NeuColors.inset : NeuColors.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow:
                    sunk ? NeuTheme.recessed(blur: 8, dist: 3) : const [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    widget.selected
                        ? widget.item.selectedIcon
                        : widget.item.icon,
                    size: 26,
                    color: color,
                  ),
                  const SizedBox(height: 2),
                  // Tab labels sit in a 56 dp cell, so they cap at 1.3x; the
                  // icon and the tooltip keep the tab readable beyond that.
                  MediaQuery.withClampedTextScaling(
                    maxScaleFactor: 1.3,
                    child: Text(
                      widget.item.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.1,
                        fontWeight:
                            widget.selected ? FontWeight.w700 : FontWeight.w500,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Extruded neumorphic floating action button (no Material elevation).
class NeuFab extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  const NeuFab({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  State<NeuFab> createState() => _NeuFabState();
}

class _NeuFabState extends State<NeuFab> {
  bool _down = false;

  void _set(bool v) {
    setState(() => _down = v);
    if (v) HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.label,
      child: Tooltip(
        message: widget.label,
        child: GestureDetector(
          onTapDown: (_) => _set(true),
          onTapCancel: () => _set(false),
          onTapUp: (_) => _set(false),
          onTap: widget.onPressed,
          child: AnimatedScale(
            scale: _down ? 0.98 : 1.0,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOutQuad,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOutQuad,
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: _down ? NeuColors.inset : NeuColors.surface,
                shape: BoxShape.circle,
                boxShadow: _down
                    ? NeuTheme.recessed(blur: 10, dist: 4)
                    : NeuTheme.raised(blur: 14, dist: 5),
              ),
              child: Icon(widget.icon, size: 30, color: NeuColors.ink),
            ),
          ),
        ),
      ),
    );
  }
}

/// Neumorphic toggle: recessed track with an extruded thumb.
class NeuSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;
  const NeuSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      toggled: value,
      label: label,
      child: Tooltip(
        message: label,
        child: GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            onChanged(!value);
          },
          child: Container(
            width: 76,
            height: 44,
            alignment: Alignment.center,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOutQuad,
              width: 72,
              height: 38,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: NeuColors.inset,
                borderRadius: BorderRadius.circular(19),
                boxShadow: NeuTheme.recessed(blur: 6, dist: 2),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOutQuad,
                alignment:
                    value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: NeuColors.surface,
                    shape: BoxShape.circle,
                    boxShadow: NeuTheme.raised(blur: 6, dist: 2),
                  ),
                  child: Icon(
                    value ? Icons.check_rounded : Icons.close_rounded,
                    size: 18,
                    color: value ? NeuColors.accentDark : NeuColors.inkSoft,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Neumorphic busy state: a recessed well holding an accent progress ring.
class NeuLoader extends StatelessWidget {
  /// Defaults to the localized "loading" label when omitted.
  final String? label;
  const NeuLoader({super.key, this.label});

  @override
  Widget build(BuildContext context) {
    final label = this.label ?? context.l10n.loading;
    return Center(
      child: Semantics(
        label: label,
        child: Container(
          padding: const EdgeInsets.all(26),
          decoration: BoxDecoration(
            color: NeuColors.inset,
            borderRadius: BorderRadius.circular(28),
            boxShadow: NeuTheme.recessed(),
          ),
          child: SizedBox(
            width: 34,
            height: 34,
            child: CircularProgressIndicator(
              strokeWidth: 3.5,
              color: NeuColors.accentDark,
            ),
          ),
        ),
      ),
    );
  }
}

/// Recessed text-field well used for every input in the app.
class NeuField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboard;
  final String? hint;
  final String? prefixText;
  final bool autofocus;
  final double height;
  final TextStyle? style;
  final Widget? leading;
  final TextInputAction? action;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final TextStyle? prefixStyle;

  /// Hides typed characters — used for PIN entry on the shared shop phone.
  final bool obscure;


  const NeuField({
    super.key,
    required this.controller,
    this.keyboard = TextInputType.text,
    this.hint,
    this.prefixText,
    this.autofocus = false,
    this.height = 56,
    this.style,
    this.leading,
    this.action,
    this.onSubmitted,
    this.onChanged,
    this.prefixStyle,
    this.obscure = false,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: NeuColors.inset,
        borderRadius: BorderRadius.circular(16),
        boxShadow: NeuTheme.recessed(blur: 8, dist: 3),
      ),
      child: Row(
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 10)],
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboard,
              obscureText: obscure,
              autofocus: autofocus,
              textInputAction: action,
              onSubmitted: onSubmitted,
              onChanged: onChanged,
              style: style ??
                  TextStyle(fontSize: 16, color: NeuColors.ink),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                prefixText: prefixText,
                hintStyle: TextStyle(color: NeuColors.inkSoft),
                prefixStyle: prefixStyle ??
                    TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: NeuColors.inkSoft),

              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Soft-UI settings row: icon well, title, current value, chevron.
class NeuTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final String? value;
  final VoidCallback onTap;
  final Color? iconColor;
  const NeuTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.value,
    this.iconColor,
  });

  @override
  State<NeuTile> createState() => _NeuTileState();
}

class _NeuTileState extends State<NeuTile> {
  bool _down = false;

  void _set(bool v) {
    setState(() => _down = v);
    if (v) HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.title,
      value: widget.value,
      child: GestureDetector(
        onTapDown: (_) => _set(true),
        onTapCancel: () => _set(false),
        onTapUp: (_) => _set(false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutQuad,
          constraints: const BoxConstraints(minHeight: 76),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: _down ? NeuColors.inset : NeuColors.surface,
            borderRadius: BorderRadius.circular(NeuTheme.radiusTile),
            boxShadow: _down ? NeuTheme.recessed() : NeuTheme.soft(),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: NeuColors.inset,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: NeuTheme.recessed(blur: 8, dist: 3),
                ),
                child: Icon(widget.icon,
                    size: 22, color: widget.iconColor ?? NeuColors.inkSoft),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(widget.title,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: NeuColors.ink)),
                    if ((widget.value ?? '').isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(widget.value!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 13.5, color: NeuColors.inkSoft)),
                    ],
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  color: NeuColors.inkSoft),
            ],
          ),
        ),
      ),
    );
  }
}

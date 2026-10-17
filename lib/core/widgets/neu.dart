import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/neu_theme.dart';

/// Extruded neumorphic container.
class NeuBox extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final bool inset;
  final VoidCallback? onTap;
  const NeuBox({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = 20,
    this.inset = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final box = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: padding,
      decoration: BoxDecoration(
        color: inset ? NeuColors.inset : NeuColors.surface,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: inset ? NeuTheme.recessed() : NeuTheme.raised(),
      ),
      child: child,
    );
    if (onTap == null) return box;
    return GestureDetector(onTap: onTap, child: box);
  }
}

/// Tactile neumorphic button: compresses to 0.98x and swaps raised→inset
/// shadows over 150ms (Curves.easeOutQuad) with selection haptic.
class NeuButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;

  /// Secondary gesture for destructive or advanced actions (remove, edit).
  final VoidCallback? onLongPress;
  final double radius;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final double minHeight;

  /// Selected controls stay recessed (toggle/segmented semantics).
  final bool selected;
  const NeuButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.onLongPress,
    this.radius = 18,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    this.color,
    this.minHeight = 56, // oversized tactile tap target
    this.selected = false,
  });


  @override
  State<NeuButton> createState() => _NeuButtonState();
}

class _NeuButtonState extends State<NeuButton> {
  bool _down = false;

  void _set(bool v) {
    if (widget.onPressed == null) return;
    setState(() => _down = v);
    if (v) HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _set(true),
      onTapCancel: () => _set(false),
      onTapUp: (_) => _set(false),
      onTap: widget.onPressed,
      onLongPress: widget.onLongPress == null
          ? null
          : () {
              HapticFeedback.mediumImpact();
              widget.onLongPress!();
            },

      child: AnimatedScale(
        scale: _down ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutQuad,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutQuad,
          constraints: BoxConstraints(minHeight: widget.minHeight),
          padding: widget.padding,
          decoration: BoxDecoration(
            color: widget.color ??
                ((_down || widget.selected)
                    ? NeuColors.inset
                    : NeuColors.surface),
            borderRadius: BorderRadius.circular(widget.radius),
            boxShadow: (_down || widget.selected)
                ? NeuTheme.recessed()
                : NeuTheme.raised(),
          ),
          child: Center(child: widget.child),
        ),
      ),
    );
  }
}

/// Animated ₹ counter — TweenAnimationBuilder driving digit transitions.
class AnimatedMoney extends StatelessWidget {
  final double rupees;
  final TextStyle? style;
  final String prefix;
  const AnimatedMoney(this.rupees,
      {super.key, this.style, this.prefix = '₹'});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: rupees),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      builder: (context, v, _) => Text(
        '$prefix${_format(v)}',
        style: style,
      ),
    );
  }

  static String _format(double v) {
    final neg = v < 0;
    v = v.abs();
    final whole = v.truncate();
    final frac = ((v - whole) * 100).round();
    // Indian digit grouping
    final s = whole.toString();
    String grouped;
    if (s.length <= 3) {
      grouped = s;
    } else {
      final last3 = s.substring(s.length - 3);
      var rest = s.substring(0, s.length - 3);
      final parts = <String>[];
      while (rest.length > 2) {
        parts.insert(0, rest.substring(rest.length - 2));
        rest = rest.substring(0, rest.length - 2);
      }
      if (rest.isNotEmpty) parts.insert(0, rest);
      grouped = '${parts.join(',')},$last3';
    }
    return '${neg ? '-' : ''}$grouped.${frac.toString().padLeft(2, '0')}';
  }
}

/// Breathing glow dot for active listening / connectivity states.
class BreathingDot extends StatefulWidget {
  final Color? color;
  final double size;
  const BreathingDot({super.key, this.color, this.size = 12});

  @override
  State<BreathingDot> createState() => _BreathingDotState();
}

class _BreathingDotState extends State<BreathingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1400))
    ..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) {
        final c = widget.color ?? NeuColors.accent;
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: c,
            boxShadow: [
              BoxShadow(
                color: c.withValues(alpha: 0.35 + 0.45 * _c.value),
                blurRadius: 6 + 10 * _c.value,
                spreadRadius: 1 + 3 * _c.value,
              ),
            ],
          ),
        );
      },
    );
  }
}


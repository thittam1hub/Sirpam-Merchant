import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:vendoros/core/theme/neu_theme.dart';

/// WCAG relative luminance / contrast ratio.
double _lum(Color c) {
  double ch(double v) =>
      v <= 0.03928 ? v / 12.92 : math.pow((v + 0.055) / 1.055, 2.4).toDouble();
  return 0.2126 * ch(c.r) + 0.7152 * ch(c.g) + 0.0722 * ch(c.b);
}

double contrast(Color a, Color b) {
  final l1 = _lum(a), l2 = _lum(b);
  final hi = math.max(l1, l2), lo = math.min(l1, l2);
  return (hi + 0.05) / (lo + 0.05);
}

void main() {
  for (final entry in {
    'light': NeuPalette.light,
    'dark': NeuPalette.dark,
  }.entries) {
    final p = entry.value;
    final surfaces = {'canvas': p.canvas, 'surface': p.surface, 'inset': p.inset};

    test('${entry.key}: body text is AAA on every surface', () {
      for (final s in surfaces.entries) {
        expect(contrast(p.ink, s.value), greaterThanOrEqualTo(7.0),
            reason: 'ink on ${s.key}');
        expect(contrast(p.inkSoft, s.value), greaterThanOrEqualTo(7.0),
            reason: 'inkSoft on ${s.key}');
      }
    });

    test('${entry.key}: accent, link, warning and danger text meet AA', () {
      final accents = {
        'accentDark': p.accentDark,
        'upi': p.upi,
        'warn': p.warn,
        'danger': p.danger,
      };
      for (final s in surfaces.entries) {
        for (final a in accents.entries) {
          expect(contrast(a.value, s.value), greaterThanOrEqualTo(4.5),
              reason: '${a.key} on ${s.key}');
        }
      }
    });
  }
}

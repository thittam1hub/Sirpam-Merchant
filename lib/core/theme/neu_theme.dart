import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// VendorOS neumorphic design tokens.
///
/// Soft UI needs the light source, the surface and the shadow to move together,
/// so both themes are described as one palette and swapped as a whole. Light:
/// canvas #E3E7EE, extruded #EDF1F7, inset #DDE2EC. Dark: a charcoal canvas
/// with a dim top-left highlight and a near-black bottom-right shadow, which is
/// what keeps the buttons looking pressed instead of flat.
class NeuPalette {
  final Color canvas;
  final Color surface;
  final Color inset;
  final Color highlight;
  final Color shadow;
  final Color ink;
  final Color inkSoft;
  final Color accent;
  final Color accentDark;
  final Color upi;
  final Color warn;
  final Color danger;

  /// Alpha multipliers: the dark theme needs a much softer white highlight.
  final double highlightAlpha;
  final double shadowAlpha;
  final Brightness brightness;

  const NeuPalette({
    required this.canvas,
    required this.surface,
    required this.inset,
    required this.highlight,
    required this.shadow,
    required this.ink,
    required this.inkSoft,
    required this.accent,
    required this.accentDark,
    required this.upi,
    required this.warn,
    required this.danger,
    required this.highlightAlpha,
    required this.shadowAlpha,
    required this.brightness,
  });

  static const light = NeuPalette(
    canvas: Color(0xFFE3E7EE),
    surface: Color(0xFFEDF1F7),
    inset: Color(0xFFDDE2EC),
    highlight: Color(0xFFFFFFFF),
    shadow: Color(0xFFBAC5D5),
    ink: Color(0xFF1A2233),
    inkSoft: Color(0xFF354056),
    accent: Color(0xFF0E9F6E),
    accentDark: Color(0xFF076044),
    upi: Color(0xFF1A3FA8),
    warn: Color(0xFF8A4008),
    danger: Color(0xFF96150F),
    highlightAlpha: 1,
    shadowAlpha: 1,
    brightness: Brightness.light,
  );

  static const dark = NeuPalette(
    canvas: Color(0xFF272B32),
    surface: Color(0xFF2F343C),
    inset: Color(0xFF23272E),
    highlight: Color(0xFF454C57),
    shadow: Color(0xFF15181D),
    ink: Color(0xFFEDF1F7),
    inkSoft: Color(0xFFC3CCDA),
    accent: Color(0xFF34D399),
    accentDark: Color(0xFF5EEAD4),
    upi: Color(0xFFA8C4FF),
    warn: Color(0xFFFBBF24),
    danger: Color(0xFFFCA5A5),
    highlightAlpha: 0.85,
    shadowAlpha: 1.05,
    brightness: Brightness.dark,
  );
}

/// Live palette. Swapped once at the root before the widget tree is built, so
/// every screen reads the same colours in the same frame.
class NeuColors {
  static NeuPalette palette = NeuPalette.light;

  static bool get isDark => palette.brightness == Brightness.dark;

  static Color get canvas => palette.canvas;
  static Color get surface => palette.surface;
  static Color get inset => palette.inset;
  static Color get highlight => palette.highlight;
  static Color get shadow => palette.shadow;
  static Color get ink => palette.ink;
  static Color get inkSoft => palette.inkSoft;
  static Color get accent => palette.accent;
  static Color get accentDark => palette.accentDark;
  static Color get upi => palette.upi;
  static Color get warn => palette.warn;
  static Color get danger => palette.danger;

  /// Text that sits on a filled accent/danger chip.
  static Color get onAccent =>
      isDark ? const Color(0xFF10151B) : const Color(0xFFFFFFFF);
}

class NeuTheme {
  static ThemeData build({bool dark = false}) {
    NeuColors.palette = dark ? NeuPalette.dark : NeuPalette.light;
    final tamil = GoogleFonts.notoSansTamil(color: NeuColors.ink);
    final base = dark ? ThemeData.dark(useMaterial3: true) : ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: NeuColors.canvas,
      colorScheme: ColorScheme(
        brightness: NeuColors.palette.brightness,
        primary: NeuColors.accentDark,
        onPrimary: NeuColors.onAccent,
        secondary: NeuColors.upi,
        onSecondary: NeuColors.onAccent,
        surface: NeuColors.surface,
        onSurface: NeuColors.ink,
        error: NeuColors.danger,
        onError: NeuColors.onAccent,
      ),
      textTheme: GoogleFonts.notoSansTamilTextTheme(base.textTheme).apply(
        bodyColor: NeuColors.ink,
        displayColor: NeuColors.ink,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: NeuColors.canvas,
        foregroundColor: NeuColors.ink,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: tamil.copyWith(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: NeuColors.ink,
        ),
      ),
      dialogTheme: DialogThemeData(backgroundColor: NeuColors.surface),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: NeuColors.surface,
        selectedItemColor: NeuColors.accentDark,
        unselectedItemColor: NeuColors.inkSoft,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle:
            const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: dark ? NeuColors.inset : NeuColors.ink,
        contentTextStyle:
            TextStyle(color: dark ? NeuColors.ink : Colors.white, fontSize: 15),
      ),
    );
  }

  /// Radius scale for soft-UI surfaces (cards, tiles, wells).
  static const double radiusCard = 26;
  static const double radiusTile = 22;
  static const double radiusWell = 18;

  static double _hi(double a) =>
      (a * NeuColors.palette.highlightAlpha).clamp(0.0, 1.0);
  static double _sh(double a) =>
      (a * NeuColors.palette.shadowAlpha).clamp(0.0, 1.0);

  /// Wide, low-contrast shadow used by large soft cards (reference look):
  /// bigger blur, gentler alpha, more visible white highlight.
  static List<BoxShadow> soft({double blur = 26, double dist = 9}) => [
        BoxShadow(
            color: NeuColors.highlight.withValues(alpha: _hi(0.95)),
            offset: Offset(-dist, -dist),
            blurRadius: blur),
        BoxShadow(
            color: NeuColors.shadow.withValues(alpha: _sh(0.42)),
            offset: Offset(dist, dist),
            blurRadius: blur + 4),
      ];

  /// Extruded (raised) neumorphic shadows. Light vector top-left (-4,-4).
  static List<BoxShadow> raised({double blur = 12, double dist = 5}) => [
        BoxShadow(
            color: NeuColors.highlight.withValues(alpha: _hi(0.9)),
            offset: Offset(-dist, -dist),
            blurRadius: blur),
        BoxShadow(
            color: NeuColors.shadow.withValues(alpha: _sh(0.65)),
            offset: Offset(dist, dist),
            blurRadius: blur + 2),
      ];

  /// Inset (recessed well) illusion: shadows flipped, drawn on a darker fill.
  static List<BoxShadow> recessed({double blur = 10, double dist = 4}) => [
        BoxShadow(
            color: NeuColors.shadow.withValues(alpha: _sh(0.55)),
            offset: Offset(-dist, -dist),
            blurRadius: blur),
        BoxShadow(
            color: NeuColors.highlight.withValues(alpha: _hi(0.85)),
            offset: Offset(dist, dist),
            blurRadius: blur),
      ];
}

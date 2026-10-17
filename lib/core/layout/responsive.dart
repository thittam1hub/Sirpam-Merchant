import 'package:flutter/material.dart';

/// Screen-size classes following Material 3 window size classes.
enum FormFactor { mobile, tablet, desktop }

/// Central breakpoint + spacing tokens so no screen hardcodes widths.
class Breakpoints {
  const Breakpoints._();

  /// < 600 : phones (compact)
  static const double tablet = 600;

  /// >= 1024 : desktop / large tablet landscape (expanded)
  static const double desktop = 1024;

  /// Reading-comfortable maximum for a single content column.
  static const double contentMaxWidth = 720;

  /// Maximum for dashboard-style multi-column content.
  static const double wideMaxWidth = 1180;

  static FormFactor of(double width) {
    if (width >= desktop) return FormFactor.desktop;
    if (width >= tablet) return FormFactor.tablet;
    return FormFactor.mobile;
  }
}

extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;

  FormFactor get formFactor => Breakpoints.of(screenWidth);

  bool get isMobile => formFactor == FormFactor.mobile;
  bool get isTablet => formFactor == FormFactor.tablet;
  bool get isDesktop => formFactor == FormFactor.desktop;

  /// True when navigation should live on the side instead of the bottom.
  bool get usesSideNav => formFactor != FormFactor.mobile;

  /// Horizontal page gutter that grows with the window.
  double get pageGutter => switch (formFactor) {
        FormFactor.mobile => 16,
        FormFactor.tablet => 24,
        FormFactor.desktop => 32,
      };

  /// Vertical rhythm between stacked sections.
  double get sectionGap => switch (formFactor) {
        FormFactor.mobile => 16,
        FormFactor.tablet => 20,
        FormFactor.desktop => 24,
      };

  /// Column count for card/tile grids.
  int gridColumns({int mobile = 1, int tablet = 2, int desktop = 3}) =>
      switch (formFactor) {
        FormFactor.mobile => mobile,
        FormFactor.tablet => tablet,
        FormFactor.desktop => desktop,
      };

  /// Scale factor for hero numbers/headlines on bigger screens.
  double get displayScale => switch (formFactor) {
        FormFactor.mobile => 1.0,
        FormFactor.tablet => 1.08,
        FormFactor.desktop => 1.16,
      };
}

/// Centers page content and caps its width so text lines stay readable on
/// tablets and desktops while phones keep edge-to-edge layout.
class ResponsiveContent extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final bool applyGutter;

  const ResponsiveContent({
    super.key,
    required this.child,
    this.maxWidth = Breakpoints.contentMaxWidth,
    this.applyGutter = false,
  });

  /// Wider variant for dashboards and grids.
  const ResponsiveContent.wide({
    super.key,
    required this.child,
    this.applyGutter = false,
  }) : maxWidth = Breakpoints.wideMaxWidth;

  @override
  Widget build(BuildContext context) {
    final content = applyGutter
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: context.pageGutter),
            child: child,
          )
        : child;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: content,
      ),
    );
  }
}

/// Builds different subtrees per form factor without repeating MediaQuery.
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, FormFactor form) builder;
  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) =>
            builder(context, Breakpoints.of(constraints.maxWidth)),
      );
}

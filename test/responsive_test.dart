import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vendoros/core/layout/responsive.dart';

void main() {
  test('window size classes map to form factors', () {
    expect(Breakpoints.of(390), FormFactor.mobile);
    expect(Breakpoints.of(599.9), FormFactor.mobile);
    expect(Breakpoints.of(600), FormFactor.tablet);
    expect(Breakpoints.of(1023), FormFactor.tablet);
    expect(Breakpoints.of(1024), FormFactor.desktop);
    expect(Breakpoints.of(1920), FormFactor.desktop);
  });

  testWidgets('context helpers follow the current window width',
      (tester) async {
    late BuildContext ctx;
    Future<void> pumpAt(Size size) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(builder: (c) {
            ctx = c;
            return const SizedBox.shrink();
          }),
        ),
      );
    }

    addTearDown(tester.view.reset);

    await pumpAt(const Size(400, 900));
    expect(ctx.isMobile, isTrue);
    expect(ctx.usesSideNav, isFalse);
    expect(ctx.pageGutter, 16);
    expect(ctx.gridColumns(), 1);

    await pumpAt(const Size(800, 1200));
    expect(ctx.isTablet, isTrue);
    expect(ctx.usesSideNav, isTrue);
    expect(ctx.gridColumns(), 2);

    await pumpAt(const Size(1400, 900));
    expect(ctx.isDesktop, isTrue);
    expect(ctx.pageGutter, 32);
    expect(ctx.gridColumns(), 3);
  });

  testWidgets('ResponsiveContent caps the content width', (tester) async {
    tester.view.physicalSize = const Size(1600, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(
        home: ResponsiveContent.wide(
          child: SizedBox(height: 10, child: Placeholder()),
        ),
      ),
    );
    final width = tester.getSize(find.byType(Placeholder)).width;
    expect(width, lessThanOrEqualTo(Breakpoints.wideMaxWidth));
  });
}

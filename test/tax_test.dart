import 'package:flutter_test/flutter_test.dart';
import 'package:vendoros/features/billing/domain/tax.dart';

void main() {
  group('GstMath.breakdown', () {
    test('splits exclusive tax into equal CGST and SGST halves', () {
      final b = GstMath.breakdown(
        lines: const [TaxableLine(totalPaise: 10000, ratePermille: 50)],
      );
      expect(b.slabs, hasLength(1));
      expect(b.taxablePaise, 10000);
      expect(b.cgstPaise, 250);
      expect(b.sgstPaise, 250);
      expect(b.taxPaise, 500);
      expect(b.slabs.first.rateLabel, '5');
      expect(b.slabs.first.halfRateLabel, '2.5');
    });

    test('pulls tax out of an inclusive price', () {
      final b = GstMath.breakdown(
        lines: const [TaxableLine(totalPaise: 10500, ratePermille: 50)],
        inclusive: true,
      );
      expect(b.taxablePaise, 10000);
      expect(b.taxPaise, 500);
    });

    test('prints one IGST figure for an out-of-state buyer', () {
      final b = GstMath.breakdown(
        lines: const [TaxableLine(totalPaise: 10000, ratePermille: 120)],
        interState: true,
      );
      expect(b.igstPaise, 1200);
      expect(b.cgstPaise, 0);
    });

    test('falls back to the shop rate when an item has none', () {
      final b = GstMath.breakdown(
        lines: const [TaxableLine(totalPaise: 10000)],
        fallbackPermille: 50,
      );
      expect(b.taxPaise, 500);
    });

    test('groups items by rate', () {
      final b = GstMath.breakdown(lines: const [
        TaxableLine(totalPaise: 10000, ratePermille: 50),
        TaxableLine(totalPaise: 20000, ratePermille: 120),
        TaxableLine(totalPaise: 5000, ratePermille: 50),
      ]);
      expect(b.slabs.map((s) => s.ratePermille), [50, 120]);
      expect(b.slabs.first.taxablePaise, 15000);
    });

    test('spreads a discount so the parts add back exactly', () {
      final b = GstMath.breakdown(
        lines: const [
          TaxableLine(totalPaise: 3333, ratePermille: 50),
          TaxableLine(totalPaise: 3333, ratePermille: 50),
          TaxableLine(totalPaise: 3334, ratePermille: 50),
        ],
        discountPaise: 1000,
      );
      expect(b.taxablePaise, 9000);
    });

    test('no rate anywhere means no tax at all', () {
      expect(
        GstMath.breakdown(lines: const [TaxableLine(totalPaise: 10000)]).isEmpty,
        isTrue,
      );
    });

    test('slab survives a JSON round trip', () {
      const slab = TaxSlab(
          ratePermille: 50, taxablePaise: 10000, cgstPaise: 250, sgstPaise: 250);
      final back = TaxSlab.tryFromJson(slab.toJson())!;
      expect(back.taxablePaise, 10000);
      expect(back.taxPaise, 500);
    });

    test('percent and permille convert both ways', () {
      expect(GstMath.permilleFromPercent(12.5), 125);
      expect(GstMath.percentFromPermille(125), 12.5);
    });
  });
}

/// GST domain: per-item rates grouped into the slab table a tax invoice needs.
///
/// Pure integer-paise math, no Flutter and no storage. Rates are permille
/// (5% is 50) so 2.5% CGST halves without floating point.
library;

/// One billed line as far as tax is concerned.
class TaxableLine {
  final int totalPaise;
  final int ratePermille;
  final String hsn;

  const TaxableLine({
    required this.totalPaise,
    this.ratePermille = 0,
    this.hsn = '',
  });
}

/// Everything sold at one rate, already split the way a bill prints it.
class TaxSlab {
  final int ratePermille;
  final int taxablePaise;
  final int cgstPaise;
  final int sgstPaise;
  final int igstPaise;

  const TaxSlab({
    required this.ratePermille,
    required this.taxablePaise,
    this.cgstPaise = 0,
    this.sgstPaise = 0,
    this.igstPaise = 0,
  });

  int get taxPaise => cgstPaise + sgstPaise + igstPaise;

  /// `5`, `12.5` — the rate as printed, without trailing zeros.
  String get rateLabel {
    final whole = ratePermille ~/ 10;
    final frac = ratePermille % 10;
    return frac == 0 ? '$whole' : '$whole.$frac';
  }

  /// Half the rate, as CGST and SGST each print it (5% -> `2.5`).
  String get halfRateLabel => _trim(ratePermille / 20);

  static String _trim(double v) {
    var t = v.toStringAsFixed(2);
    while (t.contains('.') && (t.endsWith('0') || t.endsWith('.'))) {
      t = t.substring(0, t.length - 1);
    }
    return t;
  }

  Map<String, dynamic> toJson() => {
        'rate': ratePermille,
        'taxable': taxablePaise,
        'cgst': cgstPaise,
        'sgst': sgstPaise,
        'igst': igstPaise,
      };

  static TaxSlab? tryFromJson(Map<String, dynamic> j) {
    final rate = j['rate'];
    if (rate is! num) return null;
    return TaxSlab(
      ratePermille: rate.toInt(),
      taxablePaise: (j['taxable'] as num?)?.toInt() ?? 0,
      cgstPaise: (j['cgst'] as num?)?.toInt() ?? 0,
      sgstPaise: (j['sgst'] as num?)?.toInt() ?? 0,
      igstPaise: (j['igst'] as num?)?.toInt() ?? 0,
    );
  }
}

/// The slab table plus its rolled-up totals.
class TaxBreakdown {
  final List<TaxSlab> slabs;

  const TaxBreakdown(this.slabs);

  static const TaxBreakdown empty = TaxBreakdown(<TaxSlab>[]);

  bool get isEmpty => slabs.isEmpty;

  int get taxablePaise => slabs.fold(0, (a, s) => a + s.taxablePaise);
  int get cgstPaise => slabs.fold(0, (a, s) => a + s.cgstPaise);
  int get sgstPaise => slabs.fold(0, (a, s) => a + s.sgstPaise);
  int get igstPaise => slabs.fold(0, (a, s) => a + s.igstPaise);
  int get taxPaise => cgstPaise + sgstPaise + igstPaise;
}

class GstMath {
  const GstMath._();

  /// Splits a bill into slabs.
  ///
  /// [discountPaise] is spread across the lines in proportion to their value,
  /// with the rounding remainder landing on the last line so the parts always
  /// add back to the discount. [inclusive] means the printed prices already
  /// contain the tax. [interState] prints one IGST figure instead of the
  /// CGST/SGST pair.
  static TaxBreakdown breakdown({
    required List<TaxableLine> lines,
    int fallbackPermille = 0,
    int discountPaise = 0,
    bool inclusive = false,
    bool interState = false,
  }) {
    final priced = [for (final l in lines) l.totalPaise > 0 ? l : null]
        .whereType<TaxableLine>()
        .toList();
    if (priced.isEmpty) return TaxBreakdown.empty;

    final gross = priced.fold(0, (a, l) => a + l.totalPaise);
    final discount = discountPaise.clamp(0, gross);

    // Value of each line after its share of the discount.
    final net = <int>[];
    var spent = 0;
    for (var i = 0; i < priced.length; i++) {
      final share = i == priced.length - 1
          ? discount - spent
          : (discount * priced[i].totalPaise / gross).round();
      spent += share;
      net.add(priced[i].totalPaise - share);
    }

    final byRate = <int, int>{};
    for (var i = 0; i < priced.length; i++) {
      final rate = priced[i].ratePermille > 0
          ? priced[i].ratePermille
          : (fallbackPermille > 0 ? fallbackPermille : 0);
      if (rate <= 0) continue;
      byRate[rate] = (byRate[rate] ?? 0) + net[i];
    }
    if (byRate.isEmpty) return TaxBreakdown.empty;

    final rates = byRate.keys.toList()..sort();
    final slabs = <TaxSlab>[];
    for (final rate in rates) {
      final amount = byRate[rate]!;
      final taxable =
          inclusive ? (amount * 1000 / (1000 + rate)).round() : amount;
      final tax = inclusive ? amount - taxable : (taxable * rate / 1000).round();
      if (interState) {
        slabs.add(TaxSlab(
            ratePermille: rate, taxablePaise: taxable, igstPaise: tax));
      } else {
        final half = tax ~/ 2;
        slabs.add(TaxSlab(
          ratePermille: rate,
          taxablePaise: taxable,
          cgstPaise: half,
          sgstPaise: tax - half,
        ));
      }
    }
    return TaxBreakdown(slabs);
  }

  /// A percent typed by the vendor ("5", "12.5") as permille.
  static int permilleFromPercent(double percent) =>
      percent <= 0 ? 0 : (percent * 10).round();

  static double percentFromPermille(int permille) => permille / 10;
}

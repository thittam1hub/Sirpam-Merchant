import 'inventory_models.dart';

/// Pure stock arithmetic: FIFO consumption, on-hand, valuation and expiry.
/// No I/O, no Flutter — every rule here is unit-testable in isolation.
class FifoDraw {
  final String batchId;
  final int qtyMilli;
  final int costPaise; // per unit
  const FifoDraw(
      {required this.batchId, required this.qtyMilli, required this.costPaise});

  /// Cost of this draw in paise (quantity is in milli-units).
  int get valuePaise => (qtyMilli * costPaise / 1000).round();
}

class FifoResult {
  final List<FifoDraw> draws;

  /// Quantity that could not be covered by the available batches.
  final int shortfallMilli;

  const FifoResult({required this.draws, required this.shortfallMilli});

  int get cogsPaise => draws.fold(0, (a, d) => a + d.valuePaise);
  int get drawnMilli => draws.fold(0, (a, d) => a + d.qtyMilli);
  bool get isComplete => shortfallMilli == 0;
}

enum ExpiryBucket { expired, today, soon, later, none }

class StockMath {
  const StockMath._();

  static List<StockBatch> liveBatches(List<StockBatch> batches, String productId) =>
      batches
          .where((b) =>
              !b.deleted && b.productId == productId && b.remainingMilli > 0)
          .toList()
        ..sort((a, b) => a.receivedAt.compareTo(b.receivedAt));

  static int onHandMilli(List<StockBatch> batches, String productId) =>
      liveBatches(batches, productId)
          .fold(0, (a, b) => a + b.remainingMilli);

  /// Stock value at what it actually cost (FIFO layers), in paise.
  static int valuationPaise(List<StockBatch> batches) => batches
      .where((b) => !b.deleted && b.remainingMilli > 0)
      .fold(0, (a, b) => a + (b.remainingMilli * b.costPaise / 1000).round());

  /// Oldest-first consumption. Never mutates the input.
  static FifoResult consumeFifo(
      List<StockBatch> batches, String productId, int qtyMilli) {
    var left = qtyMilli;
    final draws = <FifoDraw>[];
    for (final b in liveBatches(batches, productId)) {
      if (left <= 0) break;
      final take = left < b.remainingMilli ? left : b.remainingMilli;
      draws.add(
          FifoDraw(batchId: b.id, qtyMilli: take, costPaise: b.costPaise));
      left -= take;
    }
    return FifoResult(draws: draws, shortfallMilli: left < 0 ? 0 : left);
  }

  /// Applies [draws] to a batch list, returning the updated list.
  static List<StockBatch> applyDraws(
      List<StockBatch> batches, List<FifoDraw> draws, int now) {
    final byId = {for (final d in draws) d.batchId: d.qtyMilli};
    return [
      for (final b in batches)
        byId.containsKey(b.id)
            ? b.copyWith(
                remainingMilli: b.remainingMilli - byId[b.id]!, updatedAt: now)
            : b,
    ];
  }

  static ExpiryBucket bucket(StockBatch batch, DateTime now,
      {int soonDays = 7}) {
    final e = batch.expiryAt;
    if (e == null) return ExpiryBucket.none;
    final expiry = DateTime.fromMillisecondsSinceEpoch(e);
    final days = DateTime(expiry.year, expiry.month, expiry.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
    if (days < 0) return ExpiryBucket.expired;
    if (days == 0) return ExpiryBucket.today;
    if (days <= soonDays) return ExpiryBucket.soon;
    return ExpiryBucket.later;
  }

  static bool isLow(Product product, int onHandMilli) =>
      product.reorderMilli > 0 && onHandMilli <= product.reorderMilli;

  /// Human quantity: 250 milli-units of kg -> "0.25". Trailing zeros dropped.
  static String formatQty(int milli) {
    final v = milli / 1000;
    var s = v.toStringAsFixed(3);
    if (s.contains('.')) {
      s = s.replaceFirst(RegExp(r'0+$'), '');
      s = s.replaceFirst(RegExp(r'\.$'), '');
    }
    return s;
  }

  /// Parses a typed quantity into milli-units; null on junk or negatives.
  static int? parseQty(String raw) {
    final v = double.tryParse(raw.trim());
    if (v == null || v <= 0 || v > 1000000) return null;
    return (v * 1000).round();
  }

  /// Parses rupees into paise; null on junk or negatives.
  static int? parseMoney(String raw) {
    final v = double.tryParse(raw.trim().replaceAll(',', ''));
    if (v == null || v < 0 || v > 10000000) return null;
    return (v * 100).round();
  }
}

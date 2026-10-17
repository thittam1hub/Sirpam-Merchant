import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../../core/l10n/app_message.dart';
import '../../../core/settings/settings_controller.dart';
import '../../../core/storage/storage_failure.dart';
import '../../ledger/application/ledger_controller.dart';

class MandiPrice {
  final String commodity;
  final String variety;
  final String market;
  final double minPerKg;
  final double maxPerKg;
  final double modalPerKg;
  final String arrivalDate;

  const MandiPrice({
    required this.commodity,
    required this.variety,
    required this.market,
    required this.minPerKg,
    required this.maxPerKg,
    required this.modalPerKg,
    required this.arrivalDate,
  });

  Map<String, dynamic> toJson() => {
        'commodity': commodity,
        'variety': variety,
        'market': market,
        'min': minPerKg,
        'max': maxPerKg,
        'modal': modalPerKg,
        'date': arrivalDate,
      };

  factory MandiPrice.fromJson(Map<String, dynamic> j) => MandiPrice(
        commodity: j['commodity'] as String,
        variety: j['variety'] as String? ?? '',
        market: j['market'] as String? ?? '',
        minPerKg: (j['min'] as num).toDouble(),
        maxPerKg: (j['max'] as num).toDouble(),
        modalPerKg: (j['modal'] as num).toDouble(),
        arrivalDate: j['date'] as String? ?? '',
      );

  /// data.gov.in publishes APMC prices per quintal (100 kg).
  factory MandiPrice.fromOgd(Map<String, dynamic> r) {
    double q(Object? v) {
      final d = double.tryParse(v?.toString() ?? '') ?? 0;
      return d / 100.0;
    }

    return MandiPrice(
      commodity: r['commodity']?.toString() ?? '—',
      variety: r['variety']?.toString() ?? '',
      market: r['market']?.toString() ?? '',
      minPerKg: q(r['min_price']),
      maxPerKg: q(r['max_price']),
      modalPerKg: q(r['modal_price']),
      arrivalDate: r['arrival_date']?.toString() ?? '',
    );
  }
}

enum MandiStatus { needsKey, loading, ready, error }

class MandiState {
  final MandiStatus status;
  final List<MandiPrice> prices;
  final int? syncedAt;
  final AppMessage? error;
  const MandiState({
    required this.status,
    this.prices = const [],
    this.syncedAt,
    this.error,
  });
}

/// Live APMC wholesale prices from the data.gov.in OGD platform.
/// Resource: Current Daily Price of Various Commodities from Various Markets.
class MandiController extends AsyncNotifier<MandiState> {
  static const _resource = '9ef84268-d588-465a-a308-a864a43d0070';
  static const markets = <String>[
    'Koyambedu',
    'Madurai(Mattuthavani)',
    'Trichy(Gandhi Market)',
  ];

  @override
  Future<MandiState> build() async {
    final cached = ref.read(localStoreProvider).readMandiCache();
    final key = ref.watch(settingsProvider).mandiApiKey;
    final market = ref.watch(settingsProvider).market;

    if (key.trim().isEmpty) {
      // Honest empty state — never fabricated prices.
      return MandiState(
        status: MandiStatus.needsKey,
        prices: cached == null
            ? const []
            : (cached['rows'] as List)
                .map((e) => MandiPrice.fromJson((e as Map).cast()))
                .toList(),
        syncedAt: cached?['ts'] as int?,
      );
    }
    return _fetch(key, market);
  }

  Future<void> refresh() async {
    final s = ref.read(settingsProvider);
    if (s.mandiApiKey.trim().isEmpty) return;
    state = const AsyncValue<MandiState>.loading();
    state = await AsyncValue.guard(() => _fetch(s.mandiApiKey, s.market));
  }

  Future<MandiState> _fetch(String apiKey, String market) async {
    final uri = Uri.https('api.data.gov.in', '/resource/$_resource', {
      'api-key': apiKey.trim(),
      'format': 'json',
      'limit': '200',
      'filters[state.keyword]': 'Tamil Nadu',
      'filters[market.keyword]': market,
    });

    try {
      final res = await http.get(uri).timeout(const Duration(seconds: 20));
      if (res.statusCode == 401 || res.statusCode == 403) {
        return MandiState(
          status: MandiStatus.error,
          error: AppMessage(
              AppMessageCode.mandiKeyRejected, '${res.statusCode}'),
          prices: _cachedRows(),
          syncedAt: _cachedTs(),
        );
      }
      if (res.statusCode != 200) {
        return MandiState(
          status: MandiStatus.error,
          error: AppMessage.raw('data.gov.in HTTP ${res.statusCode}'),
          prices: _cachedRows(),
          syncedAt: _cachedTs(),
        );
      }
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      final records = (body['records'] as List? ?? const [])
          .map((e) => MandiPrice.fromOgd((e as Map).cast<String, dynamic>()))
          .where((p) => p.modalPerKg > 0)
          .toList()
        ..sort((a, b) => a.commodity.compareTo(b.commodity));

      final ts = DateTime.now().millisecondsSinceEpoch;
      await guardWrite(
          ref,
          () => ref.read(localStoreProvider).writeMandiCache({
                'ts': ts,
                'market': market,
                'rows': records.map((e) => e.toJson()).toList(),
              }));
      return MandiState(
          status: MandiStatus.ready, prices: records, syncedAt: ts);
    } catch (e) {
      return MandiState(
        status: MandiStatus.error,
        error: AppMessage(AppMessageCode.connectionFailed, '$e'),
        prices: _cachedRows(),
        syncedAt: _cachedTs(),
      );
    }
  }

  List<MandiPrice> _cachedRows() {
    final c = ref.read(localStoreProvider).readMandiCache();
    if (c == null) return const [];
    return (c['rows'] as List)
        .map((e) => MandiPrice.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
  }

  int? _cachedTs() =>
      ref.read(localStoreProvider).readMandiCache()?['ts'] as int?;
}

final mandiProvider =
    AsyncNotifierProvider<MandiController, MandiState>(MandiController.new);

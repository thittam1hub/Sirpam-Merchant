import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/supabase_config.dart';
import '../../../core/storage/local_store.dart';
import '../../ledger/application/ledger_controller.dart';
import '../../ledger/domain/sale.dart';
import '../../orders/application/order_controller.dart';

import '../data/merchant_api.dart';
import '../domain/server_payment.dart';
import 'soundbox_service.dart';

/// Poll cadence while the app is open. Payments also arrive on resume and on
/// manual refresh; nothing is lost between polls because the server keeps
/// every unacknowledged payment until this device confirms it.
const _pollInterval = Duration(seconds: 8);

/// If no successful sync happens within this window the UI warns the vendor
/// instead of silently pretending the soundbox is healthy.
const _staleAfter = Duration(minutes: 10);

class MerchantSoundboxState {
  final bool loaded;
  final PairedMerchant? merchant;

  /// Confirmed payments waiting to be spoken (durable across app restarts).
  final List<ServerPayment> pending;

  /// Spoken but not yet acknowledged to the server (retried every poll).
  final List<String> unacked;

  /// Recently announced payments, newest first (display only).
  final List<ServerPayment> announced;

  final int? lastSyncMs;
  final bool syncing;
  final String? lastError;
  final bool pairing;

  const MerchantSoundboxState({
    this.loaded = false,
    this.merchant,
    this.pending = const [],
    this.unacked = const [],
    this.announced = const [],
    this.lastSyncMs,
    this.syncing = false,
    this.lastError,
    this.pairing = false,
  });

  bool get isPaired => merchant != null;

  bool get isStale {
    if (!isPaired) return false;
    if (lastSyncMs == null) return true;
    return DateTime.now().millisecondsSinceEpoch - lastSyncMs! >
        _staleAfter.inMilliseconds;
  }

  MerchantSoundboxState copyWith({
    bool? loaded,
    PairedMerchant? merchant,
    bool clearMerchant = false,
    List<ServerPayment>? pending,
    List<String>? unacked,
    List<ServerPayment>? announced,
    int? lastSyncMs,
    bool? syncing,
    String? lastError,
    bool clearError = false,
    bool? pairing,
  }) =>
      MerchantSoundboxState(
        loaded: loaded ?? this.loaded,
        merchant: clearMerchant ? null : (merchant ?? this.merchant),
        pending: pending ?? this.pending,
        unacked: unacked ?? this.unacked,
        announced: announced ?? this.announced,
        lastSyncMs: lastSyncMs ?? this.lastSyncMs,
        syncing: syncing ?? this.syncing,
        lastError: clearError ? null : (lastError ?? this.lastError),
        pairing: pairing ?? this.pairing,
      );
}

/// Server-confirmed soundbox.
///
/// The payment provider posts every successful UPI collection to the backend,
/// which stores it once (idempotent on the provider transaction id). This
/// controller drains that queue: it speaks each payment exactly once, writes it
/// to the ledger, and only then acknowledges it. A crash, a dead battery or a
/// week offline cannot lose a payment — the server keeps it queued until this
/// device confirms it was announced.
class MerchantSoundboxController extends Notifier<MerchantSoundboxState> {
  MerchantApi get _api => ref.read(merchantApiProvider);
  LocalStore get _store => ref.read(localStoreProvider);
  Timer? _timer;
  bool _draining = false;

  @override
  MerchantSoundboxState build() {
    ref.onDispose(() => _timer?.cancel());
    final restored = _restore();
    if (restored.isPaired) {
      _timer = Timer.periodic(_pollInterval, (_) => sync());
      scheduleMicrotask(sync);
    }
    return restored;
  }

  MerchantSoundboxState _restore() {
    final raw = _store.readSoundboxSync();
    if (raw == null) return const MerchantSoundboxState(loaded: true);
    final pending = (raw['pending'] as List? ?? const [])
        .map(ServerPayment.tryFromJson)
        .whereType<ServerPayment>()
        .toList();
    final announced = (raw['announced'] as List? ?? const [])
        .map(ServerPayment.tryFromJson)
        .whereType<ServerPayment>()
        .toList();
    return MerchantSoundboxState(
      loaded: true,
      merchant: PairedMerchant.tryFromJson(raw['merchant']),
      pending: pending,
      unacked: (raw['unacked'] as List? ?? const [])
          .map((e) => e.toString())
          .toList(),
      announced: announced,
      lastSyncMs: raw['last_sync_ms'] is int ? raw['last_sync_ms'] as int : null,
    );
  }

  Future<void> _persist() async {
    try {
      await _store.writeSoundboxSync({
        'merchant': state.merchant?.toJson(),
        'pending': state.pending.map((p) => p.toJson()).toList(),
        'unacked': state.unacked,
        'announced':
            state.announced.take(50).map((p) => p.toJson()).toList(),
        'last_sync_ms': state.lastSyncMs,
      });
    } catch (e) {
      state = state.copyWith(lastError: e.toString());
    }
  }

  // ------------------------------------------------------------- pairing

  Future<bool> pair(String pairingCode) async {
    if (!SupabaseConfig.isConfigured) {
      state = state.copyWith(lastError: 'Backend not configured');
      return false;
    }
    state = state.copyWith(pairing: true, clearError: true);
    try {
      final merchant = await _api.pair(
        pairingCode: pairingCode,
        platform: kIsWeb ? 'web' : defaultTargetPlatform.name,
      );
      state = state.copyWith(merchant: merchant, pairing: false);
      await _persist();
      _timer?.cancel();
      _timer = Timer.periodic(_pollInterval, (_) => sync());
      await sync();
      return true;
    } on MerchantApiFailure catch (e) {
      state = state.copyWith(pairing: false, lastError: e.message);
      return false;
    }
  }

  /// Registers a new business merchant and immediately links this phone to it.
  /// Returns the pairing code so the vendor can note it for a second device.
  Future<String?> registerAndPair({
    required String businessName,
    required String provider,
    required String merchantRef,
    String? vpa,
    String? phonepeSaltKey,
    String? phonepeSaltIndex,
    String? paytmWebhookToken,
  }) async {
    if (!SupabaseConfig.isConfigured) {
      state = state.copyWith(lastError: 'Backend not configured');
      return null;
    }
    state = state.copyWith(pairing: true, clearError: true);
    try {
      final code = await _api.register(
        businessName: businessName,
        provider: provider,
        merchantRef: merchantRef,
        vpa: vpa,
        phonepeSaltKey: phonepeSaltKey,
        phonepeSaltIndex: phonepeSaltIndex,
        paytmWebhookToken: paytmWebhookToken,
      );
      state = state.copyWith(pairing: false);
      final ok = await pair(code);
      return ok ? code : null;
    } on MerchantApiFailure catch (e) {
      state = state.copyWith(pairing: false, lastError: e.message);
      return null;
    }
  }

  Future<void> unpair() async {
    _timer?.cancel();
    _timer = null;
    state = const MerchantSoundboxState(loaded: true);
    await _persist();
  }

  // ---------------------------------------------------------------- sync

  /// Pull every unannounced payment, then drain the local queue.
  Future<void> sync() async {
    final merchant = state.merchant;
    if (merchant == null || state.syncing) return;
    state = state.copyWith(syncing: true);
    try {
      // Retry acknowledgements first so a payment is never re-delivered.
      if (state.unacked.isNotEmpty) {
        await _api.ack(merchant.deviceKey, state.unacked);
        state = state.copyWith(unacked: const []);
      }

      // Keeps the server's last-seen accurate, so the vendor (and support)
      // can tell a quiet day from a dead soundbox.
      await _api.heartbeat(merchant.deviceKey);

      final incoming = await _api.feed(merchant.deviceKey);
      if (incoming.isNotEmpty) {
        final known = {
          ...state.pending.map((p) => p.id),
          ...state.announced.map((p) => p.id),
        };
        final fresh = incoming.where((p) => !known.contains(p.id)).toList();
        if (fresh.isNotEmpty) {
          state = state.copyWith(pending: [...state.pending, ...fresh]);
        }
      }
      state = state.copyWith(
        lastSyncMs: DateTime.now().millisecondsSinceEpoch,
        clearError: true,
      );
      await _persist();
    } on MerchantApiFailure catch (e) {
      state = state.copyWith(lastError: e.message);
      if (e.isDeviceUnknown) await unpair();
    } finally {
      state = state.copyWith(syncing: false);
    }
    await _drain();
  }

  /// Speak and record each queued payment exactly once, oldest first.
  Future<void> _drain() async {
    if (_draining) return;
    _draining = true;
    try {
      while (state.pending.isNotEmpty) {
        final payment = state.pending.first;
        await ref.read(soundboxProvider.notifier).announce(payment.rupees);
        try {
          // If exactly one open order matches this amount, close that order as
          // a paid UPI bill (which writes the ledger sale and takes the stock
          // out). Otherwise fall back to a plain UPI sale row.
          final settled = await ref
              .read(orderProvider.notifier)
              .settleFromUpiPayment(payment.amountPaise);
          if (settled == null) {
            await ref.read(ledgerProvider.notifier).addSale(
                  amountPaise: payment.amountPaise,
                  mode: SaleMode.upi,
                  item: payment.providerLabel,
                );
          }
        } catch (e) {
          state = state.copyWith(lastError: e.toString());
        }

        state = state.copyWith(
          pending: state.pending.sublist(1),
          announced: [payment, ...state.announced].take(50).toList(),
          unacked: [...state.unacked, payment.id],
        );
        await _persist();
      }
      final merchant = state.merchant;
      if (merchant != null && state.unacked.isNotEmpty) {
        try {
          await _api.ack(merchant.deviceKey, state.unacked);
          state = state.copyWith(unacked: const []);
          await _persist();
        } on MerchantApiFailure {
          // Kept in `unacked` and retried on the next sync.
        }
      }
    } finally {
      _draining = false;
    }
  }
}

final merchantApiProvider = Provider<MerchantApi>((ref) => MerchantApi());

final merchantSoundboxProvider =
    NotifierProvider<MerchantSoundboxController, MerchantSoundboxState>(
        MerchantSoundboxController.new);

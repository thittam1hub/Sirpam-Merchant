import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/l10n/app_message.dart';

class CartPosition {
  final double lat;
  final double lng;
  final double accuracy;
  final int ts;
  const CartPosition(
      {required this.lat,
      required this.lng,
      required this.accuracy,
      required this.ts});

  /// Web-viewable location URL usable in any browser or WhatsApp preview.
  String get mapsUrl =>
      'https://maps.google.com/?q=${lat.toStringAsFixed(6)},${lng.toStringAsFixed(6)}';
}

enum BroadcastStatus { off, requesting, live, denied, unavailable }

class LocationState {
  final BroadcastStatus status;
  final CartPosition? position;
  final AppMessage? error;
  const LocationState({required this.status, this.position, this.error});
}

/// Low-power cart tracker: updates only every 45 s or 30 m of displacement.
class LocationController extends Notifier<LocationState> {
  StreamSubscription<Position>? _sub;
  Timer? _throttle;
  DateTime _lastEmit = DateTime.fromMillisecondsSinceEpoch(0);

  static const _settings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 30, // metres
  );

  @override
  LocationState build() {
    ref.onDispose(() {
      _sub?.cancel();
      _throttle?.cancel();
    });
    return const LocationState(status: BroadcastStatus.off);
  }

  Future<void> start() async {
    if (state.status == BroadcastStatus.live) return;
    state = const LocationState(status: BroadcastStatus.requesting);
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        state = const LocationState(
            status: BroadcastStatus.unavailable,
            error: AppMessage(AppMessageCode.locationServiceOff));
        return;
      }
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        state = const LocationState(
            status: BroadcastStatus.denied,
            error: AppMessage(AppMessageCode.locationPermissionDenied));
        return;
      }

      final first = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      _emit(first, force: true);

      unawaited(_sub?.cancel());
      _sub = Geolocator.getPositionStream(locationSettings: _settings)
          .listen(_emit, onError: (Object e) {
        state = LocationState(
            status: BroadcastStatus.unavailable,
            position: state.position,
            error: AppMessage.raw(e.toString()));
      });
    } catch (e) {
      state = LocationState(
          status: BroadcastStatus.unavailable, error: AppMessage.raw(e.toString()));
    }
  }

  /// Time-throttle on top of the 30 m distance filter: at most one fix / 45 s.
  void _emit(Position p, {bool force = false}) {
    final now = DateTime.now();
    if (!force && now.difference(_lastEmit) < const Duration(seconds: 45)) {
      return;
    }
    _lastEmit = now;
    state = LocationState(
      status: BroadcastStatus.live,
      position: CartPosition(
        lat: p.latitude,
        lng: p.longitude,
        accuracy: p.accuracy,
        ts: now.millisecondsSinceEpoch,
      ),
    );
  }

  void stop() {
    _sub?.cancel();
    _sub = null;
    state = LocationState(status: BroadcastStatus.off, position: state.position);
  }
}

final locationProvider =
    NotifierProvider<LocationController, LocationState>(
        LocationController.new);

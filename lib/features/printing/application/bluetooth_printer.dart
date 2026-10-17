import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A thermal printer the phone is already paired with.
class BluetoothDevice {
  final String name;
  final String address;

  const BluetoothDevice({required this.name, required this.address});
}

/// Bluetooth (SPP) transport for ESC/POS receipt printers.
///
/// Android only — every other platform reports "unsupported" so the caller
/// falls back to the PDF/share path instead of failing the bill.
class BluetoothPrinter {
  static const _channel = MethodChannel('vendoros/printer');

  const BluetoothPrinter();

  bool get platformSupported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  Future<T?> _call<T>(String method, [Map<String, dynamic>? args]) async {
    if (!platformSupported) return null;
    try {
      return await _channel.invokeMethod<T>(method, args);
    } on PlatformException {
      return null;
    } on MissingPluginException {
      return null;
    }
  }

  Future<bool> isSupported() async =>
      (await _call<bool>('isSupported')) ?? false;

  Future<bool> hasPermission() async =>
      (await _call<bool>('hasPermission')) ?? false;

  /// Asks Android for the runtime Bluetooth grant (Android 12+). Resolves with
  /// the state after the vendor answers the system dialog.
  Future<bool> requestPermission() async =>
      (await _call<bool>('requestPermission')) ?? false;

  /// Printers already paired in Android Bluetooth settings.
  Future<List<BluetoothDevice>> bondedDevices() async {
    final raw = await _call<List<dynamic>>('bondedDevices');
    if (raw == null) return const [];
    return [
      for (final e in raw)
        if (e is Map)
          BluetoothDevice(
            name: (e['name'] as String?) ?? '',
            address: (e['address'] as String?) ?? '',
          ),
    ].where((d) => d.address.isNotEmpty).toList();
  }

  Future<String> connectedAddress() async =>
      (await _call<String>('connectedAddress')) ?? '';

  Future<bool> connect(String address) async =>
      (await _call<bool>('connect', {'address': address})) ?? false;

  Future<bool> write(List<int> bytes) async =>
      (await _call<bool>('write', {'bytes': Uint8List.fromList(bytes)})) ??
      false;

  Future<void> disconnect() => _call<bool>('disconnect');

  /// Connect (if needed) and push the bytes. Returns false on any failure so
  /// the caller can fall back to PDF.
  Future<bool> send(String address, List<int> bytes) async {
    if (!platformSupported || address.isEmpty) return false;
    if (await connectedAddress() != address) {
      if (!await connect(address)) return false;
    }
    if (await write(bytes)) return true;
    // One reconnect attempt: thermal printers drop idle sockets aggressively.
    if (!await connect(address)) return false;
    return write(bytes);
  }
}

final bluetoothPrinterProvider =
    Provider<BluetoothPrinter>((ref) => const BluetoothPrinter());

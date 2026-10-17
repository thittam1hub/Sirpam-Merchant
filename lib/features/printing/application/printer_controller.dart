import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/local_store.dart';
import '../../../core/storage/storage_failure.dart';
import '../../ledger/application/ledger_controller.dart';
import '../domain/printer_settings.dart';

class PrinterController extends Notifier<PrinterSettings> {
  LocalStore get _store => ref.read(localStoreProvider);

  @override
  PrinterSettings build() {
    final raw = _store.readPrinter();
    return raw == null ? const PrinterSettings() : PrinterSettings.fromJson(raw);
  }

  Future<void> save(PrinterSettings next) async {
    state = next;
    await guardWrite(ref, () => _store.writePrinter(next.toJson()));
  }
}

final printerProvider =
    NotifierProvider<PrinterController, PrinterSettings>(PrinterController.new);

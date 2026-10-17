import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu.dart';
import '../../../core/widgets/neu_chrome.dart';
import '../../products/presentation/inventory_widgets.dart';
import '../application/bluetooth_printer.dart';
import '../application/printer_controller.dart';
import '../application/receipt_printer.dart';
import '../domain/printer_settings.dart';
import '../domain/receipt.dart';

/// Receipt printer setup: roll width, how the paper is produced, and a test
/// print so the vendor can verify before the first customer.
class PrintersPage extends ConsumerStatefulWidget {
  const PrintersPage({super.key});

  @override
  ConsumerState<PrintersPage> createState() => _PrintersPageState();
}

class _PrintersPageState extends ConsumerState<PrintersPage> {
  late final TextEditingController _name;
  late final TextEditingController _address;
  List<BluetoothDevice> _devices = const [];
  bool _scanning = false;
  bool _connected = false;
  bool _supported = false;
  bool _permitted = false;
  String _connectedAddress = '';

  @override
  void initState() {
    super.initState();
    final s = ref.read(printerProvider);
    _name = TextEditingController(text: s.deviceName);
    _address = TextEditingController(text: s.deviceAddress);
    Future.microtask(_refreshStatus);
  }

  /// Live transport state: does this phone have Bluetooth at all, is the
  /// runtime grant in place, and which printer is currently on the socket.
  Future<void> _refreshStatus() async {
    final bt = ref.read(bluetoothPrinterProvider);
    final supported = await bt.isSupported();
    final permitted = supported ? await bt.hasPermission() : false;
    final address = permitted ? await bt.connectedAddress() : '';
    if (!mounted) return;
    setState(() {
      _supported = supported;
      _permitted = permitted;
      _connectedAddress = address;
      _connected = address.isNotEmpty;
    });
  }

  Future<bool> _ensurePermission() async {
    final bt = ref.read(bluetoothPrinterProvider);
    if (!await bt.isSupported()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.printerUnsupported)));
      }
      return false;
    }
    if (await bt.hasPermission()) return true;
    final granted = await bt.requestPermission();
    if (!mounted) return granted;
    if (!granted) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.printerPermissionDenied)));
    }
    await _refreshStatus();
    return granted;
  }

  /// Drops the socket but keeps the saved printer, so the next bill reconnects.
  Future<void> _disconnect() async {
    await ref.read(bluetoothPrinterProvider).disconnect();
    if (!mounted) return;
    await _refreshStatus();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.printerDisconnected)));
  }

  /// Forgets the printer entirely and falls back to the PDF/share path.
  Future<void> _forget() async {
    final settings = ref.read(printerProvider);
    await ref.read(bluetoothPrinterProvider).disconnect();
    await ref.read(printerProvider.notifier).save(settings.copyWith(
        deviceName: '', deviceAddress: '', transport: PrintTransport.pdf));
    if (!mounted) return;
    _name.text = '';
    _address.text = '';
    await _refreshStatus();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.printerForgotten)));
  }

  @override
  void dispose() {
    _name.dispose();
    _address.dispose();
    super.dispose();
  }

  /// Lists printers already paired in Android's Bluetooth settings — that is
  /// how every counter thermal printer is set up in practice.
  Future<void> _scan() async {
    if (!await _ensurePermission()) return;
    final bt = ref.read(bluetoothPrinterProvider);
    if (!mounted) return;
    setState(() => _scanning = true);
    final found = await bt.bondedDevices();
    if (!mounted) return;
    setState(() {
      _devices = found;
      _scanning = false;
    });
    if (found.isEmpty && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.printerNoDevices)));
    }
  }

  Future<void> _connect(PrinterSettings settings) async {
    final address = _address.text.trim();
    if (address.isEmpty) return;
    if (!await _ensurePermission()) return;
    final bt = ref.read(bluetoothPrinterProvider);
    await ref.read(printerProvider.notifier).save(settings.copyWith(
        deviceName: _name.text.trim(),
        deviceAddress: address,
        transport: PrintTransport.bluetooth));
    final ok = await bt.connect(address);
    if (!mounted) return;
    setState(() {
      _connected = ok;
      _connectedAddress = ok ? address : '';
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            ok ? context.l10n.printerConnected : context.l10n.printerConnectFailed)));
  }

  Future<void> _testPrint() async {
    final l10n = context.l10n;
    final settings = ref.read(printerProvider);
    final data = ReceiptData(
      shopName: l10n.appTitle,
      billNumber: l10n.printerTest,
      dateText: TimeOfDay.now().format(context),
      lines: [ReceiptLine(name: l10n.printerTest, qty: 1, totalPaise: 1000)],
      subtotalPaise: 1000,
      totalPaise: 1000,
      labels: ReceiptLabels(
        bill: l10n.billNumberLabel,
        token: l10n.orderTokenShort,
        table: l10n.orderTable,
        subtotal: l10n.billSubtotal,
        discount: l10n.billDiscount,
        tax: l10n.billTax,
        rounding: l10n.billRounding,
        total: l10n.billTotal,
        paid: l10n.billPaid,
        balance: l10n.billBalance,
        reprint: l10n.billReprint,
        thanks: l10n.billThanks,
      ),
    );
    final outcome = await ReceiptPrinter.send(data, settings,
        jobName: l10n.printerTest,
        bluetooth: ref.read(bluetoothPrinterProvider));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(outcome == PrintOutcome.fellBackToPdf
            ? l10n.printerFallbackNote
            : l10n.printerTestSent)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final settings = ref.watch(printerProvider);
    final controller = ref.read(printerProvider.notifier);
    final needsDevice = settings.transport != PrintTransport.pdf;

    return DetailScaffold(
      title: l10n.printersTitle,
      subtitle: l10n.printersSubtitle,
      fallbackLocation: AppPaths.orders,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 32),
        children: [
          SectionTitle(l10n.printerWidth),
          Row(children: [
            for (final w in PaperWidth.values) ...[
              Expanded(
                child: NeuButton(
                  selected: settings.width == w,
                  minHeight: 46,
                  onPressed: () => controller.save(settings.copyWith(width: w)),
                  child: Text(paperWidthLabel(w),
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: settings.width == w
                              ? NeuColors.accentDark
                              : NeuColors.inkSoft)),
                ),
              ),
              if (w != PaperWidth.values.last) const SizedBox(width: 10),
            ],
          ]),
          const SizedBox(height: 18),
          SectionTitle(l10n.printerTransport),
          Row(children: [
            for (final t in PrintTransport.values) ...[
              Expanded(
                child: NeuButton(
                  selected: settings.transport == t,
                  minHeight: 46,
                  onPressed: () =>
                      controller.save(settings.copyWith(transport: t)),
                  child: Text(
                      switch (t) {
                        PrintTransport.pdf => l10n.printerPdf,
                        PrintTransport.bluetooth => l10n.printerBluetooth,
                        PrintTransport.usb => l10n.printerUsb,
                      },
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: settings.transport == t
                              ? NeuColors.accentDark
                              : NeuColors.inkSoft)),
                ),
              ),
              if (t != PrintTransport.values.last) const SizedBox(width: 10),
            ],
          ]),
          if (settings.transport == PrintTransport.bluetooth) ...[
            const SizedBox(height: 18),
            SectionTitle(l10n.printerStatus),
            NeuBox(
              inset: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    !_supported
                        ? l10n.printerUnsupported
                        : _connectedAddress.isNotEmpty
                            ? l10n.printerConnectedTo(
                                settings.deviceName.isEmpty
                                    ? _connectedAddress
                                    : settings.deviceName)
                            : l10n.printerNotConnected,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: _connectedAddress.isNotEmpty
                            ? NeuColors.accentDark
                            : NeuColors.inkSoft),
                  ),
                  if (_supported && !_permitted) ...[
                    const SizedBox(height: 8),
                    Text(l10n.printerPermissionNeeded,
                        style: TextStyle(
                            fontSize: 13, color: NeuColors.inkSoft)),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(children: [
              if (_supported && !_permitted)
                Expanded(
                  child: NeuButton(
                    minHeight: 44,
                    onPressed: _ensurePermission,
                    child: Text(l10n.printerAllowBluetooth,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: NeuColors.accentDark)),
                  ),
                ),
              if (_connectedAddress.isNotEmpty) ...[
                Expanded(
                  child: NeuButton(
                    minHeight: 44,
                    onPressed: _disconnect,
                    child: Text(l10n.printerDisconnect,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: NeuColors.inkSoft)),
                  ),
                ),
                const SizedBox(width: 10),
              ],
              if (settings.deviceAddress.isNotEmpty)
                Expanded(
                  child: NeuButton(
                    minHeight: 44,
                    onPressed: _forget,
                    child: Text(l10n.printerForget,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: NeuColors.danger)),
                  ),
                ),
            ]),
            const SizedBox(height: 18),
            SectionTitle(l10n.printerPaired),
            NeuButton(
              onPressed: _scanning ? null : _scan,
              child: Text(_scanning ? l10n.printerScanning : l10n.printerScan,
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: NeuColors.inkSoft)),
            ),
            for (final d in _devices)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: NeuButton(
                  selected: settings.deviceAddress == d.address,
                  onPressed: () {
                    setState(() {
                      _name.text = d.name;
                      _address.text = d.address;
                      _connected = false;
                    });
                  },
                  child: Row(children: [
                    Expanded(
                        child: Text(d.name,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: NeuColors.ink))),
                    Text(d.address,
                        style: TextStyle(
                            fontSize: 12, color: NeuColors.inkSoft)),
                  ]),
                ),
              ),
            const SizedBox(height: 10),
            NeuButton(
              onPressed: () => _connect(settings),
              child: Text(_connected ? l10n.printerConnected : l10n.printerConnect,
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: NeuColors.accentDark)),
            ),
          ],
          if (needsDevice) ...[
            const SizedBox(height: 18),
            LabeledField(label: l10n.printerDeviceName, controller: _name),
            LabeledField(label: l10n.printerDeviceAddress, controller: _address),
            NeuButton(
              onPressed: () => controller.save(settings.copyWith(
                  deviceName: _name.text.trim(),
                  deviceAddress: _address.text.trim())),
              child: Text(l10n.save,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: NeuColors.accentDark)),
            ),
            const SizedBox(height: 12),
            NeuBox(
              inset: true,
              child: Text(
                  settings.transport == PrintTransport.bluetooth
                      ? l10n.printerBluetoothNote
                      : l10n.printerFallbackNote,
                  style: TextStyle(
                      fontSize: 13, color: NeuColors.inkSoft)),
            ),
          ],
          const SizedBox(height: 18),
          _SwitchRow(
            label: l10n.printerAutoPrint,
            value: settings.autoPrint,
            onChanged: (v) => controller.save(settings.copyWith(autoPrint: v)),
          ),
          const SizedBox(height: 12),
          _SwitchRow(
            label: l10n.printerKot,
            value: settings.printKot,
            onChanged: (v) => controller.save(settings.copyWith(printKot: v)),
          ),
          const SizedBox(height: 20),
          NeuButton(
            onPressed: _testPrint,
            child: Text(l10n.printerTest,
                style: TextStyle(
                    fontWeight: FontWeight.w800, color: NeuColors.accentDark)),
          ),
        ],
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchRow(
      {required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) => Row(children: [
        Expanded(
          child: Text(label,
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: NeuColors.inkSoft)),
        ),
        NeuSwitch(value: value, label: label, onChanged: onChanged),
      ]);
}

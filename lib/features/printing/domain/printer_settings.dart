import 'receipt.dart';

/// How receipts leave the app.
enum PrintTransport {
  /// Rendered as a roll-width PDF and handed to the system print/share sheet —
  /// always available, including on web and on phones with no printer paired.
  pdf,

  /// ESC/POS bytes pushed to a paired Bluetooth thermal printer.
  bluetooth,

  /// ESC/POS bytes pushed over USB OTG.
  usb,
}

PrintTransport printTransportFrom(String? raw) => switch (raw) {
      'bluetooth' => PrintTransport.bluetooth,
      'usb' => PrintTransport.usb,
      _ => PrintTransport.pdf,
    };

class PrinterSettings {
  final PaperWidth width;
  final PrintTransport transport;

  /// Paired device name, shown in Settings so the vendor recognises it.
  final String deviceName;
  final String deviceAddress;

  /// Print the bill automatically the moment it is settled.
  final bool autoPrint;

  /// Print a kitchen ticket when an order is accepted.
  final bool printKot;

  const PrinterSettings({
    this.width = PaperWidth.mm58,
    this.transport = PrintTransport.pdf,
    this.deviceName = '',
    this.deviceAddress = '',
    this.autoPrint = false,
    this.printKot = false,
  });

  PrinterSettings copyWith({
    PaperWidth? width,
    PrintTransport? transport,
    String? deviceName,
    String? deviceAddress,
    bool? autoPrint,
    bool? printKot,
  }) =>
      PrinterSettings(
        width: width ?? this.width,
        transport: transport ?? this.transport,
        deviceName: deviceName ?? this.deviceName,
        deviceAddress: deviceAddress ?? this.deviceAddress,
        autoPrint: autoPrint ?? this.autoPrint,
        printKot: printKot ?? this.printKot,
      );

  Map<String, dynamic> toJson() => {
        'width': width == PaperWidth.mm58 ? '58' : '80',
        'transport': transport.name,
        'device': deviceName,
        'address': deviceAddress,
        'autoPrint': autoPrint,
        'printKot': printKot,
      };

  factory PrinterSettings.fromJson(Map<String, dynamic> j) => PrinterSettings(
        width: paperWidthFrom(j['width'] as String?),
        transport: printTransportFrom(j['transport'] as String?),
        deviceName: j['device'] as String? ?? '',
        deviceAddress: j['address'] as String? ?? '',
        autoPrint: j['autoPrint'] == true,
        printKot: j['printKot'] == true,
      );
}

import 'package:flutter_test/flutter_test.dart';
import 'package:vendoros/features/backup/domain/backup_bundle.dart';
import 'package:vendoros/features/backup/domain/csv_export.dart';
import 'package:vendoros/features/ledger/domain/sale.dart';

void main() {
  group('backup bundle', () {
    final books = <String, Object>{
      'vendoros.sales.v1': [
        {'id': 'a', 'ts': 1, 'paise': 5000, 'mode': 'cash'},
      ],
      'vendoros.settings.v1': {'stallName': 'Anna Tea'},
    };

    test('round trips through encode and read', () {
      final bundle = BackupBundle(
        createdAtMs: 1700000000000,
        shopName: 'Anna Tea',
        books: books,
      );
      final result = readBackup(bundle.encode());
      expect(result.isOk, isTrue);
      expect(result.bundle!.shopName, 'Anna Tea');
      expect(result.bundle!.books.keys, containsAll(books.keys));
      expect(result.bundle!.rowCount, 2);
    });

    test('rejects a file that is not a backup', () {
      expect(readBackup('{"hello":1}').error, BackupError.notABackup);
      expect(readBackup('not json').error, BackupError.notJson);
      expect(readBackup('   ').error, BackupError.empty);
    });

    test('rejects a tampered or half-copied file', () {
      final bundle = BackupBundle(createdAtMs: 1, books: books).encode();
      final broken = bundle.replaceFirst('5000', '9900');
      expect(readBackup(broken).error, BackupError.corrupt);
    });

    test('refuses a backup from a newer app version', () {
      const raw = '{"format":"$kBackupFormat","version":99,"books":{}}';
      expect(readBackup(raw).error, BackupError.tooNew);
    });

    test('file name is filesystem safe and dated', () {
      expect(backupFileName(DateTime(2026, 9, 10, 18, 5)),
          'vendoros-backup-2026-09-10-1805.json');
    });
  });

  group('csv export', () {
    test('escapes commas, quotes and newlines', () {
      expect(csvCell('Tea, hot'), '"Tea, hot"');
      expect(csvCell('He said "hi"'), '"He said ""hi"""');
      expect(csvCell('a\nb'), '"a\nb"');
      expect(csvCell(null), '');
    });

    test('money is written in rupees, never paise', () {
      expect(csvRupees(12345), '123.45');
      expect(csvRupees(0), '0.00');
    });

    test('sales sheet keeps header and one row per sale', () {
      final csv = CsvExport.sales(
        [
          Sale(
            id: '1',
            ts: DateTime(2026, 9, 10, 9, 30).millisecondsSinceEpoch,
            amountPaise: 2500,
            mode: SaleMode.upi,
            item: 'Chai, special',
            customer: 'Raja',
          ),
        ],
        const ['Date', 'Item', 'Payment', 'Customer', 'Amount'],
      );
      expect(csv.startsWith('\uFEFF'), isTrue, reason: 'Excel needs the BOM');
      final lines = csv.trim().split('\n');
      expect(lines.first, 'Date,Item,Payment,Customer,Amount');
      expect(lines[1], contains('"Chai, special"'));
      expect(lines[1], endsWith('25.00'));
    });

    test('credit sheet is sorted by customer name', () {
      final csv = CsvExport.credit(
        {'Vijay': 10000, 'Anitha': 5000},
        const ['Customer', 'Balance'],
      );
      final lines = csv.trim().split('\n');
      expect(lines[1], 'Anitha,50.00');
      expect(lines[2], 'Vijay,100.00');
    });
  });
}

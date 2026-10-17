/// One file that holds the whole shop's books.
///
/// Pure and Flutter-free: the same bundle is written to a file the vendor
/// keeps, or uploaded, and read back on a new phone. A checksum travels with
/// it so a half-copied file is refused instead of wiping good books.
library;

import 'dart:convert';

import 'package:crypto/crypto.dart';

const String kBackupFormat = 'vendoros.backup';
const int kBackupVersion = 1;

class BackupBundle {
  final int version;
  final int createdAtMs;
  final String shopName;
  final String appVersion;
  final Map<String, Object> books;

  const BackupBundle({
    required this.createdAtMs,
    required this.books,
    this.version = kBackupVersion,
    this.shopName = '',
    this.appVersion = '',
  });

  /// Row counts per book, for the "what is inside this file" summary.
  Map<String, int> get counts {
    final out = <String, int>{};
    books.forEach((key, value) {
      out[key] = value is List ? value.length : 1;
    });
    return out;
  }

  int get documentCount => books.length;

  int get rowCount =>
      counts.values.fold<int>(0, (sum, n) => sum + n);

  Map<String, Object?> toJson() {
    final body = <String, Object?>{
      'format': kBackupFormat,
      'version': version,
      'createdAt': createdAtMs,
      'shop': shopName,
      'app': appVersion,
      'books': books,
    };
    return {...body, 'checksum': checksumOf(books)};
  }

  String encode() => const JsonEncoder.withIndent('  ').convert(toJson());

  /// SHA-256 over the books in a stable key order.
  static String checksumOf(Map<String, Object> books) {
    final keys = books.keys.toList()..sort();
    final ordered = <String, Object>{for (final k in keys) k: books[k]!};
    return sha256.convert(utf8.encode(jsonEncode(ordered))).toString();
  }
}

/// Why a file could not be restored, in a form the UI can translate.
enum BackupError { notJson, notABackup, tooNew, corrupt, empty }

class BackupReadResult {
  final BackupBundle? bundle;
  final BackupError? error;
  const BackupReadResult.ok(BackupBundle this.bundle) : error = null;
  const BackupReadResult.failed(BackupError this.error) : bundle = null;
  bool get isOk => bundle != null;
}

/// Reads a backup file back. Never throws: every bad input maps to an error
/// the vendor can be told about in their own language.
BackupReadResult readBackup(String raw) {
  if (raw.trim().isEmpty) return const BackupReadResult.failed(BackupError.empty);
  Object? decoded;
  try {
    decoded = jsonDecode(raw);
  } on FormatException {
    return const BackupReadResult.failed(BackupError.notJson);
  }
  if (decoded is! Map) {
    return const BackupReadResult.failed(BackupError.notABackup);
  }
  final map = decoded.cast<Object?, Object?>();
  if (map['format']?.toString() != kBackupFormat) {
    return const BackupReadResult.failed(BackupError.notABackup);
  }
  final version = (map['version'] as num?)?.toInt() ?? 0;
  if (version > kBackupVersion) {
    return const BackupReadResult.failed(BackupError.tooNew);
  }
  final rawBooks = map['books'];
  if (rawBooks is! Map) {
    return const BackupReadResult.failed(BackupError.corrupt);
  }
  final books = <String, Object>{};
  rawBooks.forEach((k, v) {
    if (v is Map || v is List) books[k.toString()] = v as Object;
  });
  final checksum = map['checksum']?.toString() ?? '';
  if (checksum.isNotEmpty && checksum != BackupBundle.checksumOf(books)) {
    return const BackupReadResult.failed(BackupError.corrupt);
  }
  return BackupReadResult.ok(BackupBundle(
    version: version == 0 ? kBackupVersion : version,
    createdAtMs: (map['createdAt'] as num?)?.toInt() ?? 0,
    shopName: map['shop']?.toString() ?? '',
    appVersion: map['app']?.toString() ?? '',
    books: books,
  ));
}

/// `vendoros-backup-2026-09-10-1830.json`, safe on every filesystem.
String backupFileName(DateTime at) {
  String two(int v) => v.toString().padLeft(2, '0');
  return 'vendoros-backup-${at.year}-${two(at.month)}-${two(at.day)}'
      '-${two(at.hour)}${two(at.minute)}.json';
}

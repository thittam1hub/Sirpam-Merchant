import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Guards the ARB catalogs so the build fails when a locale drifts,
/// a key is unused, or a Tamil string is hard-coded outside `lib/l10n`.
void main() {
  const locales = ['ta', 'hi', 'te', 'kn', 'ml'];
  final en = _arb('lib/l10n/app_en.arb');
  final catalogs = {
    for (final code in locales) code: _arb('lib/l10n/app_$code.arb'),
  };
  final enKeys = en.keys.toSet();
  final sources = _dartSources();

  // Keys that exist for API/message plumbing rather than direct `l10n.x` use.
  const allowUnused = <String>{'appTitle'};

  test('every locale carries exactly the English keys', () {
    for (final code in locales) {
      final keys = catalogs[code]!.keys.toSet();
      expect(keys.difference(enKeys), isEmpty,
          reason: '$code has keys missing from app_en.arb');
      expect(enKeys.difference(keys), isEmpty,
          reason: 'app_$code.arb is missing English keys');
    }
  });

  test('every declared placeholder survives translation', () {
    final meta =
        jsonDecode(File('lib/l10n/app_en.arb').readAsStringSync()) as Map;
    for (final key in enKeys) {
      final declared = (meta['@$key'] as Map?)?['placeholders'] as Map?;
      if (declared == null) continue;
      for (final name in declared.keys) {
        for (final code in locales) {
          expect(catalogs[code]![key], contains('{$name'),
              reason: '$code "$key" is missing the {$name} placeholder');
        }
        expect(en[key], contains('{$name'),
            reason: 'English "$key" is missing the {$name} placeholder');
      }
    }
  });

  test('no ARB key is unused in the app', () {
    final unused = enKeys
        .where((k) => !allowUnused.contains(k))
        .where((k) => !sources.any((s) => RegExp('\\b$k\\b').hasMatch(s)))
        .toList()
      ..sort();
    expect(unused, isEmpty, reason: 'Remove or use these keys: $unused');
  });

  test('no Tamil literal is hard-coded outside the ARB catalogs', () {
    final tamil = RegExp(r'[\u0B80-\u0BFF]');
    final offenders = <String>[];
    for (final file in _dartFiles()) {
      if (file.path.contains('lib/l10n') ||
          file.path.contains('app_languages.dart') ||
          file.path.contains('voice_parser.dart')) {
        continue; // catalogs + locale-independent speech keyword lists
      }
      final body = file.readAsStringSync();
      if (tamil.hasMatch(body)) offenders.add(file.path);
    }
    expect(offenders, isEmpty,
        reason: 'Move these strings into the ARB catalogs: $offenders');
  });
}

Map<String, String> _arb(String path) {
  final json =
      jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
  return {
    for (final e in json.entries)
      if (!e.key.startsWith('@')) e.key: e.value as String,
  };
}

List<File> _dartFiles() => Directory('lib')
    .listSync(recursive: true)
    .whereType<File>()
    .where((f) => f.path.endsWith('.dart'))
    .where((f) => !f.path.contains('l10n/generated'))
    .toList();

List<String> _dartSources() =>
    _dartFiles().map((f) => f.readAsStringSync()).toList();

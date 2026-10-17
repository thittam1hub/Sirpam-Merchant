# Skills / runbook

Operational knowledge for building, verifying and shipping VendorOS inside
this sandbox. Follow it literally; each step exists because the naive version
fails here.

## 1. Toolchain

There is no preinstalled Flutter SDK, and the Dart shipped with the nix
Flutter build does not trust the system CA bundle. `scripts/toolchain.sh`
and `scripts/build-web.sh` handle this:

```bash
nix build nixpkgs#flutter --no-link --print-out-paths   # FLUTTER_ROOT
nix build nixpkgs#dart    --no-link --print-out-paths   # DART_SDK
```

Both paths are cached in `.dart_tool/.toolchain_paths`. **The cache does not
survive a sandbox reset** — if `flutter: command not found`, re-provision. Nix
occasionally fails with `reading a line: Input/output error`; that is
transient, retry once.

Package resolution must use the standalone Dart with an explicit CA bundle:

```bash
"$DART_SDK/bin/dart" --root-certs-file=/etc/ssl/certs/ca-bundle.crt pub get
flutter build web --no-pub ...   # --no-pub so the Flutter tool never fetches
```

## 2. Web build

```bash
bash scripts/build-web.sh                  # analyze + release + smoke + publish
BUILD_MODE=fast bash scripts/build-web.sh  # small Dart change, ~minutes faster
SKIP_SMOKE=1 bash scripts/build-web.sh
```
`scripts/publish-web.mjs` copies `build/web` into the tracked `web_build/`
folder, which is what `npm run dev` serves on :8080 for the Lovable preview.
A build that is not published does not change the preview.

## 3. Tests

```bash
flutter test              # whole suite
flutter test test/voice_parser_test.dart
```
Unit tests must not need a widget binding: keep money/parsing logic in
`domain/`.

## 4. Android APK

```bash
bash scripts/build-apk.sh   # provisions JDK 17 + Android SDK, then assembles release
```
Output lands in `build/app/outputs/flutter-apk/`. It is signed with the debug
key — fine for sideloading, **not** for Play Store. For Play: create an upload
keystore, add `android/key.properties`, and wire `signingConfigs.release`.

## 5. Verifying the preview with Playwright

Flutter web renders to a canvas: **text locators do not work**. Do not try to
click Tamil labels.

- Navigate by URL (`http://localhost:8080/#/mandi?market=Koyambedu`) instead
  of clicking navigation.
- Screenshot per route and read the images.
- The Lovable preview overlay covers the bottom of the viewport, so
  coordinate clicks on the bottom nav are unreliable.
- A console `Failed to load module script` MIME warning comes from the
  preview overlay, not from the Flutter bundle.

Scripts live under `/tmp/browser/vendoros/`.

## 6. Troubleshooting

| Symptom | Cause / fix |
| --- | --- |
| `flutter: command not found` | toolchain cache wiped; re-run the nix builds |
| TLS / certificate error in `pub get` | missing `--root-certs-file` |
| `reading a line: Input/output error` | transient nix failure; retry |
| Preview unchanged after a build | forgot `publish-web.mjs` (build-web.sh does it) |
| Playwright times out on a label | canvas rendering; navigate by URL instead |
| Geolocator API mismatch | v12 uses `desiredAccuracy:`, not `locationSettings:` |
| Icon tree-shake failure | never build `IconData` from a runtime code point |

## 7. Definition of done for any change

1. `flutter analyze` clean (no new warnings).
2. `flutter test` green.
3. `bash scripts/build-web.sh` succeeds and publishes.
4. Affected routes screenshot-verified in the preview.
5. `docs/PRODUCTION_CHECKLIST.md` updated, `roadmap.md` pruned.

#!/usr/bin/env bash
# Build → verify → publish pipeline for the Flutter web bundle.
#
#   bash scripts/build-web.sh                 # full release build + smoke test
#   BUILD_MODE=fast bash scripts/build-web.sh # incremental, much faster
#   SKIP_SMOKE=1 bash scripts/build-web.sh
#
# The sandbox has no preinstalled Flutter SDK, and the Dart shipped with the
# nix Flutter build does not trust the system CA bundle, so `flutter pub get`
# fails with TLS errors. We therefore:
#   1. materialise Flutter + a standalone Dart from nixpkgs,
#   2. resolve packages with the standalone Dart using --root-certs-file,
#   3. compile with the real Flutter tool (--no-pub so it skips its own fetch),
#   4. smoke-test the bundle in headless Chromium,
#   5. publish it into the tracked web_build/ folder the preview serves.
#
# BUILD_MODE=fast is the "small Dart change" path: it reuses the resolved
# package config and the existing .dart_tool incremental kernel cache, skips
# `flutter analyze` and the smoke test, and compiles with -O1 and no source
# maps. Output is functionally identical, just less optimised.
set -euo pipefail

MODE="${BUILD_MODE:-full}"
CACHE=".dart_tool/.toolchain_paths"

if [ -f "$CACHE" ]; then
  # shellcheck disable=SC1090
  source "$CACHE"
fi
if [ ! -d "${FLUTTER_ROOT:-/nonexistent}" ] || [ ! -d "${DART_SDK:-/nonexistent}" ]; then
  FLUTTER_ROOT="$(nix build nixpkgs#flutter --no-link --print-out-paths)"
  DART_SDK="$(nix build nixpkgs#dart --no-link --print-out-paths)"
  mkdir -p .dart_tool
  printf 'FLUTTER_ROOT=%s\nDART_SDK=%s\n' "$FLUTTER_ROOT" "$DART_SDK" > "$CACHE"
fi
CA_BUNDLE="${CA_BUNDLE:-/etc/ssl/certs/ca-bundle.crt}"
export FLUTTER_ROOT
export PATH="$FLUTTER_ROOT/bin:$PATH"

if [ "$MODE" = "fast" ] && [ -f ".dart_tool/package_config.json" ]; then
  echo "--- fast mode: reusing resolved packages (skipping pub get + analyze) ---"
else
  "$DART_SDK/bin/dart" --root-certs-file="$CA_BUNDLE" pub get
  flutter analyze --no-pub || true
fi

BUILD_STAMP="${BUILD_STAMP:-$(date -u '+%Y-%m-%d %H:%M UTC')}"
BUILD_ID="${BUILD_ID:-$(date -u '+%s')}"

# Icon tree-shaking is enabled: stored icon code points are mapped through a
# const lookup table (see lib/features/rooms/rooms_section.dart), never turned
# into IconData at runtime.
EXTRA=()
if [ "$MODE" = "fast" ]; then
  EXTRA+=(--dart2js-optimization=O1 --no-source-maps)
  BUILD_STAMP="$BUILD_STAMP (fast)"
fi

flutter build web --no-pub --release --no-wasm-dry-run "${EXTRA[@]}" \
  --dart-define=BUILD_STAMP="$BUILD_STAMP" \
  --dart-define=BUILD_ID="$BUILD_ID"

if [ "$MODE" != "fast" ] && [ "${SKIP_SMOKE:-0}" != "1" ]; then
  echo "--- smoke test (headless Chromium) ---"
  python3 scripts/smoke_web.py
fi

node scripts/publish-web.mjs

echo "Built + published ($MODE). 'npm run dev' serves it on http://localhost:8080"

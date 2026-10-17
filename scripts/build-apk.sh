#!/usr/bin/env bash
# Build the Android APK inside this sandbox.
#
#   bash scripts/build-apk.sh              # release APK (split per ABI off)
#   APK_MODE=debug bash scripts/build-apk.sh
#   SPLIT_ABI=1 bash scripts/build-apk.sh  # smaller per-architecture APKs
#
# Toolchain (provisioned once by scripts/setup-android-sdk.sh):
#   JDK 17  -> nix temurin-bin-17
#   Android -> $HOME/android-sdk (cmdline-tools, platform-tools, platform 35,
#              build-tools 35.0.0)
set -euo pipefail

CACHE=".dart_tool/.toolchain_paths"
[ -f "$CACHE" ] && source "$CACHE"

# shellcheck source=scripts/toolchain.sh
export CACHE_FILE="$CACHE"
source "$(dirname "$0")/toolchain.sh"
ensure_java
ensure_flutter
toolchain_cache_write
export ANDROID_SDK_ROOT="${ANDROID_SDK_ROOT:-$HOME/android-sdk}"
export ANDROID_HOME="$ANDROID_SDK_ROOT"
export FLUTTER_ROOT
export PATH="$JAVA_HOME/bin:$FLUTTER_ROOT/bin:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$PATH"

if [ ! -d "$ANDROID_SDK_ROOT/platforms" ]; then
  echo "Android SDK missing at $ANDROID_SDK_ROOT - run scripts/setup-android-sdk.sh first" >&2
  exit 1
fi

CA_BUNDLE="${CA_BUNDLE:-/etc/ssl/certs/ca-bundle.crt}"
export SSL_CERT_FILE="$CA_BUNDLE"

# Dependency resolution happens in two steps on purpose.
#
# 1. `dart pub get` warms $PUB_CACHE. It must run through dartaotruntime with
#    --root-certs-file: the sandbox terminates TLS with its own CA, and neither
#    SSL_CERT_FILE nor DART_VM_OPTIONS reaches pub (the `dart`/`flutter`
#    launchers re-exec pub as an AOT snapshot and drop VM flags), so a plain
#    `flutter pub get` dies with CERTIFICATE_VERIFY_FAILED.
# 2. `flutter pub get --offline` then runs against the warm cache. Only Flutter
#    writes .flutter-plugins-dependencies, the native-plugin metadata the
#    Android Gradle plugin reads. Without it the APK still builds but packages
#    no plugins at all, and the app dies at boot on the shared_preferences
#    Pigeon channel.
DART_BIN="$FLUTTER_ROOT/bin/cache/dart-sdk/bin"
if [ -x "$DART_BIN/dartaotruntime" ]; then
  "$DART_BIN/dartaotruntime" --root-certs-file="$CA_BUNDLE" \
    "$DART_BIN/snapshots/dartdev_aot.dart.snapshot" pub get || true
fi
flutter pub get --offline

# Proof, not hope: the Gradle build silently degrades when this file is absent.
if ! grep -q shared_preferences_android .flutter-plugins-dependencies 2>/dev/null; then
  echo "ERROR: .flutter-plugins-dependencies missing plugin entries" >&2
  exit 1
fi


flutter config --android-sdk "$ANDROID_SDK_ROOT" --no-analytics >/dev/null 2>&1 || true

BUILD_STAMP="${BUILD_STAMP:-$(date -u '+%Y-%m-%d %H:%M UTC')}"
BUILD_ID="${BUILD_ID:-$(date -u '+%s')}"
MODE="${APK_MODE:-release}"

EXTRA=()
[ "${SPLIT_ABI:-0}" = "1" ] && EXTRA+=(--split-per-abi)

flutter build apk --no-pub "--$MODE" "${EXTRA[@]}" \
  --dart-define=BUILD_STAMP="$BUILD_STAMP" \
  --dart-define=BUILD_ID="$BUILD_ID"

ls -lh build/app/outputs/flutter-apk/*.apk

#!/usr/bin/env bash
# Shared toolchain provisioning for the Android build.
#
# Source this file; it exports JAVA_HOME, FLUTTER_ROOT and DART_SDK, installing
# anything missing. Two supply routes, tried in order:
#
#   1. nix  (fast when the sandbox has a warm store / reachable cache)
#   2. direct vendor tarballs from Adoptium and storage.googleapis.com
#
# Route 2 exists because channels.nixos.org and the GitHub API both rate-limit
# hard in some sandboxes; the vendor CDNs stay reachable. Everything is cached
# under $TOOLCHAIN_DIR and in .dart_tool/.toolchain_paths, so re-runs are cheap.

TOOLCHAIN_DIR="${TOOLCHAIN_DIR:-$HOME/toolchains}"
JDK_VERSION="${JDK_VERSION:-17}"
FLUTTER_CHANNEL="${FLUTTER_CHANNEL:-stable}"
CACHE_FILE="${CACHE_FILE:-.dart_tool/.toolchain_paths}"

_have() { [ -n "${1:-}" ] && [ -d "$1" ]; }

_nix_path() {
  # Prints a store path on success, nothing on failure. Never aborts the build.
  nix build "nixpkgs#$1" --no-link --print-out-paths 2>/dev/null || true
}

ensure_java() {
  _have "${JAVA_HOME:-}" && [ -x "$JAVA_HOME/bin/java" ] && return 0

  local p
  p="$(_nix_path "temurin-bin-$JDK_VERSION")"
  if _have "$p"; then JAVA_HOME="$p"; export JAVA_HOME; return 0; fi

  local dest="$TOOLCHAIN_DIR/jdk$JDK_VERSION"
  if [ ! -x "$dest/bin/java" ]; then
    echo "--- downloading Temurin JDK $JDK_VERSION ---"
    mkdir -p "$dest"
    curl -fsSL -o /tmp/jdk.tar.gz \
      "https://api.adoptium.net/v3/binary/latest/$JDK_VERSION/ga/linux/x64/jdk/hotspot/normal/eclipse"
    tar -xzf /tmp/jdk.tar.gz -C "$dest" --strip-components=1
    rm -f /tmp/jdk.tar.gz
  fi
  JAVA_HOME="$dest"; export JAVA_HOME
}

ensure_flutter() {
  if _have "${FLUTTER_ROOT:-}" && [ -x "$FLUTTER_ROOT/bin/flutter" ]; then
    DART_SDK="${DART_SDK:-$FLUTTER_ROOT/bin/cache/dart-sdk}"
    export FLUTTER_ROOT DART_SDK
    return 0
  fi

  local f d
  f="$(_nix_path flutter)"
  d="$(_nix_path dart)"
  if _have "$f" && _have "$d"; then
    FLUTTER_ROOT="$f"; DART_SDK="$d"; export FLUTTER_ROOT DART_SDK; return 0
  fi

  local dest="$TOOLCHAIN_DIR/flutter"
  if [ ! -x "$dest/bin/flutter" ]; then
    echo "--- downloading Flutter SDK ($FLUTTER_CHANNEL) ---"
    mkdir -p "$TOOLCHAIN_DIR"
    local base="https://storage.googleapis.com/flutter_infra_release/releases"
    local archive
    archive="$(curl -fsSL "$base/releases_linux.json" | python3 -c "
import json,sys
d = json.load(sys.stdin)
h = d['current_release']['$FLUTTER_CHANNEL']
print(next(r['archive'] for r in d['releases'] if r['hash'] == h and r['channel'] == '$FLUTTER_CHANNEL'))
")"
    curl -fL --retry 3 -o /tmp/flutter.tar.xz "$base/$archive"
    tar -xJf /tmp/flutter.tar.xz -C "$TOOLCHAIN_DIR"
    rm -f /tmp/flutter.tar.xz
  fi
  FLUTTER_ROOT="$dest"
  DART_SDK="$dest/bin/cache/dart-sdk"
  export FLUTTER_ROOT DART_SDK
}

toolchain_cache_write() {
  mkdir -p "$(dirname "$CACHE_FILE")"
  printf 'FLUTTER_ROOT=%s\nDART_SDK=%s\nJAVA_HOME=%s\n' \
    "$FLUTTER_ROOT" "$DART_SDK" "$JAVA_HOME" > "$CACHE_FILE"
}

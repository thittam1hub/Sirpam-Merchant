#!/usr/bin/env bash
# One-time Android toolchain provisioning for this sandbox / a fresh machine.
#   bash scripts/setup-android-sdk.sh
set -euo pipefail

SDK="${ANDROID_SDK_ROOT:-$HOME/android-sdk}"
CLI_ZIP_URL="https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip"
# shellcheck source=scripts/toolchain.sh
source "$(dirname "$0")/toolchain.sh"
ensure_java
ensure_flutter
toolchain_cache_write
export PATH="$JAVA_HOME/bin:$PATH"

mkdir -p "$SDK"
if [ ! -x "$SDK/cmdline-tools/latest/bin/sdkmanager" ]; then
  echo "--- downloading Android command-line tools ---"
  curl -sL -o "$SDK/cmdline-tools.zip" "$CLI_ZIP_URL"
  ( cd "$SDK" && unzip -q -o cmdline-tools.zip && mkdir -p cmdline-tools/latest \
      && mv cmdline-tools/bin cmdline-tools/lib cmdline-tools/NOTICE.txt \
            cmdline-tools/source.properties cmdline-tools/latest/ )
fi

SDKMANAGER="$SDK/cmdline-tools/latest/bin/sdkmanager"
# `yes |` makes sdkmanager exit with SIGPIPE once it stops reading; that is not
# a failure, so accept it explicitly instead of letting `set -e` abort here.
set +o pipefail
yes | "$SDKMANAGER" --sdk_root="$SDK" --licenses >/dev/null || true
set -o pipefail
"$SDKMANAGER" --sdk_root="$SDK" \
  "platform-tools" "platforms;android-35" "build-tools;35.0.0" >/dev/null

echo "Android SDK ready at $SDK (JDK: $JAVA_HOME)"
echo "Now run: bash scripts/build-apk.sh"

#!/usr/bin/env bash
# Build the debug APK, install it over the existing app (data kept), make the Dictus keyboard
# the default IME, launch the app and wait until it is usable.
#   launch.sh [--no-build]
# Requires the Pixel lock (lock.sh acquire) — refuses to run without it.
# Last line on success: READY serial=… run=… pid=… version=… apk_sha=…
set -euo pipefail
source "$(dirname "$0")/env.sh"
build=1; [ "${1:-}" = "--no-build" ] && build=0

[ -d "$DICTUS_LOCK" ] || { echo "error: take the Pixel lock first (helpers/lock.sh acquire <tag>)"; exit 1; }
adbs get-state >/dev/null 2>&1 || { echo "error: $DICTUS_SERIAL not connected (adb devices)"; exit 1; }
if adbs shell dumpsys window | grep -qE 'isKeyguardShowing=true|mDreamingLockscreen=true'; then
  echo "error: Pixel is locked. Do not unlock it: release the lock and report."; exit 1
fi

run_id="$(date +%Y%m%d-%H%M%S)-$(git -C "$REPO_ROOT" rev-parse --short HEAD)"
run="$DICTUS_EVIDENCE_ROOT/$run_id"
mkdir -p "$run" "$(dirname "$DICTUS_SESSION_PTR")"
echo "$run" > "$DICTUS_SESSION_PTR"
report "$run" "launch commit=$(git -C "$REPO_ROOT" rev-parse HEAD) branch=$(git -C "$REPO_ROOT" branch --show-current)"

if [ "$build" = 1 ]; then
  (cd "$REPO_ROOT" && git submodule update --init >/dev/null && ./gradlew assembleDebug) > "$run/build.log" 2>&1 \
    || { echo "error: build failed, see $run/build.log"; exit 1; }
fi
[ -f "$DICTUS_APK" ] || { echo "error: no APK at $DICTUS_APK"; exit 1; }
apk_sha="$(sha256sum "$DICTUS_APK" | cut -c1-16)"

# -r keeps the user's data (models, settings, notes). Never uninstall.
adbs install -r "$DICTUS_APK" > "$run/install.log" 2>&1 || { echo "error: install failed, see $run/install.log"; exit 1; }
report "$run" "installed apk_sha=$apk_sha"

# Settings snapshot, compared by cleanup.sh: a run must leave Pierre's settings as it found them.
adbs exec-out run-as "$DICTUS_PKG" cat files/datastore/dictus_prefs.preferences_pb > "$run/prefs-before.pb" 2>/dev/null || true

# Default IME: remember the previous one so cleanup.sh can put it back.
prev_ime="$(adbs shell settings get secure default_input_method | tr -d '\r')"
echo "PREV_IME=$prev_ime" > "$run/run.env"
if [ "$prev_ime" != "$DICTUS_IME" ]; then
  adbs shell ime enable "$DICTUS_IME" >/dev/null
  adbs shell ime set "$DICTUS_IME" >/dev/null
  report "$run" "ime switched from $prev_ime to $DICTUS_IME"
fi

adbs logcat -c || true
adbs shell am start -W -n "$DICTUS_ACTIVITY" > "$run/am-start.log"
# Ready = process alive AND MainActivity resumed, held for 3 s (an app that crashes on start fails here).
pid=""
for i in $(seq 1 20); do
  pid="$(adbs shell pidof "$DICTUS_PKG" | tr -d '\r')"
  if [ -n "$pid" ] && adbs shell dumpsys activity activities | grep -E 'mResumedActivity|topResumedActivity' | grep -q "$DICTUS_ACTIVITY"; then
    sleep 3
    [ "$(adbs shell pidof "$DICTUS_PKG" | tr -d '\r')" = "$pid" ] && break
  fi
  pid=""; sleep 1
done
[ -n "$pid" ] || { echo "error: Dictus not resumed after 20 s (see $run/am-start.log)"; exit 1; }

version="$(adbs shell dumpsys package "$DICTUS_PKG" | grep -m1 versionName | sed 's/.*=//' | tr -d '\r')"
{ echo "SERIAL=$DICTUS_SERIAL"; echo "PID=$pid"; echo "APK_SHA=$apk_sha"; echo "VERSION=$version"; } >> "$run/run.env"
adbs exec-out screencap -p > "$run/00-launch.png"
report "$run" "READY pid=$pid version=$version"
echo "READY serial=$DICTUS_SERIAL run=$run pid=$pid version=$version apk_sha=$apk_sha"

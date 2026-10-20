#!/usr/bin/env bash
# Sourced by every helper: toolchain, device, package, evidence root, lock path, run pointer.
# Override any of these from the environment before calling a helper.
export JAVA_HOME="${JAVA_HOME:-/opt/jdk17}"
export ANDROID_HOME="${ANDROID_HOME:-/opt/android-sdk}"
export PATH="$JAVA_HOME/bin:$ANDROID_HOME/platform-tools:$PATH"

DICTUS_SERIAL="${DICTUS_SERIAL:-99071FFAZ00EBN}"                  # Pixel 4, USB, LineageOS, French
DICTUS_PKG="dev.pivisolutions.dictus"
DICTUS_ACTIVITY="$DICTUS_PKG/.MainActivity"
DICTUS_IME="$DICTUS_PKG/.ime.DictusImeService"
DICTUS_PROOFS="${DICTUS_PROOFS:-/home/pierre/Dev/dictus-proofs}"
DICTUS_EVIDENCE_ROOT="${DICTUS_EVIDENCE_ROOT:-$DICTUS_PROOFS/verify-dictus-android}"
DICTUS_LOCK="$DICTUS_PROOFS/.pixel-lock"
REPO_ROOT="$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)"
DICTUS_APK="$REPO_ROOT/app/build/outputs/apk/debug/app-debug.apk"
# One pointer per worktree, so two sessions never resolve each other's run.
DICTUS_SESSION_PTR="$DICTUS_EVIDENCE_ROOT/sessions/$(basename "$REPO_ROOT")"

adbs() { adb -s "$DICTUS_SERIAL" "$@"; }

# Run directory: $1, else $DICTUS_VERIFY_RUN, else this worktree's pointer.
resolve_run() {
  local run="${1:-${DICTUS_VERIFY_RUN:-}}"
  if [ -z "$run" ] && [ -f "$DICTUS_SESSION_PTR" ]; then run="$(cat "$DICTUS_SESSION_PTR")"; fi
  if [ -z "$run" ] || [ ! -d "$run" ]; then
    echo "error: no run directory (run launch.sh first, or export DICTUS_VERIFY_RUN)" >&2
    return 1
  fi
  echo "$run"
}

report() { echo "$(date -Is) $*" >> "$1/report.txt"; }

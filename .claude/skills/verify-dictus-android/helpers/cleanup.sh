#!/usr/bin/env bash
# Tear down what this run changed, keep the evidence.
#   cleanup.sh [run-dir] [owner-tag]
# Copies dictus.log and the settings (prefs-after.pb, compared with prefs-before.pb) into the run, restores the IME launch.sh replaced (if any), releases the
# Pixel lock if <owner-tag> owns it. Never uninstalls, never clears app data, never kills by name.
# Stop Argent's services for the Pixel separately (MCP stop-all-simulator-servers, devices=[serial]).
set -u
source "$(dirname "$0")/env.sh"
run="$(resolve_run "${1:-}")" || exit 1
tag="${2:-verify-map}"
adbs shell run-as "$DICTUS_PKG" cat files/dictus.log > "$run/dictus.full.log" 2>/dev/null \
  && echo "copied dictus.log ($(wc -l < "$run/dictus.full.log") lines)" || echo "warning: dictus.log not copied"
adbs exec-out run-as "$DICTUS_PKG" cat files/datastore/dictus_prefs.preferences_pb > "$run/prefs-after.pb" 2>/dev/null || true
if [ -s "$run/prefs-before.pb" ]; then
  # Keys and values in order, last transcription excluded (a dictation legitimately changes it).
  kv() { strings -n 1 "$1" | grep -v -e '^last_transcription' | paste -sd' '; }
  if [ "$(kv "$run/prefs-before.pb")" = "$(kv "$run/prefs-after.pb")" ]; then echo "PREFS same"
  else echo "PREFS differ — before: $(kv "$run/prefs-before.pb")"; echo "               after:  $(kv "$run/prefs-after.pb")"; fi
fi
prev="$(grep '^PREV_IME=' "$run/run.env" 2>/dev/null | cut -d= -f2-)"
if [ -n "$prev" ] && [ "$prev" != "$DICTUS_IME" ] && [ "$prev" != "null" ]; then
  adbs shell ime set "$prev" >/dev/null && echo "IME restored to $prev"
fi
"$(dirname "$0")/lock.sh" release "$tag" || true
report "$run" "CLEANUP OK"
echo "CLEANUP OK run=$run files=$(ls "$run" | wc -l)"

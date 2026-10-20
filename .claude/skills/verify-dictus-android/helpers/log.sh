#!/usr/bin/env bash
# Logcat helpers for proofs (Timber DebugTree writes every Dictus log line to logcat in debug builds).
#   log.sh mark                         print the device time to use as a mark
#   log.sh wait '<regex>' [secs] [mark] wait until a Dictus line matching <regex> appears after <mark>
#   log.sh since <mark>                 print every Dictus line since <mark>
set -u
source "$(dirname "$0")/env.sh"
dictus_lines() {
  local pid; pid="$(adbs shell pidof "$DICTUS_PKG" | tr -d '\r')"
  [ -n "$pid" ] || return 0
  adbs logcat -d -v threadtime -T "$1" --pid="$pid" 2>/dev/null
}
case "${1:-}" in
  mark)  adbs shell "date '+%m-%d %H:%M:%S.000'" | tr -d '\r' ;;
  since) dictus_lines "${2:?mark}" ;;
  wait)
    re="${2:?regex}"; secs="${3:-15}"; mark="${4:-$(adbs shell "date '+%m-%d %H:%M:%S.000'" | tr -d '\r')}"
    for _ in $(seq 1 "$secs"); do
      line="$(dictus_lines "$mark" | grep -E "$re" | head -1)"
      if [ -n "$line" ]; then echo "found: $line"; exit 0; fi
      sleep 1
    done
    echo "error: no log line matching /$re/ after $mark within ${secs}s"; exit 1 ;;
  *) echo "usage: log.sh mark | since <mark> | wait '<regex>' [secs] [mark]"; exit 2 ;;
esac

#!/usr/bin/env bash
# Pixel lock shared by every thread that installs or drives on the Pixel.
#   lock.sh acquire <owner-tag>   wait (retry every 60 s, up to 30 min) then take the lock
#   lock.sh release <owner-tag>   release it, only if <owner-tag> owns it
#   lock.sh status                print the owner, or "free"
set -u
source "$(dirname "$0")/env.sh"
cmd="${1:-status}"; tag="${2:-verify-map}"
mkdir -p "$DICTUS_PROOFS"
case "$cmd" in
  acquire)
    if [ "$(cut -d' ' -f1 "$DICTUS_LOCK/owner" 2>/dev/null)" = "$tag" ]; then
      echo "LOCK ACQUIRED (already held by $tag since $(cut -d' ' -f2 "$DICTUS_LOCK/owner"))"; exit 0
    fi
    for i in $(seq 0 30); do
      if mkdir "$DICTUS_LOCK" 2>/dev/null; then
        echo "$tag $(date -Is)" > "$DICTUS_LOCK/owner"
        echo "LOCK ACQUIRED $(cat "$DICTUS_LOCK/owner")"; exit 0
      fi
      echo "lock held by: $(cat "$DICTUS_LOCK/owner" 2>/dev/null || echo '?') (attempt $i/30, retry in 60 s)"
      [ "$i" -lt 30 ] && sleep 60
    done
    echo "LOCK TIMEOUT after 30 min"; exit 1 ;;
  release)
    if [ ! -d "$DICTUS_LOCK" ]; then echo "LOCK already free"; exit 0; fi
    owner="$(cut -d' ' -f1 "$DICTUS_LOCK/owner" 2>/dev/null || true)"
    if [ "$owner" != "$tag" ]; then echo "LOCK owned by '$owner', not '$tag': left in place"; exit 1; fi
    rm "$DICTUS_LOCK/owner" && rmdir "$DICTUS_LOCK" && echo "LOCK RELEASED" ;;
  status)
    if [ -d "$DICTUS_LOCK" ]; then echo "held: $(cat "$DICTUS_LOCK/owner" 2>/dev/null)"; else echo "free"; fi ;;
  *) echo "usage: lock.sh acquire|release|status [owner-tag]"; exit 2 ;;
esac

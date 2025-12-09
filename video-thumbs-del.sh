#!/usr/bin/env bash
set -u -o pipefail

ROOT="/volume1/video"

find "$ROOT" -type f -name 'SYNOVIDEO_VIDEO_SCREENSHOT*' -path '*/@eaDir/*' -print0 |
#find "$ROOT" -type f -name '*.log' -path '*/@eaDir/*' -print0 |
while IFS= read -r -d '' f; do
  echo "Deleting: $f"
  rm -f -- "$f" || echo "Error delete: $f" >&2
done


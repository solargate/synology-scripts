#!/usr/bin/env bash
# Script for deleting video thumbnails from folders in the Synology Media Server
# The script deletes the video thumbnails from the specified directory and all subdirectories
set -u -o pipefail

# Root directory for video files
ROOT="/volume1/video"

find "$ROOT" -type f -name 'SYNOVIDEO_VIDEO_SCREENSHOT*' -path '*/@eaDir/*' -print0 |
while IFS= read -r -d '' f; do
  echo "Deleting: $f"
  rm -f -- "$f" || echo "Error delete: $f" >&2
done

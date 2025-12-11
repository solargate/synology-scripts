#!/usr/bin/env bash
# Script for generating video thumbnails for Synology Media Server using FFMPEG
# The script will find all video files in the specified root directory and subdirectories and generate thumbnails for them
set -u -o pipefail

# Root directory for video files
ROOT="/volume1/video"

# FFMPEG executable path
FFMPEG="ffmpeg7"

find "$ROOT" -type f \( -iname '*.mp4' -o -iname '*.avi' -o -iname '*.mkv' \) -print0 |
while IFS= read -r -d '' file; do
  dir=$(dirname "$file")
  base=$(basename "$file")
  shot_dir="$dir/@eaDir/$base"
  shot="$shot_dir/SYNOVIDEO_VIDEO_SCREENSHOT.jpg"

  if [[ -f "$shot" ]]; then
    echo "Exists: $shot"
    continue
  fi

  mkdir -p "$shot_dir"
  echo "Generating: $shot"
  if ! "$FFMPEG" -hide_banner -loglevel error -nostats -nostdin -i "$file" -ss 600 -vframes 1 -f mjpeg -y "$shot"; then
    echo "Error for file: $file" >&2
  fi
done

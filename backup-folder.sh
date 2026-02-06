#!/usr/bin/env bash
set -euo pipefail

# Configuration
SRC="/AAA"
DEST_BASE="/BBB"
PREFIX="AAA"    # prefix for backup directory names
KEEP=10         # how many latest backups to keep

# Preconditions
if [[ ! -d "$SRC" ]]; then
  echo "Source directory not found: $SRC" >&2
  exit 1
fi
mkdir -p "$DEST_BASE"

DATE="$(date +'%Y-%m-%d')"

# Determine the next sequential number for today's date
last_num="$(
  find "$DEST_BASE" -maxdepth 1 -type d -name "${PREFIX}-${DATE}-*" -printf "%f\n" 2>/dev/null \
    | sed -E 's/.*-([0-9]+)$/\1/' \
    | sort -n | tail -n1
)"
if [[ -z "${last_num:-}" ]]; then
  NEXT=1
else
  NEXT=$(( last_num + 1 ))
fi

TARGET="${DEST_BASE}/${PREFIX}-${DATE}-${NEXT}"
mkdir -p "$TARGET"

# Copy contents from SRC to TARGET
cp -a "$SRC"/. "$TARGET"/

# Keep only the $KEEP most recent backups matching PREFIX-YYYY-MM-DD-NUM
mapfile -t backups < <(
  find "$DEST_BASE" -maxdepth 1 -type d -name "${PREFIX}-????-??-??-*" -printf "%p\n" 2>/dev/null \
    | sort -V
)
count=${#backups[@]}
if (( count > KEEP )); then
  to_delete=$(( count - KEEP ))
  for d in "${backups[@]:0:to_delete}"; do
    rm -rf -- "$d"
  done
fi

echo "Backup created: $TARGET"


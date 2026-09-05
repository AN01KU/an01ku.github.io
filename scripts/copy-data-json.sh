#!/usr/bin/env bash
# Copy a shared-config data/*.json file into resources/.
# Usage: copy-data-json.sh <filename> <shared-config-dir> [output.json]
set -euo pipefail

FILENAME="${1:?Usage: copy-data-json.sh <filename> <shared-config-dir> [output.json]}"
CONFIG_DIR="${2:?Usage: copy-data-json.sh <filename> <shared-config-dir> [output.json]}"
INPUT="${CONFIG_DIR}/data/${FILENAME}"
OUTPUT="${3:-resources/${FILENAME}}"

if ! command -v jq >/dev/null 2>&1; then
  echo "jq is required" >&2
  exit 1
fi

if [[ ! -f "$INPUT" ]]; then
  echo "Data file not found: $INPUT" >&2
  exit 1
fi

mkdir -p "$(dirname "$OUTPUT")"
jq '.' "$INPUT" > "$OUTPUT"

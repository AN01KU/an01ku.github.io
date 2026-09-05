#!/usr/bin/env bash
# Copy education data from shared-config into resources/education.json.
# Usage: build-education.sh <shared-config-dir> [output.json]
set -euo pipefail

CONFIG_DIR="${1:?Usage: build-education.sh <shared-config-dir> [output.json]}"
INPUT="${CONFIG_DIR}/data/education.json"
OUTPUT="${2:-resources/education.json}"

if ! command -v jq >/dev/null 2>&1; then
  echo "jq is required" >&2
  exit 1
fi

if [[ ! -f "$INPUT" ]]; then
  echo "Education file not found: $INPUT" >&2
  exit 1
fi

mkdir -p "$(dirname "$OUTPUT")"
jq '.' "$INPUT" > "$OUTPUT"
cat "$OUTPUT"

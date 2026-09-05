#!/usr/bin/env bash
# Copy certifications data from shared-config into resources/certifications.json.
# Usage: build-certifications.sh <shared-config-dir> [output.json]
set -euo pipefail

CONFIG_DIR="${1:?Usage: build-certifications.sh <shared-config-dir> [output.json]}"
INPUT="${CONFIG_DIR}/data/certifications.json"
OUTPUT="${2:-resources/certifications.json}"

if ! command -v jq >/dev/null 2>&1; then
  echo "jq is required" >&2
  exit 1
fi

if [[ ! -f "$INPUT" ]]; then
  echo "Certifications file not found: $INPUT" >&2
  exit 1
fi

mkdir -p "$(dirname "$OUTPUT")"
jq '.' "$INPUT" > "$OUTPUT"
cat "$OUTPUT"

#!/usr/bin/env bash
# Copy publications from shared-config into resources/publications.json.
# Usage: build-publications.sh <shared-config-dir> [output.json]
set -euo pipefail

CONFIG_DIR="${1:?Usage: build-publications.sh <shared-config-dir> [output.json]}"
INPUT="${CONFIG_DIR}/data/publications.json"
OUTPUT="${2:-resources/publications.json}"

if ! command -v jq >/dev/null 2>&1; then
  echo "jq is required" >&2
  exit 1
fi

if [[ ! -f "$INPUT" ]]; then
  echo "Publications file not found: $INPUT" >&2
  exit 1
fi

mkdir -p "$(dirname "$OUTPUT")"
jq '.' "$INPUT" > "$OUTPUT"
cat "$OUTPUT"

#!/usr/bin/env bash
# Build resources/projects.json from shared-config (portfolio-visible projects only).
# Usage: build-projects.sh <shared-config-dir> [output.json]
set -euo pipefail

CONFIG_DIR="${1:?Usage: build-projects.sh <shared-config-dir> [output.json]}"
INPUT="${CONFIG_DIR}/data/projects.json"
OUTPUT="${2:-resources/projects.json}"

if ! command -v jq >/dev/null 2>&1; then
  echo "jq is required" >&2
  exit 1
fi

if [[ ! -f "$INPUT" ]]; then
  echo "Projects file not found: $INPUT" >&2
  exit 1
fi

mkdir -p "$(dirname "$OUTPUT")"

jq '{
  version: .version,
  updatedAt: .updatedAt,
  projects: [
    .projects[]
    | select((.platforms.portfolio // true) == true)
  ]
}' "$INPUT" > "$OUTPUT"

cat "$OUTPUT"

#!/usr/bin/env bash
# Filter projects.json for portfolio-visible entries.
# Usage: filter-portfolio-projects.sh <input.json> [output.json]
set -euo pipefail

INPUT="${1:?Usage: filter-portfolio-projects.sh <input.json> [output.json]}"
OUTPUT="${2:-resources/projects.json}"

if ! command -v jq >/dev/null 2>&1; then
  echo "jq is required" >&2
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

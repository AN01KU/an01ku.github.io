#!/usr/bin/env bash
set -euo pipefail

CONFIG="${1:?Usage: check-homelab.sh <homelab.json> [output.json]}"
OUTPUT="${2:-resources/homelab-status.json}"
NOW="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

if ! command -v jq >/dev/null 2>&1; then
  echo "jq is required" >&2
  exit 1
fi

check_url() {
  local url="$1"
  local code

  code="$(curl -s -o /dev/null -w "%{http_code}" --max-time 15 -L "$url" 2>/dev/null || echo "000")"

  case "$code" in
    2??|3??|401|403) echo "online|$code" ;;
    *) echo "offline|$code" ;;
  esac
}

display_host() {
  local url="$1"
  echo "$url" | sed -E 's|^https?://([^/]+).*|\1|'
}

mkdir -p "$(dirname "$OUTPUT")"

HOST="$(jq -r '.host // ""' "$CONFIG")"
DOMAIN="$(jq -r '.domain // ""' "$CONFIG")"
SERVICE_COUNT="$(jq '.services | length' "$CONFIG")"

{
  printf '{\n'
  printf '  "updatedAt": "%s",\n' "$NOW"
  printf '  "host": "%s",\n' "$HOST"
  printf '  "domain": "%s",\n' "$DOMAIN"
  printf '  "services": {\n'

  for ((i = 0; i < SERVICE_COUNT; i++)); do
    id="$(jq -r ".services[$i].id" "$CONFIG")"
    name="$(jq -r ".services[$i].name" "$CONFIG")"
    url="$(jq -r ".services[$i].url" "$CONFIG")"
    tag="$(jq -r ".services[$i].tag // \"\"" "$CONFIG")"
    description="$(jq -r ".services[$i].description // \"\"" "$CONFIG")"
    host_label="$(display_host "$url")"

    IFS='|' read -r status code <<< "$(check_url "$url")"
    http_code=$((10#$code))

    if ((i > 0)); then
      printf ',\n'
    fi

    printf '    "%s": {\n' "$id"
    printf '      "name": %s,\n' "$(jq -n --arg v "$name" '$v')"
    printf '      "url": %s,\n' "$(jq -n --arg v "$url" '$v')"
    printf '      "tag": %s,\n' "$(jq -n --arg v "$tag" '$v')"
    printf '      "description": %s,\n' "$(jq -n --arg v "$description" '$v')"
    printf '      "displayHost": %s,\n' "$(jq -n --arg v "$host_label" '$v')"
    printf '      "status": "%s",\n' "$status"
    printf '      "httpCode": %s,\n' "$http_code"
    printf '      "checkedAt": "%s"\n' "$NOW"
    printf '    }'
  done

  printf '\n  }\n}\n'
} > "$OUTPUT"

cat "$OUTPUT"

#!/usr/bin/env bash
set -euo pipefail

OUTPUT="${1:-resources/homelab-status.json}"
NOW="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

check_url() {
  local url="$1"
  local code

  code="$(curl -s -o /dev/null -w "%{http_code}" --max-time 15 -L "$url" 2>/dev/null || echo "000")"

  case "$code" in
    2??|3??|401|403) echo "online|$code" ;;
    *) echo "offline|$code" ;;
  esac
}

declare -a SERVICES=(
  "homeassistant|https://homeassistant.ankushganesh.cloud|Home Assistant"
  "beszel|https://beszel.ankushganesh.cloud|Beszel"
  "hermes|https://hermes.ankushganesh.cloud|Hermes"
  "pihole|https://pihole.ankushganesh.cloud/admin/login|Pi-hole"
  "n8n|https://n8n.ankushganesh.cloud|n8n"
)

mkdir -p "$(dirname "$OUTPUT")"

{
  printf '{\n  "updatedAt": "%s",\n  "services": {\n' "$NOW"

  first=true
  for entry in "${SERVICES[@]}"; do
    IFS='|' read -r id url name <<< "$entry"
    IFS='|' read -r status code <<< "$(check_url "$url")"
    http_code=$((10#$code))

    if [ "$first" = true ]; then
      first=false
    else
      printf ',\n'
    fi

    printf '    "%s": {\n' "$id"
    printf '      "name": "%s",\n' "$name"
    printf '      "url": "%s",\n' "$url"
    printf '      "status": "%s",\n' "$status"
    printf '      "httpCode": %s,\n' "$http_code"
    printf '      "checkedAt": "%s"\n' "$NOW"
    printf '    }'
  done

  printf '\n  }\n}\n'
} > "$OUTPUT"

cat "$OUTPUT"

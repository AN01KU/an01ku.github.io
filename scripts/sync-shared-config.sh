#!/usr/bin/env bash
# Run homelab check + site-config build using a local shared-config checkout.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SHARED_CONFIG="${SHARED_CONFIG_DIR:-${ROOT}/../shared-config}"
HOMELAB_CONFIG="${SHARED_CONFIG}/data/homelab.json"

if [[ ! -f "$HOMELAB_CONFIG" ]]; then
  echo "shared-config not found at: $SHARED_CONFIG" >&2
  echo "Clone it next to this repo or set SHARED_CONFIG_DIR." >&2
  exit 1
fi

bash "${ROOT}/scripts/check-homelab.sh" "$HOMELAB_CONFIG" "${ROOT}/resources/homelab-status.json"
bash "${ROOT}/scripts/build-site-config.sh" "$SHARED_CONFIG" "${ROOT}/resources/site-config.json"
bash "${ROOT}/scripts/build-projects.sh" "$SHARED_CONFIG" "${ROOT}/resources/projects.json"
bash "${ROOT}/scripts/build-publications.sh" "$SHARED_CONFIG" "${ROOT}/resources/publications.json"
bash "${ROOT}/scripts/build-education.sh" "$SHARED_CONFIG" "${ROOT}/resources/education.json"
bash "${ROOT}/scripts/build-certifications.sh" "$SHARED_CONFIG" "${ROOT}/resources/certifications.json"

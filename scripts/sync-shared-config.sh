#!/usr/bin/env bash
# Build resources/ from a local shared-config checkout.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SHARED_CONFIG="${SHARED_CONFIG_DIR:-${ROOT}/../shared-config}"

if [[ ! -d "${SHARED_CONFIG}/data" || ! -f "${SHARED_CONFIG}/profile.env" ]]; then
  echo "shared-config not found at: ${SHARED_CONFIG}" >&2
  echo "Clone it next to this repo or set SHARED_CONFIG_DIR." >&2
  exit 1
fi

bash "${ROOT}/scripts/prepare-resources.sh" "$SHARED_CONFIG"

#!/usr/bin/env bash
# Build all resources/*.json from a shared-config checkout.
# Usage: prepare-resources.sh <shared-config-dir>
set -euo pipefail

CONFIG_DIR="${1:?Usage: prepare-resources.sh <shared-config-dir>}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

bash "${ROOT}/scripts/build-site-config.sh" "$CONFIG_DIR" "${ROOT}/resources/site-config.json"
bash "${ROOT}/scripts/filter-portfolio-projects.sh" \
  "${CONFIG_DIR}/data/projects.json" "${ROOT}/resources/projects.json"
bash "${ROOT}/scripts/copy-data-json.sh" publications.json "$CONFIG_DIR" "${ROOT}/resources/publications.json"
bash "${ROOT}/scripts/copy-data-json.sh" education.json "$CONFIG_DIR" "${ROOT}/resources/education.json"
bash "${ROOT}/scripts/copy-data-json.sh" certifications.json "$CONFIG_DIR" "${ROOT}/resources/certifications.json"
bash "${ROOT}/scripts/check-homelab.sh" \
  "${CONFIG_DIR}/data/homelab.json" "${ROOT}/resources/homelab-status.json"

echo "Prepared resources/ from ${CONFIG_DIR}"

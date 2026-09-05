#!/usr/bin/env bash
# Build site-config.json from shared-config env files.
# Usage: build-site-config.sh <shared-config-dir> [output.json]
set -euo pipefail

CONFIG_DIR="${1:?Usage: build-site-config.sh <shared-config-dir> [output.json]}"
OUTPUT="${2:-resources/site-config.json}"

if ! command -v jq >/dev/null 2>&1; then
  echo "jq is required" >&2
  exit 1
fi

load_env_file() {
  local file="$1"
  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ "$line" =~ ^[[:space:]]*# ]] && continue
    [[ -z "${line//[[:space:]]/}" ]] && continue
    if [[ "$line" =~ ^([A-Za-z_][A-Za-z0-9_]*)=(.*)$ ]]; then
      local key="${BASH_REMATCH[1]}"
      local val="${BASH_REMATCH[2]}"
      val="${val#"${val%%[![:space:]]*}"}"
      val="${val%"${val##*[![:space:]]}"}"
      if [[ "$val" =~ ^\"(.*)\"$ ]]; then val="${BASH_REMATCH[1]}"; fi
      if [[ "$val" =~ ^\'(.*)\'$ ]]; then val="${BASH_REMATCH[1]}"; fi
      export "$key=$val"
    fi
  done < "$file"
}

load_env_file "${CONFIG_DIR}/profile.env"
load_env_file "${CONFIG_DIR}/social.env"

mkdir -p "$(dirname "$OUTPUT")"

jq -n \
  --arg fullName "${FULL_NAME:-}" \
  --arg displayName "${DISPLAY_NAME:-}" \
  --arg title "${TITLE:-}" \
  --arg company "${COMPANY:-}" \
  --arg companyUrl "${COMPANY_URL:-}" \
  --arg email "${EMAIL:-${EMAIL_PERSONAL:-}}" \
  --arg phone "${PHONE:-}" \
  --arg phoneDisplay "${PHONE_DISPLAY:-}" \
  --arg location "${LOCATION:-}" \
  --arg githubUsername "${GITHUB_USERNAME:-}" \
  --arg githubUrl "${GITHUB_URL:-}" \
  --arg linkedinUrl "${LINKEDIN_URL:-}" \
  --arg leetcodeUrl "${LEETCODE_URL:-}" \
  --arg portfolioUrl "${PORTFOLIO_URL:-}" \
  '{
    updatedAt: (now | strftime("%Y-%m-%dT%H:%M:%SZ")),
    profile: {
      fullName: $fullName,
      displayName: $displayName,
      title: $title,
      company: $company,
      companyUrl: $companyUrl,
      email: $email,
      phone: $phone,
      phoneDisplay: $phoneDisplay,
      location: $location
    },
    social: {
      githubUsername: $githubUsername,
      githubUrl: $githubUrl,
      linkedinUrl: $linkedinUrl,
      leetcodeUrl: $leetcodeUrl,
      portfolioUrl: $portfolioUrl
    }
  }' > "$OUTPUT"

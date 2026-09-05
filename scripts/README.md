# Portfolio site — generated resources

JSON under `resources/` is **not committed** to this repo. CI checks out private [shared-config](https://github.com/AN01KU/shared-config), builds the JSON files, and deploys them via GitHub Pages — nothing sensitive is stored in git.

## What gets generated

| File | Source |
|------|--------|
| `site-config.json` | `profile.env` + `social.env` (includes `updatedAt` for footer) |
| `projects.json` | `data/projects.json` + portfolio filter (`platforms.portfolio`) |
| `publications.json` | `data/publications.json` |
| `education.json` | `data/education.json` |
| `certifications.json` | `data/certifications.json` |
| `homelab-status.json` | live health check from `data/homelab.json` |

Static assets (`favicon.svg`, resume PDF, pc-setup photos) stay in this repo.

## Local refresh

Clone `shared-config` next to this repo, then:

```bash
bash scripts/sync-shared-config.sh

# Or set a custom path
SHARED_CONFIG_DIR=/path/to/shared-config bash scripts/sync-shared-config.sh
```

Requires `bash` and `jq`.

## GitHub setup

1. **Pages source**: Settings → Pages → Build and deployment → **GitHub Actions**
2. **Secret** `SHARED_CONFIG_TOKEN`: fine-grained PAT with **Contents: Read** on `shared-config`

## Deploy schedules

| Workflow | Schedule | Purpose |
|----------|----------|---------|
| **Deploy Site** | Every 12 hours, push to `main`, manual | Full site redeploy |
| **Refresh Homelab Status** | Every hour, manual | Homelab health checks + redeploy |

Both workflows rebuild all JSON and publish to GitHub Pages. Footer **Last updated** comes from `site-config.json` → `updatedAt`, set at build time.

After a `shared-config` change, re-run **Deploy Site** manually.

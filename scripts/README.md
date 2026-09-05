# Portfolio site — generated files

`resources/site-config.json`, `resources/projects.json`, `resources/publications.json`, `resources/education.json`, and `resources/certifications.json` are generated from [shared-config](https://github.com/AN01KU/shared-config) by GitHub Actions (`.github/workflows/sync-shared-config.yml`).

`resources/homelab-status.json` is also generated from `shared-config/data/homelab.json`.

## Local refresh

With `shared-config` cloned next to this repo:

```bash
# Git Bash / Linux / macOS
bash scripts/sync-shared-config.sh

# Or set a custom path
SHARED_CONFIG_DIR=/path/to/shared-config bash scripts/sync-shared-config.sh
```

Requires `bash` and `jq`.

## What lives in shared-config

| File | Used for |
|------|----------|
| `profile.env` | Name, `TITLE`, `COMPANY`, `EMAIL`, phone, location |
| `social.env` | GitHub, LinkedIn, LeetCode links |
| `data/homelab.json` | Homelab service list + card copy |
| `data/projects.json` | Project catalog (links, tags, descriptions) |
| `data/publications.json` | Publications |
| `data/education.json` | Education |
| `data/certifications.json` | Certifications |

Edit those in `shared-config`; this repo picks them up on the next workflow run (every 10 min or manual dispatch).

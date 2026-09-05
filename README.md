# an01ku.github.io

Personal portfolio site hosted on GitHub Pages.

Live site: https://an01ku.github.io/

## What lives here

- Static site files: `index.html`, `styles.css`, images, resume PDF
- Build scripts under `scripts/`
- GitHub Actions workflows under `.github/workflows/`

Profile, projects, publications, education, certifications, and homelab service list are **not** stored in this repo. They come from the private [shared-config](https://github.com/AN01KU/shared-config) repo and are built at deploy time.

Experience, skills, and hobbies remain in `index.html` for now.

## Deployment

Pages is deployed via GitHub Actions (not from a branch directly).

On each deploy, CI checks out `shared-config`, generates JSON under `resources/`, runs homelab health checks, and publishes the site. Generated JSON is gitignored and never committed.

| Workflow | When it runs |
|----------|--------------|
| Deploy Site | Push to `main`, every 12 hours, manual |
| Refresh Homelab Status | Every hour, manual |

Manual deploy: **Actions → Deploy Site → Run workflow**

Requires repo secret `SHARED_CONFIG_TOKEN` (fine-grained PAT with Contents read on `shared-config`).

## Local development

Clone `shared-config` next to this repo, then:

```bash
bash scripts/sync-shared-config.sh
```

See [scripts/README.md](scripts/README.md) for details on generated files and setup.

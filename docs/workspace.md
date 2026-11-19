# How Cursor, Codex, and LAB should share this project

## One research home

| Place | Role |
| --- | --- |
| Mac `/Users/emmalin/EMG_Project_2` | Original EMG experiments (complete tree, including pre-5.4) |
| Mac Codex folder `Documents/Codex/2026-11-19/referenced-chatgpt-conversation-this-is-an/` | Snapshot of completed Codex work (likely Section 5.4 outputs) |
| This GitHub repo `Emma` | LAB-connected hub: docs, `.gitignore`, layout. Not a dump of participant data. |
| Notion `Lab → EMG Algorithm Development & Optimization` | Canonical experiment writeups (through 5.4 and later) |

Cloud LAB agents **cannot read the Mac paths**. Consolidation of Codex → `incoming/section-5.4-from-codex-20261119/` must happen on the Mac or after those folders are attached to this Project. Copy only; never move; never overwrite earlier experiments.

## Preserve Section 5.4

Treat Section 5.4 Fatigue Detection as completed history. New work goes in new dated experiment logs. Do not re-tune the same detector as if it were a first result.

## Future biomechanics (beyond EMG fatigue)

Expected later folders (create when needed, do not pre-fill fake results):

- `src/activation/` — onset / activation detection
- `src/kinematics/` — movement / IMU / mocap pipelines
- `src/fatigue/` — fatigue indices (after 5.4 archive is copied)
- `docs/protocols/` — ethics, MVC, electrode placement

## GitHub privacy (when a private remote exists)

1. Repo must be **private**.
2. Commit `.gitignore` before any `git add`.
3. First push: README + `.gitignore` + docs only.
4. Grant [Cursor GitHub App](https://github.com/apps/cursor/installations/new) access to that repo (selected-repo installs often include only `Emma`).
5. Add the repo in the LAB environment: https://cursor.com/dashboard/cloud-agents/environments/e/6838e241-e3ea-11f1-9535-02900022bdcd
6. Review `incoming/` before tracking; keep `data/raw/` gitignored forever.

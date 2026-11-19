#!/usr/bin/env bash
# Copy Codex 5.4 outputs into EMG_Project_2 without moving or overwriting originals.
# Run on Emma's Mac only. Do not run experiments. Do not git push. Do not install packages.
set -euo pipefail

SRC_PROJECT="/Users/emmalin/EMG_Project_2"
SRC_CODEX="/Users/emmalin/Documents/Codex/2026-11-19/referenced-chatgpt-conversation-this-is-an"
DEST="${SRC_PROJECT}/incoming/section-5.4-from-codex-20261119"
STAMP="$(date '+%Y-%m-%d %H:%M:%S %Z')"

die() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

[[ "$(uname -s)" == Darwin ]] || die "This script must run on the Mac that holds the two folders (found $(uname -s))."
[[ -d "$SRC_PROJECT" ]] || die "Missing original project: $SRC_PROJECT"
[[ -d "$SRC_CODEX" ]] || die "Missing Codex outputs: $SRC_CODEX"
[[ ! -e "$DEST" ]] || die "Destination already exists (refusing to overwrite): $DEST"

command -v rsync >/dev/null || die "rsync is required"
command -v shasum >/dev/null || die "shasum is required"

mkdir -p "${SRC_PROJECT}/incoming"
# Copy only. Never --delete. Never write back to SRC_CODEX or other project files.
rsync -a --human-readable --info=stats2 "${SRC_CODEX%/}/" "${DEST}/"

python3 - "$SRC_PROJECT" "$SRC_CODEX" "$DEST" "$STAMP" <<'PY'
import hashlib, os, sys, json
from pathlib import Path

project, src, dest, stamp = map(Path, sys.argv[1:5])
src, dest, project = src.resolve(), dest.resolve(), project.resolve()

SKIP_DIR_NAMES = {".git", ".venv", "node_modules", "__pycache__"}

def files_under(root: Path):
    out = []
    for dirpath, dirnames, filenames in os.walk(root):
        dirnames[:] = [d for d in dirnames if d not in SKIP_DIR_NAMES]
        for name in filenames:
            p = Path(dirpath) / name
            if p.is_symlink() or not p.is_file():
                continue
            rel = p.relative_to(root).as_posix()
            h = hashlib.sha256()
            with p.open("rb") as f:
                for chunk in iter(lambda: f.read(1024 * 1024), b""):
                    h.update(chunk)
            out.append((rel, p.stat().st_size, h.hexdigest()))
    out.sort()
    return out

src_files = files_under(src)
dest_files = files_under(dest)
src_map = {rel: (size, digest) for rel, size, digest in src_files}
dest_map = {rel: (size, digest) for rel, size, digest in dest_files}

missing = [rel for rel, _, _ in src_files if rel not in dest_map]
mismatch = [
    rel for rel, size, digest in src_files
    if rel in dest_map and dest_map[rel] != (size, digest)
]
extra = [rel for rel, _, _ in dest_files if rel not in src_map]

keywords = ("5.4", "54", "fatigue", "fatig", "mnf", "mdf", "semg", "emg")
likely_54 = [
    rel for rel, _, _ in dest_files
    if any(k in rel.lower() for k in keywords)
]

code_ext = {".py", ".ipynb", ".r", ".m", ".jl", ".sh"}
data_ext = {".csv", ".tsv", ".txt", ".edf", ".mat", ".h5", ".hdf5", ".npy", ".npz", ".json", ".pkl", ".pickle", ".wav", ".bin"}
fig_ext = {".png", ".jpg", ".jpeg", ".svg", ".pdf", ".tif", ".tiff", ".html"}
report_ext = {".md", ".docx", ".pptx", ".tex", ".html", ".pdf"}

def classify(rel: str) -> str:
    ext = Path(rel).suffix.lower()
    name = Path(rel).name.lower()
    if ext in code_ext or "/scripts/" in rel.lower() or "/src/" in rel.lower():
        return "script"
    if ext in fig_ext and "report" not in name:
        return "figure"
    if ext in report_ext:
        return "report"
    if ext in data_ext:
        return "dataset"
    return "other"

buckets = {"script": [], "dataset": [], "figure": [], "report": [], "other": []}
for rel, size, digest in dest_files:
    buckets[classify(rel)].append(rel)

# Name collisions with the rest of EMG_Project_2 (not including dest itself)
collisions = []
dest_prefix = dest.as_posix() + "/"
for dirpath, dirnames, filenames in os.walk(project):
    dirnames[:] = [d for d in dirnames if d not in SKIP_DIR_NAMES]
    base = Path(dirpath)
    if base.as_posix() == dest.as_posix() or base.as_posix().startswith(dest_prefix):
        continue
    for name in filenames:
        p = base / name
        if not p.is_file():
            continue
        rel_project = p.relative_to(project).as_posix()
        if name in {Path(r).name for r in dest_map}:
            collisions.append({"in_project": rel_project, "basename": name})

manifest_lines = [f"{digest}  {size}  {rel}" for rel, size, digest in dest_files]
(dest / "COPY_MANIFEST.sha256").write_text("\n".join(manifest_lines) + ("\n" if manifest_lines else ""), encoding="utf-8")

copy_ok = not missing and not mismatch
report = f"""# Codex → EMG_Project_2 copy report

- Timestamp: {stamp}
- Source (left untouched): `{src}`
- Original project (left in place except new incoming folder): `{project}`
- Destination (new copy only): `{dest}`
- Files copied: {len(dest_files)}
- Byte-identical to source: {"YES" if copy_ok else "NO — see missing/mismatch"}
- Source files missing at destination: {len(missing)}
- Checksum mismatches: {len(mismatch)}
- Extra files at destination: {len(extra)}

## Likely Section 5.4 / fatigue filenames (name heuristic only)

This list is **not** a verified experiment map. It only matches path names containing 5.4 / fatigue / MNF / MDF / sEMG.

"""
if likely_54:
    report += "\n".join(f"- `{r}`" for r in likely_54) + "\n"
else:
    report += "_No filenames matched the heuristic. Inspect the copied tree and Notion Section 5.4._\n"

report += "\n## Copied tree by type\n"
for key in ("script", "dataset", "figure", "report", "other"):
    report += f"\n### {key} ({len(buckets[key])})\n"
    if buckets[key]:
        report += "\n".join(f"- `{r}`" for r in buckets[key]) + "\n"
    else:
        report += "_none_\n"

report += "\n## Basename collisions with the rest of EMG_Project_2\n"
report += "Same filename exists outside `incoming/`. Contents were **not** overwritten. Review before merging trees.\n\n"
if collisions:
    shown = collisions[:200]
    for c in shown:
        report += f"- `{c['basename']}` also at `{c['in_project']}`\n"
    if len(collisions) > 200:
        report += f"- … {len(collisions) - 200} more\n"
else:
    report += "_none found_\n"

if missing:
    report += "\n## Missing from copy\n" + "\n".join(f"- `{r}`" for r in missing) + "\n"
if mismatch:
    report += "\n## Checksum mismatch\n" + "\n".join(f"- `{r}`" for r in mismatch) + "\n"

(dest / "COPY_REPORT.md").write_text(report, encoding="utf-8")
summary = {
    "copy_ok": copy_ok,
    "n_src": len(src_files),
    "n_dest": len(dest_files),
    "n_missing": len(missing),
    "n_mismatch": len(mismatch),
    "n_collisions": len(collisions),
    "n_likely_54": len(likely_54),
}
print(json.dumps(summary, indent=2))
print(f"Wrote {dest / 'COPY_REPORT.md'}")
print(f"Wrote {dest / 'COPY_MANIFEST.sha256'}")
if not copy_ok:
    sys.exit(2)
PY

echo "Copy finished. Originals were not moved. Do not git push from this script."
echo "Read: ${DEST}/COPY_REPORT.md"

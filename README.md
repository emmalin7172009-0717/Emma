# NTU ME Laboratory — biomechanics research hub

Long-term workspace for Emma Lin, National Taiwan University, Mechanical Engineering Laboratory.

**Current thread:** surface EMG (sEMG), muscle activation, movement analysis, muscle fatigue.  
**Not a limit:** this repository is the Cursor LAB hub for the whole biomechanics line of work, not a single Section 5.4 dump.

**目前工作：** 肌電、肌肉啟動、動作分析、肌疲勞。這是實驗室的長期研究倉，不是只放 5.4 的資料夾。

## What is in Git vs what stays on the Mac

| On GitHub (this repo, when private or after review) | On the Mac only (gitignored) |
| --- | --- |
| Scripts, notebooks without embedded recordings | Raw sEMG / instrument files (`.edf`, `.mat`, `.h5`, …) |
| Experiment notes in Notion-compatible Markdown | Participant identifiers, consent scans |
| Non-identifiable figures you choose to commit | `data/raw/`, `data/participants/` |
| Environment files (`requirements.txt`, later) | Codex export trees until reviewed |

**Do not commit participant data.** If a file could identify a person, it stays local.

## Local research trees (not mounted on Cursor LAB cloud)

These paths exist on Emma’s Mac. Cloud agents cannot see them until the folders are added to this Project or the files are copied here.

- Original project: `/Users/emmalin/EMG_Project_2`
- Codex outputs (2026-11-19): `/Users/emmalin/Documents/Codex/2026-11-19/referenced-chatgpt-conversation-this-is-an/`

Completed work through **Section 5.4 Fatigue Detection** in Notion *EMG Algorithm Development & Optimization* is **history**. Do not duplicate it. Do not invent results that are not in those files.

Safe landing zone for a Codex snapshot (copy, never overwrite the rest of the tree):

`incoming/section-5.4-from-codex-20261119/`

## Layout

```
docs/          Experiment templates (Notion-compatible) and workspace notes
src/           Algorithms and pipelines (to be filled from the Mac trees)
notebooks/     Exploratory analysis
results/       Figures/tables that are not identifiable
incoming/      Frozen copies from Codex or other tools — do not edit in place
data/raw/      Gitignored raw recordings
data/participants/  Gitignored human-subjects files
```

## Documentation style

Match existing Notion experiment pages:

1. Objectives  
2. Settings  
3. Commands  
4. Results (tables; synthetic vs real; subjective exertion vs objective fatigue)  
5. Analysis  
6. Conclusions  
7. Next steps  

English headings; concise Chinese where it helps. Never treat an experiment as successful unless it was actually run. Distinguish exploratory vs held-out validation.

## Tools

Cursor Pro, Cursor LAB, Codex, Python, GitHub, Notion. Prefer these. New tools only if they clearly help the science.

## Connecting Cursor LAB

This public repo `emmalin7172009-0717/Emma` is what LAB can already clone. A **private** research remote (intended name `EMG_Project_2`) could not be created automatically (GitHub App permission). Until that exists and is granted to the Cursor GitHub App, keep documentation here and keep raw data on the Mac.

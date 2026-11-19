# Experiment log template

Use one file (or one Notion page under **Lab → EMG Algorithm Development & Optimization**) per experiment. Fill every heading. Leave “Results” empty until the run exists — do not invent numbers.

Copy this structure into Notion so Cursor, Codex, and LAB stay aligned.

---

## Title

- Date (Asia/Taipei):
- Operator:
- Code version (git SHA or folder):
- Related Notion section (e.g. 5.4 Fatigue Detection):

## Objectives 目標

- Scientific question:
- Hypothesis (if any):
- What this run is **not** (e.g. not a new 5.4 detector if 5.4 is already done):

## Settings 設定

- Dataset: synthetic / public / lab-collected human sEMG (circle one)
- If human: ethics / consent status:
- Muscles / electrode placement:
- Sampling rate, gain, hardware:
- Task: isometric / dynamic / other:
- Fatigue **construct**: subjective (RPE / Borg / task failure) vs objective (force/MVC drop, MNF/MDF, …) — list separately
- Filters, windows, normalization (MVC?):
- Train / test split: none / same-session / held-out subject / held-out day
- Random seed:

## Commands 指令

```bash
# exact commands or notebook cells, with working directory
```

## Results 結果

| Metric | Baseline | This run | Notes |
| --- | --- | --- | --- |
| | | | |

- n (subjects / trials):
- Synthetic vs real:
- Exploratory vs held-out:

Attach figures by path (do not embed identifiable recordings).

## Analysis 分析

- What the numbers mean physiologically:
- Failure modes / artifacts:
- Comparison to previous sections (do not overwrite 5.4 history):

## Conclusions 結論

- Supported:
- Not supported:
- Limitations:

## Next steps 下一步

- [ ] Proposal only until approved
- [ ] Does **not** duplicate completed 5.4 work

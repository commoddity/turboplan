# Guide 02 — Seed `planning/phases`

## Intent

Decompose the goal into **dependency-ordered, verifiable tasks** before coding.

## Layered build order

Write layers first (capability), then tasks inside layers.

```text
L0  Shell runs / module builds
L1  Config + logging
L2  Secrets / auth identity
L3  Pure core (unit-testable)
L4  Integration surface (HTTP/CLI/DB)
L5  External processes (tunnels, workers)
L6  Host integration (settings sync, installers)
L7  Operator UX (doctor, usage, status)
L8  E2E / live proof
```

Do not start Ln until L(n−1) has a verification story that can fail loudly.

## INDEX.md columns

| ID | Title | Status | Depends-on | Next | Layer | Notes |
| -- | ----- | ------ | ---------- | ---- | ----- | ----- |

- Status values: `Pending` | `Planned` | `InProgress` | `✅` | `Blocked`  
- On completion, INDEX Status = **`✅`** (never the word `Done` in this column)  
- Task *file* header may say `Status: Done`

## Stub file requirements

Copy [`../templates/phases/TXX-template.md`](../templates/phases/TXX-template.md) to `T01-short-slug.md`, etc.

Required sections:

- Description  
- Status History (log transitions)  
- Requirements  
- Implementation Plan *(empty until `/task-1-plan`)*  
- Test Plan  
- Acceptance Criteria (checkboxes)  
- Verification  
- Files Modified  
- Manual test (for humans) *(filled by `/task-3-complete`)*  
- Learnings  
- Next / Depends-on  

## Granularity heuristics

| Too big | Too small | Just right |
| ------- | --------- | ---------- |
| “Build the app” | “Rename one variable” | “Sanitizer maps aliases + unit tests” |
| “All networking” | “Add one log line” | “Tunnel supervisor + URL parse + restart” |

Each task must answer: **How do we know this layer works without the next layer?**

## Downstream sync (why stubs matter)

When `/task-3-complete` finishes T0n, it may patch later stubs if reality changed (new package names, different default ports, abandoned approaches). That only works if later tasks exist as files with AC/notes to amend.

## Bootstrap output checklist

- [ ] INDEX lists T01…Tnn in order  
- [ ] Every row links to an existing stub  
- [ ] Depends-on graph has no cycles  
- [ ] First Pending/Planned task with satisfied deps is T01 (or clearly marked)  
- [ ] E2E / holistic verification is an explicit late task  

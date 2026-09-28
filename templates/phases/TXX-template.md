# TXX — {{Short Title}}

**Status**: Pending
**Feature**: Fnn
**Parent INDEX**: [INDEX.md](./INDEX.md)
**Depends-on**: {{T0prev or —}}
**Next**: {{T0next or —}}
**Layer**: L?
**Behavior change**: yes | no
**Irreversible**: yes | no

## Description

{{One paragraph: what this task delivers and why it exists in this order.}}

## Status History

| Timestamp | Event | From | To | Details | User |
| --------- | ----- | ---- | -- | ------- | ---- |
| | created | — | Pending | stub seeded by bootstrap | |

## Requirements

- [ ] {{REQ_1}}
- [ ] {{REQ_2}}

## Implementation Plan

*(Filled by `/task-1-plan` — do not invent during bootstrap beyond high-level notes.)*

### High-level notes (bootstrap)

- {{NOTE_1}}
- Reference: {{PATH_OR_URL}}

## Execution plan (filled by /task-1-plan)

**Date:**
**Codebase snapshot:**
**Feature:** Fnn
**Execute model:** medium/small (default) | large (only if justified)
**Behavior change:** yes | no
**Irreversible:** yes | no

### Context for executor
- …

### Steps
1. … → verify: …
2. Behavior change: failing test → verify: it fails for the intended reason
3. Implementation → verify: the test passes

### Tests to add
- …

### Commit subjects
1. `Fnn Tnn S1 One imperative sentence.`

### Verify commands
- `make verify`

### Risks / pitfalls
- …

### Pause points
- none

### Out of scope
- …

### Execute model recommendation
- medium/small (default) | large — rationale: …

## Test Plan

- {{How to prove this task without the next task}}
- Commands: `make verify` (lint + tests, and build when the Makefile wires it)
- Behavior changes: a test that fails before the production edit

## Acceptance Criteria

- [ ] {{AC_1}}
- [ ] {{AC_2}}
- [ ] Tests added or updated for new behavior
- [ ] `make verify` green
- [ ] Verification commands recorded and passing
- [ ] No secrets committed
- [ ] Each commit subject is `Fnn Tnn Sn One sentence.`

## Definition of Done

Standing bar, separate from the acceptance criteria above:
[`planning/checklists/definition-of-done.md`](../checklists/definition-of-done.md).
`/task-3-complete` checks it. Security and observability checklists load when
the task requires them.

## Verification

*(Filled by `/task-2-execute`; re-confirmed by `/task-3-complete`)*

## Files Modified

*(Filled by `/task-2-execute`)*

## Commits

| Sub | Subject | SHA |
| --- | ------- | --- |
| | | |

Next sub-task id is one greater than the highest `S` for this task. The first
commit is `S1` when the table and `git log` are empty. The close-out row’s
SHA stays `—`. Earlier SHAs are filled from `git log` at close-out.

Subject machine check:

```
^F[0-9]{2,} T[0-9]{2,} S[1-9][0-9]* [A-Z][^.!?]*\.$
```

## Manual test (for humans)

*(Filled by `/task-3-complete` — runnable commands and what to look for, or
`Nothing to test — <why>`)*

## Learnings

*(Filled by `/task-3-complete` / dialectic — link rule entries)*

## Reality notes

*(Amended by an upstream `/task-3-complete` when a prior task changed assumptions)*

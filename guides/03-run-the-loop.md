# Guide 03 — Run the plan → execute → complete loop

## Happy path

```text
/task-1-plan TXX      → detailed Execution plan (prefer large model); Status Planned
/task-2-execute TXX   → follow plan (prefer small/cheap model); lint+test green
/task-3-complete TXX  → re-verify; dialectic; INDEX ✅; commit; push (default); manual test; next branch
```

Repeat until INDEX is all `✅` or human stops.

## Model split

| Skill | Typical model | Why |
| ----- | ------------- | --- |
| `/task-1-plan` | Large / expensive | Design, tradeoffs, handoff fidelity |
| `/task-2-execute` | Small / fast / cheap | Follow a concrete plan + verify |
| `/task-3-complete` | Small / cheap | Re-verify, dialectic, commit, **push** (unless `--no-push`), manual test handoff, next branch |

**Plan bar:** `/task-1-plan` must be detailed enough that a lesser agent can execute
without redesigning (paths, steps → verify, tests, commands, pitfalls).

**Exception:** if the plan sets `Execute model recommendation: large`, use a large
model for execute. That should be rare when the plan is thorough.

## `/task-1-plan` responsibilities

- Load INDEX + stub + depends-on learnings  
- Reality-check repo vs stub assumptions  
- Write **Execution plan** with steps → verify pairs **and** executor context
  (files, tests, commands, risks)  
- Set Status `Planned` only when handoff-ready for a smaller model  
- Optionally flag `Execute model recommendation: large` with rationale  
- **Do not** implement product code  

## `/task-2-execute` responsibilities

- Preconditions: depends-on satisfied; plan exists  
- Status → `InProgress` (INDEX + stub)  
- Implement surgically per hub rules; **add tests** with new code  
- **Presence check** then **run full lint + test (+ build) verify** (`make verify`; auto-fix first);
  if Makefile / lefthook / lint config missing → Status `Blocked` (do not hand off)
- Fill Verification + Files Modified  
- Hand off: tell human to run `/task-3-complete` (or run it if they asked to complete in one go)  
- **Do not** write `✅` into INDEX (that’s task-3-complete)  
- **Do not** commit unless user asked  

## `/task-3-complete` responsibilities

1. Confirm AC passed  
2. **Presence check** then **re-run full lint + test (+ build) verify** — missing tooling or failures block close-out
3. Run `/dialectic-of-cognition` fully  
4. Patch downstream stubs if this task invalidated their assumptions (Reality notes only — no scope expansion)  
5. Stub Status → `Done`; INDEX → `✅`  
6. Commit on `<stub-stem>` branch with message `TXX <short description>` (no `--trailer`; no `--no-verify` unless user overrides)  
7. **Push** to `origin` by default (`git push -u origin HEAD`); skip only with **`--no-push`** or missing remote  
8. Emit **Manual test** commands (or `Nothing to test — <why>`)  
9. `git checkout -b <next-stub-stem>` (or checkout existing)  
10. Stop — do not start implementing TYY  

Optional: `/task-3-complete TXX --no-push` to commit and branch-switch without pushing.

## Branching convention

| Moment | Branch |
| ------ | ------ |
| Working TXX | `<stub-stem>` (e.g. `T04-sanitizer-adapter`) |
| After complete | create/switch next stub-stem branch; prior branch pushed unless `--no-push` |

Do not surprise-commit on `main`/`master`. Never force-push. Do not prefix branches with `planning/phases/`.

## Blocked / failed AC

- Set Status `Blocked` with reason in Status History  
- Do **not** complete, do **not** mark INDEX ✅  
- Human decides: replan, split task, or change requirements  

## Parallelism

Default: **one** InProgress phase task. Parallel only with explicit human approval, and only for tasks with no dependency edge between them.

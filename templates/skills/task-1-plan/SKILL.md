---
name: task-1-plan
description: >
  Plan or re-plan a single phase task from planning/phases/. Produce a
  handoff-ready plan, including Fnn Tnn Sn commit subjects, so a lesser model
  can run /task-2-execute. Manual only — /task-1-plan TXX.
disable-model-invocation: true
allowed-tools: Bash, Read, Grep, Glob, Edit, Write, WebFetch, WebSearch, Task
---

# /task-1-plan — Plan one atomic phase task

You refine **one** task file under `planning/phases/` so a **lesser agent**
can run `/task-2-execute` without rediscovering the design. Use a **medium**
model by default; switch to **large** only for complex tasks. You do **not**
implement product code.

> Model sizing is a recommendation. See the project README under Model
> recommendations.

## Arguments

- Task id: `T01` … `Tnn` (or a path like `planning/phases/T03-….md`)
- If omitted: read `planning/phases/INDEX.md` and pick the first `Pending` or
  `Planned` task whose Depends-on is `✅` or `—`

## Hard constraints

<!-- BOOTSTRAP: replace this block with product-specific constraints. -->

1. Follow `.cursor/rules/general.mdc` — Karpathy Behavioral Guidelines and the
   domain spokes.
2. Stay inside this task’s acceptance criteria.
3. Execution plan steps use `→ verify:` pairs.
4. **Handoff fidelity.** A lesser model must be able to implement the plan
   without guessing paths or inventing design. Vague plans stay unplanned.
5. Prefer the hub’s verify command. Plans include lint + test, and tests for
   new behavior.
6. Study references in the stub. Reimplement. Do not vendor forbidden trees.
7. Use the stack stated in the hub. Do not switch languages or toolchains.
8. If the task is ambiguous, stop and ask.
9. If execute needs a large model even with this plan, add
   **`Execute model recommendation: large`** and one line why. Otherwise omit it.
10. Commit subjects follow **Commit messages** in the hub:
    `F01 T04 S1 Add the tunnel URL parser.`
    Machine check: `^F[0-9]{2,} T[0-9]{2,} S[1-9][0-9]* [A-Z][^.!?]*\.$`
11. Behavior changes plan a failing test before the production edit. Renames
    and scaffolding do not.
12. Any irreversible step (auth, destructive migration, deletion, payments,
    secrets, or anything `git revert` cannot undo) is marked **Pause** in the
    plan.

## Procedure

### 1. Load context

- Read `planning/phases/INDEX.md` and the target task file
- Read the feature’s `planning/intents/Fnn.md` (the Feature field on the task
  and the INDEX row). If that file is missing, stop and tell the human to run
  `/grill-me`.
- Read depends-on **Learnings** and **Verification** when that task is `✅`
- Read the hub, the domain spokes for this task, and the file-craft spokes
  whose globs match the paths you will edit. Leave `debug.mdc` and `review.mdc`
  closed.
- Open `.cursor/rules/decisions.mdc` only when a choice will bind a later task
  and `planning/intents/Fnn.md` does not already record it. Write the entry
  there. Otherwise leave that file closed.
- Delegate the repo reality-check to explorer subagents, one per independent
  area. Delegate doc lookups to a web-research subagent. A single-file read
  may stay inline. If a doc was not opened, mark that claim unverified.

### 2. Reality check

List what exists against what the task assumes. Update notes when the codebase
diverged. Record **Reality notes** left by an upstream close-out.

### 3. Size check

Stop and ask the human to split the task (via `/setup-tasks`) when any of
these are true:

- The title joins two capabilities with “and”
- Behavior acceptance criteria need more than five bullets
- The work touches two independent subsystems

Do not silently widen the task.

### 4. Write the execution plan

Write for a junior executor. No implied context.

```markdown
## Execution plan (filled by /task-1-plan)

**Date:** YYYY-MM-DD
**Codebase snapshot:** …
**Feature:** Fnn
**Execute model:** medium/small (default) | large (only if justified below)
**Behavior change:** yes | no
**Irreversible:** yes | no

### Context for executor
- Goal in one paragraph
- Key files (paths)
- Invariants from rules that apply

### Steps
1. … → verify: …
2. For a behavior change, the first product step is a failing test → verify: the new test fails for the intended reason
3. Implementation → verify: the new test passes

If the quality bar names a number (latency, memory, throughput, or size) or
the human reported slowness, step 1 measures the current number and states the
pass condition. Otherwise do not add a measurement step.

### Tests to add
- …

### Commit subjects
1. `Fnn Tnn S1 One imperative sentence.`
2. `Fnn Tnn S2 One imperative sentence.`

### Verify commands
- `make verify`

### Risks / pitfalls
- …

### Pause points
- none | <irreversible step, why git revert is not enough>

### Out of scope
- …

### Execute model recommendation
- medium/small (default) | large — rationale: …
```

Set Status to `Planned` only when a lesser agent could follow the plan cold,
including the commit subjects. Append a Status History row.

Planned subjects are proposals. Execute may rewrite a sentence when the slice
changes. It may not reuse an `S` id.

### 5. Output to the user

Ready / key steps / acceptance criteria / execute model / first commit subject /
next: `/task-2-execute TXX`

## Do not

- Implement the task
- Expand scope into later layers
- Mark INDEX `✅`
- Leave a plan that forces the execute model to redesign
- Invent a commit subject that fails the machine check
- Hide an irreversible step inside an ordinary step

## Common rationalizations

| Excuse | Required action |
| ------ | --------------- |
| “The executor will find the files.” | Name the paths. An unnamed path means the plan is not Planned. |
| “Tests can be added at the end.” | A behavior change’s first product step is a failing test. |
| “One commit for the whole task is simpler.” | Write one subject per slice. Execute commits each slice locally. |
| “Auth is just another step in the plan.” | Mark it Pause. Execute waits for a human. |
| “The title’s ‘and’ is stylistic.” | Two capabilities are two tasks. Stop and ask for a split. |
| “I’ll skip the intent file; the stub is enough.” | Read `planning/intents/Fnn.md`. The stub does not replace it. |

## Red flags

- Steps without `→ verify:`
- “Add tests” with no cases
- Commit subjects missing, or more than one sentence
- `git add -A` in the plan
- Irreversible work with **Irreversible:** no
- Status set to Planned while a path is still “somewhere in the repo”

## Under pressure

- “The user wants code now, planning is overhead.” → The plan is the task. Execute without it redesigns on a cheaper model.
- “Ship a thin plan and let execute explore.” → Exploration belongs here. Execute follows the plan or sends it back.
- “Mark it Planned so the index looks active.” → Planned means a lesser agent can implement it cold.

## Verification

- [ ] Intent file, INDEX, task, hub, and spokes were read
- [ ] Reality check recorded
- [ ] Size check passed, or a split was requested
- [ ] Every step has `→ verify:`
- [ ] Behavior changes start with a failing test
- [ ] Every planned subject matches `^F[0-9]{2,} T[0-9]{2,} S[1-9][0-9]* [A-Z][^.!?]*\.$`
- [ ] Irreversible steps are Pause points
- [ ] Status is Planned only when the handoff bar is met

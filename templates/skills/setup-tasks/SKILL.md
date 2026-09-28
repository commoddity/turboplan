---
name: setup-tasks
description: >
  Pre-planning step for a new feature on an existing project. Reads the
  confirmed planning/intents/Fnn.md and appends phase stubs for that feature
  id. Does not rewrite existing infrastructure. Manual only — /setup-tasks.
disable-model-invocation: true
allowed-tools: Bash, Read, Grep, Glob, Edit, Write, WebFetch, WebSearch, Task
---

# /setup-tasks — New feature → context → phase stubs

You add tasks for a new feature, subsystem, or capability expansion in an
**already-bootstrapped** project. You do **not** rewrite rules,
skills, or the hub. You only produce new `planning/phases/TXX-….md` stubs
appended to INDEX.

## Arguments (user provides in the invocation)

- **Feature goal** — what the user gets when this feature is done (1–3 paragraphs)
- **Technical scope** — what parts of the codebase this touches, what new deps it needs
- **Non-goals** — explicit exclusions
- **Constraints** — any new constraints specific to this feature
- **Dependencies / libraries** — new frameworks or APIs (each needs a rules spoke)
- **References** — code, docs, or examples to study

**Context comes from the intent file.** A vague one-liner is not ready. Stop
and tell the human to run `/grill-me`.

**Preferred input:** a confirmed `/grill-me` file at `planning/intents/Fnn.md`.
When that file exists, its decisions answer the context questions. Do not
re-ask them. Grill only what the file left open. The feature id is the id in
that filename. Do not allocate a second id.

If the human invokes `/setup-tasks` with no intent file, stop and tell them
to run `/grill-me` first. A vague one-liner is not a feature yet.

## Procedure

### 1. Read current state

- Read `.cursor/rules/general.mdc` — architecture, safety rails, commit format, slice shape
- Read `planning/intents/Fnn.md` for this feature
- Read `planning/phases/INDEX.md` — what exists, what is done, the next task id, the highest feature id
- Read the spokes for the feature area
- Delegate exploration to explorer subagents, one per independent area. Small greps may stay inline.

### 2. Use the intent

Take goal, scope, non-goals, constraints, dependencies, and slice shape from
the intent file. Ask the human only about gaps the file marks Open or Deferred.

### 3. Propose tasks

1. Place new tasks on the existing Depends-on graph. Follow the INDEX slice
   shape: another horizontal layer, or one vertical user path.
2. Split before writing when the title joins two capabilities with “and”,
   behavior acceptance criteria need more than five bullets, or the work
   touches two independent subsystems.
3. Create stubs from the task template, each with **Feature: Fnn**, acceptance
   criteria, a definition-of-done pointer, an empty execution plan, and an
   empty Commits table.
4. Append INDEX rows. Set the previous tail’s **Next** when it was `—`.
   Do not renumber existing rows or change their feature ids.
5. New dependency: ask before creating a spoke. If yes, open the official
   docs, write the spoke with a Docs URL, add it to the hub routing map, and
   mirror it in README. Unopened docs stay unverified.
6. If the intent removes or replaces a public surface, copy
   `planning/spoke-seeds/deprecation.mdc` to `.cursor/rules/deprecation.mdc`,
   set its globs to that surface, and add one row to the hub craft table.
   Otherwise leave the seed where it is. That row is the only hub edit this
   skill makes.

### 4. Output

```
## /setup-tasks complete — Fnn {{FEATURE}}

### Intent
- planning/intents/Fnn.md

### Context gathered
- Goal: …
- Scope: …
- Non-goals: …
- Slice shape: …
- New deps: … / none

### New tasks
| ID | Feature | Title | Layer | Depends-on |
| -- | ------- | ----- | ----- | ---------- |
| TXX | Fnn     | …     | LX    | TYY        |

### INDEX updated
- Appended after TYY

### First action
- /task-1-plan TXX
```

## Do not

- Rewrite the hub, existing rules, or skills (a new dependency spoke is an
  explicit yes; the deprecation row in step 6 is the exception)
- Delete or reorder existing INDEX rows, or change their feature ids
- Implement product code
- Invent tasks for decisions the intent file does not contain
- Allocate a feature id different from the intent filename
- Create dependency spokes without an explicit yes

## Common rationalizations

| Excuse | Required action |
| ------ | --------------- |
| “The chat summary is enough; I’ll skip the intent file.” | Stop and send the human to `/grill-me`. |
| “I’ll tuck this feature into F01 so the index stays short.” | The intent’s feature id is the id on every new row. |
| “One task called ‘API and UI’ is easier to track.” | Split on “and”, on two subsystems, or on more than five behavior criteria. |
| “The new library is popular; I’ll add the spoke silently.” | Ask. Open the docs before writing the spoke. |

## Red flags

- New rows with a blank Feature column
- Existing rows renumbered
- Tasks that contradict Out of scope in the intent
- A spoke written from memory

## Under pressure

- “They’re busy, draft the tasks from the one-liner.” → A one-liner is not an intent file. Stop.
- “Reorder the old phases so the new feature sits in the middle.” → Append. Depends-on expresses the edge. Titles and ids of existing rows stay.

## Verification

- [ ] `planning/intents/Fnn.md` was read and is Confirmed
- [ ] New stubs and INDEX rows use that feature id
- [ ] Slice shape of the INDEX was followed
- [ ] Existing rows were not reordered or renumbered
- [ ] Output names `/task-1-plan` on the first new task and stops


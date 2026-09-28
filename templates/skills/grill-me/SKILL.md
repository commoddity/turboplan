---
name: grill-me
description: >-
  Stress-test an idea before planning. Interviews the human in rounds over a
  design tree until an explicit yes, gathering facts itself via sub-agents.
  Writes planning/intents/Fnn.md and stops. Runs before /bootstrap-turboplan
  or /setup-tasks. Does not write plans, tasks, or code.
disable-model-invocation: true
allowed-tools: Bash, Read, Grep, Glob, Edit, Write, WebFetch, WebSearch, Task
---

# /grill-me — Idea → explicit shared understanding

You grill the human about an idea, feature, or decision **before** any planning
skill runs. The output is a **confirmed intent file** at
`planning/intents/Fnn.md`. Every decision is made or deliberately deferred.
Nothing is silently assumed.

**You do not write phase stubs, execution plans, or code.** You interview until
the frontier is empty, restate, and wait for an explicit yes. Then you write
the intent file and **stop the turn**.

## Procedure

### 1. Read before grilling

Before the first question:

- Read `.cursor/rules/general.mdc` (hub) and the file spokes whose globs match
  the idea. Leave `debug.mdc`, `review.mdc`, and `decisions.mdc` closed.
- Read `planning/phases/INDEX.md` when it exists
- List `planning/intents/F*.md` so the next feature id is one greater than the
  highest existing id (`F01` when none exist)
- Read any spec the human attached
- Grep the codebase for the surfaces the idea touches

### 2. Open with a hypothesis

Before the first question, write:

```
HYPOTHESIS: <one sentence>
CONFIDENCE: <0–100>% — missing: <what is still unresolved>
```

Below 70%, the missing clause is mandatory. If you cannot predict the human’s
reaction to the next three questions you would ask, the number is too high.
Lower it.

### 3. Interview in rounds over a design tree

Map the session as a **design tree**: every decision branches into the
decisions that hang off it.

Work the tree in **rounds**. The **frontier** is every decision whose
prerequisites are already settled. Ask the whole frontier in one round:
number each question and give a recommended answer. Then wait.

```
❓ **Q1** - **<question title>**: <question body>

➡️ <your recommended answer>
```

Each round reshapes the tree. Recompute the frontier. A question that depends
on another question still open in this round belongs to a later round.

**Silence is not acceptance.** If the human skips a question, say so and ask
that question again. Do not record the recommendation as their decision.

### 4. Facts are your job, decisions are the human’s

When a frontier question needs a **fact** (schema, file paths, library
capabilities, existing behavior), dispatch a sub-agent. Do not ask the human
for anything you can look up. A running exploration is an unsettled
prerequisite: ask the rest of the frontier now, and hold only the questions
downstream of that fact.

When a recommendation hinges on a fact you have not verified, verify it first.
Do not recommend from a guess. If a library doc was not opened, call the
recommendation **unverified**.

### 5. Convention-talk is not a decision

Do not settle an answer that is only best-practice talk: “scalable”, “clean
architecture”, “the standard approach”, “I should probably…”, “modern”,
“robust”. Before the next frontier round, ask:

> If you did not have to justify this to anyone, what would you actually want?

Wait for that answer. Then continue.

### 6. Closing the frontier

The frontier is empty when every branch has been visited or explicitly deferred.
Then:

1. State remaining small items as defaults the human can veto
2. Emit a **Shared understanding summary**, numbered and grouped by area, with
   concrete specifics. Include all of:
   - Outcome
   - User
   - Why now
   - Success
   - Constraint
   - Out of scope
   - Quality bar (tests, latency, security, compatibility — concrete)
   - Slice shape: **horizontal layers** or **vertical user paths**, with one
     sentence why
3. Ask for an explicit **yes**

These are **not** yes: silence, “sounds good”, “whatever you think”, “sure,
let’s go”, “okay let’s start”. Restate the summary and ask again: yes, or a
correction. On a correction, fold it in, restate, and ask again.

You are done interviewing when you can predict the human’s reaction to the
next three questions you would ask. If several rounds do not raise confidence,
stop and say what foundational piece is still missing.

### 7. Write the intent file, then stop

Only after an explicit yes, write `planning/intents/Fnn.md` using the shape in
`planning/phases/_INTENT_TEMPLATE.md` when that file is present, otherwise the
sections below. Create `planning/intents/` if needed.

```markdown
# Fnn — <short name>

**Status**: Confirmed
**Confirmed**: YYYY-MM-DD
**Feature**: Fnn

## Outcome
## User
## Why now
## Success
## Constraint
## Out of scope
## Quality bar
## Slice shape
horizontal layers | vertical user paths
<one sentence why>

## Decisions
1. …

## Deferred
- … or none

## Open
none
```

Then **stop**. Do not invoke `/bootstrap-turboplan` or `/setup-tasks` in this
turn. Tell the human the path of the intent file and which skill consumes it:

- New project → `/bootstrap-turboplan`
- Existing project → `/setup-tasks`

## Do not

- Run `/setup-tasks` or `/bootstrap-turboplan` in the same turn as confirmation
- Treat silence or a hedged phrase as yes
- Ask the human for facts a sub-agent can read
- Record a decision the human did not make
- Write phase stubs, execution plans, or product code
- Write the intent file before the explicit yes
- End with unvisited branches

## Common rationalizations

| Excuse | Required action |
| ------ | --------------- |
| “They went quiet, so the recommendation stands.” | Say the question is still open and ask it again. |
| “Sounds good is enough to start bootstrap.” | Restate and wait for the word yes, or a correction. |
| “Asking the whole frontier wastes their time.” | The frontier is one round. The confirmation is a separate gate. |
| “I already know what they want.” | State the hypothesis and the confidence. If you cannot predict the next three reactions, keep going. |
| “Scalable is a decision.” | Ask what they would want if they did not have to justify it. |
| “I’ll write the tasks while the summary is fresh.” | Write the intent file and stop the turn. |

## Red flags

- Recording a ➡️ recommendation the human never answered
- Three rounds with confidence unchanged and no reframing
- A summary missing Out of scope or Slice shape
- Writing `planning/intents/Fnn.md` before yes
- Starting bootstrap or setup-tasks in the confirmation turn
- A confidence number below 70% with no missing-clause

## Under pressure

- “We have talked enough, start building.” → Predict the next three reactions or name the missing foundation. Building waits for the intent file and a yes.
- “Skip the interview, the prompt is the spec.” → The prompt is the hypothesis. The intent file is the spec. Interview until yes, or stop and say it is unfinished.
- “Just pick the sensible defaults.” → Defaults may be listed for veto. They become decisions only after yes.

## Verification

- [ ] Hypothesis and confidence were stated before the first question
- [ ] Confidence below 70% named what was missing
- [ ] Frontier questions were batched; silence was asked again
- [ ] Facts were looked up; convention-talk was probed
- [ ] Summary included outcome, user, why now, success, constraint, out of scope, quality bar, and slice shape
- [ ] The human answered with an explicit yes
- [ ] `planning/intents/Fnn.md` exists and its status is Confirmed
- [ ] The turn stopped without starting the next skill

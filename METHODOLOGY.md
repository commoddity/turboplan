# 🧠 Turboplan methodology

<p align="center">
  <img src=".github/img/methodology.png" alt="Turboplan methodology" width="500" />
</p>

## 🔥 The problem

Long-horizon projects fail with coding agents when:

- Rules describe a **different product** than the one being built (stale fork residue)
- Work is one giant prompt instead of **ordered, verifiable layers**
- There is no **close-out ritual** (learnings → rules, INDEX update, downstream sync)

Turboplan is a portable operating system for agents: adapt rules to the goal,
slice the goal into phases, and loop plan → execute → complete until done.

---

## 🚪 Two entry points

Every idea is grilled first — `/grill-me` is the universal front-door. It is
most valuable on greenfield work, where nothing exists yet and every unspoken
assumption is still on the table.

| When                               | Use                    | What it does                                                                                                              |
| ---------------------------------- | ---------------------- | ------------------------------------------------------------------------------------------------------------------------- |
| **New project** (greenfield)       | `/grill-me` → `/bootstrap-turboplan` | `/grill-me` stress-tests the idea to a settled shared understanding; `/bootstrap-turboplan` adapts rules, creates layered phases, ships verify gate, writes README — a **ready-to-build MVP** |
| **New feature** (existing project) | `/grill-me` → `/setup-tasks` | `/grill-me` stress-tests the idea to a settled shared understanding; `/setup-tasks` turns it into new phase stubs without disturbing existing infrastructure |

```mermaid
flowchart TD
    A[Goal / Feature idea] --> GR["grill-me (design tree → shared understanding)"]
    GR --> B{New project?}
    B -->|Yes| C[bootstrap-turboplan]
    B -->|No| D[setup-tasks]
    C --> E["INDEX.md + rules + skills"]
    D --> E
    E --> F["task-1-plan TXX"]
    F --> G["task-2-execute TXX"]
    G --> H["task-3-complete TXX"]
    H --> I{Done?}
    I -->|No| F
    I -->|Yes| J[Complete]
```

---

## 🏛️ Three pillars

### 1. 🧭 Agent rules (hub → spoke)

One always-on hub routes agents to domain-specific spokes. No duplicated rules trees.

| Layer              | Location                     | Role                                                                                           |
| ------------------ | ---------------------------- | ---------------------------------------------------------------------------------------------- |
| Hub (always on)    | `.cursor/rules/general.mdc`  | Karpathy guidelines, routing, safety, rule maintenance, product architecture, skills inventory |
| Spokes (on demand) | `.cursor/rules/<domain>.mdc` | Failure modes and conventions for one domain (API, UI, packaging, dependency docs, …)          |
| Skills (commands)  | `.cursor/skills/*/SKILL.md`  | Procedures: grill-me, bootstrap, setup-tasks, plan, execute, complete, dialectic, audit           |

- Skills live in `.cursor/skills/`; Cursor loads `.cursor/rules/*.mdc` as rules and exposes skills as commands
- **Never** duplicate rules outside `.cursor/rules/`
- Bootstrap adapts rules to the specific product — deletes inapplicable spokes, creates new ones for named dependencies

### 2. 📋 Layered phases

Tasks are ordered by dependency so each layer is verifiable before the next begins.

**`planning/phases/INDEX.md`** is the single source of truth:

| Column     | Meaning                                                |
| ---------- | ------------------------------------------------------ |
| ID         | `T01` … `Tnn`                                          |
| Title      | Short name + link to stub file                         |
| Status     | `Pending` → `Planned` → `InProgress` → `✅` / `Blocked` |
| Depends-on | Prior task IDs or `—`                                  |
| Next       | Following task ID                                      |
| Layer      | Which capability layer this advances                   |

**T01** is always the skeleton bootstrap — minimal runnable program + verify gate passing.
No business logic, just the scaffold that compiles and tests green.

**Each stub file** (`TXX-name.md`) has: Description, Requirements, Acceptance Criteria,
empty Execution plan (filled by `/task-1-plan`), Test Plan, Verification, Files Modified.

### 3. 🔁 Work loop skills

```mermaid
flowchart LR
    P["task-1-plan (design)"] --> E["task-2-execute (build)"]
    E --> C["task-3-complete (close out)"]
    C --> P
```

| Skill                     | When                            | Recommended model                                                         | Does                                                                              |
| ------------------------- | ------------------------------- | ------------------------------------------------------------------------- | --------------------------------------------------------------------------------- |
| `/grill-me`               | Before `/bootstrap-turboplan` or `/setup-tasks` | Large                                                                     | Design-tree interview in rounds until shared understanding; facts via sub-agents |
| `/bootstrap-turboplan`    | New project                     | Large                                                                     | Goal → rules + phases + README + verify gate                                      |
| `/setup-tasks`            | New feature in existing project | Large                                                                     | Context → new phase stubs appended to INDEX                                       |
| `/task-1-plan TXX`        | Before coding                   | Medium (large only for complex tasks)                                     | Reality-check; handoff-ready plan for execute agent                               |
| `/task-2-execute TXX`     | After plan                      | Medium or small                                                           | Follow plan until AC pass; `make verify`; do not mark INDEX ✅                     |
| `/task-3-complete TXX`    | After execute                   | Medium or small                                                           | Re-verify; dialectic; INDEX → ✅; commit; push (default); Manual test; next branch |
| `/dialectic-of-cognition` | End of hard sessions            | —                                                                         | Particular → general → encode into spokes                                         |
| `/audit-rules`            | Periodically                    | —                                                                         | Read-only audit of rules/skills vs tree                                           |

> 💡 See [README: Model recommendations](README.md#model-recommendations) for which
> specific provider/models correspond to each size tier. These are **recommendations,**
> not hard rules — use the best model you have access to for the task's complexity budget.

### 4. 🤖 Subagent delegation

Every skill delegates facts-gathering and mechanical work to **subagents** instead
of doing it serially on the parent. The parent keeps decisions, design, and
human interaction. Use **model classes only** — never a specific model alias —
since available subagents differ per environment.

**Delegation routing:**

| Subagent class        | Purpose                                                                 | Used by                                    |
| -------------------- | ----------------------------------------------------------------------- | ------------------------------------------ |
| Explorer             | Find files, read code, trace calls, map architecture, verify facts      | grill-me, setup-tasks, bootstrap, plan     |
| Web researcher       | Fetch docs, check API references                                        | bootstrap (dep spokes), grill-me, plan     |
| Implementer          | Well-scoped feature/bugfix from a clear spec                            | execute (bounded subtasks)                 |
| Refactorer           | Extract/rename/move — behavior-preserving changes                       | execute                                    |
| Test runner          | Run tests, diagnose failures, self-heal and re-run                      | execute, complete (background)             |
| Code reviewer        | Correctness/lint/style/bug review of a diff                             | after execute and after dialectic edits    |
| Verifier             | Skeptical independent check that claimed work is actually done          | after execute (background)                 |
| Doc writer           | Docs/changelog/README updates from diffs                                | complete, dialectic                        |
| Bash                 | Multi-step shell workflows                                              | any skill                                  |

**Rules:**

- **Facts are the subagents' job; decisions and design are the parent's.**
- **Parallelize independent work** — one subagent per independent area in a
  single batch. Don't block on a running subagent: ask what's unblocked now.
- **Background post-edit checks:** after non-trivial edits, launch code-reviewer
  and test-runner subagents in the background and continue; fold results in
  when they report.
- **Escalate on bad output:** if a subagent returns incomplete/nonsensical
  results, re-launch with tighter instructions or do it on the parent. Never
  accept silently.
- **Small tasks stay inline.** A single grep or one-file read is cheaper on the
  parent than a subagent round-trip. Over-splitting negates the win.
- If the environment has no subagent facility, every skill degrades gracefully
  to serial execution on the parent — delegation is an optimization, not a
  prerequisite.

---

## 🧠 Context gathering

Both `/bootstrap-turboplan` and `/setup-tasks` share the same context-gathering pattern.
Before building anything, the agent must extract:

1. **Goal** — what users get when done (end-user perspective, 1–3 paragraphs)
2. **Technical scope** — language, runtime, OS targets, packaging, architecture
3. **Non-goals** — explicit exclusions that prevent scope creep
4. **Dependencies** — named libraries, frameworks, external APIs (each becomes a rules spoke)
5. **References** — code or docs to study (reimplement, don't vendor)

The agent **refuses to proceed** without clear answers. A vague one-liner means the
human hasn't thought it through yet.

---

## 🔥 Grilling (before planning — for any idea)

`/grill-me` is the interrogator that runs **first** — before
`/bootstrap-turboplan` for a new project, or before `/setup-tasks` for a new
feature. It converts a rough idea into a **settled design tree** so the
planning skill starts from shared understanding instead of guesses. It pays off
everywhere, but is most valuable on **greenfield / brand-new projects**, where
nothing exists yet and every unspoken assumption is still open.

**Design tree:** every decision branches into the decisions that hang off it.
The session works the tree in **rounds**. The **frontier** is every decision
whose prerequisites are already settled — asked in one numbered round, each
question with a recommended answer (➡️). Silence = accept the recommendation.
Answers reshape the tree; the frontier is recomputed each round.

**Facts vs decisions:**

- **Facts are the agent's job** — schema, file paths, library capabilities,
  existing behavior. Dispatched to sub-agents, never asked of the human. A
  running exploration is just an unsettled prerequisite: only downstream
  questions wait for it.
- **Decisions are the human's** — every one is put to them and waited on.

**Done** = frontier empty: every branch visited, nothing silently assumed. The
agent then emits a **shared-understanding summary** (numbered, grouped by area,
with concrete specifics) and waits for the human's confirmation. Only then does
`/setup-tasks` run — every settled decision must land in the INDEX header and
task stubs, nothing assumed.

---

## 🔁 Running the loop

After bootstrap or `/setup-tasks` produces tasks, the work loop is (see
[README: Model recommendations](README.md#model-recommendations) for which
specific providers/models correspond to each size tier — these are recommendations):

1. **Plan** (`/task-1-plan TXX`): medium by default; switch to large only for complex
   tasks. Plan must be detailed enough that a lesser agent can execute without
   redesigning — paths, verify steps, tests, commands, pitfalls.

2. **Execute** (`/task-2-execute TXX`): medium or small. If the plan is thorough,
   medium is usually sufficient. Follow the plan exactly. Run `make verify`.
   Hard-abort if it fails.

3. **Complete** (`/task-3-complete TXX`): medium or small. The harder the execution
   was, the more dialectic learning to apply — medium when substantial patterns were
   learned, small for routine close-outs. Re-verify, run dialectic of cognition,
   mark INDEX ✅, commit, push (default; `--no-push` to skip), emit Manual test
   section, switch to next stub-stem branch.

- One task InProgress at a time unless the human says otherwise
- Work on `<stub-stem>` branches — never commit on `main`/`master`
- Blocked tasks: set Status `Blocked` with reason; human decides next step

### Task granularity heuristics

| Too big          | Too small             | Just right                                |
| ---------------- | --------------------- | ----------------------------------------- |
| "Build the app"  | "Rename one variable" | "Sanitizer maps aliases + unit tests"     |
| "All networking" | "Add one log line"    | "Tunnel supervisor + URL parse + restart" |

Each task must answer: **How do we know this layer works without the next layer?**

---

## 🌱 Rule maintenance (self-evolving)

Rules improve over time through the dialectic of cognition:

> *From the particular to the general, then from the general to the particular.*

The hub carries the full Rule Maintenance procedure (steps 0–7). Summary:

1. **Abort gate** — can you state the rule without naming a specific file/function?
2. **Particular → general** — extract the problem *class*, not the instance
3. **Encode** — symptom / cause / fix table + `<!-- last-verified: YYYY-MM -->`
4. **Verify** — would a cold-read AI recognize and apply it?
5. **Contradictions / dedupe / decay / split** — rules stay alive

Harness: `/dialectic-of-cognition` (also run from `/task-3-complete`).

---

## 🧭 Karpathy Behavioral Guidelines

Always in the hub. Four parts:

| #   | Name                  | Core idea                                               |
| --- | --------------------- | ------------------------------------------------------- |
| 1   | Think Before Coding   | State assumptions, surface tradeoffs, ask when unclear  |
| 2   | Simplicity First      | Minimum code; no speculative flexibility                |
| 3   | Surgical Changes      | Touch only what's required; clean only your own orphans |
| 4   | Goal-Driven Execution | Verifiable success criteria; step → verify loops        |

---

## 🧱 Engineering standards (internal — for Turboplan's own seed files)

These are the defaults Turboplan ships in its seeds. When bootstrapping a target
project, **replace** these with the user's actual choices — do not copy this into
the target repo.

- **Verify gate**: root `Makefile` with `verify` target (lint + test + build),
  lint config, lefthook pre-commit → verify
- **Toolchain**: latest stable for the project's language; document pins as concerns
- **Gitignore**: always `.env*` + `tmp/` + stack-specific artifacts
- **Commit policy**: `/task-3-complete` pushes by default (`--no-push` to skip);
  no commits outside that skill without explicit user request
- **Manual test**: every complete emits a Manual test section (or `Nothing to test` + why)

---

## 🚫 What Turboplan is not

- Not a replacement for human product judgment
- Not automatic commits/pushes outside `/task-3-complete`
- Not a requirement to use Docker, a specific UI framework, or a specific LLM vendor
- Not permission to rewrite unrelated repo areas

---

## ✅ Success criteria for a bootstrap

- Hub retains Karpathy Behavioral Guidelines + Rule Maintenance 0–7 + Safety / Workflow Rails
- Git repo + root `Makefile` with `verify` target + lint config + lefthook installed
- Primary language at latest stable (or pinned older version documented as concern)
- Every named dependency has a `.cursor/rules/*.mdc` spoke with docs URL
- Root `README.md` present (banner + summary + TOC + emoji headers)
- Root `.gitignore` covers secrets, `tmp/`, and stack artifacts
- Routing Map lists every spoke that exists; no leftover rules for deleted stacks
- `planning/phases/INDEX.md` has ordered tasks with Depends-on / Next
- Every INDEX row has a stub file with AC
- Skills' hard constraints match this product
- First actionable task is clear: `/task-1-plan T01`
- No product source code created (that's T01's job)
- Installer leftovers cleaned up (no `_TEMPLATE.md`, `verify-SEED/`, etc.)

# 🧠 Turboplan methodology

```
     ┌─────────────┐
     │   🎯 GOAL   │
     └──────┬──────┘
            │
   ┌────────▼────────┐
   │ 1. Adapt rules  │  🧭 hub → spokes
   └────────┬────────┘
            │
   ┌────────▼────────┐
   │ 2. Seed phases  │  📋 INDEX + stubs
   └────────┬────────┘
            │
   ┌────────▼────────────────────────────┐
   │ 3. Loop                             │
   │  📝 plan → 🛠️ execute → ✅ complete  │
   └─────────────────────────────────────┘
```

## 🔥 The problem this solves

Long-horizon projects fail with coding agents when:

- 🏚️ Rules describe a **different product** than the one being built (stale fork residue)
- 🌀 Work is one giant prompt instead of **ordered, verifiable layers**
- 🕳️ There is no **close-out ritual** (learnings → rules, INDEX update, next task, downstream sync)

Turboplan is a **portable operating system** for agents: adapt rules to the goal, slice the goal into phases, and loop plan → execute → complete until done.

---



## 🏛️ Three pillars



### 1. 🧭 Adapt generic cross-compatible agent rules/skills to a specific goal

**Hub → spoke**


| Layer              | File                         | Role                                                                                                           |
| ------------------ | ---------------------------- | -------------------------------------------------------------------------------------------------------------- |
| Hub (always on)    | `.cursor/rules/general.mdc`  | Karpathy guidelines, routing, safety, Rule Maintenance (dialectic 0–7), skills inventory, product architecture |
| Spokes (on demand) | `.cursor/rules/<domain>.mdc` | Failure modes and conventions for one domain (API, UI, packaging, …)                                           |
| Skills (commands)  | `.claude/skills/*/SKILL.md`  | Procedures: bootstrap, plan, execute, complete, dialectic, audit                                               |


**Cross-compatible layout**

- Cursor loads `.cursor/rules/*.mdc` (`alwaysApply` / globs)
- Claude Code loads `CLAUDE.md` → **symlink** to `.cursor/rules/general.mdc`
- **Never** duplicate rules under `.claude/rules/`

**Adaptation protocol (when dropping into a project)**

1. State the goal in one paragraph + non-goals
2. List domains you will touch (languages, frameworks, external APIs, platforms)
3. **Delete** spokes/skills that cannot apply
4. **Keep** Karpathy Behavioral Guidelines + Rule Maintenance 0–7 and the Safety / Workflow Rails at full fidelity; keep hub→spoke, verification rails. **Do not** copy language/framework evangelism or Turboplan's own engineering standards into the target repo — state the user's choices as facts, not preferences
5. **Rewrite** architecture, routing map, build/verify commands, safety no-gos
6. **Create** new spokes for novel domains (symptom / cause / fix tables)
7. **Create dependency/docs spokes** for every named library/framework/API (official
  docs URL + best-practice rules); mirror a short summary in human `README.md`
8. Point skills’ hard constraints at *this* product (not a previous fork)
9. Bootstrap must leave a **git repo + verify gate** (root `Makefile` `verify` =
  lint+test[+build], stack lint config, **lefthook** pre-commit→verify, hooks installed).
   For **Go**: Makefile also includes multi-platform `build-all`. Seeds under
   `templates/seeds/` → `planning/*-SEED*`; bootstrap adapts to **repo root**.
10. Prefer **latest stable** Go and package baselines; document pins as concerns
11. Bootstrap must create/update root `README.md` (emoji headers + ASCII banner + Summary + TOC) for humans; rules/skills remain for agents — keep both in sync as the project evolves
12. Bootstrap must create/update `.gitignore` (always `.env`/variants + `tmp/`; stack-aware binaries/artifacts — agent best judgment; merge if pre-existing)
13. Create dependency/docs spokes for named libs (official docs URL) and mirror in README

Use `/bootstrap-turboplan` (template skill) so an agent does this systematically from your goal text.  
Install templates first with `[scripts/install-into.sh](scripts/install-into.sh)`.

### 2. 📋 Layered `planning/phases/INDEX.md` + stubs

**Why layers:** ship capability in dependency order. Do not start a higher layer until the lower one is verified.

Example layer sequence (generic):

```
L0  🏗️  Skeleton / config / logging
L1  🔐  Secrets / identity
L2  🧪  Core domain logic (pure, testable)
L3  🔌  Integration surface (HTTP, CLI, DB)
L4  🌐  Side systems (tunnels, third-party sync)
L5  🖥️  Operator UX (doctor, status, usage)
L6  🏁  End-to-end proof
```

**INDEX** is the single source of truth for task order:


| Column     | Meaning                                                |
| ---------- | ------------------------------------------------------ |
| ID         | `T01` … `Tnn`                                          |
| Title      | Short name + link to stub file                         |
| Status     | `Pending` → `Planned` → `InProgress` → `✅` / `Blocked` |
| Depends-on | Prior task IDs or `—`                                  |
| Next       | Following task ID                                      |
| Layer      | Which capability layer this advances                   |


**Stubs** are real markdown files (`T01-….md`) with: Description, Status History, Requirements, Implementation Plan (filled by `/task-1-plan`), Test Plan, Acceptance Criteria, Verification, Files Modified, Learnings, Next.

**Rules of granularity**

- One stub = one cohesive, independently verifiable unit  
- Prefer “prove this layer” over “build half the app”  
- No gold plating: out-of-scope ideas become **new** tasks, not silent scope creep



### 3. 🔁 Skills that plan, execute, and complete in order


| Skill                     | When                                          | Does                                                                                                                                                       |
| ------------------------- | --------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `/bootstrap-turboplan`    | New project / retarget                        | From goal → rules + INDEX + stubs + dep spokes + human README + `.gitignore` + **root verify gate** (Makefile / lefthook / lint; Go: `build-all`)          |
| `/task-1-plan TXX`        | Before coding (prefer **large** model)        | Reality-check; write handoff-ready plan for a lesser execute agent; Status → `Planned`                                                                     |
| `/task-2-execute TXX`     | After plan (prefer **small/cheap** model)     | Follow plan until AC pass; **presence abort** then `make verify`; **do not** mark INDEX ✅                                                                  |
| `/task-3-complete TXX`    | After execute (usually **small** model)       | Same presence abort + re-verify; dialectic; sync stubs; INDEX → `✅`; commit; **push** (default; `--no-push` to skip); **Manual test** handoff; next branch |
| `/dialectic-of-cognition` | End of hard sessions / via `/task-3-complete` | Particular → general → encode into spokes                                                                                                                  |
| `/audit-rules`            | Periodically                                  | Read-only mechanical audit of rules/skills vs tree                                                                                                         |


**Sequential contract**

```text
/bootstrap-turboplan   (once)     🧰  (prefer large)
        ↓
/task-1-plan T01                  📝  large → handoff-ready plan
        ↓
/task-2-execute T01               🛠️  small/cheap (or large if plan says so)
        ↓
/task-3-complete T01              ✅  usually small → push (default) + Manual test → branch <T02-stub-stem>
        ↓
/task-1-plan T02
        …
```

**Handoff rule:** if a smaller execute model would have to invent design, the plan
is not done — re-run `/task-1-plan` on a large model.

Only **one** phase task `InProgress` unless the human says otherwise.  

### 🧠 Context gathering (what the agent needs before bootstrapping)

Bootstrap and `/setup-tasks` share a context-gathering pattern. Before building
anything, the agent must extract from the human:

1. **Goal** — what users get when done (1–3 paragraphs). End-user perspective.
2. **Technical scope** — language, runtime, OS targets, packaging strategy, secrets
  policy. Be specific: "Go 1.26+, macOS/Linux host CLI, not Docker-primary."
3. **Non-goals** — explicit exclusions that prevent scope creep
4. **Dependencies** — named libraries, frameworks, external APIs. Each becomes a
  rules spoke with canonical docs URL
5. **Layer preference** (optional) — if the human already knows the build order
6. **References** — code or docs to study (reimplement, do not vendor)

**Why this matters:** without this upfront, the agent invents constraints that
the human then has to correct at review time — wasting both sides. The bootstrap
skill must refuse to proceed if goal/constraints are missing.

### 🔁 Pre-planning with `/setup-tasks`

For an **existing** Turboplan project (already bootstrapped), adding a new
feature or subsystem uses `/setup-tasks` instead of re-running bootstrap:

- Gathers context (same pattern as bootstrap: goal, constraints, dependencies)
- Reads current INDEX and rules to understand the existing architecture
- Proposes new `planning/phases/TXX-….md` stubs appended to INDEX
- Does NOT rewrite rules, skills, or README — only adds tasks

**Overlap with bootstrap:** the context-gathering questions are identical. The
difference is scope: bootstrap re-architects the whole repo; `/setup-tasks` adds
tasks to an existing plan without disturbing rules or completed work.

### 🔁 Running the loop

After bootstrap or `/setup-tasks`, the work loop is:

```text
/task-1-plan T01                  📝  large model → handoff-ready plan
/task-2-execute T01               🛠️  small/cheap model (or large if plan says so)
/task-3-complete T01              ✅  small model → push (default) + Manual test → branch <T02-stub-stem>
```

**Model split:**


| Skill              | Typical model        | Why                                             |
| ------------------ | -------------------- | ----------------------------------------------- |
| `/task-1-plan`     | Large / expensive    | Design, tradeoffs, handoff fidelity             |
| `/task-2-execute`  | Small / fast / cheap | Follow a concrete plan + verify                 |
| `/task-3-complete` | Small / cheap        | Re-verify, dialectic, commit, push, next branch |


**Plan bar:** `/task-1-plan` must be detailed enough that a lesser agent can
execute without redesigning (paths, steps → verify, tests, commands, pitfalls).

**Branching:** work on `<stub-stem>` (e.g. `T04-sanitizer-adapter`). After
complete, push and switch to next stub-stem branch. Never commit on `main`/`master`.
Never force-push.

**Blocked tasks:** set Status `Blocked` with reason. Do not complete or mark
INDEX ✅. Human decides: replan, split, or change requirements.

**Granularity heuristics:**


| Too big          | Too small             | Just right                                |
| ---------------- | --------------------- | ----------------------------------------- |
| "Build the app"  | "Rename one variable" | "Sanitizer maps aliases + unit tests"     |
| "All networking" | "Add one log line"    | "Tunnel supervisor + URL parse + restart" |


Each task must answer: **How do we know this layer works without the next layer?**

---



## 🌱 Rule maintenance (self-evolving)

**Source of truth:** installed project’s `.cursor/rules/general.mdc` → section
**Rule Maintenance (Self-Evolving Rules)** (triggers, abort gate, steps **0–7**).
Do not maintain a shortened competing copy here.

**Harness:** `/dialectic-of-cognition` (Modes A/B for project rules).

Summary (full detail lives in the hub template):

1. **Abort gate** — one-sentence test without file/function names
2. **Particular → general** — problem *class*, not instance
3. **Encode** — symptom / cause / fix tables + `last-verified`
4. **Verify** — cold-read recognition
5. **Contradictions / dedupe / decay / 600-line split**

---



## 🧭 Karpathy Behavioral Guidelines (always in hub)

**Source of truth:** `templates/rules/general.mdc` (and the installed project’s
copy) — section **Karpathy Behavioral Guidelines**, full four parts.

Do **not** paraphrase into a shorter bullet list in other docs — that loses
fidelity. Agents must read the hub.


| #   | Name                  | Core idea                                           |
| --- | --------------------- | --------------------------------------------------- |
| 1   | Think Before Coding   | Assumptions, tradeoffs, ask when unclear            |
| 2   | Simplicity First      | Minimum code; no speculative flexibility            |
| 3   | Surgical Changes      | Touch only what’s required; clean only your orphans |
| 4   | Goal-Driven Execution | Verifiable success criteria; step → verify loops    |


**Tradeoff:** bias caution over speed; use judgment on trivial tasks.

## 🧱 Engineering standards (for Turboplan's own templates)

These are the defaults Turboplan ships with in its seed files. When
bootstrapping a target project, **replace** these with the user's actual choices
— do not copy this table into the target repo.

**Source of truth:** `templates/seeds/verify/` (Makefile, lefthook, golangci)
and `templates/rules/general.mdc`.


| Topic                  | Default                                                                                                                                                                           |
| ---------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Backend / server / CLI | **Go** (raise non-Go as bootstrap concern)                                                                                                                                        |
| Static site            | **Astro**                                                                                                                                                                         |
| App-style UI           | **Vue**                                                                                                                                                                           |
| Desktop                | **Wails**                                                                                                                                                                         |
| Tests                  | Required with new code; Go → table-driven                                                                                                                                         |
| Lint                   | Required; auto-fix first; fail only if unfixable                                                                                                                                  |
| Git hooks              | Repo + **Makefile verify** + lint config + **lefthook** pre-commit→verify (bootstrap AC)                                                                                          |
| Go Makefile            | `lint` · `test` · `build` · `build-all` (cross) · `verify` (= lint+test+build)                                                                                                    |
| Pack seeds             | `templates/seeds/{readme,gitignore,verify}/` → `planning/*-SEED*` → root via bootstrap                                                                                            |
| Toolchain / deps       | **Latest stable** Go + packages at bootstrap (concern if pinned older)                                                                                                            |
| Execute / complete     | Presence check + full lint+test(+build) verify before pass / ✅; abort if tooling missing                                                                                          |
| Complete push          | `/task-3-complete` **pushes** by default; opt out with `--no-push`                                                                                                                |
| Complete handoff       | Close-out includes **Manual test** commands or `Nothing to test` + why                                                                                                            |
| UX completeness        | When adopting a UX convention across multiple user-facing artifacts (all CLI commands, all prompts), apply it uniformly in a **single sweep** — not incrementally across sessions |
| Display-id caution     | User-facing labels that double as runtime identifiers create a risk surface — treat stable identifiers as defaults and label experimental ones clearly                            |


Adaptation protocol: when rewriting a hub for a product, **keep Karpathy
and Rule Maintenance 0–7 verbatim**; only replace product architecture,
routing, and examples. Do not copy language/framework preferences from this
section — bootstrap must use whatever stack the user specifies.

---



## 🚫 What Turboplan is not

- Not a replacement for human product judgment  
- Not automatic commits / pushes outside `/task-3-complete` (or explicit user ask). That skill commits and **pushes by default**; use `--no-push` to skip push  
- Not a requirement to use Docker, a specific UI framework, or a specific LLM vendor  
- Not permission to rewrite unrelated repo areas when capturing learnings elsewhere

---



## ✅ Success criteria for a Turboplan bootstrap

- [ ] `CLAUDE.md` → `.cursor/rules/general.mdc`  
- [ ] Hub retains full **Karpathy Behavioral Guidelines** + **Rule Maintenance** steps **0–7**  
- [ ] Git + root `Makefile` `verify` (lint+test+build) + lint config + lefthook (pre-commit→verify; hooks installed); also has `build-all` when applicable  
- [ ] Language / toolchain / deps at **latest stable** (or pinned older version documented as a concern)  
- [ ] Named dependencies/docs each have a `.cursor/rules/*.mdc` spoke with official **Docs (if stuck)** URL  
- [ ] Root `README.md` present (ASCII banner + emoji headers + Dependencies & docs synced to spokes)  
- [ ] Root `.gitignore` covers secrets (`.env*`), `tmp/`, and stack artifacts (Go binaries, etc.)  
- [ ] Routing Map lists every spoke file that exists  
- [ ] No leftover rules for deleted tech stacks  
- [ ] `planning/phases/INDEX.md` has ordered tasks with Depends-on / Next  
- [ ] Every INDEX row has a stub file with AC and empty Execution plan section  
- [ ] Skills’ hard constraints match *this* product  
- [ ] First actionable task is clear: `/task-1-plan T01`  
---
name: bootstrap-turboplan
description: >
  From a confirmed planning/intents/Fnn.md, adapt .cursor/rules and
  .cursor/skills, seed planning/phases with feature ids and slice shape,
  create dependency rule spokes from docs you open, write a human README.md,
  and an appropriate .gitignore. Manual only — /bootstrap-turboplan.
  Does not implement product features.
disable-model-invocation: true
allowed-tools: Bash, Read, Grep, Glob, Edit, Write, WebFetch, WebSearch, Task
---

# /bootstrap-turboplan — Goal → rules + phases + skills + human README

You install or retarget **Turboplan** for this repository. You produce agent
operating infrastructure **and** a human-facing `README.md`. You **do not**
implement product features.

**Two audiences (keep in sync as the project grows):**

| Audience | Primary artifacts |
| -------- | ----------------- |
| **LLMs / agents** | `.cursor/rules/*.mdc`, `.cursor/skills/*/SKILL.md` |
| **Humans** | Root `README.md` (+ phase INDEX for operators) |

## Arguments (user provides in the invocation)

- **Goal** — what users get when done (1–3 paragraphs, end-user perspective)
- **Technical description** — language, runtime, OS, packaging, architecture
- **Non-goals** — explicit exclusions
- **Constraints** — secrets policy, no-gos, verify command, toolchain preferences
- **Dependencies / libraries** — frameworks the product will use (e.g. Cobra,
  SQLite driver, Astro) — each should become a rules spoke
- **References / docs** — paths/URLs to study (official docs, OpenAPI, examples;
  reimplement, do not vendor)
- Optional: preferred layer list / task count target

**Preferred input:** `planning/intents/F01.md` (or the next confirmed intent)
written by `/grill-me`. When that file exists and its status is Confirmed,
it answers the questions below. Do not re-ask settled decisions. Grill only
what the file left open.

**CRITICAL — context gathering is mandatory.** If the user invokes `/bootstrap-turboplan`
without a confirmed intent file and without a detailed goal and technical
description, you MUST ask for them before proceeding. Do not invent the goal.
Do not guess the stack. Ask:

1. What does the user get when the project is done? (end-user perspective)
2. What is the technical scope? (language, runtime, OS, packaging, architecture)
3. What is explicitly out of scope?
4. What dependencies or external APIs will it use?
5. Are there reference implementations to study?

If the answer is vague, ask follow-ups until you have enough to produce an accurate
hub + spokes + phase plan. A human who won't answer these questions isn't ready to
bootstrap — stop and say so rather than producing a wrong architecture.

When the goal arrived in the prompt instead of an intent file, write
`planning/intents/F01.md` in the grill-me shape with **Status: Confirmed**
only after the human’s explicit yes on your restatement (outcome, user, why
now, success, constraint, out of scope, quality bar, slice shape). Then
continue. Silence and “sounds good” are not yes.

**The user may provide this context in the initial prompt, in follow-up answers,
or as a file attached to the chat session.** If a file is attached and clearly
contains the project specification (PRD, design doc, notes), read it and
extract the answers — do not re-ask for information already provided. The
intent file is still written so later sessions do not depend on the transcript.

## Hard constraints

1. Write rules only under `.cursor/rules/`.
2. Delete spokes/skills that cannot apply; replace wrong-provider files (do not light-edit).
3. Seed `planning/phases/INDEX.md` + one stub file per INDEX row.  
4. Adapt skill hard constraints to **this** product.  
5. Do not commit unless the user explicitly asks. When they do, the subject
   follows **Commit messages** in the hub, using task `T00`:
   `F01 T00 S1 Seed the operating files for the project.`
   Machine check: `^F[0-9]{2,} T[0-9]{2,} S[1-9][0-9]* [A-Z][^.!?]*\.$`
   Stage named paths only. `git add -A` is forbidden. Do not push.
6. Do not implement product features. Do not create the application source
   tree. That is T01 via `/task-2-execute`.
   - In scope: root Makefile, lint config, lefthook, .gitignore, README.md,
     .cursor/rules/*.mdc, .cursor/skills/*/SKILL.md, planning/phases/,
     planning/intents/, planning/checklists/.
   - When the user chose Go: never create `cmd/`, `internal/`, `pkg/`, or
     `migrations/`, and never run `go mod init`. T01 does that.
   - When the user chose another stack: never create that stack’s source
     roots either.  
7. Bootstrap AC requires **git repo + verify gate files present + lefthook installed**:
   root `Makefile` with `verify` target (lint+test+build for Go), stack lint config,
   and `lefthook install` succeeded. Seeds live under `templates/seeds/` (after install:
   `planning/verify-SEED/`).
   Seeds under `planning/` alone are **not** enough — adapted copies must land
   at repo root + hooks installed. Go Makefiles must include `lint`, `test`,
   `build`, multi-platform `build-all`, and `verify` (= lint+test+build).
   **Do not require `make verify` to pass yet** — there is no source code.
   T01 creates the skeleton; verify passes for the first time in T01.  
8. Use the **stack the user specified** in the technical description. Do not
   silently substitute languages, frameworks, or toolchains. If the user
   specified Go, use Go. If they specified React, use React. Raise any
   non-obvious choices as **bootstrap concerns** with rationale.  
9. Use the **toolchain versions the user specified** (or current environment
    baseline). Do not silently upgrade. If the environment constrains versions,
    document under **Bootstrap concerns**.  
10. For every named dependency / provided doc set that agents will use: create a
    **dedicated spoke** under `.cursor/rules/` with an **External docs** link to
    the official source, and mirror a short human summary in `README.md`.  
11. Create or replace root **`README.md`** with: emoji section headers; ASCII
    banner; a brief human **Summary**; a **Table of Contents** immediately under
    the summary; then the body sections — humans read this; agents read rules/skills.  
12. Create or update root **`.gitignore`** appropriate to the stack — use best
    judgment (always secrets + scratch; language/tooling artifacts as needed).  

## Procedure

### 1. Inventory current agent files

List `.cursor/rules/*.mdc` and `.cursor/skills/*/SKILL.md`. Classify each:
DELETE / ADAPT / KEEP (per Turboplan Guide 01).

**Delegate:** fan out explorer subagents (one per independent area of the
codebase/tree) to build the inventory and assess each file; delegate doc
fetches for dependency spokes to web-research subagents in parallel. Keep
classification **decisions** on the parent.

### 2. Rewrite hub

Update `.cursor/rules/general.mdc`:

- **Strip every reference to Turboplan** — this file is about THIS product, not
  the methodology that bootstrapped it. No "Turboplan hub", no "Turboplan
  project", no "bootstrap-turboplan" in the safety rails exception list.
- **Product name, architecture, build/verify, safety no-gos** — all project-specific
- **Routing Map + Problem Class table** for new spokes (include every dep spoke)
- **Skills inventory** — list all skills that exist in `.cursor/skills/`
- **Keep these hub sections intact:** Karpathy Behavioral Guidelines, Definition of Done, Commit messages (including the machine check), Irreversible steps, Safety / Workflow Rails, Rule Maintenance steps 0–7, the moment-spoke sentence under **Read Rules Before You Act**, and the **Craft spokes** table. Fill `{{QUALITY_BAR}}` from the intent file. Name the lint config file in Build & Run so execute and complete can require it. Fill craft globs from the real tree. Delete a craft row when you delete that file. Do not list `debug.mdc`, `review.mdc`, or `decisions.mdc` in the craft table or the domain routing map. Do not add craft files to the skills inventory.
- **Layered delivery**: reference `planning/phases/INDEX.md` only. Do NOT copy
  task IDs, layer tables, or phase details into the hub. The INDEX header
  carries slice shape; the hub points at it.
- **Dialectic examples** from **this** domain (failure-mode illustrations only)
- **Do NOT include** generic language-preference evangelism ("Prefer Go",
  "Astro vs Vue vs Wails"), generic test/lint/git philosophy, or toolchain
  upgrade policies that match the template defaults. These are methodology
  opinions, not project ground truth. If the user specified a language,
  framework, or toolchain, state it as a fact ("Uses Go 1.26+") not as a
  preference ("Prefer Go because…").  

### 3. Spokes (domains + dependency docs)

- Delete obsolete  
- Create/adapt **product domain** spokes with invariants + at least one symptom table skeleton  
- Language craft spoke if applicable (`go.mdc`, etc.). Rename
  `LANGUAGE-craft.mdc` to that file and keep **After the new test is green**.
- **File-craft spokes** ship with the installer and start as templates.
  Set real globs, or delete the file **and** its craft-table row:
  - `security.mdc` — keep when the product accepts input, accounts, or stored
    credentials. Delete when none of those exist.
  - `api.mdc` — keep when something is exported or served as an endpoint.
    Delete for a script with no public surface.
  - `ui.mdc` — delete when the product has no interface.
  - `observability.mdc` — delete for a one-shot CLI or a pure library.
  - `deprecation.mdc` — do not install as a live rule. Leave
    `planning/spoke-seeds/deprecation.mdc` until a task removes a public surface.
- **Moment spokes** stay: `debug.mdc`, `review.mdc`, `decisions.mdc`.
  `alwaysApply: false`, no globs, and no row in either hub table. Phase skills
  open them by path.
- **Dependency / docs spokes (mandatory when deps or docs are provided):**

  For each library, framework, CLI toolkit, or external API the Goal/Constraints/
  Dependencies/References name (e.g. Cobra, Moonshot API, Cloudflare):

  1. Open the **official documentation** in this session (fetch the URL). A
     pattern you did not just read is **unverified** — say so in the spoke
     instead of stating it as fact.  
  2. Create `.cursor/rules/<name>.mdc` (e.g. `cobra.mdc`) including:
     - Title + when to apply (`globs` if useful)  
     - **`Docs (if stuck):`** canonical URL near the top (e.g. https://cobra.dev/docs/)  
     - Scope / invariants / layout or API conventions for **this** product  
     - At least one symptom / cause / fix table skeleton (or real patterns from docs)  
     - `<!-- last-verified: YYYY-MM -->`  
  3. Add the spoke to the hub **Routing Map** and Problem Class table.  
  4. Summarize the same dependency for humans in `README.md` → **Dependencies & docs**
     (name, role, docs URL, link to the `.mdc` spoke).  

  Use `templates/rules/EXAMPLE-domain.mdc` as the shape. Delete `EXAMPLE-domain.mdc`
  when real spokes exist.

### 4. Skills

Ensure these exist and hard constraints match the product:

- `grill-me`, `task-1-plan`, `task-2-execute`, `task-3-complete`, `dialectic-of-cognition`, `audit-rules`, `setup-tasks`  
- Keep `bootstrap-turboplan` for future retargets  

Remove skills that only serve deleted stacks.

### 4b. Clean up installer leftovers

After verify gate files are adapted to root, delete these stale seeds:

```bash
rm -f planning/phases/_TEMPLATE.md
rm -f planning/_TEMPLATE.md
rm -f planning/phases/_INTENT_TEMPLATE.md
rm -rf planning/verify-SEED
rm -f planning/README-SEED.md
rm -f planning/gitignore-SEED
```

Keep `planning/checklists/`, `planning/intents/`, and `planning/spoke-seeds/`.

### 5. Git repo + verify tooling + lefthook (bootstrap acceptance — mandatory)

1. If `.git` is missing: `git init` in the project root (empty repo / first commit
   later is fine). If `.git` already exists, leave it — do not destroy history.  
2. **Ship the verify gate at project root** (adapt seeds; do not leave them only
   under `planning/`):
   - Prefer pack seeds: `templates/seeds/verify/` (after install:
     `planning/verify-SEED/`) — `Makefile`, `lefthook.yml`, `golangci.yml` →
     root as `Makefile`, `lefthook.yml`, `.golangci.yml` (rename for Go).  
   - Root **`Makefile`** must expose **`verify`** that runs **lint + test**
     (+ build when applicable). Document `make verify` and `make install-hooks`
     in hub Build & Run **and** README.  
   - Root **`lefthook.yml`**: pre-commit → `make verify` (not ad-hoc partial checks).  
   - Stack lint config (Go: **`.golangci.yml`**). Adapt if non-Go; do not skip.  
3. **Go projects (mandatory Makefile shape):** start from `seeds/verify/Makefile`
   and keep (or equivalent) targets:
   - `lint` — golangci-lint  
   - `test` — `go test ./...`  
   - `build` — host `go build ./...`  
   - `build-all` — multi-platform cross-compile into `dist/` (linux/darwin ×
     amd64/arm64 by default; override `BINARY` / `MAIN_PKG` / `GOOS_LIST`)  
   - `verify` — `lint` + `test` + `build` (this is the gate; not `build-all`)  
   - `fmt`, `vet`, `clean`, `install-hooks`, `help`  
   Adapt package paths (`MAIN_PKG`) to the real `cmd/` layout.  
4. Run **`lefthook install`** (or `make install-hooks`) so hooks are active in
   this clone.  
5. Bootstrap AC **fails** if any of these files are missing, if `verify` target is not
   lint+test(+build), or if hooks are not installed / do not invoke verify.
   **Do not require `make verify` to pass** — the repo has no source code yet.
   T01 creates the skeleton; verify first passes in T01.  
6. `/task-2-execute` and `/task-3-complete` must **hard-abort** when this tooling
   is later deleted — bootstrap must leave them unable to “pass” on tests alone.

### 6. Latest stable toolchain + packages (mandatory)

1. Install or upgrade the project's **primary language** to the **latest stable**
   release available for the host OS/arch (use the package manager the user
   already employs). Record the version in hub Build & Run + README Status.  
2. When scaffolding modules: use current stable dependency versions
   (`go get` current stables for Go, `go mod tidy`; for JS: `yarn` / `npm`
   stable versions; avoid knowingly unstable majors).  
3. Install lint/format tools at current stable (e.g. golangci-lint for Go,
   ESLint/Prettier for JS) so verify works.  
4. If policy or the machine blocks upgrades, list under **Bootstrap concerns**
   with the pinned version — do not silently stay on stale toolchains when an
   upgrade is possible.  

### 6b. `.gitignore` (mandatory)

Create or update root **`.gitignore`**. Prefer
`templates/seeds/gitignore/gitignore-SEED` / installed `planning/gitignore-SEED`
as a starting checklist, then **adapt with best judgment** for this product.

**Always include (unless the user explicitly wants otherwise):**

- Secrets / env: `.env`, `.env.*` (optionally allow `!.env.example` / `!.env.ref`)  
- Scratch: root-level `tmp/` (and similar local scratch dirs)  

**Stack-aware (enable what applies):**

- **Go:** binaries / `*.exe` / `*.test` / coverage profiles; local `bin/` or `dist/`
  if used; do not ignore source. Prefer not ignoring `vendor/` unless the project
  policy is to never commit it.  
- **Node / Astro / Vue / Wails frontend:** `node_modules/`, build outputs (`dist/`,
  `.astro/`, etc.), Yarn cache noise per project linker  
- **Python:** `__pycache__/`, `.venv/`  
- **OS / editors:** `.DS_Store`, common IDE folders if not already shared  

If `.gitignore` already exists: **merge** — add missing essential patterns; do not
wipe custom entries. Never commit real secrets to “fix” ignore gaps — fix the
ignore file instead.

### 5. Seed phases

1. Read **Slice shape** from the confirmed intent.
   - **Horizontal layers** (libraries, CLIs, infrastructure): order tasks so
     each layer is true before the next exists. Use the L0–L8 legend as the
     default bands.
   - **Vertical user paths** (a user action is the proof): each task is one
     path through the stack, still ordered by Depends-on, each path provable
     without the next path. Record the path name in Notes. `T01` is still the
     skeleton. The last task is still holistic proof.
2. Write `planning/phases/INDEX.md` with **Feature** `F01` on every row of
   this initial product, **Slice shape** in the header, and T01…Tnn.
3. Split a task before writing it when the title joins two capabilities with
   “and”, behavior acceptance criteria need more than five bullets, or the
   work touches two independent subsystems.

**T01 is always the skeleton (L0).**
It creates the minimal runnable program so that `make verify` passes:
- Go: `go mod init`, `cmd/<name>/main.go` (minimal entrypoint), `internal/`
  stubs, and the root Makefile verify target. No business logic.
- Other stacks: the minimal entrypoint and test that make `make verify` pass.
  No business logic.
- After T01, `make verify` must pass (lint + test + build on the skeleton).
4. Create each stub from the task template: Feature, Description, Requirements,
   Acceptance Criteria (the thing), Definition of Done pointer, empty Execution
   plan, Commits table, Depends-on, Next, Layer, Irreversible, Behavior change.
5. The final task is holistic proof.
6. Keep `planning/checklists/` in place (definition of done, security,
   observability).  

### 6. Human README.md (mandatory)

Create or rewrite root **`README.md`** for humans (not a dump of agent rules).

Prefer the pack seed `templates/seeds/readme/README-SEED.md` (after install:
`planning/README-SEED.md` if the installer copied it):

1. **ASCII banner** for the product name (block letters in a fenced `text` block)  
2. **Summary** — brief human-readable overview (2–4 sentences: what / who / done)  
3. **Table of Contents** — immediately below the summary (link major sections)  
4. **Emoji section headers** for the body (problem, fix, status, layout, deps, building, security, …)  
5. Pitch details, status pointing at `planning/phases/INDEX.md`  
6. Repo layout table  
7. **Dependencies & docs** table (synced with dep spokes from §3)  
8. **Building with Turboplan** section — link to
   [https://github.com/commoddity/turboplan](https://github.com/commoddity/turboplan)
   and show the plan → execute → complete loop; also link to INDEX  
9. Security / invariants relevant to humans  
10. Point methodology at [Turboplan](https://github.com/commoddity/turboplan)  

If a README already exists: adapt it to this shape — do not leave a stale fork
README that contradicts the new goal. Keep factual content that still applies.

**Ongoing:** as phases complete and architecture changes, keep README and rules
aligned (execute/complete/dialectic should update human docs when the story for
humans changed — not only `.mdc` files).

### 7. Self-check

- [ ] Domain Routing Map lists domain and dependency spokes only
- [ ] Craft table lists only file spokes that still exist; moment spokes are absent from both tables
- [ ] `debug.mdc`, `review.mdc`, and `decisions.mdc` exist, `alwaysApply: false`, no globs
- [ ] `LANGUAGE-craft.mdc` renamed; language spoke still has **After the new test is green**
- [ ] `ui.mdc` absent when there is no interface; `observability.mdc` absent for a one-shot CLI or library
- [ ] `planning/spoke-seeds/deprecation.mdc` present and not copied into `.cursor/rules/` unless this feature removes a public surface
- [ ] Git repo exists; root `Makefile` has `verify` (lint+test); lint config present;
      lefthook (or approved equivalent) installed and runs that verify on pre-commit
      (note: `make verify` may fail — no source code yet; T01 makes it pass)  
- [ ] Primary language (and other baseline tools) at **latest stable**; deps installed at current stables (or concern documented)  
- [ ] Root `.gitignore` present (`.env`/variants, `tmp/`, stack artifacts — merged if pre-existing)  
- [ ] Every provided dependency/docs set has a spoke with **Docs (if stuck)** URL + README row  
- [ ] Root `README.md` exists with ASCII banner, **Summary**, **TOC**, emoji headers, deps section  
- [ ] No leftover deleted-stack names in rules/skills (grep)  
- [ ] Every INDEX row has a stub  
- [ ] Depends-on graph acyclic; T01 actionable  
- [ ] No references to "Turboplan" in `.cursor/rules/general.mdc` (aside from the skills inventory which lists `bootstrap-turboplan` as a skill name)  
- [ ] Hub states stack choices as facts ("Uses Go 1.26+, React 19") not as methodology preferences ("Prefer Go", "Astro vs Vue vs Wails")
- [ ] "Karpathy Behavioral Guidelines" heading present in hub (not "Behavioral Guidelines")  
- [ ] No task IDs or layer tables in general.mdc (INDEX.md is the sole source of truth)  
- [ ] Confirmed intent file at `planning/intents/F01.md`; `{{QUALITY_BAR}}` filled in the hub
- [ ] INDEX header has slice shape; every row has Feature `F01` and a stub
- [ ] Hub still has Definition of Done, Commit messages (machine check), and Irreversible steps
- [ ] `planning/checklists/definition-of-done.md`, `security.md`, and `observability.md` present
- [ ] No product source for the chosen stack (Go: no `cmd/`, `internal/`, `pkg/`, `migrations/`)
- [ ] Installer leftovers cleaned (no `_TEMPLATE.md`, `_INTENT_TEMPLATE.md`, `verify-SEED/`, `README-SEED.md`, `gitignore-SEED`)
- [ ] T01 is the skeleton; after T01, `make verify` passes
- [ ] `setup-tasks` skill present in `.cursor/skills/` and listed in the hub skills inventory  

### 8. Output to user

```
## Bootstrap complete — {{PRODUCT}}

### Rules
- hub: …
- spokes: … (include dep spokes + docs URLs)
- file-craft kept: security | api | ui | observability
- moment spokes closed until a phase skill names them: debug, review, decisions
- deleted: …

### README
- path: README.md
- deps documented: …

### Gitignore
- patterns: .env* · tmp/ · <stack-specific> …

### Stack
- backend: {{BACKEND_LANG}}
- frontend: {{FRONTEND_FRAMEWORK}} | n/a
- concerns: … / none

### Git / hooks
- git: initialized | already present
- Makefile verify: present → `make verify` (= lint + test + build); Go also has `build-all`
- lint config: .golangci.yml | <stack> | MISSING (fail)
- lefthook: configured + installed → pre-commit runs make verify
- seeds: `templates/seeds/` → `planning/*-SEED*` → adapted to root
- toolchain: {{LANGUAGE}} <version> (latest stable) | pinned concern: …
- packages: latest stable baseline | concern: …

### Phases
- Feature: F01
- Slice shape: horizontal layers | vertical user paths
- T01…Tnn listed
- Intent: planning/intents/F01.md
- First action: /task-1-plan T01
- Commit subjects: `F01 Tnn Sn One sentence.`

### Skills
- adapted: …

### Review gate
Please confirm architecture + layer order + README before /task-1-plan T01.
```

## Do not

- Start `/task-2-execute` unless the user explicitly chains it  
- Invent PBIs outside `planning/phases` unless the repo already uses another backlog and the user asks to bridge  
- Copy secrets from references into the repo  
- Skip git init / Makefile verify / lefthook and call bootstrap done  
- Leave verify seeds only under `planning/` without copying adapted files to project root  
- Leave any "Turboplan" reference in `.cursor/rules/general.mdc` (the skill inventory listing `bootstrap-turboplan` is the only exception)
- State stack choices as methodology preferences — state them as facts  
- Skip a dep/docs spoke when the user named that dependency or provided its docs  
- Skip creating/updating human `README.md`  
- Skip creating/updating `.gitignore` (or leave secrets/tmp unignored)
- Copy a Go Makefile and `.golangci.yml` into a project whose stack is not Go
- Drop Definition of Done, Commit messages, or Irreversible steps while rewriting the hub
- Cite a dependency doc you did not open in this session

## Common rationalizations

| Excuse | Required action |
| ------ | --------------- |
| “The seed Makefile is close enough for this stack.” | Adapt verify to the stack the human named. A Go seed on a non-Go repo is a failed bootstrap. |
| “They described the goal in chat, so an intent file is duplicate.” | Write `planning/intents/F01.md` after an explicit yes. Later sessions do not have the chat. |
| “Horizontal layers are always right.” | Read slice shape from the intent. User-path products get vertical slices. T01 stays the skeleton. |
| “I’ll scaffold `cmd/` so T01 is easier.” | T01 creates product source. Bootstrap stops at the operating files. |
| “Sounds good, I’ll start planning T01.” | The review gate waits for the human to confirm architecture, slice shape, and README. |

## Red flags

- Product source created during bootstrap
- Hub missing the commit machine check or the definition of done
- INDEX rows without a Feature id
- A spoke whose Docs URL was not opened
- `{{QUALITY_BAR}}` left unsubstituted
- Checklists deleted as “installer leftovers”

## Under pressure

- “The user wants to see the app compile today.” → T01 is the compile. Bootstrap’s done state is rules, phases, intent, verify gate, and README.
- “Skip grill, the README pitch is enough.” → Vague scope stops bootstrap. Confirmed intent, or an explicit yes on your restatement, comes first.

## Verification

- [ ] Self-check list above is all true
- [ ] Intent file status is Confirmed
- [ ] Slice shape is written on the INDEX
- [ ] No product source tree
- [ ] Output names the first action `/task-1-plan T01` and stops there
  

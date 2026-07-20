---
name: bootstrap-turboplan
description: >
  From a written product goal, adapt .cursor/rules and .claude/skills, create
  CLAUDE.md symlink, seed planning/phases, create dependency rule spokes from
  provided docs, write a human README.md, and an appropriate .gitignore.
  Manual only — /bootstrap-turboplan. Does not implement product features.
disable-model-invocation: true
allowed-tools: Bash, Read, Grep, Glob, Edit, Write, WebFetch, WebSearch
---

# /bootstrap-turboplan — Goal → rules + phases + skills + human README

You install or retarget **Turboplan** for this repository. You produce agent
operating infrastructure **and** a human-facing `README.md`. You **do not**
implement product features.

**Two audiences (keep in sync as the project grows):**

| Audience | Primary artifacts |
| -------- | ----------------- |
| **LLMs / agents** | `.cursor/rules/*.mdc`, `.claude/skills/*/SKILL.md` |
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

**CRITICAL — context gathering is mandatory.** If the user invokes `/bootstrap-turboplan`
without a detailed goal and technical description, you MUST ask for them before
proceeding. Do not invent the goal. Do not guess the stack. Ask:

1. What does the user get when the project is done? (end-user perspective)
2. What is the technical scope? (language, runtime, OS, packaging, architecture)
3. What is explicitly out of scope?
4. What dependencies or external APIs will it use?
5. Are there reference implementations to study?

If the answer is vague, ask follow-ups until you have enough to produce an accurate
hub + spokes + phase plan. A human who won't answer these questions isn't ready to
bootstrap — stop and say so rather than producing a wrong architecture.

## Hard constraints

1. Write rules only under `.cursor/rules/`. Never create `.claude/rules/`.  
2. Ensure `CLAUDE.md` → symlink to `.cursor/rules/general.mdc`.  
3. Delete spokes/skills that cannot apply; replace wrong-provider files (do not light-edit).  
4. Seed `planning/phases/INDEX.md` + one stub file per INDEX row.  
5. Adapt skill hard constraints to **this** product.  
6. Do not commit unless the user explicitly asks.  
7. Do not implement product features in this skill (verify scaffolding / lefthook /
   README / `.gitignore` / rule spokes from docs **are** in scope).  
8. Bootstrap AC requires **git repo + verify gate + lefthook**:
   root `Makefile` with `verify` (lint+test+build for Go), stack lint config, and
   pre-commit → that verify. Seeds live under `templates/seeds/` (after install:
   `planning/README-SEED.md`, `planning/gitignore-SEED`, `planning/verify-SEED/`).
   Seeds under `planning/` alone are **not** enough — adapted copies must land
   at repo root + hooks installed. Go Makefiles must include `lint`, `test`,
   `build`, multi-platform `build-all`, and `verify` (= lint+test+build).  
9. Default stack: **Go** backend; **Astro** / **Vue** / **Wails** per frontend need — raise exceptions as concerns.  
10. Prefer **latest stable** toolchain and package versions (Go + deps + frontend
    tooling); raise a concern if the environment cannot upgrade.  
11. For every named dependency / provided doc set that agents will use: create a
    **dedicated spoke** under `.cursor/rules/` with an **External docs** link to
    the official source, and mirror a short human summary in `README.md`.  
12. Create or replace root **`README.md`** with: emoji section headers; ASCII
    banner; a brief human **Summary**; a **Table of Contents** immediately under
    the summary; then the body sections — humans read this; agents read rules/skills.  
13. Create or update root **`.gitignore`** appropriate to the stack — use best
    judgment (always secrets + scratch; language/tooling artifacts as needed).  

## Procedure

### 1. Inventory current agent files

List `.cursor/rules/*.mdc` and `.claude/skills/*/SKILL.md`. Classify each:
DELETE / ADAPT / KEEP (per Turboplan Guide 01).

### 2. Rewrite hub

Update `.cursor/rules/general.mdc`:

- **Preserve (do not dilute):** Karpathy Behavioral Guidelines (full four sections);
  Cross-Cutting Engineering Standards (Go / Astro·Vue·Wails / tests / lint /
  git+lefthook / latest-stable toolchain / complete push+manual-test);
  **Model split** (expensive plan → cheap execute + handoff bar);
  and Rule Maintenance / dialectic steps **0–7** — rewrite product-specific
  examples only, never replace these with shorter paraphrases  
- Product name, architecture, build/verify, safety no-gos  
- Routing Map + Problem Class table for new spokes (include every dep spoke)  
- Skills inventory  
- Layered delivery pointing at `planning/phases/INDEX.md`  
- Dialectic *examples* from **this** domain (failure-mode illustrations only)  
- Encode stack choices (Go vs exception; Astro / Vue / Wails) in Architecture;
  if proposing non-default stack, list it under **Bootstrap concerns**  

### 3. Spokes (domains + dependency docs)

- Delete obsolete  
- Create/adapt **product domain** spokes with invariants + at least one symptom table skeleton  
- Language craft spoke if applicable (`go.mdc`, etc.)  
- **Dependency / docs spokes (mandatory when deps or docs are provided):**

  For each library, framework, CLI toolkit, or external API the Goal/Constraints/
  Dependencies/References name (e.g. Cobra, Moonshot API, Cloudflare):

  1. Prefer **official documentation** (fetch or use provided URLs).  
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

- `task-1-plan`, `task-2-execute`, `task-3-complete`, `dialectic-of-cognition`, `audit-rules`  
- Keep `bootstrap-turboplan` for future retargets  

Remove skills that only serve deleted stacks.

### 5. CLAUDE.md

```bash
ln -sf .cursor/rules/general.mdc CLAUDE.md
```

### 6. Git repo + verify tooling + lefthook (bootstrap acceptance — mandatory)

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
5. Bootstrap AC **fails** if any of these are missing, if `verify` is not
   lint+test(+build), or if hooks are not installed / do not invoke verify.  
6. `/task-2-execute` and `/task-3-complete` must **hard-abort** when this tooling
   is later deleted — bootstrap must leave them unable to “pass” on tests alone.

### 6b. Latest stable toolchain + packages (mandatory)

1. Install or upgrade **Go** to the **latest stable** release available for the
   host OS/arch (official tarball, `mise`/`asdf`, or package manager — prefer
   what the user already uses). Record the version in hub Build & Run + README Status.  
2. When scaffolding modules: use current stable dependency versions
   (`go get` current stables, `go mod tidy`; for JS: current stable Astro/Vue/Wails
   and Yarn Berry as required — avoid knowingly unstable majors).  
3. Install lint/format tools at current stable (e.g. golangci-lint) so verify
   works.  
4. If policy or the machine blocks upgrades, list under **Bootstrap concerns**
   with the pinned version — do not silently stay on stale toolchains when an
   upgrade is possible.  

### 6c. `.gitignore` (mandatory)

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

### 7. Seed phases

1. Derive layered build order from the goal (Guide 02)  
2. Write `planning/phases/INDEX.md` with T01…Tnn  
3. Create each stub from the Turboplan task template (Description, Requirements, AC, empty Execution plan section, Depends-on, Next, Layer)  
4. Final task should be E2E / holistic verification  
5. Early tasks should include verify wiring / sample test+lint green if scaffold exists  

### 8. Human README.md (mandatory)

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

### 9. Self-check

- [ ] Routing Map ↔ rule files bijection  
- [ ] `CLAUDE.md` symlink OK  
- [ ] Cross-Cutting Engineering Standards still present in hub  
- [ ] Git repo exists; root `Makefile` has `verify` (lint+test); lint config present;
      lefthook (or approved equivalent) installed and runs that verify on pre-commit  
- [ ] Go (and other baseline tools) at **latest stable**; deps installed at current stables (or concern documented)  
- [ ] Root `.gitignore` present (`.env`/variants, `tmp/`, stack artifacts — merged if pre-existing)  
- [ ] Every provided dependency/docs set has a spoke with **Docs (if stuck)** URL + README row  
- [ ] Root `README.md` exists with ASCII banner, **Summary**, **TOC**, emoji headers, deps section  
- [ ] No leftover deleted-stack names in rules/skills (grep)  
- [ ] Every INDEX row has a stub  
- [ ] Depends-on graph acyclic; T01 actionable  
- [ ] Non-default language/frontend choices listed as bootstrap concerns (or Go/Astro·Vue·Wails defaults adopted)  

### 10. Output to user

```
## Bootstrap complete — {{PRODUCT}}

### Rules
- hub: …
- spokes: … (include dep spokes + docs URLs)
- deleted: …

### README
- path: README.md
- deps documented: …

### Gitignore
- patterns: .env* · tmp/ · <stack-specific> …

### Stack
- backend: Go (default) / <exception + rationale>
- frontend: Astro | Vue | Wails | n/a
- concerns: … / none

### Git / hooks
- git: initialized | already present
- Makefile verify: present → `make verify` (= lint + test + build); Go also has `build-all`
- lint config: .golangci.yml | <stack> | MISSING (fail)
- lefthook: configured + installed → pre-commit runs make verify
- seeds: `templates/seeds/` → `planning/*-SEED*` → adapted to root
- toolchain: Go <version> (latest stable) | pinned concern: …
- packages: latest stable baseline | concern: …

### Phases
- T01…Tnn listed
- First action: /task-1-plan T01

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
- Silently choose a non-Go backend without a bootstrap concern  
- Leave an upgradeable toolchain on an old stable without documenting a concern  
- Skip a dep/docs spoke when the user named that dependency or provided its docs  
- Skip creating/updating human `README.md`  
- Skip creating/updating `.gitignore` (or leave secrets/tmp unignored)  
- Put framework tutorial essays only in README with no matching `.mdc` (or only in `.mdc` with no README mention) — keep both audiences covered  

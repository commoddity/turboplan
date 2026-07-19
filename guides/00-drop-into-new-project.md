# Guide 00 — Drop Turboplan into a new project

## Goal

Given a blank or existing repo and a written product goal, produce a working Turboplan install: rules, skills, `CLAUDE.md`, and a layered phase INDEX + stubs — **without implementing product features yet**.

## Inputs you must provide the agent

1. **Goal** (1–3 paragraphs): what users get when done  
2. **Non-goals** (bullets): what MVP will not include  
3. **Constraints**: language/runtime, OS, “no Docker”, licensing, secrets policy, etc.  
4. **Inspiration / references** (optional): paths or URLs to study — “reimplement, do not vendor”  
5. **Layer preference** (optional): if you already know the build order  

## Procedure

### Step 1 — Install templates (script)

From the **Turboplan pack** repo (Mac / Linux):

```bash
./scripts/install-into.sh /absolute/path/to/YOUR_PROJECT
```

That copies rules, skills, phase skeletons, and **`templates/seeds/`**
(readme · gitignore · verify) into `planning/*-SEED*`, then creates
`CLAUDE.md` → `.cursor/rules/general.mdc`.

Manual `cp -R` is unnecessary unless you are debugging the installer — prefer the script.

### Step 2 — Invoke bootstrap

In Cursor or Claude Code:

```text
/bootstrap-turboplan

Goal: …
Non-goals: …
Constraints: …
References: …
```

The skill will:

- Rewrite `general.mdc` for this product  
- Delete / create domain spokes  
- Create **dependency/docs spokes** (e.g. `cobra.mdc` + official docs URL) for named libs  
- Rewrite skill hard constraints  
- Prefer **latest stable** Go + packages for the baseline toolchain  
- Ensure git + **verify gate** (root `Makefile` with `verify` = lint+test+build,
  lint config, lefthook pre-commit→verify; hooks installed). For **Go**, Makefile
  also includes multi-platform `build-all`. Seeds under `planning/` must be
  adapted to **repo root**.  
- Write/update human **`README.md`** (ASCII banner + Summary + TOC + emoji headers + Dependencies & docs)  
- Create/update **`.gitignore`** (`.env*`, `tmp/`, stack-aware artifacts)  
- Fill `planning/phases/INDEX.md` + create `T01-….md` … stubs  
- Run a self-check (routing map vs files, symlink, first task, README, gitignore, verify tooling)

### Step 3 — Human review gate

Before `/task-1-plan T01`, skim:

- [ ] Architecture section matches your intent  
- [ ] Layer order is sensible  
- [ ] Task count is enough but not microscopic noise  
- [ ] Safety no-gos match your policy (commits, pushes via complete, secrets, package managers)  
- [ ] Toolchain versions look like latest stable (or an accepted pin)  
- [ ] Each major dependency has a rules spoke + README docs row  
- [ ] `README.md` is readable for humans (Summary + TOC + emoji sections; not only an agent rules dump)  
- [ ] `.gitignore` covers env secrets, `tmp/`, and language build outputs  
- [ ] Root `Makefile` / `lefthook.yml` / lint config present (bootstrap shipped verify gate)  

### Step 4 — Enter the loop

```text
/task-1-plan T01
/task-2-execute T01
/task-3-complete T01
# optional: /task-3-complete T01 --no-push
```

`/task-3-complete` commits, **pushes by default**, gives **Manual test** commands
(or `Nothing to test` + why), then checks out the next stub-stem branch.

See [`03-run-the-loop.md`](03-run-the-loop.md).

## Isolation note

When capturing Turboplan learnings into a pack under `tmp/`, treat the **rest of the host repo as read-only**. Never edit live `.cursor/rules` or product code as a side effect of documenting the methodology.

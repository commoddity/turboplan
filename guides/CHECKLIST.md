# Turboplan drop-in checklist

Use this when copying the pack into a project. Check boxes as you go.

## A. Copy

- [ ] Ran `./scripts/install-into.sh /absolute/path/to/YOUR_PROJECT`  
- [ ] `.cursor/rules/general.mdc` present  
- [ ] Domain spokes created/adapted after bootstrap (delete `EXAMPLE-domain.mdc` when done)  
- [ ] Dependency/docs spokes present for every named library (official Docs URL + README row)  
- [ ] Root `README.md` has ASCII banner + **Summary** + **TOC** + emoji headers + Dependencies & docs  
- [ ] Root `.gitignore` ignores `.env`/variants, `tmp/`, and stack build artifacts  
- [ ] Installer left `planning/README-SEED.md`, `planning/gitignore-SEED`, `planning/verify-SEED/` (from `templates/seeds/`)  
- [ ] `planning/verify-SEED/` present (`Makefile`, `lefthook.yml`, lint config seed) from `templates/seeds/verify/`  
- [ ] After bootstrap: root `Makefile` / `lefthook.yml` / `.golangci.yml` (Go) — not only under `planning/`  
- [ ] Go Makefile includes `lint`, `test`, `build`, `build-all` (cross-compile), `verify`  
- [ ] `.claude/skills/{bootstrap-turboplan,task-1-plan,task-2-execute,task-3-complete,dialectic-of-cognition,audit-rules}/` present  
- [ ] `planning/phases/` directory exists (`INDEX.md` + `_TEMPLATE.md`)  
- [ ] `CLAUDE.md` → `.cursor/rules/general.mdc`  

## B. Bootstrap

- [ ] Hub retains full **Karpathy Behavioral Guidelines** + **Cross-Cutting Engineering Standards** + Rule Maintenance **0–7** (not paraphrased away)  
- [ ] Git repo present; root **`Makefile`** with **`verify`** (lint+test+build for Go); lint config;
      **lefthook** installed and runs that verify on pre-commit; Go also has `build-all`  
- [ ] Go + baseline tools/deps at **latest stable** (or pinned older version listed as bootstrap concern)  
- [ ] Invoked `/bootstrap-turboplan` with Goal / Non-goals / Constraints / References  
- [ ] Hub architecture matches intent  
- [ ] Obsolete stack rules deleted  
- [ ] Routing Map lists every spoke  
- [ ] Skill hard constraints match product  
- [ ] INDEX has T01…Tnn with Depends-on / Next / Layer  
- [ ] Every INDEX row has a stub with AC  
- [ ] Grep clean of deleted-stack names  

## C. Human review gate

- [ ] Layer order approved  
- [ ] Safety no-gos approved  
- [ ] First task is the right starting point  

## D. Loop

- [ ] `/task-1-plan T01`  
- [ ] `/task-2-execute T01` (hard-aborts if Makefile/lefthook/lint config missing)  
- [ ] `/task-3-complete T01` (same presence abort; pushes by default; `--no-push` if local-only; Manual test handoff present)  
- [ ] Continue until INDEX complete or pause  

## E. Hygiene

- [ ] Periodic `/audit-rules`  
- [ ] Dialectic after hard sessions (also via task-3-complete)  

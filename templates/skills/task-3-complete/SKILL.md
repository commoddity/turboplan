---
name: task-3-complete
description: >
  Close out one MVP phase task: re-run lint+test verify, dialectic, mark INDEX ✅,
  commit, push branch by default (opt out with --no-push), give manual test
  commands, checkout next stub-stem branch. Manual only — /task-3-complete TXX [--no-push].
disable-model-invocation: true
allowed-tools: Bash, Read, Grep, Glob, Edit, Write
---

# /task-3-complete — Close one MVP phase task

Run after `/task-2-execute TXX` when acceptance criteria pass. You **do not**
implement product features here — you re-verify, capture learnings, sync the
backlog, mark the INDEX complete, **commit**, **push** (unless `--no-push`),
give the user **manual test** commands, and **start the next task branch**.

Usually safe on a **smaller / cheaper** model (mechanical verify + dialectic
triage + git). If dialectic Mode A/B looks like a deep novel failure mode, you
may recommend the user re-run dialectic on a large model — do not block close-out
on that alone when verify is green and AC passed.

## Arguments

- Task id: `T01` … `Tnn`  
- Optional flag: **`--no-push`** — commit locally and continue, but **do not**
  `git push`  
- If task id omitted: INDEX `InProgress`, else most recently executed in this conversation  

Examples:

```text
/task-3-complete T04
/task-3-complete T04 --no-push
```

## Hard constraints

1. Coding learnings only via `/dialectic-of-cognition` → `.cursor/rules/*.mdc`.  
2. Do not invent downstream scope; only fix stale assumptions in later stubs.  
3. INDEX completed status is **`✅`** — never write `Done` in the INDEX Status column.  
4. **Re-run the full lint + test (verify) suite** before marking complete or
   committing. Prefer **`make verify`**. Auto-fix first; remaining lint failures
   block close-out.  
4a. **Verify tooling presence (hard abort):** Same as `/task-2-execute` — require
    root `Makefile` with `verify` (lint+test), stack lint config (Go: `.golangci.yml`),
    and `lefthook.yml` (pre-commit → verify). If missing: **stop** — do not mark ✅,
    do not commit, do not push. Tell the user to restore verify tooling first.
    Never treat package tests alone as the complete gate.  
5. Commit is **part of this skill** when the user invoked `/task-3-complete`:  
   - Never update git config  
   - Never `--trailer` / Co-authored-by  
   - Never force-push  
   - Do not commit secrets  
   - Prefer committing only when pre-commit (lefthook) would also pass  
6. **Push by default** after a successful commit (`git push -u origin HEAD`
   when upstream is unset). Skip push only if **`--no-push`** was provided.  
7. Close-out **must** include a **Manual test** section (commands + what to
   look for), or **`Nothing to test`** with a clear reason.

## Branch naming

- Branch = stub **filename** without `.md` (no folder path): `<stub-stem>`
  - Example: `T01-scaffold-config-slog` (not `planning/phases/T01-scaffold-config-slog`)
  - Next: stub-stem of the task named in **Next** (not `task-TYY`)
- Do **not** use `task-TXX` / `task-TYY`.
- Do **not** prefix with `planning/phases/`.

If not on the current stub-stem branch, warn and checkout/create it — do not commit on `main` by surprise.

## Procedure

### 1. Preconditions

- AC passed (or already complete)  
- If Blocked / failed: stop  
- Note whether `--no-push` is set  

### 2. Verify gate (mandatory)

**Presence check first** (fail closed):

```bash
test -f Makefile && grep -q '^verify' Makefile
test -f lefthook.yml
test -f .golangci.yml   # Go
make verify
```

If tooling is missing: stop — do not dialectic-mark-complete, commit, or push.
Re-run **`make verify`**. If it fails: stop — send back to execute/fix.

Record results in the task **Verification** section if not already current.

### 3. Dialectic (mandatory)

Fully execute `.claude/skills/dialectic-of-cognition/SKILL.md`
(Modes A/B for this project).

### 4. Downstream task sync

If this task changed package layout, defaults, branding, or abandoned approaches,
add **Reality notes** (or amend AC) on later stubs. Do not mark them complete.
If the change altered what humans need to know (new deps, layout, how to run),
update root **`README.md`** in the same close-out (Dependencies & docs / Status /
layout). If nothing stale: say so.

### 5. Mark complete

1. Task file Status → `Done`; fill Learnings  
2. INDEX Status → **`✅`**  
3. Status History rows on both  

### 6. Commit on current stub-stem branch

```bash
git add -A
git commit -m "$(cat <<'EOF'
TXX Short description of what this task delivered.

EOF
)"
```

Pre-commit hooks (lefthook) should run verify; if the hook fails, fix and create
a **new** commit — do not `--no-verify` unless the user explicitly overrides.

### 7. Push (default)

Unless **`--no-push`**:

```bash
git push -u origin HEAD
```

If `origin` is missing, say so, skip push, and tell the user how to add a remote
— do not invent remotes. Never `--force`.

### 8. Manual test handoff (mandatory)

Write commands the **human** can run to manually exercise this task’s change.
Be concrete for the stack (Go server → run binary/`go run` + `curl`; CLI →
example invocations; frontend → `yarn dev` + URL; Wails → `make run`; etc.).

Include:

- How to start / invoke  
- Example request or UI path  
- What success looks like  

If not applicable (pure docs, rules-only, unreachable without later tasks):

```text
Nothing to test — <one-sentence why>
```

### 9. Checkout next branch

```bash
git checkout -b <next-stub-stem>
# or: git checkout <next-stub-stem> if exists
# e.g. T02-secrets-gateway-key
```

Do not implement TYY here.

### 10. Output format

```
## Completed — TXX Title
### Verify
- lint: …
- tests: …
### Dialectic
…
### Downstream updates
- none / …
### INDEX
TXX → ✅
### Git
- Branch: <stub-stem>
- Commit: …
- Push: pushed to origin | skipped (--no-push) | skipped (no origin): …
- Now on: <next-stub-stem>
### Manual test
<commands + what to look for>
# or: Nothing to test — <why>
### Next
/task-1-plan TYY
```

## Do not

- Start the next task’s implementation  
- Write `Done` into the INDEX Status column  
- Skip dialectic when triggers fired  
- Skip lint+test verify  
- Close out when Makefile / lefthook / lint config are missing (presence abort)  
- Use `--no-verify` / skip hooks without explicit user approval  
- Skip the default push when `--no-push` was **not** set and `origin` exists  
- Force-push  
- Omit Manual test / Nothing to test  

---
name: task-3-complete
description: >
  Close out one phase task: re-run verify, apply the definition of done,
  dialectic, mark INDEX ✅, commit close-out as Fnn Tnn Sn, push unless
  --no-push, manual test, next stub branch. Manual only —
  /task-3-complete TXX [--no-push].
disable-model-invocation: true
allowed-tools: Bash, Read, Grep, Glob, Edit, Write, Task
---

# /task-3-complete — Close one phase task

Run after `/task-2-execute TXX` when acceptance criteria pass. You re-verify,
apply the definition of done, capture learnings, mark the INDEX complete,
**commit the close-out**, **push** (unless `--no-push`), give the human a
manual test, and check out the next task branch.

You do not start new product behavior here.

Use a **medium or small** model: medium when dialectic has a real pattern to
encode, small for a routine close-out. When dialectic looks like a novel
failure mode, say so and offer a large-model rerun of dialectic. Do not block
a green close-out on that offer.

> Model sizing is a recommendation. See the project README under Model
> recommendations.

## Arguments

- Task id: `T01` … `Tnn`
- Optional **`--no-push`** — commit locally, do not `git push`
- If the id is omitted: the INDEX row that is `InProgress`

```text
/task-3-complete T04
/task-3-complete T04 --no-push
```

## Hard constraints

1. Coding learnings go through `/dialectic-of-cognition` into `.cursor/rules/*.mdc`.
2. Do not invent downstream scope. Only repair stale assumptions in later stubs.
3. INDEX completed status is **`✅`**. Never write `Done` in that column.
4. Re-run **`make verify`** before marking complete or committing. Lint
   failures block close-out.
5. **Verify tooling presence (hard abort).** Same bar as execute: root
   `Makefile` `verify` (lint + test, plus build when wired), the hook runner
   the hub names (`lefthook.yml` by default) invoking that verify, and the
   lint config named in the hub (Go: `.golangci.yml`). Missing toolchain:
   stop. Do not mark ✅, commit, or push.
6. **Definition of Done** in the hub, fully applied from
   `planning/checklists/definition-of-done.md`. Acceptance criteria alone do
   not close the task.
7. Commit subjects follow **Commit messages** in the hub. Example:
   `F01 T04 S4 Record close-out for the tunnel supervisor.`
   Machine check:

   ```
   ^F[0-9]{2,} T[0-9]{2,} S[1-9][0-9]* [A-Z][^.!?]*\.$
   ```

   One line, one sentence, no trailer, no `Co-authored-by`. Stage named paths.
   `git add -A` is forbidden. Never update git config. Never force-push. Never
   commit secrets. Never `--no-verify` unless the user explicitly overrides
   after seeing the hook failure.
8. **Push by default** after the close-out commit (`git push -u origin HEAD`
   when no upstream). Skip push only with **`--no-push`**, or when `origin`
   is missing (say so; do not invent a remote).
9. Close-out includes a **Manual test** section, or **`Nothing to test`** with
   a reason.
10. Do not commit on `main` or `master`.

## Branch naming

Branch = the stub filename without `.md`: `T01-scaffold-config-slog`.

Next branch = the stub stem of the task named in **Next**.

Do not use `task-TXX` or a `planning/phases/` prefix.

If you are not on the current stub stem, check it out before committing.

## Procedure

### 1. Preconditions

- Acceptance criteria passed, or the task is already complete
- Blocked or failed: stop
- Note whether `--no-push` is set
- Read the feature intent and the task **Commits** table

### 2. Verify gate

```bash
test -f Makefile && grep -q '^verify' Makefile
test -f lefthook.yml
# lint config named in the hub; Go: test -f .golangci.yml
make verify
```

Missing toolchain or a red verify: stop. Do not dialectic-mark-complete,
commit, or push. Record the commands in **Verification**.

### 3. Definition of Done

Read `planning/checklists/definition-of-done.md` and check every item.

Also load:

- `planning/checklists/security.md` when the task accepts untrusted input,
  changes auth, touches secrets, or paused as irreversible
- `planning/checklists/observability.md` when the task adds a server, daemon,
  worker, or other long-running path. Otherwise write **Nothing to observe**
  plus one sentence why

Unchecked items block close-out. Record results in **Verification**. The
checklists are the gates. Reopen a craft spoke only when an item fails and you
need the build rule. Leave `debug.mdc`, `review.mdc`, and `decisions.mdc` closed.

### 4. Dialectic

Fully execute `.cursor/skills/dialectic-of-cognition/SKILL.md` (Modes A and B).

### 5. Downstream sync

When this task changed layout, defaults, branding, or an abandoned approach,
add **Reality notes** on later stubs. Do not mark them complete. When humans
need to know (new deps, layout, how to run), update root `README.md`. A large
README rewrite may go to a doc-writer subagent. When nothing is stale, say so.

### 6. Product files still dirty

List `git status`. Paths that are product code (not the close-out set below)
and are still uncommitted get **their own commit first**, with the next `S`
id and a sentence that describes that diff only.

Close-out paths, committed in the following step, not in the product commit:

- this task file
- `planning/phases/INDEX.md`
- later stubs’ reality notes edited in this skill
- `.cursor/rules/**` edited by dialectic
- `README.md` when step 5 changed it
- `planning/checklists/**` when this skill edited them

When the dirty product diff is unfinished or the sentence is not obvious,
stop and return to `/task-2-execute`. Do not mix that diff into the close-out
commit.

Next `S` id = one greater than the highest `S` for this feature and task in
the Commits table and in `git log --format=%s`.

### 7. Mark complete

1. Task file Status → `Done`. Fill **Learnings**.
2. INDEX Status → **`✅`**
3. Status History on both
4. Fill **Manual test** (see step 9) before the close-out commit so the
   section is in the commit

### 8. Close-out commit

1. Fill SHA cells for every existing **Commits** row by matching the subject
   to `git log --format=%h %s`. Leave a cell as `—` only when git has no
   matching subject.
2. Choose the close-out subject. Append that row with SHA `—`. This row stays
   `—`: the commit that records it cannot contain its own SHA. Look that one
   up with `git log -1 --oneline`. Do not add a commit whose only job is to
   store a SHA.
3. Stage only close-out paths and commit:

```bash
git add -- planning/phases/<this-task>.md planning/phases/INDEX.md
# plus any rule, README, or later-stub paths this skill actually changed
git commit -m "$(cat <<'EOF'
F01 T04 S4 Record close-out for the tunnel supervisor.
EOF
)"
```

The sentence matches the machine check and is the only line in the message.
If the hook fails, fix and create a **new** commit with the next `S` id.
Do not amend. Do not `--no-verify`.

### 9. Push

Unless `--no-push`:

```bash
git push -u origin HEAD
```

This pushes every local `S` commit on the branch, including execute’s.
Never `--force`.

### 10. Manual test

Commands the human can run. Include how to start, an example invocation, and
what success looks like. When the task is unreachable without later work:

```text
Nothing to test — <one sentence why>
```

### 11. Next branch

```bash
git checkout -b <next-stub-stem>
```

Or check it out when it already exists. Do not implement that task.

### 12. Output

```
## Completed — TXX Title
### Verify
- lint / test / build: …
### Definition of done
- security: reviewed | not applicable
- observability: … | Nothing to observe — …
### Dialectic
…
### Downstream updates
- none / …
### INDEX
TXX → ✅
### Git
- Branch: <stub-stem>
- Commits: Fnn Tnn S1 … through Fnn Tnn Sn …
- Push: pushed to origin | skipped (--no-push) | skipped (no origin)
- Now on: <next-stub-stem>
### Manual test
…
### Next
/task-1-plan TYY
```

## Do not

- Start the next task’s implementation
- Write `Done` in the INDEX Status column
- Skip dialectic when its triggers fired
- Skip `make verify` or the definition of done
- Close out with the verify toolchain missing
- Push from a skill other than this one
- Force-push
- Use `git add -A`
- Omit manual test
- Use a commit subject that fails the machine check

## Common rationalizations

| Excuse | Required action |
| ------ | --------------- |
| “Dialectic can wait; the diff is the record.” | Chat is not a spoke. Run dialectic. Encode or say the session was routine. |
| “Tests passed, so it is done.” | Apply `planning/checklists/definition-of-done.md`. |
| “`git add -A` will catch the close-out.” | Stage the close-out paths. Product dirt gets its own sentence first. |
| “Execute already verified, skip make verify.” | Re-run it. Close-out can dirty the tree. |
| “The user is in a hurry, push from here without the manual test.” | Manual test, or `Nothing to test` plus why, is part of the commit. |
| “A free-form message explains the close-out better.” | One sentence, three identifiers, machine check. |

## Red flags

- INDEX marked ✅ before verify is green
- Push with product files still unstaged and unexplained
- Close-out subject that describes new behavior instead of the close-out
- Security or observability checklist skipped on a task that required it
- Commit on `main` or `master`
- `--no-verify` or `--force`

## Under pressure

- “Authority says mark it done and push.” → Verify, definition of done, and the commit format still apply. Then push.
- “Skip dialectic, we already know the lesson.” → The lesson goes in a spoke, or the output says the session was routine.
- “Amend the last execute commit so history is one commit.” → Do not amend. The close-out is the next `S` id.

## Verification

- [ ] `make verify` re-run and green
- [ ] Definition of done checklist applied; security and observability loaded or explicitly not applicable
- [ ] Dialectic ran
- [ ] INDEX shows ✅
- [ ] Every new subject matches the machine check
- [ ] Push happened, or `--no-push` / missing origin is stated
- [ ] Manual test section present
- [ ] Worktree is on the next stub branch and that task was not implemented

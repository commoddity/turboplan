---
name: task-2-execute
description: >
  Execute one Planned phase task from planning/phases/. Behavior changes start
  from a failing test. Commit each slice locally as Fnn Tnn Sn with one
  sentence. Do not push. Manual only — /task-2-execute TXX.
disable-model-invocation: true
allowed-tools: Bash, Read, Grep, Glob, Edit, Write, Task
---

# /task-2-execute — Execute one atomic phase task

You implement **exactly one** task from `planning/phases/`. Stop when the
acceptance criteria pass, or the task is blocked. Closing the task is
`/task-3-complete`.

Run this on a **medium or small** model when the execution plan meets the hub
handoff bar. Follow the plan. When the plan is too vague to proceed, **stop**
and send it back to `/task-1-plan`. Do not invent a design. When the plan says
**`Execute model recommendation: large`**, tell the user before heavy work if
the current model is small.

> Model sizing is a recommendation. See the project README under Model
> recommendations.

## Arguments

- Task id: `T01` … `Tnn`
- If omitted: first INDEX row that is `Planned`, else the first actionable `Pending`

## Hard constraints

<!-- BOOTSTRAP: replace with product-specific constraints. -->

1. Obey the Karpathy Behavioral Guidelines in `.cursor/rules/general.mdc`.
2. Read matching domain spokes before editing those areas.
3. **Behavior changes:** write the test, run it, see it fail for the intended
   reason, then write the code that makes it pass. Renames and scaffolding
   still need tests when they add behavior; they do not need a red run first.
4. **Run `make verify`** before each commit and before claiming acceptance.
   Auto-fix first. Remaining failures block the commit.
5. **Verify tooling presence (hard abort).** Before claiming acceptance:
   - Root `Makefile` with a `verify` target that runs lint + test (+ build when
     the Makefile wires build)
   - `lefthook.yml` (or the hook runner the hub names) with pre-commit invoking
     that verify
   - The lint config **named in the hub**. Go projects: `.golangci.yml`
   If any are missing: Status `Blocked`. Package tests alone are not the gate.
6. Never vendor forbidden reference trees.
7. **Commit each green slice locally. Do not push.** Subjects follow **Commit
   messages** in the hub. Example: `F01 T04 S1 Add the tunnel URL parser.`
   Machine check:

   ```
   ^F[0-9]{2,} T[0-9]{2,} S[1-9][0-9]* [A-Z][^.!?]*\.$
   ```

   Stage only the files that sentence describes. `git add -A` is forbidden.
   No trailer, no `Co-authored-by`, no `--no-verify` unless the user explicitly
   overrides a hook failure after you have shown them the failure.
8. One phase task `InProgress` unless the human approved parallel work.
9. **Irreversible steps pause.** Auth, destructive migration, deletion,
   payments, secrets, or anything `git revert` cannot undo: stop, name the
   risk, wait for an explicit yes. Load `planning/checklists/security.md` and
   include it in the reviewer pass.

## Procedure

### 0. Preconditions

- Read the task, its feature intent `planning/intents/Fnn.md`, and INDEX
- Depends-on is `✅` or `—`
- An execution plan exists. If it does not, run `/task-1-plan` first
- Branch is the stub stem: the task filename without `.md` (for example
  `T04-tunnel-supervisor`). If you are on `main` or `master`, create or check
  out that branch before any commit. Do not commit on `main` or `master`.

### 1. Status → `InProgress`

Update the task file and INDEX. Log Status History.

### 2. Planning residue, if the worktree is dirty

If intent files, INDEX, or phase stubs are uncommitted and are not the product
slice, commit **only those files** first:

```
Fnn Tnn S1 Record the confirmed intent and phase stubs.
```

Use the next free `S` id (see Commits below). Then start product slices at the
following id. Do not fold planning files into a code commit.

### 3. Implement in slices

Follow the execution plan’s commit subjects unless the slice changed. When it
changed, rewrite the sentence so it still matches the machine check and names
what this commit actually does.

For each slice:

1. **Behavior change:** add the test, run it, confirm it fails for the intended
   reason. Do not commit red. The pre-commit hook runs `make verify`, so the
   commit contains the failing test and the fix together, after green.
2. Implement the smallest complete piece.
3. Stay inside the plan. Note adjacent improvements; do not make them.
4. **Pause** on an irreversible step even when the plan forgot to mark it.
5. Delegate a bounded mechanical subtask (one clearly specified unit, or a
   behavior-preserving rename) to an implementer or refactorer. Keep design
   and cross-file coordination here.
6. A new library gets a `.cursor/rules/<name>.mdc` spoke with a Docs URL you
   opened this session, and a README Dependencies row. If you cannot do that
   now, note it for `/task-3-complete`. Unopened docs stay **unverified**.

### 4. When verify fails — debug before rewriting the plan

Read `.cursor/rules/debug.mdc` and follow it. Do not improvise a second
procedure, and do not open that file on a green run.

If the failure is a wrong plan rather than a wrong edit, Status `Blocked` and
send the task back to `/task-1-plan`. Do not design a replacement in this skill.

### 5. Verify gate before each commit

Presence check first:

```bash
test -f Makefile && grep -q '^verify' Makefile
test -f lefthook.yml
# lint config path named in the hub; Go projects: test -f .golangci.yml
make verify
```

Missing toolchain → Status `Blocked`. Do not commit. Do not treat package
tests as the gate.

After non-trivial edits, launch a code-reviewer and a test-runner in the
background and fold their findings in before the commit. Tell the reviewer to
read `.cursor/rules/review.mdc`. The parent does not read that file. When the
slice is on the irreversible list, or it accepts untrusted input, also tell
the reviewer to read `.cursor/rules/security.mdc` when that file exists, and
`planning/checklists/security.md`. A reviewer bug blocks the commit until fixed.

After the new test is green, simplify only by the language spoke section
**After the new test is green**. That section covers lines this task touched.

### 6. Commit the slice

Next sub-task id = one greater than the highest `S` for this feature and task
in the task **Commits** table and in `git log --format=%s`. The first commit
of the task is `S1` when neither source has an id.

Append the **Commits** row first: the exact subject, SHA `—`. Include the
task file in this commit. Do not make a second commit only to store the SHA.
`/task-3-complete` fills known SHAs from `git log`.

```bash
git add -- path/one path/two planning/phases/<this-task>.md
# subject must match ^F[0-9]{2,} T[0-9]{2,} S[1-9][0-9]* [A-Z][^.!?]*\.$
git commit -m "$(cat <<'EOF'
F01 T04 S1 Add the tunnel URL parser.
EOF
)"
```

The message is exactly that one line. If the hook fails, fix and create a
**new** commit with the next `S` id. Do not amend. Do not `--no-verify`.
Do not push.

### 7. Acceptance

All acceptance criteria checked, or Status `Blocked`. Criteria include tests
for new behavior and a green `make verify`.

### 8. Record and hand off

Fill **Verification** and **Files Modified**. Leave INDEX as `InProgress`.

Tell the user:

> Run `/task-3-complete TXX` — re-verify, definition of done, dialectic, close-out commit, push (default; `--no-push` to skip), manual test, next branch.

When the user already asked to execute and complete in one go, run
`/task-3-complete` now.

### 9. Output

```
## Executed — TXX Title
### Result
Acceptance passed / Blocked
### Verification
- lint / test / build: …
### Commits
- Fnn Tnn S1 … (sha) local, not pushed
### Files touched
- …
### Next
/task-3-complete TXX
```

## Do not

- Execute two phase tasks in one invocation
- Push
- Mark INDEX `✅`
- Write `Done` in the INDEX Status column
- Commit on `main` or `master`
- Use `git add -A`
- Commit a red tree
- Skip `make verify` because package tests passed
- Continue an irreversible step without an explicit yes
- Invent a design the plan did not specify

## Common rationalizations

| Excuse | Required action |
| ------ | --------------- |
| “Package tests are green, so verify passed.” | Run the presence check and `make verify`. |
| “I’ll commit everything at close-out.” | Each green slice commits now. Close-out commits the ritual files and pushes. |
| “`git add -A` is faster.” | Stage the files the sentence names. |
| “The failing test and a drive-by rename belong together.” | One sentence, one slice. The rename is another `S` id or a note. |
| “The plan includes the auth change, so keep going.” | Pause. Wait for an explicit yes. |
| “The hook failed, I’ll skip it.” | Fix the failure and make a new commit. |
| “A vague plan is close enough.” | Stop and return to `/task-1-plan`. |

## Red flags

- A commit subject with a second sentence, a trailer, or a `feat:` prefix
- `git add -A` or a commit on `main`
- More than one capability joined by “and” in the subject
- Production code written before a behavior test was seen failing
- `git push` in this skill
- Irreversible edit with no pause
- `S` ids reused or zero-padded (`S01`)

## Under pressure

- “The user said skip verify and commit.” → Verify is the gate. Skipping it is a blocked task, not a faster one.
- “Just land it on main, we’ll branch later.” → Check out the stub stem first. Main gets no commit from this skill.
- “One squashed commit is cleaner for review.” → Review reads the `S` sequence. Each slice stays its own subject. Push waits for complete.
- “Time is short, fold the security checklist into a comment.” → Load `planning/checklists/security.md` and pause when the list says pause.

## Verification

- [ ] Stub branch, not `main` or `master`
- [ ] Presence check passed and `make verify` is green for every commit
- [ ] Behavior changes showed a failing test before the fix
- [ ] Every subject matches the machine check and is one sentence
- [ ] Commits table has the subject; SHA may stay `—` until close-out
- [ ] Ids were not reused
- [ ] No push
- [ ] INDEX still `InProgress`
- [ ] Irreversible steps waited for an explicit yes
- [ ] Reviewer findings folded in before acceptance

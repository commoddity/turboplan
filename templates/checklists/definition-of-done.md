# Definition of Done

Standing bar for every phase close-out. Acceptance criteria live on the task
and answer “did we build this thing?”. This checklist answers “is it finished?”.
A task is done only when **both** are true.

`/task-3-complete` applies this file. The hub section **Definition of Done**
is the same bar.

## Correctness

- [ ] Acceptance criteria for this task are checked
- [ ] Behavior was exercised at runtime when a runtime exists
- [ ] Behavior changes are covered by a test that failed before the change and passes after
- [ ] `make verify` is green (lint + test, and build when the Makefile wires it)
- [ ] The verify toolchain is present: root `Makefile` `verify` target, hook runner invoking that target, and the lint config named in the hub

## Quality

- [ ] The diff matches the task. Adjacent refactors are noted, not folded in
- [ ] No debug output, dead code, or secrets
- [ ] Each commit subject matches `Fnn Tnn Sn One sentence.`

## Integration

- [ ] The slice works with the layers it depends on
- [ ] Config, migrations, and feature boundaries are accounted for
- [ ] Public interfaces stay compatible, or the break is an explicit decision in the intent file

## Documentation

- [ ] README updated when the operator story changed (how to run, layout, dependencies)
- [ ] Dependency spokes cite a Docs URL that was opened in the session that wrote the entry

## Ship-readiness

- [ ] Untrusted input, auth, or secrets reviewed against `planning/checklists/security.md`
- [ ] A new production path has a log or metric, or the close-out says nothing to observe, per `planning/checklists/observability.md`
- [ ] Irreversible steps were paused for an explicit human yes
- [ ] Manual test section is filled, or `Nothing to test` plus why
- [ ] The branch is the task’s stub stem, and the push (unless `--no-push`) is from `/task-3-complete`

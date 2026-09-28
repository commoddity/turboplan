# MVP Phase Index

**Product**: {{PRODUCT_NAME}}
**Feature**: F01
**Slice shape**: {{horizontal layers | vertical user paths}}
**Method**: Turboplan — `/task-1-plan` → `/task-2-execute` → `/task-3-complete`
**Rule**: Only one task `InProgress` unless the human approves more.
**INDEX Status**: use `✅` when complete (never the word `Done` in this column).
**Commit subject**: `F01 T01 S1 Add the skeleton entrypoint.`
Machine check: `^F[0-9]{2,} T[0-9]{2,} S[1-9][0-9]* [A-Z][^.!?]*\.$`

| ID | Feature | Title | Status | Depends-on | Next | Layer | Notes |
| -- | ------- | ----- | ------ | ---------- | ---- | ----- | ----- |
| T01 | F01 | [{{T01_TITLE}}](./T01-{{slug}}.md) | Pending | — | T02 | L0 | |
| T02 | F01 | [{{T02_TITLE}}](./T02-{{slug}}.md) | Pending | T01 | T03 | L1 | |
| T03 | F01 | [{{T03_TITLE}}](./T03-{{slug}}.md) | Pending | T02 | T04 | L2 | |
| Tnn | F01 | [E2E / live proof](./Tnn-e2e.md) | Pending | T(n-1) | — | L8 | Holistic CoS |

## Slice shape

- **Horizontal layers** — libraries, CLIs, and infrastructure. Each layer is true before the next exists.
- **Vertical user paths** — products whose proof is a user action. One path through the stack, ordered by Depends-on, each path provable on its own. Name the path in Notes.

`T01` is always the skeleton. The last task is always holistic proof. Later features (`F02`, …) append rows; they do not renumber `F01`.

## Layer legend

| Layer | Meaning |
| ----- | ------- |
| L0 | Skeleton builds |
| L1 | Config / logging |
| L2 | Secrets / identity |
| L3 | Pure core |
| L4 | Integration surface |
| L5 | External processes |
| L6 | Host integration |
| L7 | Operator UX |
| L8 | E2E proof |

## How to work

1. `/task-1-plan T01`
2. `/task-2-execute T01` — local commits `F01 T01 S1`, `S2`, … on the stub branch. No push.
3. `/task-3-complete T01` → close-out commit, push (default; `--no-push` to skip), manual test, next `<T02-stub-stem>` branch
4. Repeat

Confirmed intent for this feature: `planning/intents/F01.md`.

Bootstrap replaces this skeleton with real rows and creates stub files.

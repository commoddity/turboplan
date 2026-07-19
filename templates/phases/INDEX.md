# MVP Phase Index

**Product**: {{PRODUCT_NAME}}  
**Method**: Turboplan — `/task-1-plan` → `/task-2-execute` → `/task-3-complete`  
**Rule**: Only one task `InProgress` unless the human approves more.  
**INDEX Status**: use `✅` when complete (never the word `Done` in this column).

| ID | Title | Status | Depends-on | Next | Layer | Notes |
| -- | ----- | ------ | ---------- | ---- | ----- | ----- |
| T01 | [{{T01_TITLE}}](./T01-{{slug}}.md) | Pending | — | T02 | L0 | |
| T02 | [{{T02_TITLE}}](./T02-{{slug}}.md) | Pending | T01 | T03 | L1 | |
| T03 | [{{T03_TITLE}}](./T03-{{slug}}.md) | Pending | T02 | T04 | L2 | |
| Tnn | [E2E / live proof](./Tnn-e2e.md) | Pending | T(n-1) | — | L8 | Holistic CoS |

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
2. `/task-2-execute T01`  
3. `/task-3-complete T01` → push (default; `--no-push` to skip) + Manual test → continues on `<T02-stub-stem>`  
4. Repeat  

Bootstrap replaces this skeleton with real rows and creates stub files.

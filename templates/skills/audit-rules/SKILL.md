---
name: audit-rules
description: >
  Read-only audit of .cursor/rules/*.mdc and .cursor/skills/*/SKILL.md against
  the codebase. Flags staleness, contradictions, missing routing.
  Never auto-removes content.
disable-model-invocation: true
allowed-tools: Bash, Read, Grep, Glob
---

# /audit-rules — Rules + skills audit

**Principles**: `.cursor/rules/general.mdc`  
**Store**: `.cursor/rules/*.mdc` only  

## CRITICAL CONSTRAINTS

1. NEVER auto-remove entries — flag for humans.  
2. NEVER judge whether a latent bug “still applies.”  
3. ONLY flag mechanical staleness, contradictions, gaps, frontmatter issues.  
4. Scaffolding awareness: missing paths expected until phase tasks land →
   `PENDING_SCAFFOLD`, not `BROKEN`. Sequence of record: `planning/phases/INDEX.md`.

## Phase 1 — Inventory

Extract from every rule file: paths, package/component names, problem-class tables,
`last-verified` stamps.

Extract from every skill: frontmatter, path refs, tool allowances.

## Phase 2 — Mechanical verification

- Paths exist or `PENDING_SCAFFOLD`  
- Exports/bindings referenced still exist (grep)  
- Timestamps >6 months → STALE  
- Skills: `name`, `description`, `disable-model-invocation` as expected  

## Phase 3 — Structural audit

- Domain Routing Map ↔ domain and dependency spokes. The craft table ↔ file
  spokes that exist (`security.mdc`, `api.mdc`, `ui.mdc`, `observability.mdc`,
  and `deprecation.mdc` only when a removal copied it in). A craft row for a
  missing file is `BROKEN`. A live file with no row is `GAP`.
- Moment spokes `debug.mdc`, `review.mdc`, and `decisions.mdc` exist, have
  `alwaysApply: false`, have no `globs`, and appear in neither hub table.
  Absence is `BROKEN`. Listing them in a table is `GAP`.
- `planning/spoke-seeds/deprecation.mdc` exists. A missing seed is `BROKEN`.
  A live `deprecation.mdc` with no removal task is `GAP`.
- Skills inventory in hub ↔ `.cursor/skills/*/`
- **Hub fidelity:** `general.mdc` still contains **Karpathy Behavioral Guidelines**
  (four sections), **Project Architecture**, **Delivery Principles**,
  **Definition of Done**, **Commit messages**, **Irreversible steps**, and
  **Rule Maintenance** steps **0–7**. If bootstrap stripped these → `MISSING`
- **Commit subjects:** execute and complete forbid `git add -A` and never use it as a step. Mentioning the phrase in a “do not” list is expected. Execute commits locally and does not push. Complete pushes. Both contain the machine check `^F[0-9]{2,} T[0-9]{2,} S[1-9][0-9]* [A-Z][^.!?]*\.$`.
- **Intent:** `planning/intents/` exists. A missing `Fnn.md` before `/grill-me`
  is `PENDING_SCAFFOLD`. Grill’s skill requires an explicit yes before writing
  one
- **Checklists:** `planning/checklists/definition-of-done.md`,
  `security.md`, and `observability.md` exist. Absence is `BROKEN`
- **Skill anatomy:** every `.cursor/skills/*/SKILL.md` has `## Common rationalizations`,
  `## Red flags`, `## Verification`, and `## Under pressure`
- **Hooks:** lefthook (or the runner named in the hub) present and wired to
  lint+test; root `Makefile` with `verify`; the lint config named in the hub
  is present. Go projects: `.golangci.yml`. Flag absence as `BROKEN`
  (execute/complete must hard-abort)
- **Complete skill:** `/task-3-complete` documents push-by-default, `--no-push`,
  the definition of done, and mandatory Manual test / Nothing to test
- **Execute skill:** `/task-2-execute` documents the verify presence abort,
  red-then-green for behavior changes, local `Fnn Tnn Sn` commits, and the
  irreversible pause
- **Bootstrap skill:** uses the stack the human named; creates dependency
  spokes with official URLs opened for the entry; creates human `README.md`;
  creates `.gitignore`; ships the verify gate to the repo root; records slice
  shape and feature ids on INDEX
- **Audience split:** named deps appear in both `.cursor/rules/*.mdc` and README
  Dependencies & docs (flag one-sided coverage as `GAP`)

## Phase 4 — Contradictions

Same symptom + different fix across entries → flag both.

## Phase 5 — Gaps

New packages/domains with no spoke; missing skills for repeated workflows.

## Output format

Use severity table: `BROKEN` | `PENDING_SCAFFOLD` | `STALE` | `MISSING` | `CONTRADICTION` | `GAP`.

End with counts summary.

## Common rationalizations

| Excuse | Required action |
| ------ | --------------- |
| “This entry looks unused, I’ll delete it.” | Flag it. Humans delete. |
| “The lint config is missing because the app is not scaffolded yet.” | Missing Makefile, hook, or the hub’s lint config is `BROKEN`. Missing product source before T01 is `PENDING_SCAFFOLD`. |
| “A skill without a pressure section is fine if the procedure is clear.” | The four anatomy headings are the check. Flag `MISSING`. |

## Red flags

- Auto-editing a rule during this audit
- Calling a latent bug “still open” or “fixed”
- Treating an empty `planning/intents/` before grill as `BROKEN`
- Ignoring an execute or complete skill that tells the agent to run `git add -A`

## Under pressure

- “Clean it up while you’re here.” → The output is a severity table. The tree stays as you found it.
- “The user wants a green audit.” → Report the counts you counted.

## Verification

- [ ] Every rule and skill was inventoried
- [ ] Severity table uses only `BROKEN`, `PENDING_SCAFFOLD`, `STALE`, `MISSING`, `CONTRADICTION`, `GAP`
- [ ] No file was modified
- [ ] Counts summary is present


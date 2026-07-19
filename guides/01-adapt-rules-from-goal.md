# Guide 01 — Adapt rules from a goal

## Intent

Turn a goal statement into a **hub + spokes** rule set that steers agents toward the right architecture and away from irrelevant stacks.

## Classification for every existing rule/skill file

| Verdict | Meaning | Action |
| ------- | ------- | ------ |
| **DELETE** | Zero overlap with new product | Remove file |
| **ADAPT heavily** | Process stays; domain content wrong | Rewrite body; keep structure |
| **KEEP mostly** | Process-only (e.g. dialectic procedure) | Light routing edits |

Never “lightly patch” a wrong-stack spoke (e.g. an obsolete UI framework after you dropped that stack). **Replace** with a new spoke for the real domain.

## What always stays in `general.mdc`

- **Karpathy Behavioral Guidelines** near the top (think / simple / surgical / goal-driven — full fidelity)  
- **Cross-Cutting Engineering Standards** (Go default; Astro / Vue / Wails; tests; lint+auto-fix; git+lefthook + fail-closed verify presence; latest-stable toolchain; complete push + manual test)  
- **Model split** (large plan → small execute; handoff-ready plans)  
- Read rules before act  
- Hub → spoke routing tables  
- Safety / no-go operations (customize list; keep “no unsolicited commits/pushes outside `/task-3-complete`”; that skill pushes by default unless `--no-push`)  
- Rule Maintenance (dialectic of cognition — full 0–7 procedure)  
- Skills inventory  

## What always gets rewritten

- Product name and architecture diagram  
- Build / verify commands  
- Package managers and CGO/runtime notes  
- Delivery / MVP layer sequence  
- Routing Map rows (domains of *this* product)  
- Problem-class → file table  
- Dialectic *examples* (use failure modes from this domain)

## Spoke design

One spoke per **failure-mode domain** or **named dependency**, not per file.

Good spokes:

- Named libraries/frameworks with official docs (e.g. Cobra → `cobra.mdc` + https://cobra.dev/docs/)  
- Provider API quirks  
- Local protocol adapter / proxy  
- Host OS packaging / secrets  
- Third-party sync (IDE settings, cloud tunnel)  
- Observability / usage / pricing  

Each spoke should answer:

1. What does it look like? (symptoms)  
2. What causes it? (pattern)  
3. How do you fix it? (actionable)

Near the top: **`Docs (if stuck):`** canonical official URL.

Prefer symptom tables over essays.

### Dependency spokes from provided docs (bootstrap)

When Goal / Constraints / Dependencies / References name a library or API:

1. Research **official** docs first  
2. Write `.cursor/rules/<name>.mdc` with best practices for *this* product  
3. Link the docs URL so agents know where to dig deeper  
4. Add a matching row to human `README.md` → Dependencies & docs  

Rules/skills serve LLMs; README serves humans — keep them aligned as the project evolves.

## Routing Map template

```markdown
| When you are working on… | Read and follow |
| ------------------------ | --------------- |
| <domain A> | `.cursor/rules/a.mdc` |
| <domain B> | `.cursor/rules/b.mdc` |
| Shared language / tests / lint | `.cursor/rules/<lang>.mdc` |
| Unsure | this file + ask |
```

Every file under `.cursor/rules/` except self-references must appear in the Routing Map and/or Problem Class table.

## `CLAUDE.md`

```bash
ln -sf .cursor/rules/general.mdc CLAUDE.md
```

Document in the hub that Claude Code and Cursor share this file. Do not create `.claude/rules/`.

## Verification

```bash
# From project root
test -L CLAUDE.md && readlink CLAUDE.md   # expect .cursor/rules/general.mdc
ls .cursor/rules/
# Grep for deleted stack names that must be gone
```

Agent should confirm Routing Map ↔ file set bijection (every spoke listed; no listed missing files).

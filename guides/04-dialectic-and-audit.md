# Guide 04 — Dialectic and audit

## `/dialectic-of-cognition`

**When:** after hard debugging, after structural changes, and always as part of `/task-3-complete`.

**Authority:** Project `.cursor/rules/general.mdc` → **Rule Maintenance (Self-Evolving Rules)**
(triggers, abort gate, steps **0–7**). The skill is the harness; do not skip
those steps when encoding.

**Modes**

| Mode | Question | Writes to |
| ---- | -------- | --------- |
| A — Debugging | Did we learn a generalizable **project** failure mode? | This project’s `.cursor/rules/` |
| B — Structural | Did code changes stale or extend **project** rules? | This project’s `.cursor/rules/` |

**Abort gate (A/B):** If you cannot state the rule without naming a specific file/function/variable/endpoint, **do not** encode it in project rules. The value stays in the diff.

**Encode (A/B)** only into `.cursor/rules/*.mdc`. Prefer refining existing symptom tables. Add `<!-- last-verified: YYYY-MM -->`.

**Output:** use the skill's session-capture format. If nothing qualifies: *Nothing to capture — session was routine.*
## Karpathy guidelines (related)

Coding behavior (think / simple / surgical / goal-driven) lives in the hub
**Karpathy Behavioral Guidelines** section — not in this skill. `/task-1-plan`
and `/task-2-execute` must follow that section in full.

## `/audit-rules`

**When:** after bootstrap; after large refactors; periodically on long projects.

**Read-only.** Never auto-delete rule entries.

Flag only:

- Broken paths / missing exports (or `PENDING_SCAFFOLD` if phase not built yet)  
- Routing Map ↔ files mismatches  
- Missing `CLAUDE.md` symlink  
- Skill frontmatter gaps  
- Contradictory symptom→fix pairs  
- Stale `last-verified` (>6 months)  
- Hub missing or diluted Karpathy / Cross-Cutting / Rule Maintenance sections  
- Bootstrap skill missing latest-stable toolchain AC, dependency/docs spokes,
  human README seed, or stack-appropriate `.gitignore`; complete skill missing
  push-by-default / `--no-push` / Manual test handoff  

## File size

If a spoke exceeds **600 lines** after edits (propose earlier near ~550), propose a split to the human — do not split silently.  

---
name: dialectic-of-cognition
description: >
  Capture session learnings into project rules. Manual; also from /task-3-complete.
disable-model-invocation: true
allowed-tools: Bash, Read, Grep, Glob, Edit, Write
---

# /dialectic-of-cognition — Capture session learnings into evolving rules

Perform rule maintenance per **Rule Maintenance (Self-Evolving Rules)** in
`.cursor/rules/general.mdc` — that section is authoritative (triggers, abort
gate, steps **0–7**). This skill is the operational harness only.

**Store (this project)**: `.cursor/rules/*.mdc` only.

Follow general.mdc steps 0–7 when encoding (refine, contradict-check, verify,
timestamp, size threshold **600**).

---

## Mode A — Debugging learnings

### A0 — Triage

Triggers: debugging >5 min; external docs; multiple corrective attempts; non-obvious root cause.

If none: "Mode A: no debugging triggers — skipping." → Mode B.

### A1 — Extract (Particular → General)

Symptom, root-cause **class**, resolution **pattern**.

### A2 — Route

Routing Table at the bottom of `general.mdc` → project spokes. Write the class
into the file spoke whose globs match the paths. Do not add it to the hub, and
do not open `debug.mdc`, `review.mdc`, or `decisions.mdc`.

---

## Mode B — Code change → rule impact

### B0 — Summarize changes

### B1–B2 — Route and read spokes

### B3 — Abort gate

State the rule without naming a specific file/function/class/variable/endpoint?
If not, skip for project rules.

### B4 — Encode into `.cursor/rules/*.mdc`

Prefer refine. Add `<!-- last-verified: YYYY-MM -->`.

---

## Shared integrity

Contradiction check · file size >600 → propose split · decay >6 months.

## Output format

Include Mode A, B, and project encodings table, plus Integrity.

If nothing: **"Nothing to capture — session was routine."**

When an entry rests on an external doc, include that spoke’s Docs URL and the
month it was opened. Open the URL in this session before encoding. If it was
not opened, the entry stays unfinished.

## Common rationalizations

| Excuse | Required action |
| ------ | --------------- |
| “This bug is specific to one function, but the story is useful.” | Apply the abort gate. If the rule needs that name, it stays in the diff. |
| “I’ll write it up next session.” | This skill is the session’s write-up. Encode now or say the session was routine. |
| “A new spoke is cleaner than editing the old entry.” | Refine the overlapping entry. Propose a split only past the size threshold. |
| “The docs probably say this.” | Open the Docs URL. Until then the claim is unverified. |

## Red flags

- An entry that names a file, function, class, variable, or endpoint
- A second entry for a symptom the file already explains
- A doc URL cited without opening it this session
- A rule file edited outside this skill or `/task-3-complete`
- Silence where the output should say the session was routine

## Under pressure

- “Skip the write-up, the commit explains it.” → The commit is one sentence about the slice. The spoke is the problem class. Write the class or say there is nothing to capture.
- “The user wants the close-out pushed now.” → Dialectic is part of close-out. A routine session is a one-line result, not a skipped result.

## Verification

- [ ] Mode A and Mode B each reported a result
- [ ] Encoded entries pass the abort gate and include symptom, cause, and fix
- [ ] Doc-backed entries name a URL opened this session
- [ ] Contradictions, duplicates, decay, and the size threshold were checked
- [ ] Output is either a table of encodings or “Nothing to capture — session was routine.”

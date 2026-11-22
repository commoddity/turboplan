---
name: dialectic-of-cognition
description: >
  After a hard debug or a structural code change, choose a check, a pointer,
  or a problem class, then encode only the class. Manual; also from
  /task-3-complete.
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

<!-- turboplan:disposition -->
## Disposition — before Mode A and Mode B

Run this before Mode A. One candidate ends with one mechanism and one destination. The step is done when every candidate has a mechanism, a destination, and one of: an `EXTRACTED` edge, "graph absent", or "graph stale".

Refresh the graph first when `graphify-out/graph.json` exists. If that file is older than the newest source file in the scan (`.cursor/`, `planning/`, and markdown excluded), run `GRAPHIFY_BACKEND=none graphify update .`. Code-only. If the update fails, record "graph stale" and do not invent edges. If the graph does not exist, record "graph absent" and continue. Do not run any other `graphify` subcommand.

Query tokens must already be labels in the graph. If none match, say so and do not search with a synonym you made up. Lookups use `GRAPHIFY_BACKEND=none graphify query`.

| What the session showed | Destination |
| --- | --- |
| A mistake `make verify`, lefthook, or an existing test can refuse | The verify gate. Look there before proposing a new check. A new check's failure text names the remediation. |
| A judgment a diff reviewer can apply | A proposal for `review.mdc`, held for a yes. Leave that moment spoke closed during capture. |
| The agent was slow to find a file | One pointer in the spoke whose globs already cover that path. |
| A failure the next agent must recognize from symptoms | A symptom / cause / fix row, through Rule Maintenance steps 0–7. |
| A log or service the agent could not see | An access note in that spoke, held for a yes. |
| A steering sentence that does not change behavior | A removal proposal, held for a yes. |

Graph evidence:

- An `EXTRACTED` edge may justify a pointer or a check, or fill a map gap Mode B may name.
- An `INFERRED` or `AMBIGUOUS` edge is listed in the output and is not written into a spoke.
- A problem class comes from the session, not from a community or a god node.
- Read the target spoke before writing. If a row already covers that symptom, refine it. If a row tells the agent to do something the edge does not support, the rule wins, the edge is listed as a conflict, and that row does not change.
- The only write that does not wait is a path in a spoke whose replacement file exists on disk. `STALE` and `GAP` are reported.
- `graphify-out/reflections/LESSONS.md` may be read. It is not a problem class and it is not copied into a spoke.

Encode, when the destination is a recognition row:

- Symptom, cause, and fix are all present, or the row is unfinished.
- A boundary sits with the entry it bounds.
- A `Makefile` target or a path the agent can open is a pointer, not a restated paragraph.
- The gotcha no config confesses stays written out.
- A hard guard stays next to the action it protects: encode a class that passes the gate, and do not fabricate; propose a deletion, and wait for a yes; leave `debug.mdc`, `review.mdc`, and `decisions.mdc` closed during capture.

Mode A uses the class gate. Mode B may name files, routes, and components. There is no Mode C.
<!-- /turboplan:disposition -->

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

Mode A writes a recognition class. State that class in one sentence without a specific file, function, class, variable, or endpoint. If it cannot, do not encode it.

Mode B may write a map entry that names files, routes, and components. A map entry that fails the class test is still valid.

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
| “This bug is specific to one function, but the story is useful.” | Apply the class gate to a recognition class. If that class needs the name, it stays in the diff. A Mode B map entry may name the file. |
| “I’ll write it up next session.” | This skill is the session’s write-up. Encode now or say the session was routine. |
| "The graph inferred the call, so the spoke should say it." | `INFERRED` and `AMBIGUOUS` stay in the output. They are not encoded. |
| "This mistake belongs in a rule." | If `make verify` or a test can refuse it, the destination is the check. |
| "`LESSONS.md` already recorded it." | That file is navigation memory. A class still goes through symptom, cause, and fix, or the session was routine. |
| “A new spoke is cleaner than editing the old entry.” | Refine the overlapping entry. Propose a split only past the size threshold. |
| “The docs probably say this.” | Open the Docs URL. Until then the claim is unverified. |

## Red flags

- A recognition class (Mode A) that names a file, function, class, variable, or endpoint
- A second entry for a symptom the file already explains
- Encoding from an `INFERRED` or `AMBIGUOUS` edge
- A recognition row that dropped symptom, cause, or fix
- Opening `debug.mdc`, `review.mdc`, or `decisions.mdc` during capture
- Deleting a class or a steering line without a yes
- Treating a missing graph as a reason to skip capture
- A doc URL cited without opening it this session
- A rule file edited outside this skill or `/task-3-complete`
- Silence where the output should say the session was routine

## Under pressure

- “Skip the write-up, the commit explains it.” → The commit is one sentence about the slice. The spoke is the problem class. Write the class or say there is nothing to capture.
- “The user wants the close-out pushed now.” → Dialectic is part of close-out. A routine session is a one-line result, not a skipped result.

## Verification

- [ ] Mode A and Mode B each reported a result
- [ ] Encoded recognition classes pass the class gate and include symptom, cause, and fix
- [ ] Disposition ran, or the output says the session was routine
- [ ] Each encoded class passes the class gate and has symptom, cause, and fix
- [ ] Each map entry from Mode B is allowed to name files
- [ ] Conflicts list the winning rule and do not change that row
- [ ] Doc-backed entries name a URL opened this session
- [ ] Contradictions, duplicates, decay, and the size threshold were checked
- [ ] Output is either a table of encodings or “Nothing to capture — session was routine.”

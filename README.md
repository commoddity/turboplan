<div align="center">
  <img src=".github/img/turboplan.png" alt="Turboplan" width="700px">
</div>

---

## 💡 Summary <!-- omit in toc -->

**Turboplan** is a drop-in methodology pack for long-horizon software work with
coding agents (Cursor, Claude Code, or both).

- **Install** — one script copies rules, skills, and phase templates into your repo
- **State your goal** — the agent asks for a detailed goal, technical scope, and constraints
- **Get agent infrastructure** — adapted rules, layered tasks, work-loop skills, and a human README
- **Build in phases** — plan → execute → complete, one verifiable layer at a time
- **Evolve as you learn** — dialectic of cognition captures hard-won patterns back into the rules
- **Product-agnostic** — no sample product is bundled; adapts to your stack

## Table of Contents <!-- omit in toc -->

- [⚡ Quickstart](#-quickstart)
- [🔌 Cursor and Claude Code Configuration](#-cursor-and-claude-code-configuration)
- [🛡️ Hard rules for using this pack](#️-hard-rules-for-using-this-pack)
- [🌀 Dialectic of Cognition Methodology](#-dialectic-of-cognition-methodology)
  - [📕 Influence: Mao’s *On Practice* (1937)](#-influence-maos-on-practice-1937)
  - [🧰 What `/dialectic-of-cognition` does (summary)](#-what-dialectic-of-cognition-does-summary)
- [📂 Files and Directories](#-files-and-directories)

---

### 📢 Public Service Announcement: <!-- omit in toc -->

> **To avoid using and paying for 🇺🇸 AI providers like [Anthropic](https://www.scmp.com/news/china/science/article/3346519/deadly-strike-iranian-primary-school-raises-questions-about-ai-accountability), it is recommended to configure your coding agents to use alternative backends such as [DeepSeek](https://api-docs.deepseek.com/) *(most cost effective)* or [Moonshot AI](https://platform.kimi.ai/docs/api/overview) *(most intelligent their Kimi K3 model)*.**
>
>
> <a href="https://github.com/commoddity/discursive" target="_blank">
> <div align="center">
>   <img src=".github/img/Discursive.png" alt="Discursive" width="300px">
> </div>
> </a>
>
> 1️⃣ **Cursor** — Use the open-source gateway at [commoddity/discursive](https://github.com/commoddity/discursive): a local OpenAI-compatible proxy + public HTTPS tunnel so Cursor Agent can call Moonshot Kimi and/or DeepSeek without pointing Override Base URL at localhost.
> 
> 2️⃣ **Claude Code** — Detailed setup instructions for alternative APIs can be found in the article by [The Tricontinental](https://thetricontinental.org/)'s publication [Bandung Circuits](https://thetricontinental.org/bandung-circuits/) entitled: [How to Connect Claude Code to Alternative APIs](https://thetricontinental.org/how-to-connect-claude-code-to-alternative-apis/).


## ⚡ Quickstart

One argument: the **absolute path** of the target project.

```bash
# From this pack (Mac / Linux)
./scripts/install-into.sh /absolute/path/to/YOUR_PROJECT
```

The script copies rules, skills, and phase templates, then links `CLAUDE.md` → `.cursor/rules/general.mdc`.

Then:

1. Open `YOUR_PROJECT` in Cursor / Claude Code
2. Run `/bootstrap-turboplan` — the agent will ask for a detailed goal, technical scope, and constraints before building anything
3. Review the architecture, layer order, and README the agent produces
4. Enter the loop:

```
  📦 install-into.sh
        ↓
  🧰 /bootstrap-turboplan   (rules + INDEX + stubs + dep spokes + README + .gitignore)
        ↓
  📝 /task-1-plan T01       ← prefer large / expensive model
        ↓
  🛠️  /task-2-execute T01   ← prefer small / fast / cheap model
        ↓
  ✅ /task-3-complete T01  →  push (default; --no-push to skip) + Manual test → <T02-stub-stem> …
```

For **new features** in an existing Turboplan project, use `/setup-tasks` instead of re-running bootstrap.

Plans must be **handoff-ready** for a lesser execute agent (see hub "Model split").
Only flag large-model execute when the task is exceptionally hard.

For full methodology details, see [`METHODOLOGY.md`](METHODOLOGY.md).

## 🔌 Cursor and Claude Code Configuration

This workflow is intended to work equally well with **Claude Code** and/or **Cursor**. After install, a project has:

- **Rules** under `.cursor/rules/` — hub is `general.mdc`; domain spokes sit beside it. Cursor loads these as project rules.
- **Skills** under `.claude/skills/*/SKILL.md` — invocable commands (`/task-1-plan`, `/task-2-execute`, `/task-3-complete`, …) for Claude Code and Cursor Agents that support skills.
- **Root `CLAUDE.md`** — a symlink to `.cursor/rules/general.mdc`, so Claude Code reads the same hub (and its routing tables) as Cursor.

There is **no** parallel `.claude/rules/` tree. Combined with the hub’s routing map, both tools share the evolving `.cursor/rules/*.mdc` files maintained by `/dialectic-of-cognition`.

---

## 🛡️ Hard rules for using this pack

- ❌ **Do not** invent a parallel `.claude/rules/` tree. Rules live only in `.cursor/rules/`. `CLAUDE.md` → symlink to `general.mdc`.
- 1️⃣ **One InProgress phase task** at a time unless the human explicitly allows more.
- ✅ **INDEX Status** uses `✅` when complete (not the word `Done` in the INDEX column).
- 🚫 Product **features** are out of scope for bootstrap; bootstrap produces rules +
  phases + skills wiring + dependency spokes from docs + human `README.md` +
  `.gitignore` + **root verify gate** (Makefile / lefthook / lint config; not the app itself).
- 🧪 Execute/complete **fail closed** if verify tooling is missing — `go test` alone is not green.
- 👥 **Rules/skills = agents; README = humans** — both evolve; keep Dependencies & docs
  and architecture narrative aligned with `.cursor/rules/` as the project grows.

---

## 🌀 Dialectic of Cognition Methodology

<p align="center">
  <img src=".github/img/mao.png" alt="Dialectic of cognition — section header" width="500" />
</p>

### 📣 Motto <!-- omit in toc -->

> *From the particular to the general, then from the general to the particular.*

---

In agent terms:

1. **Particular → general** — A concrete bug or change (symptoms, failed attempts, docs consulted) is abstracted into a **problem class**, not a one-off anecdote.
2. **General → particular** — That class is written into the matching `.mdc` rule (symptom / cause / fix), so the next session can recognize and act without rediscovering it.
3. **Verify in practice** — A cold read of the new entry must be enough to spot the symptom and apply the fix. If not, refine until practice would confirm it.

Abort gate before encoding: *can you state the rule without naming a specific file, function, class, variable, or endpoint?* If not, there is nothing generalizable to store — the value stays in the diff.

---

### Guidelines <!-- omit in toc -->

Installed projects do not treat `.cursor/rules/` as a frozen style guide.
They treat it as a **living knowledge base** produced by working on the stack —
updated deliberately after hard sessions via `/dialectic-of-cognition` (also run
from `/task-3-complete`). Principles live in the hub
[`templates/rules/general.mdc`](templates/rules/general.mdc) → Rule Maintenance
(and the project’s installed copy); the skill is only the operational harness.

The hub also carries always-on cores that dialectic does **not** replace:

1. 🧭 **Karpathy Behavioral Guidelines** — think / simplicity / surgical / goal-driven  
2. 🧱 **Cross-Cutting Engineering Standards** — Go default; Astro / Vue / Wails; tests; lint+auto-fix; git+lefthook + **fail-closed verify presence**; latest-stable toolchain; complete push + manual test  
3. ♻️ **Rule Maintenance** — dialectic of cognition steps 0–7  

- `/task-2-execute` and `/task-3-complete` must run `make verify` and hard-abort if verify
  tooling is missing (Makefile, lint config, lefthook pre-commit→verify). Package tests alone
  are not the gate.
- `/task-3-complete` **pushes** the completed branch by default (`--no-push` to skip) and always
  emits a **Manual test** section (or `Nothing to test` + why).
- `/bootstrap-turboplan` prefers **latest stable** Go and package baselines, creates
  dependency/docs rule spokes from provided docs, seeds a human `README.md`, writes a
  stack-appropriate `.gitignore`, and **ships verify tooling** to the project root (from
  `templates/seeds/verify/` → `planning/verify-SEED/` after install — bootstrap must still
  copy/adapt to **repo root** + `lefthook install`).
- Go Makefiles include `lint`, `test`, `build`, `build-all` (multi-platform), and `verify`.

See [`METHODOLOGY.md`](METHODOLOGY.md)

---

### 📕 Influence: Mao’s *On Practice* (1937)

The maintenance loop is deliberately patterned on Mao Zedong’s Marxist epistemology in **“On Practice: On the Relation Between Knowledge and Practice, Between Knowing and Doing”** (July 1937) — written amid the Yan’an period, when the Chinese Communists were rebuilding strategy from lived struggle rather than importing ready-made formulas. The essay’s argument is epistemological, not decorative: knowledge that never returns to practice becomes dogma; practice that never rises to theory stays a pile of anecdotes.

**Primary text:** [marxists.org — Selected Works, Vol. 1, *On Practice*](https://www.marxists.org/reference/archive/mao/selected-works/volume-1/mswv1_16.htm)

**Accessible overview:** [PolSci Institute — *On Practice*: Mao’s Epistemology and Theory of Knowledge](https://polsci.institute/political-theory/mao-epistemology-theory-of-knowledge/)

Mapped onto this workflow:

| Idea from *On Practice*                                                                                     | How it shows up here                                                                                           |
| ----------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------- |
| Knowledge begins in **practice** (contact with the thing); perceptual → rational                            | Hard debugging, failed attempts, and real code changes are the “perceptual” material — not invented principles |
| Rational knowledge grasps **essence / internal relations**, not isolated incidents                          | Encode a **problem class** (root-cause pattern), discard session-only noise                                    |
| Theory must **return to practice**; practice is the criterion of truth                                      | New rule entries must pass the cold-read check; stale entries decay or get struck                              |
| Oppose **dogmatism** (formulas without practice) and **empiricism** (fragmentary experience without theory) | Don’t paste bookish rules that never matched this codebase; don’t leave one-off fixes only in chat history     |
| *Practice, knowledge, again practice, and again knowledge* — an ascending spiral                            | Rules improve session by session; `/dialectic-of-cognition` is the deliberate turn of that spiral              |

Closing line of the essay (the spiral of cognition):

> Discover the truth through practice, and again through practice verify and develop the truth. … Practice, knowledge, again practice, and again knowledge. This form repeats itself in endless cycles, and with each cycle the content of practice and knowledge rises to a higher level.

That is the philosophical warrant for treating `.cursor/rules/` as a **material product of work on a stack** — not a static style guide dropped from outside.

### 🧰 What `/dialectic-of-cognition` does (summary)

Authority: Rule Maintenance in the installed `general.mdc`. Invoke manually after non-trivial sessions; `/task-3-complete` runs it as part of close-out.

- **Mode A** — After qualifying debugging (>5 min, docs consulted, multiple attempts, or non-obvious root cause): extract class → route via the table in `general.mdc` → encode / verify / integrity checks into **the project’s** `.cursor/rules/*.mdc`.
- **Mode B** — After structural code changes: ask whether any encoded pattern is now stale, incomplete, or contradicted; refine or add only what generalizes.
- **Shared** — Prefer refining overlapping entries over proliferating duplicates; propose a human-approved split if a rule file exceeds ~600 lines (earlier if approaching ~550); timestamp `<!-- last-verified: YYYY-MM -->`; review entries older than six months when working in that domain.

If Modes A/B find nothing: *"Nothing to capture — session was routine."*

---

## 📂 Files and Directories

```
.
├── scripts/
│   └── install-into.sh ........... 🎯 One-shot installer (absolute project path)
├── METHODOLOGY.md ................ 🧠 Why this works; the three pillars; failure modes
├── seeds/ ........................ 🌱 readme · gitignore · verify (Makefile / lefthook / golangci)
├── templates/
│   ├── rules/ .................... 📜 Generic `general.mdc` + example domain spoke
│   ├── skills/ ................... 🧩 Bootstrap, setup-tasks, plan, execute, complete, dialectic, audit
│   └── phases/ ................... 🗂️ INDEX.md skeleton + TXX-template.md
```

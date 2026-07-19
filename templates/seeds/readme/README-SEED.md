# 🚀 {{PRODUCT_NAME}}

```
{{ASCII_BANNER}}
```

## Summary

{{2–4_SENTENCES_FOR_HUMANS: what this repo is, who it is for, and what “done” looks like.
Keep jargon light. Point at Turboplan only if useful.}}

Bootstrapped with **[Turboplan](https://github.com/commoddity/turboplan)** (agent rules + phased delivery).

## Table of Contents

- [Summary](#summary)
- [❗ The problem](#-the-problem)
- [🛠️ The fix (target)](#️-the-fix-target)
- [📊 Status](#-status)
- [📂 Repo layout](#-repo-layout)
- [📚 Dependencies & docs](#-dependencies--docs)
- [🔁 Building with Turboplan](#-building-with-turboplan)
- [🔒 Security / invariants](#-security--invariants)
- [📜 License / attribution](#-license--attribution)

---

## ❗ The problem

| What you try | What happens |
| ------------ | ------------ |
| {{TRY_1}} | {{HAPPENS_1}} |
| {{TRY_2}} | {{HAPPENS_2}} |

## 🛠️ The fix (target)

{{BULLETS_OR_SHORT_ARCHITECTURE}}

```text
{{SIMPLE_FLOW_DIAGRAM}}
```

## 📊 Status

| Area | State |
| ---- | ----- |
| 🧭 Agent rules (`.cursor/rules/`) | Bootstrapped |
| 📋 MVP plan (`planning/phases/`) | Seeded — see INDEX |
| 🛠️ Product code | Not started (or note what exists) |

## 📂 Repo layout

| Path | For |
| ---- | --- |
| [`README.md`](README.md) | 👤 Humans (this file) |
| [`CLAUDE.md`](CLAUDE.md) | 🔗 Symlink → `.cursor/rules/general.mdc` |
| [`.cursor/rules/`](.cursor/rules/) | 📜 Conventions for coding agents |
| [`.claude/skills/`](.claude/skills/) | 🧩 Invocable plan / execute / complete / … |
| [`planning/phases/`](planning/phases/) | 🗂️ MVP sequence of record |

<!-- BOOTSTRAP: add cmd/, internal/, packages as they appear. -->

## 📚 Dependencies & docs

Human-facing summary of major libraries/frameworks. Agents get detail in matching
`.cursor/rules/*.mdc` spokes — keep both in sync as the project evolves.

| Dependency | Role | Docs | Agent rules |
| ---------- | ---- | ---- | ----------- |
| {{DEP_1}} | {{ROLE}} | {{DOC_URL}} | [`.cursor/rules/{{spoke}}.mdc`](.cursor/rules/{{spoke}}.mdc) |

## 🔁 Building with [Turboplan](https://github.com/commoddity/turboplan)

Work proceeds one phase task at a time. Full methodology:
[github.com/commoddity/turboplan](https://github.com/commoddity/turboplan).

```
  📝 /task-1-plan TXX
        ↓
  🛠️  /task-2-execute TXX
        ↓
  ✅ /task-3-complete TXX → push (default) + Manual test → next <stub-stem> branch
```

See [`planning/phases/INDEX.md`](planning/phases/INDEX.md).

## 🔒 Security / invariants

- {{INVARIANT_1}}
- {{INVARIANT_2}}

## 📜 License / attribution

{{LICENSE_NOTE}}

# Prompt scrap — invoke bootstrap on a new project

Paste into Cursor / Claude Code after copying Turboplan templates:

```text
/bootstrap-turboplan

Goal:
{{What the user gets when the project is done. 1–3 paragraphs.}}

Non-goals:
- {{…}}
- {{…}}

Constraints:
- Language / version: {{prefer latest stable Go …}}
- Platforms: {{…}}
- Packaging: {{e.g. host CLI, not Docker-primary}}
- Secrets: {{…}}
- Verify command: {{…}}
- Other no-gos: {{…}}
- Toolchain: prefer latest stable (Go + deps) unless pinned

Dependencies / libraries (each → `.cursor/rules/<name>.mdc` + README row):
- {{e.g. Cobra — https://cobra.dev/docs/}}
- {{…}}

References (study, reimplement, do not vendor):
- {{path or URL}}

Preferred layers (optional):
- L0 …
- L1 …
```

Bootstrap also writes a human **`README.md`** (emoji headers + ASCII banner) and
keeps Dependencies & docs in sync with agent rule spokes.

After bootstrap review, run:

```text
/task-1-plan T01
```

On close-out, `/task-3-complete T01` commits, **pushes by default** (`--no-push` to
skip), and prints **Manual test** commands (or `Nothing to test` + why).

# Turboplan seeds

Installer copies these into `planning/` on the target project. **`/bootstrap-turboplan`**
must adapt them to the **repo root** (seeds under `planning/` alone are not enough).

| Seed folder | Installs as | Bootstrap adapts to |
| ----------- | ----------- | ------------------- |
| [`readme/`](readme/) | `planning/README-SEED.md` | Root `README.md` |
| [`gitignore/`](gitignore/) | `planning/gitignore-SEED` | Root `.gitignore` |
| [`verify/`](verify/) | `planning/verify-SEED/` | Root `Makefile`, `lefthook.yml`, `.golangci.yml` (Go) |

**Verify contract:** execute/complete hard-abort if root verify tooling is missing.
`make verify` must mean lint + test (+ build when applicable) — package tests alone
are not the gate. Go seed Makefile also ships `build-all` (multi-platform) — not
part of the default verify gate.

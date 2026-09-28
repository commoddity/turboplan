# Observability checklist

Load this from `/task-3-complete` when the task adds a path that keeps running
in production: a server, daemon, worker, or long-lived process.

When `.cursor/rules/observability.mdc` exists, that spoke is how to instrument
the path while editing matching files. This list is only the close-out gate.

A one-shot CLI or a pure library may record **Nothing to observe** plus one
sentence why. That sentence is the checklist result.

- [ ] The new path logs success and failure as different outcomes
- [ ] Failures include the operation and the error class
- [ ] Logs and metrics contain no secrets, tokens, or raw credentials
- [ ] An operator can tell whether the path worked without reading the source
- [ ] A metric or structured log exists for the critical path, or **Nothing to observe** is recorded with a reason

Record the result in the task **Verification** section.

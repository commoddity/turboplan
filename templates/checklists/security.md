# Security checklist

Load this from `/task-2-execute` and `/task-3-complete` when the task accepts
untrusted input, changes authentication or authorization, touches secrets, or
hits the irreversible-step list in the hub.

When `.cursor/rules/security.mdc` exists, that spoke is how to build the change
while editing matching files. This list is only the close-out gate.

- [ ] Secrets stay out of the repo, logs, and commit subjects. `.env` and variants are ignored
- [ ] New boundaries validate input before use
- [ ] Authn and authz are checked on the new path, or the task states why the path is unauthenticated
- [ ] User-controlled strings are not passed to a shell, an eval, or a query without a bound parameter
- [ ] A new dependency was named on purpose and has a rules spoke plus a Docs URL
- [ ] Destructive migration, deletion, billing, or credential changes waited for an explicit human yes
- [ ] The change can be undone with `git revert`, or the human accepted that it cannot

Anything unchecked is a blocker for close-out. Record the results in the task
**Verification** section.

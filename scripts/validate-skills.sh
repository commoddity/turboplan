#!/usr/bin/env bash
# Structure check for Turboplan skills and the commit-subject contract.
# Checks headings and required phrases. Does not run a model.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT}"

fail=0
err() {
  printf 'FAIL: %s\n' "$1" >&2
  fail=1
}

NEEDLE='F[0-9]{2,} T[0-9]{2,} S[1-9][0-9]*'

required_format=(
  templates/rules/general.mdc
  templates/skills/task-1-plan/SKILL.md
  templates/skills/task-2-execute/SKILL.md
  templates/skills/task-3-complete/SKILL.md
  templates/skills/bootstrap-turboplan/SKILL.md
  templates/phases/INDEX.md
  templates/phases/TXX-template.md
  METHODOLOGY.md
  README.md
  templates/seeds/readme/README-SEED.md
)

for f in "${required_format[@]}"; do
  if ! grep -q -F "${NEEDLE}" "${f}"; then
    err "${f} missing commit machine check"
  fi
done

shopt -s nullglob
for skill in templates/skills/*/SKILL.md; do
  for heading in \
    "## Common rationalizations" \
    "## Red flags" \
    "## Verification" \
    "## Under pressure"
  do
    if ! grep -q -F "${heading}" "${skill}"; then
      err "${skill} missing ${heading}"
    fi
  done
done
shopt -u nullglob

for f in \
  templates/skills/task-2-execute/SKILL.md \
  templates/skills/task-3-complete/SKILL.md
do
  if grep -E '^git add -A' "${f}" >/dev/null; then
    err "${f} instructs git add -A"
  fi
done

for f in \
  templates/checklists/definition-of-done.md \
  templates/checklists/security.md \
  templates/checklists/observability.md \
  templates/phases/intent-template.md
do
  if [[ ! -f "${f}" ]]; then
    err "missing ${f}"
  fi
done

if ! grep -q 'planning/intents/' templates/skills/grill-me/SKILL.md; then
  err "grill-me missing intent path"
fi
if ! grep -q 'explicit yes' templates/skills/grill-me/SKILL.md; then
  err "grill-me missing explicit yes"
fi
if ! grep -q 'Irreversible' templates/skills/task-2-execute/SKILL.md; then
  err "execute missing irreversible pause"
fi
if ! grep -q 'fail' templates/skills/task-2-execute/SKILL.md; then
  err "execute missing failing-test step"
fi

if ! grep -q 'Moment spokes stay closed' templates/rules/general.mdc; then
  err "hub missing moment-spoke constraint"
fi
if ! grep -q 'Craft spokes' templates/rules/general.mdc; then
  err "hub missing craft table"
fi
if ! grep -q 'decisions.mdc' templates/skills/task-1-plan/SKILL.md; then
  err "plan does not name decisions.mdc"
fi
if ! grep -q 'debug.mdc' templates/skills/task-2-execute/SKILL.md; then
  err "execute does not name debug.mdc"
fi
if ! grep -q 'review.mdc' templates/skills/task-2-execute/SKILL.md; then
  err "execute does not name review.mdc"
fi
if ! grep -q 'After the new test is green' templates/rules/LANGUAGE-craft.mdc; then
  err "language spoke missing simplify section"
fi

for spoke in security.mdc api.mdc ui.mdc observability.mdc LANGUAGE-craft.mdc; do
  if ! grep -q '^globs:' "templates/rules/${spoke}"; then
    err "${spoke} missing globs"
  fi
  if ! grep -q 'alwaysApply: false' "templates/rules/${spoke}"; then
    err "${spoke} is not a file spoke"
  fi
done

for spoke in debug.mdc review.mdc decisions.mdc; do
  if grep -q '^globs:' "templates/rules/${spoke}"; then
    err "moment spoke ${spoke} has globs"
  fi
  if ! grep -q 'alwaysApply: false' "templates/rules/${spoke}"; then
    err "moment spoke ${spoke} is always applied"
  fi
done

if [[ -f templates/rules/deprecation.mdc ]]; then
  err "deprecation.mdc must stay a seed, not a live rule"
fi
if [[ ! -f templates/spoke-seeds/deprecation.mdc ]]; then
  err "missing deprecation spoke seed"
fi

if grep -R -n -E -i 'addyosmani|agent-skills|using-agent-skills' \
  --include='*.md' --include='*.mdc' --include='*.sh' \
  templates METHODOLOGY.md README.md scripts/install-into.sh scripts/upgrade-into.sh >/dev/null; then
  grep -R -n -E -i 'addyosmani|agent-skills|using-agent-skills' \
    --include='*.md' --include='*.mdc' --include='*.sh' \
    templates METHODOLOGY.md README.md scripts/install-into.sh scripts/upgrade-into.sh >&2 || true
  err "disallowed external name present"
fi

for phrase in \
  "Ponytail is the size rule for product source" \
  "Never cut validation at a trust boundary" \
  "turboplan-methodology: 2"
do
  if ! grep -q -F "${phrase}" templates/rules/general.mdc; then
    err "hub missing ${phrase}"
  fi
done

if ! grep -q -F "Ponytail applies only to product source" templates/skills/task-2-execute/SKILL.md; then
  err "execute missing ponytail product-source sentence"
fi
if ! grep -q -F "graphify update ." templates/skills/task-2-execute/SKILL.md; then
  err "execute missing graphify update"
fi
if ! grep -q -F "GRAPHIFY_BACKEND=none" templates/skills/task-2-execute/SKILL.md; then
  err "execute missing GRAPHIFY_BACKEND=none"
fi

if [[ ! -f templates/seeds/verify/graphifyignore ]]; then
  err "missing graphifyignore seed"
fi
if ! grep -q -F "GRAPHIFY_BACKEND=none graphify update ." templates/seeds/verify/lefthook.yml; then
  err "lefthook seed missing graphify update command"
fi
if ! grep -q -F "graphify-out/" templates/seeds/gitignore/gitignore-SEED; then
  err "gitignore seed missing graphify-out/"
fi

graphify_name=graphify
lang_name=language
mdc_ext=mdc
banned_graph=(
  "${graphify_name} extract"
  "/${graphify_name}"
  "${graphify_name} hook install"
  "api.${graphify_name}.com"
  "${lang_name}.${mdc_ext}"
)
for phrase in "${banned_graph[@]}"; do
  hits="$(grep -R -n -F "${phrase}" templates METHODOLOGY.md README.md scripts || true)"
  if [[ "${phrase}" == "/${graphify_name}" ]]; then
    hits="$(printf '%s\n' "${hits}" | grep -v 'graphifyignore' || true)"
  fi
  if [[ -n "${hits}" ]]; then
    printf '%s\n' "${hits}" >&2
    err "disallowed graphify phrase present"
  fi
done

if [[ "${fail}" -eq 0 ]]; then
  printf 'validate-skills: ok\n'
fi
exit "${fail}"

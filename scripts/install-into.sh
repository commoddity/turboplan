#!/usr/bin/env bash
# Turboplan — install templates into a target project
# Usage: ./scripts/install-into.sh /absolute/path/to/YOUR_PROJECT
set -euo pipefail

# --- colours (disable if not a TTY) -----------------------------------------
if [[ -t 1 ]]; then
  BOLD=$'\033[1m'
  DIM=$'\033[2m'
  RED=$'\033[31m'
  GRN=$'\033[32m'
  YEL=$'\033[33m'
  BLU=$'\033[34m'
  MAG=$'\033[35m'
  CYN=$'\033[36m'
  WHT=$'\033[37m'
  RST=$'\033[0m'
  CLR=$'\033[2K'
else
  BOLD= DIM= RED= GRN= YEL= BLU= MAG= CYN= WHT= RST= CLR=
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACK_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

die() {
  printf '\r%s\n' "${CLR}${RED}${BOLD}✖   ${1}${RST}" >&2
  exit 1
}

ok()   { printf '%s\n' "${GRN}${BOLD}✓${RST}   ${1}"; }
info() { printf '%s\n' "${CYN}›${RST}   ${1}"; }
warn() { printf '%s\n' "${YEL}⚠${RST}   ${1}"; }

# --- spinner (braille, like the wizard) --------------------------------------
SPIN_PID=""
spin_start() {
  local msg="$1"
  if [[ ! -t 1 ]]; then
    printf '%s\n' "  ${DIM}${msg}...${RST}"
    return
  fi
  local frames=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
  (
    local i=0
    while true; do
      printf '\r%s  %s  %s' "${CLR}" "${CYN}${frames[i]}${RST}" "${DIM}${msg}${RST}"
      i=$(( (i + 1) % ${#frames[@]} ))
      sleep 0.08
    done
  ) &
  SPIN_PID=$!
  disown "${SPIN_PID}" 2>/dev/null || true
}

spin_stop() {
  local final_msg="${1:-}" detail="${2:-}"
  if [[ -n "${SPIN_PID}" ]]; then
    kill "${SPIN_PID}" 2>/dev/null || true
    wait "${SPIN_PID}" 2>/dev/null || true
    SPIN_PID=""
    printf '\r%s' "${CLR}"
  fi
  if [[ -n "${final_msg}" ]]; then
    if [[ -n "${detail}" ]]; then
      printf '%s\n' "${GRN}${BOLD}✓${RST}   ${final_msg}  ${DIM}· ${detail}${RST}"
    else
      printf '%s\n' "${GRN}${BOLD}✓${RST}   ${final_msg}"
    fi
  fi
}

# --- step completion (wizard-style: ✓ N/T emoji title · detail) -------------
step_done() {
  local step="$1" total="$2" emoji="$3" title="$4" detail="$5"
  local badge
  badge="${DIM}${step}/${total}${RST}"
  printf '%s\n' "${GRN}${BOLD}✓${RST}   ${badge}  ${emoji}  ${BOLD}${title}${RST}  ${DIM}· ${detail}${RST}"
}

# --- banner (no animation in shell, but framed like the wizard) ---------------
banner() {
  printf '\n'
  printf '%s\n' "${MAG}${BOLD}"
  cat <<'EOF'
     ████████╗██╗   ██╗██████╗ ██████╗  ██████╗
     ╚══██╔══╝██║   ██║██╔══██╗██╔══██╗██╔═══██╗
        ██║   ██║   ██║██████╔╝██████╔╝██║   ██║
        ██║   ██║   ██║██╔══██╗██╔══██╗██║   ██║
        ██║   ╚██████╔╝██║  ██║██████╔╝╚██████╔╝
        ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚═════╝  ╚═════╝
EOF
  printf '%s\n' "${RST}"
  printf '  %s\n' "${DIM}drop-in agent OS  ·  rules  ·  phases  ·  loop${RST}"
  printf '\n'
}

# --- args --------------------------------------------------------------------
banner

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  cat <<EOF
${BOLD}Usage${RST}
  ${CYN}$(basename "$0")${RST} ${YEL}/absolute/path/to/YOUR_PROJECT${RST}

${BOLD}What it does${RST}
  📦  Copies Turboplan ${DIM}templates/rules${RST}     →  ${DIM}.cursor/rules/${RST}
  🧠  Copies Turboplan ${DIM}templates/skills${RST}    →  ${DIM}.claude/skills/${RST}
  📋  Copies Turboplan ${DIM}templates/phases${RST}    →  ${DIM}planning/phases/${RST}
  🌱  Copies ${DIM}templates/seeds/${RST}              →  ${DIM}planning/*-SEED${RST}
       (readme · gitignore · verify → Makefile / lefthook / golangci)
  🔗  Creates ${DIM}CLAUDE.md${RST} → ${DIM}.cursor/rules/general.mdc${RST}

${BOLD}Then${RST}
  Open the project and run ${MAG}/bootstrap-turboplan${RST} with your goal.
  Bootstrap adapts seeds to the ${BOLD}repo root${RST} (verify gate must not stay only under planning/).
EOF
  exit 0
fi

[[ $# -eq 1 ]] || die "Pass exactly one argument: absolute path to the target project. Try --help"

TARGET="$1"

[[ "${TARGET}" == /* ]] || die "Path must be absolute (start with /). Got: ${TARGET}"
[[ -d "${TARGET}" ]] || die "Directory does not exist: ${TARGET}"
[[ -d "${PACK_ROOT}/templates/rules" ]] || die "Pack templates missing under ${PACK_ROOT}"
[[ -d "${PACK_ROOT}/templates/skills" ]] || die "Pack templates missing under ${PACK_ROOT}"
[[ -d "${PACK_ROOT}/templates/phases" ]] || die "Pack templates missing under ${PACK_ROOT}"
[[ -d "${PACK_ROOT}/templates/seeds" ]] || die "Pack seeds missing: templates/seeds/"
[[ -f "${PACK_ROOT}/templates/seeds/readme/README-SEED.md" ]] || die "README seed missing"
[[ -f "${PACK_ROOT}/templates/seeds/gitignore/gitignore-SEED" ]] || die "gitignore seed missing"
[[ -d "${PACK_ROOT}/templates/seeds/verify" ]] || die "verify seeds missing: templates/seeds/verify/"
[[ -f "${PACK_ROOT}/templates/seeds/verify/Makefile" ]] || die "verify Makefile missing"
[[ -f "${PACK_ROOT}/templates/seeds/verify/lefthook.yml" ]] || die "verify lefthook missing"

# Refuse to install into the pack itself by accident
if [[ "$(cd "${TARGET}" && pwd)" == "${PACK_ROOT}" ]]; then
  die "Refusing to install into the Turboplan pack itself (${PACK_ROOT})"
fi

echo
printf '%s\n' "  ${BOLD}${WHT}🎯  Target${RST}  ${WHT}${TARGET}${RST}"
printf '%s\n' "  ${BOLD}📦  Pack${RST}    ${DIM}${PACK_ROOT}${RST}"
printf '%s\n' "  ${DIM}══════════════════════════════════════════════════════════${RST}"
echo

TOTAL_STEPS=8
STEP=0

# --- step 1: dirs ------------------------------------------------------------
spin_start "Creating project directories"
mkdir -p \
  "${TARGET}/.cursor/rules" \
  "${TARGET}/.claude/skills" \
  "${TARGET}/planning/phases" \
  "${TARGET}/planning/verify-SEED"
sleep 2.5
STEP=$((STEP + 1))
spin_stop
step_done "${STEP}" "${TOTAL_STEPS}" "📂" "Directories" ".cursor / .claude / planning"

# --- step 2: rules -----------------------------------------------------------
spin_start "Installing agent rules"
cp -R "${PACK_ROOT}/templates/rules/." "${TARGET}/.cursor/rules/"
sleep 2.2
STEP=$((STEP + 1))
spin_stop
step_done "${STEP}" "${TOTAL_STEPS}" "🧭" "Agent rules" ".cursor/rules/"

# --- step 3: skills ----------------------------------------------------------
spin_start "Installing agent skills"
shopt -s nullglob
for skill_dir in "${PACK_ROOT}/templates/skills/"*/; do
  name="$(basename "${skill_dir}")"
  mkdir -p "${TARGET}/.claude/skills/${name}"
  cp -R "${skill_dir}." "${TARGET}/.claude/skills/${name}/"
done
shopt -u nullglob
sleep 2.3
STEP=$((STEP + 1))
spin_stop
step_done "${STEP}" "${TOTAL_STEPS}" "🧩" "Agent skills" ".claude/skills/"

# --- step 4: phases ----------------------------------------------------------
spin_start "Seeding phase INDEX + template"
cp "${PACK_ROOT}/templates/phases/INDEX.md" "${TARGET}/planning/phases/INDEX.md"
cp "${PACK_ROOT}/templates/phases/TXX-template.md" "${TARGET}/planning/phases/_TEMPLATE.md"
sleep 2.0
STEP=$((STEP + 1))
spin_stop
step_done "${STEP}" "${TOTAL_STEPS}" "📋" "Phase plan" "planning/phases/"

# --- step 5: human README seed -----------------------------------------------
spin_start "Installing README seed"
cp "${PACK_ROOT}/templates/seeds/readme/README-SEED.md" "${TARGET}/planning/README-SEED.md"
sleep 2.0
STEP=$((STEP + 1))
spin_stop
step_done "${STEP}" "${TOTAL_STEPS}" "👤" "README seed" "planning/README-SEED.md"

# --- step 6: gitignore seed --------------------------------------------------
spin_start "Installing gitignore seed"
cp "${PACK_ROOT}/templates/seeds/gitignore/gitignore-SEED" "${TARGET}/planning/gitignore-SEED"
sleep 2.0
STEP=$((STEP + 1))
spin_stop
step_done "${STEP}" "${TOTAL_STEPS}" "🙈" "gitignore seed" "planning/gitignore-SEED"

# --- step 7: verify seeds ----------------------------------------------------
spin_start "Installing verify seeds"
mkdir -p "${TARGET}/planning/verify-SEED"
cp "${PACK_ROOT}/templates/seeds/verify/Makefile" "${TARGET}/planning/verify-SEED/Makefile"
cp "${PACK_ROOT}/templates/seeds/verify/lefthook.yml" "${TARGET}/planning/verify-SEED/lefthook.yml"
if [[ -f "${PACK_ROOT}/templates/seeds/verify/golangci.yml" ]]; then
  cp "${PACK_ROOT}/templates/seeds/verify/golangci.yml" "${TARGET}/planning/verify-SEED/golangci.yml"
fi
sleep 2.8
STEP=$((STEP + 1))
spin_stop
step_done "${STEP}" "${TOTAL_STEPS}" "🧪" "Verify tooling" "Makefile / lefthook / golangci"

# --- step 8: CLAUDE.md symlink -----------------------------------------------
spin_start "Linking CLAUDE.md hub"
(
  cd "${TARGET}"
  ln -sfn .cursor/rules/general.mdc CLAUDE.md
)
sleep 2.0
STEP=$((STEP + 1))
spin_stop
step_done "${STEP}" "${TOTAL_STEPS}" "🔗" "CLAUDE.md symlink" "→ .cursor/rules/general.mdc"

# --- finale (wizard-style framed summary) -------------------------------------
echo

bar="${GRN}${BOLD}══════════════════════════════════════════════════════════${RST}"
printf '%s\n' "  ${bar}"
printf '  %s  %s\n' \
  "${GRN}${BOLD}✦${RST}" \
  "${BOLD}${WHT}Turboplan landed — ready for bootstrap${RST}"
printf '%s\n' "  ${bar}"
echo

printf '%s\n' "  ${BOLD}${WHT}📍  Installed into${RST}"
printf '    %s\n\n' "${WHT}${TARGET}${RST}"

printf '%s\n' "  ${BOLD}${WHT}🧪  Quick verify${RST}"
printf '    %s\n' "${DIM}ls ${TARGET}/.cursor/rules${RST}"
printf '    %s\n' "${DIM}ls ${TARGET}/.claude/skills${RST}"
printf '    %s\n' "${DIM}test -f ${TARGET}/planning/README-SEED.md && echo README-SEED ok${RST}"
printf '    %s\n' "${DIM}test -f ${TARGET}/planning/gitignore-SEED && echo gitignore-SEED ok${RST}"
printf '    %s\n' "${DIM}test -f ${TARGET}/planning/verify-SEED/Makefile && echo verify-SEED ok${RST}"
printf '    %s\n' "${DIM}readlink ${TARGET}/CLAUDE.md${RST}"
echo

# -- numbered next steps like wizard -------------------------------------------
printf '%s\n' "  ${BOLD}${WHT}🚀  Next steps${RST}"
echo
printf '%s\n' "  ${BOLD}${WHT}1️⃣${RST}   Open the project in Cursor / Claude Code"
printf '    %s\n\n' "${DIM}That's where the agent reads the rules you just installed.${RST}"
printf '%s\n' "  ${BOLD}${WHT}2️⃣${RST}   Run ${MAG}/bootstrap-turboplan${RST} with your goal"
printf '    %s\n\n' "${DIM}The agent will ask for a detailed goal, technical scope, and constraints.${RST}"
printf '%s\n' "  ${BOLD}${WHT}3️⃣${RST}   Bootstrap adapts seeds to the repo root"
printf '    %s\n\n' "${DIM}Makefile / lefthook / .gitignore / README — not just under planning/.${RST}"
printf '%s\n' "  ${BOLD}${WHT}4️⃣${RST}   Review the verify gate, then ${MAG}/task-1-plan T01${RST}"
printf '    %s\n\n' "${DIM}Prefer a large / expensive model for the plan.${RST}"
echo

printf '%s\n' "${DIM}Docs: METHODOLOGY.md${RST}"
echo
printf '%s\n' "🏁  ${BOLD}Happy long-horizon building.${RST} 🛠️"

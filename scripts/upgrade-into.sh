#!/usr/bin/env bash
# Insert methodology 2 blocks into a project that already uses Turboplan.
# Usage: ./scripts/upgrade-into.sh /absolute/path/to/PROJECT
set -euo pipefail

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  echo "Usage: $(basename "$0") /absolute/path/to/PROJECT"
  echo "Refuses a project that does not already have Turboplan. Use scripts/install-into.sh for a new tree."
  exit 0
fi

if [[ $# -ne 1 ]]; then
  echo "Pass exactly one argument: absolute path to the target project." >&2
  exit 2
fi

TARGET="$1"
if [[ "${TARGET}" != /* ]]; then
  echo "Path must be absolute (start with /). Got: ${TARGET}" >&2
  exit 2
fi
if [[ ! -d "${TARGET}" ]]; then
  echo "Directory does not exist: ${TARGET}" >&2
  exit 2
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACK_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 is required for upgrade-into.sh" >&2
  exit 2
fi

exec python3 - "${TARGET}" "${PACK_ROOT}" <<'PY'
import os
import re
import shutil
import subprocess
import sys
from pathlib import Path

target = Path(sys.argv[1]).resolve()
pack = Path(sys.argv[2]).resolve()

hub_path = target / ".cursor/rules/general.mdc"
dial_path = target / ".cursor/skills/dialectic-of-cognition/SKILL.md"
exec_path = target / ".cursor/skills/task-2-execute/SKILL.md"

if not hub_path.is_file() or not dial_path.is_file():
    print(
        "This project does not have Turboplan yet. Run scripts/install-into.sh "
        + str(target),
        file=sys.stderr,
    )
    sys.exit(2)

PAIR_SOURCES = {
    "ponytail": pack / "templates/rules/general.mdc",
    "abort-gate": pack / "templates/rules/general.mdc",
    "disposition-principle": pack / "templates/rules/general.mdc",
    "graphify-query": pack / "templates/rules/general.mdc",
    "disposition": pack / "templates/skills/dialectic-of-cognition/SKILL.md",
    "execute-ponytail-graph": pack / "templates/skills/task-2-execute/SKILL.md",
}
VERSION_LINE = "<!-- turboplan-methodology: 2 -->"
STOCK_ABORT = " ".join(
    """
Before extracting a principle, apply the one-sentence test: **can you state the
rule without naming a specific file, function, class, variable, or endpoint?**
If not, stop here — there is nothing to encode. The value stays in the diff.
""".split()
)


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def extract_pair(text: str, name: str) -> str:
    start = f"<!-- turboplan:{name} -->"
    end = f"<!-- /turboplan:{name} -->"
    i = text.find(start)
    j = text.find(end)
    if i < 0 or j < 0 or j < i:
        raise SystemExit(f"pack template missing marker turboplan:{name}")
    block = text[i : j + len(end)]
    if not block.endswith("\n"):
        block += "\n"
    return block


pack_text = {path: read_text(path) for path in set(PAIR_SOURCES.values())}
blocks = {name: extract_pair(pack_text[path], name) for name, path in PAIR_SOURCES.items()}


def has_pair(text: str, name: str) -> bool:
    return f"<!-- turboplan:{name} -->" in text and f"<!-- /turboplan:{name} -->" in text


def replace_pair(text: str, name: str, block: str) -> str:
    start = f"<!-- turboplan:{name} -->"
    end = f"<!-- /turboplan:{name} -->"
    i = text.find(start)
    j = text.find(end)
    if i < 0 or j < 0 or j < i:
        return text
    j2 = j + len(end)
    return text[:i] + block.rstrip("\n") + text[j2:]


def split_keep(text: str):
    return text.splitlines(keepends=True)


def join_lines(lines) -> str:
    return "".join(lines)


def find_line(lines, predicate):
    for i, line in enumerate(lines):
        if predicate(line.rstrip("\r\n")):
            return i
    return None


def insert_at(lines, index: int, block: str):
    piece = block if block.endswith("\n") else block + "\n"
    lines.insert(index, piece)


def heading_span(lines, index: int):
    j = index + 1
    while j < len(lines) and not re.match(r"^#{1,6}\s", lines[j]):
        j += 1
    return j


def norm(text: str) -> str:
    return " ".join(text.replace("–", "—").split())


def is_stock_abort(body: str) -> bool:
    n = norm(body)
    if not n or "turboplan:abort-gate" in body:
        return False
    stock = STOCK_ABORT
    return n == stock or n == stock.replace("—", "-")


insertions = []
unplaced = []
notes = []


def already_v2(hub: str, dial: str, exe: str) -> bool:
    if VERSION_LINE not in hub:
        return False
    for name in ("ponytail", "abort-gate", "disposition-principle", "graphify-query"):
        if not has_pair(hub, name):
            return False
    if not has_pair(dial, "disposition"):
        return False
    if not has_pair(exe, "execute-ponytail-graph"):
        return False
    return True


hub = read_text(hub_path)
dial = read_text(dial_path)
exe = read_text(exec_path) if exec_path.is_file() else None
skip_prose = exe is not None and already_v2(hub, dial, exe)

if skip_prose:
    print("already at methodology 2")
    notes.append("already at methodology 2")
else:
    # Version comment after YAML frontmatter.
    if VERSION_LINE in hub:
        insertions.append("turboplan-methodology: 2 already present")
    elif not hub.startswith("---"):
        unplaced.append(("turboplan-methodology: 2", VERSION_LINE + "\n"))
    else:
        rest = hub.find("\n---", 3)
        end = hub.find("\n", rest + 1) if rest >= 0 else -1
        if rest < 0 or end < 0:
            unplaced.append(("turboplan-methodology: 2", VERSION_LINE + "\n"))
        else:
            hub = hub[: end + 1] + "\n" + VERSION_LINE + "\n" + hub[end + 1 :]
            insertions.append("turboplan-methodology: 2 inserted after frontmatter")

    # Ponytail after the Karpathy heading.
    if has_pair(hub, "ponytail"):
        hub = replace_pair(hub, "ponytail", blocks["ponytail"])
        insertions.append("ponytail replaced from pack")
    else:
        lines = split_keep(hub)
        idx = find_line(
            lines,
            lambda s: s in ("# Karpathy Behavioral Guidelines", "## Karpathy Behavioral Guidelines"),
        )
        if idx is None:
            unplaced.append(("ponytail", blocks["ponytail"]))
        else:
            insert_at(lines, idx + 1, blocks["ponytail"])
            hub = join_lines(lines)
            insertions.append("ponytail inserted after Karpathy heading")

    # Abort gate. Marker wins. Stock body is replaced. Any other body is kept and the block is appended.
    if has_pair(hub, "abort-gate"):
        hub = replace_pair(hub, "abort-gate", blocks["abort-gate"])
        insertions.append("abort-gate replaced from pack")
    else:
        lines = split_keep(hub)
        idx = find_line(lines, lambda s: "Abort gate" in s and s.lstrip().startswith("#"))
        if idx is None:
            unplaced.append(("abort-gate", blocks["abort-gate"]))
        else:
            end = heading_span(lines, idx)
            body = "".join(lines[idx + 1 : end])
            if is_stock_abort(body):
                lines[idx + 1 : end] = [blocks["abort-gate"]]
                insertions.append("abort-gate replaced stock body")
            else:
                insert_at(lines, idx + 1, blocks["abort-gate"])
                notes.append(
                    "abort gate: both texts are present; delete the stock sentence if it contradicts the marked block"
                )
                insertions.append("abort-gate appended after heading; existing body kept")
            hub = join_lines(lines)

    # Disposition principle after the abort-gate block, else after the Abort gate heading.
    if has_pair(hub, "disposition-principle"):
        hub = replace_pair(hub, "disposition-principle", blocks["disposition-principle"])
        insertions.append("disposition-principle replaced from pack")
    else:
        end_marker = "<!-- /turboplan:abort-gate -->"
        if end_marker in hub:
            lines = split_keep(hub)
            idx = find_line(lines, lambda s: end_marker in s)
            insert_at(lines, idx + 1, blocks["disposition-principle"])
            hub = join_lines(lines)
            insertions.append("disposition-principle inserted after abort-gate block")
        else:
            lines = split_keep(hub)
            idx = find_line(lines, lambda s: "Abort gate" in s and s.lstrip().startswith("#"))
            if idx is None:
                unplaced.append(("disposition-principle", blocks["disposition-principle"]))
            else:
                insert_at(lines, idx + 1, blocks["disposition-principle"])
                hub = join_lines(lines)
                insertions.append("disposition-principle inserted after Abort gate heading")

    # Query sentence. Upgrade anchor is the Project Architecture heading, not Build & Run.
    if has_pair(hub, "graphify-query"):
        hub = replace_pair(hub, "graphify-query", blocks["graphify-query"])
        insertions.append("graphify-query replaced from pack")
    else:
        lines = split_keep(hub)
        idx = find_line(lines, lambda s: s == "## Project Architecture")
        if idx is None:
            hub = hub + ("\n" if hub and not hub.endswith("\n") else "") + blocks["graphify-query"]
            notes.append("graphify-query appended at end of file; ## Project Architecture was absent")
            insertions.append("graphify-query appended at end of file")
        else:
            insert_at(lines, idx + 1, blocks["graphify-query"])
            hub = join_lines(lines)
            insertions.append("graphify-query inserted after ## Project Architecture")

    # Dialectic disposition before the first ## Mode A heading.
    if has_pair(dial, "disposition"):
        dial = replace_pair(dial, "disposition", blocks["disposition"])
        insertions.append("disposition replaced from pack")
    else:
        lines = split_keep(dial)
        idx = find_line(lines, lambda s: s == "## Mode A" or s.startswith("## Mode A "))
        if idx is None:
            unplaced.append(("disposition", blocks["disposition"]))
        else:
            insert_at(lines, idx, blocks["disposition"])
            dial = join_lines(lines)
            insertions.append("disposition inserted before ## Mode A")

    # Execute block after ## Hard constraints.
    if exe is None:
        unplaced.append(("execute-ponytail-graph", blocks["execute-ponytail-graph"]))
    elif has_pair(exe, "execute-ponytail-graph"):
        exe = replace_pair(exe, "execute-ponytail-graph", blocks["execute-ponytail-graph"])
        insertions.append("execute-ponytail-graph replaced from pack")
    else:
        lines = split_keep(exe)
        idx = find_line(lines, lambda s: s == "## Hard constraints")
        if idx is None:
            unplaced.append(("execute-ponytail-graph", blocks["execute-ponytail-graph"]))
        else:
            insert_at(lines, idx + 1, blocks["execute-ponytail-graph"])
            exe = join_lines(lines)
            insertions.append("execute-ponytail-graph inserted after ## Hard constraints")

    if hub != read_text(hub_path):
        hub_path.write_text(hub, encoding="utf-8")
    if dial != read_text(dial_path):
        dial_path.write_text(dial, encoding="utf-8")
    if exe is not None and exe != read_text(exec_path):
        exec_path.write_text(exe, encoding="utf-8")

# Infrastructure. Append only. Do not rewrite pre-commit or delete project excludes.
seed_ignore = pack / "templates/seeds/verify/graphifyignore"
ignore_path = target / ".graphifyignore"
seed_lines = [
    line.strip()
    for line in read_text(seed_ignore).splitlines()
    if line.strip() and not line.strip().startswith("#")
]
if not ignore_path.is_file():
    ignore_path.write_text(read_text(seed_ignore), encoding="utf-8")
    insertions.append(".graphifyignore created from seed")
else:
    current = read_text(ignore_path)
    existing = {line.strip() for line in current.splitlines()}
    missing = [line for line in seed_lines if line not in existing]
    if missing:
        suffix = current
        if suffix and not suffix.endswith("\n"):
            suffix += "\n"
        suffix += "\n".join(missing) + "\n"
        ignore_path.write_text(suffix, encoding="utf-8")
        insertions.append(".graphifyignore appended missing pack patterns")
    else:
        notes.append(".graphifyignore already had pack patterns")

gi_path = target / ".gitignore"
if gi_path.is_file():
    gi = read_text(gi_path)
    if "graphify-out/" not in gi:
        gi = gi + ("" if gi.endswith("\n") else "\n") + "graphify-out/\n"
        gi_path.write_text(gi, encoding="utf-8")
        insertions.append("gitignore appended graphify-out/")
    else:
        notes.append("gitignore already ignores graphify-out/")
else:
    gi_path.write_text("graphify-out/\n", encoding="utf-8")
    insertions.append("gitignore created with graphify-out/")

hook_cmd = "GRAPHIFY_BACKEND=none graphify update ."
hook_path = target / "lefthook.yml"
if not hook_path.is_file():
    notes.append("lefthook.yml absent, post-commit not added")
else:
    hook = read_text(hook_path)
    if hook_cmd in hook:
        notes.append("lefthook already runs the graphify update command")
    elif re.search(r"(?m)^post-commit:\s*$", hook):
        notes.append(
            "lefthook.yml already has post-commit without the graphify update command; pre-commit was left unchanged"
        )
    else:
        addition = (
            "\npost-commit:\n  commands:\n    graphify-update:\n      run: "
            + hook_cmd
            + "\n"
        )
        hook_path.write_text(hook + ("" if hook.endswith("\n") else "\n") + addition, encoding="utf-8")
        insertions.append("lefthook post-commit command appended")

graph_result = "CLI missing, graph not built"
graph_json = target / "graphify-out" / "graph.json"
if graph_json.is_file():
    graph_result = "graph already present"
elif shutil.which("graphify"):
    proc = subprocess.run(
        ["graphify", "update", "."],
        cwd=target,
        env={**os.environ, "GRAPHIFY_BACKEND": "none"},
        capture_output=True,
        text=True,
    )
    if graph_json.is_file() and proc.returncode == 0:
        graph_result = "graph built"
    else:
        graph_result = "graph absent"
        notes.append("graph update did not create graph.json; recorded graph absent")
else:
    graph_result = "CLI missing, graph not built"

report_dir = target / "planning"
report_dir.mkdir(parents=True, exist_ok=True)
parts = ["# Upgrade report", "", "## Insertions"]
if insertions:
    parts.extend(f"- {item}" for item in insertions)
else:
    parts.append("- none")
parts.extend(["", "## Unplaced"])
if unplaced:
    for name, block in unplaced:
        parts.append(f"### {name}")
        parts.append("")
        parts.append(block.rstrip("\n"))
        parts.append("")
else:
    parts.append("- none")
parts.extend(["", "## Notes"])
if notes:
    parts.extend(f"- {item}" for item in notes)
else:
    parts.append("- none")
parts.extend(["", "## Graph", "", graph_result, ""])
(report_dir / "upgrade-report.md").write_text("\n".join(parts), encoding="utf-8")

print(graph_result)
if unplaced:
    sys.exit(1)
sys.exit(0)
PY

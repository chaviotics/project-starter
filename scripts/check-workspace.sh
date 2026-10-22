#!/bin/sh
# check-workspace.sh: warns when the workspace's own files drift past the limits
# they declare. Budgets written into a file's header don't enforce themselves; this
# script is what makes them visible.
#
# Read-only. Always exits 0: it reports and never blocks.
# Runs at session start through hooks in .claude/settings.json (Claude Code) and
# .codex/hooks.json (Codex). Agents also run it at the end of every session.
#
# Usage: sh scripts/check-workspace.sh [workspace-dir]
#        (defaults to the workspace this script lives in)

cd "${1:-$(dirname "$0")/..}" 2>/dev/null || exit 0

warnings=""
warn() { warnings="${warnings}  - $1
"; }
notes=""
note() { notes="${notes}  note: $1
"; }

# A codebase folder still holding SETUP-CODEBASE.md hasn't been created yet; its
# template files are unfilled on purpose, so most checks skip it.
parked() { [ -f "$1/SETUP-CODEBASE.md" ]; }

# 1. Leftover setup placeholders. SETUP-PROMPT and README.md exist only until
#    setup finishes.
for f in *.md docs/*.md .gitignore .ignore memory/MEMORY.md */AGENTS.md */*/AGENTS.md */.gitignore; do
  [ -f "$f" ] || continue
  case "$f" in SETUP-PROMPT|README.md) continue ;; esac
  case "$f" in */*) parked "${f%%/*}" && continue ;; esac
  if grep -qE '\{\{[A-Z0-9_]+\}\}|SETUP:' "$f" 2>/dev/null; then
    warn "$f: unfilled {{placeholder}} or SETUP: comment left from setup"
  fi
done

# 2. Agent files: AGENTS.md stays short; CLAUDE.md is exactly one line.
for f in AGENTS.md */AGENTS.md */*/AGENTS.md; do
  [ -f "$f" ] || continue
  case "$f" in */*) parked "${f%%/*}" && continue ;; esac
  lines=$(wc -l < "$f" | tr -d ' ')
  [ "$lines" -gt 200 ] && warn "$f: $lines lines (keep under 200; move state to project-status.md)"
done

# 2b. Every TODO names its open item, wherever it sits.
for f in *.md docs/*.md */AGENTS.md */*/AGENTS.md; do
  [ -f "$f" ] || continue
  case "$f" in README.md|open-items.md|session-log.md) continue ;; esac
  case "$f" in */*) case "$f" in docs/*) ;; *) parked "${f%%/*}" && continue ;; esac ;; esac
  todos=$(grep 'TODO:' "$f" | grep -vc 'open-items #')
  [ "$todos" -gt 0 ] && warn "$f: $todos TODO: line(s) without '(open-items #N)'; resolve them or add the open item"
done
for f in CLAUDE.md */CLAUDE.md */*/CLAUDE.md; do
  [ -f "$f" ] || continue
  [ "$(cat "$f")" = "@AGENTS.md" ] || warn "$f: must be exactly one line, @AGENTS.md; move content into AGENTS.md"
done

# 3. Session log: row length and month rollover.
if [ -f session-log.md ]; then
  set -- $(awk -F'|' -v m="$(date +%Y-%m)" '
    /^\| *20[0-9][0-9]-[0-9][0-9]-[0-9][0-9]/ {
      d = $2; gsub(/ /, "", d)
      if (split($(NF-1), w, " ") > 30) long++
      if (substr(d, 1, 7) != m) old++
    }
    END { print long + 0, old + 0 }' session-log.md)
  [ "$1" -gt 0 ] && warn "session-log.md: $1 row(s) over ~25 words; shorten them and move the detail into the log file"
  [ "$2" -gt 0 ] && warn "session-log.md: $2 row(s) from an earlier month; move them to logs/index-YYYY-MM.md"
fi

# 4. Open items: row length and closed rows that should have moved out.
if [ -f open-items.md ]; then
  set -- $(awk -F'|' '
    /^\| *[0-9]+ *\|/ {
      if (split($3, w, " ") > 70) long++
      if (toupper($4) ~ /^ *(CLOSED|DONE|RESOLVED)/) closed++
    }
    END { print long + 0, closed + 0 }' open-items.md)
  [ "$1" -gt 0 ] && warn "open-items.md: $1 row(s) over ~60 words; link the detail instead"
  [ "$2" -gt 0 ] && warn "open-items.md: $2 closed row(s); move them to logs/open-items-closed.md"
fi

# 5. Memory: index length and files the index doesn't mention.
if [ -f memory/MEMORY.md ]; then
  lines=$(wc -l < memory/MEMORY.md | tr -d ' ')
  [ "$lines" -gt 150 ] && warn "memory/MEMORY.md: $lines lines (Claude Code loads only the first 200)"
  bytes=$(wc -c < memory/MEMORY.md | tr -d ' ')
  [ "$bytes" -gt 20000 ] && warn "memory/MEMORY.md: $bytes bytes (Claude Code loads at most 25 KB)"
  missing=0
  for m in memory/*.md; do
    [ -f "$m" ] || continue
    name=$(basename "$m")
    [ "$name" = "MEMORY.md" ] && continue
    grep -qF -- "($name)" memory/MEMORY.md || missing=$((missing + 1))
  done
  [ "$missing" -gt 0 ] && warn "memory/: $missing file(s) not listed in MEMORY.md"
fi

# 6. Status: the Now section should be at least as recent as the latest log.
if [ -f project-status.md ]; then
  now=$(sed -n 's/.*Last updated:[* ]*\([0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}\).*/\1/p' project-status.md | head -1)
  latest=$(ls logs 2>/dev/null | grep -E '^20[0-9]{2}-[0-9]{2}-[0-9]{2}-' | sort | tail -1 | cut -c1-10)
  if [ -z "$now" ]; then
    warn "project-status.md: Now has no 'Last updated: YYYY-MM-DD' date"
  elif [ -n "$latest" ] && [ "$latest" \> "$now" ]; then
    warn "project-status.md: Now dated $now, but the latest log is $latest; update Now"
  fi
fi

# 7. Memory location: Claude Code's auto memory must point at this workspace's
#    memory/. Moving the folder or a new machine silently splits it otherwise.
here=$(pwd -P)
for s in .claude/settings.local.json */.claude/settings.local.json; do
  case "$s" in */*) parked "${s%%/*}" && continue ;; esac
  if [ ! -f "$s" ]; then
    [ "$s" = ".claude/settings.local.json" ] && [ -d memory ] && \
      warn ".claude/settings.local.json missing; set autoMemoryDirectory to $here/memory"
    continue
  fi
  dir=$(sed -n 's/.*"autoMemoryDirectory"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$s" | head -1)
  case "$dir" in "~/"*) dir="$HOME/${dir#\~/}" ;; esac
  dir=${dir%/}
  [ -d "$dir" ] && dir=$(cd "$dir" && pwd -P)
  [ "$dir" = "$here/memory" ] || warn "$s: autoMemoryDirectory is '${dir:-unset}', expected $here/memory"
done

# 8. Codebases listed in AGENTS.md that exist on disk but aren't repositories:
#    work inside them would be in no history at all.
if [ -f AGENTS.md ]; then
  sed -n 's/^| `\([^`/]*\)\/` |.*/\1/p' AGENTS.md | while IFS= read -r d; do
    [ -d "$d" ] && [ ! -e "$d/.git" ] && ! parked "$d" && echo "$d"
  done > "${TMPDIR:-/tmp}/check-workspace.$$"
  while IFS= read -r d; do
    warn "$d/: listed as a codebase but has no .git; run git init inside it"
  done < "${TMPDIR:-/tmp}/check-workspace.$$"
  rm -f "${TMPDIR:-/tmp}/check-workspace.$$"
fi

# 9. Git boundary: every codebase repository is ignored by the root, and the root
#    tracks nothing inside it.
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  for g in */.git; do
    [ -e "$g" ] || continue
    d=${g%/.git}
    git check-ignore -q "$d" || warn "$d/: codebase repository not ignored by the root .gitignore (add /$d/)"
    grep -qxF "!/$d/" .ignore 2>/dev/null || \
      warn "$d/: missing from .ignore, so code search from the root skips it (add !/$d/)"
    [ -n "$(git ls-files -- "$d" | head -1)" ] && warn "$d/: root repository tracks files inside this codebase"
  done
fi

# 10. Codebases not created yet, and content awaiting approval: notes, not
#     warnings.
for p in */SETUP-CODEBASE.md; do
  [ -f "$p" ] && note "${p%%/*}/: not created yet; follow $p once the stack is decided"
done
for g in */.git; do
  [ -e "$g" ] || continue
  d=${g%/.git}
  n=$(grep -rI --exclude-dir=node_modules --exclude-dir=.git --exclude-dir=.next \
        --exclude-dir=dist --exclude-dir=build \
        --exclude=AGENTS.md --exclude=README.md 'APPROVAL:' "$d" 2>/dev/null \
        | grep -v "^$d/docs/superpowers/" | wc -l | tr -d ' ')
  [ "$n" -gt 0 ] && note "$d/: $n APPROVAL: marker(s) awaiting sign-off; launch needs zero"
done

if [ -z "$warnings" ]; then
  echo "workspace check: ok"
else
  count=$(printf '%s' "$warnings" | grep -c '^  - ')
  printf 'workspace check: %s warning(s)\n%s' "$count" "$warnings"
fi
printf '%s' "$notes"
exit 0

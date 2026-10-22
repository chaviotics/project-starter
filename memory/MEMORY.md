# Memory index — {{PROJECT_NAME}}

The project's one memory store, visible and human-editable. Correct or delete any
file here freely. Claude Code writes here directly (`autoMemoryDirectory` in
`.claude/settings.local.json`). Codex reads this index at session start and writes
here too. Two stores would mean two truths.

**What belongs here:** facts the repository doesn't record. Decisions and the
reasons for them, alternatives rejected, client preferences, and gotchas that cost
real time. Not code structure, past fixes, or anything git history already shows.

One fact per file. Use absolute dates. Link related memories with
`[[their-filename]]`.

**Row budget: one line per memory**, with a link and a hook short enough to judge
relevance from. Keep this file under 150 lines, because Claude Code loads only the
first 200.

## Index

<!-- - [name](name.md) — one-line hook -->

# AGENTS.md — {{PROJECT_NAME}}

Rules for the **workspace root**: planning, docs, and continuity. Each codebase below
is its own Git repository with its own `AGENTS.md`. `CLAUDE.md` here is one line,
`@AGENTS.md`, so both tools read this file; two hand-synced files drift in weeks.

**Rules, not state.** Focus, progress, and blockers live in `project-status.md`.
When a decision changes something here (stack, path, invariant), update this file
in the same session; agents trust it, so a stale one misleads.

## Project

<!-- SETUP: Delete the Client line on a personal project and the Governing
     document line when there is none. Delete the field; never write "N/A". -->

- **Client:** {{CLIENT_NAME}}
- **Size:** {{SIZE}} (stack: see Codebases below)
- **Source of truth:** [docs/sot.md](docs/sot.md), built from the originals in
  `docs/source/`. The originals are never renamed or edited.
- **Hosting:** {{HOSTING}}
- **Governing document:** {{CONTRACT_REF}}. It sets phases, milestones, and
  acceptance wording; where it and this workspace disagree, it wins.

## Workspace map

```text
{{PROJECT_SLUG}}/
├── AGENTS.md             <- this file; CLAUDE.md beside it is one line: @AGENTS.md
├── project-status.md     <- where things stand now; agents keep it current
├── open-items.md         <- deferred decisions and known risks
├── session-log.md, logs/ <- this month's index; one file per logged session
├── memory/               <- the one memory store, indexed by memory/MEMORY.md
├── docs/                 <- sot.md, accounts.md, source/ originals, design/
└── {{APP_DIR}}/          <- separate repository: the deliverable
```

### Codebases

<!-- SETUP: One row per codebase, and one map line above per codebase. -->

| Directory | What it is | Stack | Origin |
|---|---|---|---|
| `{{APP_DIR}}/` | {{APP_DESCRIPTION}} | {{STACK}} | {{APP_ORIGIN}} |

**Git boundary.** The root is a private repository; each codebase is a separate one
and is what the client receives. The root `.gitignore` lists each codebase by name;
`.ignore` re-includes it for code search, so search with the Grep tool or `rg` (a
plain `grep -r` from here skips the code). Before committing at the root, confirm
`git status` lists nothing from inside a codebase.

## Session start

Start every session here, at the workspace root, not inside a codebase. Settings,
hooks, skills, and this file all load from where a session starts.

1. Read `project-status.md` (the **Now** section first), the top three rows of
   `session-log.md` (or the newest `logs/index-YYYY-MM.md` right after a monthly
   rollover), and `memory/MEMORY.md`.
2. Run `git status` at the root and in each codebase. Another agent may have
   stopped mid-task, for example when its usage ran out. Inspect uncommitted work
   before assuming anything, and say what you found.
3. Read `open-items.md` before proposing work in an area it touches.
4. `scripts/check-workspace.sh` runs at start through a hook in both tools; if its
   output isn't in your context, run it. Fix warnings in files you'll touch.
5. Before editing inside a codebase, read that codebase's `AGENTS.md`, and the
   part's own `AGENTS.md` (`client/`, `server/`) if it has one. Codex doesn't
   load those automatically from here.

## Session end

1. **Update `project-status.md`**: replace the Now lines, update build-list items
   you verified, add blockers. Sign-offs and money change only on the human's word.
2. **Log only what is worth finding later**: a decision, a scope change, or
   something costly to rediscover gets `logs/YYYY-MM-DD-NN-slug.md` (from
   `logs/_template.md`) and a `session-log.md` row. A tweak's record is its commit.
3. A deferred decision or risk goes in `open-items.md`. A lasting fact goes in
   `memory/`.
4. Commit code in its codebase repository and planning here, never across the
   boundary. No AI co-author or attribution lines in commits or PRs.
5. Run `scripts/check-workspace.sh` and fix what it flags in files you touched.

## Planning artifacts

Specs and plans go in `{{APP_DIR}}/docs/superpowers/specs/` and `.../plans/`, in
the codebase the work belongs to. **This path overrides any skill's default.**
Never create `docs/superpowers/` at this root; two trees drift. Work with no
codebase behind it keeps its spec beside the artifact under `docs/`.

While a codebase folder still holds `SETUP-CODEBASE.md` it is in no repository, so
its specs and plans go in `docs/specs/` and `docs/plans/` here until it's created.
Specs and plans are for features and multi-file changes; a tweak goes straight to
code with a clear commit message.

**Worktrees** of a codebase go in `.worktrees/` at this root:
`git -C {{APP_DIR}} worktree add ../.worktrees/<branch> -b <branch>`. Don't use
Claude Code's built-in worktree command from here; it would branch this planning
repository, not the code.

## Design

<!-- SETUP: Delete this section if the project has no user interface. -->

- Before any frontend change, read `DESIGN.md` once it exists (tokens, do/don't)
  and the `docs/design/decisions.md` lines for the page or component you touch.
- Log every accepted or rejected design variant in `docs/design/decisions.md`: one
  line with the reason. Rejected choices must not come back in a later session.
- Tokens in code are canonical. Regenerate `DESIGN.md` from them with the design
  skill (`/impeccable document`); never edit both by hand.

## Scope and approvals

<!-- SETUP: On a personal project, delete the first bullet. -->

- **Scope is the "Scope in" list in `docs/sot.md`.** Work outside it is a change
  request. Flag it before building, add an open item with requested, quoted, and
  approved dates, and build only on the owner's word. Never absorb extra work
  silently because it's technically easy.
- **Content that needs someone's approval** (prices, claims, testimonials, names,
  figures, contact details) is shown as a visible placeholder and marked in code
  with an `APPROVAL:` comment saying what's pending. Never invent the real value.
  The check script counts these markers, and launch needs zero.

## Behavioral rules

*After Andrej Karpathy's coding-agent observations; the full version, with its
checks, is in each codebase's `AGENTS.md`. Caution over speed.*

1. **Think before coding.** State assumptions; present competing readings; if unclear, ask.
2. **Simplicity first.** The minimum that solves the stated problem; nothing speculative.
3. **Surgical changes.** Touch only what's asked; match style; mention dead code, don't delete it.
4. **Goal-driven execution.** Turn vague asks into verifiable goals, each with a verify step.
5. **Suggest a better way** when one clearly exists, with concrete reasoning.

## Project invariants (don't violate without flagging)

Breaking one is not a trade-off an agent makes alone. Raise it and wait.

- {{INVARIANT_1}}
- {{INVARIANT_2}}
- {{INVARIANT_3}}

## Memory

- `./memory/` is the only memory store, indexed by `memory/MEMORY.md`. Claude Code
  writes here through `autoMemoryDirectory` (`.claude/settings.local.json`); Codex
  reads `MEMORY.md` at session start and writes here too.
- Save what code and git don't record: decisions and reasons, rejected options,
  client preferences, costly gotchas. One fact per file, absolute dates. Keep
  `MEMORY.md` under 150 lines; Claude Code loads only the first 200.

## Agent collaboration

- Either agent may continue the other's work. Switching isn't automatic: the human
  opens the other tool here and it picks up from these files, so Session end
  matters. A good first message: "Continue from the previous agent: follow Session
  start, inspect uncommitted changes, and tell me where things stand."
- Anything that must cross a session or agent boundary goes in a file here, never
  only in chat or an agent's private store. Tag log entries `tool: Claude Code` or
  `tool: Codex`.
- **Tool configuration lives here at the root, not in the codebase**: `.claude/`
  (settings, skills, agents, hook scripts), `.agents/skills/` (symlinks to the
  `.claude/skills/` copies), `.codex/`, and `.mcp.json`. Sessions start here, so
  config inside the codebase wouldn't load. The codebase carries only its
  `AGENTS.md`, its one-line `CLAUDE.md`, `.github/`, and shared `.vscode/` settings,
  unless the human agrees the client's team should share the tooling.
- Codex runs `.codex/hooks.json` only after the human approves it with `/hooks`,
  again after any change. Claude Code plugins don't carry over to Codex.

## Confidentiality

<!-- SETUP: On a personal project, replace everything above the credentials
     paragraph with one line: what material here belongs to someone else and
     must not be copied in or referenced out (or "Nothing here belongs to anyone
     else."), plus: "If client work grows out of this project, it moves to its
     own client workspace." -->

Before any client document, data, or asset goes through an AI tool, the engagement
terms must permit it. Each AI vendor clears separately.

**Status, per tool:** {{AI_VENDOR_TERMS_STATUS}}

**A tool that isn't cleared opens none of the client's material**: not
`docs/source/`, and not `docs/sot.md`, `memory/`, or the logs, which are built from
it. If that's you, stop and say so before reading further.

If an action would cross that line, stop and flag it to the project owner. Don't
reason from what the contract probably allows or give a legal conclusion.

Credentials, keys, and tokens stay out of every repository, commit message, log,
and memory file. Track accounts in `docs/accounts.md`: the service, who owns it,
and where its credential lives, never the value. If you find a committed secret,
report it. Don't quietly rewrite history.

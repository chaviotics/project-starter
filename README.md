# Project Starter

**Read this file first.** `SETUP-PROMPT` is the second step: the text you paste
into Claude Code or Codex.

Copy this folder to start any new project: client or personal, a signed contract
or none, a two-week site or a multi-month build. You drop the project's documents
in, paste one prompt, confirm what the agent found, and get a workspace that is set
up for both agents and stays readable months later.

The agent does the setup, not an installer. Every file it edits is a plain file you
can read and correct.

## How to use it

1. **Copy and rename in one step.** The copy's name is the project slug. From the
   starter's repository, without cloning it:

   ```sh
   npx degit <owner>/project-starter ~/Projects/<project-slug>
   ```

   Or from a local copy: `cp -R _project-starter ~/Projects/<project-slug>`.
   `degit` copies the files without git history or a remote, so nothing dropped
   into the new project can be pushed back to the starter by accident. Always drop
   files into the copy, never into the master folder.

2. **Drop the source material into `docs/source/`** in the copy: the contract or
   proposal, the brief, call notes, existing content, brand assets, and mockups.
   Then fill in `docs/source/kickoff-notes.md` in your own words.

3. **Start Claude Code or Codex at the copy's top folder and paste the contents of
   `SETUP-PROMPT`.** The file has no extension on purpose, so editors show it as
   plain text that is easy to select.

4. **Answer the gate, then confirm the draft.** The agent first asks whether this
   is client work and whether the terms permit AI processing of the client's
   material. Only then does it read `docs/source/`. It drafts every answer in one
   table, citing where each came from, and asks only about the gaps. Signed
   status, money, and AI-vendor clearance always need your own confirmation.

When it finishes, the agent deletes `SETUP-PROMPT` and this README and reports what
it removed and why.

## What you end up with

```text
<project-slug>/              <- private root repository, never handed over
├── AGENTS.md                <- the rules every agent follows
├── CLAUDE.md                <- one line: @AGENTS.md
├── project-status.md        <- where things stand right now
├── open-items.md            <- decisions and risks deliberately deferred
├── session-log.md           <- this month's sessions, one row each
├── logs/                    <- one file per logged session
├── memory/                  <- lasting facts and lessons
├── DESIGN.md                <- UI projects: tokens and do/don't rules (from the design skill)
├── docs/
│   ├── sot.md               <- source of truth, every fact cited
│   ├── accounts.md          <- services, owners, where credentials live (never the values)
│   ├── design/decisions.md  <- UI projects: accepted and rejected design choices
│   └── source/              <- originals as received, never edited
├── scripts/
│   └── check-workspace.sh   <- flags files drifting past their limits
├── .gitignore               <- keeps each codebase out of this repository
├── .ignore                  <- lets code search from here still see each codebase
├── .claude/                 <- Claude Code: settings, session-start check, skills (launch-audit)
├── .codex/                  <- Codex: session-start check
├── .agents/skills/          <- Codex: links to the .claude/skills copies
└── <project-slug>/           <- the code (app/ in this starter); its own repository
    ├── AGENTS.md            <- engineering rules and exact commands
    ├── CLAUDE.md            <- one line: @AGENTS.md
    └── docs/superpowers/    <- specs and plans, versioned with the code
```

### What each part is for

| Part | What it is | Who writes it |
|---|---|---|
| `app/` | The code: a repository inside the workspace. Setup renames it to the project slug by default, so the code sits at `<slug>/<slug>/` (and avoids `app/app/` in frameworks that have their own `app/` folder). On client work it is what the client receives. It stays uncreated until the stack is decided; its `SETUP-CODEBASE.md` marks that. | Agents, during the build |
| `project-status.md` | **Now** (three lines: focus, next, waiting on), the build list, milestones, launch checks, and blockers. | Agents every session; sign-offs and money only on your word |
| `open-items.md` | Questions and risks parked for later, each with what resolves it. | Agents and you |
| `logs/` + `session-log.md` | **The diary.** What happened in a session and why: one file per session, plus a one-row-per-session index. Written once and not edited after. Read when you need the history of something. | Agents, at the end of sessions that decided something |
| `memory/` | **The lessons.** One lasting fact per file (a client preference, a gotcha, a rejected option), corrected or deleted when it stops being true. Loaded at the start of every session. | Agents, and you can edit any file |
| `docs/` | What the project *is*: the source of truth, original sources, design, deliverables. Parts of it may be shared with the client. | You and agents |
| `.claude/skills/launch-audit/` | A pre-launch audit both tools can run (`/launch-audit`): SEO, performance, accessibility, security, privacy, analytics, deploy, and handover, scoped to what the site actually has (forms, CMS, auth, payments). Run it on the final preview and again after the domain goes live. | Agents, before launch |
| `scripts/` | `check-workspace.sh`, which runs at every session start and warns when a file outgrows its limits, the status goes stale, memory points to the wrong place, or the git boundary breaks. It only reads; it never changes anything. | Nobody; it ships with the starter |

**Why logs and memory stay at the top level, not in `docs/`:** every session reads
them first, and the hooks, the check script, and the memory setting all point at
these short paths. `docs/` is what the project *is*; logs and memory are how the
work went. Share individual files from `docs/`, never the whole folder: it also
holds the source of truth, key dates, and `accounts.md`.

## Switching between Claude Code and Codex

Switching is not automatic. When one tool runs out of usage, open the other at the
same top folder. Both read the same `AGENTS.md`, `project-status.md`, `memory/`,
and logs, and both run the workspace check at session start. A good first message
for the new tool:

> Continue from the previous agent. Follow the Session start steps in AGENTS.md,
> inspect any uncommitted changes, and tell me where things stand before changing
> anything.

The handover is only as good as the files. That's why every session ends by
updating the Now lines. If a session was cut off mid-task, the uncommitted changes
are the record, and Session start says to inspect them first.

Codex loads the project's hook only after you trust the project and approve the
hook with `/hooks` in your first Codex session there. Skills must exist in both
`.claude/skills/` and `.agents/skills/` to work in both tools (setup links one copy
into the other). A Claude Code plugin doesn't carry over.

**On client work, only switch to a tool that is cleared for that client.** Each AI
vendor clears separately, and a tool that isn't cleared must not read the client's
material, which includes `docs/sot.md`, `memory/`, and the logs built from it.

## Where tool configuration lives

All agent tooling sits at the workspace root, because sessions start there and
config inside the codebase wouldn't load: `.claude/` (settings, skills, agents,
hook scripts), `.agents/skills/` (links to the same skills, for Codex), `.codex/`,
and `.mcp.json`. The codebase carries only its own `AGENTS.md`, a one-line
`CLAUDE.md`, `.github/`, and shared editor settings, and its `.gitignore` keeps
agent folders out. Exception: when the client's team will use the same tooling,
agree it with them and commit only portable config (no secrets, no personal paths).

Create skills, agents, hooks, and MCP servers when a need appears, not in advance.
Right after the first framework scaffold, run the claude-code-setup automation
recommender once and adopt only what you approve.

Worktrees of the code go in `.worktrees/<branch>` at the root
(`git -C <slug> worktree add ../.worktrees/<branch> -b <branch>`). Claude Code's
built-in worktree command, started at the root, would branch the planning
repository instead.

## Apps with a frontend and a backend

First check you need two parts at all: a full-stack framework (Next.js route
handlers or server actions, with a hosted database) usually covers both in one
app. A separate backend earns its place when another client (a mobile app, a
partner) uses the same API, the backend is in another language, or it runs heavy
background work.

When there are parts, the default is **one repository with the parts as folders**:

```text
acme/                 <- private workspace
└── acme/             <- one GitHub repository: the deliverable
    ├── AGENTS.md     <- shared rules and workspace-wide commands
    ├── client/       <- frontend, with its own short AGENTS.md
    └── server/       <- backend, API, and the database's schema and migrations
```

One repository is one thing to hand over and one history, and a change that spans
the API and the UI lands in a single commit; with pnpm or npm workspaces (and
Turborepo once builds get slow) each part keeps its own dependencies. Use separate
repositories, one codebase each side by side at the workspace root, only when
different people or teams own the parts, they ship on separate schedules, or the
client requires it. The database is a hosted service, not a folder: its connection
details go in `.env` and `docs/accounts.md`.

## Several GitHub accounts

Each codebase can push to a different GitHub account. One-time machine setup:

1. One SSH key per account, and a host alias for each in `~/.ssh/config`:

   ```text
   Host github.com-<account>
     HostName github.com
     User git
     IdentityFile ~/.ssh/id_ed25519_<account>
     IdentitiesOnly yes
   ```

   Keep `IdentityFile` out of any `Host *` block, or every alias offers that key.
2. Optionally, a commit identity per folder in `~/.gitconfig`:
   `[includeIf "gitdir:~/Projects/<client>/"]` with `path = ~/.gitconfig-<client>`
   (a file that sets `user.email`). Never put `includeIf` in a repository's own
   config.
3. Prefer SSH remotes. The macOS keychain caches one HTTPS login per host, which
   pushes as the wrong account.

Setup then asks, per codebase, which account owns it and which email commits, sets
both in that repository only, adds the remote through the alias, and verifies with
`ssh -T git@github.com-<account>`.

## Recommended tools

Install once, user-level, for every project: **superpowers** (in Claude Code and,
separately, in Codex), **Context7** (current framework docs, so agents stop
inventing APIs; keep client details out of its queries), and **Chrome DevTools
MCP** (console, network, performance, accessibility; on client work run it with
`--no-usage-statistics --no-performance-crux`). Commit attribution is turned off
in `.claude/settings.json`; set `"attribution": {"commit": "", "pr": ""}` in the
user-level settings too.

Per project, as needed: one design skill (impeccable by default, installed at
setup); Playwright CLI or agent-browser for end-to-end tests on web apps (one, not
both); grill-me to stress-test a plan before writing it; the Codex plugin for
Claude Code for second-opinion reviews, only where Codex is cleared;
claude-security or security-guidance for apps with logins, payments, or user data;
Graphify only for a large inherited codebase.

Skip: claude-mem (a second, global memory store, with hosted sync), Ponytail (it
duplicates the simplicity rules in `AGENTS.md`), GSD (a competing workflow to
superpowers), and the find-skills skill (run `npx skills find <query>` when
needed instead). Built in already: `/code-review`, `/security-review`, `/simplify`.

### Design workflow for a site

Direction first, then a small token set proven on one page, then lock it:

1. `/impeccable init`: brief → PRODUCT.md.
2. `/impeccable shape home` with the client's brand assets and two or three
   reference sites.
3. Tokens in code (colors, type pair and scale, spacing, radius), then
   `/impeccable document` → DESIGN.md.
4. Build the home page; screenshot desktop and phone; `/impeccable critique`, at
   most two rounds; log each decision in `docs/design/decisions.md`.
5. `/impeccable extract`, then the remaining pages, with the detector hook running
   on every edit.
6. Before handoff: `/impeccable audit` and `/impeccable polish`, then
   `/launch-audit`.

A design supplied in Figma skips step 2: the Figma MCP supplies the tokens and the
design skill only critiques.

## Light or full

Four questions shape the workspace. Each is asked on its own and never inferred
from the others: client or personal, is there a governing document, is money tied
to acceptance, and light or full.

| | Light | Full |
|---|---|---|
| Typical shape | One codebase, weeks | Several phases with separate sign-offs, months, or several codebases |
| Phases | None: the build list, milestones, and launch checks carry progress | The governing document's phases verbatim, or the standard 15 in SETUP-PROMPT's appendix, trimmed |
| Launch checks | A short list | Each check mapped to its phase |
| `docs/sot.md` | One page | As long as the sources require |

A governing document's phases are always used, whatever the size. Payment doesn't
decide size (a small site paid 50/50 is light with two milestones), and neither does
an undecided stack: the codebase simply waits until it's chosen.

## Why it's built this way

Each rule fixes a failure seen on a real project. A short version of each reason
sits beside the rule in the files themselves, so an agent reading one file alone
still knows why the rule exists.

**One agent file.** `AGENTS.md` is the only real instruction file, and `CLAUDE.md`
is one line that imports it. Two root files written from one source and kept in
sync by hand drifted to 78 and 130 lines within weeks, with the same rules in
different words.

**Rules in AGENTS.md, state in project-status.md.** Instruction files that carried
current state went stale. One still said "Stack: TODO, undecided" weeks after the
stack was chosen, and agents trusted it. AGENTS.md now holds rules only, and any
decision that changes a rule updates it in the same session.

**Agents keep the status file current.** A status file that only the human was
allowed to edit stopped being updated after its first month. Nearly two hundred
sessions later, every phase still showed "not started". Meanwhile a tracker that
agents could update became the real status file. Agents now update the Now section,
build list, and progress statuses every session. Only sign-offs and money columns
wait for the human's word.

**Two repositories.** The root holds planning, logs, memory, and sources, and is
versioned so none of it can be lost to an accidental delete. Each codebase is a
separate repository, ignored by the root, because that repository is what the
client receives, and private material must never have been in its history.

**A codebase is created when its stack is decided.** A codebase repository created
before the stack was chosen held one commit and a page of TODOs for two months,
while the real work happened elsewhere.

**Budgets are checked by a script, not just stated.** Stating a row budget in a
file's header wasn't enough. One session index reached 80 KB in nine weeks under a
"one sentence" budget, and a risk register held rows over 2,000 characters long
under a "three sentences" budget. `scripts/check-workspace.sh` reports these drifts
at every session start. It warns and never blocks.

**Log decisions, not tweaks.** One project logged every spacing and copy tweak as
its own session, more than 150 entries in one month. A tweak's record is its commit
message. A log entry is for a decision, a scope change, or something costly to
rediscover.

**Scope and approvals are explicit.** On a fixed fee, work quietly absorbed
outside the agreed scope is unpaid work. Out-of-scope requests become change
requests with dates. Content awaiting approval (prices, claims, testimonials) is
shown as a placeholder with an `APPROVAL:` marker the check script counts, instead
of a hand-kept list that drifts.

**Sources first, gate before reading.** The interview starts from the documents,
which cuts it down to the gaps. But reading a client's documents through an AI tool
is the very act the confidentiality gate controls, so the gate question comes
first. When clearance is pending, a deny rule in `.claude/settings.json` backs the
written rule up. One project's source of truth was read before its gate was even
established.

**One memory store.** `autoMemoryDirectory` points Claude Code's own memory at
`memory/`, which Codex reads and writes too. Without it, each agent keeps a private
store and they slowly disagree.

**One primary design skill, plus a design memory.** Overlapping design skills give
conflicting direction (one says always tint black, another calls tinted black a
tell of AI design), so setup installs one, impeccable by default. Agents also
forget accepted and rejected choices between sessions and drift back to generic
defaults, so DESIGN.md holds the rules and `docs/design/decisions.md` holds the
history, read before any frontend change.

**Code search stays whole.** The root `.gitignore` hides each codebase from the
root repository, and code search honors `.gitignore`, so a search from the root
found nothing in the code until `.ignore` re-included it.

**Removed, not "N/A".** Sections a project doesn't need are deleted at setup. A
status file that is mostly empty tables teaches the reader to skim.

## Keeping the starter current

When a project shows a rule failing, fix it here, in the starter, so the next
project starts with the fix. Note what was observed in the reason beside the rule,
and keep the reason to one line in the template files. The longer story belongs in
this README.

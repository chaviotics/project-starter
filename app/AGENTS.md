# {{PROJECT_NAME}} — engineering rules

Instructions for work inside this codebase. `CLAUDE.md` beside this file is one
line, `@AGENTS.md`, so Claude Code and Codex read the same rules.

This file is versioned with the code. Update it in the same commit as any change
it describes, so it stays accurate at every commit.

## Stack

{{STACK}}

**Read the documentation for the exact versions pinned in this repository before
writing framework code**, not current docs and not from memory. Where a framework
ships its own docs inside `node_modules` (or the equivalent), read those.

## Where things live

<!-- SETUP: For a codebase with parts (client/ and server/, say), list each part
     here: its folder, its stack, and what it owns. A part with its own stack
     gets a short `<part>/AGENTS.md` (stack, commands, and rules that apply only
     there) plus a one-line `<part>/CLAUDE.md`; shared rules stay in this file. -->

{{WHERE_THINGS_LIVE}}

**First scaffold.** Generators such as `create-next-app` refuse a directory that
already holds `AGENTS.md`, `CLAUDE.md`, or `.claude/`. Move those aside, run the
generator, and restore them. If the generator wrote its own `AGENTS.md` or
`CLAUDE.md`, merge its content into the top of this file and keep `CLAUDE.md` to the
one line. Confirm `.gitignore` still has the agent-local block from setup. Then run
the claude-code-setup automation recommender once (it reads, never writes) and
apply only what the human approves, with any config at the workspace root, not
here. Delete this paragraph afterward.

- `docs/superpowers/specs/` and `docs/superpowers/plans/` are the only home for
  specs and plans. They are committed with the work they describe.

## Commands

<!-- SETUP: With parts, give the commands that run everything from this folder
     (workspace scripts) here, and each part's own commands in its AGENTS.md. -->

| Purpose | Command |
|---|---|
| Install | `{{CMD_INSTALL}}` |
| Dev server | `{{CMD_DEV}}` |
| Test | `{{CMD_TEST}}` |
| Type-check | `{{CMD_TYPECHECK}}` |
| Lint | `{{CMD_LINT}}` |
| Build | `{{CMD_BUILD}}` |
| Deploy preview | `{{CMD_DEPLOY_PREVIEW}}` |

**Done means verified.** Before saying something works, run test, type-check,
lint, and build. For anything visible, also check it in a browser at phone and
desktop widths. Report failures with their output. Never weaken or delete a test to
make it pass.

### The dev server belongs to the human

{{DEV_SERVER_NOTES}}

1. Don't start a long-lived dev server unless asked. Tests, type-check, and lint
   don't need one.
2. When you do start one, run it as a tracked background task and stop it before
   the turn ends.
3. Never `pkill node`, `killall`, or kill by port without reading the process's
   command line first.

## Git

<!-- SETUP: On a personal project, replace the first two paragraphs below with:
     "This is the code repository. The workspace one level up is a separate,
     private repository; nothing from it belongs in this history. Never `git add`
     a path starting with `../`." -->

**This repository is the deliverable**, and it is what the client receives. The
workspace one level up is a separate, private repository. Nothing from it belongs
in this history. Never `git add` a path starting with `../`.

Everything here is client-visible: code, comments, specs, plans, and commit
messages. Never write fees, contract terms, or private commentary about the client
into any of them.

- The default branch is `{{DEFAULT_BRANCH}}`.
- GitHub: {{GITHUB_REMOTE}}, committing as {{GIT_AUTHOR_EMAIL}} (set in this repo's
  own git config). Never push with a different account or email.
- Commit messages are the record for small changes, so make them say what changed
  and why. No AI co-author or attribution lines in commits or PRs.

## Project invariants (don't violate without flagging)

The engineering and content invariants from the workspace `AGENTS.md`, repeated on
purpose because this repository has to stand on its own after handover. Payment
and approval windows stay in the workspace only. Update both files when an
invariant changes.

- {{INVARIANT_1}}
- {{INVARIANT_2}}
- {{INVARIANT_3}}

## Scope and approvals

- Work outside the agreed scope is flagged before it's built, never absorbed
  silently. The workspace `AGENTS.md` says how it's handled.
- Content awaiting approval (prices, claims, testimonials, names, figures, contact
  details) renders as a visible placeholder and carries an `APPROVAL:` comment in
  the code saying what's pending. Never invent the real value. Launch needs zero
  markers left.

## Behavioral rules

*Adapted from the community-distilled version of Andrej Karpathy's coding-agent
observations. They bias toward caution over speed; for trivial tasks, use
judgment.*

### 1. Think before coding

**Don't assume. Don't hide confusion. Surface trade-offs.** Before implementing:

- State your assumptions explicitly. If uncertain, ask.
- If several interpretations exist, present them; don't pick one silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop, name what's confusing, and ask.

### 2. Simplicity first

**The minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked, and no abstractions for single-use code.
- No flexibility or configurability that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it. Would a senior engineer
  call it overcomplicated? Then simplify.

### 3. Surgical changes

**Touch only what you must. Clean up only your own mess.**

- Don't "improve" adjacent code, comments, or formatting, and don't refactor what
  isn't broken. Match the existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it; don't delete it.
- Remove the imports, variables, and functions that *your* change made unused.
  Leave pre-existing dead code unless asked.

The test: every changed line traces directly to the request.

### 4. Goal-driven execution

**Define success criteria. Loop until verified.** Turn tasks into verifiable goals:

- "Add validation" → write tests for invalid inputs, then make them pass.
- "Fix the bug" → write a test that reproduces it, then make it pass.
- "Refactor X" → make sure the tests pass before and after.

For multi-step work, state a brief plan:

```text
1. [step] → verify: [check]
2. [step] → verify: [check]
```

Strong criteria let you loop on your own; weak ones ("make it work") need constant
clarification.

### 5. Suggest a better way

Rules 1–4 lean toward restraint; this one balances them. When a clearly better
approach exists, say so with concrete reasoning instead of silently complying with
a worse one.

The rules are working when diffs carry fewer unnecessary changes, fewer rewrites
come from overcomplication, and clarifying questions come before implementation
rather than after mistakes.

## Continuity

During the build, current status, decisions, logs, and memory live in the private
workspace one level up: `../project-status.md`, `../open-items.md`,
`../session-log.md`, `../logs/`, and `../memory/`. Start sessions there, at the
workspace root, so settings, hooks, and skills load. Update those files, not just
chat, whenever something must cross a session or an agent boundary. Specs and plans
are the exception and stay here.

After handover the workspace isn't part of this repository, so these `../`
references no longer apply. Everything needed to work on the code stands on its own
here.

## Confidentiality

<!-- SETUP: On a personal project, delete the first sentence. -->

Client material enters an AI tool only once the engagement terms permit it, and
each tool clears separately; the workspace `AGENTS.md` records which tools are
cleared. Credentials stay out of the repository, commit messages, and logs. If you
find a committed secret, report it instead of rewriting history.

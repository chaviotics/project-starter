# {{PROJECT_NAME}} — engineering rules

Rules for work inside this codebase, versioned with it: update this file in the
same commit as any change it describes. `CLAUDE.md` beside it is one line,
`@AGENTS.md`, so Claude Code and Codex read the same rules.

## Stack

<!-- SETUP: The stack and its one-line reason. For a default from
     SETUP-CODEBASE.md, add that row's code notes as bullets. -->

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

**First scaffold.** Generators such as `create-next-app` refuse a directory holding
`AGENTS.md`, `CLAUDE.md`, or `.claude/`: move those aside, run it, restore them, and
merge any `AGENTS.md`/`CLAUDE.md` it wrote into the top of this file (`CLAUDE.md`
stays one line). Confirm `.gitignore` still has setup's agent-local block. Run the
claude-code-setup automation recommender once (it only reads) and apply only what
the human approves, at the workspace root. Delete this paragraph afterward.

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

**Done means verified.** Before saying something works, run test, type-check, lint,
and build, and check anything visible in a browser at phone and desktop widths.
Report failures with their output. Never weaken or delete a test to make it pass.

### The dev server belongs to the human

{{DEV_SERVER_NOTES}}

1. Don't start a long-lived dev server unless asked. Tests, type-check, and lint
   don't need one.
2. When you do start one, run it as a tracked background task and stop it before
   the turn ends.
3. Never `pkill node`, `killall`, or kill by port without reading the process's
   command line first.

## Shipping

<!-- SETUP: Fill from the Shipping answers in setup. SHIP_MERGE: `when the owner says
     "land it"` (default) | `automatically` | `through a pull request the owner
     merges`. SHIP_PUSH: `waits for the owner's word: nothing leaves the machine`
     (default) | `feature branches and PRs; the owner merges` | `the default branch
     after each merge`. SHIP_STOP_EXTRA: project-specific stop signs, each starting
     with ", ", or nothing. Delete the review or devices line when it has nothing
     to name. -->

How a finished change lands here. Every agent follows it.

- **Gate:** test, type-check, lint and build from Commands, in a clean clone of the
  branch tip; every exit code 0.
- **Merge:** one `--no-ff` merge per change into `{{DEFAULT_BRANCH}}`, after the gate
  and an independent review, {{SHIP_MERGE}}.
- **Push:** {{SHIP_PUSH}}.
- **Stop and ask before merging:** new dependencies, data migrations, anything
  published{{SHIP_STOP_EXTRA}}.
- **Review with the strongest model:** {{SHIP_RISKY}}.
- **Shared devices or accounts:** {{SHIP_DEVICES}}.

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

The workspace `AGENTS.md` invariants, repeated so this repository stands alone after
handover (payment and approval windows stay there). Update both when one changes.

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

## Building pages

<!-- SETUP: Delete this section if the codebase has no user interface, and the
     SEO bullet if it has no public pages. -->

- Colors, type, spacing, radii, and shadows come from the design tokens, never
  raw values or classes like `bg-white` in a component. *Raw values drift.*
- Every public page ships with its SEO basics: unique title and description, one
  H1, alt text, canonical URL, structured data where it fits. *Left for launch,
  some get missed.*
- A page composes section components (hero, services, contact), one per file,
  so diffs stay reviewable. That is no reason to extract a helper used once.

## Behavioral rules

*Adapted from the community-distilled version of Andrej Karpathy's coding-agent
observations. Caution over speed; for trivial tasks, use judgment.*

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
- If 200 lines could be 50, rewrite it. Overcomplicated to a senior engineer? Simplify.

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

For multi-step work, state a brief plan with a verify step per item
(`1. [step] → verify: [check]`). Strong criteria let you loop on your own; weak ones
("make it work") need constant clarification.

### 5. Suggest a better way

Rules 1–4 lean toward restraint; this one balances them. When a clearly better
approach exists, say so with concrete reasoning instead of silently complying. The
rules are working when diffs carry fewer unnecessary changes and clarifying
questions come before implementation, not after mistakes.

## Continuity

During the build, status, decisions, logs, and memory live in the private workspace
one level up (`../project-status.md`, `../open-items.md`, `../session-log.md`,
`../logs/`, `../memory/`). Start sessions there so settings, hooks, and skills load,
and update those files, not just chat, whenever something must cross a session or
an agent boundary. Specs and plans stay here. After handover the `../` paths don't
exist; the code stands on its own.

## Confidentiality

<!-- SETUP: On a personal project, delete the first sentence. -->

Client material enters an AI tool only once the engagement terms permit it, and
each tool clears separately; the workspace `AGENTS.md` records which tools are
cleared. Credentials stay out of the repository, commit messages, and logs. If you
find a committed secret, report it instead of rewriting history.

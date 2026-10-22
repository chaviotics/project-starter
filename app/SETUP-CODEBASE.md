# Setting up this codebase

This folder is the project's code: the inner repository, usually named after the
project, so it sits at `<project>/<project>/`. It is what goes to GitHub, and on
client work it is what the client receives. While this file is here, the codebase
hasn't been created yet, usually because its stack wasn't decided at setup. The
check script treats the folder as not created yet and skips it. Once the stack is
decided, an agent follows these steps. The workspace root is already a git
repository by then.

1. Confirm the folder's name matches the Codebases table in the root `AGENTS.md`.
2. Fill in this folder's `AGENTS.md`: stack, where things live, the exact command
   strings (ask for them; never guess `npm` versus `pnpm`), dev-server notes,
   default branch, and the engineering and content invariants copied from the
   root `AGENTS.md`. Never copy payment or approval windows, because on client
   work this repository is client-visible. Commands that don't exist yet share
   one open item: `TODO: not set up yet (open-items #N)`. Follow its SETUP:
   comments (personal projects drop the client wording), then strip them. If
   the codebase has parts, create each part's folder with its short `AGENTS.md`
   and one-line `CLAUDE.md` now, so the parts are scaffolded into them later.
3. Run `git init -b <default-branch>` here. If this is an existing clone, don't
   re-initialize it, and ask before adding agent files. For an existing codebase,
   also get it running locally, write the exact run steps into its `AGENTS.md`
   (they become handover documentation), and merge anything useful from
   Claude Code's `/init` into that file rather than keeping a second one.
4. **GitHub identity**, from the setup answers (ask only what's missing): owner
   account or organization, repository name, visibility (private by default for
   client work), and the commit name and email (verified on that account).
   - Set the identity in this repository only: `git config user.name "<name>"`
     and `git config user.email "<email>"`.
   - If the GitHub repository exists: add the remote through the SSH host alias
     for that account (from `~/.ssh/config`, for example
     `git@github.com-<account>:<owner>/<repo>.git`), and verify with
     `ssh -T git@<alias>` and `git config --show-origin user.email`.
   - If it doesn't exist yet: skip the remote and the SSH check, and write
     `TODO: GitHub remote not set up (open-items #N)` in this `AGENTS.md`.
   - Never create the GitHub repository or push without the human's go.
   - Record the account, alias, and email in `docs/accounts.md` at the root, and
     fill `{{GITHUB_REMOTE}}` and `{{GIT_AUTHOR_EMAIL}}` in this `AGENTS.md`.
5. Confirm the root `.gitignore` has `/<folder>/` and the root `.ignore` has
   `!/<folder>/`, both with a leading slash. Then confirm that `git status` at the
   root lists nothing from inside this folder.
6. Create `docs/superpowers/specs/` and `docs/superpowers/plans/` here, each with
   an empty `.gitkeep` so git keeps them, plus a `.gitignore` suited to the stack
   with this block appended:

   ```gitignore
   # Secrets
   .env
   .env.*
   !.env.example
   # Agent tooling lives in the private workspace above, never in this repository.
   # Remove the /.claude/, /.codex/, /.agents/ lines only if the client's team
   # will share the tooling, and commit nothing personal or secret.
   /.claude/
   /.codex/
   /.agents/
   .mcp.json
   CLAUDE.local.md
   .superpowers/
   .worktrees/
   CLAUDE-SECURITY-*/
   graphify-out/
   # Editor: share only project settings and recommended extensions.
   .vscode/*
   !.vscode/settings.json
   !.vscode/extensions.json
   .DS_Store
   ```

   If specs or plans were written in the root `docs/specs/` or `docs/plans/` while
   this codebase waited, move them in now. Read each one first and remove anything
   private (fees, contract terms, commentary about the client), because this
   repository may be handed over.
7. Create `.claude/settings.local.json` here with `autoMemoryDirectory` set to the
   absolute path of the workspace `memory/` folder, so a session that does start
   here shares the one memory store. The block above keeps it out of git.
8. Update this codebase's row in the root `AGENTS.md` Codebases table (Stack and
   Origin). If an open item tracked this step, close it, and log the session.
   Don't commit in this repository yet; its first commit comes with the first
   scaffold.
9. Delete this file. Its absence marks the codebase as created.

Don't scaffold the framework or write application code as part of these steps.
That starts in the next session, following "First scaffold" in this folder's
`AGENTS.md`.

<!-- SETUP: Lines marked `SETUP:` are instructions for the agent filling this
     starter. Strip every one of them once the file is built, including this one. -->

# Project Status — {{PROJECT_NAME}}

<!-- SETUP: Delete the Client field on a personal project and the Governing
     document field when there is none. Never write "N/A". -->

**Client:** {{CLIENT_NAME}} · **Governing document:** {{CONTRACT_REF}} · **Size:** {{SIZE}}

<!-- SETUP: If the Phases or Milestones section is deleted below, drop its
     mention from the "only on the human's word" sentence that follows. -->

**Who updates this file:** agents, at the end of every session that changed
anything below. That is what keeps it true. A status file only the human may touch
stops being updated, and then nobody reads it. Two things change **only on the
human's word**, recorded with the date when they say so: phase sign-offs, and the
Approved / Invoiced / Paid columns.

Decisions and risks go in `open-items.md`. History goes in `logs/`. This file is
the present tense.

---

## Now

_Last updated: {{DATE}} · {{TOOL}}_

- **Focus:** {{NOW_FOCUS}}
- **Next:** {{NOW_NEXT}}
- **Waiting on:** {{NOW_WAITING}}

Three lines. **Replace them each session; don't append.** Anything longer belongs
in that session's log.

---

## Build list

<!-- SETUP: Seed from the source of truth: pages, features, or deliverables, at the
     size someone would sign off on. Five to thirty rows. Leave it empty only if
     nothing is known yet. -->

Each page, feature, or deliverable. Mark ✅ only after checking it the way a user
would, and record how in **Verified how**. "Tests pass" and "looks done" are not
the same thing.

Legend: ⬜ not started · 🟡 in progress · 🔵 awaiting sign-off · ✅ done · ⏭ dropped

| Item | Due | Status | Verified how |
|---|---|---|---|
| | | ⬜ | |

---

## Phases

<!-- SETUP: Pick ONE source and delete the other two notes:
     - A governing document that names phases: use ITS phase names and numbering
       verbatim. The other party invoices against and judges the work by them.
       If the gate kept you from opening it, write one row:
       `TODO: phases verbatim from <document> once cleared (open-items #N)`.
     - Light, with no document that names phases: DELETE this whole section down
       to the next `---`. The build list, milestones, and launch checks carry its
       progress.
     - Full, no document (or a document that names no phases): use the standard
       phase list in the appendix of SETUP-PROMPT, trimmed to what this project
       involves. The six rows below are only a shape.
     Phases the route skips stay as ⏭ rows with the route as the reason, so the
     skip is a decision on record. Split a phase into sub-rows (3a, 3b) once its
     plan exists. -->

**Who updates this table:** agents set the progress statuses (⬜ 🟡 ✅ ⏭). 🔵
"awaiting sign-off" moves to ✅ only on the human's word, recorded with the date.

Legend: ⬜ not started · 🟡 in progress · 🔵 awaiting sign-off · ✅ done · ⏭ skipped

| # | Phase | Status | Notes (sign-offs, dates) |
|---|---|---|---|
| 1 | Brief: the ask written down, scope in and out | ⬜ | |
| 2 | Design direction: references or variants, one chosen | ⬜ | |
| 3 | Build: small vertical slices, each verified | ⬜ | |
| 4 | Review and changes: preview URL, feedback rounds, change requests logged | ⬜ | |
| 5 | Launch: launch checks done, production deploy | ⬜ | |
| 6 | Handover: access, docs, and ownership transferred | ⬜ | |

Overlapping phases are normal. Two 🟡 at once is not a problem to resolve.

---

## Milestones

<!-- SETUP: Keep only if money is tied to acceptance of specific deliverables.
     Otherwise delete down to the next `---`. -->

One row per payment. **Proof** uses the governing document's own wording where it
has some: "substantially complete in staging" is contract language, and "looks
done" is not. Where a response or payment window exists, write the resulting
deadline into the date columns when the clock starts.

| # | Milestone | Amount | Proof it's met | Status | Submitted | Approved | Invoiced | Paid |
|---|---|---|---|---|---|---|---|---|
| 1 | | | | ⬜ | | | | |

---

## Launch checks

<!-- SETUP: Keep the rows that apply and delete the rest. On a full project, fill
     "Phase" with the phase each check happens in. On a light project, delete
     that column. On a personal project, delete the rows marked [client].
     On a client project, keep them and remove the [client] marker. -->

The steps phases rarely name and projects routinely skip. These are the gates; the
detailed list lives in the `launch-audit` skill (run `/launch-audit`), which
updates these rows.

| Check | Phase | Status | Notes |
|---|---|---|---|
| The ask is written down (`docs/sot.md`) | | ⬜ | |
| [client] Terms agreed (and any deposit cleared) before build starts | | ⬜ | |
| [client] AI-vendor processing cleared, per tool | | ⬜ | |
| A preview URL exists before production, hidden from search engines | | ⬜ | |
| Zero `APPROVAL:` markers left in the codebase | | ⬜ | |
| `launch-audit` run on the final preview; findings fixed or accepted in writing | | ⬜ | |
| `launch-audit` run on production after the domain switch | | ⬜ | |
| 2FA on every account that controls the site (GitHub, host, registrar, DNS, CMS) | | ⬜ | |
| Accounts listed in `docs/accounts.md` (never the credential values) | | ⬜ | |
| [client] Handover: access, docs, and ownership transferred; no TODOs left in the codebase `AGENTS.md`; final payment per the governing document | | ⬜ | |

---

## Blocked on others

<!-- SETUP: Seed from the governing document's client responsibilities and the
     kickoff notes. Keep this section even if it starts empty. -->

Anything the project needs that someone else controls: access, content, assets,
approvals, a third party's turnaround. **The dates are the point.** A requested
date with no received date is the record that a delay wasn't yours, and the answer
to "what am I stuck on" after a week away.

| Item | Who | Needed by | Requested | Received | Blocks |
|---|---|---|---|---|---|

---
name: launch-audit
description: Pre-launch audit of a website or web app against checklist.md (SEO, performance, accessibility, security, privacy, analytics, deploy, handover). Run it on the final preview before launch and again right after the production domain goes live. Use only when asked for a launch audit or launch checks.
disable-model-invocation: true
---

# Launch audit

Audit this project against `checklist.md` (beside this file) and record the results
in the workspace. The checklist is the reference; this file says how to run it.

## 1. Work out what applies

Read the codebase to propose the project's tags, then ask the human to confirm
before auditing:

- `A` every public site: always.
- `B` forms or email: a form component, a form service, or an email provider in
  the dependencies.
- `C` CMS: `wp-config.php`, or a headless CMS client in the dependencies.
- `D` auth, database, user data, payments, or uploads: auth, database, Stripe, or
  storage libraries in the dependencies, or API routes that write data.
- Qualifiers: *(redesign)* when an old site's URLs exist; *(PH)*, *(EU)*, and
  *(local)* from `docs/sot.md` or the human.

Also confirm which pass this is: **preview** (the final preview before cutover) or
**production** (right after the DNS switch). Items that need the live domain
(headers on the real host, redirects, search console, analytics, email
deliverability) wait for the production pass.

## 2. Run the applicable items

Each item names how to verify it and who can:

- `script`: run the command and keep the relevant output. Never paste secrets
  into notes or logs.
- `review`: read the code and state what you checked and what you found.
- `human`: needs account access or a client decision. List it for the human.
  **Never mark a `human` item done yourself.**

Legal items are raised, never answered. Write "raise with the client", not a
conclusion.

## 3. Record the results

- **`project-status.md`, Launch checks:** update the matching rows (status and
  a one-line note) and the row for this audit pass. Don't paste the checklist
  into the status file; it stays here.
- **Each failure** becomes either a fix in this session (if small and within
  scope) or an open item in `open-items.md` with its severity.
- **`human` items** go to the Now lines or to Blocked on others, with who needs
  to act.
- **The session log** gets one entry for the audit: pass type, tags, counts of
  passed, failed, and waiting-on-human items, and links to the open items.

A finding is closed only when it's fixed and re-verified, or accepted in writing
by the human with a reason. Record which.

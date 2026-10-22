# Launch checklist

*Last reviewed 2026-10. Tool names, framework props, and CVE examples age fastest; refresh them in the starter, not per project.*

**Applies:** `A` every public site · `B` + forms/email · `C` + CMS (WordPress, headless) · `D` + auth, database, user data, payments, uploads. A project at `D` also runs `A`–`C` where relevant. Qualifiers: *(redesign)*, *(PH)*, *(EU)*, *(local)*.
**Agent:** `script` = an agent runs a command and pastes the output (fits the Codex lane) · `review` = an agent reads the code (Claude Code judgment pass) · `human` = needs account access or a client decision. The agent surfaces legal questions and never answers them.
`$URL` = the production URL, or the final preview before cutover.

## SEO & discoverability
- [ ] `A` Key content is in the initial HTML (static or server-rendered; SSR isn't required) · verify `curl -s $URL | grep -i "<h1"`, GSC URL Inspection · `script`
- [ ] `A` Unique `<title>` and meta description on every page · verify Screaming Frog (free up to 500 URLs) or `npx unlighthouse --site $URL` · `script`
- [ ] `A` One clear H1 per page with a logical heading order (a convention for accessibility and structure, not a Google rule) · verify axe `heading-order`, HeadingsMap · `review`
- [ ] `A` Self-referencing canonical on the final https host (Next.js `metadataBase` + `alternates.canonical`) · verify view source, GSC "Google-selected canonical" · `review`
- [ ] `A` Production `robots.txt` allows crawling, with no `Disallow: /` left from staging, and names the sitemap · verify `curl $URL/robots.txt` · `script`
- [ ] `A` `sitemap.xml` lists only canonical 200 URLs with an honest `lastmod` (Google ignores priority and changefreq) · verify submit in GSC and see "Success" · `script` + `human`
- [ ] `A` No `noindex` on production; previews are `noindex` or password-protected (custom-domain and branch previews often aren't by default) · verify `curl -sI <url> | grep -i x-robots` on both · `script`
- [ ] `A` One canonical host: http→https and www↔apex in a single 301/308 hop · verify `curl -sIL http://www.<domain>` · `script`
- [ ] `A` *(redesign)* Every old URL 301s to its new equivalent before DNS moves, with no chains (Next.js `permanent` sends 308, which is fine) · verify a script that runs the URL inventory through `curl -sI` · `script`
- [ ] `A` Custom 404 page that returns a real 404 status, not a soft 200 · verify `curl -sI $URL/xyz-missing | head -1` · `script`
- [ ] `A` Open Graph and Twitter tags with an absolute 1200×630 image on key pages · verify opengraph.xyz, Facebook Sharing Debugger (re-scrape after launch), LinkedIn Post Inspector · `human`
- [ ] `A` Internal links: every page reachable from navigation, no orphans, zero broken links or assets · verify `npx linkinator $URL --recurse` or lychee · `script`
- [ ] `A` JSON-LD where it fits: Organization (or LocalBusiness) on home, BreadcrumbList only on deep hierarchies, Product or Article where relevant · verify Rich Results Test, validator.schema.org · `script`
- [ ] `A` Favicon, `apple-touch-icon`, and a manifest if wanted (Next.js `app/icon`, `app/apple-icon`) · verify RealFaviconGenerator checker, an iOS home-screen add · `script`
- [ ] `A` *(local)* Google Business Profile claimed by the client, with name, address, and phone matching the site · verify the GBP dashboard · `human`
## Performance & media
- [ ] `A` Lighthouse mobile performance ≥ 90 on key templates; LCP ≤ 2.5 s, INP ≤ 200 ms, CLS ≤ 0.1 · verify PageSpeed Insights or `npx unlighthouse`, plus one real mid-range Android on mobile data · `script`
- [ ] `A` Images sized to their display, modern format (`next/image` serves WebP; AVIF is opt-in via `images.formats`), width and height set · verify Lighthouse image audits · `script`
- [ ] `A` Below-fold images lazy-load; the hero/LCP image does not (`preload` or `fetchPriority="high"`; `priority` is deprecated in Next 16) · verify Lighthouse "LCP image was lazily loaded" · `review`
- [ ] `A` Fonts through `next/font` or self-hosted subsets; third-party scripts deferred (`next/script`); YouTube and map embeds behind facades · verify Lighthouse third-party and CLS audits · `review`
- [ ] `C` CMS page cache and image compression on; an upload size cap for editors · verify PageSpeed on a page the client edited · `script`
## Accessibility (WCAG 2.2 AA)
- [ ] `A` Automated scan clean on key templates · verify `npx @axe-core/cli $URL` or `npx pa11y-ci --sitemap $URL/sitemap.xml`, Lighthouse accessibility · `script` (impeccable `audit`)
- [ ] `A` Keyboard only: everything reachable, visible focus, no traps, skip link, menus and modals close on Esc · verify Tab through the home page and one form · `human`
- [ ] `A` Contrast ≥ 4.5:1 for text (3:1 for large text and UI), including text over images and hover states · verify axe, WebAIM contrast checker · `script`
- [ ] `A` Informative images have meaningful alt; decorative images use `alt=""` · verify axe `image-alt` plus a read-through · `review`
- [ ] `A` `<html lang>` set, landmarks, named links and buttons, usable at 200% zoom and 320 px width, `prefers-reduced-motion` respected · verify axe, browser zoom, the OS reduce-motion setting · `review`
- [ ] `B` Forms: visible labels, errors tied to their fields and announced, targets ≥ 24 px · verify a VoiceOver or TalkBack pass · `human`
## Security
- [ ] `A` HTTPS with a valid certificate; HSTS, `X-Content-Type-Options`, `Referrer-Policy`, `frame-ancestors`, `Permissions-Policy`; a CSP, starting as Report-Only (nonce CSP forces dynamic rendering in Next.js, so a static site sets a header CSP) · verify securityheaders.com, MDN HTTP Observatory, SSL Labs · `script`
- [ ] `A` No secrets in the repo or its history; `.env*` git-ignored, `.env.example` committed; any leaked key rotated, since deleting the commit doesn't un-leak it · verify `gitleaks detect` or `trufflehog git file://.` · `script`
- [ ] `A` No secret reaches the browser: none in `NEXT_PUBLIC_*`, secret keys used only in server code · verify grep `.next/static` for `sk_`, `service_role`, and key prefixes · `script`
- [ ] `A` Dependencies audited and the framework patched (for example React2Shell, CVE-2025-55182) · verify `npm audit --omit=dev`, Dependabot alerts on · `script`
- [ ] `A` Production debugging off: no stack traces or verbose errors shown to users, browser source maps off, `WP_DEBUG_DISPLAY` false · verify trigger an error, send a malformed request · `review`
- [ ] `A` 2FA on every account that controls the site (GitHub, host, registrar, DNS, CMS admin), with no shared passwords · verify each account's security settings · `human`
- [ ] `B` Server-side validation on every form and endpoint (a schema such as zod, length limits); client-side checks are only for UX · verify crafted payloads sent with `curl` · `review`
- [ ] `B` Spam and abuse: a honeypot plus Turnstile/reCAPTCHA or the host's filter (Netlify Forms runs Akismet), and a per-IP rate limit · verify a burst of 20 submissions, then one with the honeypot filled · `script`
- [ ] `B` Untrusted content renders escaped: no `dangerouslySetInnerHTML` on CMS or user HTML without DOMPurify, no `javascript:` hrefs · verify grep, paste `<img src=x onerror=alert(1)>` into fields · `review`
- [ ] `C` WordPress hardened: core, themes, and plugins updated with auto-updates on, unused plugins deleted, `DISALLOW_FILE_EDIT`, admin 2FA and login limits, no `admin` user, XML-RPC off if unused · verify WPScan or Wordfence scan, Site Health · `script`
- [ ] `D` Authorization checked server-side in every route, server action, and API handler, not only in middleware (see CVE-2025-29927) · verify user A's session against user B's IDs · `review`
- [ ] `D` Supabase: RLS plus policies on every exposed table (Firebase: Security Rules); the service-role or secret key never reaches the browser · verify Supabase Security Advisor, queries with the anon key · `script`
- [ ] `D` Queries parameterized or through an ORM, with no string-built SQL (`$queryRawUnsafe`, concatenation) · verify grep for raw-query APIs · `review`
- [ ] `D` Auth through a provider (Supabase Auth, Clerk, Auth.js); any stored passwords use Argon2id or bcrypt; email verified before privileged use; reset tokens expire · verify walk the signup and reset flows · `review`
- [ ] `D` Session tokens in HttpOnly, Secure, SameSite cookies, not localStorage (Supabase: `@supabase/ssr`) · verify DevTools → Application · `review`
- [ ] `D` Rate limits on login, signup, password reset, and costly APIs (AI, email, SMS) · verify a scripted burst returns 429 · `script`
- [ ] `D` CORS: same-origin apps need none; a cross-origin API uses an explicit allowlist and never `*` with credentials (CORS is not access control) · verify `curl -I -H "Origin: https://evil.test"` · `script`
- [ ] `D` Uploads: size and type checked server-side by content, not extension; random filenames; a private bucket with signed URLs; never serve user SVG or HTML inline · verify upload a renamed `.html` and an oversized file · `review`
- [ ] `D` Webhooks verify signatures on the raw body (Stripe `constructEvent`), and handlers are idempotent · verify `stripe trigger`, and a forged request is rejected · `script`
- [ ] `D` Logs hold no passwords, tokens, or personal form data · verify grep the logger calls, read host logs after a test signup · `review`
- [ ] `D` Independent review: Claude Code `/security-review` (branch diff only) or a whole-codebase review prompt; findings logged with severity, then fixed or accepted in writing · verify the findings list · `review`
## Privacy & legal
- [ ] `A` Privacy notice linked in the footer that matches what the site really collects (forms, analytics, cookies, embeds, processors); forms ask only for what's needed · verify an inventory against the notice · `review`
- [ ] `A` *(PH)* Notice aligned with RA 10173: purpose, data, retention, sharing, data-subject rights, DPO contact; a consent checkbox where consent is the basis · verify the client confirms · `human`
- [ ] `D` *(PH)* Raise NPC registration with the client if a threshold may apply (250+ employees, sensitive data of 1,000+ people, or high-risk or automated processing) · verify the client confirms · `human`
- [ ] `A` *(EU, or GA4 with Ads)* No non-essential cookies before consent; Consent Mode v2 for GA4/Ads · verify in a fresh profile, no `_ga` cookie before accepting · `script`
- [ ] `A` Selling online: terms, refund, and shipping pages; *(PH)* the business name, address, and contact details RA 11967 requires · verify client sign-off · `human`
## Analytics
- [ ] `A` Analytics chosen to fit: GA4 (needs consent in the EU) or cookieless (Plausible, Umami, Vercel or Cloudflare Web Analytics), loaded on production only · verify a realtime view shows your visit, and none from previews · `human`
- [ ] `A` Search Console domain property verified by DNS TXT and the sitemap submitted; Bing Webmaster Tools optional (imports from GSC) · verify GSC sitemap status · `human`
- [ ] `B` Conversions tracked: form submit, click-to-call, Messenger or WhatsApp clicks · verify GA4 DebugView or realtime events · `human`
- [ ] `D` Product events on the flows that matter, with no personal data in event parameters · verify the event inspector · `review`
## Deploy & ops
- [ ] `A` Production env vars set in the host's production scope, not only preview · verify the host dashboard, then exercise each feature that needs one · `human`
- [ ] `A` Domain, DNS, and SSL live; MX and SPF records survive any nameserver move; TTL lowered before cutover · verify `dig MX <domain>`, send and receive a test email · `script`
- [ ] `A` Post-deploy smoke test: key routes return 200, forms deliver, analytics fires, no console errors · verify a Playwright script or a manual pass · `script`
- [ ] `A` Rollback rehearsed once: host instant rollback (Vercel or Netlify), a tagged release · verify one rollback on staging · `human`
- [ ] `A` Uptime monitor on the home page and one key endpoint, alerting you (UptimeRobot or Better Stack free tier) · verify a test alert · `human`
- [ ] `B` Form email sent through a provider (Resend, Postmark, SES) from the client's verified domain with SPF, DKIM, and DMARC; the visitor's address goes in `Reply-To`, not `From` · verify mail-tester.com ≥ 9/10, `dig TXT _dmarc.<domain>`, a test message lands in a Gmail inbox · `script`
- [ ] `C` `D` Backups automated and stored off the host, with one restore tested (WordPress: UpdraftPlus or host snapshots; databases: check the plan, since free tiers may have none) · verify a restore to staging · `human`
- [ ] `C` WordPress "Discourage search engines" unchecked on production; a content workflow from staging to production agreed · verify wp-admin → Reading · `human`
- [ ] `D` Error tracking (Sentry or host alerts), with source maps uploaded privately · verify a test error arrives · `script`
## Handover
- [ ] `A` Every account in the client's name (registrar, DNS, host, GA4, GSC, GBP, email provider), you a removable user, domain auto-renew on · verify the owner in each dashboard, `docs/accounts.md` · `human`
- [ ] `C` Editing guide and training, with the client's login at the right role (Editor unless they manage plugins) · verify the client edits one page live · `human`
- [ ] `A` Maintenance terms written: who patches dependencies and plugins, and how often · verify a signed document · `human`

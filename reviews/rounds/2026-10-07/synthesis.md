# Review Synthesis — 2026-10-07

## Overview

This synthesis merges the Codex review (`gpt-review.md`) with Claude's verification (`claude-review.md`). It is the corrected version of the review: severities are adjusted where verification did not support them, two findings are upgraded, five findings are added, and one claim is rejected. Every finding was checked against the canonical sources at the reviewed commits before anything was changed.

Severity follows the project scale: Critical (breaks functionality or security), High (factual error or cross-document contradiction with operational consequence), Medium (incomplete or imprecise), Low (polish).

"Models" shows who raised the finding and whether verification agreed: **GPT** = Codex, **Claude** = verifier. "GPT ✓ Claude" means Codex raised it and Claude confirmed it.

## Finding Disposition Ledger

Status values: `applied` (corrected in the canonical source on the `fix/review-2026-10-07` branch and submitted by pull request for human approval) and `rejected`.

### Operations Runbook (`wordpress-runbook-template`)

| ID | Sev. | Finding | Models | Status | Notes |
|---|---|---|---|---|---|
| CL-1 | Critical | §5.4 REST snippet raises a fatal `TypeError` on PHP 8 and stops the REST API | Claude (executed) | applied | Replaced with a snippet that skips route options and wraps core's check. Tested locally |
| RB-1 | High | §5.4 snippet replaces per-operation authorization with `list_users` on write handlers | GPT ✓ Claude (executed) | applied | Same replacement snippet; write handlers are no longer touched. Cross-reference corrected from Benchmark 5.6 to 5.4 |
| RB-2 | High | §11.2 full restore runs SQL and import while MySQL is stopped | GPT ✓ Claude | applied | MySQL stays running; only the web tier is stopped. Readiness check added |
| CL-4 | Medium | §11.2 verification and cache flush also ran before MySQL restarted; import ran before credentials were verified | Claude | applied | Steps reordered: files, configuration, database, permissions |
| RB-3 | High | §11.2 never restores the separate uploads archive | GPT ✓ Claude | applied | Uploads restore added for local and S3 paths, with a prerequisite and a media check |
| RB-4 | High | `wp-config.php` mode 400 with a `www-data` PHP-FPM pool and a different owner makes the file unreadable | GPT ✓ Claude | applied | Reference stack now uses owner `wp_user`, group `www-data`, mode 440; 400 documented for pools that run as the owner. Readability check added. §3.2 records the pool user |
| RB-5 | High | UFW enabled before SSH is allowed; SSH port change has no firewall transition | GPT ✓ Claude | applied | Rules staged before `ufw enable`; port-change procedure added |
| RB-6 | High | Incident containment relies on ten-minute maintenance mode; Nginx `deny`/`allow` order is reversed | GPT ✓ Claude | applied | Containment is now a web-server or edge block with verification; maintenance mode labeled as not containment |
| RB-7 | High | Procedure points to a plugin enforcement setting that does not exist; verification does not show enrollment | GPT ✓ Claude | applied | Enrollment, enforcement, and verification separated. A tested enforcement must-use plugin was added in the second pass (O-3) |
| RB-8 | Medium | Autoload queries match only `autoload = 'yes'` | GPT ✓ Claude | applied | Queries match the WordPress 6.6+ value set |
| RB-9 | High | Offload plugin slug does not exist on WordPress.org; `wp option update` stores a JSON string and replaces the option | GPT (option only) + Claude (slug) | applied | Slug corrected to `amazon-s3-and-cloudfront`; configuration moved to the plugin's settings constant. Key names verified against the plugin source in the second pass |
| RB-10 | Medium | WebP rewrite has no file-existence fallback | GPT ✓ Claude | applied | `map` + `try_files` with `Vary: Accept`. Tested in a container in the second pass (O-6) |
| — | Medium | PHP memory-limit triage reads the CLI value | GPT ✓ Claude | applied | PHP-FPM and pool checks added |
| — | Low | HSTS comment says `preload` submits the domain | GPT ✓ Claude | applied | Comment corrected |
| — | Medium | SSH hardening leaves keyboard-interactive password authentication open (runbook side of BB-5) | GPT ✓ Claude | applied | `KbdInteractiveAuthentication no`, `sshd -t`, `sshd -T` check |
| R-01 | Medium | §3.2 six-column service table is unreadable in the published PDF | GPT (visual); Claude (CI run only) | applied (source) | Table split into two narrower tables. PDF not regenerated; confirm visually at the next build (O-2) |
| — | Medium | Example WordPress version placeholder says 7.0 | GPT ✓ Claude | applied | Now 7.1 |

### Security Benchmark (`wp-security-benchmark`)

| ID | Sev. | Finding | Models | Status | Notes |
|---|---|---|---|---|---|
| BB-1 | High | §2.1–2.5 audits read PHP CLI settings, not the serving runtime | GPT ✓ Claude | applied | Audits query the PHP-FPM binary; section note covers pool overrides and `mod_php` |
| BB-2 / HS-02 | High | `xmlrpc_enabled` presented as disabling the endpoint; GET audit misreads an enabled endpoint | GPT ✓ Claude | applied | Corrected in all four documents and the Hardening Guide matrix. Audit uses POST |
| HS-10 | Medium | `system.multicall` amplification described as current behavior | GPT ✓ Claude | applied | Marked historical (fixed in WordPress 4.4, core commit of 2015-10-23) in Benchmark, Hardening Guide, and glossary |
| BB-3 / HS-04 | Medium | Roles-in-code control overstates protection against database tampering | GPT ✓ Claude | applied | Severity lowered from High: an overstated claim, not a broken procedure. Rationale rewritten; reconciliation snippet added and tested |
| BB-4 | High | Upload PHP-denial sample omits regular-expression location ordering; audit checks presence only | GPT ✓ Claude | applied | Placement stated; behavioral audit with an inert file added |
| BB-5 | Medium | SSH key-only control does not close or audit keyboard-interactive authentication | GPT ✓ Claude | applied | Severity lowered from High: depends on host configuration. Effective-configuration audit added |
| CL-5 | High | §6.1 Model A sets `wp-config.php` to 400 under `wp_user:www-data` | Claude; GPT noted a qualification was needed | applied | Model A uses 440; §6.2 chooses the mode from the pool user |
| BB-6 | Medium | Rate-limit example misses `?rest_route=` requests | GPT ✓ Claude | applied | Second zone keyed on `rest_route`. Tested in a container in the second pass (O-6) |
| BB-7 | Medium | Secret audits print the secrets | GPT ✓ Claude | applied | Audits return counts, file names, and option names only; table prefix no longer hardcoded |
| BB-8 | Medium | Session control's audit and remediation cover part of the description | GPT ✓ Claude | applied | Control scoped to maximum lifetime; other measures named as separate. Snippet uses a capability check |
| CL-2 | Medium | §5.4 remediation removes the users routes for every non-administrator, which breaks block-editor author lookups | Claude (code reading) | applied | Replaced with the tested wrapper snippet |
| — | Medium | §5.1 audit does not check enrollment or enforcement | GPT ✓ Claude | applied | Benchmark side of RB-7 |
| BB-9 | Medium | Target Technology calls 7.0 the current supported series | GPT ✓ Claude | applied | Reworded with an as-of date and the support policy. 7.1 delta review completed in the second pass (O-1) |

### Hardening Guide (`wp-security-hardening-guide`)

| ID | Sev. | Finding | Models | Status | Notes |
|---|---|---|---|---|---|
| HS-01 | High | Promises security backports to 3.7 | GPT ✓ Claude | applied | Both passages state the courtesy-backport policy with an as-of date |
| HS-03 | Medium | Application passwords described as scoped credentials | GPT ✓ Claude | applied | Severity lowered from High. Corrected in the Hardening Guide (two places) and the glossary |
| HS-05 | Medium | Prompt-injection and code-execution guidance overstates sanitization | GPT ✓ Claude | applied | Severity lowered from High. Rewritten around deterministic authorization, least privilege, isolation, and approval |
| HS-08 | Medium | `open_basedir` classification differs from the Benchmark | GPT ✓ Claude | applied | Level 2 stated in the Hardening Guide and the glossary |
| HS-09 | Medium | SOC 2 called a certification | GPT ✓ Claude | applied | Style Guide example and Hardening Guide §13 corrected |
| HS-11 | Medium | "Encrypt 2FA secrets" is not met by the recommended plugin | GPT ✓ Claude | applied | Threat model and plugin storage stated |
| — | Medium | Unsupported "majority of enterprise WordPress breaches" and "fastest-growing" claims | GPT (open question) ✓ Claude | applied | Reworded to what the cited sources support |
| — | Low | "WordPress 7.0 JavaScript AI API" misnames a separately distributed wrapper | GPT ✓ (dev note not re-fetched by Claude) | applied | Reworded |
| — | Medium | Scope statement silent on 7.1 | GPT (open question) | applied | Scope now covers 7.1 after the delta review (O-1) |

### Style Guide (`wp-security-style-guide`)

Sections 1–2 were not touched.

| ID | Sev. | Finding | Models | Status | Notes |
|---|---|---|---|---|---|
| HS-06 | Medium | Glossary overstates default SSRF protection | GPT ✓ Claude | applied | |
| HS-07 | Medium | Nonce definition implies authentication | GPT ✓ Claude | applied | |
| HS-12 | Low | Glossary not alphabetical; two cross-references have no target | GPT ✓ Claude | applied | Sorted letter by letter with the convention stated; `Allowlist` entry added; `WordPress` reference removed. About six of the 14 inversions were convention differences |
| HS-13 | Low | Organization-specific channel routing sits in the normative chapter | GPT ✓ Claude | applied | Marked as an example rather than moved, to keep §7.2 intact |
| R-02 | Medium | Glossary metric counts bold labels outside the glossary (143 reported, 139 actual) | GPT ✓ Claude | applied | Metric scoped to §8 in the repo and in the aggregate validator. Count is 141 after the Allowlist and SLA entries |

### Process and tooling (`ai-assisted-docs` and downstream repos)

| ID | Sev. | Finding | Models | Status | Notes |
|---|---|---|---|---|---|
| PP-1 | Medium | Reusable workflow loads a local action that external callers do not have | GPT ✓ Claude | applied | Severity lowered from High: no repository calls it. Action referenced by repository and pinned commit. Static guard added in the second pass (O-5) |
| PP-2 | High | All four contributor guides describe an automatic publish flow that no longer exists | GPT ✓ Claude | applied | Guides describe the manual build, the bundle, and the release workflow |
| PP-3 | Medium | `security-researcher` skill has no frontmatter; validator does not check it | GPT ✓ Claude | applied | Frontmatter added; validator requires `name` and `description` |
| PP-4 | Medium | Installed skill bundles lose their `AGENTS.md` reference | GPT ✓ Claude | applied | Linked by URL; validator rejects reference links that leave the bundle |
| PP-5 | Medium | New-round metrics snapshot silently omits the canonical document table | GPT ✓ Claude | applied | Heading match fixed; empty extraction now fails. Used to scaffold this round |
| PP-6 | Medium | `rebuild-all-docs.sh --wait` ignores failed runs and can watch an unrelated run | GPT ✓ Claude | applied | `--exit-status`, run selection by dispatch time. Syntax-checked; not dispatched |
| PP-7 | Low | README says no all-four rebuild command exists | GPT ✓ Claude | applied | |
| — | Low | Reusable-workflow validation does not trigger on toolchain action changes | GPT ✓ Claude | applied | Path added |
| CL-3 | Low | Downstream `CLAUDE.md` files point at a nonexistent home-directory path | GPT (as portability debt) + Claude | applied | Portable command names, matching the central file |

### Rejected

| ID | Finding | Raised by | Reason |
|---|---|---|---|
| — | `REVOKE ALL PRIVILEGES ON *.*` leaves database-level grants in place | Considered and left unasserted by GPT; asserted by Claude in its first report | The MySQL 8.0 manual says this form and `REVOKE ALL PRIVILEGES, GRANT OPTION` both drop privileges at every level. Claude's claim is retracted. The Benchmark now uses the second form because it is unambiguous, and makes no claim about the first |

### Items opened in the first pass and settled in the second

| ID | Sev. | Item | Status | Resolution |
|---|---|---|---|---|
| O-1 | Medium | WordPress 7.1 security delta review | applied | Performed from the release posts, Field Guide, and dev notes: [`wordpress-7.1-delta-review-2026-10-07.md`](../../wordpress-7.1-delta-review-2026-10-07.md). Documents now cover 7.1 (current: 7.1.3) and note 7.2 (scheduled 2026-12-08) as out of scope. New Benchmark control 11.4 for Abilities API authorization overrides; Hardening Guide, glossary, and CSP notes updated |
| O-2 | Medium | PDF visual failures; stale artifacts | applied (cause identified) | The baselines in both repositories date from 2026-03-21; the PDFs were regenerated on 2026-06-14/15/17 and the visual workflow runs for those commits were cancelled, so the baselines were never refreshed. The last passing runs (April) predate the June content. This is baseline drift, not a rendering regression. Action at the next regeneration: rebuild, inspect the pages, then run `npm run validate:pdf-visual:update` and commit the new baselines with the artifacts. The R-01 table fix needs the same visual confirmation |
| O-3 | High | 2FA enforcement control (RB-7) | applied | Runbook §5.5 now includes a must-use plugin that leaves an unenrolled privileged account only the `read` capability. Tested on a throwaway WordPress 7.1.3 site with `two-factor` 0.17: unenrolled administrator and editor lose all privileged capabilities and REST access but can edit their own profile; access returns when a provider is enabled. Limits documented (Multisite Super Admins; identity-provider enforcement remains an alternative) |
| O-4 | Low | Glossary: AI Client "core-adjacent"; `SLA` entry | applied | AI Client entry now separates what ships in core (PHP SDK, `wp_ai_client_prompt()`) from the separately distributed JavaScript API and REST endpoints, per the 7.0 dev note. `SLA` entry added (the term is used in the Hardening Guide and the Runbook). Glossary is now 141 terms |
| O-5 | Low | Consumer fixture for the reusable workflow | applied (as a static guard) | A second repository is not available to act as an external caller, so `tools/ci/check_reusable_workflow_refs.sh` fails preflight if a reusable workflow uses a local action path. This covers the defect class without a cross-repository fixture |
| O-6 | Medium | Server-side examples untested | applied | Tested in disposable containers: Nginx uploads denial (403 when placed first, executes when the generic PHP location is first), WebP fallback (sidecar served only with `Accept: image/webp`, original otherwise), `rest_route` rate limit (limits query-string REST requests only), `allow`/`deny` order; Ubuntu 24.04 `sshd -t` and `sshd -T` with the documented settings and `Match` context; UFW rule staging, enable, and port transition; `php-fpm8.3 -i`, which confirmed that pool `php_admin_value` overrides are not shown by it and must be checked separately as documented. No changes were needed |
| O-7a | Medium | Backup script identity and log permissions | applied | The script was installed root-owned with an unqualified cron entry, but WP-CLI refuses to run as root and the log path is root-only. It now refuses to run as root, runs as the site user from `/etc/cron.d`, and the log file is pre-created for that user |
| O-7b | Medium | Archive integrity checks | applied | The "verify" step only logged file sizes. It now runs `gzip -t` and writes a SHA-256 manifest that the restore procedure checks |
| O-7c | Medium | AIDE paths | applied | Verified on Ubuntu 24.04: `aide --check` fails without `--config /etc/aide/aide.conf`, and the documented `mv aide.db aide.db.orig` fails on a fresh install because the file does not exist yet. Commands corrected in three places; RHEL-family paths noted |
| O-7d | Low | PHP-FPM pool step | applied | Step now names the settings to carry over and validates with `php-fpm8.3 -t` |
| O-7e | — | Update rollback prerequisites | rejected | Not a defect: the pre-deployment database export the rollback depends on is created earlier in the Runbook (pre-deployment checklist) |
| RB-9 | — | Offload settings key names (flagged for verification in the first pass) | applied | Verified against the plugin's public source: option key `tantan_wordpress_s3`, settings constant `AS3CF_SETTINGS`, keys `provider`, `bucket`, `region`, `use-server-roles`. Example now uses the instance role |

Nothing remains open. Two facts are recorded as not established and are deliberately not stated in the documents: the capability required by the 7.1 media sideload endpoint, and the AVIF MIME-check behavior mentioned in its dev note (see the 7.1 delta review).

## Verification After Corrections

- `bash tools/ci/review_preflight.sh` with `REQUIRE_SIBLING_REPOS=1`: passed (portable paths, cross-repo metrics, 151 WP-CLI command lines, regression and glossary watchlists, skill bundles, reusable-workflow references). Workflow lint skipped: `actionlint` is not installed locally.
- `verify-metrics.sh` passed in all four document repositories after their `docs/current-metrics.md` files were updated.
- PHP snippets (users routes, role reconciliation, session lifetime, 2FA enforcement) were executed on local WordPress 7.1.x sites; server examples were executed in disposable containers (details in `claude-review.md`).
- Not run: publication builds, PDF visual validation, `rebuild-all-docs.sh` dispatch, any remote WordPress site.

## Next Steps

1. Human editorial review and merge of the five pull requests.
2. Regenerate PDF, DOCX, and EPUB, confirm the Runbook §3.2 tables visually, and refresh the PDF visual baselines.
3. Repeat the delta review for WordPress 7.2 (Beta 2026-10-20, release 2026-12-08).

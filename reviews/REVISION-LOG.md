# Revision Log

Chronological record of editorial rounds, changes applied, and commits. Each round follows the process described in `PROCESS-SUMMARY.md`.

---

## Round 3 Prep — Focused Runbook Review + WordPress 7.0 Readiness (March 2026)

**Models involved:** pending for the runbook round
**Human editor:** Dan Knauss (@dknauss)

### Scope

- Bootstrapped a focused runbook-only review round in `rounds/2026-03-15/` to concentrate the next audit on the Operations Runbook, which accounted for 12 of the 16 merged findings in the 2026-03-14 synthesis.
- Created `wordpress-7.0-readiness-2026-03-15.md` to capture the upcoming WordPress 7.0 version-reference sweep and PHP 8.4 editorial recommendation work.

### Preparation Notes

- The focused round keeps `WP-Operations-Runbook.md` as the primary review target and uses the Benchmark, Hardening Guide, and Style Guide as supporting references.
- The WordPress 7.0 readiness brief is grounded in current official project references: WordPress 7.0 remains scheduled for April 9, 2026; WordPress.org currently recommends PHP 8.3+; and core presently describes PHP 8.4 as beta compatible rather than fully supported.
- `bash tools/ci/review_preflight.sh` passed before model execution, so the round is mechanically clear to proceed.
- The first review pass was executed with the single-model, multi-agent method. Phase outputs were recorded in `rounds/2026-03-15/phase1-runbook.md`, `phase1-benchmark-alignment.md`, `phase1-hardening-guide.md`, and `phase1-style-guide.md`, then merged into `rounds/2026-03-15/synthesis.md`.
- The resulting runbook fixes were applied in `wordpress-runbook-template` commit `a323448`, and the focused round was closed with all 12 synthesized findings marked `applied`.

---

## Round 1 — Cross-Document Consistency Audit (March 2026)

**Models involved:** Gemini 2.5 Pro, GPT-5.3-Codex-xhigh, Claude Opus 4
**Human editor:** Dan Knauss (@dknauss)

### Scope

Full cross-document review of all four security documents after significant independent revisions by Gemini, GPT, and the human editor. Focus: correctness, alignment, and gaps between the four docs given their distinct audiences.

### Benchmark Changes

| Commit | Changes | Lines |
|---|---|---|
| `e0b9595` | Technical fixes from cross-document audit | +10 / -7 |
| `90b699f` | Remove redundant `return 403` from Nginx `deny all` blocks | -2 |

Key fixes:
- **REST API scoping (section 5.6)**: Changed unconditional `unset($endpoints['/wp/v2/users'])` to guarded with `current_user_can('list_users')`. The unconditional removal broke the block editor's author selector.
- **Glob escaping**: Fixed `\*` to `*` in grep glob pattern (line 227).
- **TLS classification**: Appendix A section 1.1 changed from L1 to L2.
- **XML-RPC disabling**: Changed "via `wp-config.php`" to "via a must-use plugin" (section 4.4).
- **PHP sessions**: Added defense-in-depth caveat to section 2.5 Rationale noting WordPress core does not use native PHP sessions.
- **Cross-references**: Added Runbook to Related Documents.
- **Nginx blocks**: Removed redundant `return 403` after `deny all` in xmlrpc.php and wp-cron.php location blocks.

### Hardening Guide Changes

| Commit | Changes | Lines |
|---|---|---|
| `6e5aff1` | Technical fixes from cross-document audit | +6 / -5 |

Key fixes:
- **Argon2id version floor**: Changed PHP 7.2+ to 7.3+ (section A04). `PASSWORD_ARGON2ID` constant requires PHP 7.3.
- **WP-Cron (section 7.2)**: Added `DISABLE_WP_CRON` constant requirement. Without the constant, a system cron runs in addition to page-load triggers rather than replacing them.
- **Auto-update backport floor**: Changed from 4.1 to 3.7 (sections 3.3, 5).
- **PHP sessions**: Added caveat to section 6.3.
- **Cross-references**: Added Runbook to Related Documents.

### Style Guide Changes

| Commit | Changes | Lines |
|---|---|---|
| `d0521a0` | Cross-reference: add Runbook to Related Documents | +1 |
| `ebb663c` | Add 11 missing glossary terms from cross-document audit | +22 |

New glossary terms: CDN, DISALLOW_FILE_EDIT, DISALLOW_FILE_MODS, FORCE_SSL_ADMIN, mu-plugin (must-use plugin), Object cache, Super Admin, TLS, Transient, WP-CLI, WP-Cron. All terms appear prominently in the companion documents but were absent from the Style Guide glossary.

### Runbook Changes

| Commit | Changes | Lines |
|---|---|---|
| `139c969` | Technical fixes from cross-document audit | +58 / -60 |
| `a9d8191` | Annotate plugin-dependent cache commands, fix Query Cache ref | +18 / -13 |

Key fixes:
- **Database privileges**: Replaced `GRANT ALL PRIVILEGES` with 8-privilege grants (`SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, INDEX, DROP`) at 2 locations.
- **WP-CLI commands (~25 fixes)**: Replaced nonexistent, plugin-dependent, or incorrectly flagged commands with verified alternatives. Examples:
  - `wp debug log tail` replaced with `tail` on the actual debug.log file (3 locations).
  - `--field=name,status,update` changed to `--fields=name,status,update` (4 locations).
  - `wp health-check run` replaced with `curl` health check.
  - `wp db check --repair` split into separate `wp db check` then `wp db repair`.
  - `wp comment delete --force --status=spam` replaced with proper two-step (list IDs, then delete).
  - `wp post list --post_type=all` changed to `--post_type=any`.
  - `wp cache flush --global` changed to `wp cache flush` (no `--global` flag).
  - `wp db table list` changed to `wp db tables` (3 locations).
  - `wp wordfence scan full` replaced with `clamscan -r` plus note about Wordfence dashboard.
  - `wp plugin delete --deactivate` split into separate deactivate then delete.
- **Configuration template**: Fixed `WP_DEBUG_LOG` set to `true` with `WP_DEBUG` set to `false`. Removed closing `?>` tag. Replaced deprecated `WPLANG` constant with comment.
- **Dependency management**: Changed `composer update --no-dev` to `composer install --no-dev` (2 locations).
- **Plugin-dependent commands**: Annotated `wp w3-total-cache` and `wp redis` commands as plugin-dependent at all occurrences (6 locations). Cleaned Quick Reference Card.
- **Query Cache table**: Noted MySQL Query Cache removed in MySQL 8.0+ (MariaDB retains it).
- **Cross-references**: Fixed Quick Reference Card section reference (8.3 changed to 11.3). Added deprecated `WPLANG` to Appendix D.

### GPT Corrections to Audit Findings

During the synthesis step, GPT-5.3-Codex provided corrections to Claude's initial audit:

- **OWASP Top 10:2025**: Claude flagged as potentially unpublished. GPT confirmed it is published. Finding dropped.
- **Query Cache**: Claude flagged as potentially stale. GPT noted it depends on MySQL vs MariaDB version. Addressed with table annotation.
- **`wp user update --user_login`**: Claude flagged as broken. GPT noted it requires runtime validation, not a blanket assumption. Not changed without testing.
- **"~20 nonexistent commands"**: GPT reframed as "not part of core WP-CLI / plugin-dependent / invalid syntax." Adopted this framing.

### Rejected Findings

- **Benchmark section 2.5 removal**: One model suggested removing the PHP sessions section entirely since WordPress core doesn't use them. Rejected — the section is legitimate defense-in-depth for plugins that call `session_start()`. A caveat was added to the Rationale instead.
- **Nginx `deny all` semantics debate**: One model suggested replacing `deny all` with `return 403` for "clarity." Rejected — `deny all` is idiomatic Nginx and already returns 403. The redundant `return 403` lines were removed instead.

---

## Infrastructure Round — YAML Frontmatter and Versioning (March 2026)

**Models involved:** Claude Opus 4
**Human editor:** Dan Knauss (@dknauss)

### Scope

Add YAML frontmatter to all four documents, update GitHub Actions workflows for automated date injection, version display, and EPUB generation. Add git tags and release workflows.

### Changes Applied (All Four Repos)

- Added YAML frontmatter (`title`, `subtitle`, `author`, `date`, `version`) to all four markdown documents.
- Updated `generate-docs.yml` workflow:
  - Added "Update date in frontmatter" step (auto-stamps build date).
  - Added version extraction from frontmatter for PDF title page display.
  - Added EPUB output (`--epub-title-page=false`, committed alongside PDF and DOCX).
- Created `pdf-defaults.yaml` (eisvogel template, Noto fonts, navy/WordPress-blue title page).
- Tagged releases (v1.0 for Benchmark, Hardening Guide, Style Guide; v2.0 for Runbook).
- Runbook: Added `header-includes` for LaTeX cover page metadata table. Removed old plain-text header. Positioned Emergency Quick-Reference Card before the TOC.
- Hardening Guide: Removed manual table of contents (Pandoc generates it).

---

## Round 2 — Single-Model Multi-Agent Review + Multi-Model Board Setup (March 2026)

**Models involved:** Claude Opus 4 (Sonnet and Haiku tiers for internal agents)
**Human editor:** Dan Knauss (@dknauss)

### Scope

First execution of the single-model multi-agent architecture described in `single-model-multi-agent.md`. Four Sonnet agents (@BenchmarkAgent, @HardeningGuideAgent, @RunbookAgent, @StyleGuideAgent) audit documents in parallel, followed by Haiku validation and Opus cross-document audit.

Concurrent with this round: GPT-5.3-Codex-xhigh is working on a separate branch in the Runbook repo exploring a new direction for that document. That branch's changes are not included in this review round — they will be evaluated in a future synthesis once the branch is ready for review.

### Process Documentation Created

- `single-model-multi-agent.md` — Architecture for Opus/Sonnet/Haiku tier mapping to AGENTS.md roles.
- `multi-model-editorial-board.md` — Three approaches to orchestrating multi-model reviews: manual, semi-automated, and scripted (with `review-round.sh` script and prompt template).

### Phase 1 — Parallel Sonnet Document Audits

Four Sonnet agents ran concurrently, each auditing one document under its AGENTS.md persona:

| Agent | Findings | Critical | High | Medium | Low |
|---|---|---|---|---|---|
| @BenchmarkAgent | 17 | 2 | 3 | 7 | 5 |
| @HardeningGuideAgent | 12 | 1 | 4 | 5 | 2 |
| @RunbookAgent | 20 | 3 | 6 | 7 | 4 |
| @StyleGuideAgent | 13 | 0 | 2 | 4 | 7 |
| **Total** | **62** | **6** | **15** | **23** | **18** |

Notable findings:
- **Benchmark**: REST API endpoint filter uses `is_user_logged_in()` instead of `current_user_can('list_users')` (Critical). Duplicate REST API controls (5.4 and 5.6) with conflicting guard logic.
- **Hardening Guide**: Roles/capabilities API called from `wp-config.php` — silently fails because the roles system isn't bootstrapped yet (Critical). IBM breach cost figure suspect. NordVPN citation violates source authority rules.
- **Runbook**: `wp core update --dry-run` (nonexistent flag), `wp user session destroy` (nonexistent subcommand), `wp site switch-language` (nonexistent) — all Critical. Fictional `wp shell` procedure. Broken `grep -E` pattern.
- **Style Guide**: Two glossary alphabetical ordering errors (`FORCE_SSL_ADMIN` after `FUD`, `mu-plugin` after `Multisite`). Cross-reference formatting inconsistencies. 7 missing glossary terms.

### Phase 2 — Haiku Mechanical Validation

Four Haiku validators ran concurrently:

- **WP-CLI validator**: 98 commands checked, 15 issues (7 confirmed from Phase 1, 8 new — mostly unannotated plugin-dependent commands).
- **Code block linter**: 48 missing language annotations in Benchmark (bare ` ``` ` instead of ` ```bash `). No markdown escaping corruption found.
- **Glossary checker**: 125 existing entries, 7 missing terms (SIEM, UFW, PHP-FPM, AIDE, Snuffleupagus, SIM-swapping, Ransomware), 2 ordering errors, 4 cross-reference formatting issues.
- **URL checker**: 105+ URLs checked, 7 issues — NIST SP 800-63B revision mismatch between documents, NIST SP 800-61 superseded, WordPress Security White Paper URL/label error.

### Phase 3 — Opus Cross-Document Audit

The @AuditAgent read all four documents plus all Phase 1-2 findings:

- **51 Phase 1-2 findings confirmed** as accurate and actionable.
- **5 Phase 1-2 findings challenged** — code block lint severity downgraded from High to Low; OWASP 2025 concern downgraded (edition likely published); one Runbook `--field` finding rejected as false positive.
- **11 new cross-document findings** identified, including:
  - Runbook REST API code diverges from Benchmark's capability-checked implementation (High).
  - PHP version floor discrepancy: Runbook says "8.1+" while Benchmark and Hardening Guide say "8.2+" (Medium).
  - `wp-config.php` permissions contradiction: Style Guide glossary says `600`/`640`, Benchmark says `400`/`440` (Medium).

**Top 5 priorities for human editor review:**

1. Fix three nonexistent WP-CLI commands in the Runbook.
2. Consolidate three divergent REST API user-endpoint implementations to a single correct version.
3. Remove the claim that roles can be defined in `wp-config.php` (both Hardening Guide and Benchmark).
4. Update two stale NIST URLs in the Hardening Guide.
5. Resolve the `wp-config.php` permissions contradiction between Style Guide glossary and Benchmark.

Full findings archived in `rounds/2026-03-03/`.

### Implementation — Phase 3 Findings Applied

**45 findings triaged by human editor:** 43 accepted (some with modifications), 1 rejected (#15 — IBM $4.44M figure confirmed correct for 2025), 1 already clean on inspection (#24 — sshd_config leading space).

#### Benchmark (`3e19d90`) — 13 findings

| # | Summary |
|---|---|
| 4 | `is_user_logged_in()` → `current_user_can('list_users')` for REST API guard |
| 5 | Remove `wp-config.php` from role definitions (roles API needs `init` hook) |
| 8 | `update_available` → `update` in WP-CLI `--fields` |
| 10 | Reclassify TLS from Level 2 to Level 1 with definition note |
| 26 | Add OWASP API Security Top 10 (2023) prose clarification in §1.5 |
| 27 | `wp-cli` → `WP-CLI` in prose (3 locations) |
| 30 | Remove `--allow-root`, add comment about running as site user |
| 37 | Add `bash` language annotations to 50 unannotated code blocks |
| 40 | Convert PHP inline backtick snippets to fenced code blocks (§4.1–4.7) |
| 42 | Add RHEL/AlmaLinux/Rocky Linux portability note (CentOS is EOL) |
| 43 | Reorder Fortress before wp-sudo, add authorial disclosure |
| 44 | Add `wp plugin verify-checksums` reference link |

#### Hardening Guide (`b5d0d30`) — 9 findings

| # | Summary |
|---|---|
| 5 | Remove `wp-config.php` from role definitions (roles API needs `init` hook) |
| 6 | Update NIST SP 800-63B URL to revision 4 |
| 7 | Update NIST SP 800-61 URL to revision 3, add Section 3 reference |
| 12 | Replace NordVPN citation with Verizon DBIR + SpyCloud data |
| 19 | Fix WordPress Security White Paper URLs to canonical `wordpress.org/about/security/` |
| 21 | Revise Gartner attribution — keep as framing, clarify IBM is data source |
| 25 | "admin panel" → "Dashboard" |
| 31 | Add parenthetical distinguishing 20% shadow AI from 16% attacker AI stats |
| 32 | Add NIST SP 800-61r3 Section 3 specific reference |

#### Style Guide (`31a8d18`) — 5 findings

| # | Summary |
|---|---|
| 9 | Add §3.7 Context-Dependent Technical Recommendations with editorial principles and Do/Don't table; update `wp-config.php` glossary entry |
| 18 | Reorder glossary entries (FORCE_SSL_ADMIN before FUD, mu-plugin before Multisite) |
| 19 | Fix WordPress Security White Paper URLs to canonical `wordpress.org/about/security/` |
| 35 | Add 7 missing glossary terms (AIDE, PHP-FPM, Ransomware, SIEM, SIM-swapping, Snuffleupagus, UFW) |
| 36 | Fix 4 cross-reference formatting errors (monospace → italic per convention) |

#### Runbook (`cfa3869`) — 19 findings

| # | Summary |
|---|---|
| 1 | `wp core update --dry-run` → `wp core check-update` |
| 2 | Annotate `wp user session destroy` as plugin-dependent |
| 3 | `wp site switch-language` → `wp language core activate` |
| 4/14 | Replace unconditional REST API `unset()` with capability-checked code |
| 11 | Remove redundant `return 403` after `deny all` in Nginx blocks |
| 13 | `wp redis flush` → `wp redis flush-db` |
| 16 | Replace fictional `wp shell` revision procedure with WP-CLI approach |
| 17 | Replace `ROLLBACK` no-op with backup restore note |
| 20 | PHP 8.1+ → 8.2+ (two locations) |
| 22 | Add plugin-dependency annotation to mailer commands |
| 23 | Add note that SMTP constants need consuming plugin code |
| 28 | Add WordPress 5.6 version note to `WP_AUTO_UPDATE_CORE` |
| 29 | `maintenance-mode` version: WP-CLI 2.2+ (not 2.8+) |
| 33 | Split mixed Nginx/bash code block into separate fenced blocks |
| 38 | Add HSTS preload annotation (two locations) |
| 39 | Add CSP `unsafe-eval` warning annotation |
| 41 | Add `<?php` opening tag to xmlrpc mu-plugin example |
| 45 | Change 500 error first command to `tail /var/log/php-errors.log` |

#### Notable Editorial Decisions

- **#15 Rejected**: The IBM Cost of a Data Breach 2025 figure of $4.44M was confirmed correct (a decline from $4.88M in 2024). All four agents that flagged this were wrong — the 2025 report showed costs going down for the first time in five years.
- **#21 Modified**: Gartner retained as industry framing reference; IBM identified as the factual data source. Original finding wanted to remove Gartner entirely.
- **#9 Modified**: Instead of prescribing specific `wp-config.php` permissions, added a new Style Guide section (§3.7) teaching writers how to write about context-dependent recommendations. The glossary entry was updated to reference §3.7.
- **#42 Modified**: CentOS removed from portability notes (EOL). Replaced with RHEL/AlmaLinux/Rocky Linux as the CentOS successors.
- **#29 Corrected**: `wp maintenance-mode` introduced in WP-CLI v2.2.0 (April 25, 2019), not 2.8+ as originally written.

---

## Formatting Note

Commits in this log use short hashes as recorded at the time of the editorial round. These may have been rebased during push if the CI workflow committed generated documents between rounds. The full history is preserved in each document's git log.

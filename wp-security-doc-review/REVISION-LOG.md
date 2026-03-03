# Revision Log

Chronological record of editorial rounds, changes applied, and commits. Each round follows the process described in `PROCESS-SUMMARY.md`.

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

## Formatting Note

Commits in this log use short hashes as recorded at the time of the editorial round. These may have been rebased during push if the CI workflow committed generated documents between rounds. The full history is preserved in each document's git log.

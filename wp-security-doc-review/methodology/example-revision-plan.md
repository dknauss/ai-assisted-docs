# Example Revision Plan

This is a representative example of a synthesized revision plan, drawn from the March 2026 cross-document audit. It shows how findings from multiple models are merged, verified, and prioritized before implementation.

## Context

Three models independently reviewed all four documents. Their findings were compared, cross-validated, and synthesized into this plan. Each item includes its verification status and the editorial decision.

---

## Critical Priority (Technical Correctness)

### 1. Database Privilege Grants — Runbook

**Finding (all 3 models agree):** Runbook uses `GRANT ALL PRIVILEGES` in two database setup sections. Benchmark prescribes 8 specific privileges.

**Verification:** Benchmark section 3.1 specifies `SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, INDEX, DROP`. WordPress core requires exactly these 8 for normal operation (including schema changes during updates). `GRANT ALL` adds dangerous extras like `FILE`, `PROCESS`, `SUPER`.

**Decision:** Accept. Replace both occurrences in Runbook with the 8-privilege grant.

### 2. REST API Endpoint Removal — Benchmark

**Finding (2 of 3 models):** Benchmark section 5.6 unconditionally removes `/wp/v2/users` endpoints. This breaks the block editor's author selector for authorized users.

**Verification:** Confirmed. The block editor's `AuthorSelect` component queries this endpoint. Unconditional removal causes a JavaScript error in the post editor.

**Decision:** Accept. Wrap in `current_user_can('list_users')` guard.

### 3. WP-CLI Command Validity — Runbook

**Finding (all 3 models, varying counts):** Multiple WP-CLI commands in the Runbook are nonexistent, plugin-dependent, or use invalid flags.

**Verification:** Checked each command against `wp help <command>` and the WP-CLI command reference. Confirmed ~25 commands need correction. Categories:
- Nonexistent subcommands (e.g., `wp debug log tail`, `wp health-check run`)
- Invalid flags (e.g., `--field` instead of `--fields`, `--global` on `wp cache flush`)
- Wrong argument values (e.g., `--post_type=all` instead of `--post_type=any`)
- Plugin-dependent commands presented as core (e.g., `wp wordfence scan full`)

**Decision:** Accept. Fix each command individually with verified alternatives.

---

## High Priority (Cross-Document Alignment)

### 4. Argon2id PHP Version — Hardening Guide

**Finding (1 model):** States PHP 7.2+ for Argon2id. Should be 7.3+.

**Verification:** `PASSWORD_ARGON2ID` constant was added in PHP 7.3.0. PHP 7.2 added `PASSWORD_ARGON2I` (without the 'd'). The Hardening Guide section A04 specifically references Argon2id, not Argon2i.

**Decision:** Accept. Change to 7.3+.

### 5. Auto-Update Backport Floor — Hardening Guide

**Finding (2 models):** States automatic security updates since WordPress 4.1. Should be 3.7.

**Verification:** WordPress 3.7 (October 2013) introduced automatic background updates for minor releases. This is well-documented in the WordPress Developer Handbook.

**Decision:** Accept. Change to 3.7 in both occurrences (sections 3.3 and 5).

### 6. DISABLE_WP_CRON Omission — Hardening Guide

**Finding (1 model):** Section 7.2 recommends system cron but omits the `DISABLE_WP_CRON` constant. Without it, system cron runs in addition to page-load triggers.

**Verification:** Confirmed. The constant is required to disable the page-load trigger. WordPress Handbook confirms this behavior.

**Decision:** Accept. Add the constant and explanation.

---

## Medium Priority (Completeness)

### 7. Style Guide Glossary Gaps

**Finding (1 model):** Several terms used extensively across the other three documents lack glossary entries. Examples: WP-Cron, DISALLOW_FILE_EDIT, mu-plugin, TLS, WP-CLI.

**Verification:** Cross-referenced all glossary entries against key terms in the other three documents. Confirmed 11 missing terms.

**Decision:** Accept. Add all 11 terms in the existing glossary style, alphabetically placed.

### 8. Related Documents Cross-References

**Finding (1 model):** The Runbook is missing from Related Documents in 3 of the 4 documents.

**Verification:** Confirmed. Only the Runbook itself links to the other three. The Benchmark, Hardening Guide, and Style Guide don't link back.

**Decision:** Accept. Add Runbook entry to Related Documents in all three.

---

## Low Priority (Polish)

### 9. Nginx `deny all` + `return 403` Redundancy — Benchmark

**Finding (1 model):** Two Nginx location blocks include both `deny all;` and `return 403;`. The `deny all` directive already returns 403.

**Verification:** Confirmed. Nginx processes `deny all` first, returning 403 before `return 403` is reached. The second directive is dead code.

**Decision:** Accept. Remove the redundant `return 403;` lines.

### 10. Plugin-Dependent Cache Commands — Runbook

**Finding (1 model):** `wp w3-total-cache` and `wp redis` commands are annotated as plugin-dependent at the first occurrence but appear unannotated at 5 additional locations.

**Decision:** Accept. Add the annotation at all occurrences.

---

## Rejected Findings

### R1. OWASP Top 10:2025 Publication Status

**Finding (1 model):** Flagged references to "OWASP Top 10:2025" as potentially referencing an unpublished document.

**Verification:** GPT confirmed the OWASP Top 10:2025 is published and available at owasp.org/Top10/2025/.

**Decision:** Reject. No change needed.

### R2. Remove PHP Sessions Section Entirely

**Finding (1 model):** Suggested removing Benchmark section 2.5 (PHP session security) since WordPress core doesn't use native PHP sessions.

**Verification:** While WordPress core doesn't use `$_SESSION`, some plugins do call `session_start()`. The section is legitimate defense-in-depth.

**Decision:** Reject full removal. Added a caveat to the Rationale instead.

### R3. Query Cache Removal

**Finding (1 model):** Flagged Runbook Query Cache references as stale.

**Verification:** MySQL 8.0+ removed Query Cache, but MariaDB retains it. Many WordPress deployments still use MariaDB. The Runbook's caching table already says "Disabled / configured."

**Decision:** Modify. Added "(removed in MySQL 8.0+)" to the table entry rather than removing it.

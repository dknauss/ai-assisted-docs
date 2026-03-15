# Multi-Model Review Synthesis — 2026-03-14

By OpenCode en Big Pickle Max

## Overview

Three models reviewed the four canonical WordPress security documents:

- **Gemini 3 Pro CLI** — 4 findings
- **GPT-5.4-Codex (extra high)** — 7 findings  
- **Claude Opus 4.6** — 16 findings

This synthesis merges findings, identifies convergent vs. divergent conclusions, and provides a prioritized recommendation plan.

---

## Convergent Findings (High Confidence)

These findings were identified by multiple models:

### 1. `wp user update --user_login` — DOES NOT EXIST

- **Models:** All 3 (Gemini #1, GPT #1, Claude #1)
- **Severity:** High
- **Document:** Benchmark §5.2
- **Finding:** The command `wp user update <user-id> --user_login=<new-username>` is invalid. WP-CLI does not support changing `user_login`.
- **Recommendation:** Replace with database query or create new account + delete old.
- **Verification:** `wp help user update` — no `--user_login` flag

### 2. `--post_status=scheduled` should be `--post_status=future`

- **Models:** GPT #3, Claude #3
- **Severity:** High
- **Document:** Runbook §9.2
- **Finding:** WordPress uses `future` status, not `scheduled`.
- **Recommendation:** Change to `--post_status=future`
- **Verification:** `wp help post list` + WordPress Post Status docs

### 3. Password minimum length inconsistency (15 vs 12)

- **Models:** Claude #5 (also Gemini #2 noted version inconsistency)
- **Severity:** High
- **Documents:** Benchmark vs Hardening Guide
- **Finding:** Benchmark says 15 chars without MFA; Hardening Guide says 12 chars.
- **Recommendation:** Align to NIST SP 800-63B: 15 without MFA, 12 with MFA.
- **Verification:** NIST SP 800-63B §3.1.1.2

### 4. `wp term delete --default` flag does NOT exist

- **Models:** GPT #4, Claude #4
- **Severity:** Medium
- **Document:** Runbook §9.3
- **Finding:** `--default` flag is invalid.
- **Recommendation:** Remove the flag; WordPress auto-reassigns to default category.
- **Verification:** `wp help term delete`

### 5. `JPEG_QUALITY` is NOT a WordPress constant

- **Models:** GPT #5, Claude #6
- **Severity:** Medium
- **Document:** Runbook Appendix B.5
- **Finding:** No such constant; use `jpeg_quality` filter.
- **Recommendation:** Remove constant; use filter in mu-plugin.
- **Verification:** WP core source search

### 6. WP Mail SMTP option names incorrect

- **Models:** Claude #7
- **Severity:** Medium
- **Document:** Runbook §6.7
- **Finding:** Individual options don't exist; config is in serialized `wp_mail_smtp` option.
- **Recommendation:** Use plugin's constant-based config or admin UI.
- **Verification:** WP Mail SMTP docs

---

## Independent Findings (Single Model)

### Gemini-only

- **#3:** WP-CLI `wp option update mailer` JSON formatting — should add `--format=json` flag (Medium)
- **#4:** SSRF glossary reference check — verified present, no action needed

### GPT-only

- **#2:** Style Guide `wp-cli checksum` vs `wp core verify-checksums` (Medium) — needs verification
- **#6:** Hardcoded `wp_` table prefixes vs custom prefix support (Medium)
- **#7:** WP_AUTO_UPDATE_CORE history (Low)

### Claude-only (beyond convergent)

- **#2:** `php8.2-json` package doesn't exist — remove from PHP upgrade (Medium)
- **#8:** Remove `rm wp-admin/install.php` — core already protects (Low)
- **#9:** `DB_COLLATE` should be empty string (Low)
- **#11:** Lowercase "dashboard" → "Dashboard" (Low)
- **#12:** SMTP `wp_mail` filter dead code — use `phpmailer_init` (Medium)
- **#13:** Cross-doc matrix wording inconsistencies (Low)
- **#14:** Benchmark/Hardening Guide database privileges nuance (Low)
- **#15:** Glossary terms — need verification against current glossary
- **#16:** `WP_DEBUG_LOG = true` in production template (Medium)

---

## Priority Recommendations

### Priority 1 — High Severity (Fix Now)

| # | Finding | Document | Action |
|---|---|---|---|
| 1 | `wp user update --user_login` | Benchmark §5.2 | Replace with db query or new user workflow |
| 2 | `--post_status=scheduled` | Runbook §9.2 | Change to `--post_status=future` |
| 3 | Password length 15 vs 12 | Hardening Guide §8.3 | Align with NIST: 15 without MFA, 12 with |

### Priority 2 — Medium Severity (Fix Next)

| # | Finding | Document | Action |
|---|---|---|---|
| 4 | `wp term delete --default` | Runbook §9.3 | Remove invalid flag |
| 5 | `JPEG_QUALITY` constant | Runbook App B.5 | Remove; use filter |
| 6 | `php8.2-json` package | Runbook §6.5 | Remove from apt list |
| 7 | WP Mail SMTP options | Runbook §6.7 | Use plugin constants or UI |
| 8 | SMTP `wp_mail` filter | Runbook §6.7 | Fix or remove dead code |
| 9 | `WP_DEBUG_LOG=true` | Runbook App B.4 | Fix to `false` |

### Priority 3 — Lower Severity / Verify

| # | Finding | Document | Action |
|---|---|---|---|
| 10 | Glossary: verify `wp-cli checksum` | Style Guide | Check if needs fix |
| 11 | Hardcoded `wp_` prefix | Runbook | Add `[CUSTOMIZE]` or use `$(wp db prefix)` |
| 12 | WP_AUTO_UPDATE_CORE history | Runbook App B.5 | Fix comment |
| 13 | Dashboard capitalization | Runbook §6.3 | Capitalize |
| 14 | DB_COLLATE empty string | Runbook App B.1, B.9 | Change to `''` |
| 15 | rm install.php | Runbook §5.2 | Remove line |
| 16 | Glossary terms | Style Guide | Verify which need adding |

---

## Findings Requiring Verification

These findings need manual verification before implementation:

1. **Style Guide `wp-cli checksum`** — GPT says wrong, but earlier REVISION-LOG shows this was already fixed. Verify current state.
2. **Glossary terms (SBOM, EPSS, virtual patching, shadow AI, Argon2id)** — Claude says missing. Earlier review (this session) found they ARE present. Verify current state.
3. **Cross-document matrix wording** — Low priority, verify if still inconsistent.

---

## Summary by Document

| Document | High Priority | Medium Priority | Low Priority |
|---|---|---|---|
| Benchmark | 1 (user_login) | — | — |
| Hardening Guide | 1 (password length) | — | — |
| Runbook | 1 (post_status) | 5 | 6 |
| Style Guide | — | — | 1 (verify) |

---

## Next Steps

1. **Human editor reviews** this synthesis
2. **Approves/rejects/modifies** each finding
3. **Changes applied** to canonical repos
4. **Metrics verified** and CHANGELOG updated

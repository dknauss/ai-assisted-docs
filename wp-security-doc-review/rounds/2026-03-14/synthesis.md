# Multi-Model Review Synthesis — 2026-03-14

By OpenCode en Big Pickle Max

## Overview

Three models reviewed the four canonical WordPress security documents:

- **Gemini 3 Pro CLI** — 4 findings
- **GPT-5.4-Codex (extra high)** — 7 findings  
- **Claude Opus 4.6** — 16 findings

This synthesis merges findings, identifies convergent vs. divergent conclusions, and provides a prioritized recommendation plan.

---

## High-Confidence Findings

These findings were either identified by multiple models or independently verified against the canonical docs and primary sources:

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
- **Documents:** Benchmark §5.7 vs Hardening Guide §8.3
- **Finding:** Benchmark says 15 chars without MFA; Hardening Guide says 12 chars. Neither number is directly from NIST. NIST SP 800-63B Rev 4 §3.1.1.2 says SHALL 8 / SHOULD 15, with no MFA-conditional threshold and no mention of 12.
- **Recommendation:** Align both documents to 15 characters (matching NIST SHOULD). The Benchmark's "if MFA is not enabled" conditional is a defensible policy addition but should be presented as the document's own guidance, not attributed to NIST. The Hardening Guide's "12 characters" does not correspond to any NIST threshold and should be updated to 15.
- **Verification:** NIST SP 800-63B Rev 4 §3.1.1.2 — the text reads "Verifiers and CSPs SHALL require passwords to be a minimum of eight characters in length" and "Verifiers and CSPs SHOULD require passwords to be a minimum of 15 characters in length."

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

- **#3:** WP-CLI `wp option update mailer` JSON formatting — superseded by the broader fix to remove unsupported per-field SMTP option updates and use plugin constants or the admin UI instead (Medium)
- **#4:** SSRF glossary reference check — verified present, no action needed

### GPT-only

- **#2:** Style Guide `wp-cli checksum` vs `wp core verify-checksums` (Medium) — confirmed current defect
- **#6:** Hardcoded `wp_` table prefixes vs custom prefix support (Medium)
- **#7:** WP_AUTO_UPDATE_CORE history (Low)

### Claude-only (beyond convergent)

- **#2:** `php8.2-json` package doesn't exist — remove from PHP upgrade (Medium)
- **#8:** Remove `rm wp-admin/install.php` — core already protects (Low)
- **#9:** `DB_COLLATE` should be empty string (Low)
- **#11:** Lowercase "dashboard" → "Dashboard" (Low)
- **#12:** SMTP `wp_mail` filter dead code — remove it and use the plugin's constant-based configuration or admin UI instead (Medium)
- **#13:** Cross-doc matrix wording inconsistencies (Low)
- **#14:** Benchmark/Hardening Guide database privileges nuance (Low) — reviewed and rejected as a required text change; the current docs already align on the 8-privilege baseline, and the Hardening Guide's note about plugin-specific extra privileges is conditional rather than contradictory
- **#15:** Glossary terms — verified present in the current glossary, no action
- **#16:** `WP_DEBUG_LOG = true` in production template (Medium)

---

## Priority Recommendations

### Priority 1 — High Severity (Fix Now)

| # | Finding | Document | Action |
|---|---|---|---|
| 1 | `wp user update --user_login` | Benchmark §5.2 | Replace with db query or new user workflow |
| 2 | `--post_status=scheduled` | Runbook §9.2 | Change to `--post_status=future` |
| 3 | Password length 15 vs 12 | Benchmark §5.7 and Hardening Guide §8.3 | Align both documents to the 15-character baseline and note NIST Rev. 4's SHALL 8 / SHOULD 15 guidance accurately |

### Priority 2 — Medium Severity (Fix Next)

| # | Finding | Document | Action |
|---|---|---|---|
| 4 | `wp term delete --default` | Runbook §9.3 | Remove invalid flag |
| 5 | `JPEG_QUALITY` constant | Runbook App B.5 | Remove; use filter |
| 6 | `php8.2-json` package | Runbook §6.5 | Remove from apt list |
| 7 | WP Mail SMTP options | Runbook §6.7 | Use plugin constants or UI |
| 8 | SMTP `wp_mail` filter | Runbook §6.7 | Fix or remove dead code |
| 9 | `WP_DEBUG_LOG=true` | Runbook App B.4 | Fix to `false` |

### Priority 3 — Lower Severity / Confirmed

| # | Finding | Document | Action |
|---|---|---|---|
| 10 | Style Guide checksum command names | Style Guide | Replace with `wp core verify-checksums` and `wp plugin verify-checksums` |
| 11 | Hardcoded `wp_` prefix | Runbook | Add `[CUSTOMIZE]` or use `$(wp db prefix)` |
| 12 | WP_AUTO_UPDATE_CORE history | Runbook App B.5 | Fix comment |
| 13 | Dashboard capitalization | Runbook §6.3 | Capitalize |
| 14 | DB_COLLATE empty string | Runbook App B.1, B.9 | Change to `''` |
| 15 | rm install.php | Runbook §5.2 | Remove line |
| 16 | Glossary terms | Style Guide | No action; cited terms are already present |

---

## Verification Outcomes

These items were rechecked against the current canonical docs:

1. **Style Guide checksum command names** — confirmed current defect; fixed in the canonical Style Guide.
2. **Glossary terms (SBOM, EPSS, virtual patching, shadow AI, Argon2id)** — already present in the current glossary; rejected as stale.
3. **Cross-document matrix wording** — confirmed as a minor inconsistency; normalized in Benchmark and Hardening Guide.
4. **Database privileges nuance** — reviewed against current WordPress hardening guidance and rejected as a required change. The Benchmark and Hardening Guide already share the same 8-privilege baseline; the Hardening Guide's note about plugin-specific extras is a conditional environment note, not a contradiction.

## Finding Disposition Ledger

Every merged finding in this round now ends in one archival state: `applied`, `rejected`, or `stale`.

| ID | Finding | Models | Status | Notes |
|---|---|---|---|---|
| F01 | `wp user update --user_login` invalid | Gemini, GPT, Claude | applied | Benchmark remediation changed to a supported workflow. |
| F02 | `--post_status=scheduled` should be `future` | GPT, Claude | applied | Runbook corrected to the real WordPress status value. |
| F03 | Password baseline mismatch and NIST framing | Gemini, Claude | applied | Benchmark and Hardening Guide aligned to the 15-character baseline with accurate Rev. 4 wording. |
| F04 | `wp term delete --default` invalid flag | GPT, Claude | applied | Runbook command corrected. |
| F05 | `JPEG_QUALITY` is not a WordPress constant | GPT, Claude | applied | Runbook switched to the supported filter-based pattern. |
| F06 | WP Mail SMTP option names incorrect | Claude | applied | Runbook moved to constant-based configuration guidance. |
| F07 | WP Mail SMTP JSON/per-field option update guidance unsupported | Gemini | applied | Resolved by the broader SMTP configuration rewrite. |
| F08 | Style Guide checksum command names invalid | GPT | applied | Style Guide updated to `wp core verify-checksums` and `wp plugin verify-checksums`. |
| F09 | Hardcoded `wp_` table-prefix assumptions | GPT | applied | Runbook examples now support custom prefixes. |
| F10 | `WP_AUTO_UPDATE_CORE` history comment inaccurate | GPT | applied | Runbook comment corrected. |
| F11 | `php8.2-json` package guidance | Claude | applied | Runbook package guidance corrected. |
| F12 | `rm wp-admin/install.php` hardening advice | Claude | applied | Reframed into explicit guidance not to rely on manual file deletion. |
| F13 | `DB_COLLATE` should be empty string by default | Claude | applied | Runbook templates corrected. |
| F14 | Lowercase `dashboard` usage in user-facing prose | Claude | applied | Runbook wording normalized to `Dashboard` where applicable. |
| F15 | SMTP `wp_mail` filter dead-code guidance | Claude | applied | Dead transport-configuration guidance removed; test-email example retained. |
| F16 | Cross-document matrix wording inconsistency | Claude | applied | Benchmark and Hardening Guide wording normalized. |
| F17 | Database privileges nuance between Benchmark and Hardening Guide | Claude | rejected | Existing text already aligned on the 8-privilege baseline; no canonical change required. |
| F18 | Missing glossary terms: Argon2id, EPSS, SBOM, Shadow AI, virtual patching | Claude | stale | Terms were already present in the current Style Guide. |
| F19 | SSRF glossary-reference concern | Gemini | stale | No glossary action remained after verification. |
| F20 | `WP_DEBUG_LOG = true` in production-facing template | Claude | applied | Runbook debug constants corrected. |

---

## Summary by Document

| Document | High Priority | Medium Priority | Low Priority |
|---|---|---|---|
| Benchmark | 1 (user_login) | — | — |
| Hardening Guide | 1 (password length) | — | — |
| Runbook | 1 (post_status) | 5 | 6 |
| Style Guide | — | 1 (checksum commands) | — |

---

## Next Steps

1. **Confirmed findings applied** to the canonical repos on 2026-03-15
2. **Metrics re-verified** and updated in the affected repos
3. **Rejected or stale findings recorded** here to prevent rework in future rounds

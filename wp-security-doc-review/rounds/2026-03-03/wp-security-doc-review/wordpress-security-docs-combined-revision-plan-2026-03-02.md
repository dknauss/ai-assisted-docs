# Combined WordPress Security Documentation Revision Plan (No Source-Doc Changes Yet)

Date: 2026-03-02

## Scope
This plan consolidates findings from two independent reviews and defines a single, decision-complete revision plan for these documents:
1. /Users/danknauss/Documents/GitHub/wp-security-style-guide/WP-Security-Style-Guide.md
2. /Users/danknauss/Documents/GitHub/wp-security-benchmark/WordPress-Security-Benchmark.md
3. /Users/danknauss/Documents/GitHub/wordpress-runbook-template/WP-Operations-Runbook.md
4. /Users/danknauss/Documents/GitHub/wp-security-hardening-guide/WordPress-Security-Hardening-Guide.md

This phase is planning only. No changes are applied to the four source docs in this file.

## Decision Rules
- Primary authority: developer.wordpress.org.
- If a recommendation deviates from WordPress developer docs, it must be labeled explicitly as optional or environment-specific and include tradeoffs.
- Objective correctness issues (invalid constants, deprecated controls, wrong hooks) are P0 and fixed before policy harmonization.

## Combined Findings

### 1) P0 Objective Errors (must fix first)
1. Argon2 guidance uses incorrect wording in multiple docs ("`wp_hash_password` filter").
- Correct WordPress filter name for algorithm selection: `wp_hash_password_algorithm`.

2. `XMLRPC_REQUEST` is used as a hardening toggle in runbook examples.
- This is not a supported hardening configuration pattern.
- Replace with supported controls (`xmlrpc_enabled` and/or server blocking).

3. Deprecated/invalid constants in runbook examples.
- `FORCE_SSL_LOGIN` is deprecated.
- `DISALLOW_PLUGIN_EDITING` is not a valid core constant.
- `DISALLOW_PLUGIN_ACTIVATION` is not a valid core constant.

4. Cookie constants/hooks confusion in runbook examples.
- `SECURE_LOGGED_IN_COOKIE` appears as a constant but is not one.
- `SECURE_AUTH_COOKIE` / `LOGGED_IN_COOKIE` are cookie-name constants, not boolean toggles.

5. Deprecated header guidance remains.
- `X-XSS-Protection` is still recommended in runbook header snippets.

### 2) Major Cross-Document Misalignments
1. Table prefix strategy is inconsistent.
- Benchmark/hardening recommend non-default prefix as a hardening control.
- Runbook template uses default `$table_prefix = 'wp_'` in recommended config.

2. File ownership/permission model is inconsistent.
- Benchmark/hardening trend toward non-web-server owner + tighter perms.
- Runbook prescribes `www-data:www-data` + 755/644 style across recovery and permission scripts.

3. REST API guidance conflicts.
- Benchmark/hardening include broad unauthenticated API restrictions.
- Style guide language is narrower (auth for sensitive endpoints).

4. SSH port posture conflicts.
- Benchmark/hardening frame non-standard SSH port as near-baseline.
- Runbook marks it optional.

### 3) Questionable Judgments (reword, not necessarily remove)
1. FTPS language is too absolute.
- Current wording frames FTPS disablement as mandatory.
- Should be reframed with context and tradeoffs.

2. WP-Cron replacement framed too strongly as security baseline.
- Better categorized as reliability/performance control with secondary security implications.

3. Security-through-obscurity controls overemphasized.
- Version/readme suppression should be framed as low-value noise reduction, not a primary security control.

4. `wp-config.php` relocation guidance needs caution language.
- Include the WordPress warning that incorrect placement/misconfiguration can backfire.

### 4) Useful Operational Hygiene Improvements
1. Replace legacy backticks in shell snippets with `$(...)`.
2. Normalize runtime path guidance (`/run` vs `/var/run`) and explain compatibility.
3. Mark versioned PHP-FPM socket paths as environment placeholders.
4. Modernize WAF note for Nginx deployments (while preserving WordPress-centric guidance).

## Consolidated Revision Plan

### Phase A (P0): Correctness Sweep
1. Remove invalid/deprecated symbols from all docs.
- Remove: `FORCE_SSL_LOGIN`, `DISALLOW_PLUGIN_EDITING`, `DISALLOW_PLUGIN_ACTIVATION`, `SECURE_LOGGED_IN_COOKIE`.
- Remove all usage of `define('XMLRPC_REQUEST', false)` as hardening guidance.

2. Correct WordPress cryptography hook terminology.
- Replace "`wp_hash_password` filter" phrasing with correct algorithm-filter wording.

3. Fix cookie guidance semantics.
- Replace boolean cookie-constant examples with documented cookie/security behavior.

4. Remove `X-XSS-Protection` from recommended header sets.

### Phase B (P1): Policy Harmonization Across Four Docs
1. Table prefix policy.
- Reclassify to optional/legacy-obfuscation control; avoid presenting as core hardening baseline.
- Ensure runbook sample and benchmark/hardening narrative align.

2. File ownership and permission policy.
- Define one canonical baseline model and one explicit alternate model by environment.
- Ensure runbook recovery scripts, appendices, and benchmark controls all match the same decision matrix.

3. REST API policy.
- Shift from blanket unauthenticated-blocking guidance to endpoint-specific hardening.
- Keep user-enumeration mitigation and sensitive endpoint controls explicit.

4. File modification policy.
- Baseline: `DISALLOW_FILE_EDIT`.
- Optional hardened profile: `DISALLOW_FILE_MODS` with explicit update/deployment prerequisites.

5. SSH guidance.
- Keep key-only auth as baseline.
- Reframe non-standard port as optional anti-noise measure, not core security requirement.

6. WP-Cron guidance.
- Reclassify as reliability/performance primary control with security side benefits.

### Phase C (P1): Context and Risk Framing
1. Add `wp-config.php` relocation caution language in benchmark and hardening guide.
2. Reframe obscurity controls in benchmark + style guide as defense-in-depth only.
3. Clarify `WP_AUTO_UPDATE_CORE` narrative:
- Omitting constant still allows default minor updates.
- Explicit `'minor'` is optional explicitness.

### Phase D (P2): Reusability and Prevention of Regression
1. Add shared appendix to technical docs: "Deprecated/Invalid Constants and Misused Symbols".
2. Add shared cross-doc control matrix:
- `Baseline`
- `Optional Hardened`
- `Environment-Specific`

3. Add CI/grep guardrails to catch banned patterns:
- `FORCE_SSL_LOGIN`
- `DISALLOW_PLUGIN_EDITING`
- `DISALLOW_PLUGIN_ACTIVATION`
- `SECURE_LOGGED_IN_COOKIE`
- `define('XMLRPC_REQUEST', false)`
- incorrect "`wp_hash_password` filter" phrasing

## File-Level Execution Order (when implementation starts)
1. WP-Operations-Runbook.md (largest source of objective code/sample errors).
2. WordPress-Security-Benchmark.md (control taxonomy and baseline assertions).
3. WordPress-Security-Hardening-Guide.md (high-level alignment with benchmark).
4. WP-Security-Style-Guide.md (terminology and framing alignment).

## Acceptance Criteria
1. No unsupported/deprecated constants remain in any code sample.
2. No hardening examples contradict WordPress core semantics.
3. Same control has the same baseline/optional classification across all four docs.
4. REST/API/XML-RPC recommendations are internally consistent and WordPress-doc aligned.
5. Every major recommendation references WordPress developer docs or another primary source.

## Authoritative Sources
- https://developer.wordpress.org/
- https://developer.wordpress.org/advanced-administration/security/hardening/
- https://developer.wordpress.org/advanced-administration/security/hardening/file-permissions/
- https://developer.wordpress.org/advanced-administration/security/hardening/disable-file-editing/
- https://developer.wordpress.org/advanced-administration/security/hardening/security-through-obscurity/
- https://developer.wordpress.org/rest-api/using-the-rest-api/authentication/
- https://developer.wordpress.org/reference/functions/wp_hash_password/
- https://developer.wordpress.org/reference/hooks/xmlrpc_enabled/
- https://developer.wordpress.org/reference/functions/force_ssl_login/
- https://developer.wordpress.org/reference/functions/wp_cookie_constants/
- https://developer.wordpress.org/reference/hooks/secure_logged_in_cookie/
- https://github.com/WordPress/WordPress/blob/master/xmlrpc.php
- https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-XSS-Protection

# WordPress Security Documents Revision Plan (No Implementation)

Date: 2026-03-02

## Scope
This plan compares and fact-checks these four revised Markdown documents:
1. /Users/danknauss/Documents/GitHub/wp-security-style-guide/WP-Security-Style-Guide.md
2. /Users/danknauss/Documents/GitHub/wp-security-benchmark/WordPress-Security-Benchmark.md
3. /Users/danknauss/Documents/GitHub/wordpress-runbook-template/WP-Operations-Runbook.md
4. /Users/danknauss/Documents/GitHub/wp-security-hardening-guide/WordPress-Security-Hardening-Guide.md

No source documents are changed by this plan.

## Authoritative Baseline
Primary authority for deviations: https://developer.wordpress.org/
Supporting primary references are listed in "Source References".

## Findings

### A. Significant Misalignments Between the Four Documents

1. Table-prefix guidance is inconsistent across docs.
- Benchmark and Hardening Guide recommend non-default prefix as a control.
  - Benchmark: 3.3 at /Users/danknauss/Documents/GitHub/wp-security-benchmark/WordPress-Security-Benchmark.md:625-653
  - Hardening Guide: /Users/danknauss/Documents/GitHub/wp-security-hardening-guide/WordPress-Security-Hardening-Guide.md:225
- Runbook template uses default `wp_` prefix in the "recommended" config.
  - /Users/danknauss/Documents/GitHub/wordpress-runbook-template/WP-Operations-Runbook.md:2742
- WordPress hardening docs state changing prefix offers little real security improvement.

2. File ownership and permission model conflicts.
- Benchmark/Hardening: prefer non-web-server ownership and tighter perms.
  - Benchmark: /Users/danknauss/Documents/GitHub/wp-security-benchmark/WordPress-Security-Benchmark.md:1361-1409
  - Hardening Guide: /Users/danknauss/Documents/GitHub/wp-security-hardening-guide/WordPress-Security-Hardening-Guide.md:187-189
- Runbook: standardizes ownership to `www-data:www-data` with 755/644.
  - /Users/danknauss/Documents/GitHub/wordpress-runbook-template/WP-Operations-Runbook.md:2230-2235
  - /Users/danknauss/Documents/GitHub/wordpress-runbook-template/WP-Operations-Runbook.md:2476-2515

3. SSH port stance conflicts.
- Benchmark/Hardening imply non-standard SSH port as required/default hardening.
  - Benchmark: /Users/danknauss/Documents/GitHub/wp-security-benchmark/WordPress-Security-Benchmark.md:2113-2117
  - Hardening Guide: /Users/danknauss/Documents/GitHub/wp-security-hardening-guide/WordPress-Security-Hardening-Guide.md:151
- Runbook marks non-standard port as optional.
  - /Users/danknauss/Documents/GitHub/wordpress-runbook-template/WP-Operations-Runbook.md:480-481

4. REST API policy is internally inconsistent.
- Benchmark and Hardening push broad unauthenticated REST restrictions.
  - Benchmark 5.6: /Users/danknauss/Documents/GitHub/wp-security-benchmark/WordPress-Security-Benchmark.md:1220-1254
  - Hardening Guide: /Users/danknauss/Documents/GitHub/wp-security-hardening-guide/WordPress-Security-Hardening-Guide.md:219
- Style Guide language is narrower: sensitive endpoints require auth.
  - /Users/danknauss/Documents/GitHub/wp-security-style-guide/WP-Security-Style-Guide.md:505

### B. Objective Errors (Including Code Samples)

1. Wrong hook name for Argon2 guidance appears in three docs.
- Uses "`wp_hash_password` core filter" wording:
  - Style Guide: /Users/danknauss/Documents/GitHub/wp-security-style-guide/WP-Security-Style-Guide.md:363
  - Benchmark: /Users/danknauss/Documents/GitHub/wp-security-benchmark/WordPress-Security-Benchmark.md:1278
  - Hardening Guide: /Users/danknauss/Documents/GitHub/wp-security-hardening-guide/WordPress-Security-Hardening-Guide.md:78,291
- WordPress code reference shows the algorithm filter is `wp_hash_password_algorithm`.

2. `XMLRPC_REQUEST` is incorrectly used as a configuration toggle.
- Runbook uses `define('XMLRPC_REQUEST', false);` as disable guidance.
  - /Users/danknauss/Documents/GitHub/wordpress-runbook-template/WP-Operations-Runbook.md:593
  - /Users/danknauss/Documents/GitHub/wordpress-runbook-template/WP-Operations-Runbook.md:2610
  - /Users/danknauss/Documents/GitHub/wordpress-runbook-template/WP-Operations-Runbook.md:2755
- In core, `xmlrpc.php` defines `XMLRPC_REQUEST` true for XML-RPC request context; this is not a hardening constant.
- Correct control points: `xmlrpc_enabled` hook and/or server-level blocking.

3. Deprecated constant still used.
- Runbook template sets `FORCE_SSL_LOGIN`.
  - /Users/danknauss/Documents/GitHub/wordpress-runbook-template/WP-Operations-Runbook.md:2614
  - /Users/danknauss/Documents/GitHub/wordpress-runbook-template/WP-Operations-Runbook.md:2754
- `force_ssl_login()` is deprecated in WordPress; `FORCE_SSL_ADMIN` is the supported control.

4. Unsupported/non-core constants used as if valid controls.
- `DISALLOW_PLUGIN_EDITING` and `DISALLOW_PLUGIN_ACTIVATION` in runbook.
  - /Users/danknauss/Documents/GitHub/wordpress-runbook-template/WP-Operations-Runbook.md:2604,2607
- These are not documented WordPress core hardening constants and create false assurance.

5. Cookie constants misused in runbook sample.
- Runbook sets boolean values for cookie-name constants and defines unknown `SECURE_LOGGED_IN_COOKIE`.
  - /Users/danknauss/Documents/GitHub/wordpress-runbook-template/WP-Operations-Runbook.md:2617-2619
- WordPress defines `SECURE_AUTH_COOKIE` and `LOGGED_IN_COOKIE` as string cookie names, and `secure_logged_in_cookie` is a hook, not a constant.

### C. Source-Backed Deviations from WordPress Developer Guidance

1. Table prefix as a hardening requirement is a deviation.
- WordPress hardening docs: changing default table prefix does little to improve security.
- Benchmark and Hardening Guide currently present non-default prefix as a recommended control.

2. Broad REST API authentication lock-down is a deviation from default API model.
- WordPress REST auth docs: public information endpoints can be unauthenticated; create/update require authentication.
- Benchmark 5.6 and runbook snippets lean toward global auth gating.

3. `DISALLOW_FILE_MODS` as baseline control is stricter than WordPress recommended baseline.
- WordPress docs recommend `DISALLOW_FILE_EDIT`; they warn `DISALLOW_FILE_MODS` can prevent updates and plugin/theme auto-updates depending on config.
- Benchmark and Hardening Guide still promote `DISALLOW_FILE_MODS` as primary stance.

### D. Questionable Judgments (Not Strictly Objective Errors)

1. Declaring FTPS must be disabled due channel-binding weaknesses is overly absolute.
- Benchmark 12.2 asserts mandatory disablement of FTPS.
- Better framing: prefer SFTP/SCP, but document FTPS tradeoffs and environments.

2. Using non-standard SSH port as near-baseline is low-value hardening and operationally brittle.
- Better framed as optional noise-reduction, not core security control.

3. Runbook default header set still includes deprecated `X-XSS-Protection`.
- /Users/danknauss/Documents/GitHub/wordpress-runbook-template/WP-Operations-Runbook.md:558

## Recommended Revision Plan (No Changes Applied)

### Phase 1 - Correct objective errors first
1. Replace all Argon2 hook wording from `wp_hash_password` to `wp_hash_password_algorithm`.
2. Remove all `XMLRPC_REQUEST` hardening guidance; replace with `xmlrpc_enabled` guidance and server block examples.
3. Remove `FORCE_SSL_LOGIN` everywhere.
4. Remove unsupported constants `DISALLOW_PLUGIN_EDITING` and `DISALLOW_PLUGIN_ACTIVATION`.
5. Replace invalid cookie constant examples with documented cookie/security behavior.
6. Remove deprecated `X-XSS-Protection` header recommendation.

### Phase 2 - Reconcile cross-document policy conflicts
1. Pick a single table-prefix position across all docs that matches WordPress guidance.
2. Pick one canonical file ownership model and present the alternative as environment-specific.
3. Normalize SSH non-standard port language to optional.
4. Reframe REST API control from blanket auth-gating to endpoint-specific hardening.
5. Clarify `DISALLOW_FILE_EDIT` baseline vs `DISALLOW_FILE_MODS` optional lockdown profile.

### Phase 3 - Add consistency guardrails
1. Add a "Deprecated/Invalid constants" appendix in all technical docs (especially runbook).
2. Add a cross-doc control matrix mapping each control to:
- Baseline
- Optional (high-friction)
- Environment-dependent
3. Add lint checks (or CI grep checks) for banned patterns:
- `FORCE_SSL_LOGIN`
- `DISALLOW_PLUGIN_EDITING`
- `DISALLOW_PLUGIN_ACTIVATION`
- `SECURE_LOGGED_IN_COOKIE`
- `define('XMLRPC_REQUEST', false)`

## Acceptance Criteria
1. No unsupported/deprecated constants remain in examples.
2. No code samples contradict WordPress core semantics.
3. Security control recommendations are consistent across all four docs.
4. Every hardening recommendation has at least one cited source, with WordPress developer docs as primary.
5. Changes remain documentation-only (no operational or product implementation in this plan phase).

## Source References
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

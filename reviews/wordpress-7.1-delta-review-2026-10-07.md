# WordPress 7.1 Security Delta Review — 2026-10-07

Scope: changes between WordPress 7.0 and 7.1.3 that affect the four canonical security documents. Sources are the official release posts, the 7.1 Field Guide, and the linked dev notes, fetched on 2026-10-07. This review was written from published sources. The Abilities API items were afterwards verified against WordPress 7.1.3 core code and a test site; see "Code verification" below. Part of [round 2026-10-07](rounds/2026-10-07/).

## Current releases

| Release | Date | Type |
|---|---|---|
| 7.0 "Armstrong" | 2026-05-20 | Major |
| 7.0.1 – 7.0.4 | 2026-07-09 to 2026-08-12 | Maintenance |
| 7.1 "Mary Lou" | 2026-08-19 | Major |
| 7.1.1 | 2026-09-17 | Maintenance and security (11 security fixes) |
| 7.1.2 | 2026-09-22 | Maintenance |
| 7.1.3 | 2026-10-06 | Maintenance and security (7 security fixes) — **current** |
| 7.2 | Beta 2026-10-20, RC1 2026-11-17, release **2026-12-08** | Scheduled; includes a new default theme |

Support policy, restated in both 7.1.x security posts: only the most recent version is actively supported; security fixes are backported as a courtesy to eligible branches, currently through 4.7. The WordPress.org version API also offers 7.0.7 on the 7.0 branch. Recommended environment is unchanged: PHP 8.3 or greater, MySQL 8.0 or MariaDB 10.11 or greater. The 7.2 schedule page announces no requirement changes.

Sources: [releases](https://wordpress.org/news/category/releases/), [7.1](https://wordpress.org/news/2026/08/mary-lou/), [7.1.1](https://wordpress.org/news/2026/09/wordpress-7-1-1-maintenance-and-security-release/), [7.1.3](https://wordpress.org/news/2026/10/wordpress-7-1-3-maintenance-and-security-release/), [7.2 schedule](https://make.wordpress.org/core/7-2/), [requirements](https://wordpress.org/about/requirements/), [7.1 Field Guide](https://make.wordpress.org/core/2026/08/05/wordpress-7-1-field-guide/).

## Security-relevant changes in 7.1

### 1. Abilities API: lifecycle filters can bypass or override authorization

[Dev note](https://make.wordpress.org/core/2026/07/29/new-execution-lifecycle-filters-for-the-abilities-api-in-wordpress-7-1/). Execution order in 7.1: `wp_pre_execute_ability` → input normalization (`wp_ability_normalize_input`) → input validation → permission check (`permission_callback`, then `wp_ability_permission_result`) → `wp_before_execute_ability` → execute callback (`wp_ability_execute_result`) → output validation → `wp_after_execute_ability`.

- `wp_pre_execute_ability` can return a result before validation and the permission check run.
- `wp_ability_permission_result` can turn a denial into an allow. Non-boolean returns are treated as denial.
- A new `wp_ability_invoked` action fires first, for every call, with raw unvalidated input ([improvements note](https://make.wordpress.org/core/2026/07/31/abilities-api-improvements-in-wordpress-7-1/)).

Any active plugin or theme can hook these. **Document impact:** the Hardening Guide and glossary described the Abilities API as an authorization boundary without this caveat; the Benchmark had no control for it.

### 2. Abilities API: `public` exposure flag

[Dev note](https://make.wordpress.org/core/2026/08/04/a-unified-public-exposure-flag-for-abilities-in-wordpress-7-1/). `meta.public` (default `false`) is a shared exposure default; `show_in_rest` still takes precedence for REST. The note states that exposure flags must not be treated as a security boundary and do not replace `permission_callback`. `core/get-user-info` is now exposed through REST to logged-in users. **Document impact:** same passages as item 1.

### 3. Client-side media processing and Content Security Policy

[Dev note](https://make.wordpress.org/core/2026/07/22/client-side-media-processing-in-wordpress-7-1/). The block editor processes images in a Web Worker (WebAssembly) and sends `Document-Isolation-Policy: isolate-and-credentialless` on editor screens. A site CSP must allow `worker-src 'self' blob:` or the feature falls back to server-side processing. The server still validates every uploaded file. The feature can be disabled with the `wp_client_side_media_processing_enabled` filter. **Document impact:** the CSP examples in the Benchmark (§1.2) and Runbook have no `worker-src`, so they block the worker and trigger the fallback. That is safe; the documents now say so.

Not established from the dev note: the capability required by the new `/wp/v2/media/{id}/sideload` endpoint, and the details behind its statement that the MIME-type check is bypassed for client-decoded AVIF uploads. Both would need a code read before the documents say anything about them.

### 4. Security releases since 7.1

Eighteen security fixes in seven weeks. The ones that bear on the documents' guidance:

- 7.1.1: stored XSS through `wpautop()` reachable by unauthenticated visitors (subject to comment approval); path traversal in the REST templates controller; XML-RPC publishing `customize_changeset` posts that bypass `edit_css` checks; arbitrary post overwrite by Contributors.
- 7.1.3: stored XSS on the Comments screen through pending comments; unauthenticated disclosure of comments on private and unpublished posts; second-order SQL injection in WXR export; denial of service in `WP_Http::make_absolute_url()`.

**Document impact:** supports the existing guidance on automatic minor updates and on blocking XML-RPC when unused. The Hardening Guide now cites the two releases as a current example.

### 5. Checked and unchanged

The Field Guide lists no changes to password hashing, sessions and cookies, nonces, application passwords, the Connectors API, KSES, automatic updates, autoloaded options, or PHP and MySQL requirements. Other items (XML-RPC multisite argument fix, signup URL scheme fix, jQuery UI 1.14.2, SVG Icon API, `notify_post_author` filter) do not affect the documents' guidance.

## Code verification (Abilities API, 2026-10-07)

Checked by reading `wp-includes/abilities-api/class-wp-ability.php`, `wp-includes/abilities.php`, and the three `class-wp-rest-abilities-v1-*-controller.php` files in WordPress 7.1.3, and by sending requests on a throwaway local 7.1.3 site with four test abilities (`manage_options` permission callback; each combination of `public` and `show_in_rest`) as an anonymous visitor, a Subscriber, and an Administrator.

**Confirmed**

- Order inside `WP_Ability::execute()`: `wp_ability_invoked` → `wp_pre_execute_ability` → normalize → validate → `check_permissions()` (`permission_callback`, then `wp_ability_permission_result`) → `wp_before_execute_ability` → execute callback and `wp_ability_execute_result` → validate output → `wp_after_execute_ability`.
- `show_in_rest` resolves as `show_in_rest ?? public ?? false`; `public` defaults to `false`.
- A REST-exposed ability with a restrictive callback is listed to a Subscriber, who gets 403 on run. A non-exposed ability returns 404 on the REST get and run routes for every user, including Administrators, but runs from PHP.
- `wp_ability_permission_result` returning `true` overrides the denial everywhere. With it active, an **anonymous** request ran the REST-exposed test ability (HTTP 200).
- Core registers no callbacks on the lifecycle hooks. `permission_callback` is required at registration.
- Core abilities: all three are `public` and REST-exposed. `core/get-site-info` and `core/get-environment-info` require `manage_options` (Subscriber: 403). `core/get-user-info` requires only a logged-in user and returned the Subscriber's own `id`, `display_name`, `user_nicename`, `user_login`, `roles`, `locale`, `first_name`, `last_name`, `nickname`, `description`, `user_url`.

**Corrected — the dev notes did not say this**

- **`wp_pre_execute_ability` does not bypass the permission check over REST.** The REST run route's own permission callback normalizes and validates input and calls `check_permissions()` before `execute()` is called, so a denied request never reaches the filter. With the filter returning a result, anonymous and Subscriber REST runs still returned 401 and 403. The bypass applies only to code calling `execute()` directly from PHP.
- **`wp_ability_invoked` does not fire for requests the REST endpoint rejects**, for the same reason, despite its docblock saying it fires "for every call regardless of outcome". It is not a complete log of denied attempts.
- **The REST list and get routes require `current_user_can( 'read' )`.** An anonymous visitor cannot list abilities (401) but can attempt to run one by name. On a successful REST run the permission check and its filter execute twice, once in the REST permission callback and once in `execute()`.

**WP-CLI and MCP Adapter (tested the same day on a second throwaway site)**

Neither is part of core. WP-CLI: the `wp-cli/ability-command` package at commit `c6112cc` (2026-10-07), loaded with `--require`; it is not bundled in WP-CLI 2.12.0. MCP Adapter: the official 0.7.0 release (2026-10-02), driven over HTTP with JSON-RPC and application passwords. Two more test abilities covered `meta.mcp.public`.

| | Core REST | MCP Adapter 0.7.0 | `wp ability` |
|---|---|---|---|
| Anonymous access | Cannot list (401); can attempt a run | None: the transport requires a logged-in user with `read` (401) | Runs as no user unless `--user` is given |
| Exposure rule | `show_in_rest ?? public ?? false` | `meta.mcp.public` if set, else `public`; `show_in_rest` ignored | None: lists and runs every registered ability |
| Hidden ability, Administrator | 404 | "not exposed via MCP" | Runs |
| Exposed ability, Subscriber, `manage_options` callback | Listed; run 403 | Listed by discover; run "Permission denied" | Run denied |
| `wp_pre_execute_ability` returns a result | No bypass (401/403) | No bypass ("Permission denied") | **Bypass**: result returned with no user and as Subscriber |
| `wp_ability_permission_result` returns `true` | Anonymous run succeeds (200) | Subscriber run succeeds; anonymous still blocked at the transport | Run succeeds with no user |
| `wp_ability_invoked` on a denied attempt | Not fired | Not fired | Fired |

- The dev note said the MCP Adapter would honour `public` "in its next release". 0.7.0 already does.
- `public => true` with `show_in_rest => false` is hidden from REST but exposed to MCP. `show_in_rest => true` without `public` is exposed to REST but not MCP.
- The dev note's statement that WP-CLI's listing ignores exposure is confirmed. The command also runs hidden abilities for a user who passes the permission check.
- The MCP Adapter's three own abilities (`discover-abilities`, `get-ability-info`, `execute-ability`) are not `public` and are not exposed on the core REST abilities routes.

The Benchmark (control 11.4) and the Hardening Guide were corrected to match.

## Changes made to the canonical documents

| Document | Change |
|---|---|
| Benchmark | Target Technology names 7.1.3 as current, states the support policy, and notes 7.2 is not covered. New Level 2 control **11.4** (Abilities API authorization overrides). §1.2 CSP note on `worker-src` |
| Hardening Guide | Scope statement covers 7.1 and names the 7.2 date. §3.3 cites the 7.1.x security releases. §14 Abilities API paragraph covers the `public` flag and lifecycle filters. CSP note |
| Runbook | Version placeholder example is 7.1. CSP comment on `worker-src` |
| Style Guide | Abilities API and AI Client glossary entries updated |

## For the 7.2 cycle

7.2 Beta is due 2026-10-20 and the release on 2026-12-08. Repeat this review against the 7.2 Field Guide when it is published, and re-check the two items left unestablished in section 3.

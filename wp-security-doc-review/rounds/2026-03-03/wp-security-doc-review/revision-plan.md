# WordPress Security Documentation — Revision Plan

**Created:** March 2026
**Status:** Ready for execution
**Scope:** Four Markdown source documents across four repositories

---

## Document Roles

Each document has a distinct purpose. Revisions must respect these boundaries.

| Document | Repo | Role | Implication for revisions |
|---|---|---|---|
| WP-Operations-Runbook.md | wordpress-runbook-template | **Operational** — "how to do it" | Every removal needs a working replacement snippet. People copy these code blocks. |
| WordPress-Security-Benchmark.md | wp-security-benchmark | **Audit checklist** — "what to verify" | Controls need audit commands and clear profile levels. Reclassifications must preserve control IDs. |
| WordPress-Security-Hardening-Guide.md | wp-security-hardening-guide | **Advisory** — "what to implement" | Guidance must cite rationale and link to authoritative sources. |
| WP-Security-Style-Guide.md | wp-security-style-guide | **Editorial** — "how to write about it" | Fix only factual/terminological errors. No policy matrix. No hardening controls. |

---

## Authority Hierarchy

Corrections follow this precedence:

1. **WordPress Advanced Administration Handbook** (developer.wordpress.org/advanced-administration/security/) — primary authority for WordPress-specific guidance
2. **WordPress Code Reference and core source** (developer.wordpress.org/reference/, GitHub WordPress/WordPress) — primary authority for constants, hooks, filters, and function behavior
3. **Supplemental standards** (MDN, OWASP, CIS) — authority only for non-WordPress-specific topics (HTTP headers, general crypto, network hardening)

Any recommendation that deviates from the handbook must be labeled **Conditional** or **Enterprise Optional** with stated rationale and impact.

---

## Control Taxonomy (Benchmark and Hardening Guide Only)

These categories apply to the benchmark and hardening guide. They do **not** apply to the style guide or runbook.

| Tier | Meaning | Example |
|---|---|---|
| **Baseline** | Handbook-aligned defaults every site should meet | `DISALLOW_FILE_EDIT` = true, strong passwords, HTTPS everywhere |
| **Conditional** | Requires specific infrastructure or operational maturity; state prerequisites | `DISALLOW_FILE_MODS` = true (requires CI/CD or WP-CLI update pipeline) |
| **Enterprise Optional** | Higher-friction controls with clear tradeoffs; document the cost | Non-web-server file ownership via suEXEC/php-fpm pool isolation |

---

## Verified Findings — Objective Errors

These are factually wrong and must be corrected in every document where they appear.

### F1. `XMLRPC_REQUEST` presented as a disable switch

**What's wrong:** `define('XMLRPC_REQUEST', false)` appears in 3 places in the runbook. `XMLRPC_REQUEST` is a request-context constant set internally by WordPress when `xmlrpc.php` is loaded. Defining it in `wp-config.php` does not disable XML-RPC.

**Locations:**
- WP-Operations-Runbook.md: lines 570, 2587, 2732

**Fix:** Remove all three instances. Replace with two supported methods:

```php
// Method 1: Filter (in a must-use plugin or theme functions.php)
add_filter( 'xmlrpc_enabled', '__return_false' );
```

```nginx
# Method 2: Server block (Nginx) — recommended for complete mitigation
location = /xmlrpc.php {
    deny all;
    return 403;
}
```

```apache
# Method 2: Server block (Apache)
<Files xmlrpc.php>
    Require all denied
</Files>
```

**Authority:** [xmlrpc_enabled filter](https://developer.wordpress.org/reference/hooks/xmlrpc_enabled/), [WordPress core xmlrpc.php](https://github.com/WordPress/WordPress/blob/master/xmlrpc.php)

---

### F2. `FORCE_SSL_LOGIN` (deprecated)

**What's wrong:** `define('FORCE_SSL_LOGIN', true)` appears twice. This function/constant was deprecated in WordPress 4.4. `FORCE_SSL_ADMIN` covers both admin and login when set to `true`.

**Locations:**
- WP-Operations-Runbook.md: lines 2591, 2731

**Fix:** Remove both instances. Ensure `FORCE_SSL_ADMIN` is present (it already is in the runbook). Add a note:

```php
// FORCE_SSL_LOGIN was deprecated in WordPress 4.4.
// FORCE_SSL_ADMIN covers both admin and login pages.
define( 'FORCE_SSL_ADMIN', true );
```

**Authority:** [force_ssl_login() deprecated](https://developer.wordpress.org/reference/functions/force_ssl_login/)

---

### F3. Nonexistent constants `DISALLOW_PLUGIN_EDITING` and `DISALLOW_PLUGIN_ACTIVATION`

**What's wrong:** Neither constant exists in WordPress core. `DISALLOW_FILE_EDIT` disables the theme/plugin editor. There is no constant for preventing plugin activation.

**Locations:**
- WP-Operations-Runbook.md: lines 2581, 2584

**Fix:** Remove both. The surrounding context already includes `DISALLOW_FILE_EDIT`. If the intent was to prevent plugin installation, the correct constant is `DISALLOW_FILE_MODS` (which is also already present).

**Authority:** [Disable File Editing](https://developer.wordpress.org/advanced-administration/security/hardening/disable-file-editing/), [wp-includes/default-constants.php](https://developer.wordpress.org/reference/files/wp-includes/default-constants.php/)

---

### F4. Cookie constants assigned boolean values

**What's wrong:** `SECURE_AUTH_COOKIE`, `LOGGED_IN_COOKIE`, and `SECURE_LOGGED_IN_COOKIE` are set to `true`. These constants define cookie **names** (strings), not security flags. Assigning booleans is a no-op at best and could cause authentication failures.

**Locations:**
- WP-Operations-Runbook.md: lines 2594–2596

**Fix:** Remove all three lines. Cookie names should not be customized without specific reason. If the goal was to enforce HTTPS for auth cookies, `FORCE_SSL_ADMIN` already handles that. Add a comment explaining this:

```php
// Cookie security is enforced by FORCE_SSL_ADMIN (above) and the
// 'secure' flag WordPress sets automatically when is_ssl() is true.
// Do NOT set SECURE_AUTH_COOKIE, LOGGED_IN_COOKIE, etc. to boolean
// values — they are cookie name constants, not security switches.
```

**Note:** `SECURE_LOGGED_IN_COOKIE` does not exist in WordPress core. Only `LOGGED_IN_COOKIE` and `SECURE_AUTH_COOKIE` are defined in `default-constants.php`.

**Authority:** [wp-includes/default-constants.php](https://developer.wordpress.org/reference/files/wp-includes/default-constants.php/)

---

### F5. `X-XSS-Protection` header still recommended

**What's wrong:** The runbook includes `add_header X-XSS-Protection "1; mode=block" always;` in its nginx security headers. This header is deprecated in all modern browsers and can introduce vulnerabilities in older ones. MDN explicitly recommends against using it.

**Locations:**
- WP-Operations-Runbook.md: line 535

**Fix:** Remove the header. The correct protection is `Content-Security-Policy`, which the runbook already recommends. Add a comment:

```nginx
# X-XSS-Protection is deprecated and removed from modern browsers.
# Use Content-Security-Policy instead (configured below).
```

**Authority:** [MDN: X-XSS-Protection](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-XSS-Protection)

---

### F6. `wp_hash_password` called a "core filter" (Argon2id guidance)

**What's wrong:** All four documents refer to "`wp_hash_password` core filter" for enabling Argon2id. `wp_hash_password()` is a **function**, not a filter. The correct filter for algorithm selection is `wp_hash_password_algorithm` (introduced in WordPress 6.8).

**Locations:**
- WP-Security-Style-Guide.md: line 362
- WordPress-Security-Benchmark.md: line 1108
- WordPress-Security-Hardening-Guide.md: lines 101, 314

**Fix:** In all four documents, replace `wp_hash_password` core filter with:

> `wp_hash_password_algorithm` filter

Example corrected text:

> Argon2id can be enabled via the `wp_hash_password_algorithm` filter on servers with the required PHP extensions (sodium or argon2).

**Authority:** [wp_hash_password() code reference](https://developer.wordpress.org/reference/functions/wp_hash_password/) — documents both `wp_hash_password_algorithm` and `wp_hash_password_options` filters.

---

## Verified Findings — Cross-Document Misalignments

These are not factual errors but policy conflicts between documents. Resolution requires picking a position consistent with the authority hierarchy.

### M1. Table prefix: hard requirement vs. default `wp_`

**Conflict:**
- Benchmark (Section 3.3): Level 1 control requiring non-default prefix
- Hardening guide (Section 7.3): recommends non-default prefix
- Runbook (line 2719): uses `$table_prefix = 'wp_'`

**Resolution:** Downgrade to **Conditional** (not Baseline). The WordPress Handbook does not recommend changing the table prefix. The "Security Through Obscurity" handbook page discusses this measure without endorsing it. Automated SQL injection tools that assume `wp_` are a marginal threat compared to properly parameterized queries (which WordPress core already uses via `$wpdb->prepare()`).

**Changes:**
- Benchmark: Reclassify Section 3.3 from Level 1 to Level 2. Reword rationale to acknowledge this is a defense-in-depth measure with limited practical value when core query parameterization is intact.
- Hardening guide: Reword to "may be used as a minor defense-in-depth measure" rather than a recommendation.
- Runbook: Keep `$table_prefix = 'wp_'` as default (this is correct for a template). Add a note that non-default prefixes are an optional hardening step.

**Authority:** [Security Through Obscurity](https://developer.wordpress.org/advanced-administration/security/hardening/security-through-obscurity/)

---

### M2. File ownership: `www-data` vs. non-web-server user

**Conflict:**
- Benchmark (Section 6.1) and Hardening guide (Section 6.4): favor non-web-server ownership
- Runbook (lines 2207, 2375): enforces `www-data:www-data`

**Resolution:** Both models are valid in different contexts. Present both with clear criteria for when to use each.

| Model | When appropriate | Prerequisite |
|---|---|---|
| `www-data:www-data` ownership | Shared hosting, simple VPS, managed WordPress hosts | `DISALLOW_FILE_MODS` = true (prevents web process from writing to codebase) |
| Separate system user ownership | Dedicated servers, multi-tenant, compliance environments | suEXEC or per-site php-fpm pool, deployment pipeline for updates |

**Changes:**
- Benchmark: Keep non-web-server ownership as Level 2 (not Level 1). Add the prerequisite column.
- Hardening guide: Present both models with the "when to use" criteria above.
- Runbook: Keep `www-data:www-data` as default (appropriate for the template's VPS/LEMP target audience) but add a note pointing to the separate-user model for higher-security deployments.

**Authority:** [File Permissions](https://developer.wordpress.org/advanced-administration/security/hardening/file-permissions/)

---

### M3. `DISALLOW_FILE_MODS` as universal baseline

**Conflict:** The benchmark and hardening guide treat `DISALLOW_FILE_MODS` as a baseline control, but this constant blocks ALL file modifications including plugin/theme installation and updates via the admin UI.

**Observed:** The hardening guide (line 212) correctly resolves this by saying "handle these through deployment pipelines instead." The runbook does not include this caveat.

**Resolution:** Reclassify as **Conditional**. State the prerequisite explicitly.

**Changes:**
- Benchmark: Move from Level 1 to Level 2 (Conditional). Add prerequisite: "Requires a deployment pipeline (CI/CD, WP-CLI, managed host push-to-deploy) for applying updates outside the admin UI."
- Hardening guide: Already correct. No changes needed beyond verifying the pipeline caveat is present.
- Runbook: Add the pipeline caveat alongside the existing `DISALLOW_FILE_MODS` setting:

```php
// Prevents ALL file modifications via the admin UI, including updates.
// Prerequisite: You must have a deployment pipeline (CI/CD, WP-CLI,
// or managed host) for applying core, plugin, and theme updates.
define( 'DISALLOW_FILE_MODS', true );
```

---

### M4. REST API default stance

**Conflict:** The benchmark (Section 5.6) and hardening guide (Section 7.2) default to "restrict unauthenticated REST API access" with exceptions for public endpoints. WordPress core designs the REST API as public-read by default, with authentication required only for write operations and sensitive data.

**Note:** Both documents already include exceptions for public endpoints. The issue is the framing: they present restriction as the default with exceptions, rather than public access as the default with restrictions on sensitive endpoints.

**Resolution:** Invert the framing to match WordPress design intent.

**Changes:**
- Benchmark: Reword Section 5.6 to: "The WordPress REST API provides public read access by default, consistent with WordPress core design. Restrict specific endpoints that expose sensitive data (user enumeration via `/wp/v2/users`, site configuration details). Do not blanket-restrict all unauthenticated access unless the site has no public-facing content needs (e.g., a private intranet)."
- Hardening guide: Same reframe. Lead with "WordPress REST API is public-read by design" and narrow the restriction to specific endpoints.
- Runbook: Align with the endpoint-specific approach. Replace any broad `rest_authentication_errors` filter examples with targeted endpoint restrictions.

**Authority:** [REST API Authentication](https://developer.wordpress.org/rest-api/using-the-rest-api/authentication/)

---

## Verified Findings — Judgment Normalizations

These are not errors but are over-stated, deprecated, or inconsistently framed across docs.

### J1. SSH non-standard port

**Current state:** Presented as mandatory in some places, optional in others.

**Resolution:** Normalize to **Conditional**. Non-standard SSH ports reduce log noise from automated scanners but provide no real security against targeted attacks. The effective controls are key-based auth and `fail2ban`/rate limiting.

---

### J2. "Disable FTPS" absolute language

**Current state:** Some docs use absolute language ("disable FTP/FTPS") without environment caveats.

**Resolution:** Reword to: "Use SFTP or SSH-based deployment exclusively. Disable FTP and FTPS where server configuration permits. In shared hosting environments where FTPS is the only available option, enforce TLS 1.2+ with strong cipher suites."

---

### J3. Version obscurity (readme.html removal, generator tag)

**Current state:** Over-emphasized relative to handbook guidance.

**Resolution:** Downgrade to a brief mention under defense-in-depth. The handbook's "Security Through Obscurity" page explicitly cautions against relying on these measures. These tactics should not appear in Baseline or Level 1 controls.

---

## File-by-File Edit Map

### WP-Operations-Runbook.md

| Line(s) | Finding | Action |
|---|---|---|
| 535 | F5: `X-XSS-Protection` header | Remove; add comment pointing to CSP |
| 570 | F1: `XMLRPC_REQUEST` | Replace with `xmlrpc_enabled` filter + server block examples |
| 2581 | F3: `DISALLOW_PLUGIN_EDITING` | Remove line |
| 2584 | F3: `DISALLOW_PLUGIN_ACTIVATION` | Remove line |
| 2587 | F1: `XMLRPC_REQUEST` | Remove; already replaced at line 570 |
| 2591 | F2: `FORCE_SSL_LOGIN` | Remove; add deprecation note |
| 2594–2596 | F4: Cookie constants as booleans | Remove 3 lines; add explanatory comment |
| 2719 | M1: `$table_prefix` | Keep `wp_`; add note about optional non-default prefix |
| 2729+ | M3: `DISALLOW_FILE_MODS` | Add deployment pipeline prerequisite caveat |
| 2731 | F2: `FORCE_SSL_LOGIN` (second instance) | Remove |
| 2732 | F1: `XMLRPC_REQUEST` (third instance) | Remove |
| 2207, 2375 | M2: `www-data` ownership | Keep as default; add note about separate-user model |
| ~535 area | REST API section | Align with endpoint-specific restriction approach (M4) |

### WordPress-Security-Benchmark.md

| Section | Finding | Action |
|---|---|---|
| 3.3 | M1: Table prefix | Reclassify from Level 1 to Level 2; reword rationale |
| 5.6 | M4: REST API | Reframe: public-read by design, restrict specific sensitive endpoints |
| 6.1 | M2: File ownership | Reclassify from Level 1 to Level 2; add prerequisite table |
| DISALLOW_FILE_MODS control | M3 | Reclassify from Level 1 to Level 2; add pipeline prerequisite |
| 1108 | F6: Argon2 filter name | Replace `wp_hash_password` with `wp_hash_password_algorithm` |

### WordPress-Security-Hardening-Guide.md

| Section/Line | Finding | Action |
|---|---|---|
| 101 | F6: Argon2 filter name | Replace `wp_hash_password` with `wp_hash_password_algorithm` |
| 314 | F6: Argon2 filter name | Replace `wp_hash_password` with `wp_hash_password_algorithm` |
| 7.2 | M4: REST API | Reframe to public-read-by-design with targeted restrictions |
| 7.3 | M1: Table prefix | Reword to "minor defense-in-depth measure" |
| 6.4 | M2: File ownership | Present both models with "when to use" criteria |
| DISALLOW_FILE_MODS | M3 | Verify pipeline caveat is present (already correct at line 212) |

### WP-Security-Style-Guide.md

| Line | Finding | Action |
|---|---|---|
| 362 | F6: Argon2 filter name | Replace `wp_hash_password` with `wp_hash_password_algorithm` in glossary entry |

**No other changes to the style guide.** It is an editorial reference, not a controls document. The shared policy matrix does not apply here.

---

## Validation Checklist

After all edits are applied, run these grep-based checks across all four documents:

```bash
DOCS=(
  "/path/to/WP-Operations-Runbook.md"
  "/path/to/WordPress-Security-Benchmark.md"
  "/path/to/WordPress-Security-Hardening-Guide.md"
  "/path/to/WP-Security-Style-Guide.md"
)

echo "=== Must NOT appear ==="
for doc in "${DOCS[@]}"; do
  echo "--- $(basename "$doc") ---"
  grep -n "define('XMLRPC_REQUEST'" "$doc" && echo "  FAIL: XMLRPC_REQUEST" || echo "  OK: XMLRPC_REQUEST"
  grep -n "FORCE_SSL_LOGIN" "$doc" && echo "  FAIL: FORCE_SSL_LOGIN" || echo "  OK: FORCE_SSL_LOGIN"
  grep -n "DISALLOW_PLUGIN_ACTIVATION" "$doc" && echo "  FAIL: DISALLOW_PLUGIN_ACTIVATION" || echo "  OK"
  grep -n "DISALLOW_PLUGIN_EDITING" "$doc" && echo "  FAIL: DISALLOW_PLUGIN_EDITING" || echo "  OK"
  grep -n "X-XSS-Protection" "$doc" && echo "  FAIL: X-XSS-Protection" || echo "  OK: X-XSS-Protection"
  grep -n 'wp_hash_password. core filter' "$doc" && echo "  FAIL: wrong filter name" || echo "  OK: filter name"
  grep -n "SECURE_LOGGED_IN_COOKIE" "$doc" && echo "  FAIL: nonexistent constant" || echo "  OK"
done

echo ""
echo "=== Must appear (runbook) ==="
grep -n "xmlrpc_enabled" "${DOCS[0]}" && echo "  OK: xmlrpc_enabled replacement" || echo "  MISSING: xmlrpc_enabled"
grep -n "wp_hash_password_algorithm" "${DOCS[0]}" || true  # only if runbook mentions Argon2
```

### Manual Consistency Pass

- [ ] Every control that appears in more than one document uses identical terminology and the same tier classification
- [ ] Every Conditional or Enterprise Optional control states its prerequisites
- [ ] Every snippet in the runbook is copy-pasteable and uses only real WordPress constants/hooks/filters
- [ ] Every Baseline control traces to at least one authoritative citation
- [ ] REST API guidance in all docs follows the "public-read by design, restrict specific endpoints" framing
- [ ] File ownership guidance presents both models with clear "when to use" criteria

---

## Execution Notes

### Commit Strategy

The four repos have active GitHub Actions workflows that generate PDF/DOCX on every `.md` push. During the revision pass:

- **Option A (recommended):** Edit one repo at a time. Push. Wait for PDF build to succeed. Move to the next repo. This avoids race conditions and lets you verify each PDF.
- **Option B:** Batch all edits locally, push to all 4 repos in sequence, let CI handle the rest. The `concurrency` group on each repo will cancel overlapping runs automatically.

Do **not** disable the PDF workflow for the revision pass — the generated PDFs are a useful proof that the markdown parses correctly and the resulting document looks right.

### Link Audit (Future Pass)

This revision plan does not include a link audit. A follow-up pass should:
- Check all external URLs for 404s or redirects
- Verify WP code reference links point to current function/hook pages
- Confirm handbook section anchors haven't changed

### White Paper

The HTML white paper at `/Users/danknauss/Documents/GitHub/Security-White-Paper/` also references `wp_hash_password`. It is out of scope for this pass but should be updated in a follow-up.

---

## Sources

- [WordPress Security (Advanced Administration)](https://developer.wordpress.org/advanced-administration/security/)
- [Hardening WordPress](https://developer.wordpress.org/advanced-administration/security/hardening/)
- [File Permissions](https://developer.wordpress.org/advanced-administration/security/hardening/file-permissions/)
- [Disable File Editing](https://developer.wordpress.org/advanced-administration/security/hardening/disable-file-editing/)
- [Security Through Obscurity](https://developer.wordpress.org/advanced-administration/security/hardening/security-through-obscurity/)
- [Brute Force Attacks](https://developer.wordpress.org/advanced-administration/security/brute-force/)
- [REST API Authentication](https://developer.wordpress.org/rest-api/using-the-rest-api/authentication/)
- [wp_hash_password() (code reference)](https://developer.wordpress.org/reference/functions/wp_hash_password/)
- [wp-includes/default-constants.php (code reference)](https://developer.wordpress.org/reference/files/wp-includes/default-constants.php/)
- [force_ssl_login() deprecated (code reference)](https://developer.wordpress.org/reference/functions/force_ssl_login/)
- [xmlrpc_enabled filter (code reference)](https://developer.wordpress.org/reference/hooks/xmlrpc_enabled/)
- [MDN: X-XSS-Protection](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-XSS-Protection)

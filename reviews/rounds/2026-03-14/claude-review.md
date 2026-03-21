# Cross-Document Review — 2026-03-14

**Documents reviewed:**

1. WordPress Security Benchmark (`wp-security-benchmark/WordPress-Security-Benchmark.md`)
2. WordPress Security Hardening Guide (`wp-security-hardening-guide/WordPress-Security-Hardening-Guide.md`)
3. WordPress Operations Runbook (`wordpress-runbook-template/WP-Operations-Runbook.md`)
4. WP Security Style Guide (`wp-security-style-guide/WP-Security-Style-Guide.md`)

---

## Finding 1: `wp user update --user_login` does not exist

- **Document:** Benchmark
- **Location:** §5.2, line 1097
- **Finding:** The command `wp user update <user-id> --user_login=<new-username>` is invalid. WP-CLI's `wp user update` does not support changing the `user_login` field. The `user_login` column is treated as immutable by WP-CLI; WordPress core itself does not provide a supported method to rename a user login via its APIs.
- **Severity:** High
- **Recommendation:** Replace with a direct database query using WP-CLI, and note the caveats:
  ```
  wp db query "UPDATE $(wp db prefix)users SET user_login = '<new-username>' WHERE ID = <user-id>"
  ```
  Add a warning that this requires flushing caches and that the user must log in with the new username. Alternatively, recommend creating a new account and migrating content.
- **Verification:** Run `wp help user update` and confirm `--user_login` is not listed as a valid parameter. Confirmed against WP-CLI v2.11+ source.

---

## Finding 2: `php8.2-json` package does not exist

- **Document:** Runbook
- **Location:** §6.5, lines 1043 and 1081
- **Finding:** The PHP upgrade commands include `php8.2-json` in the `apt-get install` list. Since PHP 8.0, the JSON extension is always compiled in and always available. There is no separate `php8.2-json` package on Ubuntu/Debian; attempting to install it will produce a "package not found" error (or silently succeed via a virtual package on some distributions).
- **Severity:** Medium
- **Recommendation:** Remove `php8.2-json` from both `apt-get install` lines. Add `php8.2-intl` and `php8.2-zip` instead, which are commonly needed by WordPress and its plugins.
- **Verification:** Run `apt-cache show php8.2-json` on Ubuntu 22.04+ — package does not exist. See [PHP 8.0 migration guide](https://www.php.net/manual/en/migration80.other-changes.php): "The JSON extension cannot be disabled anymore."

---

## Finding 3: `--post_status=scheduled` is not a valid WordPress post status

- **Document:** Runbook
- **Location:** §9.2, lines 1877 and 1881
- **Finding:** The commands use `--post_status=scheduled`, but WordPress's internal post status for scheduled posts is `future`, not `scheduled`. Both `wp post create --post_status=scheduled` and `wp post list --post_status=scheduled` will fail or return no results.
- **Severity:** High
- **Recommendation:** Change both occurrences to `--post_status=future`:
  ```bash
  wp post create --post_type=post --post_title='Scheduled Post' \
    --post_content='Content' --post_status=future \
    --post_date='2026-02-20 09:00:00'

  wp post list --post_status=future --format=table
  ```
- **Verification:** Run `wp post-type list` and check registered statuses, or see [WordPress Post Status documentation](https://developer.wordpress.org/reference/functions/get_post_statuses/). The `future` status is documented at [developer.wordpress.org](https://developer.wordpress.org/reference/functions/wp_publish_post/).

---

## Finding 4: `wp term delete --default` flag does not exist

- **Document:** Runbook
- **Location:** §9.3, line 1918
- **Finding:** The command `wp term delete category [TERM_ID] --default=1` uses a `--default` flag that does not exist in WP-CLI's `wp term delete` command. When deleting a category, WordPress automatically reassigns posts to the default category (set in Settings > Writing); there is no WP-CLI flag to control this.
- **Severity:** Medium
- **Recommendation:** Remove the `--default=1` flag. The correct command is:
  ```bash
  wp term delete category [TERM_ID]
  ```
  Add a note: "Posts assigned to this category will be reassigned to the site's default category."
- **Verification:** Run `wp help term delete` — no `--default` parameter is listed.

---

## Finding 5: Password minimum length inconsistency (15 vs. 12 characters)

- **Document:** Benchmark and Hardening Guide
- **Location:** Benchmark §5.7, line 1307; Hardening Guide §8.3, line 319
- **Finding:** The Benchmark specifies "minimum length of 15 characters if MFA is not enabled," while the Hardening Guide specifies "at least 12 characters" without MFA qualification. These are inconsistent recommendations for the same control.
- **Severity:** High
- **Recommendation:** Align on a single recommendation. The Benchmark's conditional approach (15 without MFA) follows NIST SP 800-63B more closely. Update the Hardening Guide §8.3 to say: "Enforce strong passwords of at least 15 characters when MFA is not enabled, or at least 12 characters when MFA is active, following NIST SP 800-63B guidelines."
- **Verification:** NIST SP 800-63B §3.1.1.2 recommends minimum 15 characters for memorized secrets without a second factor.

---

## Finding 6: `JPEG_QUALITY` is not a valid WordPress constant

- **Document:** Runbook
- **Location:** Appendix B.5, line ~2929
- **Finding:** `define('JPEG_QUALITY', 82);` is documented as a WordPress constant, but WordPress does not define or recognize a `JPEG_QUALITY` constant. JPEG quality in WordPress is controlled via the `jpeg_quality` filter or the `wp_editor_set_quality` filter.
- **Severity:** Medium
- **Recommendation:** Remove the `define()` line and replace with a comment:
  ```php
  // JPEG quality: use the jpeg_quality filter in a must-use plugin:
  // add_filter( 'jpeg_quality', function() { return 82; } );
  ```
- **Verification:** Search WordPress core source for `JPEG_QUALITY` — it does not exist. The filter is `jpeg_quality` applied in `WP_Image_Editor::set_quality()`.

---

## Finding 7: WP Mail SMTP option names are incorrect

- **Document:** Runbook
- **Location:** §6.7, lines 1189–1193
- **Finding:** The WP-CLI commands `wp option update mailer`, `wp option update mailer_host`, etc. do not correspond to how the WP Mail SMTP plugin stores its settings. WP Mail SMTP stores all configuration in a single serialized option named `wp_mail_smtp`. The individual `mailer`, `mailer_host`, etc. options do not exist.
- **Severity:** Medium
- **Recommendation:** Replace the individual `wp option update` commands with a note that WP Mail SMTP configuration should be done through its admin UI or by defining constants in `wp-config.php` that the plugin reads (e.g., `WPMS_ON`, `WPMS_SMTP_HOST`, etc.). Example:
  ```php
  // In wp-config.php (consumed by WP Mail SMTP plugin):
  define( 'WPMS_ON', true );
  define( 'WPMS_SMTP_HOST', '[CUSTOMIZE: smtp.sendgrid.net]' );
  define( 'WPMS_SMTP_PORT', 587 );
  define( 'WPMS_SSL', 'tls' );
  define( 'WPMS_SMTP_AUTH', true );
  define( 'WPMS_SMTP_USER', '[CUSTOMIZE: apikey]' );
  define( 'WPMS_SMTP_PASS', '[CUSTOMIZE: password]' );
  ```
- **Verification:** Check the [WP Mail SMTP documentation](https://wpmailsmtp.com/docs/how-to-secure-smtp-settings-by-using-constants/) for correct constant names.

---

## Finding 8: `rm wp-admin/install.php` is impractical

- **Document:** Runbook
- **Location:** §5.2, line 535
- **Finding:** The hardening procedure includes `rm /home/wordpress/public_html/wp-admin/install.php`. This file is part of WordPress core and will be restored on every core update. WordPress already protects this file: after installation, it redirects to the login page (or shows "Already Installed"). Deleting it creates a maintenance burden with no security benefit.
- **Severity:** Low
- **Recommendation:** Remove this line from the hardening procedure. Instead, add a note: "WordPress core protects `install.php` after installation by redirecting to the login page. Deleting core files is not recommended as they are restored on every update." Retain the deletion of `readme.html` and `license.txt`, which are not protected and serve no function.
- **Verification:** Read `wp-admin/install.php` source — it calls `wp_not_installed()` which checks `is_blog_installed()` and redirects accordingly.

---

## Finding 9: `DB_COLLATE` set to non-default value

- **Document:** Runbook
- **Location:** Appendix B.1 and B.9, lines ~2844, ~2991
- **Finding:** The `wp-config.php` templates set `define('DB_COLLATE', 'utf8mb4_unicode_ci');`. WordPress core documentation explicitly recommends leaving `DB_COLLATE` as an empty string (`''`) in most cases, as WordPress and MySQL will negotiate the correct collation. Setting it explicitly can cause issues on certain MySQL/MariaDB versions.
- **Severity:** Low
- **Recommendation:** Change to:
  ```php
  define('DB_COLLATE', '');
  ```
  Add a comment: "Leave empty unless you have a specific reason to override. WordPress defaults to the correct collation for the charset."
- **Verification:** See [WordPress `wp-config.php` documentation](https://developer.wordpress.org/advanced-administration/wordpress/wp-config/#database-collation): "In most cases, this value should be left blank."

---

## Finding 10: `WP_AUTO_UPDATE_CORE` history inaccurate

- **Document:** Runbook
- **Location:** Appendix B.5, line ~2932
- **Finding:** The comment says `(available since WordPress 5.6)`. The `WP_AUTO_UPDATE_CORE` constant with the value `'minor'` has been available since WordPress 3.7 (2013), when automatic background updates were introduced. WordPress 5.6 (2020) added auto-updates for major versions (the `true` value via the UI toggle), but the constant and the `'minor'` value predate 5.6 significantly.
- **Severity:** Low
- **Recommendation:** Change the comment to: `// Auto-update minor versions only (constant available since WordPress 3.7; major auto-update UI added in 5.6)`
- **Verification:** See [WordPress 3.7 release notes](https://wordpress.org/documentation/wordpress-version/version-3-7/) and [Automatic Background Updates developer documentation](https://developer.wordpress.org/advanced-administration/upgrade/upgrading/).

---

## Finding 11: Lowercase "dashboard" in Runbook

- **Document:** Runbook
- **Location:** §6.3, line 949
- **Finding:** The text reads "Confirm plugin/theme health in dashboard" — "dashboard" is lowercase. The Style Guide (Glossary) specifies: "Prefer 'Dashboard' over 'backend' or 'admin panel' in user-facing writing." The term should be capitalized when referring to the WordPress admin interface.
- **Severity:** Low
- **Recommendation:** Change "dashboard" to "Dashboard" at line 949.
- **Verification:** Style Guide Glossary entry for "Dashboard" (line 432).

---

## Finding 12: Runbook `wp-config.php` SMTP constants not standard WordPress

- **Document:** Runbook
- **Location:** §6.7, lines 1203–1207
- **Finding:** The constants `SMTP_HOST`, `SMTP_PORT`, `SMTP_USER`, `SMTP_PASSWORD`, and `SMTP_FROM` are documented as `wp-config.php` entries with an inline `add_filter('wp_mail', ...)` hook. The document correctly notes these constants are "NOT consumed by WordPress core" — but the example code that follows defines the filter with an empty implementation (`return $atts;`), which does nothing. This is dead code that gives a false sense of configuration.
- **Severity:** Medium
- **Recommendation:** Either provide a working implementation that uses PHPMailer to configure SMTP via the `phpmailer_init` action (the standard WordPress approach), or remove the custom constant approach entirely and direct readers to use the WP Mail SMTP plugin's constant-based configuration (see Finding 7). Example of the correct hook:
  ```php
  add_action( 'phpmailer_init', function( $phpmailer ) {
      $phpmailer->isSMTP();
      $phpmailer->Host       = SMTP_HOST;
      $phpmailer->SMTPAuth   = true;
      $phpmailer->Port       = SMTP_PORT;
      $phpmailer->Username   = SMTP_USER;
      $phpmailer->Password   = SMTP_PASSWORD;
      $phpmailer->SMTPSecure = PHPMailer\PHPMailer\PHPMailer::ENCRYPTION_STARTTLS;
  } );
  ```
- **Verification:** The `wp_mail` filter only modifies the mail arguments array; it cannot configure SMTP transport. The correct hook for SMTP is `phpmailer_init`. See [`phpmailer_init` hook reference](https://developer.wordpress.org/reference/hooks/phpmailer_init/).

---

## Finding 13: Cross-document control matrix minor wording inconsistencies

- **Document:** Benchmark (Appendix) and Hardening Guide (§15.6)
- **Location:** Benchmark line ~2391; Hardening Guide line ~606
- **Finding:** The cross-document control classification matrices are nearly identical but have minor wording differences in the "Environment-Specific" column:
  - Benchmark: "Dashboard updates allowed where managed hosting controls patch cadence"
  - Hardening Guide: "Dashboard updates retained where platform process requires it"
  - Benchmark: "Selective allowlists for required integrations (for example, mobile/Jetpack)"
  - Hardening Guide: "Route/IP allowlisting for required integrations"
  - Benchmark: "No SSH on managed platforms with equivalent provider controls"
  - Hardening Guide: "Managed-host controls where SSH is unavailable"
- **Severity:** Low
- **Recommendation:** Synchronize the wording between both matrices. Pick one canonical version and copy it to both documents. The Benchmark version is more specific and should be preferred.
- **Verification:** Visual diff of the two tables.

---

## Finding 14: Hardening Guide database privileges mention extra grants not in Benchmark

- **Document:** Hardening Guide
- **Location:** §7.3, line 238
- **Finding:** The Hardening Guide states: "Some plugins may also require CREATE TEMPORARY TABLES or LOCK TABLES — add only when verified necessary." The Benchmark §3.1 specifies exactly 8 privileges and does not mention CREATE TEMPORARY TABLES or LOCK TABLES. This is not contradictory (the Hardening Guide says "add only when verified necessary"), but the Benchmark's instruction to "Never grant FILE, PROCESS, SUPER, GRANT OPTION, or ALL PRIVILEGES" could be read as an exhaustive deny list, potentially confusing readers about whether CREATE TEMPORARY TABLES is acceptable.
- **Severity:** Low
- **Recommendation:** Add a brief note to Benchmark §3.1 acknowledging that some plugins may require `CREATE TEMPORARY TABLES` or `LOCK TABLES` on a case-by-case basis, with a cross-reference to the Hardening Guide §7.3.
- **Verification:** Cross-read both sections; the Hardening Guide provides the more complete guidance.

---

## Finding 15: Glossary coverage gaps for terms used across documents

- **Document:** Style Guide
- **Location:** §6 Glossary
- **Finding:** Several technical terms used prominently across multiple documents lack Style Guide glossary entries:
  - **SBOM** (Software Bill of Materials) — used in Benchmark §8.4 and Hardening Guide §11.1
  - **EPSS** (Exploit Prediction Scoring System) — used in Benchmark §8.3 and Hardening Guide §5.1
  - **virtual patching** — used in Benchmark §8.3 and Hardening Guide §9.1
  - **shadow AI** — used in Benchmark §11.3 and Hardening Guide §14.2
  - **must-use plugin** (mu-plugin) — used repeatedly in Benchmark and Runbook code examples
  - **bcrypt** — present in glossary, but **Argon2id** is not (referenced in Benchmark §5.7 and Hardening Guide §8.3)
- **Severity:** Medium
- **Recommendation:** Add glossary entries for these terms to ensure consistent usage and provide canonical definitions.
- **Verification:** Search each document for the terms and confirm they are used without glossary backing.

---

## Finding 16: Runbook Appendix B.4 `WP_DEBUG_LOG` set to `true` in production template

- **Document:** Runbook
- **Location:** Appendix B.4, line ~2900
- **Finding:** The debugging constants section shows `define('WP_DEBUG_LOG', true);` with a comment "Log errors to wp-content/debug.log". This is placed alongside `define('WP_DEBUG', false);`, creating a contradictory configuration. When `WP_DEBUG` is false, `WP_DEBUG_LOG` has no effect — but showing `WP_DEBUG_LOG = true` in a template that's labeled "(PRODUCTION = false)" is confusing and contradicts Benchmark §4.3, which recommends setting `WP_DEBUG_LOG` to `false` in production. The complete template in B.9 (line ~3045) correctly sets both to `false`.
- **Severity:** Medium
- **Recommendation:** In section B.4, change the example to match the production recommendation:
  ```php
  define('WP_DEBUG', false);       // Set to true only for development
  define('WP_DEBUG_LOG', false);   // Set to true only for development; logs to wp-content/debug.log
  define('WP_DEBUG_DISPLAY', false);
  ```
  Or clearly label the B.4 section as "Development/Staging Configuration" and add a separate production block.
- **Verification:** Compare with Benchmark §4.3 remediation and Runbook Appendix B.9 (which is correct).

---

## Summary

| Severity | Count |
| :--- | :--- |
| Critical | 0 |
| High | 3 |
| Medium | 6 |
| Low | 7 |
| **Total** | **16** |

### High-severity findings requiring immediate attention:

1. **Finding 1** — `wp user update --user_login` does not exist (Benchmark §5.2)
2. **Finding 3** — `--post_status=scheduled` should be `--post_status=future` (Runbook §9.2)
3. **Finding 5** — Password minimum length mismatch: 15 chars (Benchmark) vs. 12 chars (Hardening Guide)

### Medium-severity findings:

4. **Finding 2** — `php8.2-json` package does not exist (Runbook §6.5)
5. **Finding 4** — `wp term delete --default` flag does not exist (Runbook §9.3)
6. **Finding 6** — `JPEG_QUALITY` is not a WordPress constant (Runbook Appendix B.5)
7. **Finding 7** — WP Mail SMTP option names are incorrect (Runbook §6.7)
8. **Finding 12** — SMTP `wp_mail` filter implementation is dead code (Runbook §6.7)
9. **Finding 15** — Six glossary terms missing from Style Guide
10. **Finding 16** — `WP_DEBUG_LOG = true` in production-labeled template (Runbook Appendix B.4)

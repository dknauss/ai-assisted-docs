# Cross-Document Review — GPT — 2026-03-14

**Documents reviewed**

1. `wp-security-benchmark/WordPress-Security-Benchmark.md`
2. `wp-security-hardening-guide/WordPress-Security-Hardening-Guide.md`
3. `wordpress-runbook-template/WP-Operations-Runbook.md`
4. `wp-security-style-guide/WP-Security-Style-Guide.md`

## Scope Summary

- The database privilege guidance is aligned across the reviewed corpus: the Benchmark, Hardening Guide, and Runbook all use the eight-grant model and do not recommend `GRANT ALL PRIVILEGES`.
- Version floors are materially consistent across the requested documents: WordPress `6.x`, PHP `8.2+` with `8.3+` recommended for new deployments, and MySQL `8.0+` or MariaDB `10.6+`.
- The overlapping control-classification matrix rows in the Benchmark and Hardening Guide are aligned on baseline vs. optional hardened posture.
- The Style Guide glossary already covers the repeated terms I spot-checked for this review, including SBOM, mu-plugin, WAF, virtual patching, Shadow AI, Super Admin, and action-gated reauthentication.
- No requested-scope findings were identified in the Hardening Guide after checking the cited commands, constants, version references, and matrix alignment.

## Verified Findings

### Finding 1

- **Document:** WordPress Security Benchmark
- **Location:** §5.2, lines 1095-1097
- **Finding:** The remediation recommends renaming a predictable administrator login with `wp user update <user-id> --user_login=<new-username>`. That is not a supported update path. WP-CLI does not expose `--user_login` as a named option for `wp user update`, and WordPress core only includes `user_login` in `wp_insert_user()` when creating a user, not when updating one. As written, the control's remediation will not reliably remove a predictable login such as `admin`.
- **Severity:** High
- **Recommendation:** Replace the remediation with a supported workflow: create a new administrator account with a non-guessable login, reassign content if needed, then demote or delete the old account. If a low-level database rename is documented at all, it should be clearly labeled as a manual break-glass procedure with session/cache caveats.
- **Verification:** Run `wp help user update` and confirm the command does not document `--user_login`. Confirm in the official Code Reference for `wp_insert_user()` that `user_login` is added to the `$data` array only when `! $update`. The official profile documentation also states usernames cannot be edited from the profile screen.

### Finding 2

- **Document:** WP Security Style Guide
- **Location:** §8, lines 454 and 614
- **Finding:** The glossary uses non-existent WP-CLI checksum command names: `wp-cli checksum` and `wp checksum core`. The official commands are `wp core verify-checksums` for core and `wp plugin verify-checksums` for supported plugins.
- **Severity:** Medium
- **Recommendation:** Replace both command references with the official names. In the file-integrity entry, refer to `wp core verify-checksums` and, where relevant, `wp plugin verify-checksums`. In the WP-CLI glossary entry, update the example command accordingly.
- **Verification:** Run `wp help checksum` and confirm WP-CLI returns "not a registered wp command." Run `wp help core verify-checksums` to confirm the official command name and syntax.

### Finding 3

- **Document:** WordPress Operations Runbook
- **Location:** §9.2, lines 1875-1881
- **Finding:** The scheduling examples use `--post_status=scheduled`, but WordPress uses the `future` post status for scheduled posts. The create and list examples therefore use an invalid status value.
- **Severity:** Medium
- **Recommendation:** Change both examples to `future`:

```bash
wp post create --post_type=post --post_title='Scheduled Post' \
  --post_content='Content' --post_status=future \
  --post_date='2026-02-20 09:00:00'

wp post list --post_status=future --format=table
```

- **Verification:** `wp help post list` delegates to `WP_Query` arguments. The official `WP_Query` status documentation lists `future` and does not list `scheduled`.

### Finding 4

- **Document:** WordPress Operations Runbook
- **Location:** §9.3, line 1918
- **Finding:** The example `wp term delete category [TERM_ID] --default=1` uses a `--default` flag that does not exist for `wp term delete`.
- **Severity:** Medium
- **Recommendation:** Remove the invalid flag and document the behavior in prose instead:

```bash
wp term delete category [TERM_ID]
```

Add a note that WordPress reassigns affected posts to the site's default category.
- **Verification:** Run `wp help term delete` and confirm the only documented option beyond the positional arguments is `--by=<field>`.

### Finding 5

- **Document:** WordPress Operations Runbook
- **Location:** Appendix B.5, line 2929
- **Finding:** The appendix documents `define('JPEG_QUALITY', 82);` as though it were a WordPress configuration constant. WordPress does not expose a core `JPEG_QUALITY` constant. JPEG output quality is controlled through the `jpeg_quality` and `wp_editor_set_quality` filters.
- **Severity:** Medium
- **Recommendation:** Remove the constant from the `wp-config.php` appendix. If image quality guidance is needed, point readers to a filter-based implementation in a must-use plugin instead of a non-core constant.
- **Verification:** Check the official `wp-config.php` documentation, which does not list `JPEG_QUALITY`, and the Code Reference entries for `jpeg_quality` and `wp_editor_set_quality`, which document the supported control points.

### Finding 6

- **Document:** WordPress Security Benchmark and WordPress Operations Runbook
- **Location:** Benchmark §11.1, line 1962; Runbook §9.4, lines 1972 and 1998; Runbook §10.5, lines 2336-2337; Runbook §11.3, lines 2608-2611
- **Finding:** Several generic SQL and WP-CLI examples hardcode `wp_` table names (`wp_options`, `wp_posts`, `wp_comments`, `wp_commentmeta`) even though the same document set explicitly treats non-default table prefixes as a supported, optional deployment choice. On a site with a custom prefix, these commands fail or target the wrong tables.
- **Severity:** Medium
- **Recommendation:** Use dynamic or customizable table references in all generic procedures. For shell examples, prefer `$(wp db prefix)` where possible, for example `$(wp db prefix)options` or `$(wp db prefix)posts`. For raw SQL blocks, use a `[CUSTOMIZE: table prefix]` placeholder or direct readers to retrieve the prefix with `wp db prefix` first.
- **Verification:** Run `wp help db prefix` to confirm WP-CLI exposes the active prefix. Cross-check against Benchmark §3.3 and the Runbook's own prefix guidance, which already acknowledge non-default prefixes as valid.

### Finding 7

- **Document:** WordPress Operations Runbook
- **Location:** Appendix B.5, line 2932
- **Finding:** The comment on `define('WP_AUTO_UPDATE_CORE', 'minor');` says the setting is "available since WordPress 5.6." That timeline is incorrect. Automatic background updates were introduced in WordPress 3.7, and the `'minor'` behavior predates 5.6. WordPress 5.6 changed the default behavior for major auto-updates on new installs; it did not introduce the constant itself.
- **Severity:** Low
- **Recommendation:** Update the comment to reflect the actual history, for example: "Minor auto-updates are the long-standing default; background updates were introduced in WordPress 3.7, and WordPress 5.6 expanded major auto-update defaults for new installs."
- **Verification:** See the official Advanced Administration "Upgrading WordPress" page under "Configuring Automatic Background Updates," which states that automatic background updates were introduced in WordPress 3.7. The `wp_maybe_auto_update()` Code Reference changelog also shows version `3.7.0`.

## Open Questions

- None. The findings above were limited to items I could verify directly with WP-CLI help output, official WordPress developer documentation, or WordPress core code reference.

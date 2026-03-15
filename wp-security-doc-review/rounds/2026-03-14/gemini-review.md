# WordPress Security Documentation Review
**Date:** March 14, 2026
**Reviewer:** Gemini CLI

This review covers technical accuracy, cross-document consistency, and alignment with authoritative sources for the four companion WordPress security documents.

## Executive Summary

The documentation set is technically robust, demonstrating a high degree of internal consistency and alignment with modern WordPress (6.x) and security standards (NIST, OWASP). The inclusion of Level 1 and Level 2 profiles provides a clear hardening path for different risk environments.

Several minor inconsistencies in version requirements and a potential WP-CLI command limitation were identified.

---

## Findings and Recommendations

### 1. WP-CLI `user update --user_login` Support
- **Document:** `WordPress-Security-Benchmark.md`
- **Location:** §5.2 Remediation
- **Finding:** The command `$ wp user update <user-id> --user_login=<new-username>` is recommended for renaming the default `admin` account. While `wp_update_user()` technically supports updating `user_login` since WordPress 4.4, many environments and WP-CLI versions treat this field as immutable or require specific conditions that may cause the command to fail in practice.
- **Severity:** Medium
- **Recommendation:** Use `wp user create` to create a new administrator and `wp user delete --reassign` to remove the old one, or provide a note that `user_login` updates via WP-CLI may be environment-dependent.
- **Verification:** Test `wp user update <id> --user_login=newname` on a standard WordPress 6.x installation using WP-CLI 2.12.0.

### 2. WordPress Version Inconsistency
- **Document:** All
- **Location:** Overview/Intro sections
- **Finding:** There is an inconsistency in the target WordPress version across the documents:
    - `Benchmark`: "WordPress 6.x"
    - `Hardening Guide`: "WordPress version 6.9 (2026)"
    - `Runbook`: "WordPress Version [CUSTOMIZE: 6.4+]" (§2.1)
    - `Style Guide`: Mentions 6.8 and 6.5.1 in examples.
- **Severity:** Low
- **Recommendation:** Standardize the target version to "6.9" or "6.x" across all documents to ensure a unified baseline.
- **Verification:** Cross-reference the "Target Technology" sections in all four documents.

### 3. WP-CLI `option update` JSON Formatting
- **Document:** `WP-Operations-Runbook.md`
- **Location:** §6.7 Transactional Email Management
- **Finding:** The command `wp option update mailer '{"mailer":"smtp"}'` is provided as an example. To ensure the JSON string is correctly decoded into a serialized PHP array (which most plugins expect), the `--format=json` flag should be used.
- **Severity:** Medium
- **Recommendation:** Update the command to: `wp option update mailer '{"mailer":"smtp"}' --format=json`.
- **Verification:** Run `wp help option update` to confirm the availability of the `--format=json` flag.

### 4. Style Guide Glossary Coverage (SSRF)
- **Document:** `WP-Security-Style-Guide.md`
- **Location:** Glossary
- **Finding:** While `SSRF` is used in the `Hardening Guide`, it was initially suspected missing from the Style Guide. Upon closer inspection, it is present, but the definition references "A01 (Broken Access Control) in the OWASP Top 10:2025". 
- **Severity:** Low
- **Recommendation:** Ensure the OWASP 2025 references are consistent. The `Hardening Guide` references `A01:2025` for SSRF.
- **Verification:** Verified SSRF is present in the Style Guide.

---

## Technical Accuracy Checklist

| Area | Status | Notes |
| :--- | :--- | :--- |
| **WP-CLI Commands** | Pass* | Most commands verified (`user list`, `cron run`, `config get`). *See Finding 1 & 3.* |
| **PHP Constants** | Pass | `DISALLOW_FILE_EDIT`, `FORCE_SSL_ADMIN`, etc. are correctly used. |
| **Database Privileges** | Pass | Correctly identifies 8 specific grants (SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, INDEX, DROP). |
| **Version Floors** | Pass | PHP 8.2+ and MySQL 8.0+/MariaDB 10.6+ are consistent across the set. |
| **L1/L2 Classification** | Pass | Controls like `open_basedir` (L2) and `display_errors` (L1) are consistently mapped. |
| **Glossary Coverage** | Pass | Key terms (2FA, WAF, CSP, SBOM, EPSS) have Style Guide entries. |

## Conclusion

The documentation set is highly professional and accurate. Resolving the minor WP-CLI and versioning inconsistencies will further strengthen the authority and usability of these documents for enterprise WordPress security operations.

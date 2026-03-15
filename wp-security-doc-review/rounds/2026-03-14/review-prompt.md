# Multi-Model Editorial Review — March 2026

## Review Prompt

You are reviewing four companion WordPress security documents for technical accuracy, cross-document consistency, and alignment with authoritative sources.

## Instructions

1. Review all four documents below.
2. For each finding, provide:
   - **Document**: Which document contains the issue.
   - **Location**: Section number and/or line reference.
   - **Finding**: What is wrong or inconsistent.
   - **Severity**: Critical (breaks functionality or security), High (factual error or cross-doc contradiction), Medium (incomplete or imprecise), Low (polish/style).
   - **Recommendation**: Specific fix.
   - **Verification**: How to confirm the finding is correct (e.g., "run `wp help cache flush`" or "check developer.wordpress.org/reference/functions/wp_kses/").

3. Check these specific areas:
   - WP-CLI commands: Do they exist? Are flags correct? (Use `wp help <command>` as reference.)
   - PHP constants: Do they exist in the stated WordPress/PHP version?
   - Cross-document agreement: Same control, same classification (L1/L2, baseline/optional).
   - Database privileges: Should be 8 specific grants, not `GRANT ALL PRIVILEGES`.
   - Version floors: PHP, WordPress, MySQL version requirements must be consistent.
   - Glossary coverage: Key terms used in multiple documents should have Style Guide entries.

4. Do NOT suggest stylistic rewrites unless they fix a technical error or ambiguity.
5. Do NOT flag sections 1-2 of the Style Guide (mission/values) — these are out of scope.

## Authority Hierarchy

When sources conflict:
1. WordPress Developer Documentation (developer.wordpress.org)
2. WordPress core source code
3. WP-CLI documentation and source
4. External standards (OWASP, CIS, NIST, MDN)

## Documents

Review these four documents:
- WordPress-Security-Benchmark.md
- WordPress-Security-Hardening-Guide.md
- WP-Operations-Runbook.md
- WP-Security-Style-Guide.md

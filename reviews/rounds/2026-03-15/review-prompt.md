# Focused Runbook Editorial Review

## Review Prompt

You are reviewing the WordPress Operations Runbook as the primary target for technical accuracy, operational safety, cross-document consistency, and alignment with authoritative sources. The Benchmark, Hardening Guide, and Style Guide are supporting references for alignment, not equal-scope review targets in this round.

## Instructions

1. Review the Operations Runbook as the primary document.
2. Use the Benchmark, Hardening Guide, and Style Guide as supporting references where they help verify alignment, terminology, classification, or version guidance.
2. For each finding, provide:
   - **Document**: Which document contains the issue.
   - **Location**: Section number and/or line reference.
   - **Finding**: What is wrong or inconsistent.
   - **Severity**: Critical (breaks functionality or security), High (factual error or cross-doc contradiction), Medium (incomplete or imprecise), Low (polish/style).
   - **Recommendation**: Specific fix.
   - **Verification**: How to confirm the finding is correct.

3. Check these specific areas:
   - WP-CLI commands: Do they exist? Are flags correct? (Use `wp help <command>` as reference.)
   - Operational safety: Are prerequisites, verification steps, warnings, and rollback steps sufficient for an on-call operator?
   - Environment specificity: Are plugin-dependent, host-dependent, or distro-dependent steps clearly labeled?
   - `wp-config.php`, PHP, Nginx, Apache, cron, database, and backup guidance: Is it technically correct and internally consistent?
   - Cross-document agreement: Where the Runbook overlaps with Benchmark or Hardening Guide, do the semantics and version floors match?
   - Version readiness: Flag runbook guidance likely to need revision for WordPress 7.0 or PHP 8.4.

4. Do NOT suggest stylistic rewrites unless they fix a technical error or ambiguity.
5. Do NOT flag sections 1-2 of the Style Guide (mission/values) — these are out of scope.
6. Mechanical checks run separately before model review. Prioritize issues that require source-grounded judgment, cross-document reasoning, or substantive technical verification.

## Authority Hierarchy

When sources conflict:
1. WordPress Developer Documentation (developer.wordpress.org)
2. WordPress core source code
3. WP-CLI documentation and source
4. External standards (OWASP, CIS, NIST, MDN)

## Documents

Primary document:
- WP-Operations-Runbook.md

Supporting references:
- WordPress-Security-Benchmark.md
- WordPress-Security-Hardening-Guide.md
- WP-Security-Style-Guide.md

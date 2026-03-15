# Multi-Model Review Execution Guide

## Your Task

Run these three reviews in parallel (or sequentially). Each model should produce its own independent revision plan.

## Documents to Upload

Copy/paste or upload these 4 files to each model:

1. `/wp-security-benchmark/WordPress-Security-Benchmark.md` (2421 lines)
2. `/wp-security-hardening-guide/WordPress-Security-Hardening-Guide.md` (~1300 lines)
3. `/wordpress-runbook-template/WP-Operations-Runbook.md` (~2000 lines)
4. `/wp-security-style-guide/WP-Security-Style-Guide.md` (~700 lines)

## Review Prompt

Copy this prompt and submit with the documents:

```
You are reviewing four companion WordPress security documents for technical accuracy, cross-document consistency, and alignment with authoritative sources.

## Instructions

1. Review all four documents below.
2. For each finding, provide:
   - Document: Which document contains the issue.
   - Location: Section number and/or line reference.
   - Finding: What is wrong or inconsistent.
   - Severity: Critical, High, Medium, or Low.
   - Recommendation: Specific fix.
   - Verification: How to confirm the finding is correct.

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
```

## Output Files

Save each model's output as:
- `gemini-review.md`
- `gpt-review.md`  
- `claude-review.md`

Place them in: `wp-security-doc-review/rounds/2026-03-14/`

## After Completion

Once all three reviews are done, tell me and I'll run synthesis to merge findings.

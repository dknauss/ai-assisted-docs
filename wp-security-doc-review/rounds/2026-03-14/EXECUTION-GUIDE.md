# Multi-Model Review Execution Guide

This round is complete. Keep this file as the reusable execution pattern for future multi-model review rounds.

## Before Running Any Models

1. Run `bash tools/ci/review_preflight.sh`.
2. Use [docs/current-metrics.md](/Users/danknauss/Documents/GitHub/ai-assisted-docs/docs/current-metrics.md) as the source of truth for current document counts, line totals, and phase status.
3. If the preflight finds a mechanical issue, either fix it first or record it explicitly before asking models to review the documents.

The goal is to automate routine mechanical checks before model time is spent on them. Models should focus on ambiguity, source conflicts, and cross-document judgment.

## Your Task

Run these three reviews in parallel or sequentially. Each model should produce its own independent revision plan.

## Documents to Upload

Copy or upload these 4 files to each model:

1. `/wp-security-benchmark/WordPress-Security-Benchmark.md`
2. `/wp-security-hardening-guide/WordPress-Security-Hardening-Guide.md`
3. `/wordpress-runbook-template/WP-Operations-Runbook.md`
4. `/wp-security-style-guide/WP-Security-Style-Guide.md`

For any volatile count or status reference, point reviewers at `docs/current-metrics.md` instead of copying numbers into the round artifacts.

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
6. Mechanical checks run separately. Prioritize issues that require source-grounded editorial judgment, cross-document reasoning, or technical verification beyond simple pattern matching.

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

## After Completion

1. Save each model output in the round directory.
2. Run synthesis and verify every merged finding ends in one archival state: `applied`, `rejected`, or `stale`.
3. Update the round `README.md` to show the round is complete.
4. Re-verify cross-repo metrics after approved fixes land in the canonical repos.

# Focused Runbook Review Execution Guide

## Before Running Any Models

1. Run `bash tools/ci/review_preflight.sh`.
2. Use [docs/current-metrics.md](/Users/danknauss/Documents/GitHub/ai-assisted-docs/docs/current-metrics.md) as the source of truth for current document counts, line totals, and phase status.
3. Use `metrics-snapshot.md` for the round-start snapshot generated from the current metrics source.
4. If the preflight finds a mechanical issue, either fix it first or record it explicitly before asking models to review the documents.
5. Keep this round scoped to the Operations Runbook as the primary review target. Use the other three canonical docs as references when cross-document alignment matters.

## Files To Upload

1. `/wordpress-runbook-template/WP-Operations-Runbook.md`
2. `/wp-security-benchmark/WordPress-Security-Benchmark.md`
3. `/wp-security-hardening-guide/WordPress-Security-Hardening-Guide.md`
4. `/wp-security-style-guide/WP-Security-Style-Guide.md`

For any volatile count or status reference, point reviewers at `docs/current-metrics.md` or `metrics-snapshot.md` rather than copying numbers into ad hoc notes.

## Review Focus

Ask reviewers to prioritize:
- WP-CLI command validity and command-family correctness
- rollback safety, prerequisites, and verification steps
- environment-specific steps that need clearer labeling
- cross-document drift against Benchmark, Hardening Guide, and Style Guide terminology
- version and platform guidance that will be affected by WordPress 7.0 and PHP 8.4 work

## Output Files

Save each model's output as:
- `gemini-review.md`
- `gpt-review.md`
- `claude-review.md`

Place them in: `wp-security-doc-review/rounds/2026-03-15/`

## After Completion

1. Save each model output in the round directory.
2. Run synthesis and verify every merged finding ends in one archival state: `applied`, `rejected`, or `stale`.
3. Update `README.md` to reflect the current round state.
4. Re-verify cross-repo metrics after approved fixes land in the canonical repos.

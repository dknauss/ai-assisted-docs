# CONCERNS.md — Technical Debt & Issues

## Tech Debt

### Cross-Repo Metrics Synchronization (High)
Metrics and benchmark data are manually maintained across multiple repositories. No automated sync means data can become stale or inconsistent between canonical docs.

### DOCX Template Reproducibility (Medium)
Page numbering depends on an external Python script (`add_docx_page_numbers.py`). If the script or its environment changes, reproducibility of DOCX outputs is at risk.

### Hardcoded Relative Paths in Validation Scripts (Medium)
Validation scripts rely on hardcoded relative paths, which breaks when executed from different working directories.

### Four-Repo Coordination Overhead (High)
The project spans multiple repositories requiring coordinated updates. High risk of inconsistency when changes aren't propagated across all canonical doc sources.

## Known Issues

### No CI Automation for Cross-Repo Consistency
Cross-repository consistency is validated manually. There are no automated checks to catch drift between repos.

### Code Fence Integrity Not Automatically Validated
Code fences are critical for document rendering correctness but are not validated by any automated process.

### Planning State Drift
`.planning/STATE.md` and actual phase status can diverge over time with no automated sync checking.

## Security Concerns

No significant security concerns identified — this is a documentation/tooling repository with no authentication, user data, or sensitive external integrations.

## Performance Concerns

No significant performance concerns — scripts are run locally on small document sets.

## Fragile Areas

### Validation Scripts (`tools/`)
Critical validation gates lack integration tests. A broken script could silently pass invalid docs through the pipeline.

### Manual Workflow Dependencies
Several workflow steps depend on contributors following manual processes without automated guardrails (e.g., running linters, updating changelogs).

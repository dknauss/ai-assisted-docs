# Synthesis Workflow

Skill: wordpress-security-doc-editor
Agent(s): @SynthesisAgent

The synthesis agent merges independent review findings from multiple models into a single prioritized plan. Agreement between models increases confidence; disagreement requires investigation, not majority voting.

## Every finding states which models agreed or disagreed

**Given** a synthesized revision plan from multiple model reviews
**When** a finding is included
**Then** it must state which models identified it and whether they agreed

### Examples

Pass:
```markdown
### Finding: Benchmark section 3.1 uses deprecated `define('FORCE_SSL_LOGIN')`

- **Claude:** Flagged as Critical. Recommends replacing with `FORCE_SSL_ADMIN`.
- **Gemini:** Flagged as High. Same recommendation.
- **GPT:** Did not flag this.
- **Consensus:** 2/3 models agree. Verified against core source: `FORCE_SSL_LOGIN`
  was deprecated in WordPress 4.0. Confirmed Critical.
```

Fail:
```markdown
### Finding: Benchmark section 3.1 uses deprecated constant
Replace `FORCE_SSL_LOGIN` with `FORCE_SSL_ADMIN`.
```
No attribution. The editor can't assess confidence without knowing how many models caught it.

## Rejected findings are recorded with reasons

**Given** a model recommends a change
**When** the synthesis agent determines the recommendation is incorrect
**Then** the rejected finding must be recorded with the reason for rejection

### Examples

Pass:
```markdown
### Rejected Findings

| Model | Finding | Reason for Rejection |
|---|---|---|
| GPT | Benchmark should recommend `password_hash()` instead of `wp_hash_password()` | WordPress uses its own portable password hashing via `phpass`. Using PHP's native `password_hash()` would break compatibility with WordPress authentication. |
```

Fail: The synthesis agent silently omits GPT's recommendation without recording why. Future rounds may repeat the same overclaim.

## Prioritization follows the severity scale

**Given** a synthesized revision plan
**When** findings are prioritized
**Then** the priority must follow: Critical (technical correctness) > High (cross-document alignment) > Medium (completeness) > Low (polish)

### Examples

Pass:
```markdown
## Critical
- Deprecated constant in Benchmark section 3.1

## High
- Hardening Guide and Benchmark disagree on REST API control classification

## Medium
- Runbook missing verification step for cache flush procedure

## Low
- Inconsistent heading capitalization in Style Guide section 6
```

Fail: A deprecated constant (technical correctness) is listed as Low priority while a heading capitalization issue is listed as High.

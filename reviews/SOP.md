# Editorial Multi-Agent SOP

Standard operating procedure for editorial review and revision of the WordPress security document series.

Current counts, phase status, and cross-repo metrics live in [docs/current-metrics.md](../docs/current-metrics.md). This SOP should reference that file rather than copying volatile totals.

## Scope

This SOP applies to the four canonical security documents:

- Security Benchmark
- Hardening Guide
- Operations Runbook
- Style Guide

## Operating Modes

### Default Mode

Use the single-model, multi-agent workflow plus deterministic validators for:

- normal edits
- focused audits
- small or medium revision rounds

### Escalation Mode

Use the multi-model editorial board for:

- major cross-document revisions
- release-quality milestones
- periodic audit rounds
- changes likely to expose cross-document drift

## Procedure

### Step 0 — Mechanical Preflight

Run deterministic checks before model review:

```bash
bash tools/ci/review_preflight.sh
```

Preflight should catch or surface:

- metrics drift
- known WP-CLI regression patterns
- glossary watchlist drift
- workflow health issues

If preflight fails, fix the defect or record it before broader review.

### Step 1 — Independent Document Review

Run specialized document review roles:

- `@BenchmarkAgent`
- `@HardeningGuideAgent`
- `@RunbookAgent`
- `@StyleGuideAgent`

Each role reviews from its own domain perspective and produces structured findings. No approved-source edits happen at this stage.

### Step 2 — Validation

Run focused validation for mechanically checkable issues:

- WP-CLI command validity
- code block integrity
- glossary coverage
- reference and link checks

### Step 3 — Cross-Document Audit

Run `@AuditAgent` across the full four-document set to check:

- classification symmetry
- version and PHP floor consistency
- code example agreement
- cross-reference accuracy
- glossary coverage

Use [methodology/cross-document-audit-template.md](methodology/cross-document-audit-template.md) as the audit framework.

### Step 4 — Synthesis

Run `@SynthesisAgent` to:

- merge findings
- identify convergence and disagreement
- verify claims against source files and the authority hierarchy
- prioritize recommendations by severity and confidence

### Step 5 — Human Editorial Decision

The human editor reviews the synthesized findings and explicitly marks each one for acceptance, modification, or rejection.

No change is applied without human approval.

### Step 6 — Implementation

Apply approved changes in the canonical repositories.

Required follow-up:

- update metrics if they changed
- update changelog entries
- preserve cross-document symmetry
- regenerate and validate published artifacts when needed

### Step 7 — Post-Implementation Audit

Re-check:

- cross-document consistency
- command and code correctness
- glossary coverage
- cross-references
- output generation and validation

### Step 8 — Stateful Closeout

Every synthesized finding must end in one final archival state:

- `applied`
- `rejected`
- `stale`

`Needs verification` is acceptable during active work, but not as the final closed-round status.

## Authority Hierarchy

When sources conflict, use this precedence:

1. WordPress Developer Documentation
2. WordPress core source and Code Reference
3. WP-CLI documentation and source
4. External standards for non-WordPress-specific topics

Any deviation must be explicitly justified and labeled as conditional or environment-specific.

## Guardrails

- human editorial authority is final
- no autonomous changes
- no FUD
- no speculative vulnerability claims
- no unsupported WordPress, PHP, or WP-CLI assertions
- no unresolved cross-document drift left unexamined

## Related Process Docs

- [PROCESS-SUMMARY.md](PROCESS-SUMMARY.md)
- [methodology/single-model-multi-agent.md](methodology/single-model-multi-agent.md)
- [methodology/multi-model-editorial-board.md](methodology/multi-model-editorial-board.md)
- [methodology/editorial-workflow-diagram.md](methodology/editorial-workflow-diagram.md)

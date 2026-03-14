# TESTING.md — Test Structure & Practices

## Testing Philosophy

This project uses **Behavior-Driven Development (BDD)** with natural-language scenario files rather than a traditional unit/integration test framework. The rationale: the "code" being tested is AI agent behavior, editorial judgment, and documentation quality — not executable functions. Scenarios describe expected AI behaviors that are validated through manual test runs.

## Test Framework

**No traditional test runner** (no pytest, jest, etc.). Instead:
- Scenarios written in `Given / When / Then` format in Markdown
- Test runs executed manually by running an AI agent against a scenario
- Results recorded in `scenarios/test-runs/` with date-stamped files

CI automation uses shell scripts for validating static properties (metrics consistency, alignment).

## Scenario Organization

Scenarios live in `scenarios/` organized by skill:

```
scenarios/
├── security-researcher/       # 3 scenarios
├── wordpress-runbook-ops/     # 4 scenarios
├── wordpress-security-doc-editor/ # 4 scenarios
├── cross-skill/               # 3 scenarios (multi-skill workflows)
└── test-runs/                 # Execution records
```

### security-researcher Scenarios
- `source-grounding.md` — Agent cites authoritative sources, not opinions
- `vendor-editorial-separation.md` — Vendor content stays separate from editorial
- `verification-with-veloria.md` — Claims verified against canonical sources

### wordpress-runbook-ops Scenarios
- `code-fence-integrity.md` — Code blocks use correct language tags and syntax
- `command-validity.md` — WP-CLI commands are valid and correct
- `destructive-command-safety.md` — Destructive commands include safety warnings
- `procedure-schema-completeness.md` — Runbooks include all required sections

### wordpress-security-doc-editor Scenarios
- `authority-hierarchy.md` — Doc editor respects source authority ranking
- `benchmark-structure.md` — Benchmark docs follow required structure
- `cross-document-alignment.md` — Edits stay consistent across related docs
- `terminology-consistency.md` — Security terms used consistently

### cross-skill Scenarios
- `audit-workflow.md` — Multi-skill audit pipeline works end-to-end
- `style-guide-protection.md` — Style rules enforced across skill boundaries
- `synthesis-workflow.md` — Research → editorial synthesis workflow

## CI Validation Scripts

These run in GitHub Actions to validate static document properties:

### `tools/ci/validate_cross_repo_metrics.sh`
Validates that `docs/current-metrics.md` is consistent with metrics referenced in canonical doc repositories. Catches stale/mismatched numbers.

### `tools/ci/validate_gp_alignment.sh`
Validates GP (General Purpose) alignment across doc sources.

## GitHub Actions Workflows

| Workflow | Trigger | Purpose |
|---|---|---|
| `.github/workflows/validate-cross-repo-metrics.yml` | Push / PR | Run cross-repo metric validation |
| `.github/workflows/reusable-generate-docs.yml` | Called by other repos | Reusable doc generation pipeline |

## Test Run Records

Test runs are recorded in `scenarios/test-runs/` as dated Markdown files:
- `2026-03-11-runbook-ops-domain-migration.md`
- `2026-03-12-doc-editor-security-docs.md`

Each record captures: scenario tested, agent used, inputs, actual output, pass/fail, and observations.

## Coverage Gaps

- No integration tests for `tools/ci/` scripts themselves
- No automated execution of BDD scenarios (all manual)
- No coverage tracking across scenario categories
- Cross-repo metric validation only runs when explicitly triggered

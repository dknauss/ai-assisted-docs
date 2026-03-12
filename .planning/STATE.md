# Project State

## Project Reference

See: `README.md` and `AGENTS.md` (updated 2026-03-06)
Current metrics: `docs/current-metrics.md`

**Core value:** Keep research artifacts source-grounded and keep canonical document changes in the source repositories.
**Current focus:** Phase 2 execution planning is active (`02-01`, `02-02`) with cross-repo metrics synchronization checks in place.

## Current Position

Phase: 2 of 2 (Canonical Pipeline Consolidation and Output Polish)
Plan completion: 0 of 2 in current phase (02-01 Task 1 pre-satisfied — reusable workflow exists)
Status: In Progress (ready to execute 02-01 rollout)
Last activity: 2026-03-12 — Reusable workflow updated with pdf-defaults.yaml bootstrap and page numbering guidance; Phase 2 plans updated with editorial decisions; backlog items added for typography research and landscape layout

Progress: [#######---] 5/7 plans complete overall (71%); current phase remains 0/2 complete

## Accumulated Context

### Decisions

- Keep GridPane and Fortress material as internal research artifacts in this repo, not as canonical guidance.
- Point any approved follow-up work at the sibling source repositories, not `wp-security-doc-review/rounds/...`.
- Treat proprietary terms such as `Vaults`, `Pillars`, and `Code Freeze` as vendor-specific unless the editor explicitly approves a case-study use.
- @SecurityResearcher role is vendor-neutral; GridPane is the first research subject but not the only one.
- Merged section schema for @SecurityResearcher deliverables: Title and scope; Verified vendor claims; Product or feature analysis; Vendor-specific limitations and portability notes; Transferable editorial implications for WordPress guidance; Open questions; References.

### Pending Todos

- 02-01 Task 2: Roll out shared workflow — replace each repo's 147-line generate-docs.yml with a caller that invokes the reusable workflow. Preserve existing shared bootstrap behavior and verify `pdf-defaults.yaml` remains standardized.
- 02-01 Task 3: Record migration completion and verify.
- 02-02 Task 1: Apply reference.docx page numbering in Word across all four repos.
- 02-02 Task 2: Regenerate all document sets through shared pipeline.
- 02-02 Task 3: Run Phase 2 exit checklist and close phase.
- Backlog: Typography research (Tufte, Butterick models; font alternatives to Noto family).
- Backlog: Landscape layout investigation (wide tables in Benchmark/Runbook PDFs).

### Blockers/Concerns

- Keep `docs/current-metrics.md` in this repo synchronized with downstream repo metrics to prevent stale planning facts.
- `release.yml` in downstream repos is out-of-scope for Phase 2 changes but must be verified as unaffected after migration.
- `validate-metrics.yml` + `verify-metrics.sh` remain per-repo — do not centralize (metrics definitions are repo-specific; the generic runner needs no sharing).

## Session Continuity

Last session: 2026-03-12
Stopped at: Phase 2 planning normalization complete; ready to execute `02-01`
Resume file: `.planning/phases/02-phase2/02-01-PLAN.md`

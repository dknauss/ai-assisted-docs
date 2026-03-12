# Roadmap: GridPane Research Alignment

## Overview

This planning track keeps the GridPane research artifacts in this repository source-grounded, vendor-aware, and clearly separated from the canonical WordPress security docs maintained in sibling repositories. Work here improves research quality, validation, and planning hygiene; any approved implementation changes belong in the canonical repos, not in archived review files.

## Phases

- [x] **Phase 1: GridPane Research Alignment** - Rebuild the GridPane research package and its planning scaffold so future editorial follow-up work is correctly targeted and verifiable.
- [x] **Phase 2: Canonical Pipeline Consolidation and Output Polish** - Reduce workflow drift across canonical document repos and improve final publication quality while preserving the `Markdown -> DOCX -> PDF/EPUB` pipeline.

## Phase Details

### Phase 1: GridPane Research Alignment
**Goal**: Produce a source-grounded GridPane research package, a reusable vendor-research workflow, and the planning scaffolding needed to manage future follow-up work without confusing review artifacts for canonical docs.
**Depends on**: Nothing (first phase)
**Success Criteria** (what must be TRUE):
  1. GridPane research artifacts in this repo cite exact public URLs and distinguish verified vendor claims from editorial implications.
  2. Crosswalk and gap-analysis artifacts point follow-up work at the canonical source documents in the sibling repositories.
  3. Validation tooling runs on the default local shell environment and checks the research package for scope drift.
  4. `.planning/ROADMAP.md`, `.planning/STATE.md`, and `.planning/config.json` exist so this phase can be resumed coherently.
**Plans**: 5 plans

Plans:
- [x] 01-01: Rebuild the GridPane brief and briefing card with exact citations and internal-artifact scope.
- [x] 01-02: Rewrite the crosswalk and gap analysis against the canonical document repositories.
- [x] 01-03: Add a reusable crosswalk template and align the vendor-research prompt and skill.
- [x] 01-04: Fix AGENTS, README, PR metadata, and validation tooling for the new research package.
- [x] 01-05: Establish GSD planning hygiene and execution guardrails for future follow-up work.

### Phase 2: Canonical Pipeline Consolidation and Output Polish
**Goal**: Make the canonical document build and publication pipeline easier to maintain and produce consistently higher-quality DOCX-derived PDF/EPUB outputs.
**Depends on**: Phase 1 complete
**Success Criteria** (what must be TRUE):
  1. A single reusable workflow/composite action pattern exists for doc generation and is adopted in all four canonical document repositories.
  2. Shared validation gates are centralized so pipeline drift is caught before merge.
  3. Publication styling guidance for `reference.docx` and EPUB CSS customization is documented and tested in the canonical repos.
  4. Final PDF/EPUB outputs remain derived from DOCX generated from the single primary Markdown file per repo.
**Plans**: 2 plans

Plans:
- [x] 02-01: Implement a shared reusable docs-generation workflow/composite action for all four canonical repositories.
- [x] 02-02: Define and apply output-polish standards (`reference.docx` template tuning and EPUB CSS baseline) with validation checks.
Dependency note: Plan `02-02` starts only after `02-01` is fully landed in all four canonical repos.

Phase 2 exit checklist:
- Shared generation workflow/composite action is adopted in all four canonical repositories. Completed 2026-03-12.
- `generate-docs` and `validate-metrics` workflows are green in all four canonical repositories. `generate-docs` reruns succeeded on 2026-03-12 after migration and after page-numbered template rollout; latest `validate-metrics` runs remain green in all four repos.
- `release.yml` verified as unaffected by migration (same output filenames preserved). Confirmed during `02-01` and `02-02`.
- `reference.docx` customized with page numbering in all four repos. Completed 2026-03-12 via reproducible DOCX footer patching; EPUB CSS baseline confirmed adequate.
- `pdf-defaults.yaml` standardized across repos via the shared workflow bootstrap and verified unchanged by rollout. Completed 2026-03-12.
- `validate-metrics.yml` + `verify-metrics.sh` remain per-repo (metrics definitions are repo-specific by nature; the generic runner script needs no centralization). Confirmed 2026-03-12.
- Cross-repo consistency check confirms DOCX intermediary derivation and primary-markdown-only generation scope. Completed 2026-03-12.

## Backlog

Items for future phases, not yet scheduled.

- **Typography research:** Survey professional technical-documentation typography models (e.g., Tufte, Butterick's Practical Typography, CERN/ISO document standards) and evaluate whether the current Noto Serif/Sans/Mono family is the strongest choice or whether alternatives (Source Serif Pro, Inter, JetBrains Mono) would improve readability in long-form security documents.
- **Landscape layout investigation:** Determine whether wide tables (Benchmark appendix, Runbook configuration matrices) would benefit from landscape-oriented pages in PDF output. Evaluate eisvogel's `classoption: landscape` support, per-page rotation via `pdfjam` or LaTeX `lscape`/`pdflscape`, and whether landscape sections create usability problems in EPUB and DOCX.

## Progress

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. GridPane Research Alignment | 5/5 | Complete | ✓ |
| 2. Canonical Pipeline Consolidation and Output Polish | 2/2 | Complete | ✓ |

Overall: 7/7 plans complete (100%). Phase 2 closed on 2026-03-12 after shared workflow rollout and page-numbered `reference.docx` validation in all four canonical repos.

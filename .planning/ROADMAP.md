# Roadmap: Editorial Alignment & Vendor Research

## Overview

This planning track covers comprehensive editorial review of the WordPress security document series and extended vendor research beyond the initial GridPane work. Work produces recommendations for canonical documents; changes are staged in sibling repositories.

## Phases

- [x] **Phase 1: GridPane Research Alignment** - Initial GridPane vendor research with limited scope (2 URLs).
- [x] **Phase 2: Comprehensive Editorial Alignment** - Full editorial review cycle and extended vendor research covering GridPane KB security articles, WordPress VIP, and Patchstack.

## Backlog

- High priority: run a focused runbook-only editorial review round. The 2026-03-14 synthesis concentrated 12 of 16 findings in the Operations Runbook (1 High, 5 Medium, 6 Low), so the runbook should get the next targeted audit before another broad four-document round.
- High priority: prepare for the upcoming WordPress 7.0 release currently targeted for 2026-04-09. Version references across all canonical docs will need an explicit audit and update pass, and PHP 8.4 should be evaluated for inclusion in the recommendation set during that same review.
- Deepen the new validator baseline: expand the source-driven WP-CLI command-path check and the doc-count-aware glossary coverage checks into richer flag and term inference without reintroducing false positives.
- Add template-aware bootstrap refinements so new review rounds can optionally preseed per-model output stubs and richer synthesis sections without hand editing.

## Phase Details

### Phase 1: GridPane Research Alignment (COMPLETE)
**Goal**: Initial vendor research on GridPane (2 URLs: Fortress page, security plugin KB article)
**Status**: Complete — March 2026

### Phase 2: Comprehensive Editorial Alignment
**Goal**: Comprehensive vendor research, fresh multi-model editorial review, and glossary maintenance
**Depends on**: Phase 1 complete
**Success Criteria** (what must be TRUE):
  1. GridPane security KB research expanded to 32 articles (all security-related).
  2. New vendor research on WordPress VIP and Patchstack follows same 7-section brief format.
  3. Multi-model editorial review (3 models) produces prioritized revision plan.
  4. Canonical repos audited for unimplemented March 2026 findings.
  5. Glossary maintenance completed (7 missing terms, 2 ordering fixes, 4 cross-refs).
  6. All research artifacts point follow-up work at canonical source repos.
**Plans**:
- [x] 02-01: Phase 2 Initiation — Update planning files (ROADMAP.md, STATE.md, CHANGELOG.md)
- [x] 02-02: Comprehensive GridPane Security KB Research — Read all 32 security articles, produce updated brief and crosswalk
- [x] 02-03: New Multi-Model Editorial Review — Run 3 models (Gemini, GPT, Claude) on canonical docs
- [x] 02-04: Canonical Repo Audit — Verify pending findings from March 2026 rounds
- [x] 02-05: WordPress VIP Vendor Research — Full KB + product docs
- [x] 02-06: Patchstack Vendor Research — Full KB + product docs
- [x] 02-07: Glossary Maintenance — Add 7 missing terms, fix ordering/cross-refs

## Progress

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. GridPane Research Alignment | 5/5 | Complete | ✓ |
| 2. Comprehensive Editorial Alignment | 7/7 | Complete | ✓ |

Overall: 12/12 plans complete (100%)

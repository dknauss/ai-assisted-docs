# Current Metrics (Canonical)

This file is the single source of truth for current project counts.

Last verified: 2026-03-12
Verification environment: local repo checkouts at `/Users/danknauss/Documents/GitHub/`

## Document Series Facts

| Fact | Value | Verification | Last changed |
|---|---:|---|---|
| Canonical documents | 4 | See table below | v1.0 |
| Downstream repos | 4 | `ls -d wp-security-* wordpress-runbook-*` (submodules/siblings) | v1.0 |
| Research subjects | 1 | GridPane (first; vendor-neutral framework designed for more) | Phase 1 |
| Planning phases | 2 | `ls .planning/phases/` | Phase 2 defined |
| Behavioral scenario files | 14 | `find scenarios -name '*.md' ! -name 'README.md' | wc -l` | v1.1 |
| Cross-repo metrics sync check script | 1 | `bash tools/ci/validate_cross_repo_metrics.sh` | Phase 2 |
| Shared build outputs | 4 formats | Markdown source, DOCX, EPUB, PDF per document | Phase 2 scope |

### Canonical Document Set

| Document | Repository | Audience |
|---|---|---|
| Security Benchmark | `wp-security-benchmark` | Sysadmins, auditors |
| Hardening Guide | `wp-security-hardening-guide` | Architects, developers |
| Operations Runbook | `wordpress-runbook-template` | SREs, operators |
| Style Guide | `wp-security-style-guide` | Writers, communicators |

### Files that reference these counts

- `README.md` — project overview, document set table
- `AGENTS.md` — document set table, role definitions, acceptance criteria
- `scenarios/README.md` — scenario index, organization table
- `.planning/STATE.md` — phase completion context

## Cross-Repo Document Metrics

Each downstream repo maintains its own `docs/current-metrics.md` with verification commands. This table tracks key metrics across all four documents for cross-document audit comparisons.

| Metric | Benchmark | Hardening Guide | Runbook | Style Guide |
|---|---:|---:|---:|---:|
| Document lines | 2,421 | 621 | 3,279 | 693 |
| Major sections (H2) | 22 | 17 | 11 | 12 |
| Security controls | 50 | — | — | — |
| Glossary terms | — | — | — | 139 |
| Code fences | 250 | 0 | 164 | 0 |
| WP-CLI commands | 4 | 0 | 157 | 0 |
| Destructive commands | — | — | 54 | — |
| Inline WARNINGs | 0 | 0 | 16 | 0 |
| CUSTOMIZE placeholders | 2 | 0 | 201 | 0 |
| Has CHANGELOG.md | Yes | Yes | Yes | Yes |
| Has docs/current-metrics.md | Yes | Yes | Yes | Yes |
| Last metrics verified | 2026-03-12 | 2026-03-12 | 2026-03-12 | 2026-03-12 |

### Cross-Repo Verification

After a cross-document revision round, run the verification script in each modified repo's `docs/current-metrics.md` and update this table. Key cross-repo checks:

- **Control classification alignment:** Same control has same L1/L2 in Benchmark and Hardening Guide.
- **Terminology consistency:** Terms used in 2+ documents match the Style Guide glossary (139 terms).
- **Version references:** "As of WordPress X.Y" and PHP version floors match across all four documents.
- **Code fence integrity:** Opening/closing fence counts balance in Benchmark (250) and Runbook (164).

## Phase Completion

| Phase | Goal | Status |
|---|---|---|
| 1 | Research infrastructure + editorial workflow | Complete |
| 2 | Canonical pipeline consolidation + output polish | In Progress (`02-01` active; `02-02` blocked on `02-01`) |

## Update Procedure

1. Update this file when adding a new canonical document, downstream repo, or research subject.
2. After a revision round, update the Cross-Repo Document Metrics table with current values from each repo's `docs/current-metrics.md`.
3. Cross-reference `.planning/STATE.md` for phase status.
4. Keep `AGENTS.md` and `README.md` aligned with facts in this file.
5. Update `CHANGELOG.md` entries in both this repo and any downstream repos that received changes.

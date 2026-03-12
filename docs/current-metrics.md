# Current Metrics (Canonical)

This file is the single source of truth for current project counts.

Last verified: 2026-03-09
Verification environment: local repo checkout at `/Users/danknauss/Documents/GitHub/ai-assisted-docs`

## Document Series Facts

| Fact | Value | Verification | Last changed |
|---|---:|---|---|
| Canonical documents | 4 | See table below | v1.0 |
| Downstream repos | 4 | `ls -d wp-security-* wordpress-runbook-*` (submodules/siblings) | v1.0 |
| Research subjects | 1 | GridPane (first; vendor-neutral framework designed for more) | Phase 1 |
| Planning phases | 2 | `ls .planning/phases/` | Phase 2 defined |
| Behavioral scenario files | 14 | `find scenarios -name '*.md' ! -name 'README.md' | wc -l` | v1.1 |
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

## Phase Completion

| Phase | Goal | Status |
|---|---|---|
| 1 | Research infrastructure + editorial workflow | Complete |
| 2 | Canonical pipeline consolidation + output polish | Planned (02-01, 02-02 pending) |

## Update Procedure

1. Update this file when adding a new canonical document, downstream repo, or research subject.
2. Cross-reference `.planning/STATE.md` for phase status.
3. Keep `AGENTS.md` and `README.md` aligned with facts in this file.

# Editorial Process Summary

## Overview

The WordPress security document series (Benchmark, Hardening Guide, Runbook, Style Guide) is maintained through a multi-model editorial process where frontier LLMs serve as research assistants, cross-checkers, and drafting aids under human editorial control.

This document describes the process as it has been practiced through multiple revision rounds in early 2026.

Current counts, phase status, and cross-repo metrics live in [docs/current-metrics.md](/Users/danknauss/Documents/GitHub/ai-assisted-docs/docs/current-metrics.md). Process docs should reference that file rather than copying volatile totals.

## The Four-Document Architecture

Each document serves a distinct audience and purpose. Cross-document consistency is a primary editorial concern because the same technical control (e.g., database least-privilege, WP-Cron replacement, REST API scoping) may appear in all four documents at different levels of abstraction.

| Document | Audience | Voice | Code Examples |
|---|---|---|---|
| **Benchmark** | Sysadmins, auditors | Prescriptive (CIS-style) | Extensive — audit commands, remediation snippets |
| **Hardening Guide** | Architects, developers | Advisory (enterprise guidance) | Minimal — strategic, not operational |
| **Runbook** | SREs, operators | Procedural (step-by-step) | Extensive — runnable commands, templates |
| **Style Guide** | Writers, communicators | Editorial (principles + glossary) | None — terminology and framing only |

## Process Steps

### 0. Mechanical Preflight

Before any model review starts, run the mechanical checks:

- `bash tools/ci/review_preflight.sh`
- reusable workflow self-test in `.github/workflows/validate-reusable-generate-docs.yml`

This front-loads the checks that are better handled deterministically:

- metrics drift
- curated WP-CLI regression patterns
- glossary coverage watchlist drift
- workflow health

If preflight finds a mechanical defect, fix it or record it before spending model time on a broader review.

### 1. Independent Multi-Model Review

Three frontier models (Gemini 2.5 Pro, GPT-5.3-Codex, Claude Opus 4) independently review the documents with identical instructions:

- Compare the four documents for internal consistency.
- Identify factual errors, outdated information, incorrect code, and misalignments.
- Produce a prioritized revision plan.

The three plans typically overlap by 60-80% on findings but differ on severity, phrasing, and recommended fixes.

### 2. Cross-Validation of Findings

The human editor reviews all three plans and instructs the primary working model (Claude) to:

- Compare the three plans for agreement and disagreement.
- Verify each finding against source files and authoritative references.
- Flag overclaimed findings (model hallucinations, outdated assumptions).
- Synthesize a single revision plan with confidence ratings.

This step routinely catches errors in the models' own recommendations. Examples from actual rounds:

- One model claimed OWASP Top 10:2025 had not been published. Another correctly identified it as published. Verification confirmed publication.
- One model flagged `wp user update --user_login` as broken. Another noted it requires runtime validation, not a blanket assumption of failure.
- One model counted "~20 nonexistent WP-CLI commands." Reframed accurately as "commands that are not part of core WP-CLI, are plugin-dependent, or have invalid syntax."

### 3. Human Editorial Decision

The human editor (@dknauss) reviews the synthesized plan and approves, modifies, or rejects each item before implementation. No change is applied without explicit approval. The decision criteria:

- **Accept**: Finding is verified, fix is correct, change improves the document.
- **Modify**: Finding is valid but the recommended fix is wrong or incomplete.
- **Reject**: Finding is overclaimed, irrelevant, or the current text is preferable.

### 4. Implementation and Verification

Approved changes are applied to the source markdown files, committed with descriptive messages, and pushed. Each commit message identifies:

- What changed and why.
- Which findings drove the change.
- Co-authorship attribution for AI-assisted changes.

### 5. Post-Implementation Audit

After all changes are applied, a final cross-document consistency check verifies:

- Same control has the same classification (L1/L2, baseline/optional) across documents.
- Code examples in Benchmark and Runbook agree on syntax and semantics.
- Glossary terms in Style Guide cover key concepts from the other three documents.
- Cross-references between documents are accurate and bidirectional.

### 6. Stateful Closeout

Each synthesized finding must end in one archival state:

- `applied`
- `rejected`
- `stale`

`Needs verification` is acceptable during active work, but not as a final archival outcome. The synthesis artifact is the ledger that closes the loop between model output, human editorial decision, and canonical changes.

## Authority Hierarchy

When sources conflict, the following precedence applies:

1. **WordPress Developer Documentation** (developer.wordpress.org) — primary authority for WordPress-specific guidance.
2. **WordPress core source code** — primary authority for constants, hooks, filters, and function behavior.
3. **WP-CLI documentation and source** — primary authority for command syntax and flags.
4. **External standards** (OWASP, CIS, NIST, MDN) — authority only for non-WordPress-specific topics.

Recommendations that deviate from these sources are flagged, examined, and either labeled as conditional/environment-specific or rejected.

## What the Process Catches

Across multiple rounds, the combined automation-plus-review process has consistently identified:

- **WP-CLI command errors**: Nonexistent subcommands, invalid flags, wrong syntax (e.g., `--field` vs `--fields`, `--post_type=all` vs `--post_type=any`). Curated watchlist checks now catch known regressions before model review.
- **Cross-document contradictions**: One document prescribing `GRANT ALL PRIVILEGES` while another prescribes least-privilege with 8 specific grants.
- **Stale references**: Deprecated constants (`WPLANG`, `FORCE_SSL_LOGIN`), removed features (MySQL 8.0 Query Cache), version floor errors (auto-updates since 3.7, not 4.1).
- **Code correctness issues**: Unconditional REST API endpoint removal breaking the block editor, `WP_DEBUG_LOG=true` when `WP_DEBUG=false`, missing `current_user_can()` guards.
- **Glossary gaps**: Technical terms used extensively in 3 documents but absent from the Style Guide glossary. A watchlist check now catches known glossary drift mechanically.

## What the Process Does Not Catch

- **Subjective editorial quality**: Whether a section reads well, whether an analogy is apt, whether the tone is right. These remain human editorial judgments.
- **Real-world operational validation**: Whether a remediation step works in every hosting environment. The documents note environment-specific caveats but cannot test every configuration.
- **Community consensus**: Whether the WordPress community agrees with a particular hardening recommendation. Community review via pull requests and issues remains essential.

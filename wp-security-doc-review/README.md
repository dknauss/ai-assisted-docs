# WordPress Security Document Review — Working Directory

This directory archives the editorial process artifacts for the WordPress security document series. It records what was reviewed, what changed, and why.

Use [docs/current-metrics.md](/Users/danknauss/Documents/GitHub/ai-assisted-docs/docs/current-metrics.md) as the source of truth for volatile counts, phase status, and cross-repo metrics. Review artifacts should link to it rather than copying totals that will drift.

## Contents

### GridPane Research Package

| File | Purpose |
|---|---|
| `gridpane-security-brief.md` | Internal research brief on GridPane's public WordPress security claims |
| `gridpane-briefing-card.md` | Condensed quick-reference card for the GridPane research package |
| `gridpane-crosswalk.md` | Mapping of verified GridPane claims to canonical WordPress security docs |
| `gridpane-crosswalk-template.md` | Reusable template for future vendor-specific crosswalk work |
| `gridpane-gap-analysis.md` | Current comparison of GridPane material against the canonical doc set |
| `gridpane-security-prompt.md` | Reusable prompt for the `security-researcher` role |

### Editorial Process

| File | Purpose |
|---|---|
| `PROCESS-SUMMARY.md` | How the multi-model editorial process works in practice |
| `REVISION-LOG.md` | Chronological log of all revision rounds, changes, and commits |

### Methodology (`methodology/`)

| File | Purpose |
|---|---|
| `methodology/cross-document-audit-template.md` | Reusable template for future cross-document audits |
| `methodology/example-revision-plan.md` | Example of a synthesized revision plan from a multi-model review |
| `methodology/agent-review-board.md` | Pipeline vs. review board: comparing multi-agent documentation architectures |
| `methodology/single-model-multi-agent.md` | How Claude's internal Opus/Sonnet/Haiku tier architecture works |
| `methodology/multi-model-editorial-board.md` | Manual, semi-automated, and scripted approaches to orchestrating multi-model reviews |

### Contributions (`contributions/`)

| File | Purpose |
|---|---|
| `contributions/claude.md` | Summary of Claude's role, work performed, multi-model collaboration, and errors |
| `contributions/codex.md` | Summary of Codex's contributions |
| `contributions/gemini.md` | Summary of Gemini's contributions |

### Archives

| Directory | Purpose |
|---|---|
| `rounds/` | Per-date directories containing structured findings from each review phase |

### Helpers

| File | Purpose |
|---|---|
| `tools/review/bootstrap_round.sh` | Creates a new review-round scaffold from `docs/current-metrics.md` so volatile facts start from the canonical metrics source |

## How This Directory Is Used

After each editorial round, the working artifacts are archived here so that:

1. **Transparency** — Readers can see exactly what AI models recommended, what the human editor approved, and what was rejected.
2. **Reproducibility** — Future reviewers can re-run the same audit against updated documents.
3. **Accountability** — Every change links back to a specific finding, a verification step, and an editorial decision.

Closed synthesis artifacts should finish every merged finding with one of three statuses: `applied`, `rejected`, or `stale`.

Closed rounds are linted by `bash tools/ci/lint_review_archive.sh` so stale status language and unresolved archival states do not linger after closeout.

The documents under review live in their own repositories:

- [wordpress-runbook-template](https://github.com/dknauss/wordpress-runbook-template)
- [wp-security-benchmark](https://github.com/dknauss/wp-security-benchmark)
- [wp-security-hardening-guide](https://github.com/dknauss/wp-security-hardening-guide)
- [wp-security-style-guide](https://github.com/dknauss/wp-security-style-guide)

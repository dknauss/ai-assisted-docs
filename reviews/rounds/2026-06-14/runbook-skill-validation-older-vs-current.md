# Runbook Skill Validation — Older vs Current Canonical Runbook

Date: 2026-06-14
Method: Single-model skill validation using the installed `wordpress-runbook-ops` skill plus `wordpress-security-doc-editor` as the editorial audit lens
Status: Closed

## Purpose

Test the revised runbook skill against:

1. an older pre-hardening snapshot of the canonical WordPress Operations Runbook, and
2. the current canonical runbook,

to determine whether the skill usefully distinguishes legacy procedural weaknesses from later improvements.

## Inputs

### Skills tested

- `~/.codex/skills/wordpress-runbook-ops/SKILL.md`
- `~/.codex/skills/wordpress-security-doc-editor/SKILL.md`

### Canonical/source references loaded

- `~/.codex/skills/wordpress-runbook-ops/references/canonical-sources.md`
- `~/.codex/skills/wordpress-security-doc-editor/references/canonical-sources.md`
- `~/.codex/scenarios/wordpress-runbook-ops/procedure-schema-completeness.md`
- `~/.codex/scenarios/wordpress-runbook-ops/command-validity.md`
- `~/.codex/scenarios/wordpress-security-doc-editor/cross-document-alignment.md`

### Runbook targets

- **Older snapshot:** `/tmp/WP-Operations-Runbook-4a18785.md`
  - extracted from `wordpress-runbook-template` commit `4a18785`
  - line count: `3237`
- **Current canonical runbook:** `../wordpress-runbook-template/WP-Operations-Runbook.md`
  - audited in the patched working tree on branch `docs/runbook-skill-alignment`
  - pre-patch `HEAD` at audit start: `46ec929` (`docs: add badges and AI disclosure`)
  - line count after patch: `3394`

## Audit checks performed

1. **Strict procedure-schema signals**
   - `### Procedure Metadata`
   - `- Last Tested:`
   - `- Review Cadence:`
   - `- Last Drill Date:`
   - `### Commands`
   - `### Expected Output`
   - `### Rollback`
   - `### Verification`
   - `### Escalate If`
2. **WP-CLI command-path existence**
   - `wp help <command>` style path validation, matching the source-driven check used in `tools/ci/check_wpcli_source_validity.py`
3. **Known flag/usage regressions**
   - `--post_status=scheduled`
   - `wp term delete ... --default`
   - `--field=` on commands that require `--fields=`
   - related legacy WP-CLI usage drift
4. **Mutation-safety coverage**
   - destructive commands lacking nearby `# WARNING:` or `> **WARNING:**` markers
5. **Plugin-dependent annotation style**
   - current skill expectation: `# Plugin-dependent - uncomment the cache plugin(s) in use:`

## Summary Result

The revised runbook skill **successfully catches major weaknesses in the older snapshot** and **shows measurable improvement in the patched current canonical runbook**, but it also reveals that the current runbook still does **not** conform to the skill's stricter procedure-template format.

In other words:

- **command-path correctness** is strong in both versions,
- **editorial/safety structure** improved significantly,
- but **strict schema compliance remains incomplete even in the current document**.

## Before / After Delta

| Check | Older snapshot (`4a18785`) | Current canonical (patched working tree) | Delta |
|---|---:|---:|---:|
| WP-CLI command lines audited | 155 | 148 | -7 |
| Unique WP-CLI command paths | 65 | 64 | -1 |
| Invalid WP-CLI command paths | 0 | 0 | unchanged |
| `### Procedure Metadata` sections | 0 | 0 | unchanged |
| `### Commands` sections | 0 | 0 | unchanged |
| `### Expected Output` sections | 0 | 0 | unchanged |
| `### Rollback` sections | 0 | 0 | unchanged |
| `### Verification` sections | 0 | 0 | unchanged |
| `### Escalate If` sections | 0 | 0 | unchanged |
| `Last Tested` metadata lines | 0 | 0 | unchanged |
| `Review Cadence` metadata lines | 0 | 0 | unchanged |
| `Last Drill Date` metadata lines | 0 | 0 | unchanged |
| Destructive commands missing nearby warning markers | 52 | 10 | improved by 42 |
| `# WARNING:` comment markers | 1 | 35 | improved by 34 |
| `> **WARNING:**` blockquote warnings | 14 | 19 | improved by 5 |
| Known flag/usage regressions found | 5 | 0 | improved by 5 |
| Exact cache-plugin annotation string (`-`) | 0 | 6 | improved by 6 |
| Cache-plugin annotation with em dash (`—`) | 6 | 0 | improved by 6 |

## Verified Findings

| Document | Location | Finding | Severity | Recommendation | Verification | Status |
|---|---|---|---|---|---|---|
| Older snapshot | global | The old runbook does not use the skill's required procedural schema headings or metadata fields. | High | Treat the old runbook as pre-schema legacy content rather than a valid example of current runbook structure. | Search for `### Procedure Metadata`, `### Commands`, `### Verification`, `### Rollback`, `### Escalate If`. | Verified |
| Older snapshot | global | Command-path existence is mostly sound: the old runbook is not dominated by fabricated WP-CLI subcommands. | Medium | Preserve this distinction in future audits: command-path existence alone is not enough. | `wp help <command>` path audit found `0` invalid command paths across `155` command lines. | Verified |
| Older snapshot | lines `1868`, `1872`, `1909`, `2167`, `2176` | The older runbook contains known legacy WP-CLI flag/usage regressions (`--post_status=scheduled`, `wp term delete ... --default=1`, singular `--field=` usage). | High | Keep these patterns in the regression watchlist and treat them as true positives for the skill. | Exact line scan against the extracted snapshot. | Verified |
| Older snapshot | 52 destructive-command locations | Mutation safety is substantially weaker in the old snapshot. | High | Use the newer runbook as the minimum safety baseline; require warning coverage or explicit rationale. | Count destructive commands without a warning marker in the preceding window. | Verified |
| Current canonical | global | The current runbook still does not match the skill's strict procedure-schema headings/metadata model, despite major safety improvements. | High | Decide whether to (a) refactor the canonical runbook toward the skill's full template, or (b) relax the skill so it better matches the canonical document architecture. | Same structural heading/metadata scan as above returns zero required schema headings. | Verified |
| Current canonical | global | The residual mutation-safety gap dropped from 29 to 10 heuristic hits after the patch. Most remaining hits are read-only `wp db query` checks, a dry-run `wp search-replace`, and one already-warning-adjacent `wp plugin deactivate --all` case that the narrow scan window still counts. | Medium | Triage the remaining 10 cases into: benign read-only checks, widen the audit heuristic, or add explicit read-only labels where helpful. | Same warning-window scan used for the older snapshot. | Verified |
| Current canonical | global | The current runbook no longer contains the singular `--field=` regressions or the em-dash cache-plugin annotation variant flagged in the first pass. | Low | Keep these exact strings in regression coverage so they stay fixed. | Post-patch line scan and regex count show `0` residual matches for those patterns. | Verified |

## Interpretation

### What the test proves

The runbook skill is useful as an **editorial review tool** because it:

- distinguishes **real command-path problems** from **editorial/safety problems**
- catches known WP-CLI usage regressions in the older runbook
- surfaces a measurable improvement in warning coverage and operational caution
- correctly identifies that the current canonical runbook is **better**, but still **not fully aligned** with the stricter skill template

### What the test does not prove

This validation does **not** prove that:

- every remaining WP-CLI flag in the current runbook is wrong
- every destructive command without a nearby warning must necessarily gain one
- the current canonical runbook should be rewritten wholesale into the stricter skill template without editorial review

Some findings are best understood as a **fit gap between the skill and the canonical document architecture**, not just a document defect.

## Recommendations

1. **Keep the revised runbook skill.** It clearly improves detection of legacy runbook weaknesses.
2. **Keep the current patch set.** It materially improved the canonical runbook against the skill's own audit lens without forcing a wholesale rewrite.
3. **Do a fit-alignment pass** between the skill and the canonical runbook:
   - either refactor the runbook closer to the skill schema, or
   - relax the skill where the canonical document structure is intentionally broader.
4. **Promote the regression cases to reusable tests** if not already covered:
   - `--post_status=scheduled`
   - `wp term delete ... --default`
   - singular `--field=` patterns in audited command contexts
5. **Triage the remaining 10 current warning gaps** rather than assuming they are all equally severe.
6. **Decide whether read-only `wp db query` checks should be explicitly labeled** so the skill and heuristic can distinguish them from mutating SQL workflows.

## Final Conclusion

This was a **successful skill validation**.

The new `wordpress-runbook-ops` skill does what it should against older WordPress runbook material: it catches structural looseness, weaker mutation safety, and known WP-CLI usage drift. Against the patched current canonical runbook, it shows strong improvement on warning coverage and residual WP-CLI usage issues while still revealing one important unresolved issue: the skill's preferred procedure-template structure is stricter than the structure used by the current canonical runbook itself.

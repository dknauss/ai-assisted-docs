# Editorial Process Retrospective — 2026-03-15

This memo records what the March 2026 editorial rounds and follow-up implementation work showed in practice, especially after the verified synthesis fixes were applied to the canonical repos and regenerated through the shared DOCX-driven build pipeline.

## Current State

- The canonical document set is materially stronger than it was at the start of the March 2026 review cycle.
- The highest-value confirmed findings from the 2026-03-14 multi-model round were applied to the Benchmark, Hardening Guide, Runbook, and Style Guide.
- The regenerated `PDF` and `EPUB` outputs now reflect those corrections, not just the source Markdown.
- The most important remaining gap exposed by this round was process-level: a shared reusable workflow change was pushed without a self-test in `ai-assisted-docs`, which temporarily broke remote rebuilds in all four downstream repos.

## What Worked

### 1. Multi-model review found real issues that mattered

The three-model review surfaced a meaningful set of technical and cross-document problems:

- invalid `wp user update --user_login`
- wrong `--post_status=scheduled` usage
- incorrect password-length framing against NIST SP 800-63B Rev. 4
- stale or invalid runbook configuration examples
- incorrect Style Guide checksum command names

The strongest benefit was not simple vote-counting. It was convergence plus disagreement handling. The models did not agree on everything, and that was useful. The disagreement forced explicit verification and prevented bad recommendations from being accepted just because one model sounded confident.

### 2. Single-model role/skill-based work is better for implementation

Once the findings were approved, the role/skill-based workflow was the more effective execution model:

- it kept edits aligned with document purpose and audience
- it made the authority hierarchy operational instead of aspirational
- it supported deterministic follow-through across canonical repos, changelogs, metrics, rebuilds, and review artifacts

For implementation, this model was faster and more coherent than trying to keep re-consulting multiple external models.

### 3. Metrics and rebuild validation improved trust

The combination of:

- per-repo `verify-metrics.sh`
- cross-repo metrics sync validation
- successful downstream rebuilds
- final PDF/EPUB spot checks

gave this project a stronger evidentiary base than “the Markdown looks right.” That is a significant quality gain.

## What Did Not Work Well

### 1. Shared workflow changes lacked a proving ground

This was the clearest process failure in the round. The reusable docs-generation workflow in `ai-assisted-docs` had:

- a YAML parsing defect
- then a shell-level heredoc defect

Both were only discovered when downstream repos tried to dispatch rebuilds remotely. The failure mode was cross-repo and immediate.

### 2. Review artifacts drifted behind reality

Some review/process files remained stale after the round moved forward:

- round status text still implied work was pending after the round was complete
- execution guidance still carried stale line counts
- synthesis status lagged behind actual applied/rejected outcomes

This weakens handoff quality and makes the archive less trustworthy than the canonical repos.

### 3. Models still spent time on mechanical checks

Too much model effort was used for things that should be caught automatically:

- WP-CLI command existence
- glossary coverage drift
- metrics mismatches
- workflow breakage
- generated-output regressions

Those checks are better handled by scripts and CI, leaving models to focus on ambiguity, cross-document reasoning, and source interpretation.

## Are Both Approaches Necessary?

Not for every round.

### Multi-model review

Best use:

- major revision rounds
- pre-release or high-confidence audit passes
- situations where unknown unknowns are likely
- cases where independent disagreement is itself useful evidence

Weaknesses:

- slower
- more expensive in editor attention
- more synthesis overhead
- easier for archives to go stale if closure discipline is weak

### Single-model, role/skill-based workflow

Best use:

- routine maintenance
- implementing already-approved findings
- deterministic follow-through across repos
- repeated checks against repo-specific rules and structure

Weaknesses:

- less independence
- less likely to surface novel issues outside its current framing
- more vulnerable to blind spots if used alone as the only audit method

## Recommendation

Use a tiered operating model:

1. **Default mode:** single-model, role/skill-based editorial workflow plus automated validators.
2. **Escalation mode:** multi-model review for periodic audit rounds, major document revisions, or before declaring a release-quality milestone.
3. **Closure mode:** synthesis must end with explicit states for every finding: `applied`, `rejected`, or `stale`.

This is more sustainable than treating both methods as mandatory for every change.

## Process Improvements To Prioritize

1. Add a reusable workflow self-test in `ai-assisted-docs`.
   - Run `actionlint`.
   - Add a fixture caller workflow that exercises the shared docs-generation workflow against a tiny sample Markdown file.
   - Require that to pass before downstream repos rely on a changed reusable workflow.

2. Move more review work into automation before model review.
   - WP-CLI syntax validation
   - glossary coverage drift checks
   - cross-repo metrics drift validation
   - workflow health checks
   - generated-output smoke checks

3. Make review artifacts stateful and current.
   - Every round directory should end with a completed status summary.
   - Synthesis files should record `applied`, `rejected`, or `stale` outcomes directly.
   - “Needs verification” should be a temporary working state, not an archival end state.
   - Process docs should pull volatile counts and project status from `docs/current-metrics.md`, not hard-code them.

4. Keep generated-output review in the definition of done.
   - The DOCX intermediary and final PDF/EPUB outputs should be checked for representative changed content after major editorial rounds.

## Confidence In Current Canonical Texts

Confidence is high in the areas explicitly audited and revalidated in this round:

- source-grounded technical corrections
- WP-CLI command fixes
- cross-document consistency for the corrected controls
- glossary command naming
- propagation of corrected content into generated `PDF` and `EPUB` outputs

Confidence is medium-high overall, not absolute. The remaining residual risk is concentrated in environment-specific operational advice and anything that would require live WordPress/runtime execution rather than source-and-doc verification.

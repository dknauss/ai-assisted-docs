GridPane Research Artifacts and Planning Cleanup

Purpose

- Add a source-grounded set of internal GridPane research artifacts for editorial use.
- Keep a clear boundary between this repo's review artifacts and the canonical WordPress security docs maintained in the sibling repositories.
- Repair the incomplete GSD planning drop so future work can be tracked coherently.

What changed

- Added or rebuilt the GridPane research artifacts under `wp-security-doc-review/`:
  - `gridpane-security-brief.md`
  - `gridpane-briefing-card.md`
  - `gridpane-crosswalk.md`
  - `gridpane-crosswalk-template.md`
  - `gridpane-gap-analysis.md`
  - `gridpane-security-prompt.md`
- Added a reusable `security-researcher` skill description for vendor-specific WordPress security research.
- Updated AGENTS and README metadata so the role, skill, and repo scope agree.
- Replaced the GP validation script with a portable check that runs on the default macOS Bash shipped with Git.
- Reworked the `.planning/` phase files so they point at real artifact and source-doc targets instead of archived review snapshots or nonexistent files.
- Initialized the missing `.planning` scaffold required by the GSD workflow.

Review focus

- Confirm that every substantive GridPane claim is backed by an exact public URL.
- Confirm that Fortress remains explicitly vendor-specific and proprietary in every artifact.
- Confirm that any proposed editorial follow-up points at the canonical source docs, not `wp-security-doc-review/rounds/...`.
- Run `bash tools/ci/validate_gp_alignment.sh` and verify it passes locally.

Important scope note

- No canonical WordPress security documents are changed in this repository. This PR only updates research, planning, and governance artifacts that inform later human-approved work in the source repos.

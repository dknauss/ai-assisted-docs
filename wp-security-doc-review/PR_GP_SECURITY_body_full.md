GridPane GP Security Research: Artifacts and Crosswalk — PR Description

Purpose
- Introduce a suite of GridPane security research artifacts to enable cross-document alignment between GridPane's security stance and our WordPress security docs. The artifacts include:
  - A formal GridPane GP Security Brief
  - A ready-to-run SecurityResearcher prompt
  - A compact briefing card for editors on-hand
  - A crosswalk mapping GP patterns to our four WP security documents
  - An updated, portable SecurityResearcher skill descriptor (renamed to be GP-agnostic)

What changed
- Added to wp-security-doc-review:
  - gridpane-security-brief.md: Formal GP security brief (GP material trial)
  - gridpane-security-prompt.md: Ready-to-use prompt for SecurityResearcher
  - gridpane-briefing-card.md: Compact on-hand GP briefing card
  - gridpane-crosswalk.md: Crosswalk linking GP patterns to Benchmark/Hardening/Runbook/Style Guide
- Updated AGENTS.md to introduce @SecurityResearcher role (portable, GP-agnostic)
- Added portable security-researcher SKILL under wp-docs-skills/security-researcher/SKILL.md
- Branch feat/gridpane-security-researcher-artifacts already created and pushed; PR references these changes

How to review
- Inspect each new artifact for editorial clarity, alignment with our four WP security documents, and clear labeling of Fortress as vendor-specific.
- Verify the crosswalk links GP topics to the appropriate sections in Benchmark, Hardening Guide, Runbook, and Style Guide.
- Validate that the SecurityResearcher role and SKILL are portable to other contexts beyond GridPane.

Rationale
- Establishes a repeatable, auditable process for incorporating GridPane security perspectives into our WordPress security governance, while preserving cross-document symmetry and editorial integrity.

References (GP sources)
- GridPane Knowledge Base: https://gridpane.com/kb/
- Fortress: https://gridpane.com/fortress/
- Security Strategies and Tools: https://gridpane.com/knowledgebase/security-strategies-and-tools/

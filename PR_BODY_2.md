Summary
- Adds CHANGELOG.md files to four security repositories to record GP alignment work and governance; establishes baseline for future documentation hygiene.

Rationale
- Documentation-only changes to governance; improves traceability, onboarding, and oversight.

What changed
- New files:
  - wp-security-benchmark/CHANGELOG.md
  - wp-security-hardening-guide/CHANGELOG.md
  - wordpress-runbook-template/CHANGELOG.md
  - wp-security-style-guide/CHANGELOG.md
- Added Unreleased and 0.1.0 sections in each changelog.
- Added governance scaffolding for GP alignment; ensures changes are auditable.
- Added agent scaffolding for Security Researcher:
  - wp-docs-skills/security-researcher/agents/claude.yaml
  - wp-docs-skills/security-researcher/agents/openai.yaml
  - wp-docs-skills/security-researcher/references/canonical-sources.md

Open questions
- Do you want per-repo versioned changelog entries next (0.1.1, 0.2.0) or keep single Unreleased?
- Should we standardize a template for future changelog entries?

How to verify locally
- Inspect the four CHANGELOG.md files.
- Check the PR diff on GitHub.

Notes
- This PR is a governance change for GP alignment and does not modify canonical content.

References
- This PR: https://github.com/dknauss/ai-assisted-docs/pull/2

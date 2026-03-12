# Change Log
All notable changes to this project will be documented in this file.

Unreleased
- LLM lies logs: Created `docs/llm-lies-log.md` in all 4 downstream repos (Benchmark: 3 entries, Style Guide: 2, Runbook: 2, Hardening Guide: 0). Documents all known LLM-generated confabulations with root cause analysis and prevention measures.
- CI validators: Codex added `.github/workflows/validate-metrics.yml` and `.github/scripts/verify-metrics.sh` to all 4 downstream repos. Runs every verification command from `current-metrics.md` and compares actual vs. expected values on push and PR.
- Metrics fix (Benchmark, Codex): Code fence total corrected from 248 to 250 (2 raw-attribute fences `{=html}` were omitted). Balance check updated: 34 + 2 + 214 = 250.
- Metrics fix (Runbook, Codex): Destructive commands grep regex had escaped pipes (`\|`) in Markdown backtick context; corrected to unescaped `|` for grep ERE.
- Metrics fix (Benchmark): Verification commands for controls, Audit, and Remediation counts returned 0 instead of 50. Controls use H4 (`####`), not H3 (`###`); Audit/Remediation use bold labels (`**Audit:**`), not headings (`#### Audit`). Found by Codex audit, severity High.
- Metrics fix (Style Guide): Glossary term count pattern `^\*\*[A-Z]` excluded entries starting with non-letter characters (e.g., "2FA / MFA"), returning 128 instead of 137. Changed to `^\*\*`. Found by Codex audit, severity Medium.
- Cross-repo metrics: Added `CHANGELOG.md` and `docs/current-metrics.md` to all 4 downstream repos (Benchmark, Hardening Guide, Runbook, Style Guide). Added cross-repo metrics table to `docs/current-metrics.md`. Added metrics verification and changelog steps to AGENTS.md workflows (sections 5.1 and 5.2).
- Behavioral scenarios: First BDD cycle test run against `wordpress-runbook-ops` (domain migration procedure). 10/11 scenarios passed; 1 failure caught a missing destructive-command warning; 1 scenario coverage gap identified. Test report: `scenarios/test-runs/2026-03-11-runbook-ops-domain-migration.md`.
- Behavioral scenarios: 14 Given/When/Then scenario files added across 4 directories (`security-researcher/`, `wordpress-runbook-ops/`, `wordpress-security-doc-editor/`, `cross-skill/`). All skill files and AGENTS.md updated to reference scenarios as acceptance criteria.
- Veloria MCP server references added to all three custom skills.
- Facts registry (`docs/current-metrics.md`) created with scenario file counts and cross-links.
- Phase 2 planning groundwork: Phase 2 planning scaffold created; Phase 2 issues opened (GP alignment governance) and PRs prepared on Phase 2 plan scaffolding.
- Phase 1 recap: GridPane alignment completed; artifacts migrated to canonical repos; governance changes implemented; Phase 2 planning scaffolding added.

0.1.0 - 2026-03-06
- Initial project scaffold and governance groundwork for AI-assisted docs.

# Architecture

**Analysis Date:** 2026-03-14

## Pattern Overview

**Overall:** Multi-agent editorial coordination system for AI-assisted technical documentation maintenance

**Key Characteristics:**
- Decentralized document repositories with centralized planning and skill coordination
- Authority hierarchy-driven decision making for editorial conflicts
- Behavioral scenario specifications for acceptance testing
- Source-grounded research with vendor/editorial separation
- Human-in-the-loop approval gates for all changes

## Layers

**Planning & Coordination:**
- Purpose: Orchestrate multi-agent workflows, track project phases, maintain state
- Location: `.planning/` directory
- Contains: Phase definitions, roadmap, configuration, state tracking
- Depends on: Project metadata, workflow configuration
- Used by: All agents and editorial reviewers

**Agent Roles & Skills:**
- Purpose: Define LLM-executable constraints, done criteria, and output templates
- Location: `wp-docs-skills/` subdirectories + `AGENTS.md`
- Contains: Machine-readable SKILL.md files, platform-specific config stubs, authority rules
- Depends on: Agent role definitions in AGENTS.md, external authority sources
- Used by: LLM-based editorial agents, human reviewers

**Behavioral Specifications:**
- Purpose: Operationalize skill constraints into testable Given/When/Then scenarios
- Location: `scenarios/` directory tree
- Contains: BDD scenario files, test run results
- Depends on: SKILL.md constraints and done criteria
- Used by: Editorial review process, scenario-driven testing

**Validation & Tooling:**
- Purpose: Verify cross-document consistency, metrics correctness, build outputs
- Location: `tools/` directory
- Contains: Shell scripts for validation, metrics verification, doc rebuilds
- Depends on: Document metrics, GitHub CLI, downstream repos
- Used by: CI/CD pipelines, editorial verification workflows

**Research Artifacts:**
- Purpose: Source-grounded vendor analysis, editorial implications, follow-up tracking
- Location: `wp-security-doc-review/` directory tree
- Contains: Research briefs, crosswalks, gap analyses
- Depends on: Vendor documentation, authority hierarchy, canonical docs
- Used by: Editorial decision-making, future planning phases

**Canonical Document Series:**
- Purpose: Published security guidance for WordPress ecosystem
- Location: Four sibling repositories (external, not co-located)
- Contains: Markdown source, metrics, changelogs
- Depends on: AGENTS.md roles, skills, scenarios, authority hierarchy
- Used by: End users, operators, architects, auditors

## Data Flow

**Editorial Change Workflow:**

1. Human editor defines scope and assigns to appropriate agent role
2. Agent reads SKILL.md for constraints, AGENTS.md for authority hierarchy
3. Agent drafts content in target document repository
4. Behavioral scenarios are checked against draft
5. @StyleGuideAgent reviews for voice/tone consistency
6. @AuditAgent checks cross-document alignment
7. Human editor approves, modifies, or rejects
8. Metrics verification script runs in target repo
9. CHANGELOG.md updated
10. Changes committed and pushed

**Cross-Document Revision Round:**

1. Three independent models review all four documents with identical instructions
2. @SynthesisAgent merges review findings into prioritized plan
3. Human editor reviews and approves plan
4. Document agents implement approved changes
5. @AuditAgent runs post-implementation consistency check
6. @StyleGuideAgent verifies glossary coverage
7. Metrics verification script runs in each modified repo
8. CHANGELOG entries updated across all affected repos
9. Human editor gives final approval, changes committed and pushed

**Vendor Research Workflow:**

1. Human editor selects vendor subject and defines scope
2. @SecurityResearcher reads `security-researcher` SKILL.md
3. Researcher conducts analysis and produces structured brief
4. Brief distinguishes verified vendor claims from editorial implications
5. Editorial implications point back to canonical document repositories
6. Artifacts stored in `wp-security-doc-review/` with clear scope markers
7. Human editor reviews and archives

**State Management:**
- Authority hierarchy enforced through AGENTS.md rules, not through code
- Phase progress tracked in `.planning/STATE.md`
- Document metrics tracked in both upstream repo and canonical downstream repos
- Git history is authoritative change log (CHANGELOG.md files)
- No database; all state is versioned in repository files

## Key Abstractions

**Agent Role:**
- Purpose: Define editorial responsibility and constraints for an LLM
- Examples: `@BenchmarkAgent`, `@HardeningGuideAgent`, `@RunbookAgent`, `@StyleGuideAgent`, `@AuditAgent`, `@SynthesisAgent`, `@SecurityResearcher`
- Pattern: Each role has dedicated SKILL.md, authority rules in AGENTS.md section 4, and corresponding skill bundle in `wp-docs-skills/`
- Location: Defined in `/AGENTS.md`, implemented in `wp-docs-skills/`

**Skill:**
- Purpose: Machine-readable constraints and done criteria for producing work matching editorial standards
- Examples: `wordpress-security-doc-editor`, `wordpress-runbook-ops`, `security-researcher`
- Pattern: SKILL.md file contains constraints, output templates, references, and acceptance criteria; platform-specific config stubs in `agents/` subdirectory
- Location: `wp-docs-skills/<skill-name>/SKILL.md`

**Authority Hierarchy:**
- Purpose: Precedence rules for resolving conflicts between sources
- Pattern: 1. WordPress Developer Docs, 2. WordPress code/Code Reference, 3. WP-CLI docs, 4. External standards (OWASP, CIS, NIST, MDN)
- Location: Defined in `AGENTS.md` section 3, referenced in all SKILL.md files
- Used by: All agents when verifying claims or reconciling disagreements

**Behavioral Scenario:**
- Purpose: Operationalize skill done criteria into testable Given/When/Then specifications
- Examples: "Destructive commands have preceding backup steps", "Rollback contains concrete commands"
- Pattern: One file per behavioral concern; multiple scenarios per file; concrete pass/fail examples
- Location: `scenarios/<skill-name>/*.md`

**Metrics:**
- Purpose: Track project counts to prevent stale planning facts
- Examples: Document line counts, section counts, code fences, WP-CLI commands, glossary terms, destructive commands
- Pattern: Single source of truth in this repo at `docs/current-metrics.md`, mirrored in each downstream repo's `docs/current-metrics.md`
- Location: `docs/current-metrics.md` (upstream), cross-repo sync via `tools/ci/validate_cross_repo_metrics.sh`

## Entry Points

**Human Editorial Decision:**
- Location: `AGENTS.md` (section 5 workflows)
- Triggers: Human editor defines scope, selects agent role, approves/rejects changes
- Responsibilities: Scope definition, final approval authority, conflict resolution

**Drafting Workflow Entry:**
- Location: `AGENTS.md` section 5.1 (Drafting New Content)
- Triggers: Human editor assigns scope to specific agent
- Responsibilities: Read SKILL.md constraints, follow authority hierarchy, produce draft in target repo

**Cross-Document Revision Round Entry:**
- Location: `AGENTS.md` section 5.2 (Cross-Document Revision Round)
- Triggers: Human editor initiates multi-model review
- Responsibilities: Three models review independently, @SynthesisAgent merges findings, human editor approves merged plan

**Vendor Research Entry:**
- Location: `security-researcher` SKILL.md
- Triggers: Human editor selects vendor subject
- Responsibilities: Produce structured brief with vendor claims, limitations, editorial implications

**Metrics Verification Entry:**
- Location: `docs/current-metrics.md` (Update Procedure section)
- Triggers: After editorial changes complete
- Responsibilities: Run repo-specific metrics script, update this file and CHANGELOG.md

## Error Handling

**Strategy:** Authority hierarchy resolves conflicts; behavioral scenarios catch deviations; human editor makes final decisions

**Patterns:**
- Overclaimed findings flagged by @AuditAgent and @SynthesisAgent for investigation before implementation
- Glossary consistency enforced by @StyleGuideAgent checking style guide against other documents
- Cross-reference accuracy verified manually before publication
- Code fence integrity checked via fence-count parity (opening + closing fence counts)
- WP-CLI command validity verified against `wp help <command>` documentation

## Cross-Cutting Concerns

**Logging:**
- Change rationale recorded in CHANGELOG.md entries and git commit messages
- Research findings documented in `wp-security-doc-review/` artifacts
- Phase progress tracked in `.planning/STATE.md` and `.planning/ROADMAP.md`

**Validation:**
- Behavioral scenarios operationalize acceptance criteria
- @AuditAgent validates findings against authority hierarchy sources
- Metrics verification ensures count consistency across all four documents
- Code fence parity checks prevent corrupted fenced blocks cascading through documents

**Authentication & Authority:**
- Authority hierarchy (AGENTS.md section 3) applies to all agents regardless of LLM provider
- Human editor acts as final authority on all changes
- No change is applied without explicit human approval

**Documentation:**
- AGENTS.md defines roles, constraints, and workflow
- SKILL.md files define done criteria and output templates
- Behavioral scenarios define testable expectations
- README.md provides project overview and links to authoritative sources

---

*Architecture analysis: 2026-03-14*
